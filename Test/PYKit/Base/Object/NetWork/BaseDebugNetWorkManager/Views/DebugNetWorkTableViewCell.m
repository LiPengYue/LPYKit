//
//  BaseDebugNetWorkManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//


#import "DebugNetWorkTableViewCell.h"
#import "BaseObjectHeaders.h"
#import "BaseViewHeaders.h"


@interface DebugNetWorkTableViewCell()

@property (nonatomic,strong) UILabel *levelLabel;
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
/// leftLabel
@property (nonatomic,strong) UILabel * leftLabel;
@property (nonatomic,strong) UILabel * rightLabel;
@property (nonatomic,strong) UILabel * colonLabel;
@property (nonatomic,strong) UILabel * tagLabel;

@property (nonatomic,strong) UIView *gestureView;
@end

@implementation DebugNetWorkTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gestureView.frame = self.contentView.bounds;
}

- (void)setModel:(BaseDebugNetWorkDataStepModel *)model {
    _model = model;
    [self relayoutSubViews];
    [self setupShapeLayerFrame];
    [self setupLevelFrmae];
}

- (void) relayoutSubViews {
    [self layoutLeftLabel];
    [self setupBackgroundColor];
    
    switch (self.model.type) {
      
        case BaseDebugNetWorkDataModelType_Dictionary:
            [self setupWhenDic];
            break;
        case BaseDebugNetWorkDataModelType_Array:
            [self setupWhenArray];
            break;
        case BaseDebugNetWorkDataModelType_Number:
            [self setupWhenNumber];
            break;
        case BaseDebugNetWorkDataModelType_String:
            [self setupWhenString];
            break;
    }
}

- (void) setUpBackgroundColorWithIsSearchResultColor: (BOOL)isSearchResult andIsCurrentSearchResult: (BOOL) isCurrentSearchResult {
    UIColor *color;
    if (!isSearchResult) {
        CGFloat colorItem = (self.model.level * 0.02);
        colorItem = MIN(0.9 + colorItem, 1);
        color = [UIColor colorWithRed:colorItem green:colorItem blue:colorItem alpha:1];
    }else{
        
        color = isCurrentSearchResult ? cellBackgroundCurrentSearchColor : cellBackgroundSearchReslutColor;
    }
    self.contentView.backgroundColor = color;
}

- (void) setupBackgroundColor {
    UIColor *color;
    if (self.isSearchReslutCell) {
        color = cellBackgroundSearchReslutColor;
    }else{
        CGFloat colorItem = (self.model.level * 0.02);
        colorItem = MIN(0.9 + colorItem, 1);
        color = [UIColor colorWithRed:colorItem green:colorItem blue:colorItem alpha:1];
    }
    self.contentView.backgroundColor = color;
}

- (void) layoutLeftLabel {
    CGFloat leftLabelLeft = self.model.level * 10 + 10;
    if (self.model.key.length > 0) {
        self.leftLabel.text = [NSString stringWithFormat:@"\"%@\"", self.model.key];
    }else{
        self.leftLabel.text = @"";
    }
    
    CGFloat leftLabelH = self.height;
    CGFloat leftLabelW = BaseStringHandler.handler(self.leftLabel.text).getWidthWithHeightAndFont(leftLabelH,self.leftLabel.font);
    leftLabelW = MIN(leftLabelW, self.width/2.0);
    self.leftLabel.frame = CGRectMake(leftLabelLeft, 0, leftLabelW, leftLabelH);
    
    CGFloat colonLabelW = 10;
    self.colonLabel.hidden = false;
    if(self.leftLabel.text.length <= 0) {
        colonLabelW = 0;
        self.colonLabel.hidden = true;
    }
     self.colonLabel.frame = CGRectMake(self.leftLabel.right, leftLabelH /2.0 - 4, colonLabelW, 10);
    
}

- (void) setupWhenDic {
    self.rightLabel.text = [NSString stringWithFormat: @"Object{ %ld }",self.model.count];
    self.rightLabel.textColor = normalColor;
    self.tagLabel.text = self.model.isOpen ? @"-" : @"+";
    
    self.tagLabel.hidden = false;
    self.tagLabel.frame = CGRectMake(self.colonLabel.right, self.colonLabel.top, 10, 10);
    self.rightLabel.frame = CGRectMake(self.tagLabel.right, 0, self.width-self.tagLabel.right, self.height);
}

- (void) setupWhenArray {
    self.rightLabel.text = [NSString stringWithFormat: @"Array[ %ld ]",self.model.count];
    self.rightLabel.textColor = normalColor;
    self.tagLabel.text = self.model.isOpen ? @"-" : @"+";
    
    self.tagLabel.hidden = false;
    self.tagLabel.frame = CGRectMake(self.colonLabel.right, self.colonLabel.top, 10, 10);
    self.rightLabel.frame = CGRectMake(self.tagLabel.right, 0, self.width-self.tagLabel.right, self.height);
}

