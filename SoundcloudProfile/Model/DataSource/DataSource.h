//
//  DataSource.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DataSourceDelegate;

@interface DataSource : NSObject

/// A delegate object that will receive change notifications from this data source.
@property (nonatomic, weak) id<DataSourceDelegate> delegate;

@property (nonatomic, readonly) NSUInteger numberOfSections;

@property (nonatomic, readonly, nullable) id lastObject;

- (NSUInteger)numberOfItemsInSection:(NSUInteger)section;

- (NSArray<NSIndexPath *> *)indexPathsForItem:(id)object;

- (id _Nullable)itemAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *_Nullable)titleForSection:(NSUInteger)section;

- (NSArray<NSString *> *_Nullable)sectionIndexTitles;

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

- (void)notifyBatchUpdate:(dispatch_block_t _Nullable)update;

- (void)notifyBatchUpdate:(dispatch_block_t _Nullable)update complete:(dispatch_block_t _Nullable)complete;

@end

NS_ASSUME_NONNULL_END
