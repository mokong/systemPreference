//
//  MKCustomButton.h
//  SystemPreferenceDemo
//
//  Created by moyekong on 12/25/15.
//  Copyright © 2015 wiwide. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MKCustomButtonDelegate <NSObject>

- (void)selectButtonWithButtonTag:(NSInteger)btnTag;

@end

@interface MKCustomButton : UIButton

@property (nonatomic, weak) id<MKCustomButtonDelegate>delegate;
@property (nonatomic, strong) UILabel *displayLabel;
@property (nonatomic, strong) UIImageView *displayImageView;

@end
