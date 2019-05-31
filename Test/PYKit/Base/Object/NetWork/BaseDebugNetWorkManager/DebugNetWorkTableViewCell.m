//
//  DebugNetWorkTableViewCell.m
//  Test
//
//  Created by 衣二三 on 2019/3/27.
//  Copyright © 2019年 衣二三. All rights reserved.
//

#import "DebugNetWorkTableViewCell.h"

@interface DebugNetWorkTableViewCell()
/// leftLabel
@property (nonatomic,strong) UILabel * leftLabel;
@property (nonatomic,strong) UILabel * rightLabel;
@end

@implementation DebugNetWorkTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void) setupViews {
    [self.contentView addSubview: self.leftLabel];
    [self.contentView addSubview: self.rightLabel];
    self.leftLabel.frame = CGRectMake(0, 0, 100, 100);
}


/// leftLabel
- (UILabel *) leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.frame = CGRectMake(0,0,0,0);
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        CGFloat value = 30.0 / 255;
        _leftLabel.textColor = [UIColor colorWithRed: value green:value blue:value alpha:1];
    }
    return _leftLabel;
}

- (UILabel *) rightLabel {
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        _rightLabel.font = [UIFont systemFontOfSize:12];
        _rightLabel.textAlignment = NSTextAlignmentLeft;
        CGFloat value = 50.0 / 255;
        _rightLabel.textColor = [UIColor colorWithRed: value green:value blue:value alpha:1];
    }
    return _rightLabel;
}

@end
