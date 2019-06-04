//
//  TransformViewController.m
//  PYkit
//
//  Created by 衣二三 on 2019/5/28.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "PresentAnimationVC.h"
#import "BaseTableView.h"
#import "MainTableViewCell.h"
#import "BaseStringHandler.h"
#import "PresentDemoViewController.h"
@interface PresentAnimationVC ()
<
BaseTableViewDelegate,
BaseTableViewDataSource
>
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSArray <NSString *>*presentData;
@property (nonatomic,strong) NSArray <NSString *>*dismissData;
@property (nonatomic,copy) NSString *selectedPersentStyle;
@property (nonatomic,copy) NSString *selectedDismissStyle;

@property (nonatomic,strong) UIButton *haveNavigetionVCButton;
@property (nonatomic,strong) UIButton *linkButton;
@property (nonatomic,strong) UIButton *presentButton;
@property (nonatomic,strong) UIButton *haveShadowAnimationButton;
@property (nonatomic,strong) UILabel *label;
@end

@implementation PresentAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.label];
    [self.view addSubview:self.haveNavigetionVCButton];
    [self.view addSubview:self.linkButton];
    [self.view addSubview:self.presentButton];
    [self.view addSubview:self.haveShadowAnimationButton];
    [self.view addSubview: self.tableView];
}


- (NSArray<NSString *> *)presentData {
    if (!_presentData) {
        
        _presentData = @[
                       /// 无动画
                       @"PresentAnimationStyleNull",
                       /// 位置不动 进行 缩放与透明度 动画
                       @"PresentAnimationStyleZoom",
                       /// 从下到上
                       @"PresentAnimationStyleBottom_up",
                       /// 从上到下
                       @"PresentAnimationStyleUp_Bottom",
                       /// 右向左滑动
                       @"PresentAnimationStyleRight_left",
                       /// 左向右滑动
                       @"PresentAnimationStyleLeft_right"
                       ];
    }
    return _presentData;
}

- (NSArray<NSString *> *)dismissData {
    if(!_dismissData) {
        _dismissData = @[
                         /// 无动画
                        @"DismissAnimationStyleNull",
                         /// 位置不动 进行 缩放与透明度 动画
                        @"DismissAnimationStyleZoom",
                         /// 从上到下
                        @"DismissAnimationStyleUp_bottom",
                         /// 从下到上
                        @"DismissAnimationStyleBottom_Up",
                         /// 左向右滑动
                        @"DismissAnimationStyleLeft_Right",
                         /// 右向左滑动
                        @"DismissAnimationStyleRight_Left"
                         ];
    }
    return _dismissData;
}

#pragma mark - func
// MARK: reload data


// MARK: handle event
- (void) registerEventsFunc {
    
}

// MARK: lazy loads
- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.textColor = UIColor.redColor;
        _label.numberOfLines = 0;
        _label.layer.borderColor = UIColor.redColor.CGColor;
        _label.layer.borderWidth = 1;
        _label.frame = CGRectMake(10, 90, self.view.frame.size.width-20, 100);
    }
    return _label;
}

