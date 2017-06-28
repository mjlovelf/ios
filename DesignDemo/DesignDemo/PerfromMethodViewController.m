//
//  PerfromMethodViewController.m
//  DesignDemo
//
//  Created by mjbest on 17/6/26.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "PerfromMethodViewController.h"
static NSString *cellIdentifier = @"testCell";
static const NSInteger TIMER_INTERVAL = 1;

@interface PerfromMethodViewController (){

    NSMutableArray *p_dataAry;
    NSInteger currentNumber;
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation PerfromMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    self.title = @"runloop在perform中使用";
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    p_dataAry = [NSMutableArray arrayWithObjects:@"子线程调用主线程",@"子线程调用子线程", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - threadToMain

-(void)startTimerWithTimeInterval{
    timer =  [NSTimer timerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(timerWithTimeIntervalResult) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
-(void)timerWithTimeIntervalResult{

    dispatch_async(dispatch_get_main_queue(), ^{
        currentNumber ++;
        _label.text = @(currentNumber).stringValue;
    });
    for (long long i = 0; i<20000; i++) {
        NSLog(@"我是好人啊");
    }

}
-(void)result{

    NSLog(@"当前模式 ＝%@", [[NSRunLoop currentRunLoop] currentMode]);
    for (long long i = 0; i<12000; i++) {
        NSLog(@"当前i=%lld",i);
    }
}
- (void)asyncPerformToMain{
    [self startTimerWithTimeInterval];
    dispatch_queue_t queue = dispatch_queue_create("test", NULL);

    dispatch_async(queue, ^{
        NSLog(@"当前开始启动线程");
        sleep(2);
        [self performSelectorOnMainThread:@selector(result) withObject:nil waitUntilDone:YES];
    });

}
#pragma mark - method
//主线程中设置的定时器为default方式，通过调用performSelectorOnMainThread方法会将mainthread对应模式更改
- (void)mainTimerWithAsyncPerform{
    dispatch_queue_t queue = dispatch_queue_create("test", NULL);
    NSDictionary *dd = @{@"key":@"dd"};
    NSThread *thread =   [[NSThread alloc]initWithTarget:self selector:@selector(threadTest:) object:dd ];
    [thread start];
    dispatch_async(queue, ^{
        //这里是为了堵塞让子线程执行一定时间，而主线程的定时器已经开始执行
        NSLog(@"执行test子线程");
        NSArray *modes = @[NSRunLoopCommonModes];
        NSDictionary *dsad = @{@"key":@"dsad"};
        [self performSelector:@selector(threadTest:) onThread:thread withObject:dsad waitUntilDone:NO modes:modes];
        sleep(10);//休眠10秒为了证明runloop退出是否有效
        [self performSelector:@selector(threadTest:) onThread:thread withObject:dsad waitUntilDone:NO modes:modes];

    });

}
-(void)threadTest:(NSDictionary *)dd{
    NSLog(@"当前线程=%@",[NSThread currentThread]);
    NSLog(@"当前模式 ＝%@", [[NSRunLoop currentRunLoop] currentMode]);
    if (dd && [dd[@"key"] isEqualToString:@"dd"]) {
        NSLog(@"子线程通过thread启动");
    }
   while (dd && [dd[@"key"] isEqualToString:@"dd"]) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
    }
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopStop(runLoop);
    NSLog(@"线程停止");
    NSLog(@"当前模式 ＝%@", [[NSRunLoop currentRunLoop] currentMode]);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [p_dataAry count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 60.0;
}

-  (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *vv = [[UIView alloc]init];
    vv.backgroundColor = [UIColor clearColor];
    return vv;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = p_dataAry[row];

    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            //主线程有定时器，子线程通过perform方法调到主线程,如果主线程有for循环（正在执行中命令）则调用需要等for执行完成后才会实现
            //如果并没有在执行中的代码，则会马上调用
            [self asyncPerformToMain];
        }
            break;
        case 1:{
            //子线程调用子线程使用[NSRunLoop currentRunLoop]可以保证现场长期存活
            [self mainTimerWithAsyncPerform];
        }
            break;
        default:
            break;
    }
}

@end
