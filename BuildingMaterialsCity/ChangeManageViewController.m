//
//  ChangeManageViewController.m
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/6.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import "ChangeManageViewController.h"
#import "AppDelegate.h"
#import "CustomDatePicker.h"
#import "DateSelectView.h"



@interface ChangeManageViewController ()

@end


@implementation ChangeManageViewController
{
    NSMutableDictionary *dict;
    UIAlertView *alert;


    CustomDatePicker *FTimePicker;
    CustomDatePicker *IntPiceker;
    
    NSString *FtimeString;
    NSString *intTimeString;
    
    AppDelegate *app;
    
    DateSelectView *salesView;
    NSMutableArray *salesNameArray;
    NSString *salesID;
}

@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize conn;

#pragma SearchUserInfoByNameLikeANDShopNameWithOD  按用户名或显示名模糊查询指定商铺的用户列表
//搜索特定的数据
-(void)SearchUserInfoByNameLikeANDShopNameWithOD{
    //初始化进度框，置于当前的View中
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    HUD.labelText = @"请稍等"; //设置对话框文字
    //显示对话框
    [HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(3);
    }completionBlock:^{
        //操作执行完后取消对话框
        [HUD removeFromSuperview];
        HUD = nil;
    }];
    
    NSString * text = @"";
    NSString * odstr = @"USERID";
    
    //设置之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签想对应
    matchingElement = @"SearchUserInfoByNameLikeANDShopNameWithODResult";
    //创建SOAP消息，内容格式就是网站声提示的请求豹纹的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope "
                         "xmlns:xsi=\"http://www.w3.org/2001/XMLSchems-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<SearchUserInfoByNameLikeANDShopNameWithOD xmlns=\"http://tempuri.org/\">"
                         "<key>%@</key>"
                         "<shopname>%@</shopname>"
                         "<odstr>%@</odstr>"
                         "</SearchUserInfoByNameLikeANDShopNameWithOD>"
                         "</soap12:Body>"
                         "</soap12:Envelope>",text,app.shopName,odstr];
    
    NSLog(@"!!!!!!!!!!!!!:%@  %@    %@",text,app.shopName,odstr);
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.100/jct/DataWebService.asmx"];
    NSLog(@"soapMsg:%@",soapMsg);
    
    //根据上面的URL创建一个请求
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMsg length]];
    //添加请求的详细信息，与请求报文前半部分的各字段对应
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    //设置请求行方法为POST，与请求报文第一行对应
    [req setHTTPMethod:@"POST"];
    
    //将SOAP消息加到请求中
    [req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    //创建连接
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    [navBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *item = [[UILabel alloc] initWithFrame:CGRectMake(0,20,320,20)];
    item.text = @"修改意向客户信息";
    item.textAlignment = 1;
    item.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    item.textColor = [UIColor whiteColor];
    [navBar addSubview:item];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(20,24,10,13)];
    [left setImage:[UIImage imageNamed:@"fh.png"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:left];
    
    [self.view addSubview:navBar];
    
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:250.0/255 alpha:1];

    app = [[UIApplication sharedApplication] delegate];

    self.name.text = [NSString stringWithFormat:@"%@",app.customerName];
    self.name.layer.cornerRadius=0.0f;
    self.name.layer.masksToBounds=YES;
    self.name.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.name.layer.borderWidth= 0.5f;
    
    self.tel.text = [NSString stringWithFormat:@"%@",app.telNumber];
    self.tel.layer.cornerRadius=0.0f;
    self.tel.layer.masksToBounds=YES;
    self.tel.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.tel.layer.borderWidth= 0.5f;
    
    self.xiaouq.text = [NSString stringWithFormat:@"%@",app.xiaoQu];

    self.xiaouq.layer.cornerRadius=0.0f;
    self.xiaouq.layer.masksToBounds=YES;
    self.xiaouq.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.xiaouq.layer.borderWidth= 0.5f;
    
    self.address.text = [NSString stringWithFormat:@"%@",app.address];
    self.address.layer.cornerRadius=0.0f;
    self.address.layer.masksToBounds=YES;
    self.address.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.address.layer.borderWidth= 0.5f;
    
    self.toProduct.text = [NSString stringWithFormat:@"%@",app.product];
    self.toProduct.layer.cornerRadius=0.0f;
    self.toProduct.layer.masksToBounds=YES;
    self.toProduct.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.toProduct.layer.borderWidth= 0.5f;
    

    self.identifierID.layer.cornerRadius=0.0f;
    self.identifierID.layer.masksToBounds=YES;
    self.identifierID.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.identifierID.layer.borderWidth= 0.5f;
    
    self.beizhu.layer.cornerRadius=0.0f;
    self.beizhu.layer.masksToBounds=YES;
    self.beizhu.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.beizhu.layer.borderWidth= 0.5f;

    
    FTimePicker = [[CustomDatePicker alloc] initWithFrame:CGRectMake(115, 187, 50, 25)];
    IntPiceker =  [[CustomDatePicker alloc] initWithFrame:CGRectMake(115, 236, 50, 25)];
    [self.view addSubview:FTimePicker];
    [self.view  addSubview:IntPiceker];
    
    [self SearchUserInfoByNameLikeANDShopNameWithOD];

    
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

 In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     Get the new view controller using [segue destinationViewController].
     Pass the selected object to the new view controller.
}
*/

