//
//  UITableView+Util.m
//

#import "UITableView+Util.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UITableView(Util)

- (void)sp_registerNibForCellClass:(Class)cellClass {
    NSString *nibName = NSStringFromClass(cellClass);
    [self sp_registerNibWithName:nibName forCellClass:cellClass];
}

- (void)sp_registerNibWithName:(NSString *)nibName forCellClass:(Class)cellClass {
    NSString *cellClassNameString = NSStringFromClass(cellClass);
    UINib *nib = [UINib nibWithNibName:nibName bundle:[NSBundle bundleForClass:cellClass]];
    [self registerNib:nib forCellReuseIdentifier:cellClassNameString];
}

- (void)sp_registerNibWithName:(NSString *)nibName
                   forCellClass:(Class)cellClass
                reuseIdentifier:(NSString *)reuseIdentifier {
    UINib *nib = [UINib nibWithNibName:nibName bundle:[NSBundle bundleForClass:cellClass]];
    [self registerNib:nib forCellReuseIdentifier:reuseIdentifier];
}

- (void)sp_registerCellClass:(Class)cellClass {
    NSString *cellClassNameString = NSStringFromClass(cellClass);
    [self registerClass:cellClass forCellReuseIdentifier:cellClassNameString];
}

- (void)sp_registerHeaderFooterNibForReuseIdFromClass:(Class)viewClass {
    NSString *headerFooterViewNameString = NSStringFromClass(viewClass);
    UINib *nib = [UINib nibWithNibName:headerFooterViewNameString
                                bundle:[NSBundle bundleForClass:viewClass]];
    [self registerNib:nib forHeaderFooterViewReuseIdentifier:headerFooterViewNameString];
}

- (void)sp_registerHeaderFooterClass:(Class)viewClass {
    NSString *reuseIdnetifier = NSStringFromClass(viewClass);
    [self registerClass:viewClass forHeaderFooterViewReuseIdentifier:reuseIdnetifier];
}

- (__kindof UITableViewCell *)sp_dequeueCellForCellClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath {
    NSString *cellClassNameString = NSStringFromClass(cellClass);
    return [self dequeueReusableCellWithIdentifier:cellClassNameString forIndexPath:indexPath];
}

- (__kindof UITableViewHeaderFooterView *)sp_dequeueHeaderFooterViewForClass:(Class)headerFooterViewClass {
    NSString *headerFooterClassNameString = NSStringFromClass(headerFooterViewClass);
    return [self dequeueReusableHeaderFooterViewWithIdentifier:headerFooterClassNameString];
}

@end

NS_ASSUME_NONNULL_END
