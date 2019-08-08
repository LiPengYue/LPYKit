//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//

#import "BaseJsonViewSearchResultTableViewHeaderView.h"
#import "BaseJsonViewCommon.h"
#import "BaseSize.h"


@interface BaseJsonViewSearchResultTableViewHeaderView()
@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation BaseJsonViewSearchResultTableViewHeaderView

// MARK: - init

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViewsFunc];
    }
    return self;
}

#pragma mark - func
// MARK: reload data
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

// MARK: handle views
- (void) setupSubViewsFunc {
    [self.containerView addSubview:self.titleLabel];
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
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = normalColor;
        _titleLabel.backgroundColor = cellBackgroundSearchReslutColor;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

// MARK: systom functions


// MARK:life cycles
- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}


+ (NSString *) getTitleWithModel: (BaseJsonViewStepModel *)model {
    NSMutableArray <BaseJsonViewStepModel *>*arrayM = [NSMutableArray new];
    
    BaseJsonViewStepModel *modelTemp = model;
    
    while (1) {
        [arrayM addObject:modelTemp];
        if (modelTemp.superPoint == nil) {
            break;
        }
    }
    
    BaseStringHandler *handler = BaseStringHandler.handler(@"");
    for (NSInteger i = arrayM.count-1; i < 0; i--) {
        modelTemp = arrayM[i];
        if(modelTemp.superPoint) {
            handler.addObjc(@"→");
        }
        switch (modelTemp.type) {
                
            case BaseJsonViewStepModelType_Dictionary:
                handler
                .addObjc(modelTemp.key)
                .addObjc(@":{")
                .addInt(modelTemp.count)
                .addObjc(@"}");
                break;
            case BaseJsonViewStepModelType_Array:
                handler
                .addObjc(modelTemp.key)
                .addObjc(@":[")
                .addInt(modelTemp.count)
                .addObjc(@"]");
                break;
            case BaseJsonViewStepModelType_Number:
            case BaseJsonViewStepModelType_String:
                handler
                .addObjc(modelTemp.key)
                .addObjc(@":")
                .addObjc(modelTemp.data);
                break;
        }
    }
    return handler.getStr;
}

+ (CGFloat) getHWithString: (NSString *)str {
    if (str.length <= 0) return 30;
   return BaseStringHandler.handler(str).getHeightWithWidthAndFont(BaseSize.screenW - 24,BaseFont.fontSCR(12));
}
@end

