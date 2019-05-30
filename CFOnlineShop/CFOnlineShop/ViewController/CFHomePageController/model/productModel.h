//
//  productModel.h
//  CFOnlineShop
//
//  Created by app on 2019/5/29.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "FSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface productModel : FSBaseModel
@property (nonatomic, copy) NSString * productName;
@property (nonatomic, copy) NSString * oldPrice;
@property (nonatomic, copy) NSString * evaluateCount;
//@property (nonatomic, copy) NSString * description;
@property (nonatomic, copy) NSString * logo;
@property (nonatomic, copy) NSString * productId;
@property (nonatomic, copy) NSString * goodsSkuId;

@end

NS_ASSUME_NONNULL_END
