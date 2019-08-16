//
//  NSIndexPath+DataSource.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSIndexPath (DataSource)

+ (instancetype)sp_indexPathForItem:(NSUInteger)item inSection:(NSUInteger)section;

@property (nonatomic, readonly) NSUInteger sp_section;
@property (nonatomic, readonly) NSUInteger sp_item;

@end

NS_ASSUME_NONNULL_END
