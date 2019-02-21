//
//  ProfileViewController.h
//

#import <UIKit/UIKit.h>
#import "CommonTableViewController.h"
// ViewModel Protocol inluded to inhibit inheritance warnings
#import "UserProfileViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : CommonTableViewController

@property (nonatomic) id<UserProfileViewModelProtocol> viewModel;

@end

NS_ASSUME_NONNULL_END
