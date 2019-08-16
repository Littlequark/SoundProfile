//
//  SearchTableViewController.m
//  SoundcloudProfile
//
//  Created by tstepanov on 22/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "SearchTableViewController.h"
#import <UIViewController+KeyboardAnimation.h>

NS_ASSUME_NONNULL_BEGIN

@implementation SearchTableViewController

@dynamic viewModel;

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchTerm = searchController.searchBar.text;
    self.viewModel.filterPatterns = searchTerm;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([self.selectionDelegate respondsToSelector:@selector(searchViewController:didSelectItemAt:)]) {
        [self.selectionDelegate searchViewController:self didSelectItemAt:indexPath];
    }
}

@end

NS_ASSUME_NONNULL_END
