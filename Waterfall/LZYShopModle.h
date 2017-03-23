//
//  LZYShopModle.h
//  Waterfall
//
//  Created by LZY on 17/2/21.
//  Copyright © 2017年 LZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZYShopModle : NSObject
///宽度
@property (nonatomic, assign) CGFloat w;
///高度
@property (nonatomic, assign) CGFloat h;
///图片
@property (nonatomic, copy) NSString *img;
///价格
@property (nonatomic, copy) NSString *price;

@end
