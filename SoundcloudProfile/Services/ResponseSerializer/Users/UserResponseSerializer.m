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

NS_ASSUME_NONNULL_BEGIN

@implementation UserResponseSerializer

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
    userInfoDTO.userId = responseDictionary[@"id"];
    userInfoDTO.firstName = responseDictionary[@"first_name"];
    userInfoDTO.lastName = responseDictionary[@"last_name"];
    userInfoDTO.avatarURLString = responseDictionary[@"avatar_url"];
    userInfoDTO.username = responseDictionary[@"username"];
    userInfoDTO.location = responseDictionary[@"city"];
    userInfoDTO.userTracksCount = responseDictionary[@"track_count"];
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
        trackListDTO.nextPageURLString = responseDictionary[@"next_href"];
        trackDictionaries = responseDictionary[@"collection"];
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
    trackDTO.trackId = trackDict[@"id"];
    trackDTO.userId = trackDict[@"user_id"];
    trackDTO.title = trackDict[@"title"];
    trackDTO.trackDescription = trackDict[@"description"];
    trackDTO.artworkURLString = trackDict[@"artwork_url"];
    trackDTO.authorName = trackDict[@"user"][@"username"];
    trackDTO.duration = trackDict[@"duration"];
    return trackDTO;
}

@end

NS_ASSUME_NONNULL_END
