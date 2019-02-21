//
//  TrackListDTO.h
//  SoundcloudProfile
//
//  Created by tstepanov on 19/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TrackDTO;

@interface TrackListDTO : NSObject

@property (nonatomic) NSString *nextPageURLString;
@property (nonatomic) NSArray<TrackDTO *> *tracksDTOList;

@end

NS_ASSUME_NONNULL_END
