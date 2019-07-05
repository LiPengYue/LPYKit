//
//  DebugNetWorkSearchResultTableView.m
//  PYkit
//
//  Created by 衣二三 on 2019/7/5.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "DebugNetWorkSearchResultTableView.h"
#import "BaseDebugNetWorkCommon.h"


static NSString *const KDebugNetWorkSearchResultTableViewCellID = @"KDebugNetWorkSearchResultTableViewCellID";
@interface DebugNetWorkSearchResultTableView ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic,strong) NSMutableArray <NSAttributedString *>*modelTitleArray;
@end

@implementation DebugNetWorkSearchResultTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame: frame style:style]) {
        [self setupViews];
    }
    return self;
}

- (void) setupViews {
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:DebugNetWorkSearchResultTableViewCell.class forCellReuseIdentifier:KDebugNetWorkSearchResultTableViewCellID];
}

- (void)setModelArray:(NSArray<BaseDebugNetWorkDataStepModel *> *)modelArray {
    _modelArray = modelArray;
    _modelTitleArray = [[NSMutableArray alloc]initWithCapacity:modelArray.count];
    [_modelArray enumerateObjectsUsingBlock:^(BaseDebugNetWorkDataStepModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.modelTitleArray addObject:[obj getTreeLayerAttriStr]];
    }];
    [self reloadData];
}

- (void) setCurrentSearchModel:(BaseDebugNetWorkDataStepModel *)currentSearchModel {
    _currentSearchModel = currentSearchModel;
    [self reloadData];
}

// MARK: - delegate && DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DebugNetWorkSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KDebugNetWorkSearchResultTableViewCellID forIndexPath:indexPath];
    cell.titleStr = self.modelTitleArray[indexPath.row];
    cell.isCurrentSearch = false;
    if (self.modelArray.count > indexPath.row) {
        cell.isCurrentSearch = [self.modelArray[indexPath.row] isEqual:self.currentSearchModel];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.modelArray.count - 1) {
        return;
    }
    if (self.clickCellBlock) {
        self.clickCellBlock(self.modelArray[indexPath.row]);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = self.modelTitleArray[indexPath.row].string;
    return [DebugNetWorkSearchResultTableViewCell getHWithStr:str];
}

@end



@interface DebugNetWorkSearchResultTableViewCell()
/// title
@property (nonatomic,strong) UILabel * titleLabel;
@end

@implementation DebugNetWorkSearchResultTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void) setupViews {
    [self addSubview:self.titleLabel];
}

- (void)setTitleStr:(NSAttributedString *)titleStr {
    _titleStr = titleStr;
    self.titleLabel.attributedText = titleStr;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
    self.titleLabel.left = 14;
    self.titleLabel.width = self.width - 28;
}

/// titleLabel
- (UILabel *) titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(0,0,0,0);
        _titleLabel.backgroundColor = UIColor.whiteColor;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = normalColor;
        _titleLabel.font = BaseFont.fontSCR(12);
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

+ (CGFloat) getHWithStr: (NSString *)str {
    return BaseStringHandler.handler(str).getHeightWithWidthAndFont(BaseSize.screenW - 28,BaseFont.fontSCR(12)) + 40;
}

- (void)setIsCurrentSearch:(BOOL)isCurrentSearch {
    _isCurrentSearch = isCurrentSearch;
    self.contentView.backgroundColor = isCurrentSearch ? cellBackgroundCurrentSearchColor : UIColor.whiteColor;
}

@end
