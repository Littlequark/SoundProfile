//
//  ComposedDataSource.m
//

#import <unordered_map>

#import "ComposedDataSource.h"
#import "ComposedDataSource+Private.h"
#import "DataSource_Private.h"
#import "DataSourceDelegate.h"

#import "NSIndexPath+DataSource.h"

@interface ComposedDataSource () <DataSourceDelegate>
{
    std::unordered_map<NSUInteger, ComposedMapping *> _globalSectionToMappings;
    BOOL _needsUpdatedMapping;
}

@property (nonatomic, retain) NSMutableArray *mappings;
@property (nonatomic, retain) NSMapTable *dataSourceToMappings;
@property (nonatomic, assign) NSUInteger sectionCount;
@property (nonatomic, readonly) NSArray *dataSources;
@property (nonatomic, strong) NSString *aggregateLoadingState;

- (void)seedsUpdatedMapping;

@end

@implementation ComposedDataSource

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _needsUpdatedMapping = YES;
        _mappings = [[NSMutableArray alloc] init];
        _dataSourceToMappings = [[NSMapTable alloc] initWithKeyOptions:NSMapTableObjectPointerPersonality valueOptions:NSMapTableStrongMemory capacity:1];
    }
    
    return self;
}

- (void)seedsUpdatedMapping
{
    _needsUpdatedMapping = YES;
}

- (void)updateMappingsIfNeeded
{
    if (!_needsUpdatedMapping)
    {
        return;
    }
    
    _needsUpdatedMapping = NO;
    _sectionCount = 0;
    _globalSectionToMappings.clear();
    
    for (ComposedMapping *mapping in _mappings)
    {
        NSUInteger newSectionCount = [mapping updateMappingsStartingWithGlobalSection:_sectionCount];
        while (_sectionCount < newSectionCount)
        {
            _globalSectionToMappings[_sectionCount++] = mapping;
        }
    }
}

- (NSUInteger)sectionForDataSource:(DataSource *)dataSource
{
    ComposedMapping *mapping = [self mappingForDataSource:dataSource];
    return [mapping globalSectionForLocalSection:0];
}

- (DataSource *)dataSourceForSectionAtIndex:(NSInteger)sectionIndex
{
    ComposedMapping *mapping = [self mappingForGlobalSection:sectionIndex];
    return mapping.dataSource;
}

- (NSIndexPath *)localIndexPathForGlobalIndexPath:(NSIndexPath *)globalIndexPath
{
    ComposedMapping *mapping = [self mappingForGlobalSection:globalIndexPath.sp_section];
    return [mapping localIndexPathForGlobalIndexPath:globalIndexPath];
}

- (ComposedMapping *)mappingForGlobalSection:(NSInteger)section
{
    std::unordered_map<NSUInteger, ComposedMapping *>::const_iterator it = _globalSectionToMappings.find(section);
    if (it == _globalSectionToMappings.end())
    {
        return nil;
    }
    ComposedMapping *mapping = it->second;
    return mapping;
}

- (ComposedMapping *)mappingForDataSource:(DataSource *)dataSource
{
    ComposedMapping *mapping = [_dataSourceToMappings objectForKey:dataSource];
    return mapping;
}

- (NSIndexSet *)globalSectionsForLocal:(NSIndexSet *)localSections dataSource:(DataSource *)dataSource
{
    NSMutableIndexSet *result = [NSMutableIndexSet indexSet];
    ComposedMapping *mapping = [self mappingForDataSource:dataSource];
    [localSections enumerateIndexesUsingBlock:^(NSUInteger localSection, BOOL *stop) {
        [result addIndex:[mapping globalSectionForLocalSection:localSection]];
    }];
    return result;
}

- (NSArray *)globalIndexPathsForLocal:(NSArray *)localIndexPaths dataSource:(DataSource *)dataSource
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[localIndexPaths count]];
    ComposedMapping *mapping = [self mappingForDataSource:dataSource];
    for (NSIndexPath *localIndexPath in localIndexPaths)
    {
        [result addObject:[mapping globalIndexPathForLocalIndexPath:localIndexPath]];
    }
    
    return result;
}

- (NSArray *)dataSources
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[_dataSourceToMappings count]];
    for (id key in _dataSourceToMappings)
    {
        ComposedMapping *mapping = [_dataSourceToMappings objectForKey:key];
        [result addObject:mapping.dataSource];
    }
    return result;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    ComposedMapping *mapping = [self mappingForGlobalSection:indexPath.sp_section];
    
    NSIndexPath *mappedIndexPath = [mapping localIndexPathForGlobalIndexPath:indexPath];
    
    return [mapping.dataSource itemAtIndexPath:mappedIndexPath];
}

