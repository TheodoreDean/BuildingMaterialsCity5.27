//
//  ChangeViewController.m
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/4.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import "ChangeViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"


@interface ChangeViewController ()

@end

@implementation ChangeViewController{
    UIAlertView *alert;
    NSMutableDictionary *dict;
    AppDelegate * app;
}

@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize conn;

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    [navBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *item = [[UILabel alloc] initWithFrame:CGRectMake(0,20,320,20)];
    item.text = @"修改个人资料";
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(116, 80, 139, 21)];
    label.layer.cornerRadius = 0;
    app = [[UIApplication sharedApplication] delegate];
    
    label.text = [NSString stringWithFormat: @"  %@",app.name];
    label.font = [UIFont fontWithName:@"Helvetica" size:11];
    label.backgroundColor = [UIColor whiteColor];
    label.layer.borderColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    label.layer.borderWidth = 0.5;
    [self.view addSubview:label];
    
    self.showName.delegate = self;
    self.showName.text = [NSString stringWithFormat: @"%@",app.showName];
    self.showName.layer.cornerRadius=0.0f;
    self.showName.layer.masksToBounds=YES;
    self.showName.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.showName.layer.borderWidth= 0.5f;
    
    self.pass.delegate = self;//旧密码
    self.pass.layer.cornerRadius=0.0f;
    self.pass.layer.masksToBounds=YES;
    self.pass.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.pass.layer.borderWidth= 0.5f;
    
    self.newerPass.delegate = self;//新密码
    self.newerPass.layer.cornerRadius=0.0f;
    self.newerPass.layer.masksToBounds=YES;
    self.newerPass.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.newerPass.layer.borderWidth= 0.5f;
    
    self.passOk.delegate = self;//确认密码
    self.passOk.layer.cornerRadius=0.0f;
    self.passOk.layer.masksToBounds=YES;
    self.passOk.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.passOk.layer.borderWidth= 0.5f;
    
//    self.pass.secureTextEntry = YES;
//    self.newerPass.secureTextEntry = YES;
//    self.passOk.secureTextEntry = YES;
    
    // 点击背景隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidekeyboard:)];
    [self.view addGestureRecognizer:tap];
    
}

//点击屏幕隐藏键盘
- (void)hidekeyboard:(UITapGestureRecognizer *)sender
{
    [self.showName resignFirstResponder];
    [self.pass resignFirstResponder];
    [self.passOk resignFirstResponder];
}

//点击return隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
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

#pragma  特殊字符的判断
///////////////////////////////////
-(int)panduan:(NSString *)text{
    NSString *z =@"[A-Za-z0-9\u4e00-\u9fa5]+$";//特殊字符
    NSPredicate *n = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",z];
    int i = [n evaluateWithObject:text];
    return i;
}

///////////////////////////////////
//限定textField的长度
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    int MAXLength = 20;
    NSInteger strLength = textField.text.length - range.length + string.length;
    return (strLength  <= MAXLength);
}

#pragma  网络解析 修改个人资料－－－－修改显示名 密码
-(void)UpdateUserInfoByUserIDAndPwd{
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
    NSString *uid;
    NSString *pwd;
    app = [[UIApplication sharedApplication] delegate];
    uid = app.nameid;
    pwd = app.passWord;
    NSLog(@"uid:%@",uid);
    
    NSString *npwd = self.newerPass.text;
    NSString *nshowname = self.showName.text;
    NSString *upuid = app.nameid;
    
    //设置之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签想对应
    matchingElement = @"UpdateUserInfoByUserIDAndPwdResult";
    //创建SOAP消息，内容格式就是网站声提示的请求豹纹的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope "
                         "xmlns:xsi=\"http://www.w3.org/2001/XMLSchems-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<UpdateUserInfoByUserIDAndPwd xmlns=\"http://tempuri.org/\">"
                         "<uid>%@</uid>"
                         "<pwd>%@</pwd>"
                         "<npwd>%@</npwd>"
                         "<nshowname>%@</nshowname>"
                         "<upuid>%@</upuid>"
                         "</UpdateUserInfoByUserIDAndPwd>"
                         "</soap12:Body>"
                         "</soap12:Envelope>",uid,pwd,npwd,nshowname,upuid];
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.100/jct/DataWebService.asmx"];
    NSLog(@"change:soapMsg:%@",soapMsg);
    
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
        NSLog(@"dict:%@",[dict objectForKey:@"info"]);
    }
}

//结束解析这个元素名
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qNam
{
    if ([elementName isEqualToString:matchingElement]) {
        if ([_currentTagName isEqualToString:@"info"]) {
            if ([[dict objectForKey:@"info"] isEqualToString:@"ok"]) {
            if ([self.pass.text isEqualToString:app.passWord] && [self.newerPass.text isEqualToString:self.passOk.text]){
                    alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"信息修改成功，请重新登录"
                                                      delegate:self
                                             cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                }
                
            }
            else{
                alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                   message:[dict objectForKey:@"info"]
                                                  delegate:self
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
    NSLog(@"app.pass:%@",app.passWord);
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

- (IBAction)save:(id)sender {
    if ([self.showName.text  isEqual: @""] || [self.pass.text  isEqual: @""] || [self.newerPass.text  isEqual: @""] ||[self.passOk.text  isEqual: @""]) {
        alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                           message:@"您输入的信息不完整，请填写完整！"
                                          delegate:self
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([self panduan:self.showName.text] == 0 || [self panduan:self.pass.text] == 0 || [self panduan:self.newerPass.text] == 0 ||[self panduan:self.passOk.text] == 0) {
        alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                           message:@"请不要输入特殊字符！"
                                          delegate:self
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil, nil];
        [alert show];
    }else if (![self.newerPass.text isEqualToString: self.passOk.text]){
        alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                           message:@"新密码与确认密码不符！"
                                          delegate:self
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil, nil];
        [alert show];
    }
    
    else{
        [self UpdateUserInfoByUserIDAndPwd];
    }
}
@end
