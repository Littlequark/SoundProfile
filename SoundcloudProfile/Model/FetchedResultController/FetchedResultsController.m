//
//  FetchedResultsController.m
//

#import "FetchedResultsController.h"
#import "FetchedResultsControllerModel.h"
#import "FetchedResultsControllerModel+ModelState.h"
#import "FetchedResultsControllerDelegateEvent.h"
#import "NSIndexPath+DataSource.h"
#import "Scope.h"

@interface FetchedResultsController () {
    dispatch_queue_t _backgroundQueue;
}

@property (nonatomic, strong) FetchedResultsControllerModel *mainThreadDataModel;
@property (nonatomic, strong) FetchedResultsControllerModel *backgroundThreadDataModel;

@end


@implementation FetchedResultsController

- (instancetype)init {
    return [self initWithSectionNameKeyPath:nil];
}

- (instancetype)initWithSectionNameKeyPath:(NSString *)sectionNameKeyPath {
    self = [super init];
    if (self) {
        _backgroundQueue = dispatch_queue_create("com.brief.frc.background-queue", DISPATCH_QUEUE_SERIAL);
        _mainThreadDataModel = [[FetchedResultsControllerModel alloc] init];
        _backgroundThreadDataModel = [[FetchedResultsControllerModel alloc] init];
        self.sectionNameKeyPath = sectionNameKeyPath;
    }
    return self;
}

#pragma mark - Public

- (void)setObjectsPredicate:(NSPredicate *)objectsPredicate {
    _objectsPredicate = objectsPredicate;
    self.mainThreadDataModel.objectsPredicate = objectsPredicate;
    self.backgroundThreadDataModel.objectsPredicate = objectsPredicate;
}

- (void)setObjectsSortDescriptor:(NSSortDescriptor *)objectsSortDescriptor {
    _objectsSortDescriptor = objectsSortDescriptor;
    self.mainThreadDataModel.objectsSortDescriptor = objectsSortDescriptor;
    self.backgroundThreadDataModel.objectsSortDescriptor = objectsSortDescriptor;
}

- (void)setSectionsSortDescriptor:(NSSortDescriptor *)sectionsSortDescriptor {
    _sectionsSortDescriptor = sectionsSortDescriptor;
    self.mainThreadDataModel.sectionSortDescriptor = sectionsSortDescriptor;
    self.backgroundThreadDataModel.sectionSortDescriptor = sectionsSortDescriptor;
}

- (void)setObjects:(NSSet *)objects completion:(dispatch_block_t)completion {
    @weakify(self);
    [self dispatchBlockOnBackgroundQueue:^{
        @strongify(self);
        [self _setObjects:objects completion:completion];
    }];
}

- (void)addObjects:(NSSet *)objects completion:(dispatch_block_t)completion {
    @weakify(self);
    [self dispatchBlockOnBackgroundQueue:^{
        @strongify(self);
        [self _addObjects:objects completion:completion];
    }];
}

- (void)setSectionNameKeyPath:(NSString *)sectionNameKeyPath {
    self.mainThreadDataModel.sectionNameKeyPath = sectionNameKeyPath;
    self.backgroundThreadDataModel.sectionNameKeyPath = sectionNameKeyPath;
}

- (NSString *)sectionNameKeyPath {
    ///AssertMainThread();
    ///Assert[self.mainThreadDataModel.sectionNameKeyPath isEqual:self.backgroundThreadDataModel.sectionNameKeyPath], @"Both sectionNameKeyPath should be the same");
    return self.mainThreadDataModel.sectionNameKeyPath;
}

- (void)handleInsertedObjects:(NSSet *)objects {
    @weakify(self);
    [self dispatchBlockOnBackgroundQueue:^{
        @strongify(self);
        [self _handleUpdatedObjects:objects];
    }];
}

- (void)handleDeletedObjects:(NSSet *)objects {
    @weakify(self);
    [self dispatchBlockOnBackgroundQueue:^{
        @strongify(self);
        [self _handleDeletedObjects:objects];
    }];
}

- (void)handleUpdatedObjects:(NSSet *)objects {
    @weakify(self);
    [self dispatchBlockOnBackgroundQueue:^{
        @strongify(self);
        [self _handleUpdatedObjects:objects];
    }];
}

- (NSUInteger)fetchedObjectsCount {
    NSUInteger count = 0;
    for (id<FetchedResultsSectionInfoProtocol>sectionInfo in self.sections) {
        count += sectionInfo.objects.count;
    }
    return count;
}

- (NSArray *)fetchedObjects {
    NSArray *sections = self.sections;
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    for (id<FetchedResultsSectionInfoProtocol>sectionInfo in sections) {
        [objects addObjectsFromArray:sectionInfo.objects];
    }
    return objects.copy;
}

- (NSArray<id<FetchedResultsSectionInfoProtocol>> *)sections {
    ///AssertMainThread();
    return self.mainThreadDataModel.sections;
}

