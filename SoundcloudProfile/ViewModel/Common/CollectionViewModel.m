//
//  CollectionViewModel.m
//

#import "CollectionViewModel.h"
#import "CollectionViewModelDelegate.h"
#import "DataSource.h"
#import "ViewModelFactoryProtocol.h"
#import "NSIndexPath+DataSource.h"
#import "SafeBlock.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewModel ()

@property (nonatomic, readwrite) NSMutableOrderedSet *selectedObjects;
@property (nonatomic) NSMutableDictionary<NSString *, NSString *> *modelToViewModel;
@property (nonatomic) NSUInteger numberOfItems;
@property (nonatomic, readwrite) NSUInteger numberOfSelectedObjects;

@end

@implementation CollectionViewModel

@synthesize delegate = _delegate;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _modelToViewModel = [[NSMutableDictionary alloc] init];
        _selectedObjects = [[NSMutableOrderedSet alloc] init];
    }
    return self;
}

#pragma mark - Setters & Getters

- (void)setDataSource:(DataSource *)dataSource {
    if (_dataSource != dataSource) {
        _dataSource.delegate = nil;
        _dataSource = dataSource;
        _dataSource.delegate = self;
    }
}

- (NSUInteger)numberOfItems {
    int numOfItems = 0;
    for (int i = 0; i < self.numberOfSections; i++) {
        numOfItems += [self numberOfObjectsInSection:i];
    }
    return numOfItems;
}

#pragma mark - Public methods

- (void)registerViewModelClass:(Class<ViewModelFactoryProtocol>)viewModelClass forModelClass:(Class)modelClass {
//    Assert[(id)viewModelClass respondsToSelector:@selector(viewModelWithModel:)],
//              @"Error! You are trying to register a viewModel class, which doesn't conform to ViewModelFactoryProtocol");
    [self.modelToViewModel setObject:NSStringFromClass(viewModelClass) forKey:NSStringFromClass(modelClass)];
}

- (void)registerViewModelsMap:(NSDictionary<NSString *, NSString *> *)viewModelsMap {
    self.modelToViewModel = [NSMutableDictionary dictionaryWithDictionary:viewModelsMap];
}

- (Class<ViewModelFactoryProtocol>)viewModelClassForModel:(NSObject *)model {
    Class class = model.class;
    Class viewModelClass = nil;
    do {
        NSString *key = NSStringFromClass(class);
        viewModelClass = NSClassFromString(self.modelToViewModel[key]);
        class = class.superclass;
    } while (viewModelClass == nil && class != Nil);
    return viewModelClass;
}

- (void)notifyDidReloadData {
    if ([self.delegate respondsToSelector:@selector(viewModelDidReloadData:)]) {
        [self.delegate viewModelDidReloadData:self];
    }
}

- (void)notifyDidRefreshItemAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if ([self.delegate respondsToSelector:@selector(viewModel:didRefreshItemsAtIndexPaths:)]) {
        [self.delegate viewModel:self didRefreshItemsAtIndexPaths:indexPaths];
    }
}

#pragma mark - CollectionViewModelProtocol

- (void)loadContent {
    
}

- (NSUInteger)numberOfSections {
    return [self.dataSource numberOfSections];
}

- (NSUInteger)numberOfObjectsInSection:(NSUInteger)section {
    return [self.dataSource numberOfItemsInSection:section];
}

- (id _Nullable)viewModelAtIndexPath:(NSIndexPath *)indexPath {
    id model = [self.dataSource itemAtIndexPath:indexPath];
    Class<ViewModelFactoryProtocol> viewModelClass = [self viewModelClassForModel:model];
    id viewModel = [viewModelClass viewModelWithModel:model];
    return viewModel;
}

#pragma mark - SelectableCollectionViewModelProtocol

- (BOOL)canSelectObjectAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)isAllObjectsSelected {
    BOOL result = [self.allObjects isSubsetOfOrderedSet:self.selectedObjects];
    return result;
}

- (BOOL)isAnyObjectSelected {
    return self.numberOfSelectedObjects > 0;
}

- (BOOL)isSelectedObjectAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.dataSource itemAtIndexPath:indexPath];
    BOOL selected = [self.selectedObjects containsObject:object];
    return selected;
}

