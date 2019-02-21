//
//  UsersService.h
//  SoundcloudProfile
//
//  Created by tstepanov on 19/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "UsersServiceProtocol.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UserResponseSerializerProtocol;
@protocol UserRequestSerializerProtocol;
@protocol NetworkClientProtocol;

@interface UsersService: NSObject<UsersServiceProtocol>

@property (nonatomic) id<UserRequestSerializerProtocol> requestSerialiser;
@property (nonatomic) id<UserResponseSerializerProtocol> responseSerializer;
@property (nonatomic) id<NetworkClientProtocol> networkClient;

@end

NS_ASSUME_NONNULL_END
