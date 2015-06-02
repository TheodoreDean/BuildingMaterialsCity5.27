//
//  IndividualCenterViewController.m
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/4/30.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import "IndividualCenterViewController.h"
#import "ChangeViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "UserViewController.h"
#import "UserViewController.h"

@interface IndividualCenterViewController ()

@end

@implementation IndividualCenterViewController
{
    UIAlertView *alert;
    NSMutableDictionary *dict;
    UILabel *label;
    UILabel *uLabel;
    UILabel *jLabel;
    UILabel *lLabel;
    UILabel *sLabel;
    UILabel *cLabel;
    AppDelegate * app;
    UIButton *right;
}

@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize conn;

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
    
    NSString *uid = app.nameid;
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

//解析 显示个人资料
-(void)viewWillAppear:(BOOL)animated{
    [super viewDidLoad];
//    //初始化进度框，置于当前的View中
//    HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    //如果设置此属性则当前的view置于后台
//    HUD.dimBackground = YES;
//    HUD.labelText = @"请稍等"; //设置对话框文字
    //显示对话框
    [HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(3);
    }completionBlock:^{
        //操作执行完后取消对话框
        [HUD removeFromSuperview];
        HUD = nil;
    }];
    NSString *uid;
    
    app = [[UIApplication sharedApplication] delegate];
    uid = app.nameid;
    NSLog(@"uid:%@",uid);
    
    //设置之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签想对应
    matchingElement = @"GetUserInfoByUserIDResult";
    //创建SOAP消息，内容格式就是网站声提示的请求豹纹的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope "
                         "xmlns:xsi=\"http://www.w3.org/2001/XMLSchems-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<GetUserInfoByUserID xmlns=\"http://tempuri.org/\">"
                         "<uid>%@</uid>"
                         "</GetUserInfoByUserID>"
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
    
    
     [self LoadUserAccessByUserID];
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
    
    if ([_currentTagName isEqualToString:@"USERNAME"] && dict) {//用户名
        [dict setObject:string forKey:@"USERNAME"];
    }
    if ([_currentTagName isEqualToString:@"USERPWD"] && dict) {//密码
        [dict setObject:string forKey:@"USERPWD"];
    }
    if ([_currentTagName isEqualToString:@"SHOWNAME"] && dict) {//显示名
        [dict setObject:string forKey:@"SHOWNAME"];
    }
    if ([_currentTagName isEqualToString:@"USERROLE"] && dict) {//用户角色
        [dict setObject:string forKey:@"USERROLE"];
    }
    if ([_currentTagName isEqualToString:@"SHOPNAME"] && dict) {//店铺名
        [dict setObject:string forKey:@"SHOPNAME"];
    }
    if ([_currentTagName isEqualToString:@"USERSTATUS"] && dict) {//账号状态
        [dict setObject:string forKey:@"USERSTATUS"];
    }
    if ([_currentTagName isEqualToString:@"CREATETIME"] && dict) {//创建时间
        [dict setObject:string forKey:@"CREATETIME"];
    }
    if ([_currentTagName isEqualToString:@"OPNAME"] && dict) {
        [dict setObject:string forKey:@"OPNAME"];
        NSLog(@" OPNAME:%@",[dict objectForKey:@"OPNAME"]); //用户权限
    }
}


//结束解析这个元素名
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qNam
{
    if ([elementName isEqualToString:@"GetUserInfoByUserIDResult"])
    {
        label.text = [NSString stringWithFormat: @"\t用户名：%@",[dict objectForKey:@"USERNAME"]];
        uLabel.text = [NSString stringWithFormat:@"\t显示名：%@",[dict objectForKey:@"SHOWNAME"]];
    //    jLabel.text = [NSString stringWithFormat:@"            角色：%@",[dict objectForKey:@"USERROLE"]];
        lLabel.text = [NSString stringWithFormat:@"\t店铺名：%@",[dict objectForKey:@"SHOPNAME"]];

        //把0，1转换为状态
        switch ([[dict objectForKey:@"USERSTATUS"] integerValue]) {
            case 0:
                sLabel.text = [NSString stringWithFormat:@"\t账号状态：无效"];
                break;
            case 1:
                sLabel.text = [NSString stringWithFormat:@"\t账号状态：有效"];
                break;
            default:
                break;
        }
        
        cLabel.text = [NSString stringWithFormat:@"\t创建时间：%@",[[dict objectForKey:@"CREATETIME"] substringWithRange:NSMakeRange(0, 10)]];
    
    
        //    //判断是否是管理员 如果是管理员，左上角增加一个搜索按钮，跳转到用户管理页面
        //    if ([[dict objectForKey:@"USERROLE"] isEqualToString:@"A"]) {
        //        //搜索按钮
        //        UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [left setFrame:CGRectMake(20,24,14,14)];
        //        [left setImage:[UIImage imageNamed:@"ss.png"] forState:UIControlStateNormal];
        //        [left addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
        //        [navBar addSubview:left];
        //    }
        app = [[UIApplication sharedApplication] delegate];
        //    app.jiaose = [dict objectForKey:@"USERROLE"];//用于判断是否是管理员，是否在用户管理页面显示添加按钮
        //    NSLog(@"role:%@",app.jiaose);
        app.shopName = [dict objectForKey:@"SHOPNAME"];//用于在用户管理页面传值，作为主键筛选显示用户
        NSLog(@" app.shopName:%@",app.shopName);
        app.name = [dict objectForKey:@"USERNAME"];
        app.showName = [dict objectForKey:@"SHOWNAME"];
        app.passWord = [dict objectForKey:@"USERPWD"];
        NSLog(@"app.name:%@     app.showname:%@   app.password:%@",app.name,app.showName,app.passWord);
    }
    
    
    if ([elementName isEqualToString:@"LoadUserAccessByUserIDResult"])
    {
       NSMutableArray *opname = [[NSMutableArray alloc] init];
        for (int i = 0; i< [_notes count]; i++)
        {
            NSString *str = [[_notes objectAtIndex:i] objectForKey:@"OPNAME"];
            [opname addObject:str];
        }
        if ([opname count] == 0) {
            right.hidden = YES;
        }
        app.opnames = opname;
        
        for(int i = 0 ; i < [opname count] ; i++ )
        {
            if ([[opname objectAtIndex:i] isEqualToString:@"用户管理"]) {
               right.hidden = NO;
                app.userAccess = @"用户管理";
                break;
            }
            
            else {
                right.hidden = YES;
                app.userAccess = nil;
            }
        }
        NSLog(@"1111111  opname: %@",opname);
        
        for(int i = 0 ; i < [opname count] ; i++ )
        {
            if ([[opname objectAtIndex:i] isEqualToString:@"店长管理"]) {
                app.userAccess1 = @"店长管理";
            }
            else {
                app.userAccess1 = nil;
            }
        }
    }
    
    
    

    self.currentTagName = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [HUD removeFromSuperview];
}

