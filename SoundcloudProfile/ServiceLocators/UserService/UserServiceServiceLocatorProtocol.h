//
//  UserServiceServiceLocatorProtocol.h
//  SoundcloudProfile
//
//  Created by tstepanov on 19/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UsersServiceProtocol;

@protocol UserServiceServiceLocatorProtocol <NSObject>

- (id<UsersServiceProtocol>)userService;

@end

NS_ASSUME_NONNULL_END
