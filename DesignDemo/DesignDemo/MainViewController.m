//
//  MainViewController.m
//  DesignDemo
//
//  Created by mjbest on 17/6/29.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "MainViewController.h"
#import "RunLoopViewController.h"
#import "RuntimeViewController.h"
#import "ObserverViewController.h"
#import "GCDMainViewController.h"
#import "AnimationPageRelatedController.h"
#import "ZXingQRController.h"

static NSString *cellIdentifier = @"mainCell";


@interface MainViewController (){

    NSMutableArray *p_dataAry;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    self.title = @"study";
    [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    p_dataAry = [NSMutableArray arrayWithObjects:@"runloop",@"runtime",@"Observer",@"GCD",@"Animation",@"Zxing", nil];
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
        case 0:{
            RunLoopViewController *controller = [[RunLoopViewController alloc] initWithNibName:@"RunLoopViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1:{
            RuntimeViewController *controller = [[RuntimeViewController alloc] initWithNibName:@"RuntimeViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;

        case 2:{

            ObserverViewController *controller = [[ObserverViewController alloc] initWithNibName:@"ObserverViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 3:{

            GCDMainViewController *controller = [[GCDMainViewController alloc] initWithNibName:@"GCDMainViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];

        }
            break;
        case 4:{
            AnimationPageRelatedController *controller = [[AnimationPageRelatedController alloc] initWithNibName:@"AnimationPageRelatedController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];


        }
            break;
        case 5:{
            ZXingQRController *controller = [[ZXingQRController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
