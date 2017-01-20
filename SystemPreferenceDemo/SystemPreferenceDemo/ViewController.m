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

@property (nonatomic, assign) BOOL isGrid; // 判断是网格还是列表
@property (nonatomic, strong) MKSystemPreferenceListController *listViewController;
@property (nonatomic, strong) MKSystemCollectionViewController *gridViewController;

@end

@implementation ViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"网格";
    [self setupSubviews];

    _isGrid = YES;
}

- (void)setupSubviews {
    [self setupRightBarButtonItem];
    [self setupListViewController];
    [self setupGridViewController];
}

- (void)setupListViewController {
    if (!_listViewController) {
        _listViewController = [[MKSystemPreferenceListController alloc] initWithStyle:UITableViewStyleGrouped];
        [self addChildViewController:_listViewController];
        [_listViewController didMoveToParentViewController:self];
        _listViewController.view.frame = CGRectMake(0, 64.0, self.view.bounds.size.width, self.view.bounds.size.height-64.0);
        [self.view addSubview:_listViewController.view];
    }
}

- (void)deallocListViewController {
    [_listViewController.view removeFromSuperview];
    [_listViewController removeFromParentViewController];
    _listViewController = nil;
}

- (void)setupGridViewController {
    if (!_gridViewController) {
        _gridViewController = [[MKSystemCollectionViewController alloc] initWithCollectionViewLayout:[self collectionLayout]];
        [self addChildViewController:_gridViewController];
        [_gridViewController didMoveToParentViewController:self];
        _gridViewController.view.frame = CGRectMake(0, 64.0, self.view.bounds.size.width, self.view.bounds.size.height-64.0);
        [self.view addSubview:_gridViewController.view];
    }
}

- (void)deallocGridViewController {
    [_gridViewController.view removeFromSuperview];
    [_gridViewController removeFromParentViewController];
    _gridViewController = nil;
}

- (void)setupRightBarButtonItem {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"display_grid"] style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClicked:)];
    rightBarButtonItem.tintColor = [UIColor brownColor];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)updateRightBarButtonItemDisplay {
    if (self.navigationItem.rightBarButtonItem) {
        if (self.isGrid) {
            self.navigationItem.title = @"网格";
            self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"display_grid"];
            [self setupListViewController];
            [CATransaction flush];
            [UIView transitionFromView:_listViewController.view toView:_gridViewController.view duration:1.0f options:UIViewAnimationOptionTransitionFlipFromRight completion:nil];
        }
        else {
            self.navigationItem.title = @"列表";
            self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"display_list"];
            [self setupGridViewController];
            [CATransaction flush];
            [UIView transitionFromView:_gridViewController.view toView:_listViewController.view duration:1.0f options:UIViewAnimationOptionTransitionFlipFromLeft completion:nil];
        }
    }
}

#pragma mark - property setter && getter
- (void)setIsGrid:(BOOL)isGrid {
    _isGrid = isGrid;
    [self updateRightBarButtonItemDisplay];
}

#pragma mark - action
- (void)rightBarButtonItemClicked:(UIBarButtonItem *)targetItem {
    self.isGrid = !self.isGrid;
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
