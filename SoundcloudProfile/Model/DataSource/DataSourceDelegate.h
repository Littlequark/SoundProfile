//
//  DataSourceDelegate.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DataSource;

@protocol DataSourceDelegate <NSObject>
@optional

- (void)dataSource:(DataSource *)dataSource didInsertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (void)dataSource:(DataSource *)dataSource didRemoveItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (void)dataSource:(DataSource *)dataSource didRefreshItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (void)dataSource:(DataSource *)dataSource didMoveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)newIndexPath;

- (void)dataSource:(DataSource *)dataSource didInsertSections:(NSIndexSet *)sections;
- (void)dataSource:(DataSource *)dataSource didRemoveSections:(NSIndexSet *)sections;
- (void)dataSource:(DataSource *)dataSource didRefreshSections:(NSIndexSet *)sections;

- (void)dataSourceDidReloadData:(DataSource *)dataSource;
- (void)dataSourceDidReloadSectionIndexTitles:(DataSource *)dataSource;
- (void)dataSource:(DataSource *)dataSource performBatchUpdate:(dispatch_block_t)update complete:(dispatch_block_t)complete;

/// If the content was loaded successfully, the error will be nil.
- (void)dataSource:(DataSource *)dataSource didLoadContentWithError:(NSError *)error;

/// Called just before a datasource begins loading its content.
- (void)dataSourceWillLoadContent:(DataSource *)dataSource;

@end

NS_ASSUME_NONNULL_END
