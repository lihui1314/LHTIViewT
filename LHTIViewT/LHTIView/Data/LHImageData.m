//
//  LHImageData.m
//  LHTIViewT
//
//  Created by 李辉 on 2018/12/13.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHImageData.h"
#import "UIImage+Attach.h"

@implementation LHImageData{
    NSDictionary* _attDic;
    CGFloat _viewWidth;
}

-(instancetype)initWithAttributes:(NSDictionary *)attDic viewWidth:(CGFloat)width{
    self = [super init];
    _attDic = attDic;
    _viewWidth = width;
    return self;
}

-(void)setImage:(UIImage *)image{
    _image = image;
    self.imageAttStr = [image attachStrAndAttributes:_attDic viewWidth:_viewWidth];
}
@end
