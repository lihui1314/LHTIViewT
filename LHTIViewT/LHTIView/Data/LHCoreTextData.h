//
//  LHCoreTextData.h
//  LHTIViewT
//
//  Created by 李辉 on 2018/12/13.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "LHImageData.h"
@interface LHCoreTextData : NSObject
@property(nonatomic,strong)NSMutableAttributedString * mutaAttStr;
@property(nonatomic,strong)NSMutableArray*imageDataArray;
@property(nonatomic,assign)CGFloat height;

@property(nonatomic,assign)CTFrameRef ctFrame;
-(instancetype)initWithWidth:(CGFloat)width;
-(void)lh_ctframeParserWithFixedHight:(CGFloat)height;
@end
