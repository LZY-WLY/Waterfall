//
//  LZYShopCell.m
//  Waterfall
//
//  Created by LZY on 17/2/21.
//  Copyright © 2017年 LZY. All rights reserved.
//

#import "LZYShopCell.h"
#import "LZYShopModle.h"
#import <UIImageView+WebCache.h>

@interface LZYShopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation LZYShopCell

- (void)setShop:(LZYShopModle *)shop {
    _shop = shop;
    
    // 1.图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    // 2.价格
    self.priceLabel.text = shop.price;
}

@end
