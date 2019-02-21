//
//  ProfileViewController.m
//

#import "ProfileViewController.h"
#import "UserInfoTableViewCell.h"
#import "TrackTableViewCell.h"
#import "UITableView+Util.h"
#import "TrackCellViewModel.h"
#import "UserInfoCellViewModel.h"
#import "UserProfileViewModelProtocol.h"
#import "UIViewController+ErrorHandling.h"
#import "TextLabelReusableView.h"

NS_ASSUME_NONNULL_BEGIN

const CGFloat TrackCellHeight = 56.0;
const CGFloat UserInfoCellHeight = 75.0;
const CGFloat TrackSectionFooterHeight = 44.0;

///Second section
NSUInteger TracksSection = 1;

@interface ProfileViewController()

@property (nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ProfileViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCellsAndViewModels];
    [self.viewModel loadContent];
    self.tableView.refreshControl = self.refreshControl;
}

#pragma mark - Setters and getters

- (void)setViewModel:(id<UserProfileViewModelProtocol>)viewModel {
    [super setViewModel:viewModel];
    self.viewModel.errorHandler = self;
}

#pragma mark - Private

- (void)registerCellsAndViewModels {
    [self.tableView sp_registerNibForCellClass:TrackTableViewCell.class];
    [self.tableView sp_registerNibForCellClass:UserInfoTableViewCell.class];
    [self.tableView sp_registerHeaderFooterNibForReuseIdFromClass:TextLabelReusableView.class];
    [self registerCellClass:TrackTableViewCell.class forViewModelClass:TrackCellViewModel.class];
    [self registerCellClass:UserInfoTableViewCell.class forViewModelClass:UserInfoCellViewModel.class];
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self.viewModel action:@selector(loadContent) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = tableView.rowHeight;
    id viewModel = [self.viewModel viewModelAtIndexPath:indexPath];
    if ([viewModel isKindOfClass:TrackCellViewModel.class]) {
        height = TrackCellHeight;
    }
    else if ([viewModel isKindOfClass:UserInfoCellViewModel.class]) {
        height = UserInfoCellHeight;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat footerHeight = 0;
    if (section == TracksSection) {
        footerHeight = TrackSectionFooterHeight;
    }
    return footerHeight;
}

- (UIView *_Nullable)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView;
    if (section == TracksSection) {
        TextLabelReusableView *textLabelReusableView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(TextLabelReusableView.class)];
        textLabelReusableView.displayString = [self.viewModel afterTitleForSection:section];
        footerView = textLabelReusableView;
    }
    return  footerView;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TracksSection) {
        NSUInteger numberOfTracks = [self.viewModel numberOfObjectsInSection:indexPath.section];
        if (numberOfTracks - indexPath.row == 2) {
            [self.viewModel loadMoreIfPossible];
        }
    }
}

#pragma mark - CollectioViewDelegate

- (void)viewModelDidReloadData:(id<CollectionViewModelProtocol>)viewModel {
    if (self.refreshControl.isRefreshing) {
        [self.refreshControl endRefreshing];
    }
    [super viewModelDidReloadData:viewModel];
}

@end

NS_ASSUME_NONNULL_END
