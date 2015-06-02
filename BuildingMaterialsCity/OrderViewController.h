//
//  OrderViewController.h
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/5.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *startTime;

@property (weak, nonatomic) IBOutlet UITextField *endTime;

- (IBAction)search:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;




- (IBAction)manageBtn:(id)sender;

- (IBAction)instalBtn:(id)sender;

- (IBAction)serviceBtn:(id)sender;

- (IBAction)dataCountBtn:(id)sender;

- (IBAction)userBtn:(id)sender;




@end
