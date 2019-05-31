//
//  ThumbnailImageViewController.m
//  PYkit
//
//  Created by 衣二三 on 2019/5/24.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "ThumbnailImageViewController.h"
#import "BaseImageHandler+ChangeColor.h"
#import "DemoTextViewController.h"

@interface ThumbnailImageViewController ()

{
    NSMutableData * _data;
    NSData * _allData;
    NSUInteger length;
    UIImageView * _imageView;
    NSTimer * timer;
    NSInteger currentProgress;
    NSInteger untilLenght;
}

@property (nonatomic,assign) BOOL isLazyLoadImage;
@property (nonatomic,strong) UIButton *lazyLoadButton;
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *midButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UIButton *currentSelectedButton;
@property (nonatomic,assign) CGFloat currentThumbnailMaxSize;
@end

@implementation ThumbnailImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.isLazyLoadImage = true;
    timer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(updateImage) userInfo:nil repeats:YES];
    
    [self setupNav];
    [self setupButtons];
    [self click_lazyLoadButtonAction: self.lazyLoadButton];
    [self setupImageView];
}


- (void) setupNav {
    
    self.navBarView.titleButtonHeight = 40;
    self.navBarView.isHiddenBottomLine = false;
    self.navBarView.itemHeight = 40;
    self.navBarView
    .addTitleItemWithTitleAndImg(@"缩略图",nil);
    [self.view addSubview:self.navBarView];
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    self.navBarView.frame = CGRectMake(0, 0, w, 64);
    [self.navBarView reloadView];
}

- (void) setupImageView {
    
    _data = [[NSMutableData alloc]init];
    UIImage *image = [UIImage imageNamed:@"3"];
    _allData = UIImagePNGRepresentation(image);
    length = _allData.length;
    untilLenght = length/10;
    currentProgress = 0;
    CGFloat w = self.view.frame.size.width;
    CGFloat h = w / image.size.width * image.size.height;
    _imageView = [[UIImageView alloc]init];
    _imageView.center = self.view.center;
    _imageView.bounds = CGRectMake(0, 0, w, h);
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.backgroundColor = UIColor.blackColor;
    
    [self.view addSubview:_imageView];
}

- (void) setupButtons {
    self.leftButton = [UIButton new];
    self.rightButton = [UIButton new];
    self.midButton = [UIButton new];
    
    [self.view addSubview:self.leftButton];
    [self.view addSubview:self.rightButton];
    [self.view addSubview:self.midButton];
    [self.view addSubview:self.lazyLoadButton];
    
    [self.leftButton setTitle:@"800" forState:UIControlStateNormal];
    [self.midButton setTitle:@"400" forState:UIControlStateNormal];
    [self.rightButton setTitle:@"200" forState:UIControlStateNormal];
    
    self.leftButton.frame = CGRectMake(10, 80, 100, 50);
    self.midButton.frame = CGRectMake(120, 80, 100, 50);
    self.rightButton.frame = CGRectMake(240, 80, 100, 50);
    self.lazyLoadButton.frame = CGRectMake(10, 150, 150, 50);
    
    self.leftButton.layer.borderColor
    = self.rightButton.layer.borderColor
    = self.midButton.layer.borderColor
    = self.lazyLoadButton.layer.borderColor
    = UIColor.redColor.CGColor;
    
    self.leftButton.layer.borderWidth
    = self.rightButton.layer.borderWidth
    = self.midButton.layer.borderWidth
    = self.lazyLoadButton.layer.borderWidth
    = 1;
    
    [self.leftButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.midButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.rightButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    
    [self.leftButton addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.midButton addTarget:self action:@selector(clickMidButton:) forControlEvents:UIControlEventTouchUpInside];
    [self clickLeftButton:self.leftButton];

}

- (void) clickLeftButton: (UIButton *) button {
    
    [self reloadImageWithCurrentThumbnailMaxSize: 800];
    [self selectedButton: button];
}
- (void) clickMidButton: (UIButton *) button {
    [self reloadImageWithCurrentThumbnailMaxSize: 400];
    [self selectedButton: button];
}

- (void) clickRightButton: (UIButton *) button {
    [self reloadImageWithCurrentThumbnailMaxSize: 200];
    [self selectedButton: button];
}

- (void) reloadImageWithCurrentThumbnailMaxSize: (CGFloat) currentThumbnailMaxSize {
    self.currentThumbnailMaxSize = currentThumbnailMaxSize;
    [self setupImageView];
    if (self.isLazyLoadImage) {
        currentProgress = 0;
    }else{
        _imageView.image =
        BaseImageHandler
        .createWithData(_allData,currentThumbnailMaxSize)
        .image;
    }
    
}

- (void) selectedButton: (UIButton *)button {
    
    self.currentSelectedButton.selected = false;
    self.currentSelectedButton.backgroundColor = UIColor.whiteColor;
    
    self.currentSelectedButton = button;
    
    self.currentSelectedButton.selected = true;
    self.currentSelectedButton.backgroundColor = [UIColor colorWithRed:0.5 green:0.6 blue:0.8 alpha:0.3];
}


-(void)updateImage{
    
    if (currentProgress==10 || !self.isLazyLoadImage) {
        return;
    }
    
    NSInteger untilLenghtTemp = untilLenght;
    if (currentProgress == 9) {
        untilLenghtTemp = length - 9 * untilLenght;
    }
    
    Byte by[untilLenghtTemp];
    [_allData getBytes:by range:NSMakeRange(currentProgress*untilLenght, untilLenghtTemp)];
    [_data appendBytes:by length:untilLenghtTemp];
    
    CGImageSourceRef myImageSource = CGImageSourceCreateWithData((CFDataRef)_data, NULL);
    CFRelease(myImageSource);
    _imageView.image = BaseImageHandler.createWithData(_data,self.currentThumbnailMaxSize).image;
    currentProgress++;
}

/// lazyLoadButton
- (UIButton *) lazyLoadButton {
    if (!_lazyLoadButton) {
        _lazyLoadButton = [UIButton new];
        [_lazyLoadButton setTitle:@"渐进渲染图片" forState:UIControlStateNormal];
        [_lazyLoadButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6] forState:UIControlStateNormal];
        
        [_lazyLoadButton addTarget:self action:@selector(click_lazyLoadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lazyLoadButton;
}

- (void) click_lazyLoadButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    UIColor *color = button.isSelected ? [UIColor colorWithRed:0.5 green:0.6 blue:0.8 alpha:0.3] : UIColor.whiteColor;
    self.lazyLoadButton.backgroundColor = color;
    self.isLazyLoadImage = button.selected;
}
@end
