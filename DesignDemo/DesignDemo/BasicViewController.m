//
//  BasicViewController.m
//  DesignDemo
//
//  Created by mjbest on 17/6/26.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()

@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if( [self.navigationController.childViewControllers count] > 1 )
    {
        UIButton *leftBtn = [Utils createButtonWith:CustomButtonType_Back text:nil img:nil];
        leftBtn.selected  = NO;
        [leftBtn addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickBack:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
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
