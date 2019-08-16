//
//  NSIndexPath+DataSource.m
//

#import "NSIndexPath+DataSource.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSIndexPath (DataSource)

+ (instancetype)sp_indexPathForItem:(NSUInteger)item inSection:(NSUInteger)section
{
    NSUInteger indexes[2] = {section, item};
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexes length:2];
    return indexPath;
}

- (NSUInteger)sp_section
{
    return [self indexAtPosition:0];
}

- (NSUInteger)sp_item
{
    return [self indexAtPosition:1];
}

@end

NS_ASSUME_NONNULL_END
