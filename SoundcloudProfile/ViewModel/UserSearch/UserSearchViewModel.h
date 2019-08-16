//
//  UserSearchViewModel.h
//  SoundcloudProfile
//
//  Created by tstepanov on 21/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "CollectionViewModel.h"
#import "UserSearchViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UserSearchModelProtocol;
@protocol UserProfileServiceLocatorProtocol;

@interface UserSearchViewModel : CollectionViewModel <UserSearchViewModelProtocol>

@property (nonatomic) id<UserSearchModelProtocol> model;
@property (nonatomic) id<UserProfileServiceLocatorProtocol> userProfileServiceLocator;

@end

NS_ASSUME_NONNULL_END
