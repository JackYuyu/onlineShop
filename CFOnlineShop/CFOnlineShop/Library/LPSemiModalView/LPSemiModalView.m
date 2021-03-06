//
//  LPSemiModalView.m
//
//  Created by litt1e-p on 16/3/10.
//  Copyright © 2016年 itt1e-p. All rights reserved.
//

#import "LPSemiModalView.h"
#import <QuartzCore/QuartzCore.h>
#import "PPNumberButton.h"
#import "DCFeatureChoseTopCell.h"
#import "FSSettlementViewController.h"
#import "FSShopCartList.h"

@interface LPSemiModalView ()<PPNumberButtonDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIControl *closeControl;
@property (strong, nonatomic) UIImageView *maskImageView;
@property (nonatomic, strong) UIViewController *baseViewController;
/* tableView */
@property (strong , nonatomic)UITableView *tableView;

@property (weak , nonatomic)DCFeatureChoseTopCell *cell;
@end

static NSInteger num_;
static NSString *const DCFeatureChoseTopCellID = @"DCFeatureChoseTopCell";

@implementation LPSemiModalView

+ (UIImage *)snapshotWithWindow
{
    @autoreleasepool
    {
        UIGraphicsBeginImageContextWithOptions([UIApplication sharedApplication].keyWindow.bounds.size, YES, 2);
        [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        [_tableView registerClass:[DCFeatureChoseTopCell class] forCellReuseIdentifier:DCFeatureChoseTopCellID];
    }
    return _tableView;
}
#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCFeatureChoseTopCell *cell = [tableView dequeueReusableCellWithIdentifier:DCFeatureChoseTopCellID forIndexPath:indexPath];
    _cell = cell;
//    if (_seleArray.count != _featureAttr.count && _lastSeleArray.count != _featureAttr.count) {
        cell.chooseAttLabel.textColor = [UIColor redColor];
        cell.chooseAttLabel.text = [NSString stringWithFormat:@"¥ %@",_cartItem.productPrice];
//    }else {
//        cell.chooseAttLabel.textColor = [UIColor darkGrayColor];
//        NSString *attString = (_seleArray.count == _featureAttr.count) ? [_seleArray componentsJoinedByString:@"，"] : [_lastSeleArray componentsJoinedByString:@"，"];
//        cell.chooseAttLabel.text = [NSString stringWithFormat:@"已选属性：%@",attString];
//    }
    
    cell.goodPriceLabel.text = _cartItem.name;
    [cell.goodImageView sd_setImageWithURL:[NSURL URLWithString:_cartItem.logo]];
//    [cell.goodImageView setImage:[UIImage imageNamed:@"commodity_7"]];
    __weak typeof(self) weakSelf = self;
    cell.crossButtonClickBlock = ^{
        [weakSelf dismissFeatureViewControllerWithTag:100];
    };
    return cell;
}
#pragma mark - 退出当前界面
- (void)dismissFeatureViewControllerWithTag:(NSInteger)tag
{
    [self close];
}
-(void)setup{
    self.tableView.frame = CGRectMake(0, Main_Screen_Height-300, Main_Screen_Width, 300-50);
    self.tableView.rowHeight = 100;
}
#pragma mark - 底部按钮
- (void)setUpBottonView
{
    NSArray *titles = @[@"确定"];
    CGFloat buttonH = 50;
    CGFloat buttonW = Main_Screen_Width / titles.count;
    CGFloat buttonY = Main_Screen_Height - buttonH;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *buttton = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttton setTitle:titles[i] forState:0];
        buttton.backgroundColor = (i == 0) ? [UIColor redColor] : [UIColor orangeColor];
        CGFloat buttonX = buttonW * i;
        buttton.tag = i;
        buttton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [self addSubview:buttton];
        [buttton addTarget:self action:@selector(buttomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UILabel *numLabel = [UILabel new];
    numLabel.text = @"数量";
    numLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:numLabel];
    numLabel.frame = CGRectMake(10, Main_Screen_Height-100, 50, 35);
    
    PPNumberButton *numberButton = [PPNumberButton numberButtonWithFrame:CGRectMake(CGRectGetMaxX(numLabel.frame), numLabel.frame.origin.y, 110, numLabel.frame.size.height)];
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
    [self addSubview:numberButton];
    
    UIView* line=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame)-150, Main_Screen_Width, 0.5)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:line];
}

