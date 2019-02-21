//
//  NetworkClient.m
//  SoundcloudProfile
//
//  Created by tstepanov on 18/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "NetworkClient.h"
#import <AFNetworking/AFNetworking.h>
#import "SafeBlock.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const SoundcloudClientId = @"c23089b7e88643b5b839c4b8609fce3b";
static NSString *const SoundcloudBaseApiString = @"https://api.soundcloud.com";

@interface NetworkClient()

@property (nonatomic) AFHTTPSessionManager *manager;

@end

@implementation NetworkClient

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURL *baseURL = [NSURL URLWithString:SoundcloudBaseApiString];
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    }
    return self;
}

- (void)performRequestToPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(NetworkClientCompletionBlock)completion {
    NSMutableDictionary *mutParams = parameters != nil ? parameters.mutableCopy : [NSMutableDictionary dictionary];
    mutParams[@"client_id"] = SoundcloudClientId;
    [self.manager GET:path
           parameters:mutParams.copy
             progress:^(NSProgress * _Nonnull downloadProgress) { }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  safe_block_exec(completion, responseObject, nil);
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  safe_block_exec(completion, nil, error);
              }];
}

@end

NS_ASSUME_NONNULL_END
