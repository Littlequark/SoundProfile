//
//  FilteringViewModelProtocol.h
//  SoundcloudProfile
//
//  Created by tstepanov on 22/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FilteringViewModelProtocol <NSObject>

@property (nonatomic, nullable) NSString *filterPatterns;

@end

NS_ASSUME_NONNULL_END
