//
//  ViewController.m
//  LHTIViewT
//
//  Created by 李辉 on 2018/12/11.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "ViewController.h"
#import "LHTIView.h"
#import <CoreText/CoreText.h>
#import "UIImage+Attach.h"
#import "LHImageData.h"
#import "LHHighlight.h"
@interface ViewController ()<LHTIViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableAttributedString*muteAtt = [[NSMutableAttributedString alloc]initWithString:@"秋天，无论在什么地方的秋天，总是好的；可是啊，北国的秋，却特别地来得清，来得静，来得悲凉。我的不远千里，要从杭州赶上青岛，更要从青岛赶上北平来的理由，也不过想饱尝一尝这“秋”，这故都的秋味。\n江南，秋当然也是有的，但草木凋得慢，空气来得润，天的颜色显得淡，并且又时常多雨而少风；一个人夹在苏州上海杭州，或厦门香港广州的市民中间，混混沌沌地过去，只能感到一点点清凉，秋的味，秋的色，秋的意境与姿态，总看不饱，尝不透，赏玩不到十足。秋并不是名花，也并不是美酒，那一种半开、半醉的状态，在领略秋的过程上，是不合适的"];
    NSMutableParagraphStyle *sty = [[NSMutableParagraphStyle alloc]init];
    sty.lineSpacing = 10;
    sty.lineBreakMode = NSLineBreakByCharWrapping;
    sty.alignment = NSTextAlignmentLeft;
    
    CGFloat lineSpace = 30;
     CTFontRef ctFont = CTFontCreateWithName((CFStringRef)@"ArialMT", 17, NULL);
    CTParagraphStyleSetting theSettings[3] = {
        {
            kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpace
        },
        {
            kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpace
        },
        {
            kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpace
        }
    };
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, 3);
//    NSFont *f= [NSFont ]
    UIFont*f = [UIFont fontWithName:@"ArialMT" size:17];
    NSDictionary*dic = @{
                         NSParagraphStyleAttributeName:sty,
                         (id)kCTParagraphStyleAttributeName : (__bridge id)theParagraphRef,
//                         (id)kCTFontAttributeName : (__bridge id)ctFont,
                         NSFontAttributeName:f,
//                         NSForegroundColorAttributeName:[UIColor redColor],
                         
                         };
    [muteAtt setAttributes:dic range:NSMakeRange(0, muteAtt.length)];
    
    LHHighlight *highlight = [[LHHighlight alloc]init];
    highlight.userInfo = @{@"name":@"lihui"};
    highlight.tapAction = ^(NSRange rang, NSString *inerText, id userInfo) {
        
    };
    [muteAtt lh_setHighlight:highlight andRange:NSMakeRange(2, 6)];
    [muteAtt addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(2, 6)];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)muteAtt, CFRangeMake(22, 9), kCTBackgroundColorAttributeName, [UIColor grayColor].CGColor);
//    [muteAtt addAttribute:NSBackgroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(22, 100)];
    
    
    LHHighlight *highlight2 = [[LHHighlight alloc]init];
//    highlight2.tapBackgroundColor = [UIColor grayColor];
    highlight2.userInfo = @{@"name":@"也是一个最坏的时代"};
    highlight2.tapAction = ^(NSRange rang, id userInfo, NSString *str) {
        NSLog(@"%@",userInfo[@"name"]);
        [self lh_arlert:userInfo[@"name"]];
    };
  
//    [muteAtt lh_setHighlight:highlight2 andRange:NSMakeRange(22, 9)];
    [muteAtt addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(22, 9)];
//    [muteAtt addAttribute:NSBackgroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(22, 9)];
    [muteAtt addAttribute:NSUnderlineStyleAttributeName  value:@(1) range:NSMakeRange(22, 21)];
 
    
    //
//    NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
//    attachment.image = [UIImage imageNamed:@"pic.jpg"];
//    attachment.bounds = CGRectMake(0, 0, 250, 250);
//    NSAttributedString*attachmentStr = [NSAttributedString attributedStringWithAttachment:attachment];
//
//    [muteAtt insertAttributedString:attachmentStr atIndex:10];
    
    UIImage*image = [UIImage imageNamed:@"pic.jpg"];
//    NSAttributedString*imageStr =  image.attachStr;
//    [muteAtt insertAttributedString:imageStr atIndex:5];
    
//    CGFloat h = [self sizeLabelToFit:muteAtt width:250 height:MAXFLOAT];
   
//    NSMutableAttributedString * mutableAttriStr = [[NSMutableAttributedString alloc] initWithString:@"Wenchen"];
//    NSDictionary * attris = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSBackgroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:14]};
//    [mutableAttriStr setAttributes:attris range:NSMakeRange(0,mutableAttriStr.length)];
    /************/
    LHTIView *view = [[LHTIView alloc]initWithFrame:CGRectMake(15, 30,[UIScreen mainScreen].bounds.size.width-100, 0)];
    view.delegate = self;
    LHCoreTextData *coreTextData = [[LHCoreTextData alloc]initWithWidth:[UIScreen mainScreen].bounds.size.width-100];
    
    LHImageData *imageData = [[LHImageData alloc]initWithAttributes:dic viewWidth:[UIScreen mainScreen].bounds.size.width -30];
    imageData.image = image;
    imageData.loction = 7;
//    imageData.imageName = @"pic.jpg";
    
    coreTextData.mutaAttStr = muteAtt;
//    coreTextData.imageDataArray = [NSMutableArray arrayWithObjects:imageData, nil];
    view.coreTextData = coreTextData;
    
    view.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:view];
    
    /****************/
    
//    view.attStr =muteAtt;
    UILabel * Label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 200, 300)];
    Label.numberOfLines = 0;
//    [self.view addSubview:Label];
    NSMutableAttributedString * mutableAttriStr = [[NSMutableAttributedString alloc] initWithString:@"也是一个最坏的时代这是怀疑的纪元；这是光明的季节，这是黑暗的季节；这是希望的春日，这是失望的冬日；我们面前应有尽有，我们面前一无所有；我们都将直上天堂，我们都将直下地狱"];
    NSDictionary * attris = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSBackgroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:14]};
    [mutableAttriStr setAttributes:dic range:NSMakeRange(0,mutableAttriStr.length)];
    [mutableAttriStr addAttribute:NSBackgroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(10, 20)];
    Label.attributedText = mutableAttriStr;
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)lh_didClickImage:(UIImage *)image info:(id)info{
    NSLog(@"%@",info);
    [self lh_arlert:info];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)sizeLabelToFit:(NSAttributedString *)aString width:(CGFloat)width height:(CGFloat)height {
    CTFramesetterRef ctFrameSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)aString);
    //获取要绘制的区域信息
    CGSize restrictSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(ctFrameSetterRef, CFRangeMake(0, 0), NULL, restrictSize, NULL);
    CGFloat textHeight = coreTextSize.height;
    return textHeight;

//        NSMutableParagraphStyle *sty = [[NSMutableParagraphStyle alloc]init];
//        sty.lineSpacing =40;
//       NSDictionary* attDic = @{NSParagraphStyleAttributeName:sty,NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor darkGrayColor]};
//
//    CGSize strSize = [aString.string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attDic context:nil].size;
//    return strSize.height;
    
}
-(void)lh_arlert:(NSString*)str{
    UIAlertController*vc = [UIAlertController alertControllerWithTitle:@"您点击了" message:str preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction*oka = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [vc addAction:oka];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
