//
//  FetchedResultsControllerModel.h
//

#import <Foundation/Foundation.h>

#import "FetchedResultsSectionInfoProtocol.h"

#import "FetchedResultsControllerModelChange.h"

@interface FetchedResultsControllerModel : NSObject <NSCopying>
{
@protected
    NSMutableArray<id<FetchedResultsSectionInfoProtocol>> *_sections;
}

@property (nonatomic, readonly) NSArray<id<FetchedResultsSectionInfoProtocol>> *sections;

@property NSPredicate *objectsPredicate;
@property (nonatomic) NSSortDescriptor *objectsSortDescriptor;
@property (nonatomic) NSSortDescriptor *sectionSortDescriptor;

@property (nonatomic, copy) NSString *sectionNameKeyPath;

- (instancetype)initWithSectionInfoClass:(Class)sectionInfoClass;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForObject:(id)object;

- (id<FetchedResultsSectionInfoProtocol>)findSectionInfoWithName:(NSString *)sectionName;

- (void)clear;

- (NSArray<FetchedResultsControllerModelChange *> *)insertObjectsAndReturnChanges:(NSSet *)objects;
- (NSArray<FetchedResultsControllerModelChange *> *)removeObjectsAndReturnChanges:(NSSet *)objects;
- (NSArray<FetchedResultsControllerModelChange *> *)updateOrMoveObjectsAndReturnChanges:(NSSet *)objects;

- (id<FetchedResultsSectionInfoProtocol>)createSectionInfoWithName:(NSString *)sectionName;

@end
