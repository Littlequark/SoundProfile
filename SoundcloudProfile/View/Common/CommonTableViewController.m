//
//  CommonTableViewController.m
//


#import "CommonTableViewController.h"

#import "ConfigurableCellProtocol.h"
#import "CollectionViewModelProtocol.h"
#import <UIViewController+KeyboardAnimation.h>
#import "SafeBlock.h"
#import "Scope.h"

NS_ASSUME_NONNULL_BEGIN

const CGFloat DefaultGrouppedTableHeaderFooterHeight = 0.1f; // Using zero value for Grouped style table provides default ios footer/header height (about 20pt)

@interface CommonTableViewController ()

@property (nonatomic) UITableViewStyle tableViewStyle;
@property (nonatomic) NSMutableDictionary<NSString *, NSString *> *viewModelToCellMapping;
@property (nonatomic) NSMutableDictionary<NSString *, NSString *> *viewModelToAccessibilityMapping;

@end

@implementation CommonTableViewController

@synthesize viewModel = _viewModel;

- (instancetype)initWithNibName:(NSString *_Nullable)nibNameOrNil bundle:(NSBundle *_Nullable)nibBundleOrNil {
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.tableViewStyle = style;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self =  [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _viewModelToAccessibilityMapping = [[NSMutableDictionary alloc] init];
    _viewModelToCellMapping = [[NSMutableDictionary alloc] init];
}

- (void)loadView {
    [super loadView];
    // If tableView does not created from interface builder
    if (!_tableView) {
        [self setupTableViewProgrammatically];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    @weakify(self);
    [self an_subscribeKeyboardFrameChangesWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration) {
        @strongify(self);
        [self updateUIRelatedToKeyboardRect:keyboardRect];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self an_unsubscribeKeyboardFrameChanges];
}

- (void)setupTableView {
    if (self.tableView.style == UITableViewStylePlain) {
        // avoid "lines" (cell separators) appearance on empty state in tableView and below cell when there are few
        self.tableView.tableFooterView = [[UIView alloc] init];
    }
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 72;
    self.tableView.estimatedSectionHeaderHeight = 0.f; // disable UITableViewAutomaticDimension
    self.tableView.estimatedSectionFooterHeight = 0.f; // disable UITableViewAutomaticDimension
    self.tableView.separatorInset = UIEdgeInsetsZero;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

#pragma mark - Setters & Getters

- (void)setViewModel:(id<CollectionViewModelProtocol>)viewModel {
    _viewModel.delegate = nil;
    _viewModel = viewModel;
    _viewModel.delegate = self;
    [self viewModelDidReloadData:self.viewModel];
}

- (UITableView *_Nullable)tableView {
    [self loadViewIfNeeded];
    return _tableView;
}

#pragma mark - Public methods

- (NSString *)reuseIdentifierForCellViewModel:(NSObject *)cellViewModel {
    NSString *key = NSStringFromClass(cellViewModel.class);
    NSString *identifier = self.viewModelToCellMapping[key];
    return identifier;
}

- (void)registerCellClass:(Class)cellClass forViewModelClass:(Class)viewModelClass {
    [self.viewModelToCellMapping setObject:NSStringFromClass(cellClass) forKey:NSStringFromClass(viewModelClass)];
}

- (void)updateCell:(UITableViewCell<ConfigurableCellProtocol> *)cell withViewModelAtIndexPath:(NSIndexPath *)indexPath {
    cell.viewModel = [self.viewModel viewModelAtIndexPath:indexPath];
    cell.accessibilityIdentifier = [self accessibilityIdentifierForViewModel:cell.viewModel];
    if (self.tableView.rowHeight == UITableViewAutomaticDimension) {
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
    }
}

- (void)scrollTableViewToTop {
    CGPoint zeroContentOffset = CGPointMake(0, -self.tableView.adjustedContentInset.top);
    [self.tableView setContentOffset:zeroContentOffset animated:YES];
}

#pragma mark - Private methods

- (void)setupTableViewProgrammatically {
    UITableView *tableView = [[self.tableViewClass alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.allowsSelectionDuringEditing = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewsAutoLayoutBinding = NSDictionaryOfVariableBindings(tableView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsAutoLayoutBinding]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsAutoLayoutBinding]];
}

- (void)updateUIRelatedToKeyboardRect:(CGRect)keyboardRect {
    UIScrollView *scrollView = self.tableView;
    CGRect convertedKeyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardY = CGRectGetMinY(convertedKeyboardRect);
    CGFloat viewBottomVisibleY = CGRectGetHeight(self.view.frame) - self.bottomLayoutGuide.length;
    CGFloat scrollViewBottomY = CGRectGetMaxY(scrollView.frame);
    CGFloat minVisibleY = MIN(keyboardY, viewBottomVisibleY);
    CGFloat bottomInset = scrollViewBottomY > minVisibleY ? scrollViewBottomY - minVisibleY : 0.f;
    
    UIEdgeInsets contentInset = scrollView.contentInset;
    contentInset.bottom = bottomInset;
    scrollView.contentInset = contentInset;
    
    UIEdgeInsets scrollIndicatorInsets = scrollView.scrollIndicatorInsets;
    scrollIndicatorInsets.bottom = bottomInset;
    scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfObjectsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cellViewModel = [self.viewModel viewModelAtIndexPath:indexPath];
    NSString *cellReuseIdentifier = [self reuseIdentifierForCellViewModel:cellViewModel];
    __block UITableViewCell<ConfigurableCellProtocol> *cell;
    [UIView performWithoutAnimation:^{
        cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
        if ([cell conformsToProtocol:@protocol(ConfigurableCellProtocol)]) {
            [self updateCell:cell withViewModelAtIndexPath:indexPath];
        }
        else {
            ////AssertFalse(@"Cell %@ dequeued for %@ doesn't conform ConfigurableCell protocol", NSStringFromClass(cell.class), cellReuseIdentifier);
        }
    }];
    return cell;
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72.0;
}

#pragma mark - Protected methods

- (Class)tableViewClass {
    return UITableView.class;
}

#pragma mark - CollectionViewModelDelegate

- (void)viewModelDidReloadData:(id<CollectionViewModelProtocol>)viewModel {
    if (!self.isViewLoaded) {
        return;
    }
    [self.tableView reloadData];
}

- (void)viewModel:(id<CollectionViewModelProtocol>)viewModel didInsertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (!self.isViewLoaded) {
        return;
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewModel:(id<CollectionViewModelProtocol>)viewModel didRemoveItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (!self.isViewLoaded) {
        return;
    }
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewModel:(id<CollectionViewModelProtocol>)viewModel didRefreshItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (!self.isViewLoaded) {
        return;
    }
    for (NSIndexPath *indexPath in indexPaths) {
        UITableViewCell<ConfigurableCellProtocol> *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        // HPReorderTableView registers plain UITableViewCell for re-ordering animations.
        // We have to ignore refreshing this cell.
        if ([cell conformsToProtocol:@protocol(ConfigurableCellProtocol)]) {
            [self updateCell:cell withViewModelAtIndexPath:indexPath];
        }
    }
}

- (void)viewModel:(id<CollectionViewModelProtocol>)viewModel didInsertSections:(NSIndexSet *)sections {
    if (!self.isViewLoaded) {
        return;
    }
    [self.tableView insertSections:sections withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewModel:(id<CollectionViewModelProtocol>)viewModel didRemoveSections:(NSIndexSet *)sections {
    if (!self.isViewLoaded) {
        return;
    }
    [self.tableView deleteSections:sections withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)viewModel:(id<CollectionViewModelProtocol>)viewModel didRefreshSections:(NSIndexSet *)sections {
    if (!self.isViewLoaded) {
        return;
    }
    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewModel:(id<CollectionViewModelProtocol>)viewModel performBatchUpdate:(dispatch_block_t _Nullable)update completion:(dispatch_block_t _Nullable)completion {
    if (self.isViewLoaded) {
        [self.tableView beginUpdates];
        safe_block_exec(update);
        [self.tableView endUpdates];
    }
    
    safe_block_exec(completion);
}

#pragma mark - UIAutoTestUtils

- (void)registerAccessibilityIdentifier:(NSString *)accessibilityIdentifier forViewModelClass:(Class)viewModelClass {
    [self.viewModelToAccessibilityMapping setObject:accessibilityIdentifier forKey:NSStringFromClass(viewModelClass)];
}

- (NSString *)accessibilityIdentifierForViewModel:(NSObject *)viewModel {
    NSString *key = NSStringFromClass(viewModel.class);
    NSString *identifier = [self.viewModelToAccessibilityMapping objectForKey:key];
    return identifier;
}

@end

NS_ASSUME_NONNULL_END
