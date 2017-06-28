//
//  ViewController.m
//  DesignModelTest
//
//  Created by mjbest on 17/6/12.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UILabel *label = [[UILabel alloc]init];
    label.text = @"第一个页面";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor  = [UIColor redColor];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];

    UIButton *button =[[UIButton alloc]init];
    [button setTitle:@"点击打开" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(15);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(40));
    }];
    UITextField *textField = [[UITextField alloc]init];
    textField.placeholder = @"默认文本";
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(15);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(40));
    }];
    //
    //当需要将改变通知所有的对象时，而你又不知道这些对象的具体类型
    //改变发生在同一个对象中，并需要改变其他对象将相关的状态进行更新且不知道有多少个对象。

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(result) name:NOTICCE_MESSAGE object:nil];

    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)click{

    [self.delegate testClick];
}
- (void)result{
    NSLog(@"dfsfsfsf");

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
