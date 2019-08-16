//
//  FetchedResultsControllerModelChange+Private.h
//

#import "FetchedResultsControllerModelChange.h"

@interface FetchedResultsControllerModelChange ()

@property (nonatomic) FetchedResultsControllerModelChangeType type;

@end

@interface FetchedResultsControllerModelChangeObject : FetchedResultsControllerModelChange

@property (nonatomic, copy) NSObject<NSCopying> *object;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@interface FetchedResultsControllerModelChangeSection : FetchedResultsControllerModelChange

@property (nonatomic, strong) NSString *sectionName;
@property (nonatomic) NSUInteger sectionIndex;

@end
