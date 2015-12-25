//
//  MKCustomButton.m
//  SystemPreferenceDemo
//
//  Created by moyekong on 12/25/15.
//  Copyright © 2015 wiwide. All rights reserved.
//

#import "MKCustomButton.h"
#import <Masonry.h>

@implementation MKCustomButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _displayLabel = [UILabel new];
    _displayLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_displayLabel];
    [_displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).with.offset(-8);
        make.left.equalTo(self.mas_left).with.offset(4);
        make.right.equalTo(self.mas_right).with.offset(-4);
    }];
    
    _displayImageView = [UIImageView new];
    [self addSubview:_displayImageView];
    [_displayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(_displayLabel.mas_top).with.offset(-4);
        make.top.equalTo(self.mas_top).offset(8);
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
