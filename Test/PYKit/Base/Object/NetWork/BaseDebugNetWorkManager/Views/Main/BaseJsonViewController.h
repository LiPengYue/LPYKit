//
//  BaseJsonViewController.h
//  PYkit
//
//  Created by 衣二三 on 2019/7/1.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BaseViewController.h"
#import "BasePresentViewController.h"
#import "BaseAnimaterHeaders.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseJsonViewController : BaseViewController

- (void) reloadDataWithID: (id)data;

- (NSString *) conversionToStr;

- (NSDictionary *) conversionToDic;

- (void) prisentWithOriginFrame: (CGRect) frame andImage: (UIImage *)image;

@end

NS_ASSUME_NONNULL_END
