//
//  DataSource.m
//

#import "DataSource.h"
#import "DataSource_Private.h"
#import "DataSourceDelegate.h"
#import "Defines.h"
#import "NSIndexPath+DataSource.h"
#import "SafeBlock.h"

@implementation DataSource

NS_ASSUME_NONNULL_BEGIN

- (NSUInteger)numberOfSections {
    return 1;
}

- (NSUInteger)numberOfItemsInSection:(NSUInteger)section {
    return 0;
}

- (DataSource *)dataSourceForSectionAtIndex:(NSInteger)sectionIndex {
    return self;
}

- (NSIndexPath *)localIndexPathForGlobalIndexPath:(NSIndexPath *)globalIndexPath {
    return globalIndexPath;
}

- (NSArray<NSIndexPath *> *)indexPathsForItem:(id)object {
    OBJECT_ABSTRACT_METHOD;
}

- (id _Nullable)itemAtIndexPath:(NSIndexPath *)indexPath {
    OBJECT_ABSTRACT_METHOD;
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath {
    OBJECT_ABSTRACT_METHOD;
}

- (NSString *_Nullable)titleForSection:(NSUInteger)section {
    return nil;
}

- (NSArray<NSString *> *_Nullable)sectionIndexTitles {
    return nil;
}

- (NSUInteger)sectionIndexForTitle:(NSString *)title {
    return NSNotFound;
}

- (id _Nullable)lastObject {
    id item = nil;
    NSUInteger numberOfSections = self.numberOfSections;
    for (NSUInteger i = numberOfSections - 1; i < numberOfSections; i++) {
        NSUInteger numberOfRows = [self numberOfItemsInSection:i];
        if (numberOfRows) {
            item = [self itemAtIndexPath:[NSIndexPath sp_indexPathForItem:numberOfRows - 1 inSection:i]];
        }
    }
    return item;
}

#pragma mark - Notify updates

- (void)notifyItemsInsertedAtIndexPaths:(NSArray *)insertedIndexPaths {
    ////AssertMainThread();
    
    id<DataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didInsertItemsAtIndexPaths:)]) {
        [delegate dataSource:self didInsertItemsAtIndexPaths:insertedIndexPaths];
    }
}

- (void)notifyItemsRemovedAtIndexPaths:(NSArray *)removedIndexPaths {
    ////AssertMainThread();
    
    id<DataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didRemoveItemsAtIndexPaths:)]) {
        [delegate dataSource:self didRemoveItemsAtIndexPaths:removedIndexPaths];
    }
}

- (void)notifyItemsRefreshedAtIndexPaths:(NSArray *)refreshedIndexPaths {
    ////AssertMainThread();
    
    id<DataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didRefreshItemsAtIndexPaths:)]) {
        [delegate dataSource:self didRefreshItemsAtIndexPaths:refreshedIndexPaths];
    }
}

- (void)notifyItemMovedFromIndexPath:(NSIndexPath *)indexPath toIndexPaths:(NSIndexPath *)newIndexPath {
    ////AssertMainThread();
    
    id<DataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didMoveItemAtIndexPath:toIndexPath:)]) {
        [delegate dataSource:self didMoveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
    }
}

- (void)notifySectionsInserted:(NSIndexSet *)sections {
    ////AssertMainThread();
    
    id<DataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didInsertSections:)]) {
        [delegate dataSource:self didInsertSections:sections];
    }
}

- (void)notifySectionsRemoved:(NSIndexSet *)sections {
    ////AssertMainThread();
    
    id<DataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didRemoveSections:)]) {
        [delegate dataSource:self didRemoveSections:sections];
    }
}

- (void)notifySectionsRefreshed:(NSIndexSet *)sections {
    ////AssertMainThread();
    
    id<DataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didRefreshSections:)])
    {
        [delegate dataSource:self didRefreshSections:sections];
    }
}

- (void)notifyDidReloadData {
    ////AssertMainThread();
    
    id<DataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSourceDidReloadData:)]) {
        [delegate dataSourceDidReloadData:self];
    }
}

- (void)notifyDidReloadSectionIndexTitles {
    ////AssertMainThread();
    
    id<DataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSourceDidReloadSectionIndexTitles:)]) {
        [delegate dataSourceDidReloadSectionIndexTitles:self];
    }
}

- (void)notifyBatchUpdate:(dispatch_block_t _Nullable)update {
    [self notifyBatchUpdate:update complete:nil];
}

- (void)notifyBatchUpdate:(dispatch_block_t _Nullable)update
                 complete:(dispatch_block_t _Nullable)complete {
    ////AssertMainThread();
    
    id<DataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:performBatchUpdate:complete:)]) {
        [delegate dataSource:self performBatchUpdate:update complete:complete];
    }
    else {
        if (update) {
            update();
        }
        
        if (complete) {
            complete();
        }
    }
}

@end

NS_ASSUME_NONNULL_END
