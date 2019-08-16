//
//  FetchedResultsControllerDelegateEvent.h
//

#import <Foundation/Foundation.h>
#import "FetchedResultsControllerDelegate.h"

@class FetchedResultsControllerModelChange;
@class FetchedResultsControllerModel;
@protocol FetchedResultsControllerModelState;

@interface FetchedResultsControllerDelegateEvent : NSObject

@property (nonatomic) FetchedResultsChangeType changeType;

+ (NSArray<FetchedResultsControllerDelegateEvent *> *)delegateEventsFromChanges:(NSArray<FetchedResultsControllerModelChange *> *)changes
                                                               appliedToModelState:(id<FetchedResultsControllerModelState>)helper;
+ (void)updateDelegateEvents:(NSArray<FetchedResultsControllerDelegateEvent *> *)delegateEvents
       appliedFromModelState:(id<FetchedResultsControllerModelState>)helper;

- (NSString *)stringFromChangeType:(FetchedResultsChangeType)changeType;

- (void)notifyFetchedResultsControllerDelegate:(FetchedResultsController *)fetchedResultsController;

@end
