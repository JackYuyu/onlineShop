//
//  FSSettlementViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/1.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSSettlementViewController.h"
#import "FSShoppingCartInfoCell.h"



static NSString *const kOrderCellWithIdentifier = @"kOrderCellWithIdentifier";

@interface FSSettlementViewController ()

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLab;

@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLab;

@property (weak, nonatomic) IBOutlet UIButton *orderButton;

@property (weak, nonatomic) IBOutlet UITableView *curTabView;

@property (nonatomic, strong) NSMutableArray *addressResult;

@property (nonatomic, copy) NSString * addressID;

@end

@implementation FSSettlementViewController

- (NSMutableArray *)addressResult {
    
    if (!_addressResult) {
        
        _addressResult = [NSMutableArray array];
    }
    return _addressResult;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"确认订单";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self initSubview];
    [self requestAddress];
    self.navigationBgView.backgroundColor = kWhiteColor;
    self.navigationBgView.alpha = 0;
    [self showLeftBackButton];
}

- (void)initSubview {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bottomButton.layer.cornerRadius = 5.0;
    self.bottomButton.layer.masksToBounds = YES;
    
    self.orderButton.layer.cornerRadius = 5;
    self.orderButton.layer.masksToBounds = YES;
    self.orderButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.orderButton addTarget:self action:@selector(addNewOrder) forControlEvents:UIControlEventTouchUpInside];
    
    self.totalMoneyLab.text = @"￥0.0";
    self.totalPriceLab.text = @"￥0.0";
    
    [self initTabView];
}

- (void)initTabView {
    
    self.curTabView.delegate = self;
    self.curTabView.dataSource = self;
    self.curTabView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.curTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.curTabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.curTabView registerNib:[UINib nibWithNibName:@"FSShoppingCartInfoCell" bundle:nil] forCellReuseIdentifier:kOrderCellWithIdentifier];
}

#pragma mark - Request

- (void)addNewOrder {
    
}


- (void)requestAddress {
    
//    NSMutableDictionary *p = [NSMutableDictionary dictionary];
//    [p setObject:@"3406" forKey:@"appkey"];
//    [p setObject:[FSLoginManager manager].token forKey:@"token"];
//
//    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
//    [[FSRequestManager manager] POST:kAddress_List parameters:p success:^(id  _Nullable responseObj) {
//        [FSProgressHUD hideHUD];
//        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
//            return;
//        }
//
//        if ([responseObj[@"returns"] integerValue] == 1) {
//            NSArray *JSONArray = [responseObj[@"address"] mj_JSONObject];
//            if (JSONArray.count) {
//                [self.addressResult addObjectsFromArray:[FSShopCartList mj_objectArrayWithKeyValuesArray:JSONArray]];
//                [self reloadAddressInfo:[self.addressResult firstObject]];
//            }
//        }else {
//            [FSProgressHUD showHUDWithLongText:@"Please add address" delay:1.0];
//            [self addToAddress];
//        }
//
//        [self.tableView reloadData];
//
//    } failure:^(NSError * _Nonnull error) {
//
//        [FSProgressHUD hideHUD];
//    }];
}

- (void)addToAddress {
    
//    FSAddressAddViewController *addAddress = [[FSAddressAddViewController alloc] init];
//    [self.navigationController pushViewController:addAddress animated:YES];
}

//- (void)reloadAddressInfo:(FSShopCartList *)model {
//    if (!model) return;
//    
//    self.addressID = model.idField;
//    
//    self.telLabel.text = model.tel;
//    self.nameLabel.text = model.name;
//    self.addressLabel.text = model.address;
//}

- (void)popToController {
    
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:[FSProductDetailViewController class]]) {
//            FSProductDetailViewController *vc1 = (FSProductDetailViewController *)controller;
//            [self.navigationController popToViewController:vc1 animated:YES];
//        }if ([controller isKindOfClass:[FSMeInfoViewController class]]) {
//            FSMeInfoViewController *vc2 = (FSMeInfoViewController *)controller;
//            [self.navigationController popToViewController:vc2 animated:YES];
//        }
//    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0)
        return self.dataSource.count;
    else if (section==1) {
        return 2;
    }
    else if (section==2) {
        return 1;
    }
    else {
        return 4;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {

    FSShoppingCartInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderCellWithIdentifier];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
        cell.hideAdd = YES;
    }
    return cell;
    }
    else
    {
        static NSString *identifier = @"identifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.font = SYSTEMFONT(16);
        cell.textLabel.textColor = KDarkTextColor;
        cell.textLabel.text = @"哈哈哈哈哈啊哈哈";
        return cell;
    }
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0)
        return 100;

    else {
        return 44;
    }
}

//设置分区头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
//设置分区的头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    return view;
}
#pragma mark - Action

- (IBAction)arrowDidEvent:(id)sender {
    
    if (!self.addressID) {
        [self addToAddress];
    }
}
@end
