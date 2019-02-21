//
//  CollectionViewModelProtocol.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CollectionViewModelDelegate;

/**
 The root protocol of any list view model protocols used in the app.
 If you create a new list view model protocol, you must inherit it from this one
 */
@protocol CollectionViewModelProtocol

@required
@property (nonatomic, weak) id<CollectionViewModelDelegate> delegate;

- (NSUInteger)numberOfSections;

- (NSUInteger)numberOfObjectsInSection:(NSUInteger)section;

- (id _Nullable)viewModelAtIndexPath:(NSIndexPath *)indexPath;

- (void)loadContent;

@optional
- (NSString *_Nullable)titleForSection:(NSUInteger)section;

- (NSString *_Nullable)afterTitleForSection:(NSUInteger)section;

- (NSArray<NSString *> *_Nullable)indexTitles;

- (NSUInteger)sectionIndexForTitle:(NSString *)sectionTitle;

- (NSIndexPath *_Nullable)indexPathForViewModel:(id)viewModel;

@end

NS_ASSUME_NONNULL_END
