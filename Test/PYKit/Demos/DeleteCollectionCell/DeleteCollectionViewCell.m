//
//  DeleteCollectionViewCell.m
//  PYkit
//
//  Created by 衣二三 on 2019/5/22.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "DeleteCollectionViewCell.h"
#import "BaseObjectHeaders.h"

@interface DeleteCollectionViewCell()
/// index label
@property (nonatomic,strong) UILabel * titleLabel;
/// backgroundImageView
@property (nonatomic,strong) UIImageView *backgroundImageView;
/// actionButton
@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGesture;

@property (nonatomic,strong) NSIndexPath *previousIndexPath;

/// button
@property (nonatomic,strong) UIButton *maskButton;

// collectionView
@property (nonatomic,weak) UICollectionView *collectionView;
@end

@implementation DeleteCollectionViewCell

// MARK: - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViewsFunc];
    }
    return self;
}

#pragma mark - func
// MARK: reload data

// MARK: handle views
- (void) setupSubViewsFunc {
    [self.contentView addSubview: self.backgroundImageView];
    [self.contentView addSubview: self.titleLabel];
    [self.contentView addSubview: self.maskButton];
    [self.backgroundImageView addGestureRecognizer:self.longPressGesture];
}

// MARK: handle event
- (void) registerEventsFunc {
    
}

// MARK: lazy loads
/// titleLabel
- (UILabel *) titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(0,0,0,0);
        _titleLabel.backgroundColor = UIColor.whiteColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = BaseFont.fontSCM(12);
        _titleLabel.textColor = BaseColorHandler.cBlack;
    }
    return _titleLabel;
}


- (UIImageView *) backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]init];
        _backgroundImageView.userInteractionEnabled = true;
        _backgroundImageView.backgroundColor = UIColor.whiteColor;
        _backgroundImageView.layer.cornerRadius = 6;
    }
    return _backgroundImageView;
}

- (UILongPressGestureRecognizer *)longPressGesture {
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureAction:)];
    }
    return _longPressGesture;
}

- (void) longPressGestureAction: (UILongPressGestureRecognizer *)longPressGestrue {
    if (longPressGestrue.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(longPressGestureWithIndex:)]) {
            
            id cell = [self.collectionView cellForItemAtIndexPath:self.previousIndexPath];
            if ([cell isKindOfClass:DeleteCollectionViewCell.class]) {
                [self.delegate longPressGestureWithIndex:self.previousIndexPath];
            }
            
            NSIndexPath *index = [self.collectionView indexPathForCell:self];
            if (![self.previousIndexPath isEqual:index]) {
                _isShowMaskView = false;
                self.maskButton.alpha = 0;
            }
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.previousIndexPath = [self.collectionView indexPathForCell:self];
}

// MARK: systom functions
- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.contentView.bounds;
    self.backgroundImageView.frame = self.contentView.bounds;
    self.maskButton.frame = self.contentView.bounds;
}

// MARK:life cycles

// MARK: - get && set
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        id view = self.superview;
        if ([view isKindOfClass:UICollectionView.class]) {
            _collectionView = view;
        }
    }
    return _collectionView;
}

- (UIButton *)maskButton {
    if (!_maskButton) {
        _maskButton = [[UIButton alloc]init];
        [_maskButton addTarget:self action:@selector(clickMaskButton:) forControlEvents:UIControlEventTouchUpInside];
        [_maskButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_maskButton setTitle:@"删除" forState:UIControlStateNormal];
        _maskButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _maskButton.alpha = 0;
    }
    return _maskButton;
}

- (void)clickMaskButton: (UIButton *) button {
    if ([self.delegate respondsToSelector:@selector(deleteWithIndex:)]) {
        NSIndexPath *index = [self.collectionView indexPathForCell:self];
        [self.delegate deleteWithIndex:index];
    }
}

- (void)setModel:(DelegateModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    _isShowMaskView = false;
    self.maskButton.alpha = 0;
}

- (void) setIsShowMaskView:(BOOL)isShowMaskView {
    _isShowMaskView = isShowMaskView;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskButton.alpha = isShowMaskView;
    }];
}
@end

