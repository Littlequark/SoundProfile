//
//  UserSearchViewModelProtocol.h
//  SoundcloudProfile
//
//  Created by tstepanov on 21/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UserProfileViewModelProtocol;
@protocol ErrorPresentationHandlerProtocol;

@protocol UserSearchViewModelProtocol <SearchViewModelProtocol>

@property (nonatomic, nullable) id<ErrorPresentationHandlerProtocol> errorHandler;

- (id<UserProfileViewModelProtocol> _Nullable)profileViewModelForUserAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
