//
//  UserViewController.h
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/6.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface UserViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,NSXMLParserDelegate,
NSURLConnectionDelegate,UITextFieldDelegate>{
    MBProgressHUD *HUD;
    BOOL recordResults;
}


//网络解析   参数
@property (strong, nonatomic) NSMutableData *webData;

@property (strong, nonatomic) NSMutableString *soapResults;

@property (strong, nonatomic) NSXMLParser *xmlParser;

@property (nonatomic) BOOL elementFound;

@property (strong, nonatomic) NSString *matchingElement;

@property (strong, nonatomic) NSURLConnection *conn;


//解析出得数据，内部是字典类型
@property (strong,nonatomic) NSMutableArray * notes;

// 当前标签的名字 ,currentTagName 用于存储正在解析的元素名
@property (strong ,nonatomic) NSString * currentTagName;


@property (weak, nonatomic) IBOutlet UITableView *userDataTable;

//跳转到客户管理页面
- (IBAction)custom:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentController;

- (IBAction)choose:(id)sender;



- (IBAction)showNameBtn:(id)sender;//按显示名排序

- (IBAction)userStateBtn:(id)sender;//按用户状态排序


- (IBAction)createTimeBtn:(id)sender;//按创建时间排序



@end
