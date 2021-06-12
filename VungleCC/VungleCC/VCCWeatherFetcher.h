//
//  VCCWeatherFetcher.h
//  VungleCC
//
//  Created by Chao Zhang on 2021/6/10.
//

#import <Foundation/Foundation.h>
#import <VCCWeather.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSInteger kVCCErrorCodeNoLocationAuthorization      = -10001;     // geo location authorization not obtained
FOUNDATION_EXTERN NSInteger kVCCErrorCodeInvalidZipCode               = -10002;     // invalid zip code
FOUNDATION_EXTERN NSInteger kVCCErrorCodeUndefined                    = -10003;     // undefined error

/// success: whether is the request succeeded
/// weather: response weather model, might be nil
/// error: error generated, might be nil
typedef void(^VCCWFCompletionHandler)(BOOL success, VCCWeather *_Nullable weather, NSError *_Nullable error);

typedef NS_ENUM(NSUInteger, VCCWFTemperatureUnit) {
    VCCWFTemperatureUnitKelvin              = 0,    // unit K
    VCCWFTemperatureUnitCelsius             = 1,    // unit ºC
};

/*
 a VCCWeatherFetcher object is the worker for fetching weather data.
 the properties will be used as request parameters, to configure the content of response data.
 Property `tempUnit` is the unit of temperature, VCCWFTemperatureUnitKelvin is the default value;
 Property `zipCode` is the zip code of city;
 Property `countryCode` is the country code;
 Reminder: zipCode and countryCode should be provided together. If any of the two is left unset, the fetcher will try to fetch weather using current geolocation.
 */
@interface VCCWeatherFetcher : NSObject

/// unit for temperature data in returned weather
@property (nonatomic, assign) VCCWFTemperatureUnit          tempUnit;

/// zip code
@property (nonatomic, copy, nullable) NSString *            zipCode;

/// country code
@property (nonatomic, copy, nullable) NSString *            countryCode;

/// request weather data with given conditions
/// @param complete the completion handler for respose/error
- (void)getWeatherWithCompletionHandler:(nullable VCCWFCompletionHandler)complete;

@end

NS_ASSUME_NONNULL_END
