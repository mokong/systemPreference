//
//  UIButton+ImageTitleSpacing.m
//  SystemPreferenceDemo
//
//  Created by moyekong on 12/28/15.
//  Copyright © 2015 wiwide. All rights reserved.
//

#import "UIButton+ImageTitleSpacing.h"

@implementation UIButton (ImageTitleSpacing)

- (void)centerButtonAndImageWithSpacing:(CGFloat)spacing {

    /**
     *  参考：http://victorchee.github.io/blog/button-layout-with-image-and-title/
     */
    
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        imageEdgeInsets = UIEdgeInsetsMake(-self.titleLabel.intrinsicContentSize.height-spacing/2.0, 0, 0, -self.titleLabel.intrinsicContentSize.width);
    } else {
        imageEdgeInsets = UIEdgeInsetsMake(-self.titleLabel.frame.size.height-spacing/2.0, 0, 0, -self.titleLabel.frame.size.width);
    }
    UIEdgeInsets titleLabelEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width, -self.imageView.frame.size.height-spacing/2.0, 0);
    
    self.titleEdgeInsets = titleLabelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;

}

@end
