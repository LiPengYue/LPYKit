//
//  BaseTextViewController.m
//  PYkit
//
//  Created by 衣二三 on 2019/5/6.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BaseTextViewController.h"
#import "BaseViewHeaders.h"
#import "BaseObjectHeaders.h"
#import "YYText.h"

static inline UIColor * RGBHEX(long value) {
    return BaseColorHandler.cHex(value);
}

@interface BaseTextViewController ()
/// text
@property (nonatomic,strong) UILabel * textLabel;
@property (nonatomic,strong) UILabel *textLabel2;
@property (nonatomic,strong) UILabel *textLabel3;
@property (nonatomic,copy) id(^block)(BaseTextViewController *vc,id data);
@property (nonatomic,strong) UIColor *color;
@end

@implementation BaseTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.textLabel2];
    [self.view addSubview:self.textLabel3];
    [self setupTextLabel];
    [self setupTextLabel2];
    [self setupTextLabel3];

}

- (void) setupTextLabel {

    CGFloat w = self.view.frame.size.width - 20;
    
    NSString *str = @"据的时候，如果发送方传输的数据量超过了接收方的处理能力，那么接收方会出现丢包。为了避免出现此类 问题，流量控制要求数据传输双方在每次交互时声明各自的接收窗口「rwnd」大小，用来表示自己最大  能保存多少数据，这主要是针对接收方而言的，通俗点儿说就是让发送方知道接收方能吃几碗";
    
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    NSMutableAttributedString *attriStr = [self getTextAttributedStr: str];
    CGFloat h = 0;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(w, 999) text:attriStr];
    h = layout.textBoundingSize.height;
    
    NSLog(@"YYTextLayout = %lf",h);
    NSLog(@"PYKit %lf",[attriStr getHeightWithWidth:w]);
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.textLabel.frame = CGRectMake(10, 80, w, h);
    self.textLabel.attributedText = attriStr;
}

- (void) setupTextLabel2 {
    CGFloat w = self.view.frame.size.width - 20;
    CGFloat y = CGRectGetMaxY(self.textLabel.frame);
    
    self.textLabel2.attributedText =
    BaseAttributedStrHandler
    .handle(@"删除线字符串")
    .setUpAddBottomLine(NSAttStrChangeStyleLineStyleEnum_Single,UIColor.redColor)
    .setUpFont(BaseFont.fontSCL(20))
    .append(
            BaseAttributedStrHandler
            .handle(@"下划线")
            .setUpStrikethrough(
                                NSAttStrChangeStyleLineStyleEnum_Single,
                                UIColor.redColor,
                                NULL
                                )
            .setUpFont(BaseFont.fontSCR(22))
            )
    .str;
    
    self.textLabel2.attributedText =
    BaseAttributedStrHandler
    .handle(@"下划线")
    .setUpStrikethrough(
                        NSAttStrChangeStyleLineStyleEnum_Single,
                        UIColor.redColor,
                        NULL
                        )
    .setUpFont(BaseFont.fontSCR(22))
    .appendStr(
               BaseImageHandler
               .handle(@"1")
               .setUpImageSize(CGSizeMake(30, 32))
               .setUpYWithFont(BaseFont.fontSCR(22))
               .getImageStr
               )
    .str;
//    .append(
//            BaseAttributedStrHandler
//            .handle(@"据传输双方在每次交互时声明各自的")
//            .setUpColor(UIColor.blackColor)
//            .setUpFont(BaseFont.fontSCR(20))
//            )
//    .str;
    
    CGFloat h = [_textLabel2.attributedText getHeightWithWidth:w];
    self.textLabel2.frame = CGRectMake(10, y + 10, w, h);
    
    
    NSMutableAttributedString *attriButedStr = [[NSMutableAttributedString alloc]initWithString:@"删除线"];
    NSDictionary *attris = @{
                          NSStrikethroughStyleAttributeName :  @(NSUnderlineStyleSingle),
                          NSStrikethroughColorAttributeName : UIColor.redColor,
                          NSBaselineOffsetAttributeName : @(0),
                          NSFontAttributeName:BaseFont.fontSCR(20),
                          };
    NSRange range =  NSMakeRange(0, attriButedStr.length);
    [attriButedStr addAttributes:attris range:range];
    
    NSTextAttachment *imageAttach = [[NSTextAttachment alloc]init];
    imageAttach.image = [UIImage imageNamed:@"1"];
    CGFloat imageW = 30;
    CGFloat imageH = 32;
    CGFloat imageY = (BaseFont.fontSCR(20).capHeight - imageH)/2;
    imageAttach.bounds = CGRectMake(0,imageY, imageW, imageH);
    NSAttributedString *imageStr = [NSMutableAttributedString attributedStringWithAttachment:imageAttach];
    
    [attriButedStr appendAttributedString:imageStr];
    _textLabel.attributedText = attriButedStr;
    
}

