//
//  FetchedResultsControllerModel+ModelState.m
//

#import "FetchedResultsControllerModel+ModelState.h"

@implementation FetchedResultsControllerModel (ModelState)

- (NSUInteger)indexOfSectionInfo:(id<FetchedResultsSectionInfoProtocol>)sectionInfo {
    return [_sections indexOfObject:sectionInfo];
}

- (id<FetchedResultsSectionInfoProtocol>)sectionInfoWithName:(NSString *)name {
    return [self findSectionInfoWithName:name];
}

@end
