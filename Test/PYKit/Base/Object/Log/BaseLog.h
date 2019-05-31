//
//  BaseLog.h
//  Test
//
//  Created by 衣二三 on 2019/4/15.
//  Copyright © 2019 衣二三. All rights reserved.
//

#ifndef BaseLog_h
#define BaseLog_h

#ifdef DEBUG
#define DLog(...) NSLog(@"%s\n %@\n\n", __func__, [NSString stringWithFormat:__VA_ARGS__])
#else
#endif

#endif /* BaseLog_h */
