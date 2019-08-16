//
//  FetchedResultsSectionInfo.h
//

#import <Foundation/Foundation.h>
#import "FetchedResultsSectionInfoProtocol.h"

@interface FetchedResultsSectionInfo : NSObject <FetchedResultsSectionInfoProtocol>
{
@protected
	NSMutableArray * _objects;
}

- (instancetype)initWithName:(NSString *)name NS_DESIGNATED_INITIALIZER;

- (NSUInteger)indexOfObject:(id)object;

- (void)insertObject:(id)object atIndex:(NSUInteger)index;

- (void)removeObjectAtIndex:(NSUInteger)index;

@end
