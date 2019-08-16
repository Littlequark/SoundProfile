//
//  UserRequestSerializer.m
//  SoundcloudProfile
//
//  Created by tstepanov on 19/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "UserRequestSerializer.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UserRequestSerializer

- (NSDictionary *_Nullable)serializeUserInfoForUserId:(NSString *)userId {
    // no arguments required
    return nil;
}

- (NSDictionary *)serializeTracksWithOffset:(NSUInteger)offset length:(NSUInteger)length {
    return @{@"offset":@(offset), @"length":@(length)};
}

- (NSDictionary *)serializeSearchUsersWithText:(NSString *_Nullable)searchText offset:(NSUInteger)offset length:(NSUInteger)length {
    NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
    parameters[@"offset"] = @(offset);
    parameters[@"length"] = @(length);
    if (searchText != nil) {
        parameters[@"q"] = searchText;
    }
    return parameters;
}

@end

NS_ASSUME_NONNULL_END
