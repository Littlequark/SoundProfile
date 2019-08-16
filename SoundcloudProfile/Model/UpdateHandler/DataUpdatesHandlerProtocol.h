//
//  DataUpdatesHandlerProtocol.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DataUpdatesHandlerProtocol <NSObject>

- (void)handleInsertedObjects:(NSSet *)objects;

- (void)handleDeletedObjects:(NSSet *)objects;

- (void)handleUpdatedObjects:(NSSet *)objects;

@end

NS_ASSUME_NONNULL_END
