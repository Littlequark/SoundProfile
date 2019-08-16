//
//  FetchedResultsControllerModelChange.h
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FetchedResultsControllerModelChangeType) {
    FetchedResultsControllerModelChangeInsert = 1,
    FetchedResultsControllerModelChangeDelete = 2,
};

@class FetchedResultsControllerModel;
@protocol FetchedResultsSectionInfoProtocol;

@interface FetchedResultsControllerModelChange : NSObject

+ (instancetype)changeWithType:(FetchedResultsControllerModelChangeType)changeType
                        object:(id)object
                     indexPath:(NSIndexPath *)indexPath;
+ (instancetype)changeWithType:(FetchedResultsControllerModelChangeType)changeType
                   sectionName:(NSString *)sectionName
                  sectionIndex:(NSUInteger)sectionIndex;

- (void)applyOnModel:(FetchedResultsControllerModel *)model;

- (BOOL)isChangeOnSameObject:(FetchedResultsControllerModelChange *)change;

@end
