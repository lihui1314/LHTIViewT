//
//  LHTextLayout.h
//  LHTIViewT
//
//  Created by 李辉 on 2018/12/20.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHCoreTextData.h"
#import "LHImageData.h"
#import "LHHighlight.h"
#import "LHTestTableViewTextModel.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define SCreenHeight [UIScreen mainScreen].bounds.size.height
#define CellPadding 15
#define LHTWidth (ScreenWidth - CellPadding*2)
@protocol LHTestTableViewTextLayoutDelegate <NSObject>

-(void)lh_layout_didTouch:(NSRange)range inerText:(NSString*)inerText userInfo:(NSDictionary*)userInfo;

@end
@interface LHTestTableViewTextLayout : NSObject
@property(nonatomic,strong)LHCoreTextData*textData;
@property(nonatomic,assign)CGFloat cellHeight;
@property(nonatomic,strong)LHTestTableViewTextModel* model;
@property(nonatomic,weak)id<LHTestTableViewTextLayoutDelegate>delegate;

@end
