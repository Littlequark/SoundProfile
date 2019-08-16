//
//  UserObject.m
//  SoundcloudProfile
//
//  Created by tstepanov on 19/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "UserObject.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UserObject

- (id)copyWithZone:(NSZone *)zone {
    UserObject *newInstance = [[self.class allocWithZone:zone] init];
    if (!newInstance) {
        return nil;
    }
    newInstance->_userId = _userId;
    newInstance->_firstName = _firstName.copy;
    newInstance->_lastName = _lastName.copy;
    newInstance->_avatarURLString = _avatarURLString.copy;
    newInstance->_username = _username.copy;
    newInstance->_city = _city.copy;
    return newInstance;
}

- (NSUInteger)hash {
    return self.userId.hash;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    BOOL result = NO;
    if ([object isKindOfClass:UserObject.class]) {
        result = [self isEqualToUser:object];
    }
    return result;
}

- (BOOL)isEqualToUser:(nonnull UserObject *)other {
    BOOL isUserIdPointerEqual = self.userId == other.userId;
    BOOL isUserIdEqual = [self.userId isEqualToNumber:other.userId];
    return isUserIdPointerEqual || isUserIdEqual;
}

@end

NS_ASSUME_NONNULL_END
