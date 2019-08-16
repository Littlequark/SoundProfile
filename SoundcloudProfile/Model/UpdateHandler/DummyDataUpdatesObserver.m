//
// DummyDataUpdatesObserver.m
//

#import "DummyDataUpdatesObserver.h"
#import "FetchedResultsController.h"

@implementation DummyDataUpdatesObserver

+ (instancetype)updatesObserverWithFetchedResultsController:(FetchedResultsController *)fetchedResultsController {
    DummyDataUpdatesObserver *observer = [[self alloc] initWithFetchedResultsController:fetchedResultsController];
    return observer;
}

@end
