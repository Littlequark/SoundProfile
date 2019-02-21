//
//  CollectionViewModel.h
//

#import "CollectionViewModelProtocol.h"
#import "DataSourceDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class DataSource;
@protocol ViewModelFactoryProtocol;

@interface CollectionViewModel : NSObject <CollectionViewModelProtocol, DataSourceDelegate> {
@protected
    DataSource *_dataSource;
}

@property (nonatomic) DataSource *dataSource;
@property (nonatomic, readonly) NSUInteger numberOfItems;

- (void)registerViewModelClass:(Class<ViewModelFactoryProtocol>)viewModelClass
                 forModelClass:(Class)modelClass;

- (Class<ViewModelFactoryProtocol>)viewModelClassForModel:(NSObject *)model;

- (void)registerViewModelsMap:(NSDictionary<NSString *, NSString *> *)viewModelsMap;

- (void)notifyDidReloadData;

- (void)notifyDidRefreshItemAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)removeOutdatedSelectedObjects;

- (void)loadContent NS_REQUIRES_SUPER;

- (void)dataSourceDidReloadData:(DataSource *)dataSource NS_REQUIRES_SUPER;

- (void)dataSource:(DataSource *)dataSource
performBatchUpdate:(dispatch_block_t _Nullable)update
          complete:(dispatch_block_t _Nullable)complete NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
