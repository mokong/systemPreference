//
//  MKSystemPreferenceModel.h
//  SystemPreferenceDemo
//
//  Created by moyekong on 15/12/10.
//  Copyright © 2015年 wiwide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKSystemPreferenceModel : NSObject<NSCoding>

@property (nonatomic, strong) NSArray *models;

+ (NSDictionary *)modelContainerPropertyGenericClass;

+ (NSArray *)systemPreferenceArray;

+ (BOOL)saveDataWithArray:(NSArray *)jsonArray;

@end
