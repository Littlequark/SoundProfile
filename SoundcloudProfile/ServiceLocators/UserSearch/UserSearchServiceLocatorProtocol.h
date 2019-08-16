//
//  UserSearchServiceLocatorProtocol.h
//  SoundcloudProfile
//
//  Created by tstepanov on 21/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UserSearchViewModelProtocol;

@protocol UserSearchServiceLocatorProtocol <NSObject>

- (id<UserSearchViewModelProtocol>)userSearchViewModel;

@end

NS_ASSUME_NONNULL_END
