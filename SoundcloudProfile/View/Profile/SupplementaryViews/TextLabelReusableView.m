//
//  TextLabelReusableView.m
//  SoundcloudProfile
//
//  Created by tstepanov on 21/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "TextLabelReusableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TextLabelReusableView()

@property (nonatomic, readwrite) IBOutlet UILabel *displayTextLabel;

@end

@implementation TextLabelReusableView

- (void)setDisplayString:(NSString *)displayString {
    _displayString = displayString;
    self.displayTextLabel.text = _displayString;
}

@end

NS_ASSUME_NONNULL_END
