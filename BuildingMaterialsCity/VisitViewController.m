//
//  VisitViewController.m
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/7.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import "VisitViewController.h"
#import "ChangeVisitViewController.h"
#import "AppDelegate.h"
#import "AddCustomTrack.h"

@interface VisitViewController ()

@end

@implementation VisitViewController
{
    UIAlertView *alert;
    NSMutableDictionary *dict;
    AppDelegate *app;
}


@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize conn;

#pragma mark - GetCustomerTrackInfoByTrackID   查询指定回访记录的详细信息
/*
 trackid:回访记录ID
 返回XML：TableName:result 错误信息ElementName:info
*/
-(void)GetCustomerTrackInfoByTrackID{
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
   app = [[UIApplication sharedApplication] delegate];
    //设置之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签想对应
    matchingElement = @"GetCustomerTrackInfoByTrackIDResult";
    //创建SOAP消息，内容格式就是网站声提示的请求豹纹的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope "
                         "xmlns:xsi=\"http://www.w3.org/2001/XMLSchems-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<GetCustomerTrackInfoByTrackID xmlns=\"http://tempuri.org/\">"
                         "<trackid>%@</trackid>"
                         "</GetCustomerTrackInfoByTrackID>"
                         "</soap12:Body>"
                         "</soap12:Envelope>",app.trackID];
    
    
    NSLog(@"%@      ",app.trackID);
    
    
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
    }
}

//追加找到的元素值，一个元素值可能要分几次追加
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    dict = [_notes lastObject];
    if ([_currentTagName isEqualToString:@"CUSTOMERNAME"] && dict) {
        [dict setObject:string forKey:@"CUSTOMERNAME"];
    }
    if ([_currentTagName isEqualToString:@"SALESUSHOWNAME"] && dict) {
        [dict setObject:string forKey:@"SALESUSHOWNAME"];
    }
    if ([_currentTagName isEqualToString:@"TRACKDESCRIPTION"] && dict) {
        [dict setObject:string forKey:@"TRACKDESCRIPTION"];
    }
    if ([_currentTagName isEqualToString:@"TRACKTIME"] && dict) {
        [dict setObject:string forKey:@"TRACKTIME"];
    }
    if ([_currentTagName isEqualToString:@"CREATETIME"] && dict) {
        [dict setObject:string forKey:@"CREATETIME"];
    }
    
    if ([_currentTagName isEqualToString:@"info"] && dict) {
        [dict setObject:string forKey:@"info"];
    }
}

//结束解析这个元素名
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qNam
{
    if ([elementName isEqualToString:matchingElement]) {
        self.visitGuest.text = [NSString stringWithFormat:@"\t回访客户：%@",[dict objectForKey:@"CUSTOMERNAME"]];
        self.visitName.text = [NSString stringWithFormat:@"\t回访人员：%@",[dict objectForKey:@"SALESUSHOWNAME"]];
        self.visitContent.text = [NSString stringWithFormat:@"\t回访内容：%@",[dict objectForKey:@"TRACKDESCRIPTION"]];
        self.visitContent.font = [UIFont fontWithName:@"Arial" size:9.0];

        self.trackTime.text = [NSString stringWithFormat:@"\t回访时间：%@",[[dict objectForKey:@"TRACKTIME"] substringWithRange:NSMakeRange(0, 10)]];
        self.createTime.text = [NSString stringWithFormat:@"\t创建时间：%@",[[dict objectForKey:@"CREATETIME"] substringWithRange:NSMakeRange(0, 10)]];
        //强制放弃解析
        [xmlParser abortParsing];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [HUD removeFromSuperview];
        elementFound = FALSE;
    }
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

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [navBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *item = [[UILabel alloc] initWithFrame:CGRectMake(0,20,320,20)];
    item.text = @"回访详情";
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
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setFrame:CGRectMake(288,24,12,12)];
    [right setImage:[UIImage imageNamed:@"tj.png"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:right];
    
    self.visitGuest.layer.cornerRadius=0.0f;//回访客户 姓名
    self.visitGuest.layer.masksToBounds=YES;
    self.visitGuest.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.visitGuest.layer.borderWidth= 0.5f;
    
    self.visitName.layer.cornerRadius=0.0f;//回访人员 姓名
    self.visitName.layer.masksToBounds=YES;
    self.visitName.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.visitName.layer.borderWidth= 0.5f;
    
    self.visitContent.delegate = self;
    self.visitContent.layer.cornerRadius=0.0f;//回访内容
    self.visitContent.layer.masksToBounds=YES;
    self.visitContent.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.visitContent.layer.borderWidth= 0.5f;
    self.visitContent.backgroundColor = [UIColor clearColor];
    
    self.trackTime.layer.cornerRadius=0.0f;//回访时间
    self.trackTime.layer.masksToBounds=YES;
    self.trackTime.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.trackTime.layer.borderWidth= 0.5f;
    
    self.createTime.layer.cornerRadius=0.0f;//创建时间
    self.createTime.layer.masksToBounds=YES;
    self.createTime.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.createTime.layer.borderWidth= 0.5f;


    [self GetCustomerTrackInfoByTrackID];
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)add{
    
    AddCustomTrack *add = [[AddCustomTrack alloc] initWithNibName:@"AddCustomTrack" bundle:nil];
    [self presentViewController:add animated:YES completion:nil];
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

- (IBAction)changeBtn:(id)sender {
    ChangeVisitViewController *change = [[ChangeVisitViewController alloc] initWithNibName:@"ChangeVisitViewController" bundle:nil];
    [self presentViewController:change animated:NO completion:nil];
}
@end
