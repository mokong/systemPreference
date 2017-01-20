//
//  MKSystemPreferenceModel.m
//  SystemPreferenceDemo
//
//  Created by moyekong on 15/12/10.
//  Copyright © 2015年 wiwide. All rights reserved.
//

#import "MKSystemPreferenceModel.h"
#import <NSObject+YYModel.h>
#import "MKSystemPreferenceItem.h"

@implementation MKSystemPreferenceModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self yy_modelInitWithCoder:aDecoder];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"models" : MKSystemPreferenceItem.class};
}

+ (NSArray *)systemPreferenceArray {
    NSUserDefaults *groupDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.huazhu.systemPreferenceDemoGroup"];
    NSData *archivedData = [groupDefaults objectForKey:@"models"];
    if (archivedData == nil) {
        NSLog(@"重新读取");
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DataJson" ofType:@"json"];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        
        NSString *jsonString = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
        MKSystemPreferenceModel *systemModel = [MKSystemPreferenceModel yy_modelWithJSON:jsonString];
        return systemModel.models;
    } else {
        NSLog(@"保存的");
        NSArray *resultArray = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
        return resultArray;
    }
}

+ (BOOL)saveDataWithArray:(NSArray *)jsonArray {
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:jsonArray];
    NSUserDefaults *groupDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.huazhu.systemPreferenceDemoGroup"];
    [groupDefaults setObject:archiveData forKey:@"models"];
    [groupDefaults synchronize];
    return YES;
}

@end
