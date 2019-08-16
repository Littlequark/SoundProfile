//
//  UserInfoCellViewModelProtocol.h
//  SoundcloudProfile
//
//  Created by tstepanov on 20/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "ViewModelFactoryProtocol.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UserInfoCellViewModelProtocol <ViewModelFactoryProtocol>

@property (nonatomic, readonly, nullable) NSString *username;
@property (nonatomic, readonly, nullable) NSString *fullName;
@property (nonatomic, readonly, nullable) NSString *city;
@property (nonatomic, readonly, nullable) NSURL *avatarURL;

@end

NS_ASSUME_NONNULL_END
