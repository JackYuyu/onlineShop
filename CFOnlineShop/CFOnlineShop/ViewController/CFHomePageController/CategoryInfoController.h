//
//  CategoryInfoController.h
//  CFOnlineShop
//
//  Created by app on 2019/5/23.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryInfoController : CFBaseController
@property (nonatomic, strong) UICollectionView *collectionView;
/**
 *  记录当前点击的indexPath
 */
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@end

NS_ASSUME_NONNULL_END
