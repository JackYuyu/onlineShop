//
//  CFShoppingCartController.m
//  CFOnlineShop
//
//  Created by 俞渊华 on 2018/7/18.
//  Copyright © 2018年 俞渊华. All rights reserved.
//

#import "CFShoppingCartController.h"
#import "CFShoppingCartCell1.h"
#import "CFShoppingCartCell2.h"
#import "CFShoppingCartHeaderView.h"
#import "productModel.h"
#import "FSSettlementViewController.h"
#import "PPNumberButton.h"

@interface CFShoppingCartController ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray* productList;
@property (nonatomic, assign) CGFloat bottomHeight;

@end
static NSInteger num_;

@implementation CFShoppingCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"购物车"];
    self.navigationView.backgroundColor = kWhiteColor;
    [self setCollectionView];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (![MySingleton sharedMySingleton].openId) {
        [_productList removeAllObjects];
        return;
    }
    [self postUI];
}
- (void)setCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TopHeight, Main_Screen_Width, Main_Screen_Height - TabbarHeight - TopHeight) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = kClearColor;
    [_collectionView registerClass:[CFShoppingCartCell1 class] forCellWithReuseIdentifier:@"CollectionCell"];
    [_collectionView registerClass:[CFShoppingCartCell2 class] forCellWithReuseIdentifier:@"CollectionCell2"];
    [_collectionView registerClass:[CFShoppingCartHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    _collectionView.emptyDataSetSource=self;
    _collectionView.emptyDataSetDelegate=self;
    [self.view addSubview:_collectionView];
    
    //去掉顶部偏移
    if (@available(iOS 11.0, *))
    {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
}
-(void)postUI
{
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
                             @"openId" : [MySingleton sharedMySingleton].openId,
                             @"page" : @"1",
                             @"limits": @"10"
                             };
    [HttpTool get:[NSString stringWithFormat:@"renren-fast/mall/goodsshoppingcar/querylist"] params:params success:^(id responseObj) {
        NSDictionary* a=responseObj[@"list"];
        _productList=[NSMutableArray new];
        for (NSDictionary* products in responseObj[@"list"]) {
            productModel* p=[productModel mj_objectWithKeyValues:products];
            p.productName=[products objectForKey:@"name"];
            p.productId=[products objectForKey:@"id"];
            NSLog(@"");
            [_productList addObject:p];
        }
        if ([_productList count]>0) {
            [self setBottomView];
        }
        [_collectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
-(void)postDelUI
{
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
                             @"openId" : [MySingleton sharedMySingleton].openId,
                             @"goodsId" : @"",
                             @"page" : @"1",
                             @"limits": @"10"
                             };
    [HttpTool get:[NSString stringWithFormat:@"renren-fast/mall/goodsshoppingcar/delete"] params:params success:^(id responseObj) {
//        NSDictionary* a=responseObj[@"list"];
        
        [_collectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
- (void)setBottomView
{
    _bottomHeight = 55+TabbarHeight;

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height - _bottomHeight, Main_Screen_Width, 55)];
    bottomView.backgroundColor = [UIColor whiteColor];;
    [self.view addSubview:bottomView];
    
    UIButton *addButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    addButton.frame = CGRectMake(bottomView.mj_w/2, 0, bottomView.mj_w/4, 55);
    addButton.backgroundColor = [UIColor whiteColor];
    addButton.titleLabel.font = SYSTEMFONT(16);
    [addButton setTitle:@"合计:150" forState:(UIControlStateNormal)];
    [addButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [addButton addTarget:self action:@selector(addAction) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:addButton];
    
    UIButton *addimButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    addimButton.frame = CGRectMake(bottomView.mj_w*3/4, 0, bottomView.mj_w/4, 55);
    addimButton.backgroundColor = kRedColor;
    addimButton.titleLabel.font = SYSTEMFONT(16);
    [addimButton setTitle:@"去结算" forState:(UIControlStateNormal)];
    [addimButton setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
    [addimButton addTarget:self action:@selector(addAction) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:addimButton];
    
}
-(void)addAction
{
    FSSettlementViewController* confirmOrder=[[FSSettlementViewController alloc] initWithNibName:@"FSSettlementViewController" bundle:nil];
    confirmOrder.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:confirmOrder animated:YES];
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return [_productList count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        static NSString *collectionCell = @"CollectionCell";
        CFShoppingCartCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
        [cell configCollectionCellType:(CFEditCollectionCellTypeWithDelete)];
        productModel* p=[_productList objectAtIndex:indexPath.row];
        //cell.backgroundColor = kRedColor;
        cell.titleStr.text = p.productName;
        cell.priceStr.text=[NSString stringWithFormat:@"￥:%@",p.marketPrice];
        NSString *imageName = [NSString stringWithFormat:@"commodity_%ld",(long)indexPath.row + 1];
//        cell.imageView.image = [UIImage imageNamed:imageName];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:p.logo]];
        [cell setDeleteButtonAction:^(UIButton *button) {
            NSLog(@"删除操作");
        }];
        
        PPNumberButton *numberButton = [PPNumberButton numberButtonWithFrame:CGRectZero];
        numberButton.shakeAnimation = YES;
        numberButton.minValue = 1;
        numberButton.inputFieldFont = 23;
        numberButton.increaseTitle = @"＋";
        numberButton.decreaseTitle = @"－";
        num_ = (_lastNum == 0) ?  1 : [_lastNum integerValue];
        numberButton.currentNumber = num_;
        numberButton.delegate = self;
        
        numberButton.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
            num_ = num;
        };
        [cell.contentView addSubview:numberButton];
        [numberButton mas_makeConstraints:^(MASConstraintMaker *make) {
            [make.right.mas_equalTo(cell.contentView)setOffset:-10];
            [make.bottom.mas_equalTo(cell.contentView)setOffset:0];
            make.size.mas_equalTo(CGSizeMake(110, 40));
        }];
        return cell;
    }
    else
    {
        static NSString *collectionCell2 = @"CollectionCell2";
        CFShoppingCartCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell2 forIndexPath:indexPath];
        [cell configCollectionCellType:(CFEditCollectionCellTypeWithNone)];
        cell.backgroundColor = kRedColor;
        cell.titleStr.text = @"测试商品";
        
        NSString *imageName = [NSString stringWithFormat:@"commodity_%ld",(long)indexPath.row + 1];
        
        cell.imageView.image = [UIImage imageNamed:imageName];
        [cell setDeleteButtonAction:^(UIButton *button) {
            NSLog(@"删除操作");
        }];
        
        return cell;
    }
}


#pragma mark -- UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return CGSizeMake(_collectionView.mj_w - 10, 80);
    }
    else
    {
        NSInteger itemCount = 2;
        return CGSizeMake((Main_Screen_Width - 25)/itemCount, (Main_Screen_Width - 25)/itemCount + 60);
    }
}

//距离collectionview的上下左右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5,10,0,10);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader && indexPath.section == 1){
        
        CFShoppingCartHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        reusableview = headerView;
        //reusableview.backgroundColor = kRedColor;
    }
    
    return reusableview;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(0, 0);
    }
    
    return CGSizeMake(Main_Screen_Width, 40);
}

#pragma mark --UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"click collectionView row");
}

#pragma mark - <DZNEmptyDataSetSource>

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *buttonTitle = @"去逛逛";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Light" size:17],
                                 NSForegroundColorAttributeName: [UIColor blackColor]
                                 };
    return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"empty_cart"];
}
#pragma mark - <DZNEmptyDataSetDelegate>

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    // Do something
//    [self refreshingAgain];
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    
    return Main_Screen_Width * 0.75;
}
#pragma mark --UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"开始拖动");
    [[_collectionView visibleCells] makeObjectsPerformSelector:@selector(hiddenButtonsWithAnimation)];
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
