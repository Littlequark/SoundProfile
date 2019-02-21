//
//  UserProfileModel.h
//  SoundcloudProfile
//
//  Created by tstepanov on 20/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "UserProfileModelProtocol.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UsersServiceProtocol;

@interface UserProfileModel : NSObject <UserProfileModelProtocol>

@property (nonatomic) id<UsersServiceProtocol> userService;

@end

NS_ASSUME_NONNULL_END
