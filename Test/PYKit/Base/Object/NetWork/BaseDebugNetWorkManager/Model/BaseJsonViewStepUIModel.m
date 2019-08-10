//
//  BaseJsonViewManager.h
//  PYKit
//
//  Created by 李鹏跃 on 2019/9/11.
//  Copyright © 2019年 13lipengyue. All rights reserved.
//


#import "BaseJsonViewStepUIModel.h"
#import "BaseJsonViewStepModel.h"
#import "BaseJsonViewCommon.h"


@interface BaseJsonViewStepUIModel ()

@end

@implementation BaseJsonViewStepUIModel

+ (NSAttributedString *(^)(BaseJsonViewStepModel *))getTreeLayerAttriStrWithModel {
    return ^(BaseJsonViewStepModel *model) {
        return [self getTreeLayerAttriStrWithStepModel:model];
    };
}

+ (NSAttributedString *)getTreeLayerAttriStrWithStepModel: (BaseJsonViewStepModel *)model {
    NSMutableArray <BaseJsonViewStepModel *>*arrayM = [NSMutableArray new];
    
    BaseJsonViewStepModel *modelTemp = model;
    
    while (1) {
        [arrayM addObject:modelTemp];
        if (modelTemp.superPoint == nil) {
            break;
        }
        modelTemp = modelTemp.superPoint;
    }
    
    BaseAttributedStrHandler*handler = BaseAttributedStrHandler.handle(@"");
    for (NSInteger i = arrayM.count-1; i >= 0; i--) {
        BaseJsonViewStepModel *model = arrayM[i];
        if(model.superPoint) {
            //            handler.addObjc(@"→");
            handler.append(
                           BaseAttributedStrHandler
                           .handle(@"→")
                           );
        }
        switch (model.type) {
                
            case BaseJsonViewStepModelType_Dictionary: {
                NSString *key = model.key;
                if (key.length <= 0) {
                    key = @"obj";
                }
                
                key =
                BaseStringHandler
                .handler(key)
                .addObjc(@"{")
                .addInt(model.count)
                .addObjc(@"}")
                .getStr;
                
                handler
                .append(
                        BaseAttributedStrHandler
                        .handle(key)
                        );
                handler
                .setUpColor(normalColor);
            }
                break;
            case BaseJsonViewStepModelType_Array: {
                NSString *key = model.key;
                if (key.length <= 0) {
                    key = @"array";
                }
                key =
                BaseStringHandler
                .handler(key)
                .addObjc(@"[")
                .addInt(model.count)
                .addObjc(@"]")
                .getStr;
                
                handler
                .append(
                        BaseAttributedStrHandler
                        .handle(key)
                        );
                
                handler
                .setUpColor(normalColor);
            }
                break;
            case BaseJsonViewStepModelType_Number:
            case BaseJsonViewStepModelType_String:
                handler
                .append(
                        BaseAttributedStrHandler
                        .handle(BaseStringHandler.handler(@"\n").addObjc(model.key))
                        .setUpColor(searchResultCellKeyColor)
                        )
                .append(
                        BaseAttributedStrHandler
                        .handle(@":")
                        .setUpColor(normalColor)
                        )
                .append(
                        BaseAttributedStrHandler
                        .handle(model.data)
                        .setUpColor(BaseJsonViewStepModelType_Number == model.type ? numberColor : stringColor)
                        );
                break;
        }
    }
    handler.setUpFont(BaseFont.fontSCR(12));
    return handler.str;
}


+ (NSString *(^)(BaseJsonViewStepModel *))getTreeLayerStringWithModel {
    return ^(BaseJsonViewStepModel *model) {
        return [self getTreeLayerStringWithStepModel:model];
    };
}

+ (NSString *) getTreeLayerStringWithStepModel: (BaseJsonViewStepModel *) model{
    NSMutableArray <BaseJsonViewStepModel *>*arrayM = [NSMutableArray new];
    
    BaseJsonViewStepModel *modelTemp = model;
    
    while (1) {
        [arrayM addObject:modelTemp];
        if (modelTemp.superPoint == nil) {
            break;
        }
        modelTemp = modelTemp.superPoint;
    }
    
    BaseStringHandler *handler = BaseStringHandler.handler(@"");
    for (NSInteger i = arrayM.count-1; i >= 0; i--) {
        BaseJsonViewStepModel *model = arrayM[i];
        if(model.superPoint) {
            handler.addObjc(@"→");
        }
        switch (model.type) {
                
            case BaseJsonViewStepModelType_Dictionary: {
                NSString *key = model.key;
                if (key.length <= 0) {
                    key = @"obj";
                }
                handler
                .addObjc(key)
                .setDefaultIfNull(@"obj")
                .addObjc(@"{")
                .addInt(model.count)
                .addObjc(@"}");
            }
                break;
            case BaseJsonViewStepModelType_Array: {
                NSString *key = model.key;
                if (key.length <= 0) {
                    key = @"obj";
                }
                handler
                .addObjc(key)
                .setDefaultIfNull(@"arr")
                .addObjc(@"[")
                .addInt(model.count)
                .addObjc(@"]");
            }
                break;
            case BaseJsonViewStepModelType_Number:
            case BaseJsonViewStepModelType_String:
                handler
                .addObjc(model.key)
                .addObjc(@":")
                .addObjc(model.data);
                break;
        }
    }
    return handler.getStr;
}


+ (NSString *(^)(BaseJsonViewStepModel *))getSuperPointKeyWithModel {
    return ^(BaseJsonViewStepModel *model) {
        BaseJsonViewStepModel *modelTemp = model.superPoint;
        
        NSString *key = @"";
        while (1) {
            key = modelTemp.key;
            if (key.length > 0 || modelTemp.superPoint == nil) {
                break;
            }
            modelTemp = modelTemp.superPoint;
        }
        return key;
    };
}
@end
