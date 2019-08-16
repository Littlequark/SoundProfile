//
//  UserInfoCellViewModel.m
//  SoundcloudProfile
//
//  Created by tstepanov on 20/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "UserInfoCellViewModel.h"
#import "UserObject.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UserInfoCellViewModel

@synthesize model = _model;

+ (id _Nullable)viewModelWithModel:(id)model {
    if (![model isKindOfClass:UserObject.class]) {
        return nil;
    }
    UserObject *user = (UserObject *)model;
    return [[self alloc] initWithModel:user];
}

- (instancetype)initWithModel:(UserObject *)model {
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

#pragma mark - UserInfoCellViewModelProtocol

- (NSString *_Nullable)username {
    return ((UserObject *)self.model).username;
}

- (NSString *_Nullable)city {
    return self.user.city ;
}

- (NSString *_Nullable)fullName {
    NSString *fullName;
    if (self.user.firstName != nil && self.user.lastName) {
        fullName = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
    }
    else if (self.user.firstName != nil) {
        fullName = self.user.firstName;
    }
    else if (self.user.lastName != nil) {
        fullName = self.user.lastName;
    }
    return fullName;
}

- (NSURL *_Nullable)avatarURL {
    return [NSURL URLWithString:self.user.avatarURLString];
}

#pragma mark - Getters

- (UserObject *)user {
    return (UserObject *)self.model;
}

@end

NS_ASSUME_NONNULL_END
