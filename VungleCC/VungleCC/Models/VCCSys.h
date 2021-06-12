//
//  VCCSys.h
//  VungleCC
//
//  Created by Chao Zhang on 2021/6/12.
//

#import "VCCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCCSys : VCCBaseModel

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, assign) NSInteger sunrise;
@property (nonatomic, assign) NSInteger sunset;
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
