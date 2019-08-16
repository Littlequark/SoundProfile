//
//  FetchedResultsController+Protected.h
//

#import "FetchedResultsController.h"

@class FetchedResultsControllerModel;

@interface FetchedResultsController (Protected)

@property (nonatomic) FetchedResultsControllerModel *mainThreadDataModel;

- (void)dispatchBlockOnBackgroundQueue:(dispatch_block_t)block;

- (void)_setObjects:(NSSet *)objects completion:(dispatch_block_t)completion;

- (void)_addObjects:(NSSet *)objects completion:(void(^)(void))completion;

@end
