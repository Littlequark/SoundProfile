//
//  UserInfoTableViewCell.m
//  SoundcloudProfile
//
//  Created by tstepanov on 20/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "UserInfoTableViewCell.h"
#import "UserInfoCellViewModelProtocol.h"
#import <SDWebImage/UIImageView+WebCache.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoTableViewCell()

@property (nonatomic, weak) IBOutlet UILabel *primaryLabel;
@property (nonatomic, weak) IBOutlet UILabel *secondaryLabel;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;

@end

@implementation UserInfoTableViewCell

- (void)setViewModel:(id<UserInfoCellViewModelProtocol>)viewModel {
    _viewModel = viewModel;
    self.primaryLabel.text = _viewModel.username;
    self.secondaryLabel.text = _viewModel.location;
    [self.avatarImageView sd_setImageWithURL:_viewModel.avatarURL];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.avatarImageView sd_cancelCurrentAnimationImagesLoad];
}

@end

NS_ASSUME_NONNULL_END
