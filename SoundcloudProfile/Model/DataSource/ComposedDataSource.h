//
//  MRComposedDataSource.h
//

#import "DataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComposedDataSource : DataSource

- (void)addDataSource:(DataSource *)dataSource;
- (void)insertDataSource:(DataSource *)dataSource atIndex:(NSUInteger)index;
- (void)removeDataSource:(DataSource *)dataSource;
- (BOOL)containsDataSource:(DataSource *)dataSource;

- (NSUInteger)sectionIndexForDataSource:(DataSource *)dataSource;

- (DataSource *_Nullable)dataSourceForSectionIndex:(NSUInteger)sectionIndex;

- (void)seedsUpdatedMapping;
- (void)updateMappingsIfNeeded;

@end

NS_ASSUME_NONNULL_END
