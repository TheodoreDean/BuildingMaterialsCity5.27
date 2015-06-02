//
//  MessageRemberViewController.m
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/4/30.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import "MessageRemberViewController.h"

@interface MessageRemberViewController ()

@end

@implementation MessageRemberViewController{
    NSMutableArray *arr1;
    NSMutableArray *arr2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [navBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *item = [[UILabel alloc] initWithFrame:CGRectMake(0,20,320,20)];
    item.text = @"信息";
    item.textAlignment = 1;
    item.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    item.textColor = [UIColor whiteColor];
    [navBar addSubview:item];
    
    [self.view addSubview:navBar];
    
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:250.0/255 alpha:1];
    
    arr1 = [[NSMutableArray alloc] initWithObjects:@"记录客户装修时间还有3",@"11111111111",@"322r24534",@"23t35yth",nil];
    arr2 = [[NSMutableArray alloc] initWithObjects:@"zhangsna 12964923165  yixiangchanop: mx,  nj",@"zhangsna 12964923165  yixiangchanop: mxnj",@"zhangsna 12964923165  yixiangchanop: mxdfh",@"detailTextLabel",nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [arr1 count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }else{
        // 删除cell中的子对象,刷新覆盖问题。
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 280, 20)];
    textLabel.text = [arr1 objectAtIndex:indexPath.row];
    textLabel.textColor = [UIColor colorWithRed:255.0/255 green:23.0/255 blue:145.0/255 alpha:1];
    textLabel.font = [UIFont fontWithName:@"Helvetica" size:11];
    textLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:textLabel];
    
    UILabel *detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 280, 20)];
    detailTextLabel.text = [arr2 objectAtIndex:indexPath.row];
    detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:9];
    detailTextLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:detailTextLabel];
    
    
    return cell;
}


#pragma delete 滑动删除

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//单元格返回的编辑风格，包括删除 添加 和 默认  和不可编辑三种风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete ;//返回编辑风格：  -：删除； +：添加  无：不可编辑
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [arr1  removeObjectAtIndex:indexPath.row];
        [arr2  removeObjectAtIndex:indexPath.row];
        
        [self.messageData deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