- (void) setupWhenString {
    self.rightLabel.text = [NSString stringWithFormat:@"\"%@\"",self.model.data];
    self.rightLabel.textColor = stringColor;
    self.tagLabel.text = @"";
    
    self.tagLabel.hidden = true;
    self.tagLabel.frame = CGRectMake(self.colonLabel.right, self.colonLabel.top, 0, 10);
    self.rightLabel.frame = CGRectMake(self.tagLabel.right, 0, self.width-self.tagLabel.right, self.height);
}

- (void) setupWhenNumber {
    self.rightLabel.text = [NSString stringWithFormat:@"%@",self.model.data];
    self.rightLabel.textColor = numberColor;
    self.tagLabel.text = @"";
    
    self.tagLabel.hidden = true;
    self.tagLabel.frame = CGRectMake(self.colonLabel.right, self.colonLabel.top, 0, 10);
    self.rightLabel.frame = CGRectMake(self.tagLabel.right, 0, self.width-self.tagLabel.right, self.height);
}

- (void) setupViews {
    [self.contentView addSubview: self.leftLabel];
    [self.contentView addSubview: self.rightLabel];
    [self.contentView addSubview: self.tagLabel];
    [self.contentView addSubview: self.colonLabel];
    [self.contentView addSubview: self.gestureView];
    [self.contentView addSubview: self.levelLabel];
    [self.contentView.layer addSublayer: self.shapeLayer];
    self.gestureView.frame = self.bounds;
}

/// levelLabel
- (UILabel *) levelLabel {
    if (!_levelLabel) {
        _levelLabel = [[UILabel alloc] init];
        _levelLabel.frame = CGRectMake(0,0,0,0);
        _levelLabel.backgroundColor = cellLevelLabelColor;
        _levelLabel.textAlignment = NSTextAlignmentLeft;
        _levelLabel.font = BaseFont.fontSCL(12);
        _levelLabel.textColor = cellLevelLabelColor;
    }
    return _levelLabel;
}

/// leftLabel
- (UILabel *) leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.frame = CGRectMake(0,0,0,0);
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _leftLabel.textColor = leftTitleColor;
        _leftLabel.numberOfLines = 0;
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
        _rightLabel.numberOfLines = 0;
        
    }
    return _rightLabel;
}

/// colonLabel
- (UILabel *) colonLabel {
    if (!_colonLabel) {
        _colonLabel = [[UILabel alloc] init];
        _colonLabel.frame = CGRectMake(0,0,0,0);
        _colonLabel.text = @":";
        _colonLabel.textAlignment = NSTextAlignmentCenter;
        _colonLabel.font = BaseFont.fontSCM(10);
        _colonLabel.textColor = normalColor;
    }
    return _colonLabel;
}

/// tagLabel
- (UILabel *) tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.frame = CGRectMake(0,0,0,0);
        _tagLabel.backgroundColor = UIColor.whiteColor;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.font = BaseFont.fontSCL(10);
        _tagLabel.textColor = normalColor;
        _tagLabel.layer.borderColor = normalColor.CGColor;
        _tagLabel.layer.borderWidth = 0.5;
        _tagLabel.layer.cornerRadius = 2;
        _tagLabel.hidden = true;
     }
    return _tagLabel;
}

- (UIView *)gestureView {
    if (!_gestureView) {
        _gestureView = [UIView new];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(signalTap:)];
        [_gestureView addGestureRecognizer:tap];
    }
    return _gestureView;
}

- (void) signalTap: (UITapGestureRecognizer *) tap {
    UIView *view = tap.view;
    if (![view isEqual:self.gestureView]) {
        return;
    }
    // 通知 tableview 加载数据源
    if (self.singleTapBlock){
        self.singleTapBlock(self, self.indexPath);
    }
}
- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer new];
        
        _shapeLayer.fillColor = UIColor.clearColor.CGColor;
        _shapeLayer.strokeColor = cellLevelLabelColor.CGColor;
        _shapeLayer.lineWidth = 1;
        _shapeLayer.lineJoin = kCALineCapRound;
        _shapeLayer.lineDashPattern = @[@(1),@(1)];
        
        CGFloat y = 1;
        CGFloat x = self.leftLabel.left - 2;
        CGFloat w = 1;
        CGFloat h = self.height - y*2;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(w/2.0, 0)];
        [path addLineToPoint:CGPointMake(w/2.0, h)];
        _shapeLayer.path = path.CGPath;
        _shapeLayer.frame = CGRectMake(x, y, w, self.height - 2);
    }
    return _shapeLayer;
}

- (void) setupShapeLayerFrame {
    CGRect frame = self.shapeLayer.frame;
    frame.origin.x = self.leftLabel.left - 4;
    self.shapeLayer.frame = frame;
}

- (void) setupLevelFrmae {
    return;
    CGFloat y = 1;
    CGFloat x = self.leftLabel.left - 2;
    CGFloat w = 1;
    self.levelLabel.frame = CGRectMake(x, y, w, self.height - 2);
}
@end
