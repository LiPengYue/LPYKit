//
//  DebugNetWorkViewController.h
//  Test
//
//  Created by 衣二三 on 2019/3/27.
//  Copyright © 2019年 衣二三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseJsonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DebugNetWorkViewController : BaseJsonViewController
- (void) setJson: (NSString *) json withURL: (NSString *)url;
@end

NS_ASSUME_NONNULL_END
