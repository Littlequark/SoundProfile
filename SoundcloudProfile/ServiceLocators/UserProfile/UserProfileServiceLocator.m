//
//  UserProfileServiceLocator.m
//  SoundcloudProfile
//
//  Created by tstepanov on 20/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "UserProfileServiceLocator.h"
#import "UserProfileViewModel.h"
#import "UserProfileModel.h"
#import "UserServiceServiceLocator.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UserProfileServiceLocator

- (id<UserProfileViewModelProtocol>)userProfileViewModel {
    UserProfileViewModel *userProfileViewModel = [[UserProfileViewModel alloc] init];
    userProfileViewModel.model = self.userProfileModel;
    return userProfileViewModel;
}

#pragma mark - Private

- (id<UserProfileModelProtocol>)userProfileModel {
    UserProfileModel *model = [[UserProfileModel alloc] init];
    model.userService = self.userService;
    return model;
}

- (id<UsersServiceProtocol>)userService {
    UserServiceServiceLocator *serviceLocator = [[UserServiceServiceLocator alloc] init];
    return serviceLocator.userService;
}

@end

NS_ASSUME_NONNULL_END
