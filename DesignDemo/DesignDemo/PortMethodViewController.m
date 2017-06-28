//
//  PortMethodViewController.m
//  DesignDemo
//
//  Created by mjbest on 17/6/27.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "PortMethodViewController.h"
#import "MyWorkerClass.h"

@interface PortMethodViewController ()<NSMachPortDelegate>
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;

@end

@implementation PortMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    self.title = @"runloop使用port";
    // Do any additional setup after loading the view from its nib.

}
- (IBAction)buttonClick:(id)sender {

    [self createThread];

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
- (void)createThread{

    //1. 创建主线程的port
    // 子线程通过此端口发送消息给主线程
    NSPort *myPort = [NSMachPort port];

    //2. 设置port的代理回调对象
    myPort.delegate = self;

    //3. 把port加入runloop，接收port消息
    [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];

    NSLog(@"---myport %@", myPort);
    //4. 启动次线程,并传入主线程的port
    MyWorkerClass *work = [[MyWorkerClass alloc] init];
    [NSThread detachNewThreadSelector:@selector(launchThreadWithPort:)
                             toTarget:work
                           withObject:myPort];
}

//- (void)handleMachMessage:(void *)msga{
//        NSLog(@"message:%lld", *(long long *)msga);
//    mach_msg_base_t *msg =msga;
//    if (msg->header.msgh_size > sizeof(mach_msg_base_t)) {
//        CFDataRef responseData = CFDataCreate(kCFAllocatorSystemDefault, (uint8_t *)msg + sizeof(mach_msg_base_t), msg->header.msgh_size - sizeof(mach_msg_base_t));
////        NSData *data = (__bridge NSData*)responseData;
////        NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
////        NSLog(@"result = %@",result);
//        NSData *data = [NSData dataWithBytes: &msg->body length: sizeof(msg->body)];
//        NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
//        NSLog(@"result = %@",result);
//    }
//}
- (void)handlePortMessage:(NSMessagePort*)message{

    NSLog(@"接到子线程传递的消息！%@",message);

    //1. 消息id
    NSUInteger msgId = [[message valueForKeyPath:@"msgid"] integerValue];

    //2. 当前主线程的port
    NSPort *localPort = [message valueForKeyPath:@"localPort"];

    //3. 接收到消息的port（来自其他线程）
    NSPort *remotePort = [message valueForKeyPath:@"remotePort"];
    NSObject *object = [message valueForKeyPath:@"components"];
    if (msgId == kMsg1)
    {
        //向子线的port发送消息
        [remotePort sendBeforeDate:[NSDate date]
                             msgid:kMsg2
                        components:nil
                              from:localPort
                          reserved:0];
        _mainLabel.text = [NSString stringWithFormat:@"%zd",msgId];
    } else if (msgId == kMsg2){
        NSLog(@"操作2....\n");
        _thirdLabel.text = [NSString stringWithFormat:@"%zd",msgId];
    }
}
@end
