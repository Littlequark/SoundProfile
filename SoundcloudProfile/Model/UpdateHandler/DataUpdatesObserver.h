//
//  DataUpdatesObserver.h
//

#import <Foundation/Foundation.h>

@protocol DataUpdatesHandlerProtocol;

@protocol DataUpdatesObserver <NSObject>

/**
 DataUpdatesObserver uses objectsPool as cache for observing objects. This property must be thread-safe because private implementation of
 objecstPool usually represented by mutable collection working on background queue.
 */
@property (copy) NSSet *objectsPool;

- (instancetype)initWithFetchedResultsController:(id<DataUpdatesHandlerProtocol>)fetchedResultsController;

@end
