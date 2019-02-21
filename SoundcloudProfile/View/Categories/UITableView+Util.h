//
//  UITableView+Util.h
//

#import <UIKit/UIKit.h>

@interface UITableView (Util)

- (void)sp_registerNibForCellClass:(Class)cellClass;
- (void)sp_registerNibWithName:(NSString *)nibName forCellClass:(Class)cellClass;

- (void)sp_registerNibWithName:(NSString *)nibName
                   forCellClass:(Class)cellClass
                reuseIdentifier:(NSString *)reuseIdentifier;

- (void)sp_registerCellClass:(Class)cellClass;
- (void)sp_registerHeaderFooterNibForReuseIdFromClass:(Class)viewClass;

- (void)sp_registerHeaderFooterClass:(Class)viewClass;

- (__kindof UITableViewCell *)sp_dequeueCellForCellClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath;
- (__kindof UITableViewHeaderFooterView *)sp_dequeueHeaderFooterViewForClass:(Class)headerFooterViewClass;

@end
