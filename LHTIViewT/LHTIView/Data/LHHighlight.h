//
//  LHHighlight.h
//  LHTIViewT
//
//  Created by 李辉 on 2018/12/15.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^LHtapActionBlock)(NSRange rang,NSString* inerText,id userInfo);
@interface LHHighlight : NSObject
@property(nonatomic,copy)LHtapActionBlock tapAction;
@property(nonatomic,strong)NSDictionary*userInfo;
@property(nonatomic,strong)UIColor *tapBackgroundColor;
@end
