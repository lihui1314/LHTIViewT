//
//  LHTIView.h
//  LHTIViewT
//
//  Created by 李辉 on 2018/12/11.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHCoreTextData.h"
#import "LHHighlight.h"
#import "NSMutableAttributedString+Cate.h"
@protocol LHTIViewDelegate <NSObject>

-(void)lh_didClickImage:(UIImage*)image info:(id)info;

@end
@interface LHTIView : UIView
//@property(nonatomic,strong)NSMutableAttributedString* attStr;
@property(nonatomic,strong)LHCoreTextData*coreTextData;
@property(nonatomic,weak)id<LHTIViewDelegate>delegate;
@property(nonatomic,assign)NSInteger numberOfLines;
@end
