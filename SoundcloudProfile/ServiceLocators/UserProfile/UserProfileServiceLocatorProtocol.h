//
//  UserProfileServiceLocatorProtocol.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UserProfileViewModelProtocol;

@protocol UserProfileServiceLocatorProtocol <NSObject>

- (id<UserProfileViewModelProtocol>)userProfileViewModel;

@end

NS_ASSUME_NONNULL_END
