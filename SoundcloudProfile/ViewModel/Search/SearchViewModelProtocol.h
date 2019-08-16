//
//  SearchViewModelProtocol.h
//  SoundcloudProfile
//
//  Created by tstepanov on 22/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionViewModelProtocol.h"
#import "FilteringViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SearchViewModelProtocol <CollectionViewModelProtocol, FilteringViewModelProtocol>

@end

NS_ASSUME_NONNULL_END
