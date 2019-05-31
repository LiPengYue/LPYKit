//
//  DeleteCollectionCellViewController.m
//  PYkit
//
//  Created by 衣二三 on 2019/5/21.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "DeleteCollectionCellViewController.h"
#import "DeleteCollectionViewCell.h"
#import "DelegateModel.h"

static NSString *const kDeleteCellKey = @"kDeleteCellKey";

@interface DeleteCollectionCellViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
DeleteCollectionViewCellDelegate
>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray <DelegateModel *>*dataSource;
@property (nonatomic,strong) NSIndexPath *currentSelecteIndex;
@end

@implementation DeleteCollectionCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    NSString *str = @"阿爸 阿斗 阿飞 阿胶 阿拉 阿里 阿婆 阿姨 阿谀 埃及 挨边 挨次 挨打 挨到 挨饿 挨个 挨过 挨肩 挨近 挨骂 挨整 挨着 挨揍 哎呀 哎哟 癌变 癌病 癌症 艾草 艾虎 艾蓬 艾绒 艾蒿 碍口 碍难 碍事 碍眼 碍于 爱称 爱戴 爱得 爱抚 爱国 爱好 爱河 爱护 爱怜 爱恋 爱美 爱民 爱慕 爱女 爱妻 爱情 爱人 爱说 爱听 爱惜 爱小 爱心 爱憎 爱重 爱子 隘口 鞍马 鞍子 氨基 氨气 氨水 安插 安达 安得 安定 安顿 安放 安分 安抚 安好 安徽 安家 安静 安居 安康 安乐 安曼 安眠 安民 安宁 安排 安培 安庆 安全 安然 安上 安设 安身 安神 安生 安适 安睡 安泰 安恬 安妥 安危 安慰 安稳 安息 安闲 安祥 安详 安歇 安心 安逸 安营 安葬 安枕 安置 安装 安谧 安瓿 按插 按此 按动 按键 按揭 按理 按例 按量 按了 按铃 按脉 按摩 按年 按钮 按排 按期 按日 按时 按说 按下 按压 按语 按月 按照 按置 按住 暗暗 暗堡 暗舱 暗藏 暗处 暗淡 暗道 暗房 暗害 暗含 暗号 暗盒 暗黑 暗花 暗疾 暗记 暗礁 暗里 暗流 暗昧 暗门 暗念 暗盘 暗器 暗弱 暗杀 暗伤 暗哨 暗示 暗事 暗室 暗算 暗探 暗喜 暗匣 暗下 暗线 暗箱 暗销 暗语 暗喻 暗中 暗自 岸边 岸标 岸上 案板 案发 案犯 案件 案卷 案例 案情 案头 案子 肮脏 昂昂 昂奋 昂贵 昂然 昂首 昂扬 盎然 盎司 敖包 熬到 熬过 熬煎 熬磨 熬心 熬药 熬夜 熬粥 翱翔 奥迪 奥秘 奥妙 奥拓 澳抗 澳毛 澳门 澳洲 芭蕉 芭蕾 吧女 吧台 吧嗒 八百 八成 八方 八哥 八股 八角 八开 八路 八强 八十 八万 八一 八月 八卦 疤痕 疤瘌 巴巴 巴豆 巴赫 巴结 巴库 巴黎 巴林 巴士 巴松 巴望 巴乌 巴西 巴掌 跋涉 跋扈 靶标 靶场 靶台 靶心 靶子 把柄 把持 把关 把好 把家 把酒 把脉 把你 把手 把守 把他 把它 把她 把头 把玩 把我 把握 把戏 坝基 坝田 罢笔 罢工 罢官 罢课 罢了 罢免 罢赛 罢市 罢手 罢讼 罢诉 罢休 罢演 罢战 罢职 白白 白班 白版 白布 白菜 白茶 白城 白吃 白痴 白醋 白搭 白带 白道 白地 白鹅 白发 白矾 白方 白费 白鸽 白宫 白骨 白光 白果 白喝 白鹤 白喉 白花 白化 白话 白灰 白鸡 白讲 白金 白净 白酒 白看 白亮 白磷 白领 白露 白马 白忙 白猫 白面 白拿 白嫩 白跑 白票 白漆 白旗 白区 白热 白人 白刃 白日 白肉 白润 白色 白生 白事 白薯 白术 白水 白塔 白糖";
    self.dataSource = [NSMutableArray new];
    NSArray <NSString *>*stringArray = [str componentsSeparatedByString:@" "].mutableCopy;
    [stringArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DelegateModel *model = [DelegateModel new];
        model.title = obj;
        model.isBarView = idx == 12;
        [self.dataSource addObject:model];
    }];
    
    [self setup_views];
    [self register_events];
}
// MARK: - init


#pragma mark - func

// MARK: setupTable

// MARK: handle views
- (void) setup_views {
    [self.view addSubview: self.collectionView];
}
// MARK: handle event
- (void) register_events {
    
}

// MARK: lazy loads
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 12;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 14, 0, 14);
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        [_collectionView registerClass:DeleteCollectionViewCell.class forCellWithReuseIdentifier:kDeleteCellKey];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
    }
    return _collectionView;
}
// MARK: systom functions

// MARK:life cycles


// MARK: - DataSource delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDeleteCellKey forIndexPath:indexPath];
    
    if ([cell isKindOfClass:DeleteCollectionViewCell.class]) {
        DeleteCollectionViewCell *deleteCell = (DeleteCollectionViewCell *)cell;
        deleteCell.model = self.dataSource[indexPath.row];
        deleteCell.isShowMaskView = false;
        deleteCell.delegate = self;
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    id anyCell = [self.collectionView cellForItemAtIndexPath:self.currentSelecteIndex];
    if ([anyCell isKindOfClass: DeleteCollectionViewCell.class]) {
        DeleteCollectionViewCell *cell = anyCell;
        cell.isShowMaskView = false;
    }
}

// MARK: - DeleteCollectionCellDelegate

- (void)longPressGestureWithIndex:(NSIndexPath *)index{
    id cellAny = [self.collectionView cellForItemAtIndexPath:index];
    id currentCellAny = [self.collectionView cellForItemAtIndexPath:self.currentSelecteIndex];
    if ([cellAny isKindOfClass:DeleteCollectionViewCell.class]) {
        if ([currentCellAny isKindOfClass:DeleteCollectionViewCell.class]) {
            DeleteCollectionViewCell *currentCell = currentCellAny;
            currentCell.isShowMaskView = false;
        }
        DeleteCollectionViewCell *deleteCell = cellAny;
        deleteCell.isShowMaskView = true;
        self.currentSelecteIndex = index;
    }
}

- (void)deleteWithIndex:(NSIndexPath *)index {
    [self netWork:^{
        [self.dataSource removeObjectAtIndex:index.row];
        [self.collectionView deleteItemsAtIndexPaths:@[index]];
    }];
}

- (void) netWork: (void(^)(void))block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}
@end

