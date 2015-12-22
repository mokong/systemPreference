//
//  MKSystemPreferenceListController.m
//  SystemPreferenceDemo
//
//  Created by moyekong on 15/12/9.
//  Copyright © 2015年 wiwide. All rights reserved.
//

#import "MKSystemPreferenceListController.h"
#import "MKSystemPreferenceCell.h" // cell
#import "MKSystemPreferenceModel.h"
#import <NSObject+YYModel.h>
#import "MKSystemPreferenceItem.h"

@interface MKSystemPreferenceListController ()

@property (nonatomic, strong) NSMutableArray *dataArray; // 存放的是title
@property (nonatomic, assign) BOOL canMove; // 用于判断是否可以移动

/**
 *  @brief 参数配置
 
 http://forums.macrumors.com/threads/ios-8-widget-customisations-using-launcher.1782093/
 
 - Siri: prefs:root=General&path=SIRI
 - Personal Hotspot: prefs:root=INTERNET_TETHERING
 - Location Services: prefs:root=LOCATION_SERVICES
 - Cellular/Mobile Data: prefs:root=MOBILE_DATA_SETTINGS_ID
 - Sounds: prefs:root=Sounds
 - Notifications: prefs:root=NOTIFICATIONS_ID
 - Background App Refresh: prefs:root=General&path=AUTO_CONTENT_DOWNLOAD
 - Battery (iOS8): prefs:root=General&path=USAGE/BATTERY_USAGE
 - Battery (updated for iOS 9): prefs:root=BATTERY_USAGE
 - VPN: prefs:root=General&path=VPN
 - Settings App: prefs:root
 - SIM Apps: prefs:root=Phone&path=SIMToolkit
 - Display & Brightness: prefs:root=Display&Brightness
 - CallerID : prefs:root=Phone&path=CallerID
 
 - Apple News app: applenews:// (iOS9 only)
 - Phone App: mobilephone://
 - TestFlight App: itms-beta://
 - Notes: mobilenotes://
 
 */

@end

@implementation MKSystemPreferenceListController

static NSString * const kCellReuseIdentifier = @"MKSystemPreferenceCell";

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MKSystemPreferenceCell class]) bundle:nil] forCellReuseIdentifier:kCellReuseIdentifier];
        _canMove = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(beginEdit:)];
    self.dataArray = [NSMutableArray arrayWithArray:[MKSystemPreferenceModel systemPreferenceArray]];
    
    // add longPressGesture to tableView
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
}

- (void)setCanMove:(BOOL)canMove {
    _canMove = canMove;
    self.tableView.editing = _canMove;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)updateRightBarButtonItem {
    if (_canMove) {
        self.navigationItem.rightBarButtonItem.title = @"完成";
    } else {
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKSystemPreferenceCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    if (self.dataArray) {
        MKSystemPreferenceItem *item = self.dataArray[indexPath.row];
        cell.displayTitleLabel.text = item.title;
        item.idString = [NSString stringWithFormat:@"%ld", indexPath.row];
    }
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger rowNumber = indexPath.row;
    MKSystemPreferenceItem *item = self.dataArray[rowNumber];
    NSString *prefs = item.prefs;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@", prefs]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath != destinationIndexPath) {
        NSString *stringToMove = [self.dataArray objectAtIndex:sourceIndexPath.row];
        [self.dataArray removeObjectAtIndex:sourceIndexPath.row];
        [self.dataArray insertObject:stringToMove atIndex:destinationIndexPath.row];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return _canMove;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    }
    return _canMove;
}

#pragma mark - 开始编辑
- (void)beginEdit:(UIBarButtonItem *)sender {
    self.canMove = !self.canMove;
    if ([sender.title isEqualToString: @"完成"]) {
        [MKSystemPreferenceModel saveDataWithArray:self.dataArray];
    }
    [self updateRightBarButtonItem];
}

#pragma mark - gesture method
- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)gesture {
    UIGestureRecognizerState state = gesture.state;
    
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView *snapshot = nil; // a snapshot of the row user is moving
    static NSIndexPath *sourceIndexPath = nil; // initial indexPath, where gesture is begin
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            if (indexPath) {
                {
                    sourceIndexPath = indexPath;
                    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                    
                    // Take a snapshot of the selected row using helped method.
                    snapshot = [self customSnapshotFromView:cell];
                    
                    // Add the snapshot as subview, centered at cell's center
                    __block CGPoint center = cell.center;
                    snapshot.center = center;
                    snapshot.alpha = 0.0;
                    [self.tableView addSubview:snapshot];
                    
                    [UIView animateWithDuration:0.25 animations:^{
                        // offset for gesture location
                        center.y = location.y;
                        snapshot.center = center;
                        snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                        snapshot.alpha = 0.98;
                        
                        // Black out
                        cell.backgroundColor = [UIColor blackColor];
                    }];
                }
            }
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                // update dataSource
                [self.dataArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // move the rows
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // and update source so it is in sync with UI changes
                sourceIndexPath = indexPath;
            }
        }
            break;
            
        default:
        {
            // Clean up
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                // Undo the black-out effect we did
                cell.backgroundColor = [UIColor whiteColor];
            } completion:^(BOOL finished) {
                [snapshot removeFromSuperview];
                snapshot = nil;
            }];
            sourceIndexPath = nil;
        }
            break;
    }
}

- (UIView *)customSnapshotFromView:(UIView *)inputView {
    UIView *snapShot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapShot.layer.masksToBounds = YES;
    snapShot.layer.cornerRadius = 0.0;
    snapShot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapShot.layer.shadowRadius = 5.0;
    snapShot.layer.shadowOpacity = 0.4;
    return snapShot;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
