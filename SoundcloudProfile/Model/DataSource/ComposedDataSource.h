//
//  MRComposedDataSource.h
//

#import "DataSource.h"

@interface ComposedDataSource : DataSource

- (void)addDataSource:(DataSource *)dataSource;
- (void)insertDataSource:(DataSource *)dataSource atIndex:(NSUInteger)index;
- (void)removeDataSource:(DataSource *)dataSource;
- (BOOL)containsDataSource:(DataSource *)dataSource;

- (NSUInteger)sectionIndexForDataSource:(DataSource *)dataSource;

- (DataSource *)dataSourceForSectionIndex:(NSUInteger)sectionIndex;

- (void)seedsUpdatedMapping;
- (void)updateMappingsIfNeeded;

@end
