//
//  AddCustomTrack.h
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/21.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface AddCustomTrack : UIViewController<UITextFieldDelegate,NSXMLParserDelegate,NSURLConnectionDelegate>
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



@property (weak, nonatomic) IBOutlet UITextField *customName;

@property (weak, nonatomic) IBOutlet UITextField *visiterName;

@property (weak, nonatomic) IBOutlet UITextField *visitContent;

@property (weak, nonatomic) IBOutlet UITextField *meMo;



@property (weak, nonatomic) IBOutlet UITextField *createrID;

@property (weak, nonatomic) IBOutlet UITextField *shopName;

- (IBAction)addCustomTrack:(id)sender;

@end
