//
//  UserProfileViewModelProtocol.h
//  SoundcloudProfile
//
//  Created by tstepanov on 20/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "CollectionViewModelProtocol.h"
#import "ErrorHandlerProtocol.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ErrorPresentationHandlerProtocol;

@protocol UserProfileViewModelProtocol <CollectionViewModelProtocol, ErrorHandlerProtocol>

@property (nonatomic, nullable) id<ErrorPresentationHandlerProtocol> errorHandler;

- (void)loadMoreIfPossible;

@end

NS_ASSUME_NONNULL_END
