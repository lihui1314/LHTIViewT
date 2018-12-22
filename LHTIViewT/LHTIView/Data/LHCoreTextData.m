//
//  LHCoreTextData.m
//  LHTIViewT
//
//  Created by 李辉 on 2018/12/13.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHCoreTextData.h"
@implementation LHCoreTextData{
    CGFloat _width;
    BOOL _havePraser; //是否解析过
    NSMutableAttributedString *_previousMuteStr;//前一个str
}
-(instancetype)initWithWidth:(CGFloat)width{
    self = [super init];
    _imageDataArray = [NSMutableArray array];
    _width = width;
    return self;
}
-(void)setImageDataArray:(NSMutableArray *)imageDataArray{
    _imageDataArray = imageDataArray;
    
//    [self lh_ctf];
//    [self lh_calculateImagePosition];
}
-(void)setMuteAttStr:(NSMutableAttributedString *)muteAttStr{
    _muteAttStr = muteAttStr;
//    [self lh_ctf];
}
-(void)lh_ctf{
    if (!_muteAttStr) {
        return;
    }
    CGFloat h = [self sizeLabelToFit:self.muteAttStr width:_width height:MAXFLOAT];
    self.height = h;
    //绘制区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, _width  , h));
    
    //设置CTFram
    CTFramesetterRef ctFrameSetting = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.muteAttStr);
    CTFrameRef ctframe = CTFramesetterCreateFrame(ctFrameSetting, CFRangeMake(0, 0), path, NULL);
    self.ctFrame = ctframe;
    
    //
    CFRelease(path);
    CFRelease(ctFrameSetting);
    CFRelease(ctframe);
}

//高度计算
-(CGFloat)sizeLabelToFit:(NSAttributedString *)aString width:(CGFloat)width height:(CGFloat)height {
    CTFramesetterRef ctFrameSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)aString);
    //获取要绘制的区域信息
    CGSize restrictSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(ctFrameSetterRef, CFRangeMake(0, 0), NULL, restrictSize, NULL);
    CGFloat textHeight = coreTextSize.height;
    return textHeight;
    
}

//图片位置
-(void)lh_calculateImagePosition{
    NSInteger index = 0;
    if (_imageDataArray.count>0) {
      NSArray* linesArray = (NSArray*) CTFrameGetLines(self.ctFrame);
        CGPoint linesOrigins[linesArray.count];
        CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), linesOrigins);
        for (int i = 0; i<linesArray.count; i++) {
            CTLineRef line = (__bridge CTLineRef)linesArray[i];
            NSArray*runs = (NSArray*)CTLineGetGlyphRuns(line);
            for (int j = 0; j<runs.count; j++) {
                CTRunRef run =(__bridge CTRunRef) runs[j];
                NSDictionary*attributes = (NSDictionary*)CTRunGetAttributes(run);
                if (!attributes) {
                    continue;
                }
                //取出runDelegate;
                CTRunDelegateRef delegateRef = (__bridge CTRunDelegateRef)[attributes valueForKey:(id)kCTRunDelegateAttributeName];
                
                if (!delegateRef) {
                    continue;
                }
                NSDictionary*imageSizeDic = (NSDictionary*)CTRunDelegateGetRefCon(delegateRef);
                
                if (!imageSizeDic) {
                    continue;
                }
                //开始计算
                CGFloat ascent;
                CGFloat decent;
                CGFloat width;
                width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &decent, NULL);
                
                CGFloat xOffset =linesOrigins[i].x+ CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                CGFloat yOffset = linesOrigins[i].y;
                LHImageData*imageData = _imageDataArray[index];
                imageData.position = CGRectMake(xOffset, yOffset, width, decent+ascent);
                index ++;
                
                if (index == _imageDataArray.count) {
                    return;
                }
            }
            
        }
    }
}

-(void)setCtFrame:(CTFrameRef)ctFrame{
    if (_ctFrame != nil && _ctFrame != ctFrame) {
        CFRelease(_ctFrame);
    }
    CFRetain(ctFrame);
    _ctFrame = ctFrame;
}

/**
 解析成CTFrame并计算图片位置。
 */
-(void)lh_ctframeParser{
    if (_previousMuteStr != _muteAttStr||(_previousMuteStr.length!=_muteAttStr.length)) {
        _havePraser = NO;
    }
    if (_havePraser==YES ) {
        return;
    }
    if (self.muteAttStr) {
        for (int i = 0; i<_imageDataArray.count; i++) {
            LHImageData*imageData = _imageDataArray[i];
            [self.muteAttStr insertAttributedString:imageData.imageAttStr atIndex:imageData.loction];
        }
    }
    [self lh_ctf];
    if (_imageDataArray.count>0) {
        [self lh_calculateImagePosition];
    }
    _havePraser = YES;
    _previousMuteStr = _muteAttStr;
}

@end
