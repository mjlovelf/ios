//
//  GCDMainViewController.m
//  DesignDemo
//
//  Created by mjbest on 17/7/4.
//  Copyright © 2017年 majian. All rights reserved.
//
/*
 Grand Central Dispatch支持以下dispatch source：

 Timer dispatch source：定期产生通知

 Signal dispatch source：UNIX信号到达时产生通知

 Descriptor dispatch source：各种文件和socket操作的通知

 数据可读

 数据可写

 文件在文件系统中被删除、移动、重命名

 文件元数据信息改变

 Process dispatch source：进程相关的事件通知

 当进程退出时

 当进程发起fork或exec等调用

 信号被递送到进程

 Mach port dispatch source：Mach相关事件的通知

 Custom dispatch source：你自己定义并自己触发
 */

#import "GCDMainViewController.h"
static NSString *cellIdentifier = @"GCDMainCell";

@interface GCDMainViewController (){

    NSMutableArray *p_dataAry;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation GCDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    self.title = @"GCD";
    [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    p_dataAry = [NSMutableArray arrayWithObjects:@"getGlobalQueue",@"sourcequeue", nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)importGCDMethod{
    //dispatch_queue_create(<#const char * _Nullable label#>, <#dispatch_queue_attr_t  _Nullable attr#>)
    //dispatch_get_global_queue(<#long identifier#>, <#unsigned long flags#>)
    // dispatch_get_main_queue()
}

#pragma mark - Navigation
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
        case 0:
        {
            [self getGlobalQueue];

        }
            break;
        case 1:
        {
            [self useDispatchSourceQueue];

        }
            break;

        default:
            break;
    }
}
#pragma mark - gcd method


/**
 我们需要同时执行多个任务时，并发队列是非常有用的。并发队列其实仍然还是一个队列，
 它保留了队列中的任务按先进先出(FIFO)的顺序执行的特点。同时，一个并发队列可以移除t它多余的任务，
 甚至这些任务之前还有未完成的任务。一个并发队列中实际执行的任务数是由很多因素决定的，比如系统的内核数，
 其他串行队列中任务的优先级，以及其他进程的工作状态。系统为每个程序提供了四种全局队列，这些队列中仅仅通过优先级加以区别，
 这四种类型分别是高、中(默认)、低、后台。因为这些队列是全局的，所以大家不能直接创建它们,通过dispatch_get_global_queue这个方法来调用它们
 */
-(void)getGlobalQueue{


    /**
     //全局队列的四种类型
     DISPATCH_QUEUE_PRIORITY_HIGH
     DISPATCH_QUEUE_PRIORITY_DEFAULT
     DISPATCH_QUEUE_PRIORITY_LOW
     DISPATCH_QUEUE_PRIORITY_BACKGROUND被设置成后台级别的队列，它会等待所有比它级别高的队列中的任务执行完或CPU空闲的时候才会执行自己的任务
     */
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"getGlobalQueue =%@",aQueue);


}

- (void)createSerializationAndConcurrentDispatch{


    /**
     创建串行队列
     "com.majian.serialization" A string label to attach to the queue.
     NULL NULL的时候默认代表串行。
     */
    dispatch_queue_t serialQueue =  dispatch_queue_create("com.majian.serialization", NULL);

    /**
     创建并行队列
     "com.majian.concurrent"  A string label to attach to the queue.
     DISPATCH_QUEUE_CONCURRENT 设置为并行
     */
    dispatch_queue_t concurrent = dispatch_queue_create("com.majian.concurrent", DISPATCH_QUEUE_CONCURRENT);

    //异步执行
    dispatch_async(serialQueue, ^{

    });
    //同步执行，会导致堵塞
    dispatch_sync(serialQueue, ^{

    });
}
//当需要挂起队列时，使用dispatch_suspend方法；恢复队列时，使用dispatch_resume方法
//NOTE：执行挂起操作不会对已经开始执行的任务起作用，它仅仅只会阻止将要进行但是还未开始的任务。


- (void)useDispatchGroupWait{

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    // 添加队列到组中
    dispatch_group_async(group, queue, ^{
        // 一些异步操作
    });
    //如果在所有任务完成前超时了，该函数会返回一个非零值。
    //你可以对此返回值做条件判断以确定是否超出等待周期；
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    // 不需要group后将做释放操作

}


/**
 dispatch_group_notify。它以异步的方式工作，
 当 Dispatch Group中没有任何任务时，它就会执行其代码，那么 completionBlock便会运行
 */
- (void)useDispatchGroupNotify{

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    // 添加队列到组中
    dispatch_group_async(group, queue, ^{
        // 一些异步操作
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        if (completionBlock) {
//            completionBlock(error);
//        }
    });
}

/**
 使用sourcequeue处理事件
 */
- (void)useDispatchSourceQueue{

   dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    //leeway是指精确程度
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        //do something end
        dispatch_source_cancel(timer);
    });
    dispatch_resume(timer);
}
@end
