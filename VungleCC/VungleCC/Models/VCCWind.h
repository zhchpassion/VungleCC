//
//  VCCWind.h
//  VungleCC
//
//  Created by Chao Zhang on 2021/6/12.
//

#import "VCCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCCWind : VCCBaseModel

@property (nonatomic, assign) NSInteger deg;
@property (nonatomic, assign) double speed;
@property (nonatomic, assign) double gust;

@end

NS_ASSUME_NONNULL_END
