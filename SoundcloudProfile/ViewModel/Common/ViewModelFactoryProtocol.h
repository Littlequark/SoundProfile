//
//  ViewModelFactoryProtocol.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ViewModelFactoryProtocol <NSObject>

+ (id _Nullable)viewModelWithModel:(id)model;

@optional
@property (nonatomic, nullable) id model;

@end

NS_ASSUME_NONNULL_END
