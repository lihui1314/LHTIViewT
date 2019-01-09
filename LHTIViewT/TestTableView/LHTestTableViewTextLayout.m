//
//  LHTextLayout.m
//  LHTIViewT
//
//  Created by 李辉 on 2018/12/20.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHTestTableViewTextLayout.h"
#import "NSMutableAttributedString+Cate.h"
@implementation LHTestTableViewTextLayout
-(void)setModel:(LHTestTableViewTextModel *)model{
    _model = model;
    NSMutableParagraphStyle *sty = [[NSMutableParagraphStyle alloc]init];
    sty.lineSpacing = 10;
    sty.alignment = NSTextAlignmentLeft;
//    sty.lineBreakMode = NSLineBreakByTruncatingMiddle;
    UIFont *font = [UIFont fontWithName:@"ArialMT" size:16];
    NSDictionary*atts = @{NSParagraphStyleAttributeName:sty,
                          NSFontAttributeName:font,
                          };
    NSMutableAttributedString *muteStr  = [[NSMutableAttributedString alloc]initWithString:model.text attributes:atts];
    __weak typeof(self)wek = self;
    LHHighlight*hightlight = [[LHHighlight alloc]init];
    hightlight.tapBackgroundColor = [UIColor lightGrayColor];
    hightlight.userInfo = @{@"name":@"{3,24}"};
    hightlight.tapAction = ^(NSRange rang, NSString *inerText,id userInfo) {
        if ([wek.delegate respondsToSelector:@selector(lh_layout_didTouch:inerText:userInfo:)]) {
            [wek.delegate lh_layout_didTouch:rang inerText:inerText userInfo:userInfo];
        }
    };
    [muteStr lh_setHighlight:hightlight andRange:NSMakeRange(3, 24)];
    [muteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(3, 24)];
    
    self.textData.mutaAttStr = muteStr;
    for (int i =0; i<model.imageInfoArray.count; i++) {
        NSDictionary*imageInfo = model.imageInfoArray[i];
        UIImage*imge = [UIImage imageNamed:imageInfo[@"name"]];
        LHImageData *imageData = [[LHImageData alloc]initWithAttributes:atts viewWidth:LHTWidth];
        imageData.image = imge;
        imageData.imageInfo = @{@"name":imageInfo[@"name"]};
        imageData.loction = [imageInfo[@"loction"] integerValue];
        [self.textData.imageDataArray addObject:imageData];
    }
    [self.textData lh_ctframeParserWithFixedHight:0];//解析
    self.cellHeight = self.textData.height;
    
}

-(LHCoreTextData*)textData{
    if (!_textData) {
        _textData = [[LHCoreTextData alloc]initWithWidth:LHTWidth];
    }
    return _textData;
}

@end
