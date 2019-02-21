//
//  DataSource.h
//

#import <Foundation/Foundation.h>

@protocol DataSourceDelegate;

@interface DataSource : NSObject

/// A delegate object that will receive change notifications from this data source.
@property (nonatomic, weak) id<DataSourceDelegate> delegate;

@property (nonatomic, readonly) NSUInteger numberOfSections;

@property (nonatomic, readonly) id lastObject;

- (NSUInteger)numberOfItemsInSection:(NSUInteger)section;

- (NSArray<NSIndexPath *> *)indexPathsForItem:(id)object;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)titleForSection:(NSUInteger)section;
- (NSArray<NSString *> *)sectionIndexTitles;
- (NSUInteger)sectionIndexForTitle:(NSString *)title;

// Use these methods to notify the collection view of changes to the dataSource.
- (void)notifyItemsInsertedAtIndexPaths:(NSArray<NSIndexPath *> *)insertedIndexPaths;
- (void)notifyItemsRemovedAtIndexPaths:(NSArray<NSIndexPath *> *)removedIndexPaths;
- (void)notifyItemsRefreshedAtIndexPaths:(NSArray<NSIndexPath *> *)refreshedIndexPaths;
- (void)notifyItemMovedFromIndexPath:(NSIndexPath *)indexPath toIndexPaths:(NSIndexPath *)newIndexPath;

- (void)notifySectionsInserted:(NSIndexSet *)sections;
- (void)notifySectionsRemoved:(NSIndexSet *)sections;
- (void)notifySectionsRefreshed:(NSIndexSet *)sections;

- (void)notifyDidReloadData;
- (void)notifyDidReloadSectionIndexTitles;

- (void)notifyBatchUpdate:(dispatch_block_t)update;
- (void)notifyBatchUpdate:(dispatch_block_t)update complete:(dispatch_block_t)complete;

@end