#pragma  mark - 修改客户信息
-(void)changeCustomer{
    //初始化进度框，置于当前的View中
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    HUD.labelText = @"请稍等"; //设置对话框文字
    //显示对话框
    [HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(3);
    }completionBlock:^{
        //操作执行完后取消对话框
        [HUD removeFromSuperview];
        HUD = nil;
    }];
 
    app = [[UIApplication sharedApplication] delegate];
    
    for(int i = 0 ; i < [_notes count] ; i++)
    {
     if ([[[_notes objectAtIndex:i] objectForKey:@"USERNAME"] isEqualToString:salesView.textField.text]) {
    
        salesID = [[_notes objectAtIndex:i] objectForKey:@"USERID"];
         NSLog(@"sale 111:%@",salesID);
         break;
     }
    }
 
    //设置之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签想对应
    matchingElement = @"UpdateCustomerInfoByCustomerIDResult";
    //创建SOAP消息，内容格式就是网站声提示的请求豹纹的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<UpdateCustomerInfoByCustomerID xmlns=\"http://tempuri.org/\"> "
                         "<customerid>%@</customerid>"
                         "<customername>%@</customername>"
                         "<customertel>%@</customertel>"
                         "<customeraddr>%@</customeraddr>"
                         "<customerar>%@</customerar>"
                         "<salesuserid>%@</salesuserid>"
                         "<intproduct>%@</intproduct>"
                         "<cmemo>%@</cmemo>"
                         "<ftime>%@</ftime>"
                         "<inttime>%@</inttime>"
                         "<idcard>%@</idcard>"
                         "</UpdateCustomerInfoByCustomerID>"
                         "</soap12:Body>"
                         "</soap12:Envelope>",app.customerID,self.name.text,self.tel.text,self.address.text,self.xiaouq.text,salesID,app.product,self.beizhu.text,FtimeString,intTimeString,self.identifierID.text];
    NSLog(@"~~~~%@  %@  %@  %@  %@   %@  %@  %@  %@  %@  %@ ",app.customerID,self.name.text,self.tel.text,self.address.text,self.xiaouq.text,app.nameid,self.toProduct.text,self.beizhu.text,FtimeString,intTimeString,self.identifierID.text);
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.100/jct/DataWebService.asmx"];
    NSLog(@"soapMsg:%@",soapMsg);
    
    //根据上面的URL创建一个请求
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMsg length]];
    //添加请求的详细信息，与请求报文前半部分的各字段对应
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    //设置请求行方法为POST，与请求报文第一行对应
    [req setHTTPMethod:@"POST"];
    
    //将SOAP消息加到请求中
    [req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    //创建连接
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
    }
}

#pragma mark -
#pragma mark URl Connection Data Delegate Methods

//刚开始接受响应时调用
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [webData setLength:0];
}

//每接收到一部分数据就追加到webData中
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [webData appendData:data];
}

//出现错误时
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    conn = nil;
    webData = nil;
}

//完成接收数据时调用
-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *theXML = [[NSString alloc] initWithBytes:[webData mutableBytes]
                                                length:[webData length]
                                              encoding:NSUTF8StringEncoding];
    NSLog(@"theXML:  %@",theXML);
    //是用NSXMLParser解析我们想要的结果
    xmlParser  = [[NSXMLParser alloc] initWithData:webData];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
}

