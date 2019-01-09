//
//  LHTIView.m
//  LHTIViewT
//
//  Created by 李辉 on 2018/12/11.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHTIView.h"
#import <CoreText/CoreText.h>
static NSString* const LHTruncationReplacementChar = @"\u2026";
#define MinDurationTime 0.1f
@implementation LHTIView{
    LHHighlight *_highlight;
    LHImageData *_imageData;
    NSRange _highlightRange;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    return self;
}
-(void)setCoreTextData:(LHCoreTextData *)coreTextData{
    [coreTextData lh_ctframeParserWithFixedHight:self.frame.size.height];//解析
    _coreTextData = coreTextData;
    if (self.frame.size.height==0) {
          self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.coreTextData.height);
    }else{
        [self setNeedsDisplay];
    }
}

-(void)setNumberOfLines:(NSInteger)numberOfLines{
    _numberOfLines = numberOfLines;
    [self setNeedsDisplay];
}
-(void)drawRect:(CGRect)rect{
//    NSLog(@"2222222222222");
    //上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //坐标转化
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
     [self lh_drawHighlightWithRect:rect];
     [self lh_drawCoreText:context];
   
    
}

-(void)lh_drawCoreText:(CGContextRef)context{
    CFRange lastLineRange = CFRangeMake(0, 0);
    if (_numberOfLines>0) {
        CFArrayRef lines = CTFrameGetLines(self.coreTextData.ctFrame);
        NSInteger numberOfLines = _numberOfLines > 0 ? MIN(CFArrayGetCount(lines), _numberOfLines) : CFArrayGetCount(lines);
        CGPoint lineOrigins[numberOfLines];
        CTFrameGetLineOrigins(self.coreTextData.ctFrame, CFRangeMake(0, 0), lineOrigins);
        for (CFIndex index = 0; index<numberOfLines; index++) {
            CGPoint originPoint = lineOrigins[index];
            CGContextSetTextPosition(context, originPoint.x, originPoint.y);
            CTLineRef line = CFArrayGetValueAtIndex(lines, index);
            BOOL shouldDrawLine = YES;
            
            if (index == numberOfLines-1) {
                lastLineRange = CTLineGetStringRange(line);
                if (lastLineRange.location+lastLineRange.length<self.coreTextData.mutaAttStr.length) {
                    CTLineTruncationType lineTrunCationtype = kCTLineTruncationEnd;
                    NSInteger truncationAttributePosition = lastLineRange.location+lastLineRange.length-1;
                    NSDictionary*attsDic = [self.coreTextData.mutaAttStr attributesAtIndex:truncationAttributePosition effectiveRange:NULL];
                    
                    NSAttributedString *tokenString = [[NSAttributedString alloc]initWithString:LHTruncationReplacementChar attributes:attsDic];
                    CTLineRef truncationToken = CTLineCreateWithAttributedString((CFAttributedStringRef)tokenString);
                    
                    NSMutableAttributedString *trunCationSting = [[self.coreTextData.mutaAttStr attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)] mutableCopy];
                    if (lastLineRange.length>0) {
                        [trunCationSting deleteCharactersInRange:NSMakeRange(lastLineRange.length-1, 1)];
                    }
                    [trunCationSting appendAttributedString:tokenString];
                    CTLineRef truncationLine = CTLineCreateWithAttributedString((CFAttributedStringRef)trunCationSting);
                    
                    CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, self.frame.size.width, lineTrunCationtype, truncationToken);
                    CFRelease(truncationLine);
                    CFRelease(truncationToken);
                    CTLineDraw(truncatedLine, context);
                    CFRelease(truncatedLine);
                    shouldDrawLine = NO;
                }
            }
            if (shouldDrawLine) {
                CTLineDraw(line, context);
            }
        }
        
    }else{
         CTFrameDraw(self.coreTextData.ctFrame, context);
    }
    if (self.coreTextData.imageDataArray.count>0) {
        for (LHImageData*imageData in self.coreTextData.imageDataArray) {
            if (lastLineRange.location&&lastLineRange.length>0) {
                if (imageData.loction<(lastLineRange.location+lastLineRange.length)) {
                      CGContextDrawImage(context, imageData.position, imageData.image.CGImage);
                }
            }else{
                CGContextDrawImage(context, imageData.position, imageData.image.CGImage);
            }
        }
    }
}

