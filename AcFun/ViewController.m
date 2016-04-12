//
//  ViewController.m
//  AcFun
//
//  Created by 陈 on 16/1/28.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <SDCycleScrollView.h>
#import "MainModle.h"
#import "contents.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "KCollectionViewFlowLayout.h"
@interface ViewController ()<SDCycleScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong)  UICollectionView *collection;

@property (nonatomic ,strong)  NSMutableArray *imagesArray;

@property (nonatomic ,strong)  NSIndexPath *indexPath;


@end

@implementation ViewController

- (NSMutableArray *)imagesArray {
    if (_imagesArray == nil) {
        _imagesArray = [[NSMutableArray alloc] init];
    }
    return _imagesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 180);
    
    SDCycleScrollView *cycleScrollView = [[SDCycleScrollView alloc] init];
    cycleScrollView.frame = frame;
    [self.view addSubview:cycleScrollView];
    
    
//      http://api.aixifan.com/regions
//      User-Agent	AcFun/4.1.0 (iPhone; iOS 9.1; Scale/2.00)
//      resolution	640x1136
//      market	appstore
//      deviceType	0
//      If-Modified-Since	Wed, 27 Jan 2016 08:58:15 GMT
//      If-None-Match	"4a65b2a5-c480-4e24-ad2b-43d7d090c57b"
//      Connection	keep-alive
//      udid	D8AD022A-33E8-4167-BD25-3AFCC407D64F
//      productId	2000
//      appVersion	4.1.0
    
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    
    [mgr.requestSerializer setValue:@"AcFun/4.1.0 (iPhone; iOS 9.1; Scale/2.00)" forHTTPHeaderField:@"User-Agent"];
    [mgr.requestSerializer setValue:@"640x1136" forHTTPHeaderField:@"resolution"];
    [mgr.requestSerializer setValue:@"appstore" forHTTPHeaderField:@"market"];
    [mgr.requestSerializer setValue:@"0" forHTTPHeaderField:@"deviceType"];
    [mgr.requestSerializer setValue:@"Wed, 27 Jan 2016 08:58:15 GMT" forHTTPHeaderField:@"If-Modified-Since"];
    [mgr.requestSerializer setValue:@"4a65b2a5-c480-4e24-ad2b-43d7d090c57b" forHTTPHeaderField:@"If-None-Match"];
    [mgr.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    [mgr.requestSerializer setValue:@"D8AD022A-33E8-4167-BD25-3AFCC407D64F" forHTTPHeaderField:@"udid"];
    [mgr.requestSerializer setValue:@"2000" forHTTPHeaderField:@"productId"];
    [mgr.requestSerializer setValue:@"4.1.0" forHTTPHeaderField:@"appVersion"];



    
    [mgr GET:@"http://api.aixifan.com/regions" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        
        
        
        [MainModle mj_setupObjectClassInArray:^NSDictionary *{
            return@{ @"contents" : [contents class] };
        }];
        
        NSArray * data = responseObject[@"data"];
        NSMutableArray * result = [NSMutableArray array];
        
        for ( NSDictionary * dict in data ) {
            MainModle *mainList = [MainModle mj_objectWithKeyValues:dict];
            
//            NSLog(@"name : %@    count : %ld ",mainList.name,[mainList.contents count]);
            
            [result addObject:mainList];
        }
        
        
        
        NSMutableArray * images = [NSMutableArray array];
        NSMutableArray * titles = [NSMutableArray array];

        MainModle * top = [result objectAtIndex:0];
        NSArray * contentArray = top.contents;
        
        
        for (contents * cont in contentArray) {

            [images addObject:[NSURL URLWithString:cont.image]];
            [titles addObject:cont.title];
        }
        
        [self setImagesArrayWithResult:result];
        [self.collection reloadData];
        
        cycleScrollView.imageURLStringsGroup = images;
        cycleScrollView.titlesGroup = titles;
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    KCollectionViewFlowLayout *flow = [[KCollectionViewFlowLayout alloc] init];

    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    flow.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 50);
    self.collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height-180) collectionViewLayout:flow];
    
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.view addSubview:self.collection];
    
    self.collection.backgroundColor = [UIColor whiteColor];
    [self.collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];


    
}

