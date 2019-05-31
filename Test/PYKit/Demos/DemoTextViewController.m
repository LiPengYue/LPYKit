    //
//  DemoTextViewController.m
//  PYkit
//
//  Created by 衣二三 on 2019/5/28.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "DemoTextViewController.h"
#import "BaseStringHandler.h"

@interface DemoTextViewController ()
/// textView
@property (nonatomic,strong) UITextView *textView;
@end

@implementation DemoTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.textView];
    self.textView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    self.textView.text = self.demoStr;
}
- (void) setDemoStr:(NSString *)demoStr {
    if ([demoStr isEqualToString:_demoStr]) {
        return;
    }
    _demoStr = [demoStr stringByReplacingOccurrencesOfString:@"$" withString:@"\n"];
    
    self.textView.text = self.demoStr;
}


- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]init];
    }
    return _textView;
}

@end
