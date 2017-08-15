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
    p_dataAry = [NSMutableArray arrayWithObjects:@"getGlobalQueue",@"sourcequeue",@"dispatchGroup",@"dispatchapply",@"dispatchBarrier", nil];

    [self testDeadLock];

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
        case 2:
        {
            [self dispatchGroup];
        }
            break;
        case 3:
        {
            [self dispatchApply];
        }
            break;
        case 4:{
            [self dispatchBarrier];

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

- (void)testDeadLock{

    dispatch_queue_t serialQueue =  dispatch_queue_create("com.majian.serialization", NULL);
    dispatch_queue_t serialQueue2 =  dispatch_queue_create("com.majian.serialQueue2", NULL);
    dispatch_sync(serialQueue, ^{
        NSLog(@"start");
        //error
//        dispatch_sync(serialQueue, ^{
//            NSLog(@"run serialQueue2");
//
//        });
        NSLog(@"end serialQueue2");

    });
    NSLog(@"end");
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
    //dispatch_walltime 函数来设置定时器dispatch source，则定时器会根据挂钟时间来跟踪,这种定时器比较适合触发间隔相对比较大的场合，可以防止定时器触发间隔出现太大的误差。
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        //do something end
        dispatch_source_cancel(timer);
    });
    dispatch_resume(timer);
}
- (dispatch_source_t) readFileData:(const char*)filename{
    // Prepare the file for reading.
    int fd = open(filename, O_RDONLY);
    if (fd == -1)
        return NULL;
    fcntl(fd, F_SETFL, O_NONBLOCK);// Avoid blocking the read operation
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t readSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ,fd, 0, queue);
    if (!readSource)
    {
        close(fd);
        return NULL;
    }
    // Install the event handler
    dispatch_source_set_event_handler(readSource, ^{
        size_t estimated = dispatch_source_get_data(readSource) + 1;
        // Read the data into a text buffer.
        char* buffer = (char*)malloc(estimated);
        if (buffer)
        {
            ssize_t actual = read(fd, buffer, (estimated));
            // Boolean done = MyProcessFileData(buffer, actual);  // Process the data.

            // Release the buffer when done.
            free(buffer);

            // If there is no more data, cancel the source.
            // if (done)
            dispatch_source_cancel(readSource);
        }
    });

    // Install the cancellation handler
    dispatch_source_set_cancel_handler(readSource, ^{close(fd);});
    dispatch_resume(readSource);
    return readSource;
}

- (dispatch_source_t) WriteDataToFile:(const char*)filename
{
    int fd = open(filename, O_WRONLY | O_CREAT | O_TRUNC,
                  (S_IRUSR | S_IWUSR | S_ISUID | S_ISGID));
    if (fd == -1)
        return NULL;
    fcntl(fd, F_SETFL); // Block during the write.

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t writeSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_WRITE,
                                                           fd, 0, queue);
    if (!writeSource)
    {
        close(fd);
        return NULL;
    }

    dispatch_source_set_event_handler(writeSource, ^{
        //   size_t bufferSize = MyGetDataSize();
        //  void* buffer = malloc(bufferSize);

        //   size_t actual = MyGetData(buffer, bufferSize);
        //  write(fd, buffer, actual);

        // free(buffer);

        // Cancel and release the dispatch source when done.
        dispatch_source_cancel(writeSource);
    });

    dispatch_source_set_cancel_handler(writeSource, ^{close(fd);});
    dispatch_resume(writeSource);
    return (writeSource);
}
//监控文件系统对象设置一个 DISPATCH_SOURCE_TYPE_VNODE 类型
//的dispatch source，你可以从这个dispatch source中接收文件删除、
//写入、重命名等通知。你还可以得到文件的特定元数据信息变化通知。
-(dispatch_source_t) MonitorNameChangesToFile:(const char* )filename
{
    int fd = open(filename, O_EVTONLY);
    if (fd == -1)
        return NULL;

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
                                                      fd, DISPATCH_VNODE_RENAME, queue);
    if (source)
    {
        // Copy the filename for later use.
        long length = strlen(filename);
        char* newString = (char*)malloc(length + 1);
        newString = strcpy(newString, filename);
        dispatch_set_context(source, newString);

        // Install the event handler to process the name change
        dispatch_source_set_event_handler(source, ^{
            const char*  oldFilename = (char*)dispatch_get_context(source);
            //       MyUpdateFileName(oldFilename, fd);
        });

        // Install a cancellation handler to free the descriptor
        // and the stored string.
        dispatch_source_set_cancel_handler(source, ^{
            char* fileStr = (char*)dispatch_get_context(source);
            free(fileStr);
            close(fd);
        });

        // Start processing events.
        dispatch_resume(source);
    }
    else
        close(fd);

    return source;
}
//监测信号
//如不可恢复的错误(非法指令)、或重要信息的通知(如子进程退出)。传统编程中，
//应用使用 sigaction 函数安装信号处理器函数，信号到达时同步处理信号。如果你只
//是想信号到达时得到通知，并不想实际地处理该信号，可以使用信号dispatch source来异步处理信号。
//配置信号dispatch source来处理SIGHUP信号
void InstallSignalHandler()
{
    // Make sure the signal does not terminate the application.
    signal(SIGHUP, SIG_IGN);

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_SIGNAL, SIGHUP, 0, queue);

    if (source)
    {
        dispatch_source_set_event_handler(source, ^{
            //     MyProcessSIGHUP();
        });

        // Start processing signals
        dispatch_resume(source);
    }
}
- (void)someCommonMethod{

    //  后台执行：
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // something
    });
    //主线程执行：
    dispatch_async(dispatch_get_main_queue(), ^{
        // something
    });
    //一次性执行：
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // code to be executed once
    });
    // 延迟2秒执行：
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // code to be executed on the main queue after delay
    });
    // 合并汇总结果
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        // 并行执行的线程一
    });
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        // 并行执行的线程二
    });
    dispatch_group_notify(group, dispatch_get_global_queue(0,0), ^{
        // 汇总结果
    });
}


