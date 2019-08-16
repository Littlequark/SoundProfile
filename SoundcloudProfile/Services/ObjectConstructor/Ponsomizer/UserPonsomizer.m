//
//  UserPonsomizer.m
//  SoundcloudProfile
//
//  Created by tstepanov on 21/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "UserPonsomizer.h"
#import "UserObject.h"
#import "UserInfoDTO.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UserPonsomizer

+ (NSArray<UserObject *> *)usersFromUserDTOs:(NSArray<UserInfoDTO *> *_Nullable)userDTOs {
    NSMutableArray<UserObject *> *users = [[NSMutableArray<UserObject *> alloc] init];
    for (UserInfoDTO *userDTO in userDTOs) {
        UserObject *user = [self userFromUserDTO:userDTO];
        if (user != nil) {
            [users addObject:user];
        }
    }
    return users.copy;
}

+ (UserObject *_Nullable)userFromUserDTO:(UserInfoDTO *_Nullable)userInfoDTO {
    if (!userInfoDTO) {
        ///ParameterAssert
        return nil;
    }
    UserObject *user = [[UserObject alloc] init];
    user.avatarURLString = userInfoDTO.avatarURLString;
    user.userId = userInfoDTO.userId;
    user.firstName = userInfoDTO.firstName;
    user.lastName = userInfoDTO.lastName;
    user.username = userInfoDTO.username;
    user.city = userInfoDTO.location;
    return user;
}

@end

NS_ASSUME_NONNULL_END
