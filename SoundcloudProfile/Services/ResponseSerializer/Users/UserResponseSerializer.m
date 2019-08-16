//
//  UserResponseSerializer.m
//  SoundcloudProfile
//
//  Created by tstepanov on 19/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "UserResponseSerializer.h"
#import "UserInfoDTO.h"
#import "TrackDTO.h"
#import "TrackListDTO.h"
#import "Defines.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UserResponseSerializer

- (NSArray<UserInfoDTO *> *)serializeUserDTOsFromResponse:(id)response {
    if (![response isKindOfClass:NSArray.class]) {
        ////ParameterAssertLog
        return @[];
    }
    NSArray<NSDictionary *> *userDictionaries = (NSArray<NSDictionary *> *)response;
    NSMutableArray<UserInfoDTO *> *userDTOs = [[NSMutableArray<UserInfoDTO *> alloc] init];
    for (NSDictionary *userDictionary in userDictionaries) {
        UserInfoDTO *userInfoDTO = [self serializeUserInfoFromResponse:userDictionary];
        if (userInfoDTO != nil) {
            [userDTOs addObject:userInfoDTO];
        }
    }
    return userDTOs.copy;
}

- (UserInfoDTO *_Nullable)serializeUserInfoFromResponse:(id)response {
    if (![response isKindOfClass:NSDictionary.class]) {
        ////ParameterAssertLog
        return nil;
    }
    NSDictionary *responseDictionary = (NSDictionary *)response;
    if (![responseDictionary[@"kind"] isEqualToString:@"user"]) {
        ////ParameterLog
        return nil;
    }
    UserInfoDTO *userInfoDTO = [[UserInfoDTO alloc] init];
    userInfoDTO.userId = ObjectOrNilForKey(responseDictionary, @"id");
    userInfoDTO.firstName = ObjectOrNilForKey(responseDictionary, @"first_name");
    userInfoDTO.lastName = ObjectOrNilForKey(responseDictionary, @"last_name");
    userInfoDTO.avatarURLString = ObjectOrNilForKey(responseDictionary ,@"avatar_url");
    userInfoDTO.username = ObjectOrNilForKey(responseDictionary, @"username");
    userInfoDTO.location = ObjectOrNilForKey(responseDictionary, @"city");
    userInfoDTO.userTracksCount = ObjectOrNilForKey(responseDictionary, @"track_count");
    userInfoDTO.favouritesCount = ObjectOrNilForKey(responseDictionary, @"public_favorites_count");
    return userInfoDTO;
}

- (TrackListDTO *_Nullable)serializeUserTrackListFromResponse:(id)response {
    if (![response isKindOfClass:NSArray.class] && ![response isKindOfClass:NSDictionary.class]) {
        ////ParameterAssertLog
        return nil;
    }
    TrackListDTO *trackListDTO = [[TrackListDTO alloc] init];
    NSArray<NSDictionary *> *trackDictionaries;
    if ([response isKindOfClass:NSArray.class]) {
        trackDictionaries = (NSArray<NSDictionary *> *)response;
    }
    if ([response isKindOfClass:NSDictionary.class]) {
        NSDictionary *responseDictionary = (NSDictionary *)response;
        trackListDTO.nextPageURLString = ObjectOrNilForKey(responseDictionary, @"next_href");
        trackDictionaries = ObjectOrNilForKey(responseDictionary, @"collection");
    }
    trackListDTO.tracksDTOList = [self trackDTOsFromDictionaries:trackDictionaries];
    return trackListDTO;
}

#pragma mark - Private

- (NSArray<TrackDTO *> *_Nullable)trackDTOsFromDictionaries:(NSArray<NSDictionary *> *)dictionaries {
    if (dictionaries.count == 0) {
        ////ParameterLog
        return nil;
    }
    NSMutableArray<TrackDTO *> *trackDTOs = NSMutableArray.array;
    for (NSDictionary *trackDict in dictionaries) {
        TrackDTO *trackDTO = [self trackDTOFromDictionary:trackDict];
        [trackDTOs addObject:trackDTO];
    }
    return trackDTOs.copy;
}

- (TrackDTO *_Nullable)trackDTOFromDictionary:(NSDictionary *)trackDict {
    if (![trackDict[@"kind"] isEqualToString:@"track"]) {
        ////ParameterLog
        return nil;
    }
    TrackDTO *trackDTO = [[TrackDTO alloc] init];
    trackDTO.trackId = ObjectOrNilForKey(trackDict, @"id");
    trackDTO.userId = ObjectOrNilForKey(trackDict, @"user_id");
    trackDTO.title = ObjectOrNilForKey(trackDict, @"title");
    trackDTO.trackDescription = ObjectOrNilForKey(trackDict, @"description");
    trackDTO.artworkURLString = ObjectOrNilForKey(trackDict, @"artwork_url");
    trackDTO.authorName = ObjectOrNilForKey(ObjectOrNilForKey(trackDict, @"user"), @"username");
    trackDTO.duration = ObjectOrNilForKey(trackDict, @"duration");
    return trackDTO;
}

@end

NS_ASSUME_NONNULL_END
