//
//  TrackTableViewCell.m
//  SoundcloudProfile
//
//  Created by tstepanov on 20/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "TrackTableViewCell.h"
#import "TrackCellViewModelProtocol.h"
#import <SDWebImage/UIImageView+WebCache.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrackTableViewCell()

@property (nonatomic, weak) IBOutlet UILabel *trackNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *authorNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *durationLabel;
@property (nonatomic, weak) IBOutlet UIImageView *artworkImageView;

@end

@implementation TrackTableViewCell

- (void)setViewModel:(id<TrackCellViewModelProtocol>)viewModel {
    _viewModel = viewModel;
    self.trackNameLabel.text = _viewModel.trackTitle;
    self.authorNameLabel.text = _viewModel.authorName;
    self.durationLabel.text = _viewModel.duration;
    [self.artworkImageView sd_setImageWithURL:_viewModel.artworkURL];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.artworkImageView sd_cancelCurrentAnimationImagesLoad];
}

@end

NS_ASSUME_NONNULL_END
