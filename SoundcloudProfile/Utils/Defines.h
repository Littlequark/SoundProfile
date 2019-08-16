//
//  Defines.h
//  SoundcloudProfile
//
//  Created by tstepanov on 20/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#ifndef OBJECT_ABSTRACT_METHOD
#define OBJECT_ABSTRACT_METHOD @throw [NSException exceptionWithName:NSInternalInconsistencyException \
reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] \
userInfo:nil];
#endif


#define ObjectOrNilForKey(JSON_, KEY_) [[JSON_ objectForKey:KEY_] isKindOfClass:[NSNull class]] ? nil : [JSON_ objectForKey:KEY_]

