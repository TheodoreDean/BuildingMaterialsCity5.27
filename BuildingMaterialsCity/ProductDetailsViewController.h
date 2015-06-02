//
//  ProductDetailsViewController.h
//  BuildingMaterialsCity
//
//  Created by xiaozhan on 15/5/26.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface ProductDetailsViewController : UIViewController<UIAlertViewDelegate,NSXMLParserDelegate,NSURLConnectionDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
    MBProgressHUD *HUD;
    BOOL recordResults;
}


- (IBAction)add:(UIBarButtonItem *)sender;

- (IBAction)delete:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UITableView *featureTableView;

- (IBAction)admit:(UIButton *)sender;

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



@property (weak, nonatomic) IBOutlet UITextField *productName;

@property (weak, nonatomic) IBOutlet UITextField *productDes;

@end