#pragma mark -
#pragma mark XML Parser Delegate Methods

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    _notes = [NSMutableArray new];
}

//开始解析一个元素名
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    _currentTagName = elementName;
    if ([_currentTagName isEqualToString:@"result"]) {
        NSString * _id = [attributeDict objectForKey:@"diffgr:id"];
        //实例化一个可变的字典对象，用于存放
        dict = [NSMutableDictionary new];
        //把id放入字典中
        [dict setObject:_id forKey:@"diffgr:id"];
        
        //把可变字典 放入到 可变数组集合_notes变量中
        [_notes addObject:dict];
        //        NSLog(@"========_notes======%@",_notes);
    }
}

//追加找到的元素值，一个元素值可能要分几次追加
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    dict = [_notes lastObject];
    if ([_currentTagName isEqualToString:@"USERID"] && dict) {//用户ID
        [dict setObject:string forKey:@"USERID"];
    }
    if ([_currentTagName isEqualToString:@"USERNAME"] && dict) {//用户名
        [dict setObject:string forKey:@"USERNAME"];
    }
    
//    if ([_currentTagName isEqualToString:@"SHOWNAME"] && dict) {//显示名
//        [dict setObject:string forKey:@"SHOWNAME"];
//    }
//    if ([_currentTagName isEqualToString:@"USERSTATUS"] && dict) {//账号状态
//        [dict setObject:string forKey:@"USERSTATUS"];
//    }
//    if ([_currentTagName isEqualToString:@"CREATETIME"] && dict) {//创建时间
//        [dict setObject:string forKey:@"CREATETIME"];
//    }
//    
    if ([_currentTagName isEqualToString:@"info"] && dict) {//更改结果
        [dict setObject:string forKey:@"info"];
    }
}

//结束解析这个元素名
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"UpdateCustomerInfoByCustomerIDResult"]) {
        //修改用户状态
        if ([_currentTagName isEqualToString:@"info"]) {
            if ([[dict objectForKey:@"info"] isEqualToString:@"ok"]) {
                
                NSLog(@"xml ok");
                alert  = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:[dict objectForKey:@"info"]
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
                [alert show];

                
            }else{
                alert  = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:[dict objectForKey:@"info"]
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [HUD removeFromSuperview];
}

//解析整个文件结束后
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [[NSNotificationCenter defaultCenter] postNotificationName: @"reloadViewNotification" object:self.notes userInfo:nil];
    //进入该方法就意味着解析完成，需要清理一些成员变量，同时要将数据返回给表示层（表示图控制器） 通过广播机制将数据通过广播通知投送到 表示层
    NSLog(@"%@  ",_notes);
    
    salesNameArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [_notes count]; i++) {
            if([[_notes objectAtIndex:i ] objectForKey:@"USERNAME"] != nil)
            {
             [salesNameArray addObject:[[_notes objectAtIndex:i ] objectForKey:@"USERNAME"]];
            }
        }
    if([app.opnames containsObject:@"用户管理"])
    {
        salesView = [[DateSelectView  alloc] initWithFrame:CGRectMake(115 , 336, 141, 22) tableviewFrame:CGRectMake(0, 20, 105, 0)];
        salesView.textField.placeholder = @"请选择";
        salesView.tableArray = salesNameArray;
        [self.view addSubview:salesView];
    }else {
        self.charger.text = [NSString stringWithFormat:@"%@",app.salesUserID];
        self.charger.enabled = NO;
        self.charger.layer.cornerRadius=0.0f;
        self.charger.layer.masksToBounds=YES;
        self.charger.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
        self.charger.layer.borderWidth= 0.5f;

    }
  
}

//出错时，例如强制结束解析
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    if (soapResults) {
        soapResults = nil;
    }
}

- (IBAction)save:(id)sender {
    FtimeString = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)FTimePicker.yearString,(long)FTimePicker.monthString,(long)FTimePicker.dayString];
    NSLog(@"test date 1  ==%@",FtimeString);
    
    intTimeString = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)IntPiceker.yearString,(long)IntPiceker.monthString,(long)IntPiceker.dayString];
    NSLog(@"test date 2  ==%@",intTimeString);
    
    [self changeCustomer];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
