//
//  BaseJsonEditingStatusTableViewCell.m
//  PYkit
//
//  Created by 衣二三 on 2019/8/8.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BaseJsonEditingStatusTableViewCell.h"
#import "BaseJsonViewCommon.h"


static NSString * const dicMessgae = @"插入Dictionary：如果value没有值，则会插入一个空的Dictionary，否则";


@interface BaseJsonEditingStatusTableViewCell()
<
UITextFieldDelegate,
UITextViewDelegate
>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyBackgroundViewH;//55
@property (weak, nonatomic) IBOutlet UIView *keyBackgroundView;
@property (weak, nonatomic) IBOutlet UIScrollView *massageBackgroundScrollview;
@property (weak, nonatomic) IBOutlet UIButton *massageButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *massageButtonH;

@property (nonatomic,strong) NSMutableArray <UIButton *>*insertButtonArray;
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;

@property (weak, nonatomic) IBOutlet UITextView *keyTextView;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UITextView *valueTextView;

@property (weak, nonatomic) IBOutlet UIView *valueBackgroundView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *insertTypeBackgroundH;
@property (weak, nonatomic) IBOutlet UIView *insertTypeBackgroundView;
@property (nonatomic,weak) IBOutlet UIButton *insertDicButton;
/// insertArrayButton
@property (nonatomic,weak) IBOutlet UIButton *insertArrayButton;
@property (nonatomic,weak) IBOutlet UIButton *insertStringButton;
@property (nonatomic,weak) IBOutlet UIButton *insertNumberButton;
@property (nonatomic,weak) IBOutlet UIButton *insertJsonButton;
@property (nonatomic,weak) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIButton *canCellButton;

@property (nonatomic,strong) UIButton *currentSelectedInsertButton;

@property (nonatomic,copy) NSString *originKey;
@property (nonatomic,strong) id originData;
@property (nonatomic,assign) BaseJsonViewStepModelType originType;
@end

@implementation BaseJsonEditingStatusTableViewCell


#pragma mark - func
// MARK: reload data
- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.layer.borderColor = messageColor.CGColor;
    self.contentView.layer.borderWidth = 1;
    [self setupSubViewsFunc];
}

// MARK: handle views
- (void) setupSubViewsFunc {
    self.massageButton.titleLabel.numberOfLines = 0;
    self.insertButtonArray = @[
                               self.insertDicButton,
                               self.insertArrayButton,
                               self.insertStringButton,
                               self.insertNumberButton,
                               self.insertJsonButton
                               ].mutableCopy;
    
    [self setupTextViewWithView:self.valueTextView];
    [self setupTextViewWithView:self.keyTextView];
    
    [self setupCornerStyle: self.insertDicButton];
    [self setupCornerStyle: self.insertArrayButton];
    [self setupCornerStyle: self.insertStringButton];
    [self setupCornerStyle: self.insertNumberButton];
    [self setupCornerStyle: self.insertJsonButton];
    
    [self setupCornerRoundStyle:self.downButton];
    [self setupCornerRoundStyle: self.canCellButton];
    
    [self setupButtonStyle: self.insertDicButton];
    [self setupButtonStyle: self.insertArrayButton];
    [self setupButtonStyle: self.insertStringButton];
    [self setupButtonStyle: self.insertNumberButton];
    [self setupButtonStyle: self.insertJsonButton];
    
    [self.canCellButton setTitleColor:normalColor forState:UIControlStateNormal];
    [self.downButton setTitleColor:normalColor forState:UIControlStateNormal];
    [self setupLabelStyleWithLabel:self.keyLabel];
    [self setupLabelStyleWithLabel:self.valueLabel];
}

- (void) setupLabelStyleWithLabel:(UILabel *)label {
    label.textColor = discColor;
    label.font = tableViewCellTagFont;
}

- (void) setupCornerStyle:(UIView *)view {
    view.layer.cornerRadius = 6;
    view.layer.borderColor = messageColor.CGColor;
    view.layer.borderWidth = 1;
}

- (void) setupCornerRoundStyle:(UIView *)view {
    view.layer.cornerRadius = view.height/2.0;
    view.layer.borderColor = messageColor.CGColor;
    view.layer.borderWidth = 1;
}

- (void) setupButtonStyle: (UIButton *)button {
    [button setTitleColor:normalColor forState:UIControlStateNormal];
}

