//
//  PYCountDownViewController.m
//  PYCountDownHandler_Example
//
//  Created by 李鹏跃 on 2018/12/18.
//  Copyright © 2018年 LiPengYue. All rights reserved.
//

#import "PYCountDownViewController.h"
#import "PYCountDownTableViewCell.h"
#import "PYCountDownModel.h"
#import "CountDownHandler.h"
#import "BaseObjectHeaders.h"

static NSString *const k_PYCountDownTableViewCellID = @"k_PYCountDownTableViewCellID";
#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface PYCountDownViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic,strong) UIButton *dismissButton;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray <PYCountDownModel *> *modelArray;
@property (nonatomic,strong) CountDownHandler *countDownHandler;
@end


@implementation PYCountDownViewController
#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BaseColorHandler.cHex(0xFAFAFA);
    
    [self setup];
}

#pragma mark - functions

- (void) setup {
    self.countDownHandler = [[CountDownHandler alloc]init];
    self.countDownHandler.targetMaxCount = 100;
    [self.countDownHandler start];
    [self setupView];
    [self loadData];
}

// MARK: network
- (void) loadData {
    NSMutableArray * arrayM = @[].mutableCopy;
    for (int i = 0; i < 20; i ++) {
        PYCountDownModel *model = [PYCountDownModel new];
        model.countDownNum = 30;
        model.isShowCountDown = i%2;
        [arrayM addObject:model];
    }
    self.modelArray = arrayM.copy;
}

// MARK: handle views

- (void) setupView {

    [self.view addSubview:self.tableView];
    
    [self layoutTableView];
    
    [self.tableView registerClass:[PYCountDownTableViewCell class] forCellReuseIdentifier:k_PYCountDownTableViewCellID];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    [self setupFooterView];
    
    // tableView 偏移20/64适配
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void) layoutTableView {
    self.tableView.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:100];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    [self.view addConstraints:@[top,left,bottom,right]];
}

- (void) setupFooterView {
    
    UIButton *footerButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 40)];
    footerButton.backgroundColor = UIColor.redColor;
    [footerButton setTitle:@"点击加载更多" forState:UIControlStateNormal];
    [footerButton setTitle:@"加载中" forState:UIControlStateSelected];
    self.tableView.tableFooterView = footerButton;
    [footerButton addTarget:self action:@selector(clickLoadData:) forControlEvents:UIControlEventTouchUpInside];
}
/// 加载数据
- (void) clickLoadData:(UIButton *)button {
    button.selected = true;
    button.userInteractionEnabled = false;
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), q, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray * arrayM = self.modelArray.mutableCopy;
            for (int i = 0; i < 20; i ++) {
                PYCountDownModel *model = [PYCountDownModel new];
                model.countDownNum = 340;
                model.isShowCountDown = i%2;
                [arrayM addObject:model];
            }
            self.modelArray = arrayM.copy;
            button.selected = false;
            button.userInteractionEnabled = true;
        });
    });
}

// MARK: properties get && set
- (void)setModelArray:(NSArray<PYCountDownModel *> *)modelArray {
    _modelArray = modelArray;
    [self.countDownHandler registerCountDownEventWithDataSources:modelArray];
    [self.tableView reloadData];
}

// MARK: - delegate && datesource

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

- (UIButton *) dismissButton {
    if (!_dismissButton) {
        _dismissButton = [UIButton new];
        [_dismissButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [_dismissButton setTitle:@"销毁倒计时视图" forState:UIControlStateNormal];
        _dismissButton.backgroundColor = UIColor.blackColor;
        [_dismissButton addTarget:self action:@selector(click_dismissButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}
- (void)click_dismissButton {
    [self dismissViewControllerAnimated:true completion:nil];
}

//MARK: - delegate && datasource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PYCountDownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:k_PYCountDownTableViewCellID forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[PYCountDownTableViewCell class]]) {
        PYCountDownModel *model = self.modelArray[indexPath.row];
        cell.model = model;
        [self.countDownHandler registerCountDownEventWithDelegate:cell];
    }
    return cell;
}

// MARK:life cycles
- (void)dealloc {
    [self.countDownHandler end];
    NSLog(@"✅销毁：%@",NSStringFromClass([self class]));
}
@end

