//
//  UserRequestSerializer.m
//  SoundcloudProfile
//
//  Created by tstepanov on 19/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "UserRequestSerializer.h"

@implementation UserRequestSerializer

- (NSDictionary *)serializeUserInfoForUserId:(NSString *)userId {
    // no arguments required
    return nil;
}

- (NSDictionary *)serializeTracksWithOffset:(NSUInteger)offset length:(NSUInteger)length {
    return @{@"offset":@(offset), @"length":@(length)};
}

@end
