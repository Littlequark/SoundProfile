//
//  BasicDataSource.h
//

#import "DataSource.h"

@interface BasicDataSource : DataSource

@property (nonatomic, copy) NSArray *items;
@property (nonatomic, copy) NSString *title;

- (void)insertItems:(NSArray *)array atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)array;

@end
