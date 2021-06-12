//
//  VCCMain.h
//  VungleCC
//
//  Created by Chao Zhang on 2021/6/12.
//

#import "VCCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCCMain : VCCBaseModel

@property (nonatomic, assign) double temp_max;
@property (nonatomic, assign) double temp_min;
@property (nonatomic, assign) double temp;
@property (nonatomic, assign) double feels_like;
@property (nonatomic, assign) NSInteger humidity;
@property (nonatomic, assign) NSInteger pressure;

@end

NS_ASSUME_NONNULL_END