- (NSArray *)indexPathsForItem:(id)object
{
    NSMutableArray *results = [NSMutableArray array];
    NSArray *dataSources = self.dataSources;
    
    for (DataSource *dataSource in dataSources)
    {
        ComposedMapping *mapping = [self mappingForDataSource:dataSource];
        NSArray *indexPaths = [dataSource indexPathsForItem:object];
        
        if (![indexPaths count])
        {
            continue;
        }
        
        for (NSIndexPath *localIndexPath in indexPaths)
        {
            [results addObject:[mapping globalIndexPathForLocalIndexPath:localIndexPath]];
        }
    }
    
    return results;
}

- (NSString *)titleForSection:(NSUInteger)section {
    ComposedMapping *mapping = [self mappingForGlobalSection:section];
    
    NSUInteger localSection = [mapping localSectionForGlobalSection:section];
    
    return [mapping.dataSource titleForSection:localSection];
}

- (NSArray<NSString *> *)sectionIndexTitles {
    NSMutableArray<NSString *> *indexTitles = [[NSMutableArray<NSString *> alloc] init];
    for (DataSource *dataSource in self.dataSources) {
        NSArray<NSString *> *localIndexTitles = [dataSource sectionIndexTitles];
        if (localIndexTitles) {
            [indexTitles addObjectsFromArray:localIndexTitles];
        }
    }
    return indexTitles.copy;
}

- (NSUInteger)sectionIndexForTitle:(NSString *)title {
    NSUInteger section = NSNotFound;
    for (DataSource *dataSource in self.dataSources) {
        NSUInteger localSectionIndex = [dataSource sectionIndexForTitle:title];
        if (localSectionIndex != NSNotFound) {
            ComposedMapping *mapping = [self mappingForDataSource:dataSource];
            section = [mapping globalSectionForLocalSection:localSectionIndex];
            break;
        }
    }
    return section;
}

#pragma mark - ComposedDataSource API

- (void)addDataSource:(DataSource *)dataSource {
    [self insertDataSource:dataSource atIndex:self.mappings.count];
}

- (void)insertDataSource:(DataSource *)dataSource atIndex:(NSUInteger)index {
    ////ParameterAssert(dataSource != nil);
    if ([self containsDataSource:dataSource]) {
        return;
    }
    
    dataSource.delegate = self;
    
    ComposedMapping *mappingForDataSource = [_dataSourceToMappings objectForKey:dataSource];
    ////Assert(mappingForDataSource == nil, @"tried to add data source more than once: %@", dataSource);
    
    mappingForDataSource = [[ComposedMapping alloc] initWithDataSource:dataSource];
    [_mappings insertObject:mappingForDataSource atIndex:index];
    [_dataSourceToMappings setObject:mappingForDataSource forKey:dataSource];
    
    [self seedsUpdatedMapping];
    [self updateMappingsIfNeeded];
    
    NSMutableIndexSet *addedSections = [NSMutableIndexSet indexSet];
    NSUInteger numberOfSections = dataSource.numberOfSections;
    
    for (NSUInteger sectionIdx = 0; sectionIdx < numberOfSections; ++sectionIdx) {
        [addedSections addIndex:[mappingForDataSource globalSectionForLocalSection:sectionIdx]];
    }
}

- (void)removeDataSource:(DataSource *)dataSource
{
    if (![self containsDataSource:dataSource]) {
        return;
    }
    
    ComposedMapping *mappingForDataSource = [_dataSourceToMappings objectForKey:dataSource];
    ////Assert(mappingForDataSource != nil, @"Data source not found in mapping");
    
    NSMutableIndexSet *removedSections = [NSMutableIndexSet indexSet];
    NSUInteger numberOfSections = dataSource.numberOfSections;
    
    for (NSUInteger sectionIdx = 0; sectionIdx < numberOfSections; ++sectionIdx)
    {
        [removedSections addIndex:[mappingForDataSource globalSectionForLocalSection:sectionIdx]];
    }
    
    [_dataSourceToMappings removeObjectForKey:dataSource];
    [_mappings removeObject:mappingForDataSource];
    
    dataSource.delegate = nil;
    
    [self seedsUpdatedMapping];
    [self updateMappingsIfNeeded];
}

- (BOOL)containsDataSource:(DataSource *)dataSource {
    return [self.dataSources containsObject:dataSource];
}

- (NSUInteger)sectionIndexForDataSource:(DataSource *)dataSource {
    ComposedMapping *mapping = [self mappingForDataSource:dataSource];
    if (mapping.dataSource.numberOfSections == 0) {
        return NSNotFound;
    }
    return [mapping globalSectionForLocalSection:0];
}

- (DataSource *)dataSourceForSectionIndex:(NSUInteger)sectionIndex {
    ComposedMapping *mapping = [self mappingForGlobalSection:sectionIndex];
    return mapping.dataSource;
}