- (void)setImagesArrayWithResult:(NSMutableArray *)result {
    

    
    for (int i = 1; i < 16; i++) {

    NSMutableArray * images = [NSMutableArray array];
    NSMutableArray * titles = [NSMutableArray array];
    
    MainModle * section = [result objectAtIndex:i];
    NSArray * contentArray = section.contents;
    
    
    for (contents * cont in contentArray) {

        [images addObject:[NSURL URLWithString:cont.image]];
        [titles addObject:cont.title];

    }
    if (i==1 | i==3 ) {
        [self.imagesArray addObject:images];
    }

        
    }
    
    if ([self.imagesArray count]>0) {

        NSLog(@" count %ld",(unsigned long)[_imagesArray count]);

//        [self.collection reloadData];
    }
}

#pragma make collectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    NSLog(@" count %ld",self.indexPath.section);

    return [self.imagesArray[section] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identify = @"cell";


    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"nil cell 无法创建");
    }
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    UIImageView * imageView = [[UIImageView alloc] init];

    if (indexPath.section == 1) {
        imageView.frame = CGRectMake(0, 0, (self.view.frame.size.width-40)/3,120);
    }else {
        imageView.frame = CGRectMake(0, 0, (self.view.frame.size.width-30)/2,100);
    }
    
    [imageView sd_setImageWithURL:self.imagesArray[indexPath.section][indexPath.row] placeholderImage:[UIImage imageNamed:@"holder.jpg"]];
    
    [cell.contentView addSubview:imageView];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UIView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
        view.backgroundColor = [UIColor redColor];
        return (UICollectionReusableView *)view;
    }
    return nil;
}