- (void) setupTextField: (UITextField *)textField andSelecter: (SEL) selecter andPlaceHolder:(NSString *)placeholder andLeftStr: (NSString *)leftStr{
    textField.delegate = self;
    textField.textColor = leftTitleColor;
    textField.returnKeyType = UIReturnKeySearch;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    textField.placeholder = placeholder;
    textField.font = textFieldFont;
    [textField setValue: textFieldFont forKeyPath:@"_placeholderLabel.font"];
    textField.layer.cornerRadius = 4;
    textField.layer.borderColor = messageColor.CGColor;
    textField.layer.borderWidth = 1;
    textField.leftViewMode = UITextFieldViewModeAlways;
    [textField addTarget:self action:selecter forControlEvents:UIControlEventEditingChanged];
}

// MARK: handle event
- (void) registerEventsFunc {
    
}

// MARK: get && set
- (void)setEditingModel:(BaseJsonViewStepModel *)editingModel {
    [self clearStatus];
    self.originKey = editingModel.key;
    self.originData = editingModel.originData;
    self.originType = editingModel.type;
    
    _editingModel = editingModel;
    self.keyTextView.text = editingModel.key;
    if ([editingModel.data isKindOfClass:NSString.class]) {
        self.valueTextView.text = editingModel.data;
    }else{
        self.valueTextView.text = @"";
    }
    
    [self updateLayout];
}

-(void) updateLayout {
    self.valueBackgroundView.hidden = false;
    self.insertTypeBackgroundH.constant = 33;
    self.valueLabelTop.constant = 8;
    switch (self.editingModel.status) {
        case BaseJsonViewStepCellStatus_Normal:
            break;
        case BaseJsonViewStepCellStatus_EditingSelf:
            break;
        case BaseJsonViewStepCellStatus_InsertItem:
            if (self.editingModel.type == BaseJsonViewStepModelType_Array) {
                
            }
            break;
    }
    if (self.editingModel.status == BaseJsonViewStepCellStatus_InsertItem) {
        
    }
    [self setupDefaultSelectedType];
    [self layoutKayValueViews];
}

- (void) setupDefaultSelectedType {
    NSString *title = @"";
    switch (self.editingModel.type) {
        case BaseJsonViewStepModelType_Dictionary:
            [self clickInsertDic:self.insertDicButton];
            break;
        case BaseJsonViewStepModelType_Array:
            [self clickInsertArray:self.insertArrayButton];
            break;
        case BaseJsonViewStepModelType_Number:
            [self clickInsertArray:self.insertNumberButton];
            break;
        case BaseJsonViewStepModelType_String:
            [self clickInsertArray:self.insertStringButton];
            break;
    }
    self.titleLabel.text = title;
}

- (void) isHiddenKayBackgroundView:(BOOL) isHidden {
    [UIView animateWithDuration:0.2 animations:^{
        self.keyBackgroundViewH.constant = isHidden ? 0 : 55;
        self.keyBackgroundView.alpha = !isHidden;
        self.valueBackgroundView.alpha = isHidden;
        [self layoutIfNeeded];
    }];
}

- (void) isHiddenValueBackgroundView: (BOOL) isHidden  {
    [UIView animateWithDuration:0.2 animations:^{
        self.keyBackgroundViewH.constant = isHidden ? 55 + 120 : 55;
        self.valueBackgroundView.alpha = !isHidden;
        [self layoutIfNeeded];
    }];
}

- (IBAction)clickInsertDic:(id)sender {
    self.editingModel.type = BaseJsonViewStepModelType_Dictionary;
    self.currentSelectedInsertButton = sender;
    
    if (self.clickInsertDicBlock) {
        self.clickInsertDicBlock();
    }
}

- (IBAction)clickInsertArray:(id)sender {
    self.editingModel.type = BaseJsonViewStepModelType_Array;
    
    self.currentSelectedInsertButton = sender;
    
    if (self.clickInsertArrayBlock) {
        self.clickInsertArrayBlock();
    }
}

- (IBAction)clickInsertString:(id)sender {
    self.editingModel.type = BaseJsonViewStepModelType_String;
    self.currentSelectedInsertButton = sender;
    
    if (self.clickInsertStringBlock) {
        self.clickInsertStringBlock();
    }
}

- (IBAction)clickInsertNumber:(id)sender {
    self.editingModel.type = BaseJsonViewStepModelType_Number;
    self.currentSelectedInsertButton = sender;
    
    if (self.clickInsertNumberBlock) {
        self.clickInsertNumberBlock();
    }
}

