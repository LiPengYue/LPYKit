//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//

#import "BaseJsonViewEditHeaderView.h"
#import "BaseJsonViewCommon.h"

@interface BaseJsonViewEditHeaderView()
<
UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet UIButton *TypeButton;
@property (weak, nonatomic) IBOutlet UILabel *ValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *KeyLabel;
@property (weak, nonatomic) IBOutlet UITextField *keyTextField;
@property (weak, nonatomic) IBOutlet UIButton *canCellButton;

@property (weak, nonatomic) IBOutlet UITextView *valueTextField;
@property (weak, nonatomic) IBOutlet UITextField *indexRowTextField;
@property (weak, nonatomic) IBOutlet UIButton *showIndexRowButton;
/// path
@property (nonatomic,strong)  UILabel * pathLabel;
@property (nonatomic,weak) IBOutlet UIButton *insertDicButton;
/// insertArrayButton
@property (nonatomic,weak) IBOutlet UIButton *insertArrayButton;
@property (nonatomic,weak) IBOutlet UIButton *insertStringButton;
@property (nonatomic,weak) IBOutlet UIButton *insertNumberButton;
@property (nonatomic,weak) IBOutlet UIButton *insertJsonButton;
@property (nonatomic,weak) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indexRowTextFieldH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indexRowTextFieldTop;

@property (nonatomic,strong) UIButton *currentSelectedInsertButton;
@property (nonatomic,strong) NSMutableArray <UIButton *>*insertButtonArray;
@end

@implementation BaseJsonViewEditHeaderView


// MARK: - init

+ (instancetype)createWithFrame:(CGRect)frame {
    BaseJsonViewEditHeaderView *editView = [[[NSBundle mainBundle] loadNibNamed:@"BaseJsonViewEditHeaderView" owner:self options:nil] lastObject];
    return editView;
}

- (void) layoutWithWidth: (CGFloat)w {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubViewsFunc];
}

#pragma mark - func
// MARK: reload data
+ (CGFloat) getHeightWithWithModel: (BaseJsonViewStepModel *)model {
    return 270;
//    if ([model.data isKindOfClass:NSArray.class]) {
//        return 250;
//    }else{
//        return 220;
//    }
}
// MARK: handle views
- (void) setupSubViewsFunc {
    
    self.insertButtonArray = @[
                               self.insertDicButton,
                               self.insertArrayButton,
                               self.insertStringButton,
                               self.insertNumberButton,
                               self.insertJsonButton
                               ].mutableCopy;
    
    [self setupTextField:self.keyTextField andSelecter:@selector(keyTextFieldChange) andPlaceHolder:@"请输入key" andLeftStr:@""];
    [self setupTextField:self.indexRowTextField andSelecter:@selector(indexTextFieldChange) andPlaceHolder:@"请输入index" andLeftStr:@"index"];
    
    [self setupTextView];
    
    [self setupCornerStyle: self.insertDicButton];
    [self setupCornerStyle: self.insertArrayButton];
    [self setupCornerStyle: self.insertStringButton];
    [self setupCornerStyle: self.insertNumberButton];
    [self setupCornerStyle: self.insertJsonButton];
    [self setupCornerStyle: self.showIndexRowButton];
    
    [self setupCornerRoundStyle:self.downButton];
    [self setupCornerRoundStyle: self.canCellButton];
    
    [self setupButtonStyle: self.insertDicButton];
    [self setupButtonStyle: self.insertArrayButton];
    [self setupButtonStyle: self.insertStringButton];
    [self setupButtonStyle: self.insertNumberButton];
    [self setupButtonStyle: self.insertJsonButton];
    
    [self.canCellButton setTitleColor:normalColor forState:UIControlStateNormal];
    [self.downButton setTitleColor:normalColor forState:UIControlStateNormal];
    [self.TypeButton setTitleColor:discColor forState:UIControlStateNormal];
    self.ValueLabel.textColor = discColor;
    self.KeyLabel.textColor = discColor;
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

- (IBAction)clickInsertDic:(id)sender {
    self.currentSelectedInsertButton = sender;
    if (self.clickInsertDicBlock) {
        self.clickInsertDicBlock();
    }
}

- (IBAction)clickInsertArray:(id)sender {
    self.currentSelectedInsertButton = sender;
    if (self.clickInsertArrayBlock) {
        self.clickInsertArrayBlock();
    }
}

- (IBAction)clickInsertString:(id)sender {
    self.currentSelectedInsertButton = sender;
    if (self.clickInsertStringBlock) {
        self.clickInsertStringBlock();
    }
}

- (IBAction)clickInsertNumber:(id)sender {
    self.currentSelectedInsertButton = sender;
    if (self.clickInsertNumberBlock) {
        self.clickInsertNumberBlock();
    }
}

- (IBAction)clickInsertJson:(id)sender {
    self.currentSelectedInsertButton = sender;
    if (self.clickInsertJsonBlock) {
        self.clickInsertJsonBlock();
    }
}

- (IBAction)clickInsertDown:(id)sender {
    if (self.clickInsertDownBlock) {
        self.clickInsertDownBlock();
    }
}

- (IBAction)clickCancellButton:(id)sender {
    
}

- (IBAction)clickShowIndexButton:(id)sender {
    self.showIndexRowButton.selected = !self.showIndexRowButton.selected;
    if(self.clickShowIndexBlock) {
        self.clickShowIndexBlock(self.showIndexRowButton.selected);
    }
}

- (void) keyTextFieldChange {
    
}

- (void) indexTextFieldChange {
    
}


// MARK: lazy loads
- (void)setCurrentSelectedInsertButton:(UIButton *)currentSelectedInsertButton {
    if (_currentSelectedInsertButton == currentSelectedInsertButton) {
        _currentSelectedInsertButton = nil;
    }else{
        _currentSelectedInsertButton = currentSelectedInsertButton;
    }
    [self.insertButtonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = false;
        [self setupButtonBackgroundStyle:obj];
    }];
    _currentSelectedInsertButton.selected = true;
    [self setupButtonBackgroundStyle:_currentSelectedInsertButton];
}

