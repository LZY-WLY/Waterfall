//
//  LZYShopLayout.h
//  Waterfall
//
//  Created by LZY on 17/2/20.
//  Copyright © 2017年 LZY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LZYShopLayout;
@protocol LZYShopLayoutDelegate <NSObject>
@required
/**
 计算item的高度
 */
- (CGFloat)shopLayout:(LZYShopLayout *)shopLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
/**
  列数
*/
- (CGFloat)columnCountInShopLayout:(LZYShopLayout *)shopLayout;
/**
  列与列的间距
*/
- (CGFloat)columnMarginInShopLayout:(LZYShopLayout *)shopLayout;
/**
    行与行的间距
*/
- (CGFloat)rowMarginInShopLayout:(LZYShopLayout *)shopLayout;
/**
  边缘的间距
*/
- (UIEdgeInsets)edgeInsetsInShopLayout:(LZYShopLayout *)shopLayout;
@end


@interface LZYShopLayout : UICollectionViewLayout
///代理
@property (nonatomic, weak) id<LZYShopLayoutDelegate> delegate;
@end
