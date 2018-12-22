//
//  LHImageData.h
//  LHTIViewT
//
//  Created by 李辉 on 2018/12/13.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LHImageData : NSObject
@property(nonatomic,strong)UIImage*image;
@property(nonatomic,assign)NSInteger loction;
@property(nonatomic,assign)CGRect position;
@property(nonatomic,strong)NSAttributedString* imageAttStr;
@property(nonatomic,strong)NSDictionary*imageInfo;

-(instancetype)initWithAttributes:(NSDictionary*)attDic viewWidth:(CGFloat)width;
@end
