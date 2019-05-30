//
//  CFClassificationController.m
//  CFOnlineShop
//
//  Created by 俞渊华 on 2018/7/18.
//  Copyright © 2018年 俞渊华. All rights reserved.
//

#import "CFClassificationController.h"
#import "CFHomeCollectionHeader.h"
#import "CFClassificationCell.h"
#import "classifyModel.h"
#import "ClassificationDetailController.h"

@interface CFClassificationController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) NSMutableArray *leftData;
@property (nonatomic, strong) UICollectionView *rightCollectionView;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSString* code;
@property (nonatomic, strong) NSMutableArray *rightData;

@end

@implementation CFClassificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _code=@"01";
    
    [self setTitle:@"分类"];
    self.navigationView.backgroundColor = kWhiteColor;
    
    [self setTableViewAndCollectionView];
    [self postUI];
    [self postSubUI];
}

- (void)setTableViewAndCollectionView
{
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TopHeight, Main_Screen_Width/4, Main_Screen_Height - TopHeight - TabbarHeight) style:(UITableViewStylePlain)];
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftTableView.backgroundColor = KBackgroundColor;
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    [self.view addSubview:_leftTableView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(MaxX(_leftTableView), TopHeight, Main_Screen_Width/4*3, Main_Screen_Height - TopHeight - TabbarHeight) collectionViewLayout:flowLayout];
    _rightCollectionView.dataSource = self;
    _rightCollectionView.delegate = self;
    _rightCollectionView.backgroundColor = kClearColor;
    [_rightCollectionView registerClass:[CFClassificationCell class] forCellWithReuseIdentifier:@"CollectionCell"];
//    [_rightCollectionView registerClass:[CFHomeCollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:_rightCollectionView];
    
    //去掉顶部偏移
    if (@available(iOS 11.0, *))
    {
        _leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _rightCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}
-(void)postUI
{
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
                             @"page" : @"1",
                             @"limits": @"10"
                             };
    [HttpTool get:[NSString stringWithFormat:@"renren-fast/mall/goodscategory/list"] params:params success:^(id responseObj) {
        NSDictionary* a=responseObj[@"page"][@"list"];
        _leftData = [NSMutableArray new];
        for (NSDictionary* products in responseObj[@"page"][@"list"]) {
            classifyModel* c=[classifyModel mj_objectWithKeyValues:products];
//            p.productName=[products objectForKey:@"description"];
//            p.productId=[products objectForKey:@"id"];
            NSLog(@"");
                        [_leftData addObject:c];
        }
        [_leftTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
-(void)postSubUI
{
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
                             @"code" : _code,
                             @"page" : @"1",
                             @"limits": @"10"
                             };
    [HttpTool get:[NSString stringWithFormat:@"renren-fast/mall/goodscategory/list"] params:params success:^(id responseObj) {
        NSDictionary* a=responseObj[@"page"][@"list"];
        _rightData = [NSMutableArray new];
        for (NSDictionary* products in responseObj[@"page"][@"list"]) {
            classifyModel* c=[classifyModel mj_objectWithKeyValues:products];
                        c.categoryId=[products objectForKey:@"id"];
            //            p.productId=[products objectForKey:@"id"];
            NSLog(@"");
            [_rightData addObject:c];
        }
        [_rightCollectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
#pragma mark -- method

- (void)leftTableViewOffsetWithIndexPath:(NSIndexPath *)indexPath
{
    //判断点击的cell是否靠近底部，或顶部，是则偏移指定位移
    CGRect rect = [_leftTableView rectForRowAtIndexPath:indexPath];
    
    CGFloat total_offset = _leftTableView.contentSize.height - _leftTableView.mj_h;//总偏移
    WeakSelf(self);
    //44为cell高度,乘以3表示点击下面三个时偏移
    if (rect.origin.y - _leftTableView.mj_offsetY >= _leftTableView.mj_h - 44 * 3 - 1) {
        
        CGFloat contentOffset_y = _leftTableView.mj_offsetY + 44 * 3;
        
        if (total_offset - _leftTableView.mj_offsetY < 44 * 3) {
            //判断ios 11直接设置偏移无效，我也没弄懂，必须延时才有效
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakself.leftTableView setContentOffset:CGPointMake(0, total_offset) animated:YES];
            });
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.leftTableView setContentOffset:CGPointMake(0, contentOffset_y) animated:YES];
            });
        }
    }
    //44为cell高度,乘以3表示点击上面三个时偏移
    else if (rect.origin.y - _leftTableView.mj_offsetY < 44 * 3)
    {
        CGFloat contentOffset_y = _leftTableView.mj_offsetY - 44 * 3;
        
        if (_leftTableView.mj_offsetY < 44 * 3) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.leftTableView setContentOffset:CGPointMake(0, 0) animated:YES];
            });
            
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.leftTableView setContentOffset:CGPointMake(0, contentOffset_y) animated:YES];
            });
            
        }
    }
    
}

#pragma mark -- UITableViewDelegate & dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _leftData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UILabel *label in cell.contentView.subviews) {
        [label removeFromSuperview];
    }
    //一般不怎么添加视图，我是为了方便
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width/4, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = KDarkTextColor;
    label.font = SYSTEMFONT(14);
    classifyModel* c=_leftData[indexPath.row];
    label.text = c.name;
    [cell.contentView addSubview:label];
    
    if (_selectIndex == indexPath.row) {
        cell.backgroundColor = kWhiteColor;
    }
    else
    {
        cell.backgroundColor = KBackgroundColor;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectIndex = indexPath.row;
    
    
    //用于判断lefttableView上下偏移
    [self leftTableViewOffsetWithIndexPath:indexPath];
    
    [self.leftTableView reloadData];
    classifyModel* c=[_leftData objectAtIndex:indexPath.row];
    _code=c.code;
    [self postSubUI];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_rightData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *collectionCell = @"CollectionCell";
    CFClassificationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
    classifyModel* c=[_rightData objectAtIndex:indexPath.row];
    cell.titleStr.text = c.name;
    
    NSString *imageName = [NSString stringWithFormat:@"commodity_%ld",(long)indexPath.row%10 + 1];
    
//    cell.imageView.image = [UIImage imageNamed:imageName];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:c.thumLogo]];
    return cell;
    
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//
//    UICollectionReusableView *reusableview = nil;
//
//    if (kind == UICollectionElementKindSectionHeader){
//
//        CFHomeCollectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//        reusableview = headerView;
//        reusableview.backgroundColor = kRedColor;
//    }
//
//    return reusableview;
//}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//  return CGSizeMake(_rightCollectionView.mj_w, _rightCollectionView.mj_w/16*7);
//}

#pragma mark -- UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger itemCount = 3;

    return CGSizeMake((_rightCollectionView.mj_w)/itemCount,(_rightCollectionView.mj_w)/itemCount + 50);
}

//距离collectionview的上下左右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5,0,10,0);
}

#pragma mark --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassificationDetailController* cd=[ClassificationDetailController new];
    classifyModel* c=[_rightData objectAtIndex:indexPath.row];
    cd.categoryId=c.categoryId;
    [self.navigationController pushViewController:cd animated:YES];
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
