//
//  TrackCellViewModel.m
//  SoundcloudProfile
//
//  Created by tstepanov on 20/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "TrackCellViewModel.h"
#import "TrackObject.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TrackCellViewModel

@synthesize model = _model;

+ (id _Nullable)viewModelWithModel:(id)model {
    if (![model isKindOfClass:TrackObject.class]) {
        return nil;
    }
    TrackObject *track = (TrackObject *)model;
    return [[self alloc] initWithModel:track];
}

- (instancetype)initWithModel:(TrackObject *)model {
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

#pragma mark - TrackCellViewModel

- (NSString *_Nullable)trackTitle {
    return self.track.title;
}

- (NSString *_Nullable)trackLength {
    return @"3:54";
}

- (NSURL *_Nullable)artworkURL {
    return [NSURL URLWithString:self.track.artworkURLString];
}

- (NSString *_Nullable)authorName {
    return self.track.authorName;
}

- (NSString *_Nullable)duration {
    NSTimeInterval lengthInSeconds = round(self.track.duration.doubleValue / 1000.0);
    return [self.lengthFormatter stringFromTimeInterval:lengthInSeconds];
}

#pragma mark - Getters

- (TrackObject *)track {
    return (TrackObject *)self.model;
}

- (NSDateComponentsFormatter *)lengthFormatter {
    static dispatch_once_t onceToken;
    static NSDateComponentsFormatter *lengthFormatter;
    dispatch_once(&onceToken, ^{
        lengthFormatter = [[NSDateComponentsFormatter alloc] init];
        lengthFormatter.allowedUnits = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    });
    return lengthFormatter;
}

@end

NS_ASSUME_NONNULL_END
