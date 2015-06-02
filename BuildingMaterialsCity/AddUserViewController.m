//
//  AddUserViewController.m
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/6.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import "AddUserViewController.h"
#import "AppDelegate.h"
#define initialX 48
#define initialY 264
#define width 75
#define height 21
#define margin 31
#define column 3

@interface AddUserViewController ()

@end

@implementation AddUserViewController{
    UIAlertView *alert;
    NSMutableDictionary *dict;
    AppDelegate * app;
    NSMutableArray *opName;//权限数组
    NSString *neweruid;
    NSMutableArray *mutableArr;
}

@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize conn;

//获取权限表里的全部权限
-(void)GetAllSysAccess{
    //初始化进度框，置于当前的View中
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    HUD.labelText = @"请稍等"; //设置对话框文字
    //显示对话框
    [HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(1);
    }completionBlock:^{
        //操作执行完后取消对话框
        [HUD removeFromSuperview];
        HUD = nil;
    }];
    
    //设置之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签想对应
    matchingElement = @"GetAllSysAccessResult";
    //创建SOAP消息，内容格式就是网站声提示的请求豹纹的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?> "
                         "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\"> "
                         "<soap12:Body>"
                         "<GetAllSysAccess xmlns=\"http://tempuri.org/\"> "
                         "</GetAllSysAccess>"
                         "</soap12:Body>"
                         "</soap12:Envelope>"
                         ];
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.100/jct/DataWebService.asmx"];
    NSLog(@"addConsumer:soapMsg:%@",soapMsg);
    
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewDidLoad];
     [self GetAllSysAccess];//调用获取系统权限列表 方法
}

/////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    [navBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *item = [[UILabel alloc] initWithFrame:CGRectMake(0,20,320,20)];
    item.text = @"用户添加";
    item.textAlignment = 1;
    item.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    item.textColor = [UIColor whiteColor];
    [navBar addSubview:item];
    
    [self.view addSubview:navBar];
    
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:250.0/255 alpha:1];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(20,24,10,13)];
    [left setImage:[UIImage imageNamed:@"fh.png"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:left];
    
    [self.view addSubview:navBar];
    
    self.userName.delegate = self;//用户名
    self.userName.layer.cornerRadius=0.0f;
    self.userName.layer.masksToBounds=YES;
    self.userName.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.userName.layer.borderWidth= 0.5f;

    self.showName.delegate = self;//显示名
    self.showName.layer.cornerRadius=0.0f;
    self.showName.layer.masksToBounds=YES;
    self.showName.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.showName.layer.borderWidth= 0.5f;
    
    self.pass.delegate = self;//密码
    self.pass.layer.cornerRadius=0.0f;
    self.pass.layer.masksToBounds=YES;
    self.pass.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.pass.layer.borderWidth= 0.5f;
    
//    self.jiaose.delegate = self;//用户角色 暂且不要
//    self.jiaose.layer.cornerRadius=0.0f;
//    self.jiaose.layer.masksToBounds=YES;
//    self.jiaose.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
//    self.jiaose.layer.borderWidth= 0.5f;
    self.jiaose.enabled = NO;

    
    app = [[UIApplication sharedApplication] delegate];
    
    self.shopName.delegate = self;//商铺名称
    self.shopName.layer.cornerRadius=0.0f;
    self.shopName.text = app.shopName;
    self.shopName.layer.masksToBounds=YES;
    self.shopName.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.shopName.layer.borderWidth= 0.5f;
    
    self.beizhu.delegate = self;//用户备注
     //边框
    self.beizhu.layer.cornerRadius=0.0f;
    self.beizhu.layer.masksToBounds=YES;
    self.beizhu.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.beizhu.layer.borderWidth= 0.5f;
    
    mutableArr  = [[NSMutableArray alloc] init];
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加用户
-(void)jiexi{
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
    
    NSString *userName = self.userName.text;
    NSString *nshowName = self.showName.text;
    NSString *npass = self.pass.text;
    NSString *role = nil;
    NSString *nShopName = app.shopName;
    NSString *nBeizhu = self.beizhu.text;
    
    
    NSLog(@"%@ %@ %@ %@",userName,nshowName,npass,nShopName);
    
    
    //设置之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签想对应
    matchingElement = @"CreateNewUserWithShopNameResult";
    //创建SOAP消息，内容格式就是网站声提示的请求豹纹的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?> "
                         "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\"> "
                         "<soap12:Body>"
                         "<CreateNewUserWithShopName xmlns=\"http://tempuri.org/\"> "
                         "<uname>%@</uname>"
                         "<upwd>%@</upwd>"
                         "<ushowname>%@</ushowname>"
                         "<urole>%@</urole>"
                         "<umemo>%@</umemo>"
                         "<cuid>%@</cuid>"
                         "<sname>%@</sname>"
                         "</CreateNewUserWithShopName>"
                         "</soap12:Body>"
                         "</soap12:Envelope>"
                         ,userName,npass,nshowName,role,nBeizhu,app.nameid,app.shopName];
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.100/jct/DataWebService.asmx"];
    NSLog(@"addConsumer:soapMsg:%@",soapMsg);
    
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
        NSLog(@"========_notes======%@",_notes);
    }
}

