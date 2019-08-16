//
//  FetchedResultsControllerModel.m
//

#import "FetchedResultsControllerModel.h"
#import "NSIndexPath+DataSource.h"
#import "FetchedResultsSectionInfo.h"
#import "FetchedResultsControllerModelChange.h"

@interface FetchedResultsControllerModel ()
{
    Class _sectionInfoClass;
}

@end

@implementation FetchedResultsControllerModel

- (instancetype)init {
    return [self initWithSectionInfoClass:FetchedResultsSectionInfo.class];
}

- (instancetype)initWithSectionInfoClass:(Class)sectionInfoClass {
    ///ParameterAssert(sectionInfoClass);
    self = [super init];
    if (self) {
        _sectionInfoClass = sectionInfoClass;
        _sectionSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        _sections = [[NSMutableArray<id<FetchedResultsSectionInfoProtocol>> alloc] init];
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    FetchedResultsControllerModel *newInstance = [[FetchedResultsControllerModel alloc] init];
    if (!newInstance) {
        return nil;
    }
    newInstance->_sections = [[NSMutableArray<id<FetchedResultsSectionInfoProtocol>> alloc] initWithArray:_sections copyItems:YES];
    newInstance->_objectsSortDescriptor = _objectsSortDescriptor;
    newInstance->_sectionSortDescriptor = _sectionSortDescriptor;
    newInstance->_sectionNameKeyPath = _sectionNameKeyPath;
    newInstance->_sectionInfoClass = _sectionInfoClass;
    newInstance->_objectsPredicate = _objectsPredicate;
    return newInstance;
}

#pragma mark - Public

- (NSArray<id<FetchedResultsSectionInfoProtocol>> *)sections {
    return [_sections copy];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    __unused NSUInteger sectionsCount = self.sections.count;
    ///AssertindexPath.sp_section < sectionsCount, nil);
    
    id<FetchedResultsSectionInfoProtocol> sectionInfo = self.sections[indexPath.sp_section];
    NSArray *objects = sectionInfo.objects;
    __unused NSUInteger objectsCount = objects.count;
    ///AssertindexPath.sp_item < objectsCount, nil);
    
    id object = objects[indexPath.sp_item];
    return object;
}

- (NSIndexPath *)indexPathForObject:(id)object {
    NSIndexPath *indexPath;
    
    for (int section = (int)self.sections.count - 1; section >= 0; --section) {
        id<FetchedResultsSectionInfoProtocol> sectionInfo = self.sections[section];
        
        NSUInteger objectIndex = [sectionInfo.objects indexOfObject:object];
        if (objectIndex != NSNotFound) {
            indexPath = [NSIndexPath sp_indexPathForItem:objectIndex inSection:section];
            break;
        }
    }
    
    return indexPath;
}

- (id<FetchedResultsSectionInfoProtocol>)findSectionInfoWithName:(NSString *)sectionName {
    __block id<FetchedResultsSectionInfoProtocol> sectionInfo;
    [_sections enumerateObjectsUsingBlock:^(id<FetchedResultsSectionInfoProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!sectionName && !obj.name) {
            sectionInfo = obj;
            *stop = YES;
        }
        else if ([obj.name isEqual:sectionName]) {
            sectionInfo = obj;
            *stop = YES;
        }
    }];
    return sectionInfo;
}

- (void)clear {
    [_sections removeAllObjects];
}

- (NSSet *)filteredObjectsFromSet:(NSSet *)objects {
    if (self.objectsPredicate) {
        return [objects filteredSetUsingPredicate:self.objectsPredicate];
    }
    return objects;
}

- (NSArray<FetchedResultsControllerModelChange *> *)insertObjectsAndReturnChanges:(NSSet *)objects {
    NSSet *filteredObjects = [self filteredObjectsFromSet:objects];
    
    NSUInteger objectsCount = filteredObjects.count;
    if (objectsCount == 0) {
        return nil;
    }
    
    NSMutableArray<FetchedResultsControllerModelChange *> *changes = [[NSMutableArray<FetchedResultsControllerModelChange *> alloc] initWithCapacity:objectsCount];
    
    for (id object in filteredObjects) {
        NSString *sectionName = [self sectionNameForObject:object];
        
        id<FetchedResultsSectionInfoProtocol> sectionInfo = [self findSectionInfoWithName:sectionName];
        if (!sectionInfo) {
            sectionInfo = [self createSectionInfoWithName:sectionName];
            [self addSectionInfo:sectionInfo];
            
            NSUInteger sectionIndex = [_sections indexOfObject:sectionInfo];
            FetchedResultsControllerModelChange *sectionChange = [FetchedResultsControllerModelChange changeWithType:FetchedResultsControllerModelChangeInsert
                                                                                                               sectionName:sectionName
                                                                                                              sectionIndex:sectionIndex];
            [changes addObject:sectionChange];
        }
        
        [self addObject:object inSectionInfo:sectionInfo];
        
        NSUInteger sectionIndex = [_sections indexOfObject:sectionInfo];
        NSUInteger objectIndex = [sectionInfo.objects indexOfObject:object];
        NSIndexPath *indexPath = [NSIndexPath sp_indexPathForItem:objectIndex inSection:sectionIndex];
        FetchedResultsControllerModelChange *sectionChange = [FetchedResultsControllerModelChange changeWithType:FetchedResultsControllerModelChangeInsert
                                                                                                                object:object
                                                                                                             indexPath:indexPath];
        [changes addObject:sectionChange];
    }
    
    return changes.copy;
}

