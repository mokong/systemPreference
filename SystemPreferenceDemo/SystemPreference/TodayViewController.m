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
#import "UIButton+ImageTitleSpacing.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *centerButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
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
    
    self.leftButton.tag = buttonBeginTagValue + 0;
    self.centerButton.tag = buttonBeginTagValue + 1;
    self.rightButton.tag = buttonBeginTagValue + 2;

    if (self.dataArray) {

        MKSystemPreferenceItem *targetLeftItem = self.dataArray[0];
        MKSystemPreferenceItem *targetCenterItem = self.dataArray[1];
        MKSystemPreferenceItem *targetRightItem = self.dataArray[2];
        
        [self.leftButton setTitle:targetLeftItem.title forState:UIControlStateNormal];
        [self.leftButton setImage:[UIImage imageNamed:targetLeftItem.imageName] forState:UIControlStateNormal];
        [self.leftButton centerButtonAndImageWithSpacing:15.0];
        
        [self.centerButton setTitle:targetCenterItem.title forState:UIControlStateNormal];
        [self.centerButton setImage:[UIImage imageNamed:targetCenterItem.imageName] forState:UIControlStateNormal];
        [self.centerButton centerButtonAndImageWithSpacing:15.0];
        
        [self.rightButton setTitle:targetRightItem.title forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage imageNamed:targetRightItem.imageName] forState:UIControlStateNormal];
        [self.rightButton centerButtonAndImageWithSpacing:15.0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openSetting:(id)sender {
    NSInteger btnTag = ((UIButton *)sender).tag - buttonBeginTagValue;
    [self jumpToSystemPreferenceWithNumber:btnTag];

}

- (void)selectButtonWithButtonTag:(NSInteger)btnTag {
    NSInteger tempTag = btnTag - buttonBeginTagValue;
    [self jumpToSystemPreferenceWithNumber:tempTag];
}

- (void)jumpToSystemPreferenceWithNumber:(NSInteger)tagNum {
    MKSystemPreferenceItem *targetItem = self.dataArray[tagNum];
    NSURL *url;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"Prefs:root=%@", targetItem.prefs]];
    }
    else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@", targetItem.prefs]];
    }
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
