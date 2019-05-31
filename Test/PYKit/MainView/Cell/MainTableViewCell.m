//
//  MainTableViewCell.m
//  Test
//
//  Created by 衣二三 on 2019/4/15.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "MainTableViewCell.h"
#import "BaseViewHeaders.h"
#import "BaseObjectHeaders.h"

@interface MainTableViewCell()
/// title
@property (nonatomic,strong) BaseLabel * titleLabel;

@end
@implementation MainTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.titleLabel = [BaseLabel new];
    self.titleLabel.font = BaseFont.fontSCM(12);
    self.titleLabel.textColor = BaseColorHandler.cBlack;
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(10, 0, self.frame.size.width - 10, self.frame.size.height);
}

- (void) setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}
@end