- (IBAction)clickInsertJson:(id)sender {
    self.editingModel.type = BaseJsonViewStepModelType_Dictionary;
    self.currentSelectedInsertButton = sender;
    
    if (self.clickInsertJsonBlock) {
        self.clickInsertJsonBlock();
    }
}

- (IBAction)clickInsertDown:(id)sender {
    
    BaseJsonViewStepErrorModel *errorModel = [BaseJsonViewStepErrorModel new];
    
    NSInteger index = self.indexPath.row - self.superPointIndexPath.row - 1;
    
    [self setupModelValueWithErrorModel:errorModel];
    
    if (!errorModel.isSuccess) {
        goto failedCode;
    }
    
    switch (self.editingModel.status) {
            
        case BaseJsonViewStepCellStatus_Normal:
            break;
        case BaseJsonViewStepCellStatus_EditingSelf:
            break;
        case BaseJsonViewStepCellStatus_InsertItem:
            
            errorModel = [self.editingModel.superPoint insertWithModel:self.editingModel andIndex:index]; 
            break;
    }
    
    if (!errorModel.isSuccess) {
        goto failedCode;
    }
    
    self.editingModel.status = BaseJsonViewStepCellStatus_Normal;
    [self.editingModel reloadDataWitOriginDataProperty];
    [self reloadEditModel];
    
    if (self.clickInsertDownBlock) {
        self.clickInsertDownBlock();
    }
    [self clearStatus];
    
failedCode: {
    [self showErrorWithModel: errorModel];
}
    
}

- (void) clearStatus {
    self.currentSelectedInsertButton = nil;
    self.originKey = nil;
    self.originData = nil;
    [self showErrorWithModel:nil];
}

- (void) reloadEditModel {
    BaseJsonViewStepModelType type = self.editingModel.type;
    id superPointData = self.editingModel.superPoint.data;
    if ([superPointData isKindOfClass:NSArray.class]) {
        NSArray *dataArray = superPointData;
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:BaseJsonViewStepModel.class]) {
                BaseJsonViewStepModel *model = obj;
                
                if([self.editingModel isEqualToKeyAndOriginDataWithModel:model]) {
                    self.editingModel = model;
                }
            }
        }];
    }
    self.editingModel.type = type;
}

- (void) showErrorWithModel: (BaseJsonViewStepErrorModel *)errorModel {
    NSString *errorStr = errorModel.errorMessage;
    [self.massageButton setTitle:errorStr forState:UIControlStateNormal];
    self.massageButton.titleLabel.font = tableViewCellTagFont;
    
    CGFloat h =
    BaseStringHandler
    .handler(errorStr)
    .getHeightWithWidthAndFont(self.massageButton.width,tableViewCellTagFont);
    
    self.massageButtonH.constant = h;
    self.massageBackgroundScrollview.contentSize = CGSizeMake(0, h);

    if (errorStr.length > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeMassageBordeColor) object:nil];
        [self performSelector:@selector(changeMassageBordeColor) withObject:nil afterDelay:0.2];
    }else {
        self.contentView.layer.borderColor = messageColor.CGColor;
    }
}

- (void) changeMassageBordeColor {
    self.contentView.layer.borderColor = errorColor.CGColor;
}

- (void) setupModelValueWithErrorModel: (BaseJsonViewStepErrorModel *)errorModel {
    
    NSString *data = self.valueTextView.text;
    NSString *key = self.keyTextView.text;
    
    [self checkoutKeyFormSuperPointDataWithKey:key andErrorModel:errorModel];
    
    if (!errorModel.isSuccess) {
        return;
    }
    
    self.editingModel.key = key;
    
    if (self.insertJsonButton.selected) {
        [self insertJsonSetupModelValueWithError:errorModel];
    }
    
    if (self.insertDicButton.selected){
        if (self.originType != BaseJsonViewStepModelType_Dictionary || !self.editingModel.originData) {
            self.editingModel.originData = [NSMutableDictionary new];
        }
    }
    
    if (self.insertArrayButton.selected){
        if (self.originType != BaseJsonViewStepModelType_Array || !self.editingModel.originData) {
            self.editingModel.originData = [NSMutableArray new];
        }
    }
    
    if (self.insertNumberButton.selected) {
        BOOL isNumber = [self isPureNumandCharacters:data];
        if (isNumber) {
            self.editingModel.originData = @(data.floatValue);
        }else{
            errorModel.code = BaseJsonViewStepTypeErrorCode404;
            errorModel.errorMessage = [NSString stringWithFormat:@"🌶: 想要插入一个Number，但实际插入的是字符串【%@】",data];
        }
    }
    
    if (self.insertStringButton.selected) {
        self.editingModel.originData = data;
    }
}

