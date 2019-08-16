//
//  FetchedResultsControllerDelegateEvent+Private.h
//

#import "FetchedResultsControllerDelegateEvent.h"

@protocol FetchedResultsSectionInfoProtocol;

@interface FetchedResultsControllerDelegateEventObject : FetchedResultsControllerDelegateEvent

@property (nonatomic) NSIndexPath *fromIndexPath;
@property (nonatomic) NSIndexPath *toIndexPath;

@property (nonatomic) id object;

@end

@interface FetchedResultsControllerDelegateEventSection : FetchedResultsControllerDelegateEvent

@property (nonatomic) NSUInteger sectionIndex;
@property (nonatomic, copy) NSString *sectionName;
@property (nonatomic) id<FetchedResultsSectionInfoProtocol> sectionInfo;

@end
