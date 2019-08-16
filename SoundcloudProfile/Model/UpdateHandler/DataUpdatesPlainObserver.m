//
//  DataUpdatesPlainObserver.m
//

#import "DataUpdatesPlainObserver.h"
#import "FetchedResultsController.h"
#import "Scope.h"

@interface DataUpdatesPlainObserver ()

@property (nonatomic) dispatch_queue_t objectsPoolQueue;
@property (nonatomic, readwrite) FetchedResultsController *fetchedResultsController;

@end

@implementation DataUpdatesPlainObserver

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    return [self initWithFetchedResultsController:nil];
}

- (instancetype)initWithFetchedResultsController:(FetchedResultsController *)fetchedResultsController {
    self = [super init];
    if (self) {
        _objectsPoolQueue = dispatch_queue_create("com.persTim.updates-plain-observer.objects-pool.queue", DISPATCH_QUEUE_SERIAL);
        _fetchedResultsController = fetchedResultsController;
    }
    return self;
}

- (void)setObjectsPool:(NSSet *)objectsPool {
    NSMutableSet *mutableObjectsPool = [[NSMutableSet alloc] initWithSet:objectsPool copyItems:YES];
    @weakify(self);
    dispatch_async(self.objectsPoolQueue, ^{
        @strongify(self);
        if (self) {
            self->_objectsPool = mutableObjectsPool;
        }
    });
}

- (NSSet *)objectsPool {
    __block NSSet *objects;
    dispatch_sync(self.objectsPoolQueue, ^{
        objects = [[NSSet alloc] initWithSet:self->_objectsPool copyItems:YES];
    });
    return objects;
}

#pragma mark - Private methods

- (void)subscribeForDataChangeNotifications {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(handleInsertedObjects:) name:self.insertedObjectsNotificationName object:nil];
    [notificationCenter addObserver:self selector:@selector(handleDeletedObjects:) name:self.deletedObjectsNotificationName object:nil];
    [notificationCenter addObserver:self selector:@selector(handleUpdatedObjects:) name:self.updatedObjectsNotificationName object:nil];
}

- (NSSet *)objectsSetFromUserInfo:(NSDictionary *)userInfo {
    NSArray *objects = userInfo[self.objectsKey];
    return [[NSSet alloc] initWithArray:[[NSArray alloc] initWithArray:objects copyItems:YES]];
}

- (void)addObjectsInPool:(NSSet *)objects {
    [_objectsPool unionSet:[[NSSet alloc] initWithSet:objects copyItems:YES]];
}

- (void)removeObjectsFromPool:(NSSet *)objects {
    [_objectsPool minusSet:objects];
}

- (void)updateObjectsInPool:(NSSet *)objects {
    [self removeObjectsFromPool:objects];
    [self addObjectsInPool:objects];
}

#pragma mark - Notifications handlers

- (void)handleInsertedObjects:(NSNotification *)notification {
    NSSet *objects = [self objectsSetFromUserInfo:notification.userInfo];
    if (objects.count) {
        @weakify(self);
        dispatch_async(self.objectsPoolQueue, ^{
            @strongify(self);
            [self addObjectsInPool:objects];
            [self.fetchedResultsController handleInsertedObjects:objects];
        });
    }
}

- (void)handleDeletedObjects:(NSNotification *)notification {
    NSSet *objects = [self objectsSetFromUserInfo:notification.userInfo];
    if (objects.count) {
        @weakify(self);
        dispatch_async(self.objectsPoolQueue, ^{
            @strongify(self);
            [self removeObjectsFromPool:objects];
            [self.fetchedResultsController handleDeletedObjects:objects];
        });
    }
}

- (void)handleUpdatedObjects:(NSNotification *)notification {
    NSSet *objects = [self objectsSetFromUserInfo:notification.userInfo];
    if (objects.count) {
        @weakify(self);
        dispatch_async(self.objectsPoolQueue, ^{
            @strongify(self);
            [self updateObjectsInPool:objects];
            [self.fetchedResultsController handleUpdatedObjects:objects];
        });
    }
}

@end
