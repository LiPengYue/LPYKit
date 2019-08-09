//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//


#import "BaseJsonViewTableViewCell.h"
#import "BaseObjectHeaders.h"
#import "BaseViewHeaders.h"
#import "BaseJsonViewCommon.h"

@interface BaseJsonViewTableViewCell()
@property (nonatomic,strong) NSIndexPath *touchBeginIndex;
@property (nonatomic,strong) UILabel *levelLabel;
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
/// leftLabel
@property (nonatomic,strong) UILabel * leftLabel;
@property (nonatomic,strong) UILabel * rightLabel;
@property (nonatomic,strong) UILabel * colonLabel;
@property (nonatomic,strong) UILabel * tagLabel;

@property (nonatomic,strong) UIView *gestureView;
@property (nonatomic,strong) UIButton *bottomFoldLineButton;
@property (nonatomic,strong) CAGradientLayer *gradientLayer;
@end

@implementation BaseJsonViewTableViewCell

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
    CGFloat labelH = self.height - tableViewCellBottomMinSpacing - tableViewCellTopMinSpacing;
    if (self.model.isShowFoldLineButton) {
        labelH -= tableViewCellBottomFoldLineButtonH;
    }
    self.leftLabel.height = labelH;
    self.rightLabel.height = labelH;
    self.colonLabel.top = self.leftLabel.bottom /2.0 - 3;
    self.tagLabel.top = self.colonLabel.top;
    self.bottomFoldLineButton.top = self.rightLabel.bottom + 2;
    [self setupShapeLayerFrame];
    self.bottomFoldLineButton.selected = self.model.isOpenFoldLine;
//    CGRect frame = self.gradientLayer.frame;
//    frame.size.width = self.rightLabel.width;
//    frame.origin.x = self.rightLabel.left;
//    frame.origin.y = self.rightLabel.bottom - frame.size.height;
//    self.gradientLayer.frame = frame;
//    [self.contentView.layer addSublayer:self.gradientLayer];
}

- (void)setModel:(BaseJsonViewStepModel *)model {
    _model = model;
    
    [self relayoutSubViews];
    [self setupShapeLayerFrame];
//    [self setupLevelFrmae];
}

- (void) relayoutSubViews {
    [self layoutLeftLabel];
    [self setupBackgroundColor];
    
    CGFloat tagLabelW = 10;
    
    switch (self.model.type) {
      
        case BaseJsonViewStepModelType_Dictionary:
            tagLabelW = 10;
            [self setupWhenDic];
            break;
        case BaseJsonViewStepModelType_Array:
            tagLabelW = 10;
            [self setupWhenArray];
            break;
        case BaseJsonViewStepModelType_Number:
            tagLabelW = 0;
            [self setupWhenNumber];
            break;
        case BaseJsonViewStepModelType_String:
            tagLabelW = 0;
            [self setupWhenString];
            break;
    }
    
    self.tagLabel.frame = CGRectMake(self.colonLabel.right, self.colonLabel.top, tagLabelW, 10);
    self.tagLabel.hidden = tagLabelW <= 0;
    
    CGFloat rightLabelW = self.width - self.tagLabel.right - tableViewCellRightSpacing;
    self.rightLabel.frame = CGRectMake(self.tagLabel.right, self.leftLabel.top, rightLabelW, self.leftLabel.height);
    
    self.bottomFoldLineButton.hidden = !self.model.isShowFoldLineButton;
    self.bottomFoldLineButton.top = self.rightLabel.bottom;
    self.bottomFoldLineButton.left = self.rightLabel.left;
    self.bottomFoldLineButton.width = self.rightLabel.width;
    self.bottomFoldLineButton.height = self.height - self.rightLabel.bottom - tableViewCellBottomMinSpacing;
    
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
    CGFloat leftLabelLeft = (self.model.level - self.levelOffset) * tableViewCellLevelSpacing + tableViewCellLeftSpacing;
    if (self.model.key.length > 0) {
        self.leftLabel.text = [NSString stringWithFormat:@"\"%@\"", self.model.key];
    }else{
        self.leftLabel.text = @"";
    }
    
    CGFloat leftLabelH = self.height - tableViewCellTopMinSpacing - tableViewCellBottomMinSpacing;
    if (self.model.isShowFoldLineButton) {
        leftLabelH -= tableViewCellBottomFoldLineButtonH;
    }
    CGFloat leftLabelW = BaseStringHandler.handler(self.leftLabel.text).getWidthWithHeightAndFont(leftLabelH,self.leftLabel.font);
    
    leftLabelW = MIN(leftLabelW, self.width/2.0);
    self.leftLabel.frame = CGRectMake(leftLabelLeft, tableViewCellTopMinSpacing, leftLabelW, leftLabelH);
    
    CGFloat colonLabelW = 10;
    self.colonLabel.hidden = false;
    if(self.leftLabel.text.length <= 0) {
        colonLabelW = 0;
        self.colonLabel.hidden = true;
    }
     self.colonLabel.frame = CGRectMake(self.leftLabel.right, self.leftLabel.bottom /2.0 - 3, colonLabelW, 10);
    
}

