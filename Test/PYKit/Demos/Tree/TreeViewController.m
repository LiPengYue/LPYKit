//
//  TreeViewController.m
//  PYkit
//
//  Created by 衣二三 on 2019/5/29.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "TreeViewController.h"
#import "TreeModel.h"

@interface TreeViewController ()

@end

@implementation TreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    TreeModel *rootModel = [self getTree];
    [self visitTreeWithModel:rootModel];
    NSLog(@"");
    [self levelOrder:rootModel];
}


- (void) visitTreeWithModel: (TreeModel *)model {
    if (model == nil) {
        return;
    }
    NSLog(@"前序遍历：%@",model.data);// 前序遍历
    if (model.left != nil) {
        [self visitTreeWithModel:model.left];
    }
    
//    NSLog(@"中序遍历：%@",model.data);// 中序遍历
    if (model.right != nil) {
        [self visitTreeWithModel:model.right];
    }
//    NSLog(@"后序遍历：%@",model.data);// 后序遍历
}

- (void) levelOrder: (TreeModel *)model {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:model];
    while (array.count) {
        TreeModel *model = array[0];
        [array removeObject:model];
        
        NSLog(@"%@",model.data);
        
        if (model.left) {
            [array addObject:model.left];
        }
        if (model.right) {
            [array addObject:model.right];
        }
    }
}


- (TreeModel *)getTree {
    TreeModel *model = [TreeModel new];
    model.left = [TreeModel new];
    model.right = [TreeModel new];
    model.data = @"1";
    model.left.data =  @"1left";
    model.right.data =  @"1right";

    
    model.left.left = [TreeModel new];
    model.left.left.data = @"2left-left";
    
    
    model.right.left = [TreeModel new];
    model.right.left.data = @"2right.left";
    model.right.right = [TreeModel new];
    model.right.right.data = @"2right.right";
    return model;
}


@end
