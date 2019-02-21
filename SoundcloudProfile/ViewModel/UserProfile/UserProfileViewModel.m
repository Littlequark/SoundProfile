//
//  UserProfileViewModel.m
//  SoundcloudProfile
//
//  Created by tstepanov on 20/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "UserProfileViewModel.h"
#import "UserProfileModelProtocol.h"
#import "UserInfoCellViewModel.h"
#import "UserObject.h"
#import "TrackCellViewModel.h"
#import "TrackObject.h"
#import "ErrorPresentationHandlerProtocol.h"
#import "ComposedDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UserProfileViewModel

@synthesize errorHandler;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self registerViewModels];
    }
    return self;
}

- (void)setModel:(id<UserProfileModelProtocol>)model {
    _model = model;
    self.dataSource = [self createDataSourceWithModel:_model];
    _model.errorHandler = self;
}

- (void)loadContent {
    [super loadContent];
    [self.model loadProfileInfo];
}

- (void)loadMoreIfPossible {
    [self.model loadMoreIfPossible];
}

- (void)registerViewModels {
    [self registerViewModelClass:TrackCellViewModel.class forModelClass:TrackObject.class];
    [self registerViewModelClass:UserInfoCellViewModel.class forModelClass:UserObject.class];
}

#pragma mark - CollectionViewModelProtocol

- (NSString *_Nullable)afterTitleForSection:(NSUInteger)section {
    NSString *afterTitle;
    if (section == self.trackSectionIndex) {
        NSUInteger numberOfTracks = [self.model.tracksDataSource numberOfItemsInSection:0];
        NSString *tracksFormat = NSLocalizedString(@"%d tracks", nil);
        afterTitle = [NSString stringWithFormat:tracksFormat, numberOfTracks];
    }
    return afterTitle;
}

- (NSUInteger)trackSectionIndex {
    return [((ComposedDataSource *)self.dataSource) sectionIndexForDataSource:self.model.tracksDataSource];
}

#pragma mark - ErrorHandlerProtocol

- (ComposedDataSource *)createDataSourceWithModel:(id<UserProfileModelProtocol>)model {
    ComposedDataSource *composedDataSource = [[ComposedDataSource alloc] init];
    [composedDataSource addDataSource:model.userInfoDataSource];
    [composedDataSource addDataSource:model.tracksDataSource];
    return composedDataSource;
}

- (void)handleError:(NSError *)error {
    //FIXME: - Decompose and switch over error types
    if ([self.errorHandler respondsToSelector:@selector(handleErrorWithDescription:)]) {
        NSString *errorMessage = NSLocalizedString(@"Error loading data", nil);
        [self.errorHandler handleErrorWithDescription:errorMessage];
    }
}

@end

NS_ASSUME_NONNULL_END
