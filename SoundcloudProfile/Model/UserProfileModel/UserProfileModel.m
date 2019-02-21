//
//  UserProfileModel.m
//  SoundcloudProfile
//
//  Created by tstepanov on 20/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "UserProfileModel.h"

#import "DataSource.h"
#import "UsersServiceProtocol.h"
#import "BasicDataSource.h"
#import "UserObject.h"
#import "TrackObject.h"
#import "UserInfoDTO.h"
#import "TrackDTO.h"
#import "TrackListDTO.h"
#import "NSIndexPath+DataSource.h"
#import "ErrorHandlerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserProfileModel()

@property (nonatomic) NSUInteger userTracksCount;
@property (nonatomic) NSTimer *refreshTimer;
@property (nonatomic, readwrite) BasicDataSource *userInfoDataSource;
@property (nonatomic, readwrite) BasicDataSource *tracksDataSource;


@end

NSString *const InspectedUserId =  @"249092";// Profile link - http://soundcloud.com/betsielarkin
const NSUInteger tracksPageSize = 50;
const NSTimeInterval UsersModelDataRefreshPeriod = 120.0; //2 mins

@implementation UserProfileModel

@synthesize userInfoDataSource = _userInfoDataSource;
@synthesize tracksDataSource = _tracksDataSource;
@synthesize errorHandler;

- (void)dealloc {
    [self stopTimer];
}

#pragma mark - UserProfileViewModel

- (DataSource *)userInfoDataSource {
    if (!_userInfoDataSource) {
        _userInfoDataSource = [[BasicDataSource alloc] init];
    }
    return _userInfoDataSource;
}

- (BasicDataSource *)tracksDataSource {
    if(!_tracksDataSource) {
        _tracksDataSource = [[BasicDataSource alloc] init];
    }
    return _tracksDataSource;
}

- (void)loadProfileInfo {
    [self dropState];
    [self startRefreshTimerIfNeeded];
    __block UserObject *user;
    __block NSArray<TrackObject *> *tracks;
    __block NSUInteger initialTracksCount;
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_enter(dispatchGroup);
    [self.userService loadInfoForUserWithId:InspectedUserId
                                 completion:^(UserInfoDTO * _Nullable userInfoDTO, NSError * _Nullable error) {
                                     if (userInfoDTO != nil) {
                                         initialTracksCount = userInfoDTO.userTracksCount.unsignedIntegerValue;
                                         user = [self userFromUserInfoDTO:userInfoDTO];
                                         dispatch_group_leave(dispatchGroup);
                                     }
                                     else if (error != nil) {
                                         [self handleError:error];
                                     }
                                 }];
    dispatch_group_enter(dispatchGroup);
    [self.userService loadTracksForUserWithId:InspectedUserId
                                       offset:0
                                       length:tracksPageSize
                                    competion:^(TrackListDTO * _Nullable trackListDTO, NSError * _Nullable error) {
                                        if (trackListDTO != nil){
                                            tracks = [self tracksFromTrackDTOs:trackListDTO.tracksDTOList];
                                            dispatch_group_leave(dispatchGroup);
                                        }
                                        else if (error != nil) {
                                            [self handleError:error];
                                        }
                                    }];
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
        self.userTracksCount = initialTracksCount;
        [self handleInitialTracks:tracks];
        [self handleUser:user];
    });
}

- (void)loadMoreIfPossible {
    NSUInteger currentTracksAmount = [self.tracksDataSource numberOfItemsInSection:0];
    BOOL hasMoreTracks = currentTracksAmount < self.userTracksCount;
    if (hasMoreTracks) {
        [self.userService loadTracksForUserWithId:InspectedUserId
                                           offset:currentTracksAmount
                                           length:tracksPageSize
                                        competion:^(TrackListDTO * _Nullable trackListDTO, NSError * _Nullable error) {
                                            if (trackListDTO != nil){
                                                NSArray<TrackObject *> *tracks = [self tracksFromTrackDTOs:trackListDTO.tracksDTOList];
                                                [self handleMoreTracks:tracks];
                                            }
                                            else if (error != nil) {
                                                [self handleError:error];
                                            }
                                        }];
    }
}