//-(void)search{//跳转到用户管理页面
//    app = [[UIApplication sharedApplication] delegate];
//    app.jiaose = [dict objectForKey:@"USERROLE"];
//    UserViewController *user = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
//    [self presentViewController:user animated:YES completion:nil];
//}

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

- (void)viewDidLoad {
    [super viewDidLoad];

     UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [navBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *item = [[UILabel alloc] initWithFrame:CGRectMake(0,20,320,20)];
    item.text = @"个人中心";
    item.textAlignment = 1;
    item.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    item.textColor = [UIColor whiteColor];
    [navBar addSubview:item];
    
    [self.view addSubview:navBar];
    
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:250.0/255 alpha:1];
    
    //用户名
    label = [[UILabel alloc] initWithFrame:CGRectMake(55, 71, 210, 20)];
    label.layer.cornerRadius = 0.0f;
    label.font = [UIFont fontWithName:@"Helvetica" size:11];
    label.backgroundColor = [UIColor whiteColor];
    label.layer.borderColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    label.layer.borderWidth = 0.5;
    [self.view addSubview:label];
    
    //显示名
    uLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 100, 210, 20)];
    uLabel.layer.cornerRadius = 0.0f;
    uLabel.font = [UIFont fontWithName:@"Helvetica" size:11];
    uLabel.backgroundColor = [UIColor whiteColor];
    uLabel.layer.borderColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    uLabel.layer.borderWidth = 0.5;
    [self.view addSubview:uLabel];
    
    //角色  隐藏
    jLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 120, 210, 20)];
    jLabel.layer.cornerRadius = 0.0f;
    jLabel.font = [UIFont fontWithName:@"Helvetica" size:11];
    jLabel.backgroundColor = [UIColor whiteColor];
    jLabel.layer.borderColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    jLabel.layer.borderWidth = 0.5;
//    [self.view addSubview:jLabel];
    
    //店铺名
    lLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 140, 210, 20)];
    lLabel.layer.cornerRadius = 0.0f;
    lLabel.font = [UIFont fontWithName:@"Helvetica" size:11];
    lLabel.backgroundColor = [UIColor whiteColor];
    lLabel.layer.borderColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    lLabel.layer.borderWidth = 0.5;
    [self.view addSubview:lLabel];
    
    //跳转到用户管理页面
    right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setFrame:CGRectMake(200 ,140, 65, 20)];
    [right setTitle:@"用户管理" forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:11];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [right addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:right];
    
    //账号状态
    sLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 160, 210, 20)];
    sLabel.layer.cornerRadius = 0.0f;
    sLabel.font = [UIFont fontWithName:@"Helvetica" size:11];
    sLabel.backgroundColor = [UIColor whiteColor];
    sLabel.layer.borderColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    sLabel.layer.borderWidth = 0.5;
    [self.view addSubview:sLabel];
    
    //创建时间
    cLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 180, 210, 20)];
    cLabel.layer.cornerRadius = 0.0f;
    cLabel.font = [UIFont fontWithName:@"Helvetica" size:11];
    cLabel.backgroundColor = [UIColor whiteColor];
    cLabel.layer.borderColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    cLabel.layer.borderWidth = 0.5;
    [self.view addSubview:cLabel];

}

//跳转到用户管理页面
-(void)jump{
//    app.shopName = [dict objectForKey:@"SHOPNAME"];
    UserViewController *user = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
    [self presentViewController:user animated:YES completion:nil];
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

//修改个人资料
- (IBAction)change:(id)sender {
    
    ChangeViewController *change = [[ChangeViewController alloc] initWithNibName:@"ChangeViewController" bundle:nil];
    [self presentViewController:change animated:YES completion:nil];
}

//退出账号
- (IBAction)exit:(id)sender {
    app.userAccess = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
