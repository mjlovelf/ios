//
//  GCDMainViewController.m
//  DesignDemo
//
//  Created by mjbest on 17/7/4.
//  Copyright © 2017年 majian. All rights reserved.
//

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
    p_dataAry = [NSMutableArray arrayWithObjects:@"getGlobalQueue", nil];

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
@end