- (NSArray *)sectionIndexTitles {
    if (self.sectionNameKeyPath.length == 0) {
        return nil;
    }
    
    NSArray<id<FetchedResultsSectionInfoProtocol>> *sections = self.sections;
    NSMutableArray<NSString *> *titles = [[NSMutableArray<NSString *> alloc] initWithCapacity:sections.count];
    for (id<FetchedResultsSectionInfoProtocol> section in sections) {
        ///Assertsection.indexTitle.length > 0, nil);
        [titles addObject:section.indexTitle];
    }
    return titles.copy;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    ///ParameterAssert(indexPath);
    ///AssertMainThread();
    
    id<FetchedResultsSectionInfoProtocol> sectionInfo = self.sections[indexPath.sp_section];
    id object = sectionInfo.objects[indexPath.sp_item];
    return object;
}

- (NSIndexPath *)indexPathForObject:(id)object {
    ///AssertMainThread();
    
    NSIndexPath *indexPath = nil;
    for (int section = (int)[self.sections count] - 1; section >= 0; --section) {
        id<FetchedResultsSectionInfoProtocol> sectionInfo = self.sections[section];
        NSUInteger row = [sectionInfo.objects indexOfObject:object];
        if (row != NSNotFound) {
            indexPath = [NSIndexPath sp_indexPathForItem:row inSection:section];
            break;
        }
    }
    return indexPath;
}

#pragma mark - Private

- (void)dispatchBlockOnBackgroundQueue:(dispatch_block_t)block {
    dispatch_async(_backgroundQueue, block);
}

- (void)dispatchBlockOnMainQueue:(dispatch_block_t)block {
    dispatch_async(dispatch_get_main_queue(), block);
}

- (void)_setObjects:(NSSet *)objects completion:(dispatch_block_t)completion {
    [self.backgroundThreadDataModel clear];
    [self _addObjects:objects completion:completion];
}

- (void)_addObjects:(NSSet *)objects completion:(void(^)(void))completion {
    [self.backgroundThreadDataModel removeObjectsAndReturnChanges:objects];
    [self.backgroundThreadDataModel insertObjectsAndReturnChanges:objects];
    
    FetchedResultsControllerModel *model = self.backgroundThreadDataModel.copy;
    
    @weakify(self);
    [self dispatchBlockOnMainQueue:^{
        @strongify(self);
        self.mainThreadDataModel = model;
        
        if (completion) {
            completion();
        }
    }];
}

- (void)_handleDeletedObjects:(NSSet *)objects {
    NSArray<FetchedResultsControllerModelChange *> *changes = [self.backgroundThreadDataModel removeObjectsAndReturnChanges:objects];
    NSArray<FetchedResultsControllerDelegateEvent *> *delegateEvents = [FetchedResultsControllerDelegateEvent delegateEventsFromChanges:changes
                                                                                                                          appliedToModelState:self.backgroundThreadDataModel];
    @weakify(self);
    [self dispatchBlockOnMainQueue:^{
        @strongify(self);
        [self performSecondStageUpdateModelWithChanges:changes delegateEvents:delegateEvents];
    }];
}

- (void)_handleUpdatedObjects:(NSSet *)objects {
    NSArray<FetchedResultsControllerModelChange *> *changes = [self.backgroundThreadDataModel updateOrMoveObjectsAndReturnChanges:objects];
    NSArray<FetchedResultsControllerDelegateEvent *> *delegateEvents = [FetchedResultsControllerDelegateEvent delegateEventsFromChanges:changes
                                                                                                                          appliedToModelState:self.backgroundThreadDataModel];
    @weakify(self);
    [self dispatchBlockOnMainQueue:^{
        @strongify(self);
        [self performSecondStageUpdateModelWithChanges:changes delegateEvents:delegateEvents];
    }];
}

- (void)performSecondStageUpdateModelWithChanges:(NSArray<FetchedResultsControllerModelChange *> *)changes
                                  delegateEvents:(NSArray<FetchedResultsControllerDelegateEvent *> *)delegateEvents {
    [FetchedResultsControllerDelegateEvent updateDelegateEvents:delegateEvents appliedFromModelState:self.mainThreadDataModel];
    [self updateMainThreadModelWithChanges:changes];
    [self notifyDelegateWithDelegateEvents:delegateEvents];
}

- (void)updateMainThreadModelWithChanges:(NSArray<FetchedResultsControllerModelChange *> *)changes {
    ///AssertMainThread();
    
    for (FetchedResultsControllerModelChange *change in changes) {
        [change applyOnModel:self.mainThreadDataModel];
    }
}

- (void)notifyDelegateWithDelegateEvents:(NSArray<FetchedResultsControllerDelegateEvent *> *)delegateEvents {
    ///AssertMainThread();
    
    if (!delegateEvents.count) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(sp_controllerWillChangeContent:)]) {
        [self.delegate sp_controllerWillChangeContent:self];
    }
    
    for (FetchedResultsControllerDelegateEvent *delegateEvent in delegateEvents) {
        [delegateEvent notifyFetchedResultsControllerDelegate:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(sp_controllerDidChangeContent:)]) {
        [self.delegate sp_controllerDidChangeContent:self];
    }
}

@end
