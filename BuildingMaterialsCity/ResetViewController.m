//
//  ResetViewController.m
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/12.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import "ResetViewController.h"
#import "AppDelegate.h"
#define initialX 48
#define initialY 267
#define width 75
#define height 21
#define margin 31
#define column 3

@interface ResetViewController ()

@end

@implementation ResetViewController
{
    UIAlertView *alert;
    NSMutableDictionary *dict;
    AppDelegate * app;
    NSMutableArray *opName;//所有权限数组
    NSMutableArray *opname;//用户权限数组
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

//页面加载的时候调用  在页面上显示用户的权限
-(void)viewWillAppear:(BOOL)animated{
    [super viewDidLoad];
    
    [self LoadUserAccessByUserID];
    
    [self GetAllSysAccess];
}

#pragma mark- 载入指定用户的所有权限
-(void)LoadUserAccessByUserID{
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
    
    NSString *uid = app.backNameid;
    NSLog(@"uid:%@",uid);
    
    //设置之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签想对应
    matchingElement = @"LoadUserAccessByUserIDResult";
    //创建SOAP消息，内容格式就是网站声提示的请求豹纹的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope "
                         "xmlns:xsi=\"http://www.w3.org/2001/XMLSchems-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<LoadUserAccessByUserID xmlns=\"http://tempuri.org/\">"
                         "<uid>%@</uid>"
                         "</LoadUserAccessByUserID>"
                         "</soap12:Body>"
                         "</soap12:Envelope>",uid];
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
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [navBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *item = [[UILabel alloc] initWithFrame:CGRectMake(0,20,320,20)];
    item.text = @"重置";
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
    
    //用户名
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(116, 103, 139, 21)];
    label.layer.cornerRadius = 0;
    app = [[UIApplication sharedApplication] delegate];
    
    label.text = [NSString stringWithFormat: @"  %@",app.showName];
    label.font = [UIFont fontWithName:@"Helvetica" size:11];
    label.backgroundColor = [UIColor whiteColor];
    label.layer.borderColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    label.layer.borderWidth = 0.5;
    [self.view addSubview:label];
    
    self.newerPass.delegate = self;
    self.newerPass.layer.cornerRadius=0.0f;
    self.newerPass.layer.masksToBounds=YES;
    self.newerPass.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.newerPass.layer.borderWidth= 0.5f;
    mutableArr = [[NSMutableArray alloc] init];
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma ResetUserPwd  重置用户密码（适用于管理员重置忘记密码用户的密码）
-(void)ResetUserPwd{
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
    
    NSString *uid = app.backNameid;//选中的用户id
    NSLog(@"uid:%@",uid);
    
    NSString *npwd = self.newerPass.text;
    NSLog(@"npwd:%@",npwd);
    
    NSString *cuid = app.nameid;//登录用户id
    NSLog(@"cuid:%@",cuid);
    
    //设置之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签想对应
    matchingElement = @"ResetUserPwdResult";
    //创建SOAP消息，内容格式就是网站声提示的请求豹纹的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope "
                         "xmlns:xsi=\"http://www.w3.org/2001/XMLSchems-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<ResetUserPwd xmlns=\"http://tempuri.org/\">"
                         "<uid>%@</uid>"
                         "<npwd>%@</npwd>"
                         "<cuid>%@</cuid>"
                         "</ResetUserPwd>"
                         "</soap12:Body>"
                         "</soap12:Envelope>",uid,npwd,cuid];
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

//保存按钮   重设用户密码
- (IBAction)reset:(id)sender {
    [self ResetUserPwd];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark-    //重设用户权限  点击保存按钮，传入新添加用户的id，和权限一起存入用户权限表中
- (IBAction)resetAccess:(id)sender {
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
                         "</soap12:Envelope>",app.backNameid,string];
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
    }
}

//追加找到的元素值，一个元素值可能要分几次追加
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    dict = [_notes lastObject];
    if ([_currentTagName isEqualToString:@"info"] && dict) {
        [dict setObject:string forKey:@"info"];
    }
    if ([_currentTagName isEqualToString:@"OPNAME"] && dict) {
        [dict setObject:string forKey:@"OPNAME"];
        NSLog(@" OPNAME:%@",[dict objectForKey:@"OPNAME"]);
    }
}

//结束解析这个元素名
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qNam
{
    if ([elementName isEqualToString:@"LoadUserAccessByUserIDResult"])
    {
        opname = [[NSMutableArray alloc] init];
        for (int i = 0; i< [_notes count]; i++)
        {
            NSString *str = [[_notes objectAtIndex:i] objectForKey:@"OPNAME"];
            [opname addObject:str];
        }
        NSLog(@"1111111  opname: %@",opname);
    }
    if ([elementName isEqualToString:@"GetAllSysAccessResult"])
    {
        opName = [[NSMutableArray alloc] init];
        for (int i = 0; i< [_notes count]; i++)
        {
            NSString *str = [[_notes objectAtIndex:i] objectForKey:@"OPNAME"];
            [opName addObject:str];
        }
        NSLog(@"22222222  opName: %@",opName);
        
        //复选按钮
        for(int i = 0 ; i < [opName count]; i++)
        {
            CGFloat x = initialX + width * (i % column);
            CGFloat y = initialY + ( margin) * (i / column );
            CGRect frame = CGRectMake(x, y, width, height);
            QCheckBox *checki = [[QCheckBox alloc] initWithDelegate:self frame:frame];
            
            [checki setTitle:[opName objectAtIndex:i] forState:UIControlStateNormal];
            [self.view addSubview:checki];
            
            for(int j = 0; j < [opname count] ; j++)
            {
                if([ opname[j] isEqualToString:[opName objectAtIndex:i]])
                {
                    checki.selected = YES;
                    [mutableArr addObject:checki.titleLabel.text];
                    NSLog(@"==== %@  ==========%@",[opName objectAtIndex:i],opname[j]);
                    NSLog(@"0000000000000");
                }
                else {
                    NSLog(@"ssssfwsaytgdhb");
                }
            }
        }
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [HUD removeFromSuperview];
//    _currentTagName = nil;
}

//解析整个文件结束后
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [[NSNotificationCenter defaultCenter] postNotificationName: @"reloadViewNotification" object:self.notes userInfo:nil];
    //进入该方法就意味着解析完成，需要清理一些成员变量，同时要将数据返回给表示层（表示图控制器） 通过广播机制将数据通过广播通知投送到 表示层
   NSLog(@"cccccccc  OPNAME:%@",_notes);
    self.notes = nil;
}

//出错时，例如强制结束解析
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    if (soapResults) {
        soapResults = nil;
    }
}


#pragma mark - QCheckBoxDelegate
//选中某些权限

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    if (checked) {
        [mutableArr  addObject:checkbox.titleLabel.text];
        
        NSLog(@"22222222:%@",mutableArr);
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
