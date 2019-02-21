//
//  UsersService.m
//  SoundcloudProfile
//
//  Created by tstepanov on 19/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "UsersService.h"
#import "NetworkClientProtocol.h"
#import "UserResponseSerializerProtocol.h"
#import "UserRequestSerializerProtocol.h"
#import "UserObject.h"
#import "UserInfoDTO.h"
#import "TrackListDTO.h"
#import "SafeBlock.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UsersService

- (void)loadInfoForUserWithId:(NSString *)userId
                   completion:(UserServiceUserInfoCompletionBlock)completion {
    NSDictionary *parameters = [self.requestSerialiser serializeUserInfoForUserId:userId];
    NSString *path = [NSString stringWithFormat:@"users/%@", userId];
    [self.networkClient performRequestToPath:path parameters:parameters completion:^(id  _Nullable response, NSError * _Nullable error) {
        if (response != nil){
            UserInfoDTO *userInfoDTO = [self.responseSerializer serializeUserInfoFromResponse:response];
            safe_block_exec(completion, userInfoDTO, nil);
        }
        else if (error != nil) {
            safe_block_exec(completion, nil, error);
        }
    }];
}

- (void)loadTracksForUserWithId:(NSString *)userId
                         offset:(NSUInteger)offset
                         length:(NSUInteger)length
                      competion:(UserServiceTrackListCompletionBlock)completion {
    NSString *path = [NSString stringWithFormat:@"users/%@/tracks", userId];
    NSDictionary *parameters = [self.requestSerialiser serializeTracksWithOffset:offset length:length];
    [self.networkClient performRequestToPath:path parameters:parameters completion:^(id  _Nullable response, NSError * _Nullable error) {
        if (response != nil){
            NSLog(@"tacks list response: %@", response);
            TrackListDTO *trackListDTO = [self.responseSerializer serializeUserTrackListFromResponse:response];
            safe_block_exec(completion, trackListDTO, nil);
        }
        else if (error != nil) {
            safe_block_exec(completion, nil, error);
        }
    }];
}

@end

NS_ASSUME_NONNULL_END