- (void) checkoutKeyFormSuperPointDataWithKey:(NSString *)key andErrorModel:(BaseJsonViewStepErrorModel *)errorModel{
    
    if ([self.editingModel.superPoint.data isKindOfClass:NSArray.class]) {
        NSArray *array = self.editingModel.superPoint.data;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:BaseJsonViewStepModel.class]) {
                BaseJsonViewStepModel *model = obj;
                if ([model.key isEqualToString:key] && (![model isEqual:self.editingModel]) && (model.key.length > 0)){
                    errorModel.code = BaseJsonViewStepErrorCode500;
                    errorModel.errorMessage = [NSString stringWithFormat: @"🌶：同级中有相同的key：%@",key];
                    *stop = true;
                }
            }
        }];
    }
}

- (void) insertJsonSetupModelValueWithError:(BaseJsonViewStepErrorModel *)errorModel {
    NSString *json = self.valueTextView.text;
    NSDictionary *dic = BaseJsonViewManager.convertToDicWithJson(json);
    if (self.insertJsonButton == self.currentSelectedInsertButton) {
        if (self.editingModel.superPoint.type == BaseJsonViewStepModelType_Dictionary) {
            if(dic.count > 0) {
                if (dic.count > 1) {
                    errorModel.code = BaseJsonViewStepErrorCode500;
                    NSMutableString *strM = [NSMutableString new];
                    __block NSInteger idx = 1;
                    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        [strM appendFormat:@"\n        %ld.%@",idx,key];
                        idx += 1;
                    }];
                    errorModel.errorMessage = [NSString stringWithFormat: @"🌶：想要插入一段json，但是json解析出%ld个并列对象: %@",dic.count,strM];
                    
                }else if (dic.count == 1){
                    NSString *key = dic.allKeys.firstObject;
                    id data = [dic valueForKey:key];
                    
                    self.editingModel.key = key;
                    self.editingModel.originData = data;
                }
            }else{
                
            }
        }
    }
    if (self.editingModel.superPoint.type == BaseJsonViewStepModelType_Array) {
        self.editingModel.key = @"";
        self.editingModel.originData = dic;
    }
}

- (void) setupEditSelfValue {
    NSString *data = self.valueTextView.text;
    NSString *key = self.keyTextView.text;
    if (self.insertJsonButton.selected) {
        NSDictionary *dic = BaseJsonViewManager.convertToDicWithJson(data);
        if (dic) {
            self.editingModel.originData = dic;
        }
    } else if (self.insertNumberButton.selected) {
        BOOL isNumber = [self isPureNumandCharacters:data];
        if (isNumber) {
            self.editingModel.originData = data;
        }else{
            /// error
        }
    }else{
        self.editingModel.originData = data;
    }
    self.editingModel.key = key;
    [self.editingModel reloadDataWitOriginDataProperty];
}

- (BOOL)isPureNumandCharacters:(NSString *)string {
    NSScanner *scanner = [NSScanner scannerWithString:string];
    int intValue;
    BOOL isInt = [scanner scanInt:&intValue];
    double doubleValue;
    BOOL isDouble = [scanner scanDouble:&doubleValue];
    
    return (isInt || isDouble) && [scanner isAtEnd];
}

- (IBAction)clickCancellButton:(id)sender {
    //    [self reloadEditModel];
    self.editingModel.originData = self.originData;
    self.editingModel.type = self.originType;
    self.editingModel.key = self.originKey;
    [self.editingModel reloadDataWitOriginDataProperty];
    
    if (self.clickCancellButtonBlock) {
        self.clickCancellButtonBlock();
    }
}

- (void) keyTextViewChange {
    
}

- (void) indexTextFieldChange {
    
}


