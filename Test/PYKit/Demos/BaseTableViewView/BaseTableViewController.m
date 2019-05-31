//
//  BaseTableViewController.m
//  Test
//
//  Created by 衣二三 on 2019/4/15.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseTableTestView.h"
#import "BaseSize.h"
@interface BaseTableViewController ()

@property (nonatomic,strong) BaseTableTestView *tableView;
@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, BaseSize.navTotalH, BaseSize.screenW,BaseSize.screen_navH);
}



- (BaseTableTestView *)tableView {
    if (!_tableView) {
        _tableView  = [BaseTableTestView new];
    }
    return _tableView;
}


@end