//追加找到的元素值，一个元素值可能要分几次追加
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    dict = [_notes lastObject];
    //添加用户
    if ([_currentTagName isEqualToString:@"info"] && dict) {
        [dict setObject:string forKey:@"info"];
    }
    
    //获取系统用户权限
    if ([_currentTagName isEqualToString:@"OPNAME"] && dict) {
        [dict setObject:string forKey:@"OPNAME"];
    }
}

//判断返回值是否是整形
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//结束解析这个元素名
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qNam
{
    if ([elementName isEqualToString:@"GetAllSysAccessResult"])
    {
        opName = [[NSMutableArray alloc] init];
        for (int i = 0; i< [_notes count]; i++)
        {
            NSString *str = [[_notes objectAtIndex:i] objectForKey:@"OPNAME"];
            [opName addObject:str];
        }
        //复选按钮
        
        for(int i = 0 ; i < [opName count]; i++)
            
        {
            CGFloat x = initialX + width * (i % column);
            CGFloat y = initialY + ( margin) * (i / column ) ;
            CGRect frame = CGRectMake(x, y, width, height);
            QCheckBox *checki = [[QCheckBox alloc] initWithDelegate:self frame:frame];
            
            [checki setTitle:[opName objectAtIndex:i] forState:UIControlStateNormal];
            //        [_check1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //        [_check1 setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
            //        [_check1.titleLabel setFont:[UIFont boldSystemFontOfSize:9.0f]];
            //        [_check1 setImage:[UIImage imageNamed:@"uncheck_icon.png"] forState:UIControlStateNormal];
            //        [_check1 setImage:[UIImage imageNamed:@"check_icon.png"] forState:UIControlStateSelected];
            [self.view addSubview:checki];
        }
    }
    if ([elementName isEqualToString:matchingElement])
    {
        if ([_currentTagName isEqualToString:@"info"]) {
            if ([self isPureInt:[dict objectForKey:@"info"]]) {
//                alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                   message:@"添加成功"
//                                                  delegate:self
//                                         cancelButtonTitle:@"确定"
//                                         otherButtonTitles:nil, nil];
//                
//                [alert show];
                neweruid = [dict objectForKey:@"info"];
                NSLog(@"[dict objectForKey:]:%@",neweruid);
                
                [self ResetUserAccess];//调用重置用户密码方法

            }else{
                alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                   message:[dict objectForKey:@"info"]
                                                  delegate:self
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
    //    self.currentTagName = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [HUD removeFromSuperview];
    
    
}

//解析整个文件结束后
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [[NSNotificationCenter defaultCenter] postNotificationName: @"reloadViewNotification" object:self.notes userInfo:nil];
    //进入该方法就意味着解析完成，需要清理一些成员变量，同时要将数据返回给表示层（表示图控制器） 通过广播机制将数据通过广播通知投送到 表示层
    self.notes = nil;
}

//出错时，例如强制结束解析
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    if (soapResults) {
        soapResults = nil;
    }
}

//添加用户
- (IBAction)save:(id)sender {
    [self jiexi];
}


#pragma  //重设用户权限  点击保存按钮，传入新添加用户的id，和权限一起存入用户权限表中

-(void)ResetUserAccess{
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
    NSString *string = [mutableArr componentsJoinedByString:@","];
    
    //设置之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签想对应
    matchingElement = @"ResetUserAccessResult";
    //创建SOAP消息，内容格式就是网站声提示的请求豹纹的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?> "
                         "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\"> "
                         "<soap12:Body>"
                         "<ResetUserAccess xmlns=\"http://tempuri.org/\"> "
                         "<uid>%@</uid>"
                         "<oplist>%@</oplist>"
                         "</ResetUserAccess>"
                         "</soap12:Body>"
                         "</soap12:Envelope>",neweruid,string];
    
    
    NSLog(@"newerid: %@, string:%@",neweruid,string);
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.100/jct/DataWebService.asmx"];
    NSLog(@"addConsumer:soapMsg:%@",soapMsg);
    
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

#pragma mark - QCheckBoxDelegate
//选中某些权限

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    if (checked) {
        [mutableArr  addObject:checkbox.titleLabel.text];
    }
    else{
        for (NSString * str in mutableArr)
        {
            if ([str isEqualToString:checkbox.titleLabel.text]){
                
                [mutableArr removeObject: str];
                
                break;//一定要有break，否则会出错的。
                
            }
        }
    }
    NSLog(@"mutableArr:%@",mutableArr);
}


@end
