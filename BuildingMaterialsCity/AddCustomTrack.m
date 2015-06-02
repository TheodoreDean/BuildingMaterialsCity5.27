//
//  AddCustomTrack.m
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/21.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import "AddCustomTrack.h"
#import "AppDelegate.h"
#import "CustomDatePicker.h"


@interface AddCustomTrack ()

@end

@implementation AddCustomTrack
{
    UIAlertView *alert;
    NSMutableDictionary *dict;
    AppDelegate *app;
    CustomDatePicker *picker;
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
    item.text = @"添加回访记录";
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
    
    self.customName.delegate = self;
    self.customName.enabled = NO;
    self.visiterName.delegate = self;
    self.visitContent.delegate = self;
    self.meMo.delegate = self;
    
    self.createrID.delegate = self;
    self.shopName.delegate = self;
    
    self.customName.backgroundColor = [UIColor colorWithRed:31.0/255 green:138.0/255 blue:204.0/255 alpha:1];
    self.visiterName.backgroundColor = [UIColor colorWithRed:31.0/255 green:138.0/255 blue:204.0/255 alpha:1];
    self.visitContent.backgroundColor = [UIColor colorWithRed:31.0/255 green:138.0/255 blue:204.0/255 alpha:1];
    self.meMo.backgroundColor = [UIColor colorWithRed:31.0/255 green:138.0/255 blue:204.0/255 alpha:1];
    self.shopName.backgroundColor = [UIColor colorWithRed:31.0/255 green:138.0/255 blue:204.0/255 alpha:1];
    
    app = [[UIApplication sharedApplication] delegate];
    self.customName.text = app.customerName;
    self.visiterName.text = app.name;
    self.shopName.text = app.shopName;
    
    picker = [[CustomDatePicker alloc] initWithFrame:CGRectMake(92, 265, 141, 22)];
    [self.view addSubview:picker];
    

}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建回访记录 
/*ustomerid:客户ID   salesuserid:回访人用户ID     trackdescription:回访内容   trackmemo:备注
tracktime:回访时间（yyyy-MM-dd)   createuserid:创建人用户ID    shopname:商铺名称
返回XML：TableName:result ElementName:info
成功：info=新增的回访记录ID
失败：info=错误信息*/

-(void)CreateCustomerTrack{

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
    NSString *time = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)picker.yearString,(long)picker.monthString,(long)picker.dayString];
    NSLog(@"time : %@",time);
    //设置之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签想对应
    matchingElement = @"CreateCustomerTrackResult";
    //创建SOAP消息，内容格式就是网站声提示的请求豹纹的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope "
                         "xmlns:xsi=\"http://www.w3.org/2001/XMLSchems-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<CreateCustomerTrack xmlns=\"http://tempuri.org/\">"
                         "<customerid>%@</customerid>"
                         "<salesuserid>%@</salesuserid>"
                         "<trackdescription>%@</trackdescription>"
                         "<trackmemo>%@</trackmemo>"
                         "<tracktime>%@</tracktime>"
                         "<createuserid>%@</createuserid>"
                         "<shopname>%@</shopname>"
                         "</CreateCustomerTrack>"
                         "</soap12:Body>"
                         "</soap12:Envelope>",app.customerID,app.nameid,self.visitContent.text,self.meMo.text,time,app.nameid,self.shopName.text];
    
    
    NSLog(@"%@      %@    %@     %@     %@      %@   %@ ",app.customerID,app.nameid,self.visitContent.text,self.meMo.text,time,app.nameid,self.shopName.text);
    
    
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


- (IBAction)addCustomTrack:(id)sender {
    [self CreateCustomerTrack];
}
@end
