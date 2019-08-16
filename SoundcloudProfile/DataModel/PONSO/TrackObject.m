//
//  TrackObject.m
//  SoundcloudProfile
//
//  Created by tstepanov on 19/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "TrackObject.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TrackObject

- (id)copyWithZone:(NSZone *)zone {
    TrackObject *newInstance = [[self.class allocWithZone:zone] init];
    if (!newInstance) {
        return nil;
    }
    newInstance->_trackId = _trackId;
    newInstance->_userId = _userId;
    newInstance->_trackDescription = _trackDescription.copy;
    newInstance->_trackURIString = _trackURIString.copy;
    newInstance->_title = _title.copy;
    newInstance->_artworkURLString = _artworkURLString.copy;
    newInstance->_authorName = _authorName.copy;
    newInstance->_duration = _duration;
    return newInstance;
}

- (NSUInteger)hash {
    return self.trackId.hash;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    BOOL result = NO;
    if ([object isKindOfClass:TrackObject.class]) {
        result = [self isEqualToTrack:object];
    }
    return result;
}

- (BOOL)isEqualToTrack:(nonnull TrackObject *)other {
    return [self.trackId isEqualToNumber:other.trackId];
}

@end

NS_ASSUME_NONNULL_END
