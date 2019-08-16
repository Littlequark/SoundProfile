//
//  FetchedResultsSectionInfo.m
//

#import "FetchedResultsSectionInfo.h"

@implementation FetchedResultsSectionInfo

@synthesize name = _name;
@synthesize indexTitle = _indexTitle;

- (instancetype)init {
    return [self initWithName:nil];
}

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _objects = [[NSMutableArray alloc] init];
        
        _name = [name copy];
        
        if ([_name length]) {
            NSRange range = [_name rangeOfComposedCharacterSequenceAtIndex:0];
            _indexTitle = [_name substringWithRange:range];
        }
        else {
            _indexTitle = @"";
        }
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    FetchedResultsSectionInfo *newSectionInfo = [[[self class] allocWithZone:zone] init];
    if (!newSectionInfo) {
        return nil;
    }
    newSectionInfo->_name = self.name;
    newSectionInfo->_indexTitle = self.indexTitle;
    newSectionInfo->_objects = [[NSMutableArray alloc] initWithArray:_objects copyItems:YES];
    return newSectionInfo;
}

- (NSUInteger)indexOfObject:(id)object {
    return [_objects indexOfObject:object];
}

- (void)insertObject:(id)object atIndex:(NSUInteger)index {
    ///ParameterAssert(object);
    [_objects insertObject:object atIndex:index];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    ///ParameterAssert(index < _objects.count);
    [_objects removeObjectAtIndex:index];
}

#pragma mark - FetchedResultsSectionInfo

- (NSUInteger)numberOfObjects {
	return _objects.count;
}

- (NSArray *)objects {
    return [_objects copy];
}

@end
