//
//  ComposedDataSource+Private.h
//

#import "ComposedDataSource.h"

NS_ASSUME_NONNULL_BEGIN

/// Maps global sections to local sections for a given data source
@interface ComposedMapping : NSObject <NSCopying>

- (instancetype)initWithDataSource:(DataSource *_Nullable)dataSource;

/// The data source associated with this mapping
@property (nonatomic, strong) DataSource * dataSource;

/// The number of sections in this mapping
@property (nonatomic, readonly) NSInteger sectionCount;

/// Return the local section for a global section
- (NSUInteger)localSectionForGlobalSection:(NSUInteger)globalSection;

/// Return the global section for a local section
- (NSUInteger)globalSectionForLocalSection:(NSUInteger)localSection;

/// Return a local index path for a global index path
- (NSIndexPath *)localIndexPathForGlobalIndexPath:(NSIndexPath *)globalIndexPath;

/// Return a global index path for a local index path
- (NSIndexPath *)globalIndexPathForLocalIndexPath:(NSIndexPath *)localIndexPath;

/// Return an array of local index paths from an array of global index paths
- (NSArray *)localIndexPathsForGlobalIndexPaths:(NSArray *)globalIndexPaths;

/// Return an array of global index paths from an array of local index paths
- (NSArray *)globalIndexPathsForLocalIndexPaths:(NSArray *)localIndexPaths;

/// Update the mapping of local sections to global sections.
- (NSUInteger)updateMappingsStartingWithGlobalSection:(NSUInteger)globalSection;

@end

@interface ComposedDataSource (Private)

- (ComposedMapping *)mappingForGlobalSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
