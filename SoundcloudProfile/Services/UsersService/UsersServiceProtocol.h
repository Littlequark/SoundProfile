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

typedef void (^UserServiceUserInfoCompletionBlock)(UserInfoDTO *_Nullable userInfoDTO, NSError *_Nullable error);
typedef void (^UserServiceUsersCompletionBlock)(NSArray<UserInfoDTO *> *_Nullable userInfoDTOs, NSError *_Nullable error);
typedef void (^UserServiceTrackListCompletionBlock)(id _Nullable trackList, NSError *_Nullable error);


@protocol UsersServiceProtocol <NSObject>

- (void)loadInfoForUserWithId:(NSNumber *)userId
                   completion:(UserServiceUserInfoCompletionBlock)completion;

- (void)loadTracksForUserWithId:(NSNumber *)userId
                         offset:(NSUInteger)offset
                         length:(NSUInteger)length
                      competion:(UserServiceTrackListCompletionBlock)completion;

- (void)searchUsersWithText:(NSString *_Nullable)searchText
                     offset:(NSUInteger)offset
                     length:(NSUInteger)length
                  competion:(UserServiceUsersCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
