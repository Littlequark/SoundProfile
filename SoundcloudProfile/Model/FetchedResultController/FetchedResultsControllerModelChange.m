//
//  FetchedResultsControllerModelChange.m
//

#import "Defines.h"

#import "FetchedResultsControllerModelChange.h"
#import "FetchedResultsControllerModelChange+PrivateInterfaces.h"

#import "FetchedResultsControllerModel.h"
#import "FetchedResultsControllerModel+ModelChange.h"

#pragma mark - FetchedResultsControllerModelChange

@implementation FetchedResultsControllerModelChange

+ (instancetype)changeWithType:(FetchedResultsControllerModelChangeType)changeType object:(id)object indexPath:(NSIndexPath *)indexPath {
    FetchedResultsControllerModelChangeObject *change = [[FetchedResultsControllerModelChangeObject alloc] initWithType:changeType];
    change.object = object;
    change.indexPath = indexPath;
    return change;
}

+ (instancetype)changeWithType:(FetchedResultsControllerModelChangeType)changeType sectionName:(NSString *)sectionName sectionIndex:(NSUInteger)sectionIndex {
    FetchedResultsControllerModelChangeSection *change = [[FetchedResultsControllerModelChangeSection alloc] initWithType:changeType];
    change.sectionName = sectionName;
    change.sectionIndex = sectionIndex;
    return change;
}

- (instancetype)initWithType:(FetchedResultsControllerModelChangeType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)applyOnModel:(FetchedResultsControllerModel *)model {
    OBJECT_ABSTRACT_METHOD;
}

- (BOOL)isChangeOnSameObject:(FetchedResultsControllerModelChange *)change {
    OBJECT_ABSTRACT_METHOD;
}

@end

#pragma mark - FetchedResultsControllerModelChangeObject

@implementation FetchedResultsControllerModelChangeObject

- (void)applyOnModel:(FetchedResultsControllerModel *)model {
    switch (self.type) {
        case FetchedResultsControllerModelChangeInsert: {
            [model addObject:self.object atIndexPath:self.indexPath];
            break;
        }
            
        case FetchedResultsControllerModelChangeDelete: {
            [model removeObjectFromIndexPath:self.indexPath];
            break;
        }
            
        default:
            break;
    }
}

- (BOOL)isChangeOnSameObject:(FetchedResultsControllerModelChange *)change {
    if (self.class != change.class) {
        return NO;
    }
    
    FetchedResultsControllerModelChangeObject *changeObject = (FetchedResultsControllerModelChangeObject *)change;
    return [self.object isEqual:changeObject.object];
}

@end

#pragma mark - FetchedResultsControllerModelChangeSection

@implementation FetchedResultsControllerModelChangeSection

- (void)applyOnModel:(FetchedResultsControllerModel *)model {
    switch (self.type) {
        case FetchedResultsControllerModelChangeInsert: {
            [model createSectionInfoWithName:self.sectionName atIndex:self.sectionIndex];
            break;
        }
            
        case FetchedResultsControllerModelChangeDelete: {
            [model removeSectionInfoFromIndex:self.sectionIndex];
            break;
        }
            
        default:
            break;
    }
}

- (BOOL)isChangeOnSameObject:(FetchedResultsControllerModelChange *)change {
    if (self.class != change.class) {
        return NO;
    }
    
    FetchedResultsControllerModelChangeSection *changeSection = (FetchedResultsControllerModelChangeSection *)change;
    return (self.sectionName == changeSection.sectionName) || [self.sectionName isEqual:changeSection.sectionName];
}

@end

