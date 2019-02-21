//
//  NetworkClientProtocol.h
//  SoundcloudProfile
//
//  Created by tstepanov on 18/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^NetworkClientCompletionBlock)(id _Nullable response, NSError *_Nullable error);

@protocol NetworkClientProtocol <NSObject>

- (void)performRequestToPath:(NSString *)path
                        parameters:(NSDictionary *)parameters
                        completion:(NetworkClientCompletionBlock)completion;


@end

NS_ASSUME_NONNULL_END
