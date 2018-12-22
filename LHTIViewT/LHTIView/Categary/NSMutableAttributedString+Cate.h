//
//  NSMutableAttributedString+Cate.h
//  LHTIViewT
//
//  Created by 李辉 on 2018/12/15.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHHighlight.h"
@interface NSMutableAttributedString (Cate)
-(void)lh_setHighlight:(LHHighlight*)hightlight andRange:(NSRange)range;
-(LHHighlight*)lh_getHighlightWithLoctionIndex:(NSInteger)index andRange:(NSRangePointer)range;
@end
