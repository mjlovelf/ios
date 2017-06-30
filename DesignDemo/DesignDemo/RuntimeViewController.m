//
//  RuntimeViewController.m
//  DesignDemo
//
//  Created by mjbest on 17/6/29.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "RuntimeViewController.h"
#import "baseMethod+swizzlingMethod.h"
@interface RuntimeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation RuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonClick:(id)sender {
    baseMethod *method = [[baseMethod alloc] init];
    [method writeSome];
}
- (IBAction)varListClick:(id)sender {

    baseMethod *method = [[baseMethod alloc] init];
    [method logAllProperite];
    [method logPublicProperite];
    method.categaryProperite = @"ddsds";
    NSLog(@"当前 ＝%@",method.categaryProperite);
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
