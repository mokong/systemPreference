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

@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftDisplayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (weak, nonatomic) IBOutlet UILabel *centerDisplayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightDisplayLabel;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation TodayViewController

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
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MKSystemPreferenceItem *item = (MKSystemPreferenceItem *)obj;
        NSLog(@"%@------%@", item.title, item.idString);
    }];
    if (self.dataArray) {
        MKSystemPreferenceItem *targetLeftItem = self.dataArray[0];
        MKSystemPreferenceItem *targetCenterItem = self.dataArray[1];
        MKSystemPreferenceItem *targetRightItem = self.dataArray[2];

        self.leftDisplayLabel.text = targetLeftItem.title;
        self.centerDisplayLabel.text = targetCenterItem.title;
        self.rightDisplayLabel.text = targetRightItem.title;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openCellularSetting:(id)sender {
    [self jumpToSystemPreferenceWithNumber:0];
}

- (IBAction)openWIFISetting:(id)sender {
    [self jumpToSystemPreferenceWithNumber:1];
}

- (IBAction)openBatterySetting:(id)sender {
    [self jumpToSystemPreferenceWithNumber:2];
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
