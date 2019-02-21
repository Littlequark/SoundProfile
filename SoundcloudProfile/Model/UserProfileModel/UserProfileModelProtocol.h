//
//  UserProfileModelProtocol.h
//  SoundcloudProfile
//
//  Created by tstepanov on 20/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DataSource;
@protocol ErrorHandlerProtocol;

@protocol UserProfileModelProtocol <NSObject>

@property (nonatomic, nullable) id<ErrorHandlerProtocol> errorHandler;
@property (nonatomic, readonly) DataSource *userInfoDataSource;
@property (nonatomic, readonly) DataSource *tracksDataSource;

- (void)loadProfileInfo;

- (void)loadMoreIfPossible;

@end

NS_ASSUME_NONNULL_END
