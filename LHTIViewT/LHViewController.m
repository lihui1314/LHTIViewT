//
//  LHViewController.m
//  LHTIViewT
//
//  Created by 李辉 on 2018/12/16.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHViewController.h"
#import "LHTIView.h"
#import "NSMutableAttributedString+Cate.h"
#import "LHHighlight.h"
#import "LHCoreTextData.h"
#import "LHImageData.h"

@interface LHViewController ()<LHTIViewDelegate>

@end

@implementation LHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSMutableParagraphStyle *sty = [[NSMutableParagraphStyle alloc]init];
    sty.lineSpacing = 10;
    sty.alignment = NSTextAlignmentLeft;
    UIFont *font = [UIFont fontWithName:@"ArialMT" size:16];
    NSDictionary*atts = @{NSParagraphStyleAttributeName:sty,
                          NSFontAttributeName:font
                          };
    NSMutableAttributedString*muteStr = [[NSMutableAttributedString alloc]initWithString:@ "秋天，无论在什么地方的秋天，总是好的；可是啊，北国的秋，却特别地来得清，来得静，来得悲凉。我的不远千里，要从杭州赶上青岛，更要从青岛赶上北平来的理由，也不过想饱尝一尝这“秋”，这故都的秋味。\n江南，秋当然也是有的，但草木凋得慢，空气来得润，天的颜色显得淡，并且又时常多雨而少风；一个人夹在苏州上海杭州，或厦门香港广州的市民中间，混混沌沌地过去，只能感到一点点清凉，秋的味，秋的色，秋的意境与姿态，总看不饱，尝不透，赏玩不到十足。秋并不是名花，也并不是美酒，那一种半开、半醉的状态，在领略秋的过程上，是不合适的" attributes:atts];
    //hilight 给指定字段加上点击事件
    LHHighlight*hightlight = [[LHHighlight alloc]init];
    hightlight.tapBackgroundColor = [UIColor lightGrayColor];//高亮背景
    hightlight.userInfo = @{@"name":@"{3,24}"};
    hightlight.tapAction = ^(NSRange rang, id userInfo, NSString *str) {
        [self lh_arlert:userInfo[@"name"]];
    };
    [muteStr lh_setHighlight:hightlight andRange:NSMakeRange(3, 24)];
    [muteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(3, 24)];
    
    CGFloat width =  [UIScreen mainScreen].bounds.size.width-30;
    LHTIView*view = [[LHTIView alloc]initWithFrame:CGRectMake(15, 30,width, 0)];
    
    LHCoreTextData*coreData = [[LHCoreTextData alloc]initWithWidth:width];
    LHImageData*imageData = [[LHImageData alloc]initWithAttributes:atts viewWidth:width];
    imageData.image = [UIImage imageNamed:@"331545211074_.pic.jpg"];
    imageData.loction = 55;
    imageData.imageInfo = @{@"name":@"pic.jpg"};
    
    coreData.imageDataArray = [NSMutableArray arrayWithObjects:imageData, nil];
    coreData.mutaAttStr = muteStr;
    [coreData lh_ctframeParserWithFixedHight:0];
    view.coreTextData = coreData;
    view.delegate = self;
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
   
    // Do any additional setup after loading the view.
}

-(void)lh_didClickImage:(UIImage *)image info:(id)info{
    [self lh_arlert:info[@"name"]];
}

-(void)lh_arlert:(NSString*)str{
//    UIAlertController*vc = [UIAlertController alertControllerWithTitle:@"您点击了" message:str preferredStyle:(UIAlertControllerStyleAlert)];
//    UIAlertAction*oka = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
//    }];
//    [vc addAction:oka];
//    [self presentViewController:vc animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
