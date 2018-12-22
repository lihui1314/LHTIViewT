//
//  NSMutableAttributedString+Cate.m
//  LHTIViewT
//
//  Created by 李辉 on 2018/12/15.
//  Copyright © 2018年 李辉. All rights reserved.
//
#import "LHHighlight.h"
#import "NSMutableAttributedString+Cate.h"
 NSString* const LHHighlightAttributedName = @"LHHighlight";
@implementation NSMutableAttributedString (Cate)

-(void)lh_setHighlight:(LHHighlight *)hightlight andRange:(NSRange)range{
    [self addAttribute:LHHighlightAttributedName value:hightlight range:range];
}
-(LHHighlight*)lh_getHighlightWithLoctionIndex:(NSInteger)index andRange:(NSRangePointer)range{
    NSRange  highlightRange = {0};
   LHHighlight*highlight= [self attribute:LHHighlightAttributedName atIndex:index longestEffectiveRange:&highlightRange inRange:NSMakeRange(0, self.length)];
    *range = highlightRange;
    return highlight;

}

@end
