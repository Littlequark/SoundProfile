//
//  TableViewController.h
//

#import "CollectionViewModelDelegate.h"
#import "CollectionViewModelProtocol.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ConfigurableCellProtocol;

@interface CommonTableViewController : UIViewController <
    UITableViewDelegate,
    UITableViewDataSource,
    CollectionViewModelDelegate
>

@property (nonatomic) id<CollectionViewModelProtocol> viewModel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (instancetype)initWithStyle:(UITableViewStyle)style NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

- (void)setupTableView NS_REQUIRES_SUPER;

- (void)updateCell:(UITableViewCell<ConfigurableCellProtocol> *)cell withViewModelAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)reuseIdentifierForCellViewModel:(NSObject *)cellViewModel;

- (void)registerCellClass:(Class)cellClass forViewModelClass:(Class)viewModelClass;

@end

NS_ASSUME_NONNULL_END
