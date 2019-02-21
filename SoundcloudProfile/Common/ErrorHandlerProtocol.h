//
//  ErrorHandlerProtocol.h
//  SoundcloudProfile
//
//  Created by tstepanov on 20/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ErrorHandlerProtocol <NSObject>

- (void)handleError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
