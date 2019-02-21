//
//  NSIndexPath+DataSource.h
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (DataSource)

+ (instancetype)sp_indexPathForItem:(NSUInteger)item inSection:(NSUInteger)section;

@property (nonatomic, readonly) NSUInteger sp_section;
@property (nonatomic, readonly) NSUInteger sp_item;

@end
