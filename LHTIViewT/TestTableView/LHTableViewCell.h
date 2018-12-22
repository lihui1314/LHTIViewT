//
//  LHTableViewCell.h
//  LHTIViewT
//
//  Created by 李辉 on 2018/12/20.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHTIView.h"
#import "LHTestTableViewTextLayout.h"

@protocol LHTableViewCellDelegate <NSObject>

-(void)lh_didSeletedImage:(UIImage*)image imageInfo:(NSDictionary*)imageInfo;
-(void)lh_didSeletedText:(NSRange)range inserText:(NSString*)inerText textInfo:(NSDictionary*)textInfo;

@end

@interface LHTableViewCell : UITableViewCell
@property(nonatomic,strong) LHTIView* displayView;
@property(nonatomic,strong)LHTestTableViewTextLayout*layout;
@property(nonatomic,weak)id<LHTableViewCellDelegate>delegate;
@end
