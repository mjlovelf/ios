//
//  MyWorkerClass.m
//  DesignDemo
//
//  Created by mjbest on 17/6/27.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "MyWorkerClass.h"

@interface MyWorkerClass() <NSMachPortDelegate> {
    NSPort *remotePort;
    NSPort *myPort;
}
@end



@implementation MyWorkerClass


- (void)launchThreadWithPort:(NSPort *)port {

    @autoreleasepool {

        //1. 保存主线程传入的port
        remotePort = port;
        //2. 设置子线程名字
        [[NSThread currentThread] setName:@"MyWorkerClassThread"];
        //3. 开启runloop
        [[NSRunLoop currentRunLoop] run];
        //4. 创建自己port
        myPort = [NSPort port];
        //5.
        myPort.delegate = self;
        //6. 将自己的port添加到runloop
        //作用1、防止runloop执行完毕之后推出
        //作用2、接收主线程发送过来的port消息
        [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
        //7. 完成向主线程port发送消息
        [self sendPortMessage];
        //不一直执行线程将终止
        while (true) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
        }
    }
}

/**
 *   完成向主线程发送port消息
 */
- (void)sendPortMessage {
    NSString *test = @"1";
NSData* xmlData = [test dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *array  =[NSMutableArray arrayWithObject:xmlData];
    //发送消息到主线程，操作1
   BOOL result = [remotePort sendBeforeDate:[NSDate date]
                         msgid:kMsg1
                    components:array
                          from:myPort
                      reserved:0];
    NSLog(@"发送结果 =%zd",result);
    //发送消息到主线程，操作2
    //    [remotePort sendBeforeDate:[NSDate date]
    //                         msgid:kMsg2
    //                    components:nil
    //                          from:myPort
    //                      reserved:0];
}


#pragma mark - NSPortDelegate

/**
 *  接收到主线程port消息
 */
- (void)handlePortMessage:(NSPortMessage *)message
{
    NSLog(@"接收到父线程的消息...\n");

    [remotePort sendBeforeDate:[NSDate date]
                              msgid:kMsg2
                         components:nil
                               from:myPort
                           reserved:0];
}

@end
