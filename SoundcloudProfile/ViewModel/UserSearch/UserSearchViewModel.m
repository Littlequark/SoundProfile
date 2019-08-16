//
//  UserSearchViewModel.m
//  SoundcloudProfile
//
//  Created by tstepanov on 21/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "UserSearchViewModel.h"
#import "UserSearchModelProtocol.h"
#import "ErrorHandlerProtocol.h"
#import "ErrorPresentationHandlerProtocol.h"
#import "UserInfoCellViewModel.h"
#import "UserObject.h"
#import "UserProfileServiceLocatorProtocol.h"
#import "DataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserSearchViewModel() <ErrorHandlerProtocol>

@end

@implementation UserSearchViewModel

@synthesize filterPatterns = _filterPatterns;
@synthesize errorHandler;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self registerViewModels];
    }
    return self;
}

#pragma mark - UserSearchViewModelProtocol

- (void)setFilterPatterns:(NSString *_Nullable)filterPatterns {
    _filterPatterns = filterPatterns;
    if (filterPatterns != nil) {
        [self.model searchUsersWithText:_filterPatterns];
    }
    else {
        [self.model clearSearch];
    }
}

- (void)searchUsersWithText:(NSString *_Nullable)searchText {
    [self.model searchUsersWithText:searchText];
}

- (void)setModel:(id<UserSearchModelProtocol>)model {
    _model = model;
    self.dataSource = _model.usersDataSource;
    _model.errorHandler = self;
}

- (id<UserProfileViewModelProtocol> _Nullable)profileViewModelForUserAtIndexPath:(NSIndexPath *)indexPath {
    id<UserProfileViewModelProtocol> profileViewModel;
    UserObject *user = [self.dataSource itemAtIndexPath:indexPath];
    if (user != nil) {
        profileViewModel = [self.userProfileServiceLocator profileViewModelForUser:user];
    }
    return profileViewModel;
}

#pragma mark - ErrorHandlerProtocol

- (void)handleError:(NSError *)error {
    //FIXME: - Decompose and switch over error types
    if ([self.errorHandler respondsToSelector:@selector(handleErrorWithDescription:)]) {
        NSString *errorMessage = NSLocalizedString(@"Error loading data", nil);
        [self.errorHandler handleErrorWithDescription:errorMessage];
    }
}

#pragma mark - Private

- (void)registerViewModels {
    [self registerViewModelClass:UserInfoCellViewModel.class forModelClass:UserObject.class];
}

@end

NS_ASSUME_NONNULL_END
