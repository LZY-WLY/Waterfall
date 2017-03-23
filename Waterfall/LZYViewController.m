//
//  LZYViewController.m
//  Waterfall
//
//  Created by LZY on 17/2/20.
//  Copyright © 2017年 LZY. All rights reserved.
//

#import "LZYViewController.h"
#import "LZYShopLayout.h"
#import "LZYShopModle.h"
#import "LZYShopCell.h"
#import <MJExtension.h>
#import <MJRefresh.h>
@interface LZYViewController ()<UICollectionViewDataSource, LZYShopLayoutDelegate>
/** 所有的商品数据 */
@property (nonatomic, strong) NSMutableArray *shops;

@property (nonatomic, weak) UICollectionView *collectionView;

@end

static NSString * const LZYShopId = @"shop";
@implementation LZYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLayout];
    
    [self setupRefresh];
}
- (void)setupRefresh
{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
}

- (void)loadNewShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.shops = [LZYShopModle mj_objectArrayWithFilename:@"1.plist"];
        // 刷新数据
        [self.collectionView reloadData];
        
        [self.collectionView.mj_header endRefreshing];
    });
}

- (void)loadMoreShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [LZYShopModle mj_objectArrayWithFilename:@"1.plist"];
        [self.shops addObjectsFromArray:shops];
        
        // 刷新数据
        [self.collectionView reloadData];
        
        [self.collectionView.mj_footer endRefreshing];
    });
}
- (void)setupLayout
{
    // 创建布局
    LZYShopLayout *layout = [[LZYShopLayout alloc] init];
    layout.delegate = self;
    
    // 创建CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    // 注册
    [collectionView registerNib:[UINib nibWithNibName:@"LZYShopCell" bundle:nil] forCellWithReuseIdentifier:LZYShopId];
    
    self.collectionView = collectionView;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    collectionView.mj_footer.hidden = (self.shops.count == 0);
    
    return self.shops.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LZYShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LZYShopId forIndexPath:indexPath];
    
    cell.shop = self.shops[indexPath.item];
    
    return cell;
}
#pragma mark LZYShopLayoutDelegate
- (CGFloat)shopLayout:(LZYShopLayout *)shopLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
   LZYShopModle *shop = self.shops[index];
    return itemWidth * shop.h / shop.w;
}
@end