-(void)lh_normDraw{
    //上下文
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //坐标转化
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//    CGContextTranslateCTM(context, 0, self.bounds.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    
//    //绘制区域
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
//    
//    //设置CTFram
//    CTFramesetterRef ctFrameSetting = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attStr);
//    CTFrameRef ctframe = CTFramesetterCreateFrame(ctFrameSetting, CFRangeMake(0, self.attStr.length), path, NULL);
//    //在CTFrame中绘制文本。
//    CTFrameDraw(ctframe, context);
//    
//    //释放变量
//    CFRelease(path);
//    CFRelease(ctFrameSetting);
//    CFRelease(ctframe);
}
//
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //坐标转换
    CGPoint relPoint = CGPointMake(point.x, self.bounds.size.height-point.y);
    if (self.coreTextData.imageDataArray.count>0) {
        for (LHImageData*imageData in self.coreTextData.imageDataArray) {
            if (CGRectContainsPoint(imageData.position, relPoint)) {
                _imageData = imageData;
                return;
            }
        }
    }
    
   CFIndex index =  [self lh_touchIndex:point];
    
    if (index <0) {
        return;
    }
    
    NSRange highlightRange;
    _highlight = [self.coreTextData.mutaAttStr lh_getHighlightWithLoctionIndex:index andRange:&highlightRange];
    _highlightRange = highlightRange;
//    NSLog(@"index->%ld",index);
    if (_highlight.tapBackgroundColor) {
        [self setNeedsDisplay];
    }
//    NSLog(@"1111111111");
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"33333333333");
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
      //坐标转换
    CGPoint relPoint = CGPointMake(point.x, self.bounds.size.height-point.y);
    if (self.coreTextData.imageDataArray.count>0) {
        for (LHImageData*imageData in self.coreTextData.imageDataArray) {
            if (CGRectContainsPoint(imageData.position, relPoint)) {
                if (imageData == _imageData) {
                    if ([self.delegate respondsToSelector:@selector(lh_didClickImage:info:)]) {
                        [self.delegate lh_didClickImage:_imageData.image info:_imageData.imageInfo];
                         return;
                    }
                }
               
            }
        }
    }
    
    if (_highlight) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MinDurationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_highlight.tapBackgroundColor) {
                  [self setNeedsDisplay];
            }
            _highlight = nil;
        });
        
    }
   
    CFIndex index =  [self lh_touchIndex:point];
    
    if (index <0) {
        return;
    }
    
    NSRange highlightRange;
    LHHighlight*high = [self.coreTextData.mutaAttStr lh_getHighlightWithLoctionIndex:index andRange:&highlightRange];
    if (high!=_highlight) {
        return;
    }
    if (_highlight) {
        _highlight.tapAction(highlightRange,  self.coreTextData.mutaAttStr.string,_highlight.userInfo);
    }
        _imageData = nil;
    
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_highlight.tapBackgroundColor) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MinDurationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
            _highlight = nil;
        });
        
    }
    _imageData = nil;
}
-(CFIndex)lh_touchIndex:(CGPoint)point{
    CFIndex index = kCFNotFound;
    CFArrayRef lines = CTFrameGetLines(self.coreTextData.ctFrame);
    if (lines ==nil) {
        return index;
    }
    CFIndex linsCont = CFArrayGetCount(lines);
    CGPoint lineOrigins[linsCont];
    CTFrameGetLineOrigins(self.coreTextData.ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    //坐标转换
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, self.frame.size.height);
    transform = CGAffineTransformScale(transform, 1, -1);
    
    for (int i =0; i<linsCont; i++) {
        CGPoint originsPoint = lineOrigins[i];
//        NSLog(@"originsPoint.y->%f",originsPoint.y);
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CGFloat ascent = 0;
        CGFloat descent = 0;
        CGFloat leading = 0;
        CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
//        NSLog(@"ascent+descent->%f",ascent+descent);
        CGRect lineRect = CGRectMake(originsPoint.x, originsPoint.y-descent, width, ascent+descent);
        //转化成UIKit的坐标
        CGRect uiRect = CGRectApplyAffineTransform(lineRect, transform);
        
        if (CGRectContainsPoint(uiRect, point)) {
            //获取点击点相对于line的位置 -10为矫正 
            CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(uiRect)-10, point.y-CGRectGetMinY(uiRect));
            index = CTLineGetStringIndexForPosition(line, relativePoint);
            break;
        }
        
        
    }
    return index;
    
}

