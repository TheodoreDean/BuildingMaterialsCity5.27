//
//  ViewController.m
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/4/30.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
//#import "MBProgressHUD.h"
//#import "Reachability.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UIAlertView *alert;
    NSMutableDictionary *dict;
}

@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize conn;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userName.delegate = self;
    self.passWord.delegate = self;
    self.userName.placeholder = @"用户名";
    self.passWord.placeholder = @"密码";
//    self.passWord.secureTextEntry = YES;//密码隐藏不可见
    
    // 点击背景隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidekeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    self.navigationController.hidesBarsOnTap = YES;
    
}

//点击屏幕隐藏键盘
- (void)hidekeyboard:(UITapGestureRecognizer *)sender
{
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
}

//点击return隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma  特殊字符的判断
///////////////////////////////////
-(int)panduan:(NSString *)text{
    NSString *z =@"[A-Za-z0-9\u4e00-\u9fa5]+$";//特殊字符
    NSPredicate *n = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",z];
    int i = [n evaluateWithObject:text];
    return i;
}

- (IBAction)loginBtn:(id)sender {
    if ([self.userName.text isEqualToString:@""]||[self.passWord.text isEqualToString:@""]){
        alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                           message:@"用户名或密码不能为空！"
                                          delegate:self
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil, nil];
        [alert show];
    }else if ([self panduan:self.userName.text] == 0 || [self panduan:self.passWord.text] == 0){
        alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                           message:@"请不要输入特殊字符！"
                                          delegate:self
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil, nil];
        [alert show];
    }else{
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
        NSString *na = self.userName.text;
        NSString *pa = self.passWord.text;
        
        //设置之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签想对应
        matchingElement = @"UserLoginResult";
        //创建SOAP消息，内容格式就是网站声提示的请求豹纹的实体主体部分
        NSString *soapMsg = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap12:Envelope "
                             "xmlns:xsi=\"http://www.w3.org/2001/XMLSchems-instance\" "
                             "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                             "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                             "<soap12:Body>"
                             "<UserLogin xmlns=\"http://tempuri.org/\">"
                             "<username>%@</username>"
                             "<password>%@</password>"
                             "</UserLogin>"
                             "</soap12:Body>"
                             "</soap12:Envelope>",na,pa];
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
}

//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}


//结束解析这个元素名
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qNam
{
    if ([elementName isEqualToString:matchingElement]) {
        
        if ([_currentTagName isEqualToString:@"info"]) {
            bool i= [self isPureInt:[dict objectForKey:@"info"]];
            if(i==TRUE)
            {
                AppDelegate * app = [[UIApplication sharedApplication] delegate];
                
                app.nameid = [dict objectForKey:@"info"]; 
                [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"tab"] animated:YES completion:nil];
                self.userName.text = NULL;
                self.passWord.text = NULL;
                elementFound = FALSE;
                
                //强制放弃解析
                [xmlParser abortParsing];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    [HUD removeFromSuperview];
            }
            else
            {
                alert = [[UIAlertView alloc] initWithTitle:@"信息"
                                                  message:[NSString stringWithFormat:@"%@",[dict objectForKey:@"info"]]
                                                 delegate:self
                                        cancelButtonTitle:nil
                                        otherButtonTitles:nil];
                                     [alert show];
                         
                 elementFound = FALSE;
     
                 //强制放弃解析
                 [xmlParser abortParsing];
                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                 [HUD removeFromSuperview];
                 //设定定时器，让alert自动消失
                 [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(dismissAlert:)
                                                userInfo:nil
                                                 repeats:NO];
            }
        }
    }
}

//释放弹出框
-(void)dismissAlert:(NSTimer *)timer
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    //定时器停止使用：
    [timer invalidate];
    timer = nil;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)remberClick:(id)sender {
    NSLog(@"OK");
}


@end
