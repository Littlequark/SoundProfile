//
//  UserRequestSerializerProtocol.h
//  SoundcloudProfile
//
//  Created by tstepanov on 19/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UserRequestSerializerProtocol <NSObject>

- (NSDictionary *_Nullable)serializeUserInfoForUserId:(NSString *)userId;

- (NSDictionary *)serializeTracksWithOffset:(NSUInteger)offset length:(NSUInteger)length;

@end

NS_ASSUME_NONNULL_END
