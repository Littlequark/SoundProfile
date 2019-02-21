//
//  UIViewController+ErrorHandling.m
//  SoundcloudProfile
//
//  Created by tstepanov on 20/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "UIViewController+ErrorHandling.h"
#import "UIView+GentleShowAndDismiss.h"

NS_ASSUME_NONNULL_BEGIN

const CGFloat errorMessageHeight = 20.0;
const NSTimeInterval ErrorPresentationDuration = 2.0;

@implementation UIViewController (ErrorHandling)

- (void)handleErrorWithDescription:(NSString *)errorDescription {
    UILabel *errorLabel = [self errorLabelWithMessage:errorDescription];
    errorLabel.backgroundColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.9 alpha:1.0];
    [errorLabel showInView:self.view completion:^{
        dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ErrorPresentationDuration * NSEC_PER_SEC));
        dispatch_after(when, dispatch_get_main_queue(), ^{
            [errorLabel dismiss];
        });
    }];
}

- (UILabel *)errorLabelWithMessage:(NSString *)message {
    UILabel *errorLabel = [[UILabel alloc] initWithFrame:self.frameForErrorView];
    errorLabel.font = [UIFont systemFontOfSize:13.0];
    errorLabel.textColor = UIColor.darkGrayColor;
    errorLabel.textAlignment = NSTextAlignmentCenter;
    errorLabel.text = message;
    return errorLabel;
}

- (CGRect)frameForErrorView {
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    CGFloat yPosition = navBarFrame.origin.y + CGRectGetHeight(navBarFrame);
    return CGRectMake(0.0, yPosition, CGRectGetWidth(navBarFrame), errorMessageHeight);
}

@end

NS_ASSUME_NONNULL_END
