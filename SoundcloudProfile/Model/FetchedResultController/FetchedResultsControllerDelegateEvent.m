//
//  FetchedResultsControllerDelegateEvent.m
//

#import "Defines.h"
#import "FetchedResultsControllerDelegateEvent.h"
#import "FetchedResultsControllerDelegateEvent+PrivateInterfaces.h"
#import "FetchedResultsControllerModelState.h"
#import "FetchedResultsControllerModelChange+PrivateInterfaces.h"
#import "FetchedResultsControllerModel.h"
#import "FetchedResultsSectionInfoProtocol.h"
#import "FetchedResultsController.h"
#import "FetchedResultsControllerDelegate.h"

@implementation FetchedResultsControllerDelegateEvent

+ (FetchedResultsChangeType)fetchedResultsControllerTypeFromModelChangeType:(FetchedResultsControllerModelChangeType)modelChangeType {
    FetchedResultsChangeType type;
    switch (modelChangeType) {
        case FetchedResultsControllerModelChangeInsert: {
            type = FetchedResultsChangeInsert;
            break;
        }
        case FetchedResultsControllerModelChangeDelete: {
            type = FetchedResultsChangeDelete;
            break;
        }
            
        default:
            break;
    }
    
    return type;
}

+ (FetchedResultsControllerDelegateEvent *)delegateEventFromObjectChange:(FetchedResultsControllerModelChangeObject *)changeObject
                                                                     appliedToModelState:(id<FetchedResultsControllerModelState>)helper {
    FetchedResultsControllerDelegateEventObject *delegateEvent = [[FetchedResultsControllerDelegateEventObject alloc] init];
    delegateEvent.changeType = [self fetchedResultsControllerTypeFromModelChangeType:changeObject.type];
    delegateEvent.object = changeObject.object;
    
    if (delegateEvent.changeType == FetchedResultsChangeDelete) {
        delegateEvent.fromIndexPath = changeObject.indexPath;
    }
    else {
        delegateEvent.toIndexPath = [helper indexPathForObject:changeObject.object];
    }
    return delegateEvent;
}

+ (FetchedResultsControllerDelegateEvent *)delegateEventFromSectionChange:(FetchedResultsControllerModelChangeSection *)changeSection
                                                         appliedToModelState:(id<FetchedResultsControllerModelState>)modelState {
    FetchedResultsControllerDelegateEventSection *delegateEvent = [[FetchedResultsControllerDelegateEventSection alloc] init];
    delegateEvent.changeType = [self fetchedResultsControllerTypeFromModelChangeType:changeSection.type];
    
    if (delegateEvent.changeType == FetchedResultsChangeDelete) {
        delegateEvent.sectionName = changeSection.sectionName;
    }
    else {
        NSObject<FetchedResultsSectionInfoProtocol> *sectionInfo = [modelState sectionInfoWithName:changeSection.sectionName];
        ///AssertsectionInfo, nil);
        delegateEvent.sectionIndex = [modelState indexOfSectionInfo:sectionInfo];
    }
    
    return delegateEvent;
}

+ (FetchedResultsChangeType)fetchedResultsChangeTypeForFromIndexPath:(nonnull NSIndexPath *)fromIndexPath toIndexPath:(nonnull NSIndexPath *)toIndexPath {
    BOOL isIndexPathChange = [fromIndexPath compare:toIndexPath] != NSOrderedSame;
    return isIndexPathChange ? FetchedResultsChangeMove : FetchedResultsChangeUpdate;
}

+ (FetchedResultsControllerDelegateEvent *)delegateEventFromChangesForSameObject:(nonnull NSArray<FetchedResultsControllerModelChangeObject *> *)changes
                                                                appliedToModelState:(id<FetchedResultsControllerModelState>)helper {
    ///ParameterAssert(changes.count == 2);
    ///ParameterAssert(changes.firstObject.type != changes.lastObject.type);
    ///ParameterAssert([changes.firstObject.object isEqual:changes.lastObject.object]);
    
    NSObject<NSCopying> *object = changes.firstObject.object;
    FetchedResultsControllerDelegateEventObject *delegateEvent = [[FetchedResultsControllerDelegateEventObject alloc] init];
    delegateEvent.object = object;
    delegateEvent.toIndexPath = [helper indexPathForObject:object];
    
    return delegateEvent;
}

