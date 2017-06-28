//
//  ViewController.h
//  DesignModelTest
//
//  Created by mjbest on 17/6/12.
//  Copyright © 2017年 majian. All rights reserved.
//

#import <UIKit/UIKit.h>
static  NSString *NOTICCE_MESSAGE = @"GODISGOOD";

@protocol ViewControllerDelegate<NSObject>
//当一个类的某些功能需要被别人来实现，但是既不明确是些什么功能，又不明确谁来实现这些功能的时候，委托模式就可以派上用场。
@optional
-(void)testClick;
@end

@interface ViewController : UIViewController

@property (weak, nonatomic) id<ViewControllerDelegate> delegate;

@end

