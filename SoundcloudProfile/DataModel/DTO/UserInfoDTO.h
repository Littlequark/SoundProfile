//
//  UserInfoDTO.h
//  SoundcloudProfile
//
//  Created by tstepanov on 19/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoDTO : NSObject

@property (nonatomic) NSString *avatarURLString;
@property (nonatomic) NSNumber *userId;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *location;
@property (nonatomic) NSNumber *userTracksCount;
@property (nonatomic) NSNumber *favouritesCount;

@end

NS_ASSUME_NONNULL_END
