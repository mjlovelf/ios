//
//  RunLoopStudyViewController.m
//  DesignDemo
//
//  Created by mjbest on 17/6/16.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "RunLoopStudyViewController.h"

static const NSInteger TIMER_INTERVAL = 1;
static NSString *cellIdentifier = @"testCell";


@interface RunLoopStudyViewController (){

    NSInteger currentNumber;
    NSTimer *timer;
    NSMutableArray *p_dataAry;
    dispatch_queue_t p_queue;
    NSUInteger test;
    int i ;
    CFRunLoopObserverRef observer;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RunLoopStudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    self.title = @"RunLoop中观察者";
    // Do any additional setup after loading the view from its nib.
    _titleLabel.text = 0;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    p_dataAry = [NSMutableArray arrayWithCapacity:1];
    for (int k = 0; k<200; k++) {
        [p_dataAry addObject:[NSString stringWithFormat:@"这是第%zd",k]];
    }
    [self runloopObserver];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (observer) {
        CFRelease(observer);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)startTimerWithTimeInterval{
    timer =  [NSTimer timerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(timerWithTimeIntervalResult) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    //    [timer fire];
}
- (void)startScheduledTimerWithTimeInterval{
    timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(timerWithTimeIntervalResult) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    //        [timer fire];
}
//用途：监听线程点runloop变化，可以在一些状态下做一些特殊处理，比如计算高度
//http://blog.sunnyxx.com/2015/05/17/cell-height-calculation/

- (void)runloopObserver{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    /*observer对象的内存
     obersver关注事件
     是第一次进入runloop还剩每次进入runLoop
     设置优先级别
     设置
     */
    observer = CFRunLoopObserverCreateWithHandler
    (kCFAllocatorDefault, kCFRunLoopAllActivities, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity _aaa) {
        i ++;
        switch (_aaa) {
            case kCFRunLoopEntry:
                NSLog(@"即将进入runloop");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"即将处理timer");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"即将处理source");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"即将进入睡眠");
                _titleLabel.text = [NSString stringWithFormat:@"%zd",i];
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"刚从睡眠中唤醒");
                break;
            case kCFRunLoopExit:
                NSLog(@"即将退出");
                break;
            default:
                break;
        }
    });
    CFRunLoopAddObserver(runLoop, observer, kCFRunLoopDefaultMode);
}
-(void)timerWithTimeIntervalResult{


    currentNumber ++;
    _titleLabel.text = @(currentNumber).stringValue;

}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
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

}

@end
