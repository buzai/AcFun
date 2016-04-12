//
//  DanMuView.m
//  AcFun
//
//  Created by 陈 on 16/1/29.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import "DanMuView.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "DanMuModle.h"
#import "QHDanmuManager.h"
#import "QHDanmuSendView.h"
#import "NSTimer+EOCBlocksSupport.h"
#import <BarrageRenderer.h>
#import <KRVideoPlayerController.h>
@interface DanMuView ()<QHDanmuSendViewDelegate>
@property (nonatomic, strong) QHDanmuManager *danmuManager;
@property (nonatomic, strong) QHDanmuSendView *danmuSendV;
@property (nonatomic) BOOL bPlaying;
@property (weak, nonatomic) IBOutlet UIView *screenV;
@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval countTime;
@property (nonatomic ,strong) KRVideoPlayerController  *videoController;

@end

@implementation DanMuView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BarrageRenderer * render = [[BarrageRenderer alloc] init];
    [self.view addSubview:render.view];
    
    
    
    
    
    self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*(9.0/16.0))];
    
    
    http://api.aixifan.com/plays/650596/realSource
    
    self.videoController.contentURL = [NSURL URLWithString:@"http://vplay.aixifan.com/des/acf-44/650596_mp4/650596_lvbr.mp4?k=4f897eab569a1d48cfbd920d26159791&t=1454087113"];
    //    [self.videoController showInWindow];

    [self.view addSubview:self.videoController.view];
    
//    curl -H "Host: static.comment.acfun.tv" -H "Accept: */*" -H "Accept-Language: zh-Hans-CN;q=1, en-CN;q=0.9" -H "User-Agent: AcFun/4.1.0 (iPhone; iOS 9.1; Scale/2.00)" --compressed http://static.comment.acfun.tv/V2/650596?pageNo=1&pageSize=500
//    // Do any additional setup after loading the view.
    
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    
//    NSDictionary * param = @{@"pageNo":@"1",@"pageSize":@"500"};

    NSMutableArray *tempInfos = [NSMutableArray array];
    [mgr GET:@"http://static.comment.acfun.tv/V2/650596?pageNo=1&pageSize=500" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        for (NSArray * array in responseObject) {
            NSArray *userArray = [DanMuModle mj_objectArrayWithKeyValuesArray:array];
            for (DanMuModle *dan in userArray) {
//                NSLog(@"name=%@ time:%@", dan.m,dan.c);
                NSArray *strarray = [dan.c componentsSeparatedByString:@","];
//                NSLog(@"%@",strarray[0]);
                NSDictionary * dict = @{@"c":dan.m,@"v":strarray[0]};
                [tempInfos addObject:dict];
            }
            NSLog(@"%@",tempInfos);
            
            NSLog(@"%@",tempInfos);
            NSArray *infos = [tempInfos sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                CGFloat v1 = [[obj1 objectForKey:kDanmuTimeKey] floatValue];
                CGFloat v2 = [[obj2 objectForKey:kDanmuTimeKey] floatValue];
                
                NSComparisonResult result = v1 <= v2 ? NSOrderedAscending : NSOrderedDescending;
                
                return result;
            }];
//            tempInfos = nil;
            //    NSLog(@"11111%@", infos);
            
            self.danmuManager = [[QHDanmuManager alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width,200) data:infos inView:self.view durationTime:1];
            
            self.countTime = -1;
            [self.danmuManager initStart];
            
            
            [self start:nil];


        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
//    NSString *path = [[NSBundle mainBundle] bundlePath];
//    path = [[path stringByAppendingPathComponent:@"QHDanmuSource"] stringByAppendingPathExtension:@"plist"];
//    NSArray *tempInfos = [NSArray arrayWithContentsOfFile:path];

    
    
    
    


}
//iOS8旋转动作的具体执行
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition: ^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if ([QHDanmuUtil isOrientationLandscape]) {
            [self p_prepareFullScreen];
        }
        else {
            [self p_prepareSmallScreen];
        }
    } completion: ^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (self.bPlaying)
            [self start:nil];
    }];
    
    [super viewWillTransitionToSize: size withTransitionCoordinator: coordinator];
}

//iOS7旋转动作的具体执行
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIDeviceOrientationLandscapeRight || toInterfaceOrientation == UIDeviceOrientationLandscapeLeft) {
        [self p_prepareFullScreen];
    }
    else {
        [self p_prepareSmallScreen];
    }
    if (self.bPlaying)
        [self start:nil];
}
#pragma mark - Private

- (void)p_destoryTimer {
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}
// 切换成全屏的准备工作
- (void)p_prepareFullScreen {
    [self p_prepare];
}

// 切换成小屏的准备工作
- (void)p_prepareSmallScreen {
    [self p_prepare];
}

//由于这里大小屏无需区分，真正应用场景肯定是要区分的操作的
- (void)p_prepare {
    [self.danmuSendV backAction];
    [self p_destoryTimer];
    BOOL bPlaying = self.bPlaying;
    [self stop:nil];
    self.bPlaying = bPlaying;
    [self.danmuManager resetDanmuWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _screenV.bounds.size.height)];
}
#pragma mark - QHDanmuSendViewDelegate

- (void)sendDanmu:(QHDanmuSendView *)danmuSendV info:(NSString *)info {
    NSDate *now = [NSDate new];
    double t = ((double)now.timeIntervalSince1970);
    t = ((int)t)%1000;
    CGFloat nowTime = self.countTime + t*0.0001;
    [self.danmuManager insertDanmu:@{kDanmuContentKey:info, kDanmuTimeKey:@(nowTime), kDanmuOptionalKey:@"df"}];
    
    if (self.bPlaying)
        [self resume:nil];
}

- (void)closeSendDanmu:(QHDanmuSendView *)danmuSendV {
    if (self.bPlaying)
        [self resume:nil];
}

#pragma mark - Action

- (IBAction)start:(id)sender {
    
    NSLog(@"start ");

    
    [self.danmuManager initStart];
    self.bPlaying = YES;
    
    if ([_timer isValid]) {
        return;
    }
    if (_timer == nil) {
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer eoc_scheduledTimerWithTimeInterval:1 block:^{
            DanMuView *strogSelf = weakSelf;
            [strogSelf progressVideo];
        } repeats:YES];
    }
}

- (IBAction)stop:(id)sender {
    self.bPlaying = NO;
    [self.danmuManager stop];
}

- (IBAction)pause:(id)sender {
    [self p_destoryTimer];
    [self.danmuManager pause];
}

- (IBAction)resume:(id)sender {
    [self.danmuManager resume:_countTime];
    
    [self start:nil];
}

- (IBAction)restart:(id)sender {
    self.countTime = -1;
    [self.danmuManager restart];
    [self p_destoryTimer];
    
    [self start:nil];
}

- (IBAction)send:(id)sender {
    if (self.danmuSendV != nil) {
        self.danmuSendV = nil;
    }
    self.danmuSendV = [[QHDanmuSendView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.danmuSendV];
    self.danmuSendV.deleagte = self;
    [self.danmuSendV showAction:self.view];
    
    if (self.bPlaying)
        [self pause:nil];
}

- (void)progressVideo {
    self.countTime++;
    [_danmuManager rollDanmu:_countTime];
}

- (IBAction)clickScreenView:(id)sender {
#ifdef DEBUG
    NSLog(@"hello world");
#endif
}

#pragma mark - Get

- (void)setCountTime:(NSTimeInterval)countTime {
    _countTime = countTime;
    self.playTimeLabel.text = [NSString stringWithFormat:@"%f", _countTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
