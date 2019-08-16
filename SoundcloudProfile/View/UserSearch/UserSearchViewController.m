//
//  UserSearchViewController.m
//  SoundcloudProfile
//
//  Created by tstepanov on 21/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "UserSearchViewController.h"
#import "UserInfoTableViewCell.h"
#import "USerInfoCellViewModel.h"
#import "UITableView+Util.h"
#import "UIViewController+ErrorHandling.h"
#import "SearchTableViewController.h"
#import "ProfileViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserSearchViewController () <UISearchControllerDelegate, SearchViewControllerDelegate>

@property (nonatomic) UISearchController *searchController;
@property (nonatomic) SearchTableViewController *searchResultsViewController;

@end

@implementation UserSearchViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCellsAndViewModels];
    self.navigationItem.searchController = self.searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    self.definesPresentationContext = YES;
    self.title = NSLocalizedString(@"Search", nil);
}

#pragma mark - Setters and getters

- (void)setViewModel:(id<UserSearchViewModelProtocol>)viewModel {
    [super setViewModel:viewModel];
    self.viewModel.errorHandler = self;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsViewController];
        _searchController.delegate = self;
        _searchController.searchResultsUpdater = self.searchResultsViewController;
        
        UISearchBar *searchBar = _searchController.searchBar;
        searchBar.enablesReturnKeyAutomatically = NO;
        searchBar.placeholder = NSLocalizedString(@"Search username, desc. etc.", nil);
        [searchBar sizeToFit];
    }
    return _searchController;
}

- (SearchTableViewController *)searchResultsViewController {
    if (!_searchResultsViewController) {
        _searchResultsViewController = [[SearchTableViewController alloc] initWithStyle:UITableViewStylePlain];
        Class userCellClass = UserInfoTableViewCell.class;
        [_searchResultsViewController registerCellClass:userCellClass
                                      forViewModelClass:UserInfoCellViewModel.class];
        [_searchResultsViewController.tableView sp_registerNibForCellClass:userCellClass];
        _searchResultsViewController.selectionDelegate = self;
    }
    return _searchResultsViewController;
}

#pragma mark - UISearchControllerDelegate

- (void)didPresentSearchController:(UISearchController *)searchController {
    self.searchResultsViewController.viewModel = self.viewModel;
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    self.searchResultsViewController.viewModel = nil;
}

#pragma mark - SearchViewControllerDelegate

- (void)searchViewController:(SearchTableViewController *)searchViewController didSelectItemAt:(NSIndexPath *)indexPath {
    id<UserProfileViewModelProtocol> profileViewModel = [self.viewModel profileViewModelForUserAtIndexPath:indexPath];
    if (profileViewModel != nil) {
        ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithStyle:UITableViewStyleGrouped];
        profileViewController.viewModel = profileViewModel;
        [self showViewController:profileViewController sender:self];
    }
}

#pragma mark - Private

- (void)registerCellsAndViewModels {
    Class userCellClass = UserInfoTableViewCell.class;
    [self registerCellClass:userCellClass forViewModelClass:UserInfoCellViewModel.class];
    [self.tableView sp_registerNibForCellClass:userCellClass];
}

@end

NS_ASSUME_NONNULL_END
