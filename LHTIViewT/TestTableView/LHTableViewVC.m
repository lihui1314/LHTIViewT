//
//  LHTableViewVC.m
//  LHTIViewT
//
//  Created by 李辉 on 2018/12/20.
//  Copyright © 2018年 李辉. All rights reserved.
//
#define versionGreaterThan11(topM)\
{\
NSString *version= [UIDevice currentDevice].systemVersion;\
if(version.doubleValue <11.0) {\
topM.constant +=20;\
}\
}
#import "LHTableViewVC.h"
#import "LHTestTableViewTextLayout.h"
#import "LHTableViewCell.h"

@interface LHTableViewVC ()<UITableViewDelegate,UITableViewDataSource,LHTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

@implementation LHTableViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    versionGreaterThan11(_top);
    [self lh_loadData];
    [self configT];
    // Do any additional setup after loading the view from its nib.
}

-(void)lh_loadData{
    NSMutableArray*array = [NSMutableArray arrayWithObjects:@{@"name":@"331545211074_.pic.jpg",@"loction":@(45)}, nil];

    LHTestTableViewTextModel*model = [[LHTestTableViewTextModel alloc]init];
    model.text = @ "秋天，无论在什么地方的秋天，总是好的；可是啊，北国的秋，却特别地来得清，来得静，来得悲凉。我的不远千里，要从杭州赶上青岛，更要从青岛赶上北平来的理由，也不过想饱尝一尝这“秋”，这故都的秋味。\n江南，秋当然也是有的，但草木凋得慢，空气来得润，天的颜色显得淡，并且又时常多雨而少风；一个人夹在苏州上海杭州，或厦门香港广州的市民中间，混混沌沌地过去，只能感到一点点清凉，秋的味，秋的色，秋的意境与姿态，总看不饱，尝不透，赏玩不到十足。秋并不是名花，也并不是美酒，那一种半开、半醉的状态，在领略秋的过程上，是不合适的";
    model.imageInfoArray = array;
    LHTestTableViewTextLayout*lay = [[LHTestTableViewTextLayout alloc]init];
    lay.model = model;
    [self.dataArray addObject:lay];
}

-(void)configT{
    [self.tableView registerClass:[LHTableViewCell class] forCellReuseIdentifier:@"LHTableViewCell"];
}

#pragma mark - tableview delegate and dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LHTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"LHTableViewCell"];
    cell.delegate = self;
    cell.layout = self.dataArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LHTestTableViewTextLayout*layout = self.dataArray[indexPath.row];
    return layout.cellHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark  touch image or highlightText
-(void)lh_didSeletedImage:(UIImage *)image imageInfo:(NSDictionary *)imageInfo{
    NSLog(@"%@",imageInfo[@"name"]);
}

-(void)lh_didSeletedText:(NSRange)range inserText:(NSString *)inerText textInfo:(NSDictionary *)textInfo{
    NSLog(@"%@",textInfo[@"name"]);
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
