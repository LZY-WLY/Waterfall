//
//  LZYShopLayout.m
//  Waterfall
//
//  Created by LZY on 17/2/20.
//  Copyright © 2017年 LZY. All rights reserved.
//

#import "LZYShopLayout.h"

//默认的列数
static NSInteger const LZYDefaultColumnCount = 3;
//每一列之间的间距
static CGFloat const LZYDefaultColumnMargin = 10;
//每一行之间的间距
static CGFloat const LZYDefaultRowMargin = 10;
//边缘间距
static UIEdgeInsets const LZYDefaultEdgeInsets = {10, 10, 10, 10};

@interface LZYShopLayout ()
///存放所有cell的布局属性
@property (nonatomic, strong) NSMutableArray *attersArray;
///存放所有列的当前高度
@property (nonatomic, strong) NSMutableArray *columnHeights;
   
//声明
- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;
@end


@implementation LZYShopLayout
#pragma mark - 常见数据处理
- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInShopLayout:)]) {
        return [self.delegate rowMarginInShopLayout:self];
    } else {
        return LZYDefaultRowMargin;
    }
}

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInShopLayout:)]) {
        return [self.delegate columnMarginInShopLayout:self];
    } else {
        return LZYDefaultColumnMargin;
    }
}

- (NSInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountInShopLayout:)]) {
        return [self.delegate columnCountInShopLayout:self];
    } else {
        return LZYDefaultColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInShopLayout:)]) {
        return [self.delegate edgeInsetsInShopLayout:self];
    } else {
        return LZYDefaultEdgeInsets;
    }
}
- (NSMutableArray *)attersArray {
    if (!_attersArray) {
        self.attersArray = [NSMutableArray array];
    }
    return _attersArray;
}
- (NSMutableArray *)columnHeights {
    if (!_columnHeights) {
        self.columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}
/**
 准备布局
 */
- (void)prepareLayout {
    [super prepareLayout];
    //清楚之前的数据
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    //清楚之前的数据
    [self.attersArray removeAllObjects];
    //开始创建每一个cell对应的布局属性
    NSInteger nums = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < nums; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *atters = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attersArray addObject:atters];
    }
}
//item的位置数组
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attersArray;
}
//item属性
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes * atters = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    CGFloat attersW = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / 3;
    CGFloat attersH = [self.delegate shopLayout:self heightForItemAtIndex:indexPath.row itemWidth:attersW];
    
    //找出高度最短的那一列
    __block NSInteger destColumn = 0;
    __block CGFloat minColumnHeight = MAXFLOAT;
    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.doubleValue < minColumnHeight) {
            minColumnHeight = obj.doubleValue;
            destColumn = idx;
        }
    }];
    CGFloat attersX = self.edgeInsets.left + destColumn * (attersW + self.columnMargin);
    CGFloat attersY = minColumnHeight + self.rowMargin;
    atters.frame = CGRectMake(attersX, attersY, attersW, attersH);
    
    //跟新最短那列高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(atters.frame));
    return atters;
}
- (CGSize)collectionViewContentSize {
    //找出高度最长的那一列
    __block CGFloat maxColumnHeight = 0;
    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.doubleValue > maxColumnHeight) {
            maxColumnHeight = obj.doubleValue;
        }
    }];
    return CGSizeMake(0, maxColumnHeight);
}
@end
