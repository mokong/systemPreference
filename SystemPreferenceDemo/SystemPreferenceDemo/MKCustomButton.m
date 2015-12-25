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
    self.backgroundColor = [UIColor redColor];
    
    _displayLabel = [UILabel new];
    _displayLabel.textAlignment = NSTextAlignmentCenter;
    _displayLabel.userInteractionEnabled = YES;
    [self addSubview:_displayLabel];
    [_displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.left.equalTo(self.mas_left).with.offset(4);
        make.right.equalTo(self.mas_right).with.offset(-4);
    }];
    
    UITapGestureRecognizer *tapOnLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
    [_displayLabel addGestureRecognizer:tapOnLabel];
    
    _displayImageView = [UIImageView new];
    _displayImageView.userInteractionEnabled = YES;
    [self addSubview:_displayImageView];
    [_displayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).with.offset(-9.0); // 假设label的高度是18.0
        make.bottom.equalTo(_displayLabel.mas_top).with.offset(-4);
    }];
    
    UITapGestureRecognizer *tapOnImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    [_displayImageView addGestureRecognizer:tapOnImageView];
}

- (void)tapLabel:(UILabel *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectButtonWithButtonTag:)]) {
        [self.delegate selectButtonWithButtonTag:self.tag];
    }
}

- (void)tapImage:(UILabel *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectButtonWithButtonTag:)]) {
        [self.delegate selectButtonWithButtonTag:self.tag];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