#pragma mark - Private

- (void)startRefreshTimerIfNeeded {
    if (!self.refreshTimer.isValid) {
        [self startRefreshTimer];
    }
}

- (void)startRefreshTimer {
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:UsersModelDataRefreshPeriod
                                                         target:self
                                                       selector:@selector(loadProfileInfo)
                                                       userInfo:nil
                                                        repeats:YES];
}

- (void)stopTimer {
    [self.refreshTimer invalidate];
}

- (void)dropState {
    self.userTracksCount = 0;
}

- (void)handleUser:(UserObject *)user {
    if ([self.userInfoDataSource numberOfItemsInSection:0] == 0) {
        self.userInfoDataSource.items = @[user];
    }
    else {
        [self notifyModel:user didUpdateInDataSource:self.userInfoDataSource];
    }
}

- (void)handleTracks:(NSArray<TrackObject *> *)tracks {
    NSUInteger containedTrackscount = [self.tracksDataSource numberOfItemsInSection:0];
    if (containedTrackscount == 0) {
        [self handleInitialTracks:tracks];
    }
    else {
        [self handleMoreTracks:tracks];
    }
}

- (void)handleInitialTracks:(NSArray<TrackObject *> *)tracks {
    self.tracksDataSource.items = tracks;
}

- (void)handleMoreTracks:(NSArray<TrackObject *> *)tracks {
    NSUInteger containedTrackscount = [self.tracksDataSource numberOfItemsInSection:0];
    NSRange indexRange = NSMakeRange(containedTrackscount, tracks.count);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:indexRange];
    [self.tracksDataSource insertItems:tracks atIndexes:indexSet];
}


- (void)notifyModel:(id)model didUpdateInDataSource:(BasicDataSource *)dataSource {
    NSIndexPath *indexPath = [dataSource indexPathsForItem:model].lastObject;
    if (indexPath) {
        NSUInteger index = indexPath.sp_item;
        [dataSource replaceItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] withItems:@[model]];
    }
}

- (void)handleError:(NSError *)error {
    if ([self.errorHandler respondsToSelector:@selector(handleError:)]) {
        [self.errorHandler handleError:error];
    }
}

//FIXME: - Move to object constructors

- (UserObject *)userFromUserInfoDTO:(UserInfoDTO *)userInfoDTO {
    UserObject *user = [[UserObject alloc] init];
    user.avatarURLString = userInfoDTO.avatarURLString;
    user.userId = userInfoDTO.userId;
    user.firstName = userInfoDTO.firstName;
    user.lastName = userInfoDTO.lastName;
    user.username = userInfoDTO.username;
    user.location = userInfoDTO.location;
    return user;
}

- (NSArray<TrackObject *> *)tracksFromTrackDTOs:(NSArray<TrackDTO *> *)trackDTOs {
    NSMutableArray<TrackObject *> *tracks = NSMutableArray.array;
    for (TrackDTO *trackDTO in trackDTOs) {
        TrackObject *track = [self trackFromTrackDTO:trackDTO];
        [tracks addObject:track];
    }
    return tracks.copy;
}

- (TrackObject *)trackFromTrackDTO:(TrackDTO *)trackDTO {
    TrackObject *track = [[TrackObject alloc] init];
    track.trackId = trackDTO.trackId;
    track.userId = trackDTO.userId;
    track.trackDescription = trackDTO.trackDescription;
    track.title = trackDTO.title;
    track.artworkURLString = trackDTO.artworkURLString;
    track.trackURIString = trackDTO.trackURIString;
    track.duration = trackDTO.duration;
    track.authorName = trackDTO.authorName;
    return track;
}

@end

NS_ASSUME_NONNULL_END
