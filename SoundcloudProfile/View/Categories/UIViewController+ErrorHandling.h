//
//  UIViewController+ErrorHandling.h
//  SoundcloudProfile
//
//  Created by tstepanov on 20/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ErrorPresentationHandlerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ErrorHandling) <ErrorPresentationHandlerProtocol>

@end

NS_ASSUME_NONNULL_END
