//
//  TrackPonsomizer.m
//  SoundcloudProfile
//
//  Created by tstepanov on 21/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "TrackPonsomizer.h"
#import "TrackObject.h"
#import "TrackDTO.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TrackPonsomizer

+ (NSArray<TrackObject *> *)tracksFromTrackDTOs:(NSArray<TrackDTO *> *_Nullable)trackDTOs {
    NSMutableArray<TrackObject *> *tracks = [[NSMutableArray<TrackObject *> alloc] init];
    for (TrackDTO *trackDTO in trackDTOs) {
        TrackObject *user = [self trackFromTrackDTO:trackDTO];
        if (user != nil) {
            [tracks addObject:user];
        }
    }
    return tracks.copy;
}

+ (TrackObject *_Nullable)trackFromTrackDTO:(TrackDTO *_Nullable)trackDTO {
    if (!trackDTO) {
        ///ParameterAssert
        return nil;
    }
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