- (void) setupButtonBackgroundStyle: (UIButton *)button {
    button.backgroundColor = button.selected ? messageColor : UIColor.whiteColor;
}

- (void)setEditModel:(BaseJsonViewStepModel *)editModel {
    _editModel = editModel;
    CGFloat h = 30;
    CGFloat top = 10;
    BOOL isHiddenIndex = true;
    
    
    switch (editModel.type) {
        case BaseJsonViewStepModelType_Dictionary:
            top = 2; h = 0;
            isHiddenIndex = true;
            break;
        case BaseJsonViewStepModelType_Array:
            top = 30; h = 10;
            isHiddenIndex = false;
            break;
        case BaseJsonViewStepModelType_Number:
            top = 2; h = 0;
            isHiddenIndex = true;
            break;
        case BaseJsonViewStepModelType_String:
            top = 2; h = 0;
            isHiddenIndex = true;
            break;
    }
    self.indexRowTextField.hidden = true;
    self.keyTextField.text = editModel.key;
    if (editModel.key.length > 0) {
        self.KeyLabel.text = @"Key修改为：";
    }else{
        self.KeyLabel.text = @"Key：";
    }
    
    if ([self.editModel.data isKindOfClass:NSString.class]
        || [self.editModel.data isKindOfClass:NSNumber.class]) {
        self.ValueLabel.text = @"Value修改为：";
        self.valueTextField.text = [NSString stringWithFormat:@"%@",self.editModel.data];
    }else{
        self.valueTextField.text = @"";
        self.ValueLabel.text = @"Value：";
    }
    
    self.indexRowTextFieldH.constant = h;
    self.indexRowTextFieldTop.constant = top;
    self.indexRowTextField.hidden = isHiddenIndex;
    self.showIndexRowButton.hidden = isHiddenIndex;
}

- (void) setupTextView {
    self.valueTextField.font = textFieldFont;
    self.valueTextField.textColor = normalColor;
    self.valueTextField.layer.cornerRadius = 4;
    self.valueTextField.layer.borderColor = messageColor.CGColor;
    self.valueTextField.layer.borderWidth = 1;
}

// MARK: systom functions

// MARK:life cycles

@end
