//
//  UIView+GentleShowAndDismiss.h
//  SoundcloudProfile
//
//  Created by tstepanov on 21/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (GentleShowAndDismiss)

- (void)showInView:(UIView *)viewToShowIn completion:(dispatch_block_t _Nullable)completion;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
