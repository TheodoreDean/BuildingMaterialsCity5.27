//
//  AddguestViewCOntroller.h
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/7.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AddguestViewController : UIViewController<UITextFieldDelegate,NSXMLParserDelegate,NSURLConnectionDelegate>{
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




@property (weak, nonatomic) IBOutlet UITextField *toName;//客户姓名

@property (weak, nonatomic) IBOutlet UITextField *toTel;//手机号码

@property (weak, nonatomic) IBOutlet UITextField *toAdderss;//地址

@property (weak, nonatomic) IBOutlet UITextField *toXiaoQu;//小区

@property (weak, nonatomic) IBOutlet UITextField *toProduct;//意向产品

@property (weak, nonatomic) IBOutlet UITextField *beizhu;//备注

@property (weak, nonatomic) IBOutlet UITextField *chargerID;//负责人ID

@property (weak, nonatomic) IBOutlet UITextField *cardNo;//身份证号


- (IBAction)save:(id)sender;

@end