- (void) setupTextLabel3 {
    CGFloat w = self.view.frame.size.width - 20;
    CGFloat y = CGRectGetMaxY(self.textLabel2.frame);
    self.textLabel3.attributedText = [self getAttribute:@"中新网北京新闻4月26日电 (记者 杜燕)自2019年5月1日起,北京市药品和医疗器械产品注册收费标准降为零,预计2019年减轻企业负担约6600万元。" andHighligh:@[@"2019年5月1日",@"2019年",@"4月26日",@"6600万"]];
    CGFloat h = [_textLabel3.attributedText getHeightWithWidth:w];
    self.textLabel3.frame = CGRectMake(10, y + 10, w, h);
}

- (NSMutableAttributedString *) getTextAttributedStr: (NSString *)str {
    if (str.length <= 0) {
        str = @"";
    }
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 4;
    style.paragraphSpacingBefore = 0;
    style.paragraphSpacing = 7;
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:UIColor.redColor};
    [attributedStr addAttributes:dic range:NSMakeRange(0, str.length)];
    return attributedStr;
}
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.numberOfLines = 0;
        _textLabel.layer.borderWidth = 1;
        _textLabel.layer.borderColor = UIColor.redColor.CGColor;
    }
    return _textLabel;
}
- (UILabel *)textLabel2 {
    if (!_textLabel2) {
        _textLabel2 = [[UILabel alloc]init];
        _textLabel2.numberOfLines = 0;
        _textLabel2.userInteractionEnabled = true;
        _textLabel2.layer.borderWidth = 1;
        _textLabel2.layer.borderColor = UIColor.redColor.CGColor;
    }
    return _textLabel2;
}
- (UILabel *)textLabel3 {
    if (!_textLabel3) {
        _textLabel3 = [[UILabel alloc]init];
        _textLabel3.numberOfLines = 0;
        _textLabel3.layer.borderWidth = 1;
        _textLabel3.layer.borderColor = UIColor.redColor.CGColor;
    }
    return _textLabel3;
}

- (NSMutableAttributedString *) getAttribute: (NSString *)normalStr andHighligh:(NSArray <NSString *> *)highlighs {
    
    normalStr = [normalStr stringByReplacingOccurrencesOfString:@"<BR>" withString:@"\n"];
    
    BaseAttributedStrHandler *handler =
    BaseAttributedStrHandler
    .handle(normalStr)
    .setUpColor(RGBHEX(0x333333))
    .setUpFont(BaseFont.fontSCR(12));
    
    
    NSArray <AttributedStrFiltrateRuler *>*array = [handler.str filtrates:[self createRulersWithSpecials:highlighs]];
    
    for (AttributedStrFiltrateRuler *ruler in array) {
        
        [ruler.resultRangeArray enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [handler setupInRange:obj.rangeValue andCallBack:^(BaseAttributedStrHandler *attributedStr) {
                __block BaseAttributedStrHandler *handlerHighligh = BaseAttributedStrHandler.handle(@"");
                [attributedStr.str.string enumerateSubstringsInRange:NSMakeRange(0, attributedStr.str.string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                    BaseAttributedStrHandler *lineHandler = BaseAttributedStrHandler.handle(substring);
                    if (lineHandler.isPureInt || lineHandler.isPureFloat) {
                        lineHandler.setUpFont(BaseFont.fontSCL(12));
                    }else{
                        lineHandler.setUpFont(BaseFont.fontSCB(12));
                    }
                    handlerHighligh.append(lineHandler);
                }];

                handlerHighligh.setUpColor(RGBHEX(0xFF544B));
                attributedStr.str = handlerHighligh.str;
            }];
        }];
    }
    
    handler
    .setUpStyleHandler(
                       BaseParagraphStyleHandler
                       .handler()
                       .setUpLineSpacing(10)
                       );
    return handler.str;
}


- (NSArray <AttributedStrFiltrateRuler *>*) createRulersWithSpecials:(NSArray <NSString *>*)specials {
    NSMutableArray <AttributedStrFiltrateRuler *>*array = [NSMutableArray new];
    [specials enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AttributedStrFiltrateRuler *ruler = [AttributedStrFiltrateRuler new];
        ruler.expressionString = obj;
        ruler.color = RGBHEX(0xFF544B);
        [array addObject:ruler];
    }];
    return array;
}




@end
