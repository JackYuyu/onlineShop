//
//  OrderController.m
//  CFOnlineShop
//
//  Created by mac on 2019/6/3.
//  Copyright © 2019 chenfeng. All rights reserved.
//

#import "OrderController.h"
#import "math.h"
#import "CFSegmentedControl.h"
@interface OrderController ()<UITableViewDataSource,UITableViewDelegate,CFSegmentedControlDataSource,CFSegmentedControlDelegate>
@property (nonatomic, strong) NSArray *segmentTitles;
@property (nonatomic, strong) CFSegmentedControl *segmentedControl;
@property (nonatomic,strong) NSMutableArray* checkList;
@property (nonatomic,strong) UITableView* tableView;
@end

@implementation OrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TopHeight+40, self.view.bounds.size.width, self.view.bounds.size.height-40) style:UITableViewStyleGrouped];
    
    tableView.delegate=self;
    tableView.dataSource=self;
    //    tableView.editing=YES;
    _tableView=tableView;
    [self.view addSubview:tableView];
    self.navigationBgView.backgroundColor = kWhiteColor;
    self.navigationBgView.alpha = 1;
    [self showLeftBackButton];
    _segmentTitles = @[@"全部订单",@"待支付",@"待发货",@"已完成"];
    
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
//    view.backgroundColor = [UIColor whiteColor];
    _segmentedControl = [[CFSegmentedControl alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 - (90 * [_segmentTitles count])/2, TopHeight, 90 * [_segmentTitles count], 40)];
    _segmentedControl.delegate = self;
    _segmentedControl.dataSource = self;
    _segmentedControl.alpha = 1;
//    [view addSubview:_segmentedControl];
    [self.view addSubview:_segmentedControl];
    
}
-(void)postUI
{
    NSDictionary *params = @{
                             @"openId" : [MySingleton sharedMySingleton].openId
                             };
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
    [HttpTool postWithUrl:[NSString stringWithFormat:@"renren-fast/mall/usersigininfo/save"] body:data showLoading:false success:^(NSDictionary *response) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"");
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
#pragma mark -- SegmentedControlDelegate & datasource

- (NSArray *)getSegmentedControlTitles
{
    return _segmentTitles;
}

- (void)control:(CFSegmentedControl *)control didSelectAtIndex:(NSInteger)index
{
    if (index==1) {
        [self postRecordUI];
    }
    NSLog(@"");
    //    [_bgScrollView setContentOffset:CGPointMake(Main_Screen_Width * index, 0) animated:YES];
}
-(void)postRecordUI
{
    NSDictionary *params = @{
                             @"openId" : [MySingleton sharedMySingleton].openId,
                             @"todayScore" : @"1",
                             @"conDays" : @"1",
                             @"score" : @"1"
                             };
    WeakSelf(self)
    [HttpTool get:[NSString stringWithFormat:@"renren-fast/mall/usersigininfo/list"] params:params success:^(id responseObj) {
        NSDictionary* a=responseObj[@"page"][@"list"];
        _checkList=[[NSMutableArray alloc] init];
        //
        for (NSDictionary* products in responseObj[@"page"][@"list"]) {
//            checkModel* t=[checkModel mj_objectWithKeyValues:products];
            NSLog(@"");
            //            [_topicList addObject:t];
//            [_checkList addObject:t];
        }
//        weakself.segmentedControl.tapIndex=2;
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
//设置表格视图有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    if (section==0) {
    return 6;
    //    }else{
    //        return 10;
    //    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//设置每行的UITableViewCell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%d分区",indexPath.section];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"第%d行",indexPath.row];
    //    cell.imageView.image= [UIImage imageNamed:@"image"];
    //    cell.backgroundColor = [UIColor greenColor];
    //    cell.showsReorderControl=YES;
    //    cell.shouldIndentWhileEditing=YES;
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    checkModel* c=[_checkList objectAtIndex:indexPath.row];
    cell.textLabel.text=@"每日签到获得";
//    cell.detailTextLabel.text=c.signTime;
    //    cell.
    return cell;
}

//设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.section==0) {
    //        return 100;
    //    }else{
    return 64;
    //    }
}
//设置分区尾视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
//设置分区头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
//设置分区的尾视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    view.backgroundColor = [UIColor greenColor];
    return view;
}
//设置分区的头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];

    return view;
}
-(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[color CGColor]);
    CGContextFillRect(context,rect);
    UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//选中cell时调用的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
