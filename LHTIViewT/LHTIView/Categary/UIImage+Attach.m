//
//  UIImage+Attach.m
//  LHTIViewT
//
//  Created by 李辉 on 2018/12/12.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "UIImage+Attach.h"
#import <CoreText/CoreText.h>

static CGFloat getAscent(void* ref){
    float height = [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"height"] floatValue];
    return height;
}

static CGFloat getDescent(){
    return 0;
}
static CGFloat getWidth(void* ref){
    float width = [[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
    return width;
}

@implementation UIImage (Attach)
-(NSAttributedString*)attachStrAndAttributes:(NSDictionary *)attDic viewWidth:(CGFloat)width{
    CTRunDelegateCallbacks runDelegateCallbac;
    memset(&runDelegateCallbac, 0, sizeof(CTRunDelegateCallbacks));
    runDelegateCallbac.getAscent = getAscent;
    runDelegateCallbac.getDescent = getDescent;
    runDelegateCallbac.getWidth = getWidth;
    CGSize newSize = [self lh_returnNewSize:width];
    NSDictionary*dic = @{@"height":@(newSize.height),@"width":@(newSize.width)};
    CTRunDelegateRef runDelegateRef = CTRunDelegateCreate(&runDelegateCallbac, (__bridge_retained  void*)dic);
    //设置占位符
    unichar objectReplacementChar = 0xFFFC;
    NSMutableAttributedString*imagePlaceholder = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithCharacters:&objectReplacementChar length:1] attributes:attDic];
    
    //设置代理
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)imagePlaceholder, CFRangeMake(0, 1), kCTRunDelegateAttributeName, runDelegateRef);
    
    CFRelease(runDelegateRef);
   
    return imagePlaceholder;
}
-(CGSize)lh_returnNewSize:(CGFloat)widht {
    CGSize newSize;
    CGFloat w = widht;
    if (self.size.width >w &&widht>18) {
        newSize = CGSizeMake(w, self.size.height*(w/self.size.width));
        return newSize;
    }
    return self.size;
}
-(void)dealloc{
    
}
@end

