//
//  FetchedResultsControllerModel+ModelChange.m
//

#import "FetchedResultsControllerModel+ModelChange.h"
#import "FetchedResultsControllerModelChange.h"
#import "FetchedResultsSectionInfo.h"
#import "NSIndexPath+DataSource.h"

@implementation FetchedResultsControllerModel (ModelChange)

- (void)createSectionInfoWithName:(NSString *)sectionName atIndex:(NSUInteger)sectionIndex {
    id<FetchedResultsSectionInfoProtocol> sectionInfo = [self createSectionInfoWithName:sectionName];
    [_sections insertObject:sectionInfo atIndex:sectionIndex];
}

- (void)removeSectionInfoFromIndex:(NSUInteger)sectionIndex {
    [_sections removeObjectAtIndex:sectionIndex];
}

- (void)addObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    FetchedResultsSectionInfo *sectionInfo = self.sections[indexPath.sp_section];
    [sectionInfo insertObject:object atIndex:indexPath.sp_item];
}

- (void)removeObjectFromIndexPath:(NSIndexPath *)indexPath {
    FetchedResultsSectionInfo *sectionInfo = self.sections[indexPath.sp_section];
    [sectionInfo removeObjectAtIndex:indexPath.sp_item];
}

@end
