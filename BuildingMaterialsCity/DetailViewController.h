//
//  DetailViewController.h
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/6.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface DetailViewController : UIViewController<NSXMLParserDelegate,NSURLConnectionDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
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

@property (weak, nonatomic) IBOutlet UITableView *customerTrack;


@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *tel;

@property (weak, nonatomic) IBOutlet UILabel *xiaoqu;

@property (weak, nonatomic) IBOutlet UILabel *address;



@property (weak, nonatomic) IBOutlet UILabel *enterTime;

@property (weak, nonatomic) IBOutlet UILabel *toTime;

@property (weak, nonatomic) IBOutlet UILabel *toProduct;

@property (weak, nonatomic) IBOutlet UILabel *charger;


- (IBAction)changeBtn:(id)sender;

@end
