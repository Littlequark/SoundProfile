//
//  UserSearchServiceLocator.m
//  SoundcloudProfile
//
//  Created by tstepanov on 21/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "UserSearchServiceLocator.h"
#import "UserSearchViewModel.h"
#import "UserSearchModel.h"
#import "UserServiceServiceLocator.h"
#import "UserProfileServiceLocator.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UserSearchServiceLocator

- (id<UserSearchViewModelProtocol>)userSearchViewModel {
    UserSearchViewModel *userSearchViewModel = [[UserSearchViewModel alloc] init];
    userSearchViewModel.model = self.userSearchModel;
    userSearchViewModel.userProfileServiceLocator = [[UserProfileServiceLocator alloc] init];
    return userSearchViewModel;
}

#pragma mark - Private

- (id<UserSearchModelProtocol>)userSearchModel {
    UserSearchModel *model = [[UserSearchModel alloc] init];
    model.usersService = self.userService;
    return model;
}

- (id<UsersServiceProtocol>)userService {
    UserServiceServiceLocator *serviceLocator = [[UserServiceServiceLocator alloc] init];
    return serviceLocator.userService;
}


@end

NS_ASSUME_NONNULL_END
