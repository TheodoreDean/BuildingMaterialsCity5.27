//
//  TableView.m
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/18.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import "TableView.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "AddCustomTrack.h"

@implementation TableView{
    UIButton *addVisitRecord;
    UIButton *addOrder;
}

@synthesize tv;
@synthesize tableArray;

@synthesize tableArray1;
@synthesize tableArray2;
@synthesize tableArray3;
@synthesize tableArray4;
@synthesize tableArray5;
@synthesize tableArray6;
@synthesize tableArray7;
@synthesize tableArray8;
@synthesize tableArray9;



-(id)initWithFrame:(CGRect)frame tableviewFrame:(CGRect)tvframe
{
        
    self=[super initWithFrame:frame];
    
    if(self){
        
        tv = [[UITableView alloc] initWithFrame:tvframe];
        tv.delegate = self;
        tv.dataSource = self;
        tv.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:250.0/255 alpha:1];
        tv.separatorColor = [UIColor lightGrayColor];
        tv.scrollEnabled = YES;
        [self addSubview:tv];
 
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }else{
        // 删除cell中的子对象,刷新覆盖问题。
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    //客户名称
    UILabel *customNameL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 20)];
    customNameL.text = [tableArray objectAtIndex:[indexPath row]];
    customNameL.font = [UIFont fontWithName:@"Helvetica" size:11.0f];
    customNameL.backgroundColor = [UIColor clearColor];
    customNameL.textAlignment = 1;
    [cell.contentView addSubview:customNameL];

    //小区
    UILabel *communityL = [[UILabel alloc] initWithFrame:CGRectMake(35, 12, 50, 20)];
    communityL.text = [tableArray1 objectAtIndex:[indexPath row]];
    communityL.font = [UIFont fontWithName:@"Helvetica" size:9.0f];
    communityL.backgroundColor = [UIColor clearColor];
    communityL.textAlignment = 1;
    [cell.contentView addSubview:communityL];
    
    //负责人
    UILabel *guiderL = [[UILabel alloc] initWithFrame:CGRectMake(85, 12, 50, 20)];
    guiderL.text = [tableArray2 objectAtIndex:[indexPath row]];
    guiderL.font = [UIFont fontWithName:@"Helvetica" size:9.0f];
    guiderL.backgroundColor = [UIColor clearColor];
    guiderL.textAlignment = 1;
    [cell.contentView addSubview:guiderL];
    
    //意向产品
    UILabel *productL = [[UILabel alloc] initWithFrame:CGRectMake(135, 12, 50, 20)];
    productL.text = [tableArray3 objectAtIndex:[indexPath row]];
    productL.font = [UIFont fontWithName:@"Helvetica" size:9.0f];
    productL.backgroundColor = [UIColor clearColor];
    productL.textAlignment = 1;
    [cell.contentView addSubview:productL];
    
    //进店时间
    UILabel *toTimeL = [[UILabel alloc] initWithFrame:CGRectMake(185, 12, 50, 20)];
    toTimeL.text = [[tableArray4 objectAtIndex:[indexPath row]] substringWithRange:NSMakeRange(2, 8)];
    toTimeL.font = [UIFont fontWithName:@"Helvetica" size:9.0f];
    toTimeL.backgroundColor = [UIColor clearColor];
    toTimeL.textAlignment = 1;
    [cell.contentView addSubview:toTimeL];
    
    //预计够装时间
    UILabel *buyTimeL = [[UILabel alloc] initWithFrame:CGRectMake(235, 12, 50, 20)];
    buyTimeL.text = [[tableArray5 objectAtIndex:[indexPath row]] substringWithRange:NSMakeRange(2, 8)];
    buyTimeL.font = [UIFont fontWithName:@"Helvetica" size:9.0f];
    buyTimeL.backgroundColor = [UIColor clearColor];
    buyTimeL.textAlignment = 1;
    [cell.contentView addSubview:buyTimeL];
    
    //+记录
    addVisitRecord = [[UIButton alloc] initWithFrame:CGRectMake(285, 0, 35, 22)];
    [addVisitRecord setTitle:@"+回访" forState:UIControlStateNormal];
    [addVisitRecord setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addVisitRecord setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [addVisitRecord addTarget:self action:@selector(addVisitRecordBtn:) forControlEvents:UIControlEventTouchUpInside];
    addVisitRecord.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
    [cell.contentView addSubview:addVisitRecord];
    
    //+订单
    addOrder = [[UIButton alloc] initWithFrame:CGRectMake(285, 22, 35, 22)];
    [addOrder setTitle:@"+订单" forState:UIControlStateNormal];
    [addOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addOrder setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [addOrder addTarget:self action:@selector(addOrderBtn) forControlEvents:UIControlEventTouchUpInside];
    addOrder.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
    [cell.contentView addSubview:addOrder];
    
    return cell;
}

//+记录
-(void)addVisitRecordBtn:(id)sender{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    int myRow = [tv indexPathForCell:((UITableViewCell*)[[sender superview]superview])].row;
//    NSLog(@"MyRow:%d",[tv indexPathForCell:((UITableViewCell*)[[sender superview]superview])].row);
    app.customerID = [tableArray8 objectAtIndex:myRow];
    
    app.customerName = [tableArray objectAtIndex:myRow];
    NSLog(@"app.customerid  :%@",app.customerID);
    AddCustomTrack *add = [[AddCustomTrack alloc] initWithNibName:@"AddCustomTrack" bundle:nil];
   [[self viewController] presentViewController:add animated:YES completion:nil];}

//+订单
-(void)addOrderBtn{
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
            }
        }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    if ( [[tableArray9 objectAtIndex:[indexPath row]] isEqualToString:@"0" ]) {
        DetailViewController *detail = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        //传递意向客户详情的参数
        app.customerName = [tableArray objectAtIndex:[indexPath row]];
        app.xiaoQu = [tableArray1 objectAtIndex:[indexPath row]];
        app.address= [tableArray6 objectAtIndex:[indexPath row]];
        app.FTime = [tableArray4 objectAtIndex:[indexPath row]];
        app.IntTime = [tableArray5 objectAtIndex:[indexPath row]];
        app.product = [tableArray3 objectAtIndex:[indexPath row]];
        app.salesUserID = [tableArray2 objectAtIndex:[indexPath row]];
        app.telNumber = [tableArray7 objectAtIndex:[indexPath row]];
        app.customerID = [tableArray8 objectAtIndex:[indexPath row]];
        
        NSLog(@"~~~~~~~~~~~~%@~~~~~~~~~~~%@~~~~~~~~~~",app.telNumber,app.address);
        
        
        [[self viewController] presentViewController:detail animated:YES completion:nil];
    }
    else if ([[tableArray9 objectAtIndex:[indexPath row]] isEqualToString:@"1" ]){
        NSLog(@"11111");
    }
    
    
}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}


@end