- (void) setupWhenDic {
    self.rightLabel.text = [NSString stringWithFormat: @"Object{ %ld }",self.model.count];
    self.rightLabel.textColor = normalColor;
    self.tagLabel.text = self.model.isOpen ? @"-" : @"+";
}

- (void) setupWhenArray {
    self.rightLabel.text = [NSString stringWithFormat: @"Array[ %ld ]",self.model.count];
    self.rightLabel.textColor = normalColor;
    self.tagLabel.text = self.model.isOpen ? @"-" : @"+";
}

- (void) setupWhenString {
    self.rightLabel.text = [NSString stringWithFormat:@"\"%@\"",self.model.data];
    self.rightLabel.textColor = stringColor;
    self.tagLabel.text = @"";
}

- (void) setupWhenNumber {
    self.rightLabel.text = [NSString stringWithFormat:@"%@",self.model.data];
    self.rightLabel.textColor = numberColor;
    self.tagLabel.text = @"";
}

- (void) setupViews {
    [self.contentView addSubview: self.leftLabel];
    [self.contentView addSubview: self.rightLabel];
    [self.contentView addSubview: self.tagLabel];
    [self.contentView addSubview: self.colonLabel];
    [self.contentView addSubview: self.gestureView];
    [self.contentView addSubview: self.levelLabel];
    [self.contentView addSubview: self.bottomFoldLineButton];
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
        _levelLabel.font = tableViewCellLevelFont;
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
        _leftLabel.font = tableViewCellLeftFont;
        _leftLabel.textColor = leftTitleColor;
        _leftLabel.numberOfLines = 0;
    }
    return _leftLabel;
}

- (UILabel *) rightLabel {
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        _rightLabel.font = tableViewCellRightFont;
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
        _colonLabel.font = tableViewCellColonLabelFont;
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
        _tagLabel.font = tableViewCellTagFont;
        _tagLabel.textColor = normalColor;
        _tagLabel.layer.borderColor = normalColor.CGColor;
        _tagLabel.layer.borderWidth = 0.5;
        _tagLabel.layer.cornerRadius = 2;
        _tagLabel.hidden = true;
     }
    return _tagLabel;
}

- (UIButton *)bottomFoldLineButton {
    if (!_bottomFoldLineButton) {
        _bottomFoldLineButton = [[UIButton alloc]initWithFrame:CGRectZero];
        _bottomFoldLineButton.layer.cornerRadius = 2;
//        _bottomFoldLineButton.layer.borderColor = leftTitleColor.CGColor;
//        _bottomFoldLineButton.layer.borderWidth = 0.3;
        _bottomFoldLineButton.layer.shadowColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
        _bottomFoldLineButton.layer.shadowOpacity = 1;
        _bottomFoldLineButton.layer.shadowOffset = CGSizeMake(0, -10);
        _bottomFoldLineButton.layer.shadowRadius = 8;
        [_bottomFoldLineButton setTitle:@"∨" forState:UIControlStateNormal];
        [_bottomFoldLineButton setTitle:@"∧" forState:UIControlStateSelected];
        [_bottomFoldLineButton setTitleColor:leftTitleColor forState:UIControlStateNormal];
        _bottomFoldLineButton.titleLabel.font = tableViewCellBottomFoldLineButtonFont;
        _bottomFoldLineButton.hidden = true;
        [_bottomFoldLineButton addTarget:self action:@selector(clickBottomFoldLineButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomFoldLineButton;
}

- (void) clickBottomFoldLineButton {
    if (self.clickBottomFoldLineButtonBlock) {
        self.clickBottomFoldLineButtonBlock(self);
    }
}

- (UIView *)gestureView {
    if (!_gestureView) {
        _gestureView = [UIView new];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(signalTap:)];
        [_gestureView addGestureRecognizer:tap];
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longAction:)];
        [_gestureView addGestureRecognizer:longGesture];
        
        UITapGestureRecognizer *doubleGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleAction:)];
        doubleGesture.numberOfTapsRequired = 2;
        [_gestureView addGestureRecognizer:doubleGesture];
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
        self.singleTapBlock(self, self.touchBeginIndex);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.touchBeginIndex = self.indexPath;
}

