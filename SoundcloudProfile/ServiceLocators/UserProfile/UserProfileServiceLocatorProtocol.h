//
//  UserProfileServiceLocatorProtocol.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UserObject;
@protocol UserProfileViewModelProtocol;

@protocol UserProfileServiceLocatorProtocol <NSObject>

- (id<UserProfileViewModelProtocol>)profileViewModelForUser:(UserObject *)user;

@end

NS_ASSUME_NONNULL_END
