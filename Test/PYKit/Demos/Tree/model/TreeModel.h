//
//  TreeModel.h
//  PYkit
//
//  Created by 衣二三 on 2019/5/29.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TreeModel : NSObject
@property (nonatomic,strong) TreeModel *right;
@property (nonatomic,strong) TreeModel *left;
@property (nonatomic,strong) id data;

@end

NS_ASSUME_NONNULL_END