- (void) longAction:(UILongPressGestureRecognizer *)longGesture {
    if (longGesture.state == UIGestureRecognizerStateBegan) {
        UIView *view = longGesture.view;
        if (!([view isEqual:self.gestureView])) return;
        if (self.longAction) {
            self.longAction(self, self.touchBeginIndex);
        }
      }
}

- (void) doubleAction: (UITapGestureRecognizer *)doubleGesture {
    UIView *view = doubleGesture.view;
    if (!([view isEqual:self.gestureView])) return;
    if (self.doubleAction) {
        self.doubleAction(self, self.indexPath);
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
    }
    return _shapeLayer;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer new];
        _gradientLayer.startPoint = CGPointMake(0.5, 1);
        _gradientLayer.endPoint = CGPointMake(0.5, 0);
        _gradientLayer.locations = @[@0.0,@0.3,@1.0];
        _gradientLayer.colors = @[
                                 (id)[UIColor.whiteColor colorWithAlphaComponent:1].CGColor,
                                 (id)[UIColor.whiteColor colorWithAlphaComponent:0].CGColor,
                                 ];;
        
        _gradientLayer.frame = CGRectMake(0, 0, 0, tableViewCellBottomFoldLineButtonH);
    }
    return _gradientLayer;
}

- (void) setupShapeLayerFrame {
    CGFloat y = tableViewCellLeftLineTopBottomMinSpacing;
    CGFloat x = self.leftLabel.left - 4;
    CGFloat w = 1;
    CGFloat h = self.height - y*2;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(w/2.0, 0)];
    [path addLineToPoint:CGPointMake(w/2.0, h)];
    self.shapeLayer.path = path.CGPath;
    self.shapeLayer.frame = CGRectMake(x, y, w, self.height - 2);
}

+ (CGFloat) getHeightWithModel: (BaseJsonViewStepModel *)model andLevelOffset: (NSInteger) levelOffset andLeftMaxW: (CGFloat) leftLabelMaxW andCellWidth: (CGFloat) cellW{
    NSString *leftStr = nil;
    if (model.key.length > 0) {
        leftStr = [NSString stringWithFormat:@"\"%@\"", model.key];
    }else{
        leftStr = @"";
    }
    NSString *right = nil;
    if ([model.data isKindOfClass:NSString.class]) {
        right = [NSString stringWithFormat:@"\"%@\"",model.data];
    }
    if ([model.data isKindOfClass:NSNumber.class]) {
        NSNumber *data = model.data;
        right = data.stringValue;
    }
    
    CGFloat leftLabelLeft = (model.level - levelOffset) * tableViewCellLevelSpacing + tableViewCellLeftSpacing;
    CGFloat leftLabelW = BaseStringHandler.handler(leftStr).getWidthWithHeightAndFont(999,tableViewCellLeftFont);
    
    leftLabelW = leftLabelW > leftLabelMaxW ? leftLabelMaxW : leftLabelW;
    
    leftLabelW += leftLabelLeft;
    
    CGFloat rightLabelLeft = leftLabelW;
    CGFloat tagLabelW = 10;
    
    switch (model.type) {
            
        case BaseJsonViewStepModelType_Dictionary:
            tagLabelW = 10;
            break;
        case BaseJsonViewStepModelType_Array:
            tagLabelW = 10;
            break;
        case BaseJsonViewStepModelType_Number:
            tagLabelW = 0;
            break;
        case BaseJsonViewStepModelType_String:
            tagLabelW = 0;
            break;
    }
    
    CGFloat colonLabelW = 10;
    if(model.key.length <= 0) {
        colonLabelW = 0;
    }
    
    rightLabelLeft += colonLabelW;
    rightLabelLeft += tagLabelW;
    
    CGFloat h = 0.0 ;
    CGFloat rightw = cellW - rightLabelLeft - tableViewCellRightSpacing;
    if (right.length > 0) {
        h = [BaseJsonViewCommon getHeightLineWithString:right withWidth:rightw withFont:tableViewCellRightFont];
    }
    return h;
}



+ (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font {
    
    CGSize size = CGSizeMake(width, 999);

    NSDictionary *dic = @{NSFontAttributeName:font};

    CGFloat height = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    
    return height;
}
@end