#pragma every cell item size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return CGSizeMake((self.view.frame.size.width-40)/3,120);
    }else {
        return CGSizeMake((self.view.frame.size.width-30)/2,100);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 100;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10;
//}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)bookList{
    
    NSLog(@"1");

    
    
//    curl
//    -H "Host: api.zhuishushenqi.com"
    
//    -H "X-Device-Id: 631cf212b409f949264fad9ba1ba1daa"
//    -H "Accept: */*"
//    -H "Accept-Language: zh-Hans-CN;q=1, en-CN;q=0.9"
    
//    -H "X-User-Agent: YouShaQi/2.23.2 (iPhone; iOS 9.1; Scale/2.00)"
//    -H "User-Agent: YouShaQi/2.23.2 (iPhone; iOS 9.1; Scale/2.00)"
//    --compressed
//    http://api.zhuishushenqi.com/book?view=updated&id=5108725a7a2138ed06000001,53e56ee335f79bb626a496c9,53115e30173bfacb4904897e,567d2cb9ee0e56bc713cb2c0,5510f8a79a365b2749dd6f9d,50975b961db679b876000029,526e8e3e7cfc087140004df7,52567a4b8515ae761f0019d9,5091ece08d834c0f19000070,54041c06460501ce66533196,50ade17a5da9cfc663000139,539015b74f85f9f037d6abaa,53833d44c1e9745616015fce,50874973abf1ced53c000041,50ac662fde1233e062000001,50d93de1ab38ee5d3d000003
    
//    NSString * urlstr = @"http://api.zhuishushenqi.com/book?view=updated&id=5108725a7a2138ed06000001,53e56ee335f79bb626a496c9,53115e30173bfacb4904897e,567d2cb9ee0e56bc713cb2c0,5510f8a79a365b2749dd6f9d,50975b961db679b876000029,526e8e3e7cfc087140004df7,52567a4b8515ae761f0019d9,5091ece08d834c0f19000070,54041c06460501ce66533196,50ade17a5da9cfc663000139,539015b74f85f9f037d6abaa,53833d44c1e9745616015fce,50874973abf1ced53c000041,50ac662fde1233e062000001,50d93de1ab38ee5d3d000003";
//    
    NSURL * url = [NSURL URLWithString:@"http://api.zhuishushenqi.com/book?view=updated&id=5108725a7a2138ed06000001,53e56ee335f79bb626a496c9,53115e30173bfacb4904897e,567d2cb9ee0e56bc713cb2c0,5510f8a79a365b2749dd6f9d,50975b961db679b876000029,526e8e3e7cfc087140004df7,52567a4b8515ae761f0019d9,5091ece08d834c0f19000070,54041c06460501ce66533196"];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"GET";
    
    [request setValue:@"X-Device-Id" forHTTPHeaderField:@"980bbc45086bb5d87a88ca9adff2890c"];
//    [request setValue:@"X-User-Agent" forHTTPHeaderField:@"YouShaQi/2.23.2 (iPhone; iOS 9.1; Scale/2.00)"];
//    [request setValue:@"User-Agent" forHTTPHeaderField:@"YouShaQi/2.23.2 (iPhone; iOS 9.1; Scale/2.00)"];
    
//    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    
//    
//    
//    NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"str  -----   %@",str);
    
    
    
//    [{"_id":"5108725a7a2138ed06000001","author":"蛊真人","referenceSource":"sogou","updated":"2016-01-28T12:30:51.369Z","chaptersCount":1078,"lastChapter":"第三波净网活动开始了。","latelyFollower":0,"retentionRatio":null},{"_id":"53e56ee335f79bb626a496c9","author":"厌笔萧生","referenceSource":"sogou","updated":"2016-01-28T10:07:12.229Z","chaptersCount":1496,"lastChapter":"第1479章入轮回谷","latelyFollower":0,"retentionRatio":null},{"_id":"53115e30173bfacb4904897e","author":"烟雨江南","referenceSource":"sogou","updated":"2016-01-27T15:48:01.136Z","chaptersCount":726,"lastChapter":"章三十五 加餐","latelyFollower":0,"retentionRatio":null},{"_id":"567d2cb9ee0e56bc713cb2c0","author":"忘语","referenceSource":"default","updated":"2016-01-28T11:21:40.211Z","chaptersCount":45,"lastChapter":"第四十四章 玄子令","latelyFollower":0,"retentionRatio":null},{"_id":"5510f8a79a365b2749dd6f9d","author":"黑山老鬼","referenceSource":"sogou","updated":"2016-01-28T10:55:59.269Z","chaptersCount":703,"lastChapter":"第七百零一章 让你神州无正统！","latelyFollower":0,"retentionRatio":null},{"_id":"50975b961db679b876000029","author":"烽火戏诸侯","referenceSource":"sogou","updated":"2016-01-28T10:10:37.016Z","chaptersCount":901,"lastChapter":"第三百三十二章 满架刀","latelyFollower":0,"retentionRatio":null},{"_id":"526e8e3e7cfc087140004df7","author":"太一生水","referenceSource":"sogou","updated":"2016-01-28T08:28:37.547Z","chaptersCount":1982,"lastChapter":"第1978章 紫金雷劫丹","latelyFollower":0,"retentionRatio":null},{"_id":"52567a4b8515ae761f0019d9","author":"缘分0","referenceSource":"sogou","updated":"2016-01-28T01:08:01.666Z","chaptersCount":1046,"lastChapter":"第六十五章 硬撼","latelyFollower":0,"retentionRatio":null},{"_id":"5091ece08d834c0f19000070","author":"天下飘火","referenceSource":"sogou","updated":"2016-01-27T16:01:58.282Z","chaptersCount":1480,"lastChapter":"第一千四百六十三章 星际计划","latelyFollower":0,"retentionRatio":null},{"_id":"54041c06460501ce66533196","author":"无罪","referenceSource":"sogou","updated":"2016-01-28T14:27:50.477Z","chaptersCount":556,"lastChapter":"第三十九章 受死","latelyFollower":0,"retentionRatio":null},{"_id":"50ade17a5da9cfc663000139","author":"何不语","referenceSource":"sogou","updated":"2016-01-12T09:39:56.511Z","chaptersCount":1210,"lastChapter":"大结局（全书完）","latelyFollower":0,"retentionRatio":null},{"_id":"539015b74f85f9f037d6abaa","author":"冰临神下","referenceSource":"sogou","updated":"2015-12-22T13:30:54.084Z","chaptersCount":1141,"lastChapter":"第一千一百一十一章 下降","latelyFollower":0,"retentionRatio":null},{"_id":"53833d44c1e9745616015fce","author":"无极书虫","referenceSource":"sogou","updated":"2015-12-18T08:23:59.831Z","chaptersCount":1269,"lastChapter":"后记","latelyFollower":0,"retentionRatio":null},{"_id":"50874973abf1ced53c000041","author":"管平潮","referenceSource":"sogou","updated":"2015-10-31T17:57:01.994Z","chaptersCount":470,"lastChapter":"第二十一卷 『人间仙路几烟尘』 第二十九章 仙路不知行远近，人生若只初相识（完）","latelyFollower":0,"retentionRatio":null},{"_id":"50ac662fde1233e062000001","author":"减肥专家","referenceSource":"sogou","updated":"2015-07-09T04:03:36.359Z","chaptersCount":1811,"lastChapter":"尾声 生死当下 继往开来","latelyFollower":0,"retentionRatio":null},{"_id":"50d93de1ab38ee5d3d000003","author":"冰临神下","referenceSource":"sogou","updated":"2014-07-12T17:12:30.434Z","chaptersCount":1220,"lastChapter":"新书《拔魔》","latelyFollower":0,"retentionRatio":null}]
    
    
    
//    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
//    [mgr.requestSerializer setValue:@"X-Device-Id" forHTTPHeaderField:@"631cf212b409f949264fad9ba1ba1daa"];
//    [mgr.requestSerializer setValue:@"X-Device-Id" forHTTPHeaderField:@"980bbc45086bb5d87a88ca9adff2890c"];
//    [mgr.requestSerializer setValue:@"X-User-Agent" forHTTPHeaderField:@"YouShaQi/2.23.2 (iPhone; iOS 9.1; Scale/2.00)"];
//    [mgr.requestSerializer setValue:@"User-Agent" forHTTPHeaderField:@"YouShaQi/2.23.2 (iPhone; iOS 9.1; Scale/2.00)"];
//    [mgr.requestSerializer setValue:@"Connection" forHTTPHeaderField:@"keep-alive"];


//    NSDictionary * dict = @{@"id":@"5108725a7a2138ed06000001,53e56ee335f79bb626a496c9,53115e30173bfacb4904897e,567d2cb9ee0e56bc713cb2c0,5510f8a79a365b2749dd6f9d,50975b961db679b876000029,526e8e3e7cfc087140004df7,52567a4b8515ae761f0019d9,5091ece08d834c0f19000070,54041c06460501ce66533196,50ade17a5da9cfc663000139,539015b74f85f9f037d6abaa,53833d44c1e9745616015fce,50874973abf1ced53c000041,50ac662fde1233e062000001,50d93de1ab38ee5d3d000003",@"view":@"updated"};
//    
//curl -H "Host: api.zhuishushenqi.com" -H "X-Device-Id: 980bbc45086bb5d87a88ca9adff2890c" -H "Accept: */*" -H "Accept-Language: zh-Hans-CN;q=1, en-CN;q=0.9" -H "X-User-Agent: YouShaQi/2.24.10 (iPhone; iOS 9.1; Scale/2.00)" -H "User-Agent: YouShaQi/2.24.10 (iPhone; iOS 9.1; Scale/2.00)" --compressed http://api.zhuishushenqi.com/book/recommend?gender=male
    
//    NSDictionary * param = @{@"gender":@"male"};
//    
//    [mgr GET:@"http://api.zhuishushenqi.com/book/recommend" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"book : %@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
//    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
