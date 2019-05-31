//
//  BasetableTestHeserFooterView2.m
//  Test
//
//  Created by 衣二三 on 2019/4/16.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BasetableTestHeserFooterView2.h"
#import "BaseColorHandler.h"

@implementation BasetableTestHeserFooterView2

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupviews];
        self.containerView.backgroundColor = BaseColorHandler.separatorColor;
    }
    return self;
}

- (void) setupviews {
    [self.contentView addSubview: self.titleLabel];
    [self.contentView addSubview:self.rightPointView];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    self.titleLabel.frame = CGRectMake(30, 0, w, h);
    self.rightPointView.center = CGPointMake(20, h/2);
    self.rightPointView.bounds = CGRectMake(0, 0, 10, 10);
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = BaseColorHandler.cGrayD;
    }
    return _titleLabel;
}

- (UIView *)rightPointView {
    if (!_rightPointView) {
        _rightPointView = [UIView new];
        _rightPointView.layer.cornerRadius = 5;
        _rightPointView.backgroundColor = BaseColorHandler.cGrayL;
    }
    return _rightPointView;
}

@end
