//
//  DataSource_Private.h
//

#import "DataSource.h"

@interface DataSource ()

- (NSIndexPath *)localIndexPathForGlobalIndexPath:(NSIndexPath *)globalIndexPath;

/// Is this data source the root data source? This depends on proper set up of the delegate property. Container data sources ALWAYS act as the delegate for their contained data sources.
@property (nonatomic, readonly, getter = isRootDataSource) BOOL rootDataSource;

- (void)notifySectionsInserted:(NSIndexSet *)sections;
- (void)notifySectionsRemoved:(NSIndexSet *)sections;

- (DataSource *)dataSourceForSectionAtIndex:(NSInteger)sectionIndex;

@end