/// haveNavigetionVCButton
- (UIButton *) haveNavigetionVCButton {
    if (!_haveNavigetionVCButton) {
        _haveNavigetionVCButton = [UIButton new];
        _haveNavigetionVCButton.frame = CGRectMake(10, CGRectGetMaxY(self.label.frame) + 10, self.view.frame.size.width/2-15, 50);
        [_haveNavigetionVCButton setTitle:@"含导航条" forState:UIControlStateNormal];
        [_haveNavigetionVCButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _haveNavigetionVCButton.layer.borderColor = UIColor.redColor.CGColor;
        _haveNavigetionVCButton.layer.borderWidth = 1;
        [_haveNavigetionVCButton addTarget:self action:@selector(click_haveNavigetionVCButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _haveNavigetionVCButton;
}
- (void) click_haveNavigetionVCButtonAction:(UIButton *)button {
    
    button.selected = !button.selected;
    BOOL isSelected = button.selected;
    button.backgroundColor = isSelected ? [UIColor colorWithRed:0.5 green:0.6 blue:0.8 alpha:0.3] : UIColor.whiteColor;
}

- (UIButton *) haveShadowAnimationButton {
    if (!_haveShadowAnimationButton) {
        _haveShadowAnimationButton = [UIButton new];
        _haveShadowAnimationButton.frame = CGRectMake(CGRectGetMaxX(self.haveNavigetionVCButton.frame) + 10, self.haveNavigetionVCButton.frame.origin.y, self.view.frame.size.width/2-15, 50);
        [_haveShadowAnimationButton setTitle:@"阴影动画" forState:UIControlStateNormal];
        [_haveShadowAnimationButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_haveShadowAnimationButton addTarget:self action:@selector(click_haveShadowAnimationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _haveShadowAnimationButton.layer.borderColor = UIColor.redColor.CGColor;
        _haveShadowAnimationButton.layer.borderWidth = 1;
    }
    return _haveShadowAnimationButton;
}

- (void)click_haveShadowAnimationButtonAction: (UIButton *)button {
    button.selected = !button.selected;
    button.backgroundColor = button.selected ? [UIColor colorWithRed:0.5 green:0.6 blue:0.8 alpha:0.3] : UIColor.whiteColor;
}
- (UIButton *)linkButton {
    if (!_linkButton) {
        _linkButton = [UIButton new];
        _linkButton.frame = CGRectMake(CGRectGetMaxX(self.haveNavigetionVCButton.frame) + 10, CGRectGetMaxY(self.haveNavigetionVCButton.frame) + 10, self.view.frame.size.width/2-15, 50);
        [_linkButton setTitle:@"联动" forState:UIControlStateNormal];
        [_linkButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_linkButton addTarget:self action:@selector(click__linkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _linkButton.layer.borderColor = UIColor.redColor.CGColor;
        _linkButton.layer.borderWidth = 1;
    }
    return _linkButton;
}

- (void)click__linkButtonAction: (UIButton *)button {
    button.selected = !button.selected;
    button.backgroundColor = button.selected ? [UIColor colorWithRed:0.5 green:0.6 blue:0.8 alpha:0.3] : UIColor.whiteColor;
}

/// presentButton
- (UIButton *) presentButton {
    if (!_presentButton) {
        _presentButton = [UIButton new];
        _presentButton.frame = CGRectMake(10, CGRectGetMaxY(self.haveNavigetionVCButton.frame) + 10, self.view.frame.size.width/2-15, 50);
        [_presentButton setTitle:@"present" forState:UIControlStateNormal];
        [_presentButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_presentButton addTarget:self action:@selector(click_presentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _presentButton.layer.borderColor = UIColor.redColor.CGColor;
        _presentButton.layer.borderWidth = 1;
    }
    return _presentButton;
}
- (void) click_presentButtonAction:(UIButton *)button {
    
    PresentDemoViewController *presentViewController = [PresentDemoViewController new];
    presentViewController.presentStyle = [self.presentData indexOfObject:self.selectedPersentStyle];
    presentViewController.dismissStyle = [self.dismissData indexOfObject:self.selectedDismissStyle];
    
    UIViewController *vc = self.haveNavigetionVCButton.selected ? presentViewController.presentNavigationController : presentViewController;
    
    presentViewController.isShowNavigetion = self.haveNavigetionVCButton.selected;
    presentViewController.isHaveShadowAnimation = self.haveShadowAnimationButton.selected;
    presentViewController.isLinkage = self.linkButton.selected;
    [self presentViewController:vc animated:true completion:nil];
}



- (BaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[BaseTableView alloc]initWithFrame:self.view.bounds];
        _tableView.tableViewDelegate = self;
        _tableView.tableViewDataSource = self;
        _tableView.frame = CGRectMake(0, CGRectGetMaxY(self.presentButton.frame) + 10, self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(self.presentButton.frame) - 10);
        if (@available(iOS 11.0, *)) {
            _tableView.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
        }
        else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

// MARK: systom functions

// MARK:life cycles


#pragma mark - delegate dataSource
- (SBaseTabelViewData) getTableViewData:(BaseTableView *)baseTableView andCurrentSection:(NSInteger)section andCurrentRow:(NSInteger)row {
   
    SBaseTabelViewData data = SBaseTabelViewDataMakeDefault();
    data.sectionCount = 2;
    data.rowHeight = 60;
    data.rowType = MainTableViewCell.class;
    data.rowIdentifier = @"MainTableViewCell";
    
    if (section == 0) {
        data.rowCount = self.presentData.count;
        data.key = @"present";
    }else{
        data.rowCount = self.presentData.count;
        data.key = @"dismiss";
    }
  
    return data;
}

- (void)baseTableView:(BaseTableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath andData:(SBaseTabelViewData)data{
    
    if ([MainTableViewCell.class isEqual: data.rowType]) {
        
        MainTableViewCell *mainCell = (MainTableViewCell *)cell;
        if ([data.key isEqualToString:@"present"]) {
            mainCell.title = self.presentData[indexPath.row];
        }else{
            mainCell.title = self.dismissData[indexPath.row];
        }
        
        if ([mainCell.title isEqualToString:self.selectedPersentStyle]
            || [mainCell.title isEqualToString:self.selectedDismissStyle] ) {
            mainCell.backgroundColor = [UIColor colorWithRed:0.5 green:0.6 blue:0.8 alpha:0.3];
        }else{
            mainCell.backgroundColor = UIColor.whiteColor;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath andData:(SBaseTabelViewData)data {
    
    if ([MainTableViewCell.class isEqual:data.rowType]) {
        if ([data.key isEqualToString:@"present"]) {
            self.selectedPersentStyle = self.presentData[indexPath.row];
        }else{
            self.selectedDismissStyle = self.dismissData[indexPath.row];
        }
        
    }
    
    
    BaseStringHandler *handler =
    BaseStringHandler
    .handler(@"1. ")
    .addObjc(self.selectedPersentStyle);
    
    if (self.selectedDismissStyle != NULL) {
        handler
        .addObjc(@"\n2. ")
        .addObjc(self.selectedDismissStyle);
    }
    self.label.text = handler.getStr;
    [self.tableView.tableView reloadData];
}
@end