+ (NSArray<FetchedResultsControllerDelegateEvent *> *)delegateEventsFromChanges:(NSArray<FetchedResultsControllerModelChange *> *)changes
                                                               appliedToModelState:(id<FetchedResultsControllerModelState>)modelState {
    NSMutableArray<FetchedResultsControllerDelegateEvent *> *delegateEvents = [[NSMutableArray<FetchedResultsControllerDelegateEvent *> alloc] init];
    NSMutableArray<FetchedResultsControllerModelChange *> *mutableChanges = changes.mutableCopy;
    
    for (int i = 0; i < mutableChanges.count; ++i) {
        FetchedResultsControllerModelChange *change = mutableChanges[i];
        FetchedResultsControllerModelChange *changePair = [self findPairForChange:change
                                                                           inChanges:mutableChanges
                                                                           fromIndex:i + 1];
        
        if (changePair) {
            if ([change isKindOfClass:[FetchedResultsControllerModelChangeObject class]]) {
                FetchedResultsControllerModelChangeObject *changeObject = (FetchedResultsControllerModelChangeObject *)change;
                FetchedResultsControllerModelChangeObject *changeObjectPair = (FetchedResultsControllerModelChangeObject *)changePair;
                
                FetchedResultsControllerDelegateEvent *delegateEvent = [self delegateEventFromChangesForSameObject:@[changeObject, changeObjectPair]
                                                                                                  appliedToModelState:modelState];
                
                [delegateEvents addObject:delegateEvent];
            }
            
            [mutableChanges removeObject:changePair];
        }
        else {
            FetchedResultsControllerDelegateEvent *delegateEvent;
            
            if ([change isKindOfClass:[FetchedResultsControllerModelChangeSection class]]) {
                FetchedResultsControllerModelChangeSection *changeSection = (FetchedResultsControllerModelChangeSection *)change;
                delegateEvent = [self delegateEventFromSectionChange:changeSection appliedToModelState:modelState];
            }
            else {
                FetchedResultsControllerModelChangeObject *changeObject = (FetchedResultsControllerModelChangeObject *)change;
                delegateEvent = [self delegateEventFromObjectChange:changeObject appliedToModelState:modelState];
            }
            
            [delegateEvents addObject:delegateEvent];
        }
    }
    
    return delegateEvents.copy;
}

+ (void)updateDelegateEvents:(NSArray<FetchedResultsControllerDelegateEvent *> *)delegateEvents
       appliedFromModelState:(id<FetchedResultsControllerModelState>)modelState {
    for (FetchedResultsControllerDelegateEvent *delegateEvent in delegateEvents) {
        if ([delegateEvent isKindOfClass:FetchedResultsControllerDelegateEventObject.class]) {
            FetchedResultsControllerDelegateEventObject *objectDelegateEvent = (FetchedResultsControllerDelegateEventObject *)delegateEvent;
            [self updateObjectDelegateEvent:objectDelegateEvent
                      appliedFromModelState:modelState];
        }
        else if ([delegateEvent isKindOfClass:FetchedResultsControllerDelegateEventSection.class]) {
            FetchedResultsControllerDelegateEventSection *sectionDelegateEvent = (FetchedResultsControllerDelegateEventSection *)delegateEvent;
            if (sectionDelegateEvent.changeType != FetchedResultsChangeInsert) {
                [self updateSectionDelegateEvent:sectionDelegateEvent appliedToModelState:modelState];
            }
        }
    }
}

+ (void)updateObjectDelegateEvent:(FetchedResultsControllerDelegateEventObject *)delegateEvent appliedFromModelState:(id<FetchedResultsControllerModelState>)modelState {
    delegateEvent.fromIndexPath = [modelState indexPathForObject:delegateEvent.object];
    if (delegateEvent.fromIndexPath && delegateEvent.toIndexPath) {
        delegateEvent.changeType = [self fetchedResultsChangeTypeForFromIndexPath:delegateEvent.fromIndexPath
                                                                      toIndexPath:delegateEvent.toIndexPath];
    }
}

+ (void)updateSectionDelegateEvent:(FetchedResultsControllerDelegateEventSection *)delegateEvent appliedToModelState:(id<FetchedResultsControllerModelState>)modelState {
    NSObject<FetchedResultsSectionInfoProtocol> *sectionInfo = [modelState sectionInfoWithName:delegateEvent.sectionName];
    ///AssertsectionInfo, nil);
    delegateEvent.sectionInfo = sectionInfo;
    delegateEvent.sectionIndex = [modelState indexOfSectionInfo:sectionInfo];
}