#pragma mark - 底部按钮点击
- (void)buttomButtonClick:(UIButton *)button
{
//    if (_seleArray.count != _featureAttr.count && _lastSeleArray.count != _featureAttr.count) {//未选择全属性警告
//        [SVProgressHUD showInfoWithStatus:@"请选择全属性"];
//        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//        [SVProgressHUD dismissWithDelay:1.0];
//        return;
//    }
    
    [self dismissFeatureViewControllerWithTag:button.tag];
    [self postUI];
}
-(void)postUI
{
    NSDictionary *params = @{
                             @"goodsId" : _cartItem.goodsId,
                             @"openId" : [MySingleton sharedMySingleton].openId,
                             @"goodsSkuId" : _cartItem.goodsSkuId,
                             @"num": @"1"
                             };
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
    [HttpTool postWithUrl:[NSString stringWithFormat:@"renren-fast/mall/goodsshoppingcar/save"] body:data showLoading:false success:^(NSDictionary *response) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
- (void)open
{
    if (!self.narrowedOff) {
        //self.contentView.hidden = YES;
        CATransform3D t = CATransform3DIdentity;
        t.m34 = -0.004;
        [self.maskImageView.layer setTransform:t];
        self.maskImageView.layer.zPosition = -10000;
        
        self.maskImageView.image = [self.class snapshotWithWindow];
        if (self.baseViewController) {
            [self.baseViewController.view bringSubviewToFront:self];
        }
        self.closeControl.userInteractionEnabled = YES;
        [UIView animateWithDuration:0.5f animations:^{
            self.maskImageView.alpha = 0.5;
            self.contentView.frame = CGRectMake(0,
                                                [[UIScreen mainScreen] bounds].size.height - self.contentView.bounds.size.height,
                                                self.contentView.frame.size.width,
                                                self.contentView.frame.size.height);
        }];
        [UIView animateWithDuration:0.25f animations:^{
            self.maskImageView.layer.transform = CATransform3DRotate(t, 7/90.0 * M_PI_2, 1, 0, 0);
            if (self.baseViewController) {
                if (self.baseViewController.navigationController) {
                    [self transNavigationBarToHide:YES];
                }
            }
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25f animations:^{
                self.maskImageView.layer.transform = CATransform3DTranslate(t, 0, -50, -50);
            }];
        }];
    } else {
        self.maskImageView.image = [self.class snapshotWithWindow];
        if (self.baseViewController) {
            [self.baseViewController.view bringSubviewToFront:self];
        }
        self.closeControl.userInteractionEnabled = YES;
        [UIView animateWithDuration:0.25f animations:^{
            self.maskImageView.alpha = 0.25;
            self.contentView.frame = CGRectMake(0,
                                                [[UIScreen mainScreen] bounds].size.height - self.contentView.bounds.size.height,
                                                self.contentView.frame.size.width,
                                                self.contentView.frame.size.height);
            if (self.baseViewController) {
                if (self.baseViewController.navigationController) {
                    self.baseViewController.navigationController.navigationBarHidden = YES;
                }
            }
        }];
    }
    _cartItem=[MySingleton sharedMySingleton].cartItem;

    [self setup];
    [self setUpBottonView];
}

- (void)close
{
    if (self.semiModalViewWillCloseBlock) {
        self.semiModalViewWillCloseBlock();
    }
    if (!self.narrowedOff) {
        CATransform3D t = CATransform3DIdentity;
        t.m34 = -0.004;
        [self.maskImageView.layer setTransform:t];
        self.closeControl.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.5f animations:^{
            self.maskImageView.alpha = 1;
            self.contentView.frame = CGRectMake(0,
                                                self.frame.size.height,
                                                self.contentView.frame.size.width,
                                                self.contentView.frame.size.height);
        } completion:^(BOOL finished) {
            if (self.semiModalViewDidCloseBlock) {
                self.semiModalViewDidCloseBlock();
            }
            if (self.baseViewController) {
                if (self.baseViewController.navigationController) {
                    if (self.block) {
                        FSSettlementViewController* confirmOrder=[[FSSettlementViewController alloc] initWithNibName:@"FSSettlementViewController" bundle:nil];
//                        FSShopCartList *newCart = [FSShopCartList new];
//                        newCart.num = [NSString stringWithFormat:@"%ld", 1.0];
//                        newCart.img = @"commodity_7";
//                        newCart.name = @"测试商品";
//                        newCart.idField = @"11111";
                        confirmOrder.dataSource = [NSMutableArray arrayWithObjects:_cartItem, nil];
                        [self.baseViewController.navigationController pushViewController:confirmOrder animated:YES];
                    }
                    else
                    {
                    [self transNavigationBarToHide:NO];
                    }
                }
                [self.baseViewController.view sendSubviewToBack:self];
            }
        }];
        [UIView animateWithDuration:0.25f animations:^{
            self.maskImageView.layer.transform = CATransform3DTranslate(t, 0, -50, -50);
            self.maskImageView.layer.transform = CATransform3DRotate(t, 7/90.0 * M_PI_2, 1, 0, 0);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25f animations:^{
                self.maskImageView.layer.transform = CATransform3DTranslate(t, 0, 0, 0);
            }];
        }];
    } else {
        self.closeControl.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.25f animations:^{
            self.maskImageView.alpha = 1;
            self.contentView.frame = CGRectMake(0,
                                                self.frame.size.height,
                                                self.contentView.frame.size.width,
                                                self.contentView.frame.size.height);
        } completion:^(BOOL finished) {
            if (self.semiModalViewDidCloseBlock) {
                self.semiModalViewDidCloseBlock();
            }
            if (self.baseViewController) {
                [self.baseViewController.view sendSubviewToBack:self];
                if (self.baseViewController.navigationController) {
                    self.baseViewController.navigationController.navigationBarHidden = NO;
                }
            }
        }];
    }
}

