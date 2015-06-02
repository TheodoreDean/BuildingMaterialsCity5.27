//
//  OrderViewController.m
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/5.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import "OrderViewController.h"
#import "ManagementViewController.h"
#import "DataCountViewController.h"
#import "InstallViewController.h"
#import "ServiceViewController.h"
#import "DataViewController.h"
#import "UserViewController.h"

@interface OrderViewController (){
    UISegmentedControl *segmentedControl;
    
}
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [navBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *item = [[UILabel alloc] initWithFrame:CGRectMake(0,20,320,20)];
    item.text = @"管理";
    item.textAlignment = 1;
    item.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    item.textColor = [UIColor whiteColor];
    [navBar addSubview:item];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(20,24,12,12)];
    [left setImage:[UIImage imageNamed:@"ss.png"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:left];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setFrame:CGRectMake(288,24,12,12)];
    [right setImage:[UIImage imageNamed:@"tj.png"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:right];
    
    [self.view addSubview:navBar];
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:250.0/255 alpha:1];
    
    
    self.startTime.layer.cornerRadius=0.0f;
    self.startTime.layer.masksToBounds=YES;
    self.startTime.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.startTime.layer.borderWidth= 0.5f;
    
    self.endTime.layer.cornerRadius=0.0f;
    self.endTime.layer.masksToBounds=YES;
    self.endTime.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.endTime.layer.borderWidth= 0.5f;
    
    
    
}
  
-(void)search{
    NSLog(@"aaa");
}

-(void)add{
    
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

- (IBAction)search:(id)sender {
    DataCountViewController *data = [[DataCountViewController alloc] initWithNibName:@"DataCountViewController" bundle:nil];
    [self presentViewController:data animated:YES completion:nil];
    
}


- (IBAction)manageBtn:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)instalBtn:(id)sender {
    InstallViewController *instal = [[InstallViewController alloc] initWithNibName:@"InstallViewController" bundle:nil];
    [self presentViewController:instal animated:NO completion:nil];
}

- (IBAction)serviceBtn:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    ServiceViewController *service = [[ServiceViewController alloc] initWithNibName:@"ServiceViewController" bundle:nil];
    [self presentViewController:service animated:NO completion:nil];
}

- (IBAction)dataCountBtn:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    DataViewController *data = [[DataViewController alloc] initWithNibName:@"DataViewController" bundle:nil];
    [self presentViewController:data animated:NO completion:nil];
}

- (IBAction)userBtn:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    UserViewController *user = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
    [self presentViewController:user animated:NO completion:nil];
}
@end
