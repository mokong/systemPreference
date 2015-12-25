//
//  MKSystemCollectionViewCell.m
//  SystemPreferenceDemo
//
//  Created by moyekong on 12/23/15.
//  Copyright © 2015 wiwide. All rights reserved.
//

#import "MKSystemCollectionViewCell.h"

@implementation MKSystemCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    _displayButton.displayLabel.font = [UIFont systemFontOfSize:14.0];
}

@end
