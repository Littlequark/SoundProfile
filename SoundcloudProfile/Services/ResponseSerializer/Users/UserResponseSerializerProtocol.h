//
//  UserResponseSerializerProtocol.h
//  SoundcloudProfile
//
//  Created by tstepanov on 19/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UserInfoDTO;
@class TrackListDTO;

@protocol UserResponseSerializerProtocol <NSObject>

- (UserInfoDTO *_Nullable)serializeUserInfoFromResponse:(id)response;

- (TrackListDTO *_Nullable)serializeUserTrackListFromResponse:(id)response;

@end

NS_ASSUME_NONNULL_END
