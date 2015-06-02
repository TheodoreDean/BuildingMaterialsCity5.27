//
//  VisitViewController.h
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/7.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface VisitViewController : UIViewController<NSXMLParserDelegate,NSURLConnectionDelegate,UITextFieldDelegate,UITextViewDelegate>
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

@property (weak, nonatomic) IBOutlet UILabel *visitGuest;//回访客户名

@property (weak, nonatomic) IBOutlet UILabel *visitName;//回访人员

@property (weak, nonatomic) IBOutlet UITextView *visitContent;//回访内容

@property (weak, nonatomic) IBOutlet UILabel *trackTime;//回访时间

@property (weak, nonatomic) IBOutlet UILabel *createTime;//创建时间



- (IBAction)changeBtn:(id)sender;



@end
