//
//  CFDetailViewController.m
//  CFOnlineShop
//
//  Created by 俞渊华 on 2018/8/6.
//  Copyright © 2018年 俞渊华. All rights reserved.
//

#import "CFDetailViewController.h"
//#import "CFDetailView.h"
#import "productModel.h"
#import "CFShoppingCartController.h"

@interface CFDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UIWebView *webView;

//添加在头部视图的tempScrollView
@property (nonatomic, strong) UIScrollView *tempScrollView;
//记录底部空间所需的高度
@property (nonatomic, assign) CGFloat bottomHeight;
@property (nonatomic, strong) NSArray *detailTitles;
@property (nonatomic,strong)productModel* pmodel;
//@property (nonatomic, strong) CFDetailView *detailView;

@end

@implementation CFDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _detailTitles = @[@"夏季印花棉修身默认套餐",@"商品评价(0)",@"商品信息",@"商品详情"];

    [self setBgUI];
    [self setHeaderAndFooterView];
    [self setBottomView];
    [self setUpLeftTwoButton];
    [self postUI];
    [self postCommentUI];
    [self postSkuUI];
    [self postBrowseInfoUI];
    [self postFavUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _webView.delegate = nil;
    _webView = nil;
    NSLog(@"释放View");
}
-(void)postUI
{
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
                             @"id" : _productId,
                             @"page" : @"1",
                             @"limits": @"10"
                             };
    [HttpTool get:[NSString stringWithFormat:@"renren-fast/mall/goodsinfo/list"] params:params success:^(id responseObj) {
        NSDictionary* a=responseObj[@"page"][@"list"];
        for (NSDictionary* products in responseObj[@"page"][@"list"]) {
            productModel* p=[productModel mj_objectWithKeyValues:products];
            p.productName=[products objectForKey:@"description"];
            p.productId=[products objectForKey:@"id"];
            _pmodel=p;
            
            FSShopCartList* cart =[FSShopCartList new];
            cart.goodsId=p.productId;
            cart.goodsSkuId=p.goodsSkuId;
            [MySingleton sharedMySingleton].cartItem=cart;
            NSLog(@"");
//            [_productList addObject:p];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
-(void)postCommentUI
{
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
                             @"goodsId" : _productId,
                             @"page" : @"1",
                             @"limits": @"10"
                             };
    [HttpTool get:[NSString stringWithFormat:@"renren-fast/mall/goodscomment/list"] params:params success:^(id responseObj) {
        NSDictionary* a=responseObj[@"page"][@"list"];
        for (NSDictionary* products in responseObj[@"page"][@"list"]) {
            //            productModel* p=[productModel mj_objectWithKeyValues:products];
            //            p.productName=[products objectForKey:@"description"];
            //            p.productId=[products objectForKey:@"id"];
            NSLog(@"");
            //            [_productList addObject:p];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
-(void)postFavUI
{
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
                             @"openId" : [MySingleton sharedMySingleton].openId,
                             @"goodsId" : _productId,
                             @"page" : @"1",
                             @"limits": @"10"
                             };
    [HttpTool get:[NSString stringWithFormat:@"renren-fast/mall/goodsfavorite/list"] params:params success:^(id responseObj) {
        NSDictionary* a=responseObj[@"page"][@"list"];
        for (NSDictionary* products in responseObj[@"page"][@"list"]) {
            //            productModel* p=[productModel mj_objectWithKeyValues:products];
            //            p.productName=[products objectForKey:@"description"];
            //            p.productId=[products objectForKey:@"id"];
            NSLog(@"");
            //            [_productList addObject:p];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
-(void)postSkuUI
{
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
                             @"goodsId" : _productId,
                             @"page" : @"1",
                             @"limits": @"10"
                             };
    [HttpTool get:[NSString stringWithFormat:@"renren-fast/mall/goodssku/list"] params:params success:^(id responseObj) {
        NSDictionary* a=responseObj[@"page"][@"list"];
        for (NSDictionary* products in responseObj[@"page"][@"list"]) {
            //            productModel* p=[productModel mj_objectWithKeyValues:products];
            //            p.productName=[products objectForKey:@"description"];
            //            p.productId=[products objectForKey:@"id"];
            NSLog(@"");
            //            [_productList addObject:p];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
-(void)postBrowseInfoUI
{
    NSDictionary *params = @{
                             @"openId" : [MySingleton sharedMySingleton].openId,
                             @"goodsId" : _productId,
                             @"page" : @"1",
                             @"limits": @"10"
                             };
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
    [HttpTool postWithUrl:[NSString stringWithFormat:@"renren-fast/mall/userbrowseinfo/save"] body:data showLoading:false success:^(NSDictionary *response) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
-(void)postAddFavUI
{
    NSDictionary *params = @{
                             @"openId" : [MySingleton sharedMySingleton].openId,
                             @"goodsId" : _productId,
                             @"page" : @"1",
                             @"limits": @"10"
                             };
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
    [HttpTool postWithUrl:[NSString stringWithFormat:@"renren-fast/mall/goodsfavorite/save"] body:data showLoading:false success:^(NSDictionary *response) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];

        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
-(void)postDelFavUI
{
    NSDictionary *params = @{
                             @"openId" : [MySingleton sharedMySingleton].openId,
                             @"goodsId" : _productId,
                             @"page" : @"1",
                             @"limits": @"10"
                             };
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
    [HttpTool postWithUrl:[NSString stringWithFormat:@"renren-fast/mall/goodsfavorite/delete"] body:data showLoading:false success:^(NSDictionary *response) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
- (void)setBgUI
{
    _bottomHeight = 55;
    
    //存放tableView和webView，tableview在上面，webview在下面
    _bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, (Main_Screen_Height - _bottomHeight) * 2)];
    _bigView.backgroundColor = kWhiteColor;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - _bottomHeight)];
    _tableView.backgroundColor = kWhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //去掉顶部偏移
    if (@available(iOS 11.0, *))
    {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height - _bottomHeight, Main_Screen_Width, Main_Screen_Height - _bottomHeight)];
    _webView.backgroundColor = [UIColor clearColor];
    
    _webView.scrollView.delegate = self;
    
    [self.view addSubview:_bigView];
    [_bigView addSubview:_tableView];
    [_bigView addSubview:_webView];
    
    WeakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    });
}

- (void)setHeaderAndFooterView{
    
    //添加头部和尾部视图
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Width)];
    headerView.backgroundColor = kWhiteColor;
    
    _tempScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Width)];
    [headerView addSubview:_tempScrollView];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Width)];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    _headerImageView.image = _image;
    [_tempScrollView addSubview:_headerImageView];
    
    _tableView.tableHeaderView = headerView;
    
    UILabel *pullMsgView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
    pullMsgView.textAlignment = NSTextAlignmentCenter;
    pullMsgView.text = @"上拉显示网页";
    pullMsgView.textColor = KGrayTextColor;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
    [footView addSubview:pullMsgView];
    
    _tableView.tableFooterView = footView;
    
    //设置下拉提示视图
    UILabel *downPullMsgView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
    downPullMsgView.textAlignment = NSTextAlignmentCenter;
    downPullMsgView.text = @"下拉显示列表";
    downPullMsgView.textColor = KGrayTextColor;
    
    UIView *downMsgView = [[UIView alloc] initWithFrame:CGRectMake(0, -40, Main_Screen_Width, 40)];
    [downMsgView addSubview:downPullMsgView];
    [_webView.scrollView addSubview:downMsgView];
}

- (void)setBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height - _bottomHeight, Main_Screen_Width, _bottomHeight)];
    bottomView.backgroundColor = KBackgroundColor;
    [self.view addSubview:bottomView];
    
    UIButton *addButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    addButton.frame = CGRectMake(bottomView.mj_w/2, 0, bottomView.mj_w/4, _bottomHeight);
    addButton.backgroundColor = RGBCOLOR(250, 112, 60);
    addButton.titleLabel.font = SYSTEMFONT(16);
    [addButton setTitle:@"加入购物车" forState:(UIControlStateNormal)];
    [addButton setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
    [addButton addTarget:self action:@selector(addAction) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:addButton];
    
    UIButton *addimButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    addimButton.frame = CGRectMake(bottomView.mj_w*3/4, 0, bottomView.mj_w/4, _bottomHeight);
    addimButton.backgroundColor = kRedColor;
    addimButton.titleLabel.font = SYSTEMFONT(16);
    [addimButton setTitle:@"立即购买" forState:(UIControlStateNormal)];
    [addimButton setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
    [addimButton addTarget:self action:@selector(addAction) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:addimButton];
    
}
#pragma mark - 收藏 购物车
- (void)setUpLeftTwoButton
{
    NSArray *imagesNor = @[@"tabr_07shoucang_up",@"tabr_08gouwuche"];
    NSArray *imagesSel = @[@"tabr_07shoucang_down",@"tabr_08gouwuche"];
    CGFloat buttonW = Main_Screen_Width * 0.2;
    CGFloat buttonH = _bottomHeight;
    CGFloat buttonY = Main_Screen_Height - buttonH;
    
    for (NSInteger i = 0; i < imagesNor.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:imagesNor[i]] forState:UIControlStateNormal];
        button.backgroundColor = KBackgroundColor;
        [button setImage:[UIImage imageNamed:imagesSel[i]] forState:UIControlStateSelected];
        button.tag = i;
        [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonX = (buttonW * i);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        [self.view addSubview:button];
    }
}
-(void)bottomButtonClick:(UIButton*)sender
{
    if (sender.tag==0) {
        if(sender.selected)
        {
            [self postDelFavUI];
        }
        else
        {
            [self postAddFavUI];
        }
        sender.selected=!sender.selected;
//        [self postDelFavUI];

    }
    if (sender.tag==1) {
        CFShoppingCartController* sc=[CFShoppingCartController new];
        [self.navigationController pushViewController:sc animated:YES];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    
    if (scrollView == _tableView){
        //重新赋值，就不会有用力拖拽时的回弹
        _tempScrollView.contentOffset = CGPointMake(_tempScrollView.contentOffset.x, 0);
        if (offset >= 0 && offset <= Main_Screen_Width) {
            //因为tempScrollView是放在tableView上的，tableView向上速度为1，实际上tempScrollView的速度也是1，此处往反方向走1/2的速度，相当于tableView还是正向在走1/2，这样就形成了视觉差！
            _tempScrollView.contentOffset = CGPointMake(_tempScrollView.contentOffset.x, - offset / 2.0f);
        }
    }
    
    _scrollViewDidScroll(scrollView);
}

#pragma mark -- 监听滚动实现商品详情与图文详情界面的切换
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    WeakSelf(self);
    CGFloat offset = scrollView.contentOffset.y;
    if (scrollView == _tableView) {
        if (offset > _tableView.contentSize.height - Main_Screen_Height + self.bottomHeight + 50) {
            [UIView animateWithDuration:0.4 animations:^{
                weakself.bigView.transform = CGAffineTransformTranslate(weakself.bigView.transform, 0, -Main_Screen_Height +  self.bottomHeight + TopHeight);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    if (scrollView == _webView.scrollView) {
        if (offset < -50) {
            [UIView animateWithDuration:0.4 animations:^{
                [UIView animateWithDuration:0.4 animations:^{
                    weakself.bigView.transform = CGAffineTransformIdentity;
                    
                }];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

#pragma mark - action

- (void)addAction
{
    if (_addActionWithBlock) {
        _addActionWithBlock();
    }
}

#pragma mark -- UITableViewDelegate & dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==1)
        return 2;
    else
        return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 100;
    }
    else if (indexPath.section==1){
        return 80;
    }
    else if (indexPath.section==2) {
        return 80;
    }
    else{
        
    return 60;
    }
}
//设置分区尾视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section>0) {
        return 10;
    }
    else{
        return 0.01;
    }}
//设置分区头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.01;
}
//设置分区的尾视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.font = SYSTEMFONT(16);
    cell.textLabel.textColor = KDarkTextColor;
    cell.textLabel.text = [_detailTitles objectAtIndex:indexPath.row+indexPath.section];
    if (indexPath.section==0) {
        cell.textLabel.text=_pmodel.productName;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
