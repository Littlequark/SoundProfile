//
//  TrackPonsomizer.h
//  SoundcloudProfile
//
//  Created by tstepanov on 21/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TrackObject;
@class TrackDTO;

@interface TrackPonsomizer : NSObject

+ (NSArray<TrackObject *> *)tracksFromTrackDTOs:(NSArray<TrackDTO *> *_Nullable)trackDTOs;

+ (TrackObject *_Nullable)trackFromTrackDTO:(TrackDTO *_Nullable)trackDTO;

@end

NS_ASSUME_NONNULL_END