/**
 创建 并发队列talentQueue
 参数 "TalentC.dispatch.queue.test" 队列的标记 可自定义
 参数 DISPATCH_QUEUE_CONCURRENT并发队列 (同时可选则 DISPATCH_QUEUE_SERIAL 串行队列)
 返回 dispatch_queue_t 队列对象 dispatch_object
 */
- (void)dispatchGroup{
    dispatch_queue_t talentQueue = dispatch_queue_create("dispatch.queue.test", DISPATCH_QUEUE_CONCURRENT);
    //创建调度组
    dispatch_group_t talentGroup = dispatch_group_create();
    //创建任务
    for (int i = 1; i <= 5; i ++) {
        dispatch_group_async(talentGroup, talentQueue, ^{
            sleep(3);
            NSString *string = [NSString stringWithFormat:@"任务%d",i];
            NSLog(@"%@ 是否主线程:%@",string,[NSThread currentThread].isMainThread?@"YES":@"NO");
        });
    }
    //分组结果通知
    dispatch_group_notify(talentGroup, talentQueue, ^{
        NSLog(@"thread: %p 是否主线程?:%@ 任务全部执行完毕*********",[NSThread currentThread],[NSThread currentThread].isMainThread?@"YES":@"NO");
    });
    NSLog(@"分组任务添加完毕 是否主线程:%@",[NSThread currentThread].isMainThread?@"YES":@"NO");
}

- (void)dispatchApply{

    dispatch_queue_t talentQueue = dispatch_queue_create("dispatch.queue.test", DISPATCH_QUEUE_CONCURRENT);
    dispatch_apply(5, talentQueue, ^(size_t idx) {
        NSLog(@"dispatch_apply 执行idx:%zu 是否主线程:%@",idx,[NSThread currentThread].isMainThread?@"YES":@"NO");
    });
}
- (void)dispatchBarrier{

    dispatch_queue_t talentQueue_bar = dispatch_queue_create("talentQueue.barrier.test", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 5; i ++) {
        if (i == 2) {
            dispatch_barrier_async(talentQueue_bar, ^{
                NSString *taskString = [NSString stringWithFormat:@"任务%d barrier任务",i];
                NSLog(@"%@开始执行 是否主线程:%@",taskString,[NSThread currentThread].isMainThread?@"YES":@"NO");
                //这里使用 GCD 的计时器代替 sleep(3) 可以更加明显的看出效果
                __block int count_t = 0;
                dispatch_queue_t queue = dispatch_get_main_queue();
                dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                uint64_t interval = (uint64_t)(0.5 * NSEC_PER_SEC);
                dispatch_source_set_timer(timer, start, interval, 0);
                dispatch_source_set_event_handler(timer, ^{
                    CGFloat p = count_t/10.0;
                    p = p>1?1:p;
                    if (p == 1) {
                        //取消定时器
                        dispatch_cancel(timer);
                        NSLog(@"%@执行完毕 是否主线程:%@",taskString,[NSThread currentThread].isMainThread?@"YES":@"NO");
                    }
                    count_t++;
                });
                // 启动定时器
                dispatch_resume(timer);
            });
        }else {
            dispatch_async(talentQueue_bar, ^{
                NSString *taskString = [NSString stringWithFormat:@"任务%d",i];
                NSLog(@"%@开始执行 是否主线程:%@",taskString,[NSThread currentThread].isMainThread?@"YES":@"NO");
                sleep(3);
                NSLog(@"%@执行完毕 是否主线程:%@",taskString,[NSThread currentThread].isMainThread?@"YES":@"NO");
            });
        }
    }
    NSLog(@"任务添加完毕 是否主线程:%@",[NSThread currentThread].isMainThread?@"YES":@"NO");
    
    
}
@end
