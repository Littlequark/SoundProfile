//
//  BasicDataSource.h
//

#import "DataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface BasicDataSource : DataSource

@property (nonatomic, copy) NSArray *items;
@property (nonatomic, copy, nullable) NSString *title;

- (void)insertItems:(NSArray *)array atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
