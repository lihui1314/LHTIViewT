//
//  LHbaseTool.m
//  LHTIViewT
//
//  Created by 李辉 on 2019/1/8.
//  Copyright © 2019年 李辉. All rights reserved.
//

#import "LHbaseTool.h"
#import <CoreText/CoreText.h>
@implementation LHbaseTool
+(CGFloat)sizeLabelToFit:(NSAttributedString *)aString width:(CGFloat)width height:(CGFloat)height {
    CTFramesetterRef ctFrameSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)aString);
    //获取要绘制的区域信息
    CGSize restrictSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(ctFrameSetterRef, CFRangeMake(0, 0), NULL, restrictSize, NULL);
    CGFloat textHeight = coreTextSize.height;
    return textHeight;
    
}
@end
