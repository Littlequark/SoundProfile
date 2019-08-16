//
//  UserSearchViewController.h
//  SoundcloudProfile
//
//  Created by tstepanov on 21/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "CommonTableViewController.h"
#import "UserSearchViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserSearchViewController : CommonTableViewController

@property (nonatomic) id<UserSearchViewModelProtocol> viewModel;

@end

NS_ASSUME_NONNULL_END