- (void)selectObjectAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.dataSource itemAtIndexPath:indexPath];
    [self.selectedObjects addObject:object];
    self.numberOfSelectedObjects = self.selectedObjects.count;
    [self notifyDidRefreshItemAtIndexPaths:@[indexPath]];
}

- (void)deselectObjectAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.dataSource itemAtIndexPath:indexPath];
    [self.selectedObjects removeObject:object];
    self.numberOfSelectedObjects = self.selectedObjects.count;
    [self notifyDidRefreshItemAtIndexPaths:@[indexPath]];
}

- (void)selectAllObjects {
    self.selectedObjects = self.allObjects.mutableCopy;
    self.numberOfSelectedObjects = self.selectedObjects.count;
    [self notifyDidReloadData];
}

- (void)deselectAllObjects {
    [self.selectedObjects removeAllObjects];
    self.numberOfSelectedObjects = self.selectedObjects.count;
    [self notifyDidReloadData];
}

#pragma mark - Private methods

- (NSOrderedSet *)allObjects {
    // TODO: Improve this implementation
    NSMutableOrderedSet *objects = [[NSMutableOrderedSet alloc] init];
    for (int section = (int)self.dataSource.numberOfSections - 1; section >= 0; --section) {
        for (int item = (int)[self.dataSource numberOfItemsInSection:section] - 1; item >= 0; --item) {
            NSIndexPath *indexPath = [NSIndexPath sp_indexPathForItem:item inSection:section];
            id object = [self.dataSource itemAtIndexPath:indexPath];
            [objects addObject:object];
        }
    }
    return objects;
}

- (void)removeOutdatedSelectedObjects {
    NSIndexSet *indexSet = [self.selectedObjects indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [self.dataSource indexPathsForItem:obj].count == 0;
    }];
    [self.selectedObjects removeObjectsAtIndexes:indexSet];
    self.numberOfSelectedObjects = self.selectedObjects.count;
}

#pragma mark - DataSourceDelegate

- (void)dataSourceDidReloadData:(DataSource *)dataSource {
    [self removeOutdatedSelectedObjects];
    [self notifyDidReloadData];
}

- (void)dataSource:(DataSource *)dataSource didInsertSections:(NSIndexSet *)sections {
    if ([self.delegate respondsToSelector:@selector(viewModel:didInsertSections:)]) {
        [self.delegate viewModel:self didInsertSections:sections];
    }
}

- (void)dataSource:(DataSource *)dataSource didRemoveSections:(NSIndexSet *)sections {
    if ([self.delegate respondsToSelector:@selector(viewModel:didRemoveSections:)]) {
        [self.delegate viewModel:self didRemoveSections:sections];
    }
}

- (void)dataSource:(DataSource *)dataSource didRefreshSections:(NSIndexSet *)sections {
    if ([self.delegate respondsToSelector:@selector(viewModel:didRefreshSections:)]) {
        [self.delegate viewModel:self didRefreshSections:sections];
    }
}

- (void)dataSource:(DataSource *)dataSource didInsertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if ([self.delegate respondsToSelector:@selector(viewModel:didInsertItemsAtIndexPaths:)]) {
        [self.delegate viewModel:self didInsertItemsAtIndexPaths:indexPaths];
    }
}

- (void)dataSource:(DataSource *)dataSource didRemoveItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if ([self.delegate respondsToSelector:@selector(viewModel:didRemoveItemsAtIndexPaths:)]) {
        [self.delegate viewModel:self didRemoveItemsAtIndexPaths:indexPaths];
    }
}

- (void)dataSource:(DataSource *)dataSource didRefreshItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self notifyDidRefreshItemAtIndexPaths:indexPaths];
}

- (void)dataSource:(DataSource *)dataSource performBatchUpdate:(dispatch_block_t _Nullable)update complete:(dispatch_block_t _Nullable)complete {
    [self removeOutdatedSelectedObjects];
    if ([self.delegate respondsToSelector:@selector(viewModel:performBatchUpdate:completion:)]) {
        [self.delegate viewModel:self performBatchUpdate:update completion:complete];
    }
    else {
        safe_block_exec(complete);
    }
}

@end

NS_ASSUME_NONNULL_END