+ (FetchedResultsControllerModelChange *)findPairForChange:(FetchedResultsControllerModelChange *)change inChanges:(NSArray<FetchedResultsControllerModelChange *> *)changes fromIndex:(int)fromIndex {
    FetchedResultsControllerModelChange *pair;
    
    for (int i = fromIndex; i < changes.count; ++i) {
        FetchedResultsControllerModelChange *currentChange = changes[i];
        if ([change isChangeOnSameObject:currentChange]) {
            pair = currentChange;
            break;
        }
    }
    
    return pair;
}

- (NSString *)stringFromChangeType:(FetchedResultsChangeType)changeType {
    switch (changeType) {
        case FetchedResultsChangeInsert: {
            return @"Insert";
        }
        
        case FetchedResultsChangeDelete: {
            return @"Delete";
        }
        
        case FetchedResultsChangeMove: {
            return @"Move";
        }
            
        case FetchedResultsChangeUpdate: {
            return @"Update";
        }
            
        default: {
            return nil;
        }
    }
}

- (void)notifyFetchedResultsControllerDelegate:(FetchedResultsController *)fetchedResultsController {
    OBJECT_ABSTRACT_METHOD;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p>", NSStringFromClass(self.class), self];
}

- (NSString *)debugDescription {
    return self.description;
}

@end

#pragma mark - FetchedResultsControllerDelegateEventObject

@implementation FetchedResultsControllerDelegateEventObject

- (NSString *)description {
    NSString *result = [super description];
    result = [result stringByAppendingFormat:@"(" \
              "\n\tobject: %@" \
              "\n\ttype: %@\n" \
              "\n\tfromIndexPath: %@" \
              "\n\ttoIndexPath: %@" \
              ")",
              self.object,
              [self stringFromChangeType:self.changeType],
              self.fromIndexPath,
              self.toIndexPath];
    return result;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    BOOL result = NO;
    if ([object isKindOfClass:self.class]) {
        result = [self isEqualToDelegateEventObject:object];
    }
    return result;
}

- (BOOL)isEqualToDelegateEventObject:(FetchedResultsControllerDelegateEventObject *)event {
    BOOL isFromIndexPathEqual = (self.fromIndexPath == event.fromIndexPath) || [self.fromIndexPath isEqual:event.fromIndexPath];
    BOOL isToIndexPathEqual = (self.toIndexPath == event.toIndexPath) || [self.toIndexPath isEqual:event.toIndexPath];
    
    BOOL result = [self.object isEqual:event.object]
               && (self.changeType == event.changeType)
               && isFromIndexPathEqual
               && isToIndexPathEqual;
    
    return result;
}

- (void)notifyFetchedResultsControllerDelegate:(FetchedResultsController *)fetchedResultsController {
    id<FetchedResultsControllerDelegate> delegate = fetchedResultsController.delegate;
    if ([delegate respondsToSelector:@selector(sp_controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:)]) {
        [delegate sp_controller:fetchedResultsController didChangeObject:self.object atIndexPath:self.fromIndexPath forChangeType:self.changeType newIndexPath:self.toIndexPath];
    }
}

@end

#pragma mark - FetchedResultsControllerDelegateEventSection

@implementation FetchedResultsControllerDelegateEventSection

- (NSString *)description {
    NSString *result = [super description];
    result = [result stringByAppendingFormat:@"(" \
              "\n\tsectionInfo: %@" \
              "\n\ttype: %@" \
              "\n\tsectionIndex: %lu" \
              ")",
              self.sectionInfo,
              [self stringFromChangeType:self.changeType],
              (unsigned long)self.sectionIndex];
    return result;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    BOOL result = NO;
    if ([object isKindOfClass:self.class]) {
        result = [self isEqualToDelegateEventSection:object];
    }
    return result;
}

- (BOOL)isEqualToDelegateEventSection:(FetchedResultsControllerDelegateEventSection *)event {
    BOOL isSectionInfoEqual = ((self.sectionInfo.name == event.sectionInfo.name)
                           || [self.sectionInfo.name isEqual:event.sectionInfo.name]);
    BOOL result = isSectionInfoEqual && (self.sectionIndex == event.sectionIndex);
    return result;
}

- (void)notifyFetchedResultsControllerDelegate:(FetchedResultsController *)fetchedResultsController {
    id<FetchedResultsControllerDelegate> delegate = fetchedResultsController.delegate;
    if ([delegate respondsToSelector:@selector(sp_controller:didChangeSection:atIndex:forChangeType:)]) {
        [delegate sp_controller:fetchedResultsController didChangeSection:self.sectionInfo atIndex:self.sectionIndex forChangeType:self.changeType];
    }
}

@end
