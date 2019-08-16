//
//  DataUpdatesPlainObserver.h
//

#import "DataUpdatesObserver.h"

@class FetchedResultsController;

@interface DataUpdatesPlainObserver : NSObject <DataUpdatesObserver> {
@protected
    NSMutableSet *_objectsPool;
}

@property (nonatomic, copy) NSString *insertedObjectsNotificationName;
@property (nonatomic, copy) NSString *deletedObjectsNotificationName;
@property (nonatomic, copy) NSString *updatedObjectsNotificationName;
@property (nonatomic, copy) NSString *objectsKey;
@property (nonatomic, readonly) FetchedResultsController *fetchedResultsController;

- (instancetype)initWithFetchedResultsController:(FetchedResultsController *)fetchedResultsController NS_DESIGNATED_INITIALIZER;

- (void)subscribeForDataChangeNotifications;

- (void)addObjectsInPool:(NSSet *)objects;

- (void)removeObjectsFromPool:(NSSet *)objects;

- (void)updateObjectsInPool:(NSSet *)objects;

@end
