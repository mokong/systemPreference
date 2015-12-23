//
//  ViewController.m
//  SystemPreferenceDemo
//
//  Created by moyekong on 15/12/9.
//  Copyright © 2015年 wiwide. All rights reserved.
//

#import "ViewController.h"
#import "MKSystemPreferenceListController.h"
#import "MKSystemCollectionViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)displaySystemPreferenceList:(id)sender {
    UIButton *clickedButton = (UIButton *)sender;
    if ([clickedButton.currentTitle isEqualToString:@"SystemPreferenceList"]) {
        MKSystemPreferenceListController *systemListVC = [[MKSystemPreferenceListController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:systemListVC animated:YES];
    }
    else {
        MKSystemCollectionViewController *systemCollectionListVC = [[MKSystemCollectionViewController alloc] initWithCollectionViewLayout:[self collectionLayout]];
        [self.navigationController pushViewController:systemCollectionListVC animated:YES];
    }

}

- (UICollectionViewFlowLayout *)collectionLayout
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    
    CGFloat itemSpace = 1.0;
    CGFloat lineSpace = 1.0;
    NSInteger itemsCountOnHorizontal = 4.0;
    CGFloat itemWidth = (self.view.bounds.size.width - (itemSpace * (itemsCountOnHorizontal - 1))) / 4;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.minimumInteritemSpacing = itemSpace;
    layout.minimumLineSpacing = lineSpace;
    
    return layout;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
