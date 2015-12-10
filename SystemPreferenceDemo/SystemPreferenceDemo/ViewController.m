//
//  ViewController.m
//  SystemPreferenceDemo
//
//  Created by moyekong on 15/12/9.
//  Copyright © 2015年 wiwide. All rights reserved.
//

#import "ViewController.h"
#import "MKSystemPreferenceListController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)displaySystemPreferenceList:(id)sender {
    MKSystemPreferenceListController *systemListVC = [[MKSystemPreferenceListController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:systemListVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
