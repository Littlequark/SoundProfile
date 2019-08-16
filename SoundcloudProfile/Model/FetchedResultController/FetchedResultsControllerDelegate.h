//
//  FetchedResultsControllerDelegate.h
//

#import <Foundation/Foundation.h>

@class FetchedResultsController;
@protocol FetchedResultsSectionInfoProtocol;

@protocol FetchedResultsControllerDelegate <NSObject>

typedef NS_ENUM(NSUInteger, FetchedResultsChangeType) {
    FetchedResultsChangeInsert = 1, // NSFetchedResultsChangeInsert,
    FetchedResultsChangeDelete = 2, // NSFetchedResultsChangeDelete,
    FetchedResultsChangeMove = 3, // NSFetchedResultsChangeMove,
    FetchedResultsChangeUpdate = 4, //NSFetchedResultsChangeUpdate
    
};

/* Notifies the delegate that a fetched object has been changed due to an add, remove, move, or update. Enables NSFetchedResultsController change tracking.
	controller - controller instance that noticed the change on its fetched objects
	anObject - changed object
	indexPath - indexPath of changed object (nil for inserts)
	type - indicates if the change was an insert, delete, move, or update
	newIndexPath - the destination path for inserted or moved objects, nil otherwise
	
	Changes are reported with the following heuristics:
 
	On Adds and Removes, only the Added/Removed object is reported. It's assumed that all objects that come after the affected object are also moved, but these moves are not reported.
	The Move object is reported when the changed attribute on the object is one of the sort descriptors used in the fetch request.  An update of the object is assumed in this case, but no separate update message is sent to the delegate.
	The Update object is reported when an object's state changes, and the changed attributes aren't part of the sort keys.
 */
@optional
- (void)sp_controller:(nonnull FetchedResultsController *)controller didChangeObject:(nonnull id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(FetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath;

/* Notifies the delegate of added or removed sections.  Enables NSFetchedResultsController change tracking.
 
	controller - controller instance that noticed the change on its sections
	sectionInfo - changed section
	index - index of changed section
	type - indicates if the change was an insert or delete
 
	Changes on section info are reported before changes on fetchedObjects.
 */
@optional
- (void)sp_controller:(nonnull FetchedResultsController *)controller didChangeSection:(nonnull id<FetchedResultsSectionInfoProtocol>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(FetchedResultsChangeType)type;

/* Notifies the delegate that section and object changes are about to be processed and notifications will be sent.  Enables NSFetchedResultsController change tracking.
 Clients utilizing a UITableView may prepare for a batch of updates by responding to this method with -beginUpdates
 */
@optional
- (void)sp_controllerWillChangeContent:(nonnull FetchedResultsController *)controller;

/* Notifies the delegate that all section and object changes have been sent. Enables NSFetchedResultsController change tracking.
 Providing an empty implementation will enable change tracking if you do not care about the individual callbacks.
 */
@optional
- (void)sp_controllerDidChangeContent:(nonnull FetchedResultsController *)controller;

@end
