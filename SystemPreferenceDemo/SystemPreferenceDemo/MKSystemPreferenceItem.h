//
//  MKSystemPreferenceItem.h
//  SystemPreferenceDemo
//
//  Created by moyekong on 15/12/10.
//  Copyright © 2015年 wiwide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKSystemPreferenceItem : NSObject<NSCoding>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *prefs;
@property (nonatomic, strong) NSString *idString;

@end
