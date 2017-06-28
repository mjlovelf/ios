//
//  RunLoopViewController.m
//  DesignDemo
//
//  Created by mjbest on 17/6/26.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "RunLoopViewController.h"
#import "PerfromMethodViewController.h"
#import "PortMethodViewController.h"
#import "RunLoopStudyViewController.h"

static NSString *cellIdentifier = @"testCell";

@interface RunLoopViewController (){

    NSMutableArray *p_dataAry;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RunLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    self.title = @"RunLoop";
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    p_dataAry = [NSMutableArray arrayWithObjects:@"在perform中使用",@"使用port",@"使用观察者", nil];
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
            PerfromMethodViewController *controller = [[PerfromMethodViewController alloc] initWithNibName:@"PerfromMethodViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1:{

            PortMethodViewController *controller = [[PortMethodViewController alloc] initWithNibName:@"PortMethodViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
        }
        case 2:
        {
            RunLoopStudyViewController *controller = [[RunLoopStudyViewController alloc] initWithNibName:@"RunLoopStudyViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];

        }
            break;
        default:
            break;
    }
}

@end