/**
 绘制高亮背景

 @param rect rect
 */
-(void)lh_drawHighlightWithRect:(CGRect)rect{
    if (_highlight&&_highlight.tapBackgroundColor) {
        [_highlight.tapBackgroundColor setFill];
        NSRange hightlightRange = _highlightRange;
        CFArrayRef lines = CTFrameGetLines(self.coreTextData.ctFrame);
        NSInteger numberOfLines = CFArrayGetCount(lines);
        
        CGPoint lineOrigins[numberOfLines];
        CTFrameGetLineOrigins(self.coreTextData.ctFrame, CFRangeMake(0, 0), lineOrigins);
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        for (int i = 0; i<numberOfLines; i++) {
            CTLineRef line = CFArrayGetValueAtIndex(lines, i);
            CFRange lineRange = CTLineGetStringRange(line);
            NSRange lineRangeL = NSMakeRange(lineRange.location, lineRange.length);
            NSRange intersectedRange = NSIntersectionRange(lineRangeL, _highlightRange);
            
            if (intersectedRange.length==0) {
                continue;
            }
            CGRect highlightRect = [self lh_rectForRangeInLine:line highlightRange:_highlightRange lineOrigin:lineOrigins[i]];
             highlightRect = CGRectOffset(highlightRect, 0, -rect.origin.y);
            if (!CGRectIsEmpty(highlightRect))
            {
                CGFloat pi = (CGFloat)M_PI;
                
                CGFloat radius = 1.0f;
                CGContextMoveToPoint(ctx, highlightRect.origin.x, highlightRect.origin.y + radius);
                CGContextAddLineToPoint(ctx, highlightRect.origin.x, highlightRect.origin.y + highlightRect.size.height - radius);
                CGContextAddArc(ctx, highlightRect.origin.x + radius, highlightRect.origin.y + highlightRect.size.height - radius,
                                radius, pi, pi / 2.0f, 1.0f);
                CGContextAddLineToPoint(ctx, highlightRect.origin.x + highlightRect.size.width - radius,
                                        highlightRect.origin.y + highlightRect.size.height);
                CGContextAddArc(ctx, highlightRect.origin.x + highlightRect.size.width - radius,
                                highlightRect.origin.y + highlightRect.size.height - radius, radius, pi / 2, 0.0f, 1.0f);
                CGContextAddLineToPoint(ctx, highlightRect.origin.x + highlightRect.size.width, highlightRect.origin.y + radius);
                CGContextAddArc(ctx, highlightRect.origin.x + highlightRect.size.width - radius, highlightRect.origin.y + radius,
                                radius, 0.0f, -pi / 2.0f, 1.0f);
                CGContextAddLineToPoint(ctx, highlightRect.origin.x + radius, highlightRect.origin.y);
                CGContextAddArc(ctx, highlightRect.origin.x + radius, highlightRect.origin.y + radius, radius,
                                -pi / 2, pi, 1);
                CGContextFillPath(ctx);
            }
            
        }
        
    }
}


/**
 line中的run的rect

 @param line line
 @param highlightRange 高亮范围
 @param lineOrigin 起点
 @return rect
 */
-(CGRect)lh_rectForRangeInLine:(CTLineRef)line highlightRange:(NSRange)highlightRange lineOrigin:(CGPoint)lineOrigin{
    CGRect highlightRect = CGRectZero;
    
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    CFIndex lineCont = CFArrayGetCount(runs);
    
    for (CFIndex i = 0; i<lineCont; i++) {
        CTRunRef run = CFArrayGetValueAtIndex(runs, i);
        CFRange runRane = CTRunGetStringRange(run);
        NSRange runRangeR = NSMakeRange(runRane.location, runRane.length);
        NSRange intersectionRange = NSIntersectionRange(runRangeR, highlightRange);
        if (intersectionRange.length==0) {
            continue;
        }
        CGFloat ascent,descent,width,leading;
        width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading);
        CGFloat hight = ascent + descent;
        CGFloat offset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
        CGRect hRect = CGRectMake(lineOrigin.x+offset, lineOrigin.y-descent, width, hight);
        highlightRect = CGRectIsEmpty(highlightRect) ? hRect : CGRectUnion(highlightRect, hRect);
    }
    return highlightRect;
}

-(void)dealloc{
    CFRelease(self.coreTextData.ctFrame);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