#pragma mark - DataSource methods

- (NSUInteger)numberOfSections
{
    [self updateMappingsIfNeeded];
    return _sectionCount;
}

- (NSUInteger)numberOfItemsInSection:(NSUInteger)section {
    ComposedMapping *mapping = [self mappingForGlobalSection:section];
    NSUInteger localSection = [mapping localSectionForGlobalSection:section];
    NSUInteger numberOfItems = [mapping.dataSource numberOfItemsInSection:localSection];
    
    return numberOfItems;
}

#pragma mark - DataSourceDelegate

- (void)dataSource:(DataSource *)dataSource didInsertItemsAtIndexPaths:(NSArray *)indexPaths
{
    ComposedMapping *mapping = [self mappingForDataSource:dataSource];
    NSArray *globalIndexPaths = [mapping globalIndexPathsForLocalIndexPaths:indexPaths];
    
    [self notifyItemsInsertedAtIndexPaths:globalIndexPaths];
}

- (void)dataSource:(DataSource *)dataSource didRemoveItemsAtIndexPaths:(NSArray *)indexPaths
{
    ComposedMapping *mapping = [self mappingForDataSource:dataSource];
    NSArray *globalIndexPaths = [mapping globalIndexPathsForLocalIndexPaths:indexPaths];
    
    [self notifyItemsRemovedAtIndexPaths:globalIndexPaths];
}

- (void)dataSource:(DataSource *)dataSource didRefreshItemsAtIndexPaths:(NSArray *)indexPaths
{
    ComposedMapping *mapping = [self mappingForDataSource:dataSource];
    NSArray *globalIndexPaths = [mapping globalIndexPathsForLocalIndexPaths:indexPaths];
    
    [self notifyItemsRefreshedAtIndexPaths:globalIndexPaths];
}

- (void)dataSource:(DataSource *)dataSource didMoveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)newIndexPath
{
    ComposedMapping *mapping = [self mappingForDataSource:dataSource];
    NSIndexPath *globalFromIndexPath = [mapping globalIndexPathForLocalIndexPath:fromIndexPath];
    NSIndexPath *globalNewIndexPath = [mapping globalIndexPathForLocalIndexPath:newIndexPath];
    
    [self notifyItemMovedFromIndexPath:globalFromIndexPath toIndexPaths:globalNewIndexPath];
}

- (void)dataSource:(DataSource *)dataSource didInsertSections:(NSIndexSet *)sections
{
    ComposedMapping *mapping = [self mappingForDataSource:dataSource];
    
    [self seedsUpdatedMapping];
    [self updateMappingsIfNeeded];
    
    NSMutableIndexSet *globalSections = [NSMutableIndexSet indexSet];
    [sections enumerateIndexesUsingBlock:^(NSUInteger localSectionIndex, BOOL *stop) {
        [globalSections addIndex:[mapping globalSectionForLocalSection:localSectionIndex]];
    }];
    
    [self notifySectionsInserted:globalSections];
}

- (void)dataSource:(DataSource *)dataSource didRemoveSections:(NSIndexSet *)sections
{
    ComposedMapping *mapping = [self mappingForDataSource:dataSource];
    
    NSMutableIndexSet *globalSections = [NSMutableIndexSet indexSet];
    [sections enumerateIndexesUsingBlock:^(NSUInteger localSectionIndex, BOOL *stop) {
        [globalSections addIndex:[mapping globalSectionForLocalSection:localSectionIndex]];
    }];
	
	[self seedsUpdatedMapping];
	[self updateMappingsIfNeeded];
	
    [self notifySectionsRemoved:globalSections];
}

- (void)dataSource:(DataSource *)dataSource didRefreshSections:(NSIndexSet *)sections
{
    ComposedMapping *mapping = [self mappingForDataSource:dataSource];
    
    NSMutableIndexSet *globalSections = [NSMutableIndexSet indexSet];
    [sections enumerateIndexesUsingBlock:^(NSUInteger localSectionIndex, BOOL *stop) {
        [globalSections addIndex:[mapping globalSectionForLocalSection:localSectionIndex]];
    }];
    
    [self notifySectionsRefreshed:globalSections];
    
    [self seedsUpdatedMapping];
    [self updateMappingsIfNeeded];
}

- (void)dataSourceDidReloadData:(DataSource *)dataSource
{
    [self seedsUpdatedMapping];
    [self updateMappingsIfNeeded];
    [self notifyDidReloadData];
}

- (void)dataSource:(DataSource *)dataSource performBatchUpdate:(dispatch_block_t)update complete:(dispatch_block_t)complete
{
    [self notifyBatchUpdate:update complete:complete];
}

@end
