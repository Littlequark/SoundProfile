//
//  TrackObject.h
//  SoundcloudProfile
//
//  Created by tstepanov on 19/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrackObject : NSObject

@property (nonatomic) NSString *trackURIString;
@property (nonatomic) NSNumber *trackId;
@property (nonatomic) NSNumber *userId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *trackDescription;
@property (nonatomic) NSString *artworkURLString;
@property (nonatomic) NSString *authorName;
@property (nonatomic) NSNumber *duration;

@end

NS_ASSUME_NONNULL_END