// MARK: lazy loads
- (void)setCurrentSelectedInsertButton:(UIButton *)currentSelectedInsertButton {
    if (_currentSelectedInsertButton == currentSelectedInsertButton) {
        _currentSelectedInsertButton = nil;
        self.editingModel.type = BaseJsonViewStepModelType_Dictionary;
        _currentSelectedInsertButton = self.insertJsonButton;
    }else{
        _currentSelectedInsertButton = currentSelectedInsertButton;
        [self showErrorWithModel:nil];
    }
    
    [self layoutKayValueViews];
    
    [self.insertButtonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = false;
        [self setupButtonBackgroundStyle:obj];
    }];
    _currentSelectedInsertButton.selected = true;
    [self setupButtonBackgroundStyle:_currentSelectedInsertButton];
}

- (void) layoutKayValueViews {
    
    BOOL isInsertItem = self.editingModel.status == BaseJsonViewStepCellStatus_InsertItem;
    BOOL isSuperPointIsArray = self.editingModel.superPoint.type == BaseJsonViewStepModelType_Array;
    
    BOOL isSuperPointIsDic = self.editingModel.superPoint.type == BaseJsonViewStepModelType_Dictionary;
    BOOL isHiddenKey = isSuperPointIsArray;
    BOOL isHiddenValue = !isHiddenKey;
    NSString *title = @"";
    self.valueTextView.userInteractionEnabled = true;
    if (self.currentSelectedInsertButton == self.insertJsonButton) {
        isHiddenValue = false;
        isHiddenKey = true;
        
        if (BaseJsonViewStepModelType_Dictionary == self.originType) {
            title = @"⚠️：转成Dictionary类型，请输入json";
        }
        if (isInsertItem) {
            title = @"插入Dictionary类型,输入json";
        }
    }
    
    if (self.currentSelectedInsertButton == self.insertDicButton) {
        isHiddenValue = true;
        
        if (BaseJsonViewStepModelType_Dictionary == self.originType) {
            title = @"⚠️：本身就是Dictionary类型，值不变";
        } else {
            title = @"⚠️：转成Dictionary类型，并清空子节点";
        }
        if (isInsertItem) {
            title = @"插入Dictionary类型的节点";
        }
    }
    
    if (self.currentSelectedInsertButton == self.insertArrayButton) {
        isHiddenValue = true;
        
        if (BaseJsonViewStepModelType_Array == self.originType) {
            title = @"⚠️：本身就是 Array类型，值不变";
        } else {
            title = @"⚠️：转成Array类型, 并清空子节点";
        }
        if (isInsertItem) {
            title = @"插入Array类型的节点";
        }
    }
    if (self.currentSelectedInsertButton == self.insertStringButton) {
        isHiddenValue = false;
        
        if (BaseJsonViewStepModelType_Dictionary == self.originType) {
            title = @"String类型,请输入String";
            if (isSuperPointIsArray) {
                title = @"⚠️：转成String类型，请输入String";
            }
        } else {
            title = @"⚠️：转成String类型，请输入String";
        }
        
        if (isInsertItem) {
            title = @"插入String类型的字典";
        }
    }
    if (self.currentSelectedInsertButton == self.insertNumberButton) {
        isHiddenValue = false;
        
        if (BaseJsonViewStepModelType_Dictionary == self.originType) {
            title = @"Number类型,请输入Number";
            if (isSuperPointIsArray) {
                title = @"⚠️：转成Number类型，请输入Number";
            }
        } else {
            title = @"⚠️：转成Number类型，请输入Number";
        }
        if (isInsertItem) {
            title = @"插入Number类型的字典";
        }
    }
    if (!self.currentSelectedInsertButton) {
        isHiddenValue = false;
    }
    if (isHiddenKey) {
        isHiddenValue = false;
    }
    [self isHiddenKayBackgroundView:isHiddenKey];
    if (!isHiddenKey) {
        [self isHiddenValueBackgroundView:isHiddenValue];
    }
    
    self.titleLabel.text = title;
}

- (void) setupButtonBackgroundStyle: (UIButton *)button {
    button.backgroundColor = button.selected ? messageColor : UIColor.whiteColor;
}

- (void) setupTextViewWithView:(UITextView *) textview {
    textview.font = textFieldFont;
    textview.textColor = normalColor;
    textview.layer.cornerRadius = 4;
    textview.layer.borderColor = messageColor.CGColor;
    textview.layer.borderWidth = 1;
    textview.delegate = self;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.textViewShouldBeginEditingBlock) {
        self.textViewShouldBeginEditingBlock(self);
    }
    [self showErrorWithModel:nil];
    return true;
}

+ (CGFloat) getHeithWithModel: (BaseJsonViewStepModel *)model {
    return 320;
}

// MARK: systom functions

// MARK:life cycles


@end


