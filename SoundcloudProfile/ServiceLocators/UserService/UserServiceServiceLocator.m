//
//  UserServiceServiceLocator.m
//  SoundcloudProfile
//
//  Created by tstepanov on 19/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "UserServiceServiceLocator.h"

#import "UsersService.h"
#import "NetworkClient.h"
#import "UserRequestSerializer.h"
#import "UserResponseSerializer.h"

@implementation UserServiceServiceLocator

- (id<UsersServiceProtocol>)userService {
    UsersService *usersService = [[UsersService alloc] init];
    usersService.networkClient = self.networkClient;
    usersService.requestSerialiser = self.requestSerializer;
    usersService.responseSerializer = self.responseSerializer;
    return usersService;
}

#pragma mark - Private

- (id<NetworkClientProtocol>)networkClient {
    return [[NetworkClient alloc] init];
}

- (id<UserRequestSerializerProtocol>)requestSerializer {
    return [[UserRequestSerializer alloc] init];
}

- (id<UserResponseSerializerProtocol>)responseSerializer {
    return [[UserResponseSerializer alloc] init];
}

@end
