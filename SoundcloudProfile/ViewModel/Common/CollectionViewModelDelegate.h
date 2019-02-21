//
//  CollectionViewModelDelegate.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CollectionViewModelProtocol;

@protocol CollectionViewModelDelegate <NSObject>

@optional
- (void)viewModel:(id<CollectionViewModelProtocol>)viewModel didInsertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)viewModel:(id<CollectionViewModelProtocol>)viewModel didRemoveItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)viewModel:(id<CollectionViewModelProtocol>)viewModel didRefreshItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)viewModel:(id<CollectionViewModelProtocol>)viewModel didInsertSections:(NSIndexSet *)sections;

- (void)viewModel:(id<CollectionViewModelProtocol>)viewModel didRemoveSections:(NSIndexSet *)sections;

- (void)viewModel:(id<CollectionViewModelProtocol>)viewModel didRefreshSections:(NSIndexSet *)sections;

- (void)viewModelDidReloadData:(id<CollectionViewModelProtocol>)viewModel;

- (void)viewModel:(id<CollectionViewModelProtocol>)viewModel performBatchUpdate:(dispatch_block_t _Nullable)update completion:(dispatch_block_t _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
