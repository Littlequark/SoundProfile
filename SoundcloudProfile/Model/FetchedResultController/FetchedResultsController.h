//
//  FetchedResultsController.h
//

#import <Foundation/Foundation.h>
#import "FetchedResultsSectionInfoProtocol.h"
#import "FetchedResultsControllerDelegate.h"
#import "DataUpdatesHandlerProtocol.h"

/**
 You configure an instance of this class using an `objectsSortDescriptor`, optionally an `objectsPredicate`.
 If you set `sectionNameKeyPath` then `sectionsSortDescriptor` is required.
 Changing properties of FetchedResultsController after adding any objects are not allowed.
 */
@interface FetchedResultsController : NSObject <DataUpdatesHandlerProtocol>

@property (nonatomic, nullable) NSPredicate *objectsPredicate;
@property (nonatomic, nullable) NSSortDescriptor *objectsSortDescriptor;
@property (nonatomic, nullable) NSSortDescriptor *sectionsSortDescriptor;
@property (nonatomic, nullable, copy) NSString *sectionNameKeyPath;

@property (nonatomic, nonnull, readonly) NSArray *fetchedObjects;
@property (nonatomic, nonnull, readonly) NSArray<id<FetchedResultsSectionInfoProtocol>> *sections;
@property (nonatomic, nullable, readonly) NSArray<NSString *> *sectionIndexTitles;

@property (nonatomic, nullable, weak) id<FetchedResultsControllerDelegate> delegate;

- (nonnull instancetype)initWithSectionNameKeyPath:(nullable NSString *)sectionNameKeyPath NS_DESIGNATED_INITIALIZER;

- (nonnull id)objectAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (nullable NSIndexPath *)indexPathForObject:(nonnull id)object;

- (void)setObjects:(nonnull NSSet *)objects completion:(nullable dispatch_block_t)completion;
- (void)addObjects:(nonnull NSSet *)objects completion:(nullable dispatch_block_t)completion;

- (void)handleInsertedObjects:(nonnull NSSet *)objects;
- (void)handleDeletedObjects:(nonnull NSSet *)objects;
- (void)handleUpdatedObjects:(nonnull NSSet *)objects;

@end
