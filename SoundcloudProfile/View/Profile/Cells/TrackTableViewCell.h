//
//  TrackTableViewCell.h
//  SoundcloudProfile
//
//  Created by tstepanov on 20/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "ConfigurableCellProtocol.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TrackCellViewModelProtocol;

@interface TrackTableViewCell : UITableViewCell <ConfigurableCellProtocol>

@property (nonatomic) id<TrackCellViewModelProtocol> viewModel;

@end

NS_ASSUME_NONNULL_END
