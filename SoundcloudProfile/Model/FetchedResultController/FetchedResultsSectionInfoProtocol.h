//
//  FetchedResultsSectionInfoProtocol.h
//

#import <Foundation/Foundation.h>

@protocol FetchedResultsSectionInfoProtocol <NSObject, NSCopying>

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *indexTitle;
@property (nonatomic, readonly) NSArray *objects;

- (instancetype)initWithName:(NSString *)name;

@end
