//
//  FSSettlementViewController.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/1.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "CFBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSSettlementViewController : CFBaseController

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (assign , nonatomic)NSString *lastNum;

@end

NS_ASSUME_NONNULL_END
