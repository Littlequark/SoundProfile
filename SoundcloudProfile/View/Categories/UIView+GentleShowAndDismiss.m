//
//  UIView+GentleShowAndDismiss.m
//  SoundcloudProfile
//
//  Created by tstepanov on 21/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "UIView+GentleShowAndDismiss.h"
#import "SafeBlock.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UIView (GentleShowAndDismiss)

- (void)showInView:(UIView *)viewToShowIn completion:(dispatch_block_t _Nullable)completion {
    if (!viewToShowIn) {
        ///ParameterAssertLog
        return;
    }
    self.alpha = 0.0;
    [viewToShowIn addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        safe_block_exec(completion);
    }];
}

- (void)dismiss {
    if (!self.superview) {
        ///ParameterAssertLog
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

NS_ASSUME_NONNULL_END
