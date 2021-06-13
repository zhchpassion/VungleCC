# VungleCC

## How to integrate
To integrate VungleCC into Xcode project using CocoaPods, specify it in `Podfile`:
```
pod 'VungleCC', '0.0.3'
```

## Usage
a `VCCWeatherFetcher` object is the worker for fetching weather data.
 the properties will be used as request parameters, to configure the content of response data.
 Property `tempUnit` is the unit of temperature, VCCWFTemperatureUnitKelvin is the default value;
 Property `zipCode` is the zip code of city;
 Property `countryCode` is the country code;
 Reminder: zipCode and countryCode should be provided together. If any of the two is left unset, the fetcher will try to fetch weather using current geolocation.
 
Using `VCCWeatherFetcher` to fetch weather is quite straightforward, just a single call to the only public API:
```
- (void)getWeatherWithCompletionHandler:(nullable VCCWFCompletionHandler)complete
```
 
Example:
```
VVCCWeatherFetcher *fetcher = [[VCCWeatherFetcher alloc] init];
fetcher.tempUnit = VCCWFTemperatureUnitCelsius;
fetcher.zipCode = @"94040";
fetcher.countryCode = @"us";
[fetcher getWeatherWithCompletionHandler:^(BOOL success, VCCWeather * _Nullable weather, NSError * _Nullable error) {
    if (error) {
        // hint for error
        return;
    }
    // render with valid weather
}];
```

## TODOs
1. error codes have not covered all possible issues, such as network unreachable situations, network request overtime, etc.
2. should provide a mechainsm for unexpectedly terminating the request process. For example, if the use toggled off geolocation authorization when we are updating the location.
3. unit tests do not cover all conditions, for example the undefined error.
4. as I know, in XCTests all privacy authorizations are granted by default. I haven't figured out how to simulate the procedure of obtaining authorizations.