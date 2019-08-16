//
//  FetchedResultsControllerModelState.h
//

#import <Foundation/Foundation.h>

@protocol FetchedResultsSectionInfoProtocol;

@protocol FetchedResultsControllerModelState <NSObject>

- (NSIndexPath *)indexPathForObject:(id)object;

- (NSUInteger)indexOfSectionInfo:(id<FetchedResultsSectionInfoProtocol>)sectionInfo;
- (id<FetchedResultsSectionInfoProtocol>)sectionInfoWithName:(NSString *)name;


@end
