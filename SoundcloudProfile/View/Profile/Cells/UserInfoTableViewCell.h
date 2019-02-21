//
//  UserInfoTableViewCell.h
//  SoundcloudProfile
//
//  Created by tstepanov on 20/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "ConfigurableCellProtocol.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UserInfoCellViewModelProtocol;

@interface UserInfoTableViewCell : UITableViewCell <ConfigurableCellProtocol>

@property (nonatomic) id<UserInfoCellViewModelProtocol> viewModel;

@end

NS_ASSUME_NONNULL_END
