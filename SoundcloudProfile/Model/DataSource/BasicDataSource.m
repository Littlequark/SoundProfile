//
//  BasicDataSource.m
//

#import "BasicDataSource.h"
#import "DataSource_Private.h"
#import "Defines.h"
#import "NSIndexPath+DataSource.h"

@implementation BasicDataSource

- (NSUInteger)numberOfItemsInSection:(NSUInteger)section {
    ////ParameterAssert(section == 0);
    return _items.count;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    ////AssertMainThread();
    
    NSUInteger itemIndex = indexPath.sp_item;
    if (itemIndex < [_items count]) {
        return _items[itemIndex];
    }
    
    return nil;
}

- (NSArray *)indexPathsForItem:(id)item {
    ////AssertMainThread();
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    [_items enumerateObjectsUsingBlock:^(id obj, NSUInteger objectIndex, BOOL *stop) {
        if ([obj isEqual:item]) {
            [indexPaths addObject:[NSIndexPath sp_indexPathForItem:objectIndex inSection:0]];
        }
    }];
    return indexPaths.copy;
}

- (void)setItems:(NSArray *)items {
    ////AssertMainThread();
    _items = [items copy];
    [self notifyDidReloadData];
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexSet *removedIndexes = [NSIndexSet indexSetWithIndex:indexPath.sp_item];
    [self removeItemsAtIndexes:removedIndexes];
}

- (NSString *)titleForSection:(NSUInteger)section {
    return _items.count ? self.title : nil;
}

#pragma mark - KVC methods for item property

- (NSUInteger)countOfItems {
    return [_items count];
}

- (NSArray *)itemsAtIndexes:(NSIndexSet *)indexes {
    return [_items objectsAtIndexes:indexes];
}

- (void)getItems:(__unsafe_unretained id *)buffer range:(NSRange)range {
    ////AssertMainThread();
    return [_items getObjects:buffer range:range];
}

- (void)insertItems:(NSArray *)array atIndexes:(NSIndexSet *)indexes {
    ////AssertMainThread();
    
	NSMutableArray *newItems = _items ? [_items mutableCopy] : [[NSMutableArray alloc] initWithCapacity:indexes.count];
    [newItems insertObjects:array atIndexes:indexes];
    
    _items = newItems;
    
    NSMutableArray *insertedIndexPaths = [NSMutableArray arrayWithCapacity:[indexes count]];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [insertedIndexPaths addObject:[NSIndexPath sp_indexPathForItem:idx inSection:0]];
    }];
    
    [self notifyBatchUpdate:^{
        [self notifyItemsInsertedAtIndexPaths:insertedIndexPaths];
    }];
}

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes {
    ////AssertMainThread();
    
    NSInteger newCount = [_items count] - [indexes count];
    NSMutableArray *newItems = newCount > 0 ? [[NSMutableArray alloc] initWithCapacity:newCount] : nil;
    
    // set up a delayed set of batch update calls for later execution
    __block dispatch_block_t batchUpdates = ^{};
    batchUpdates = [batchUpdates copy];
    
    [_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        dispatch_block_t oldUpdates = batchUpdates;
        if ([indexes containsIndex:idx])
        {
            // we're removing this item
            batchUpdates = ^{
                oldUpdates();
                [self notifyItemsRemovedAtIndexPaths:@[[NSIndexPath sp_indexPathForItem:idx inSection:0]]];
            };
            batchUpdates = [batchUpdates copy];
        }
        else
        {
            // we're keeping this item
            NSUInteger newIdx = [newItems count];
            [newItems addObject:obj];
            if (newIdx != idx)
            {
                batchUpdates = ^{
                    oldUpdates();
                    [self notifyItemMovedFromIndexPath:[NSIndexPath sp_indexPathForItem:idx inSection:0]
                                          toIndexPaths:[NSIndexPath sp_indexPathForItem:newIdx inSection:0]];
                };
                batchUpdates = [batchUpdates copy];
            }
        }
    }];
    
    _items = newItems;
    
    [self notifyBatchUpdate:^{
        batchUpdates();
    }];
}

- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)array {
    ////AssertMainThread();
    
    NSMutableArray *newItems = [_items mutableCopy];
    [newItems replaceObjectsAtIndexes:indexes withObjects:array];
    
    _items = newItems;
    
    NSMutableArray *replacedIndexPaths = [NSMutableArray arrayWithCapacity:[indexes count]];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [replacedIndexPaths addObject:[NSIndexPath sp_indexPathForItem:idx inSection:0]];
    }];
    
    [self notifyBatchUpdate:^{
        [self notifyItemsRefreshedAtIndexPaths:replacedIndexPaths];
    }];
}

@end
