//
//  ComposedDataSource+Private.m
//

#import "ComposedDataSource+Private.h"
#import "NSIndexPath+DataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComposedMapping ()

@property (nonatomic, retain) NSMutableDictionary *globalToLocalSections;
@property (nonatomic, retain) NSMutableDictionary *localToGlobalSections;

@end

@implementation ComposedMapping

- (instancetype)init {
    return [self initWithDataSource:nil];
}

- (instancetype)initWithDataSource:(DataSource *_Nullable)dataSource {
    self = [super init];
    if (self) {
        _dataSource = dataSource;
        _globalToLocalSections = [NSMutableDictionary dictionary];
        _localToGlobalSections = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)copyWithZone:(NSZone *_Nullable)zone {
    ComposedMapping *result = [[[self class] allocWithZone:zone] init];
    if (!result) {
        return nil;
    }
    result.dataSource = self.dataSource;
    result.globalToLocalSections = self.globalToLocalSections;
    result.localToGlobalSections = self.localToGlobalSections;
    return result;
}

- (NSUInteger)localSectionForGlobalSection:(NSUInteger)globalSection {
    NSNumber *localSection = _globalToLocalSections[@(globalSection)];
    ////Assert(localSection != nil,@"globalSection %ld not found in globalToLocalSections: %@",(long)globalSection,_globalToLocalSections);
    return [localSection unsignedIntegerValue];
}

- (NSUInteger)globalSectionForLocalSection:(NSUInteger)localSection {
    NSNumber *globalSection = _localToGlobalSections[@(localSection)];
    ////Assert(globalSection != nil,@"localSection %ld not found in localToGlobalSections:%@",(long)localSection,_localToGlobalSections);
    return [globalSection unsignedIntegerValue];
}

- (NSIndexPath *)localIndexPathForGlobalIndexPath:(NSIndexPath *)globalIndexPath {
    NSUInteger section = [self localSectionForGlobalSection:globalIndexPath.sp_section];
    return [NSIndexPath sp_indexPathForItem:globalIndexPath.sp_item inSection:section];
}

- (NSIndexPath *)globalIndexPathForLocalIndexPath:(NSIndexPath *)localIndexPath {
    NSUInteger section = [self globalSectionForLocalSection:localIndexPath.sp_section];
    return [NSIndexPath sp_indexPathForItem:localIndexPath.sp_item inSection:section];
}

- (void)addMappingFromGlobalSection:(NSUInteger)globalSection toLocalSection:(NSUInteger)localSection {
    NSNumber *globalNum = @(globalSection);
    NSNumber *localNum = @(localSection);
    ////Assert(_localToGlobalSections[localNum] == nil, @"collision while trying to add to a mapping");
    _globalToLocalSections[globalNum] = localNum;
    _localToGlobalSections[localNum] = globalNum;
}

- (NSUInteger)updateMappingsStartingWithGlobalSection:(NSUInteger)globalSection {
    _sectionCount = _dataSource.numberOfSections;
    [_globalToLocalSections removeAllObjects];
    [_localToGlobalSections removeAllObjects];
    
    for (NSUInteger localSection = 0; localSection<_sectionCount; localSection++) {
        [self addMappingFromGlobalSection:globalSection++ toLocalSection:localSection];
    }
    return globalSection;
}

- (NSArray *)localIndexPathsForGlobalIndexPaths:(NSArray *)globalIndexPaths {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[globalIndexPaths count]];
    for (NSIndexPath *globalIndexPath in globalIndexPaths) {
        [result addObject:[self localIndexPathForGlobalIndexPath:globalIndexPath]];
    }
    return result;
}

- (NSArray *)globalIndexPathsForLocalIndexPaths:(NSArray *)localIndexPaths {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[localIndexPaths count]];
    for (NSIndexPath *localIndexPath in localIndexPaths) {
        [result addObject:[self globalIndexPathForLocalIndexPath:localIndexPath]];
    }
    return result;
}

@end

NS_ASSUME_NONNULL_END
