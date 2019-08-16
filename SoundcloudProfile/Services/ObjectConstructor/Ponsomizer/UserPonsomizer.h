//
//  UserPonsomizer.h
//  SoundcloudProfile
//
//  Created by tstepanov on 21/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UserObject;
@class UserInfoDTO;

@interface UserPonsomizer : NSObject

+ (NSArray<UserObject *> *)usersFromUserDTOs:(NSArray<UserInfoDTO *> *_Nullable)userDTOs;

+ (UserObject *_Nullable)userFromUserDTO:(UserInfoDTO *_Nullable)userInfoDTO;

@end

NS_ASSUME_NONNULL_END
