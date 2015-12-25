//
//  TodayViewController.m
//  SystemPreference
//
//  Created by moyekong on 15/12/9.
//  Copyright © 2015年 wiwide. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "MKSystemPreferenceModel.h"
#import "MKSystemPreferenceItem.h"
#import "MKCustomButton.h"

@interface TodayViewController () <NCWidgetProviding, MKCustomButtonDelegate>

@property (weak, nonatomic) IBOutlet MKCustomButton *leftButton;
@property (weak, nonatomic) IBOutlet MKCustomButton *centerButton;
@property (weak, nonatomic) IBOutlet MKCustomButton *rightButton;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation TodayViewController

static NSInteger buttonBeginTagValue = 540;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDefaultsDidChange:)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDefaultsDidChange:)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setPreferredContentSize:CGSizeMake(self.view.bounds.size.width, 64.0)];
    
    self.dataArray = [MKSystemPreferenceModel systemPreferenceArray];
    [self updateUI];
}

- (void)userDefaultsDidChange:(NSNotification *)notification {
    NSLog(@"notification");
    self.dataArray = [MKSystemPreferenceModel systemPreferenceArray];
    [self updateUI];
}

- (void)updateUI {
    [self setupButtonUI:self.leftButton tag:buttonBeginTagValue + 0];
    [self setupButtonUI:self.centerButton tag:buttonBeginTagValue + 1];
    [self setupButtonUI:self.rightButton tag:buttonBeginTagValue + 2];
    
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MKSystemPreferenceItem *item = (MKSystemPreferenceItem *)obj;
        NSLog(@"%@------%@", item.title, item.idString);
    }];
    if (self.dataArray) {
        for (int i = 0; i < self.dataArray.count; i++) {
            MKSystemPreferenceItem *targetItem = self.dataArray[i];
            MKCustomButton *tempButton = [self targetButtonWithTag:i];
            if (tempButton) {
                tempButton.displayLabel.text = targetItem.title;
                tempButton.displayImageView.image = [UIImage imageNamed:targetItem.imageName];
            }
        }
//        MKSystemPreferenceItem *targetLeftItem = self.dataArray[0];
//        MKSystemPreferenceItem *targetCenterItem = self.dataArray[1];
//        MKSystemPreferenceItem *targetRightItem = self.dataArray[2];
//
//        self.leftButton.displayLabel.text = targetLeftItem.title;
//        self.leftButton.displayImageView.image = [UIImage imageNamed:targetLeftItem.imageName];
//        self.centerButton.displayLabel.text = targetCenterItem.title;
//        self.centerButton.displayImageView.image = [UIImage imageNamed:targetCenterItem.imageName];
//        self.rightButton.displayLabel.text = targetRightItem.title;
//        self.rightButton.displayImageView.image = [UIImage imageNamed:targetRightItem.imageName];
    }
}

- (void)setupButtonUI:(MKCustomButton *)targetButton
                  tag:(NSInteger)tagValue
{
    CGFloat fontSize = 12.0;
    UIColor *fontColor = [UIColor whiteColor];
    targetButton.displayLabel.font = [UIFont systemFontOfSize:fontSize];
    targetButton.displayLabel.textColor = fontColor;
    targetButton.tag = tagValue;
}

- (MKCustomButton *)targetButtonWithTag:(NSInteger)tag {
    for (id object in self.view.subviews) {
        if ([object isKindOfClass:[MKCustomButton class]]) {
            MKCustomButton *tempButton = (MKCustomButton *)object;
            if (tempButton.tag == (tag + buttonBeginTagValue)) {
                return tempButton;
            }
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openSetting:(MKCustomButton *)sender {
    NSInteger btnTag = sender.tag - buttonBeginTagValue;
    [self jumpToSystemPreferenceWithNumber:btnTag];
}

- (void)selectButtonWithButtonTag:(NSInteger)btnTag {
    NSInteger tempTag = btnTag - buttonBeginTagValue;
    [self jumpToSystemPreferenceWithNumber:tempTag];
}

- (void)jumpToSystemPreferenceWithNumber:(NSInteger)tagNum {
    MKSystemPreferenceItem *targetItem = self.dataArray[tagNum];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@", targetItem.prefs]];
    NSLog(@"%@", targetItem.prefs);
    [self.extensionContext openURL:url completionHandler:nil];
}

- (void)beginRequestWithExtensionContext:(NSExtensionContext *)context {

}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}

@end