- (NSArray<FetchedResultsControllerModelChange *> *)removeObjectsAndReturnChanges:(NSSet *)objects {
    NSUInteger objectsCount = objects.count;
    if (objectsCount == 0) {
        return nil;
    }
    
    NSMutableArray<FetchedResultsControllerModelChange *> *changes = [[NSMutableArray<FetchedResultsControllerModelChange *> alloc] initWithCapacity:objectsCount];
    
    for (id object in objects) {
        int sectionsCount = (int)_sections.count;
        for (int sectionIndex = sectionsCount - 1; sectionIndex >= 0; --sectionIndex) {
            FetchedResultsSectionInfo *sectionInfo = _sections[sectionIndex];
            NSUInteger objectIndex = [sectionInfo indexOfObject:object];
            if (objectIndex != NSNotFound) {
                [sectionInfo removeObjectAtIndex:objectIndex];
                
                NSIndexPath *indexPath = [NSIndexPath sp_indexPathForItem:objectIndex inSection:sectionIndex];
                FetchedResultsControllerModelChange *sectionChange = [FetchedResultsControllerModelChange changeWithType:FetchedResultsControllerModelChangeDelete
                                                                                                                        object:object
                                                                                                                     indexPath:indexPath];
                [changes addObject:sectionChange];
                
                BOOL isSectionEmpty = (sectionInfo.objects.count == 0);
                if (isSectionEmpty) {
                    [_sections removeObjectAtIndex:sectionIndex];
                    
                    FetchedResultsControllerModelChange *sectionChange = [FetchedResultsControllerModelChange changeWithType:FetchedResultsControllerModelChangeDelete
                                                                                                                       sectionName:sectionInfo.name
                                                                                                                      sectionIndex:sectionIndex];
                    [changes addObject:sectionChange];
                }
                
                break;
            }
        }
    }
    
    return changes.copy;
}

- (NSArray<FetchedResultsControllerModelChange *> *)updateOrMoveObjectsAndReturnChanges:(NSSet *)objects {
    NSUInteger objectsCount = objects.count;
    if (objectsCount == 0) {
        return nil;
    }
    
    NSArray<FetchedResultsControllerModelChange *> *removeChanges = [self removeObjectsAndReturnChanges:objects];
    NSArray<FetchedResultsControllerModelChange *> *insertChanges = [self insertObjectsAndReturnChanges:objects];
    
    NSUInteger changesCapacity = removeChanges.count + insertChanges.count;
    NSMutableArray<FetchedResultsControllerModelChange *> *changes = [[NSMutableArray alloc] initWithCapacity:changesCapacity];
    [changes addObjectsFromArray:removeChanges];
    [changes addObjectsFromArray:insertChanges];
    
    return changes.copy;
}

#pragma mark - Private

- (NSString *)sectionNameForObject:(NSObject *)object {
    if (self.sectionNameKeyPath.length == 0) {
        return nil;
    }
    
    NSObject *value = [object valueForKeyPath:self.sectionNameKeyPath];
    return value.description;
}

- (id<FetchedResultsSectionInfoProtocol>)createSectionInfoWithName:(NSString *)sectionName {
    id<FetchedResultsSectionInfoProtocol> sectionInfo = [[_sectionInfoClass alloc] initWithName:sectionName];
    return sectionInfo;
}

- (void)addObject:(id)object inSectionInfo:(FetchedResultsSectionInfo *)sectionInfo {
    NSComparator comparator = ^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = [self.objectsSortDescriptor compareObject:obj1 toObject:obj2];
        return result;
    };
    
    NSRange range = NSMakeRange(0, sectionInfo.objects.count);
    NSUInteger insertIndex = [sectionInfo.objects indexOfObject:object
                                                  inSortedRange:range
                                                        options:NSBinarySearchingInsertionIndex
                                                usingComparator:comparator];
    ///AssertinsertIndex != NSNotFound, nil);
    
    [sectionInfo insertObject:object atIndex:insertIndex];
}

- (void)addSectionInfo:(id<FetchedResultsSectionInfoProtocol>)sectionInfo {
    NSComparator comparator = ^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = [self.sectionSortDescriptor compareObject:obj1 toObject:obj2];
        return result;
    };
    
    NSRange range = NSMakeRange(0, _sections.count);
    NSUInteger insertIndex = [_sections indexOfObject:sectionInfo
                                        inSortedRange:range
                                              options:NSBinarySearchingInsertionIndex
                                      usingComparator:comparator];
    ///AssertinsertIndex != NSNotFound, nil);
    
    [_sections insertObject:sectionInfo atIndex:insertIndex];
}

@end
