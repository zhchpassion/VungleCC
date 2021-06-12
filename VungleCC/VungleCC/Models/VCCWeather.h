//
//  VCCWeather.h
//  VungleCC
//
//  Created by Chao Zhang on 2021/6/12.
//

#import "VCCBaseModel.h"
#import "VCCMain.h"
#import "VCCCoord.h"
#import "VCCSys.h"
#import "VCCWind.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCCWeather : VCCBaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) VCCMain *main;
@property (nonatomic, strong) VCCCoord *coord;
@property (nonatomic, strong) VCCSys *sys;
@property (nonatomic, strong) VCCWind *wind;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy)  NSString *localDateString;

@end

NS_ASSUME_NONNULL_END
