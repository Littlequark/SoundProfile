//
//  UserProfileViewModel.h
//  SoundcloudProfile
//
//  Created by tstepanov on 20/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "CollectionViewModel.h"
#import "UserProfileViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UserProfileModelProtocol;

@interface UserProfileViewModel : CollectionViewModel <UserProfileViewModelProtocol>

@property (nonatomic) id<UserProfileModelProtocol> model;

@end

NS_ASSUME_NONNULL_END
