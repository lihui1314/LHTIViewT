//
//  LHTableViewCell.m
//  LHTIViewT
//
//  Created by 李辉 on 2018/12/20.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHTableViewCell.h"
#import "LHTIView.h"
@interface LHTableViewCell ()<LHTestTableViewTextLayoutDelegate,LHTIViewDelegate>
@end
@implementation LHTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self lh_setUI];
   
    return self;
}

-(void)lh_setUI{
    LHTIView*v = [[LHTIView alloc]initWithFrame:CGRectMake(CellPadding, 0, LHTWidth, self.frame.size.height)];
    v.delegate  = self;
    _displayView = v;
}

-(void)setLayout:(LHTestTableViewTextLayout *)layout{
         _layout =layout;
        _layout.delegate = self;
         self.displayView.coreTextData = layout.textData;
         [self addSubview:_displayView];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)lh_layout_didTouch:(NSRange)range inerText:(NSString *)inerText userInfo:(NSDictionary *)userInfo{
    if ([self.delegate respondsToSelector:@selector(lh_didSeletedText:inserText:textInfo:)]) {
        [self.delegate lh_didSeletedText:range inserText:inerText textInfo:userInfo];
    }
}
-(void)lh_didClickImage:(UIImage *)image info:(id)info{
    if ([self.delegate respondsToSelector:@selector(lh_didSeletedImage:imageInfo:)]) {
        [self.delegate lh_didSeletedImage:image imageInfo:info];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
