//
//  MKSystemCollectionViewController.m
//  SystemPreferenceDemo
//
//  Created by moyekong on 12/23/15.
//  Copyright © 2015 wiwide. All rights reserved.
//

#import "MKSystemCollectionViewController.h"
#import "MKSystemCollectionViewCell.h"
#import "MKSystemPreferenceModel.h"
#import "MKSystemPreferenceItem.h"
#import "UIButton+ImageTitleSpacing.h"

@interface MKSystemCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray; // 存放的是title

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

@implementation MKSystemCollectionViewController

static NSString * const reuseIdentifier = @"MKSystemCollectionViewCell";
static NSInteger buttonTagBeginValue = 240;

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.0];
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MKSystemCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray arrayWithArray:[MKSystemPreferenceModel systemPreferenceArray]];
    
    
    // 添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestureRecognized:)];
    [self.collectionView addGestureRecognizer:longPress];
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

#pragma mark - 长按
- (void)longGestureRecognized:(id)sender {
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    // 1. 获取在collectionView中长按的位置;
    CGPoint location = [longPress locationInView:self.collectionView];
    
    // 2. 找出这个位置对应的cell的index
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    static UIView *snapShot = nil; // a snapshot of the row user is moving
    static NSIndexPath *sourceIndexPath = nil; // Initical IndexPath, where gesture begins
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            if (indexPath) {
                sourceIndexPath = indexPath;
                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method
                snapShot = [self customSnapShotFromView:cell];
                
                // Add the snapshot as a subview, centered at cell's center
                __block CGPoint center = cell.center;
                snapShot.center = center;
                snapShot.alpha = 0.0;
                [self.collectionView addSubview:snapShot];
                [UIView animateWithDuration:0.25 animations:^{
                    // Offset for gesture location
                    center.y = location.y;
                    snapShot.center = center;
                    snapShot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapShot.alpha = 0.98;
                    
                    // Black out
                    cell.backgroundColor = [UIColor blackColor];
                }];
                
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint center = snapShot.center;
            center.y = location.y;
            center.x = location.x;
            snapShot.center = center;
            
            // Is destination valid and is is it different from source
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                // update the datasource
                [self.dataArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // move the rows
                [self.collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // and update sources so it is in sync with UI changes
                sourceIndexPath = indexPath;
            }
        }
            break;
        default:
        {
            // Clean up
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                snapShot.center = cell.center;
                snapShot.transform = CGAffineTransformIdentity;
                snapShot.alpha = 0.0;
                
                // Undo the black out effect we did
                cell.backgroundColor = [UIColor whiteColor];
            } completion:^(BOOL finished) {
                [snapShot removeFromSuperview];
                snapShot = nil;
                [MKSystemPreferenceModel saveDataWithArray:self.dataArray];
            }];
            sourceIndexPath = nil;
        }
            break;
    }
    
}

- (UIView *)customSnapShotFromView:(UIView *)inputView {
    UIView *snapShot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapShot.layer.masksToBounds = NO;
    snapShot.layer.cornerRadius = 0.0;
    snapShot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapShot.layer.shadowRadius = 5.0;
    snapShot.layer.shadowOpacity = 0.4;
    return snapShot;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MKSystemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(MKSystemCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray) {
        MKSystemPreferenceItem *item = self.dataArray[indexPath.row];
        
        [cell.displayButton setImage:[UIImage imageNamed:item.imageName] forState:UIControlStateNormal];
        [cell.displayButton setTitle:item.title forState:UIControlStateNormal];

        [cell.displayButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:20.0];
        
        item.idString = [NSString stringWithFormat:@"%ld", indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        [cell.displayButton addTarget:self action:@selector(displaySettings:) forControlEvents:UIControlEventTouchUpInside];
        cell.displayButton.tag = buttonTagBeginValue + indexPath.row;
    }
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select collectionView");
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSInteger rowNumber = indexPath.row;
    [self openSettingsWithValue:rowNumber];
}

- (void)displaySettings:(UIButton *)sender {
    NSLog(@"button");
    NSInteger tagValue = sender.tag - buttonTagBeginValue;
    [self openSettingsWithValue:tagValue];
}

- (void)selectButtonWithButtonTag:(NSInteger)btnTag {
    NSInteger tagValue = btnTag - buttonTagBeginValue;
    [self openSettingsWithValue:tagValue];
}

- (void)openSettingsWithValue:(NSInteger)rowNumber {
    MKSystemPreferenceItem *item = self.dataArray[rowNumber];
    NSString *prefs = item.prefs;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@", prefs]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}




@end
