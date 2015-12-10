//
//  MKSystemPreferenceItem.m
//  SystemPreferenceDemo
//
//  Created by moyekong on 15/12/10.
//  Copyright © 2015年 wiwide. All rights reserved.
//

#import "MKSystemPreferenceItem.h"
#import <NSObject+YYModel.h>

@implementation MKSystemPreferenceItem

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self yy_modelInitWithCoder:aDecoder];
}

@end
