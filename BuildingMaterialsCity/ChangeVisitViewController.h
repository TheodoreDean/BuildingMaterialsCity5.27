//
//  ChangeVisitViewController.h
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/7.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeVisitViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *visitGuest;

@property (weak, nonatomic) IBOutlet UITextField *orderNo;

@property (weak, nonatomic) IBOutlet UITextField *visitMemo;

@property (weak, nonatomic) IBOutlet UITextField *visitContent;

- (IBAction)saveBtn:(id)sender;

@end
