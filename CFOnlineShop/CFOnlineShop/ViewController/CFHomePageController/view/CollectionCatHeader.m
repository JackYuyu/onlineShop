//
//  CollectionCatHeader.m
//  CFOnlineShop
//
//  Created by app on 2019/5/23.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "CollectionCatHeader.h"
#import "SDCycleScrollView.h"

@implementation CollectionCatHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *array = @[@"catcommodity_6"];
        CGRect a=CGRectMake(0, TopHeight, Main_Screen_Width, Main_Screen_Width/16*7);
        //本地加载图片的轮播器
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.frame imageNamesGroup:array];
        cycleScrollView.backgroundColor = kWhiteColor;
        cycleScrollView.autoScrollTimeInterval = 3;
        cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        cycleScrollView.currentPageDotColor = kRedColor;
        cycleScrollView.autoScroll=false;
        [self addSubview:cycleScrollView];
        
    }
    return self;
}
@end
