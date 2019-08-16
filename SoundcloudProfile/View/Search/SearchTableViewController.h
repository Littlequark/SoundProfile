//
//  SearchTableViewController.h
//  SoundcloudProfile
//
//  Created by tstepanov on 22/02/2019.
//  Copyright © 2019 persTim. All rights reserved.
//

#import "CommonTableViewController.h"
#import "SearchViewModelProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@class SearchTableViewController;

@protocol SearchViewControllerDelegate<NSObject>

@optional
- (void)searchViewController:(SearchTableViewController *)searchViewController
             didSelectItemAt:(NSIndexPath *)indexPath;

@end

@protocol FilteringViewModelProtocol;

@interface SearchTableViewController : CommonTableViewController <UISearchResultsUpdating>

@property (nonatomic, nullable) id<SearchViewModelProtocol> viewModel;
@property (nonatomic, nullable) id<SearchViewControllerDelegate> selectionDelegate;

@end

NS_ASSUME_NONNULL_END