- (void)transNavigationBarToHide:(BOOL)hide
{
    if (hide) {
        CGRect frame = self.baseViewController.navigationController.navigationBar.frame;
        [self setNavigationBarOriginY:-frame.size.height animated:NO];
    } else {
        [self setNavigationBarOriginY:[self statusBarHeight] animated:NO];
    }
}

- (void)setNavigationBarOriginY:(CGFloat)y animated:(BOOL)animated
{
    CGFloat statusBarHeight         = [self statusBarHeight];
    UIWindow *appKeyWindow          = [UIApplication sharedApplication].keyWindow;
    UIView *appBaseView             = appKeyWindow.rootViewController.view;
    CGRect viewControllerFrame      = [appBaseView convertRect:appBaseView.bounds toView:appKeyWindow];
    CGFloat overwrapStatusBarHeight = statusBarHeight - viewControllerFrame.origin.y;
    CGRect frame                    = self.baseViewController.navigationController.navigationBar.frame;
    frame.origin.y                  = y;
    CGFloat navBarHiddenRatio       = overwrapStatusBarHeight > 0 ? (overwrapStatusBarHeight - frame.origin.y) / overwrapStatusBarHeight : 0;
    CGFloat alpha                   = MAX(1.f - navBarHiddenRatio, 0.000001f);
    [UIView animateWithDuration:animated ? 0.1 : 0 animations:^{
        self.baseViewController.navigationController.navigationBar.frame = frame;
        NSUInteger index = 0;
        for (UIView *view in self.baseViewController.navigationController.navigationBar.subviews) {
            index++;
            if (index == 1 || view.hidden || view.alpha <= 0.0f) continue;
            view.alpha = alpha;
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            UIColor *tintColor = self.baseViewController.navigationController.navigationBar.tintColor;
            if (tintColor) {
                self.baseViewController.navigationController.navigationBar.tintColor = [tintColor colorWithAlphaComponent:alpha];
            }
        }
    }];
}

- (CGFloat)statusBarHeight
{
    CGSize statuBarFrameSize = [UIApplication sharedApplication].statusBarFrame.size;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        return statuBarFrameSize.height;
    }
    return UIInterfaceOrientationIsPortrait(self.baseViewController.interfaceOrientation) ? statuBarFrameSize.height : statuBarFrameSize.width;
}

- (void)contentViewHeight:(float)height
{
    if (height > [UIScreen mainScreen].bounds.size.height) {
        height = [UIScreen mainScreen].bounds.size.height;
    }
    self.contentView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, height);
}

- (CGRect)contentViewFrameWithSize:(CGSize)size
{
    if (size.height > [UIScreen mainScreen].bounds.size.height) {
        size.height = [UIScreen mainScreen].bounds.size.height;
    }
    if (size.width > [UIScreen mainScreen].bounds.size.width) {
        size.width = [UIScreen mainScreen].bounds.size.width;
    }
    return CGRectMake(0, self.frame.size.height, self.frame.size.width, size.height);
}

- (id)initWithSize:(CGSize)size andBaseViewController:(UIViewController *)baseViewController
{
    if (self = [super init]) {
        self.frame           = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.maskImageView];
        [self addSubview:self.closeControl];
        [self addSubview:self.contentView];
        self.contentView.frame  = [self contentViewFrameWithSize:size];
        self.baseViewController = baseViewController;
        if (baseViewController) {
            [baseViewController.view insertSubview:self atIndex:0];
            [baseViewController.view sendSubviewToBack:self];
        }
    }
    return self;
}

#pragma mark - lazy loads 📌
- (UIView *)contentView
{
    if (!_contentView) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    self.frame.size.height,
                                                                    self.frame.size.width,
                                                                    self.frame.size.height)];
        contentView.backgroundColor = [UIColor whiteColor];
        self.contentView = contentView;
    }
    return _contentView;
}

- (UIControl *)closeControl
{
    if (!_closeControl) {
        UIControl *closeControl             = [[UIControl alloc] initWithFrame:self.bounds];
        closeControl.userInteractionEnabled = NO;
        closeControl.backgroundColor        = [UIColor clearColor];
        [closeControl addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        self.closeControl = closeControl;
    }
    return _closeControl;
}

- (UIImageView *)maskImageView
{
    if (!_maskImageView) {
        self.maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           self.frame.size.width,
                                                                           self.frame.size.height)];
    }
    return _maskImageView;
}

@end
