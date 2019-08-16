//
//  FetchedResultsControllerModel+ModelChange.h
//

#import "FetchedResultsControllerModel.h"

@interface FetchedResultsControllerModel (ModelChange)

- (void)createSectionInfoWithName:(NSString *)sectionName atIndex:(NSUInteger)sectionIndex;

- (void)removeSectionInfoFromIndex:(NSUInteger)sectionIndex;

- (void)addObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

- (void)removeObjectFromIndexPath:(NSIndexPath *)indexPath;

@end
