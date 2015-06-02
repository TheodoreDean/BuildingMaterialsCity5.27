//
//  InstallViewController.h
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/6.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstallViewController : UIViewController <UITextFieldDelegate>



@property (weak, nonatomic) IBOutlet UITextField *startTime;

@property (weak, nonatomic) IBOutlet UITextField *endTime;


- (IBAction)searchBtn:(id)sender;


@property (weak, nonatomic) IBOutlet UITableView *dataTable;



- (IBAction)clientBtn:(id)sender;

- (IBAction)orderBtn:(id)sender;

- (IBAction)serviceBtn:(id)sender;

- (IBAction)countBtn:(id)sender;

- (IBAction)userBtn:(id)sender;











@end
