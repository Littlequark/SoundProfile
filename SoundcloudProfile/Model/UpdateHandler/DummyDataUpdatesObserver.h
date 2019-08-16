//
// DummyDataUpdatesObserver.h
//

#import <Foundation/Foundation.h>
#import "DataUpdatesPlainObserver.h"

@class FetchedResultsController;

/// This "update observer" does not observe changes automatically. You should manually add changes instead.
@interface DummyDataUpdatesObserver : DataUpdatesPlainObserver

+ (instancetype)updatesObserverWithFetchedResultsController:(FetchedResultsController *)fetchedResultsController;

@end
