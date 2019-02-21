//
//  UsersServiceProtocol.h
//  SoundcloudProfile
//
//  Created by tstepanov on 19/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class TrackListDTO;
@class UserInfoDTO;

typedef void (^UserServiceUserInfoCompletionBlock)(UserInfoDTO *_Nullable userinfoDTO, NSError *_Nullable error);
typedef void (^UserServiceTrackListCompletionBlock)(id _Nullable trackList, NSError *_Nullable error);

@protocol UsersServiceProtocol <NSObject>

- (void)loadInfoForUserWithId:(NSString *)userId
                   completion:(UserServiceUserInfoCompletionBlock)completion;

- (void)loadTracksForUserWithId:(NSString *)userId
                         offset:(NSUInteger)offset
                         length:(NSUInteger)length
                      competion:(UserServiceTrackListCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
