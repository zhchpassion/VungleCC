//
//  ViewController.m
//  VungleDemo
//
//  Created by Chao Zhang on 2021/6/12.
//

#import "ViewController.h"
#import <VCCWeatherFetcher.h>

#define kScreenWidth            ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight           ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()

@property (nonatomic, strong) VCCWeatherFetcher *fetcher;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UILabel *scLabel;
@property (nonatomic, strong) UISegmentedControl *sc;

@property (nonatomic, strong) UILabel *zipLabel;
@property (nonatomic, strong) UITextField *zipTF;
@property (nonatomic, strong) UILabel *countryLabel;
@property (nonatomic, strong) UITextField *countryTF;

@property (nonatomic, strong) UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.sc];
    [self.view addSubview:self.scLabel];
    [self.view addSubview:self.zipLabel];
    [self.view addSubview:self.countryLabel];
    [self.view addSubview:self.zipTF];
    [self.view addSubview:self.countryTF];
    [self.view addSubview:self.button];
    self.fetcher = [[VCCWeatherFetcher alloc] init];
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)buttonPressed:(UIButton *)sender {
    self.fetcher.tempUnit = self.sc.selectedSegmentIndex;
    self.fetcher.zipCode = self.zipTF.text;
    self.fetcher.countryCode = self.countryTF.text;
    self.textView.text = @"Fetching Data..........";
    self.button.enabled = NO;
    __weak typeof(self) weakSelf = self;
    [self.fetcher getWeatherWithCompletionHandler:^(BOOL success, VCCWeather * _Nullable weather, NSError * _Nullable error) {
        weakSelf.button.enabled = YES;
        if (error) {
            [weakSelf generateErrorTextToTexView:error];
            return;
        }
        [weakSelf generateOutputToTextView:weather];
    }];
}

- (void)generateOutputToTextView:(VCCWeather *)weather {
    NSString *unit = self.fetcher.tempUnit == VCCWFTemperatureUnitKelvin ? @"K" : @"ºC";
    NSString *output = @"";
    NSString *line = [NSString stringWithFormat:@"Region Name: %@\n", weather.name];
    output = [output stringByAppendingString:line];
    line = [NSString stringWithFormat:@"Current Temp: %.1lf%@\n", weather.main.temp, unit];
    output = [output stringByAppendingString:line];
    line = [NSString stringWithFormat:@"Max/Min Temp: %.1lf%@/%.1lf%@\n", weather.main.temp_max, unit, weather.main.temp_min, unit];
    output = [output stringByAppendingString:line];
    line = [NSString stringWithFormat:@"Fetch Time: %@", weather.localDateString];
    output = [output stringByAppendingString:line];
    self.textView.text = output;
}

- (void)generateErrorTextToTexView:(NSError *)error {
    NSString *output = @"Oops!! error occoured:\n";
    NSString *line = [NSString stringWithFormat:@"Error code: %ld\n", error.code];
    output = [output stringByAppendingString:line];
    line = [NSString stringWithFormat:@"Error Message: %@\n", [error.userInfo objectForKey:NSLocalizedDescriptionKey]];
    output = [output stringByAppendingString:line];
    self.textView.text = output;
}

#pragma mark - getters
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor yellowColor];
        _textView.editable = NO;
        _textView.text = @"Please set up parameters";
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.textColor = [UIColor blackColor];
        _textView.frame = CGRectMake(20, 80, kScreenWidth - 40, 100);
    }
    return _textView;
}

- (UISegmentedControl *)sc {
    if (!_sc) {
        _sc = [[UISegmentedControl alloc] initWithItems:@[@"Kelvin", @"Celsius"]];
        _sc.selectedSegmentTintColor = [UIColor blueColor];
        _sc.frame = CGRectMake((kScreenWidth - 120)/2.0, 235, 120, 40);
        _sc.selectedSegmentIndex = 0;
    }
    return _sc;
}

- (UILabel *)scLabel {
    if (!_scLabel) {
        _scLabel = [[UILabel alloc] init];
        _scLabel.textAlignment = NSTextAlignmentCenter;
        _scLabel.frame = CGRectMake(20, 200, kScreenWidth - 40, 40);
        _scLabel.text = @"Select temperature unit";
        _scLabel.textColor = [UIColor blackColor];
    }
    return _scLabel;
}

- (UILabel *)zipLabel {
    if (!_zipLabel) {
        _zipLabel = [[UILabel alloc] init];
        _zipLabel.frame = CGRectMake(20, 280, kScreenWidth - 40, 40);
        _zipLabel.textAlignment = NSTextAlignmentCenter;
        _zipLabel.text = @"Enter zip code here";
        _zipLabel.textColor = [UIColor blackColor];
    }
    return _zipLabel;
}

- (UILabel *)countryLabel {
    if (!_countryLabel) {
        _countryLabel = [[UILabel alloc] init];
        _countryLabel.frame = CGRectMake(20, 375, kScreenWidth - 40, 40);
        _countryLabel.textAlignment = NSTextAlignmentCenter;
        _countryLabel.text = @"Enter country code here";
        _countryLabel.textColor = [UIColor blackColor];
    }
    return _countryLabel;
}

- (UITextField *)zipTF {
    if (!_zipTF) {
        _zipTF = [[UITextField alloc] init];
        _zipTF.frame = CGRectMake(50, 325, kScreenWidth - 100, 40);
        _zipTF.textColor = [UIColor blackColor];
        _zipTF.keyboardType = UIKeyboardTypeNumberPad;
        _zipTF.backgroundColor = [UIColor whiteColor];
        _zipTF.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _zipTF;
}

- (UITextField *)countryTF {
    if (!_countryTF) {
        _countryTF = [[UITextField alloc] init];
        _countryTF.frame = CGRectMake(50, 420, kScreenWidth - 100, 40);
        _countryTF.textColor = [UIColor blackColor];
        _countryTF.keyboardType = UIKeyboardTypeDefault;
        _countryTF.backgroundColor = [UIColor whiteColor];
        _countryTF.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _countryTF;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:126.0/255.0 blue:54.0/255.0 alpha:1.0];
        _button.frame = CGRectMake(50, 500, kScreenWidth - 100, 40);
        [_button setTitle:@"FetchWeather" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end
