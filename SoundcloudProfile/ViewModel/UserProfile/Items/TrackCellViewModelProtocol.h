//
//  TrackCellViewModelProtocol.h
//  SoundcloudProfile
//
//  Created by tstepanov on 20/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "ViewModelFactoryProtocol.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TrackCellViewModelProtocol <ViewModelFactoryProtocol>

@property (nonatomic, readonly, nullable) NSString *trackTitle;
@property (nonatomic, readonly, nullable) NSURL *artworkURL;
@property (nonatomic, readonly, nullable) NSString *trackLength;
@property (nonatomic, readonly, nullable) NSString *authorName;
@property (nonatomic, readonly, nullable) NSString *duration;

@end

NS_ASSUME_NONNULL_END
