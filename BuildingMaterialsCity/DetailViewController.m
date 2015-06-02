//
//  DetailViewController.m
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/6.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import "DetailViewController.h"
#import "ChangeManageViewController.h"
#import "AddguestViewController.h"
#import "AppDelegate.h"
#import "VisitViewController.h"
#import "VisitViewController.h"


@interface DetailViewController ()

@end

@implementation DetailViewController{
    NSMutableDictionary *dict;
    
//    NSMutableArray *customTrackNameLTableArray;
//    NSMutableArray *trackContentLTableArray;
//    NSMutableArray *trackmemoTableArray;
//    NSMutableArray *trackTimeTableArray;
    
    NSString *orderBy;
    AppDelegate *app;

}

@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize conn;


-(void)viewWillAppear:(BOOL)animated{
    [super viewDidLoad];
    app = [[UIApplication sharedApplication] delegate];
    self.name.text = [NSString stringWithFormat:@"\t客户姓名: %@",app.customerName];
    self.tel.text = [NSString stringWithFormat:@"\t客户电话: %@",app.telNumber];
    self.xiaoqu.text = [NSString stringWithFormat: @"\t小区：%@",app.xiaoQu];
    self.address.text = [NSString stringWithFormat: @"\t地址：%@",app.address];
    self.enterTime.text = [NSString stringWithFormat:@"\t进店时间：%@",[app.FTime substringWithRange:NSMakeRange(0, 10)]];
    
    self.toTime.text = [NSString stringWithFormat:@"\t意向时间：%@",[app.IntTime substringWithRange:NSMakeRange(0, 10)]];
    self.toProduct.text = [NSString stringWithFormat:@"\t意向产品：%@",app.product];
    self.charger.text = [NSString stringWithFormat:@"\t负责人ID：%@",app.nameid];
    
    [self GetCustomerTrackByCustomerID];

}

#pragma mark - 查询回访信息
//查询客户信息
-(void)GetCustomerTrackByCustomerID
{
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
    orderBy = @"TRACKTIME DESC";
    
    //设置之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签想对应
    matchingElement = @"GetCustomerTrackByCustomerIDResult";
    //创建SOAP消息，内容格式就是网站声提示的请求豹纹的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?> "
                         "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\"> "
                         "<soap12:Body>"
                         "<GetCustomerTrackByCustomerID xmlns=\"http://tempuri.org/\">"
                         "<customerid>%@</customerid>"
                         "<orderby>%@</orderby>"
                         "</GetCustomerTrackByCustomerID>"
                         "</soap12:Body>"
                         "</soap12:Envelope>",app.customerID,orderBy];
    
    NSLog(@"%@   %@ ~~orderby~~",app.customerID,orderBy);
    
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
    if ([_currentTagName isEqualToString:@"SALESUSHOWNAME"] && dict) {//回访人姓名
        [dict setObject:string forKey:@"SALESUSHOWNAME"];
    }
    if ([_currentTagName isEqualToString:@"TRACKDESCRIPTION"] && dict) {//回访内容
        [dict setObject:string forKey:@"TRACKDESCRIPTION"];
    }
    if ([_currentTagName isEqualToString:@"TRACKMEMO"] && dict) {//回访备注
        [dict setObject:string forKey:@"TRACKMEMO"];
    }
    
    if ([_currentTagName isEqualToString:@"TRACKTIME"] && dict) {//回访时间
        [dict setObject:string forKey:@"TRACKTIME"];
    }
    if ([_currentTagName isEqualToString:@"TRACKID"] && dict) {//回访记录ID
        [dict setObject:string forKey:@"TRACKID"];
    }
    
    if ([_currentTagName isEqualToString:@"info"] && dict) {//结果
        [dict setObject:string forKey:@"info"];
    }
    
}

//结束解析这个元素名
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:matchingElement]) {
        NSLog(@"huifang: %@",_notes);
        
//        customTrackNameLTableArray = [[NSMutableArray alloc] init];
//        trackContentLTableArray = [[NSMutableArray alloc] init];
//        trackmemoTableArray = [[NSMutableArray alloc] init];
//        trackTimeTableArray = [[NSMutableArray alloc] init];
//        
//        for(int i = 0 ; i < [_notes count]; i++)
//        {
//            [customTrackNameLTableArray addObject: [[_notes objectAtIndex:i] objectForKey:@"SALESUSHOWNAME"]];
//            [trackContentLTableArray  addObject:[[_notes objectAtIndex:i] objectForKey:@"TRACKDESCRIPTION"]];
//            if([[_notes objectAtIndex:i] objectForKey:@"TRACKMEMO"] != nil)
//            {
//                [trackmemoTableArray  addObject:[[_notes objectAtIndex:i] objectForKey:@"TRACKMEMO"]];
//            }else{
//                [trackmemoTableArray  addObject:@"空"];
//            }
//            
//            [trackTimeTableArray  addObject:[[_notes objectAtIndex:i] objectForKey:@"TRACKTIME"]];
//            
//            
//            
//        }
//        NSLog(@"%@   ~~ %@  ～～  %@  ~~%@  ",customTrackNameLTableArray,trackContentLTableArray,trackmemoTableArray,trackTimeTableArray);
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [HUD removeFromSuperview];
}

//解析整个文件结束后
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [[NSNotificationCenter defaultCenter] postNotificationName: @"reloadViewNotification" object:self.notes userInfo:nil];
    //进入该方法就意味着解析完成，需要清理一些成员变量，同时要将数据返回给表示层（表示图控制器） 通过广播机制将数据通过广播通知投送到 表示层
    
    [_customerTrack reloadData];
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
    item.text = @"意向客户详情";
    item.textAlignment = 1;
    item.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    item.textColor = [UIColor whiteColor];
    [navBar addSubview:item];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(20,24,10,13)];
    [left setImage:[UIImage imageNamed:@"fh.png"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:left];
    
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    [delete setFrame:CGRectMake(241,19,26,22)];
    [delete setTitle:@"删除" forState:UIControlStateNormal];
    [delete setTintColor:[UIColor whiteColor]];
    delete.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
    [delete addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
//    [navBar addSubview:delete];暂时隐藏
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(276, 24, 1, 12)];
    l.backgroundColor = [UIColor whiteColor];
//    [navBar addSubview:l];暂时隐藏
    
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setFrame:CGRectMake(288,24,12,12)];
    [right setImage:[UIImage imageNamed:@"tj.png"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:right];
    
    
    [self.view addSubview:navBar];
    
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:250.0/255 alpha:1];
    

    self.name.layer.cornerRadius = 0.0f;
    
    self.name.font = [UIFont fontWithName:@"Helvetica" size:9.0];
    self.name.backgroundColor = [UIColor whiteColor];
    self.name.layer.borderColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.name.layer.borderWidth = 0.5;
    
    
    self.tel.layer.cornerRadius = 0.0f;
    
    self.tel.font = [UIFont fontWithName:@"Helvetica" size:9.0];
    self.tel.backgroundColor = [UIColor whiteColor];
    self.tel.layer.borderColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.tel.layer.borderWidth = 0.5;
    
    self.xiaoqu.layer.cornerRadius = 0.0f;
    
    self.xiaoqu.font = [UIFont fontWithName:@"Helvetica" size:9.0];
    self.xiaoqu.backgroundColor = [UIColor whiteColor];
    self.xiaoqu.layer.borderColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.xiaoqu.layer.borderWidth = 0.5;
    
    self.address.layer.cornerRadius = 0.0f;
    
    self.address.font = [UIFont fontWithName:@"Helvetica" size:9.0];
    self.address.backgroundColor = [UIColor whiteColor];
    self.address.layer.borderColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.address.layer.borderWidth = 0.5;
    
    self.enterTime.layer.cornerRadius = 0.0f;
    
    self.enterTime.font = [UIFont fontWithName:@"Helvetica" size:9.0];
    self.enterTime.backgroundColor = [UIColor whiteColor];
    self.enterTime.layer.borderColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.enterTime.layer.borderWidth = 0.5;
    
    self.toTime.layer.cornerRadius = 0.0f;
    
    self.toTime.font = [UIFont fontWithName:@"Helvetica" size:9.0];
    self.toTime.backgroundColor = [UIColor whiteColor];
    self.toTime.layer.borderColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.toTime.layer.borderWidth = 0.5;
    
    self.toProduct.layer.cornerRadius = 0.0f;
    
    self.toProduct.font = [UIFont fontWithName:@"Helvetica" size:9.0];
    self.toProduct.backgroundColor = [UIColor whiteColor];
    self.toProduct.layer.borderColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.toProduct.layer.borderWidth = 0.5;
    
    self.charger.layer.cornerRadius = 0.0f;
    
    self.charger.font = [UIFont fontWithName:@"Helvetica" size:9.0];
    self.charger.backgroundColor = [UIColor whiteColor];
    self.charger.layer.borderColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.charger.layer.borderWidth = 0.5;
    
    //    背景条
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 350, 320, 20)];
    label1.backgroundColor = [UIColor colorWithRed:31.0/255 green:138.0/255 blue:204.0/255 alpha:1];
    [self.view addSubview:label1];
    
    
    //回访人
    UILabel *tracker = [[UILabel alloc] initWithFrame:CGRectMake(0, 350, 35, 20)];
    tracker.text = @"回访人";
    tracker.textColor = [UIColor whiteColor];
    tracker.textAlignment = 1;
    tracker.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
    [self.view addSubview:tracker];
    
    //回访内容
    UILabel *trackContent = [[UILabel alloc] initWithFrame:CGRectMake(35, 350, 125, 20)];
    trackContent.text = @"回访内容";
    trackContent.textColor = [UIColor whiteColor];
    trackContent.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
    trackContent.backgroundColor = [UIColor clearColor];
    trackContent.textAlignment = 1;
    [self.view addSubview:trackContent];
    
    //备注
    UILabel *beizhu = [[UILabel alloc] initWithFrame:CGRectMake(160, 350, 100, 20)];
    beizhu.text = @"备注";
    beizhu.textColor = [UIColor whiteColor];
    beizhu.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
    beizhu.backgroundColor = [UIColor clearColor];
    beizhu.textAlignment = 1;
    [self.view addSubview:beizhu];
    
    //回访时间
    UILabel *trackTime = [[UILabel alloc] initWithFrame:CGRectMake(260, 350, 50, 20)];
    trackTime.text = @"回访时间";
    trackTime.textColor = [UIColor whiteColor];
    trackTime.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
    trackTime.backgroundColor = [UIColor clearColor];
    trackTime.textAlignment = 1;
    [self.view addSubview:trackTime];
    
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)delete{
    NSLog(@"aa");
    
}


-(void)add{
    AddguestViewController *addGuest = [[AddguestViewController alloc] initWithNibName:@"AddguestViewController" bundle:nil];
    [self presentViewController:addGuest animated:YES completion:nil];
}


- (IBAction)changeBtn:(id)sender {
    ChangeManageViewController *change = [[ChangeManageViewController alloc] initWithNibName:@"ChangeManageViewController" bundle:nil];
    [self presentViewController:change animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_notes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }else{
        // 删除cell中的子对象,刷新覆盖问题。
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    //回访人
    UILabel *customNameL = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 35, 20)];
    customNameL.text = [[_notes objectAtIndex:indexPath.row] objectForKey:@"SALESUSHOWNAME"];//[customTrackNameLTableArray objectAtIndex:[indexPath row]];
    customNameL.font = [UIFont fontWithName:@"Helvetica" size:11.0f];
    customNameL.backgroundColor = [UIColor clearColor];
    customNameL.textAlignment = 1;
    [cell.contentView addSubview:customNameL];
    
    //回访内容
    UILabel *communityL = [[UILabel alloc] initWithFrame:CGRectMake(35, 12, 125, 20)];
    communityL.text = [[_notes objectAtIndex:indexPath.row] objectForKey:@"TRACKDESCRIPTION"];//[trackContentLTableArray objectAtIndex:[indexPath row]];
    communityL.font = [UIFont fontWithName:@"Helvetica" size:9.0f];
    communityL.backgroundColor = [UIColor clearColor];
    communityL.textAlignment = 1;
    [cell.contentView addSubview:communityL];
    
    //备注
    UILabel *memo = [[UILabel alloc] initWithFrame:CGRectMake(160, 12, 100, 20)];
    memo.text = [[_notes objectAtIndex:indexPath.row] objectForKey:@"TRACKMEMO"];//[trackmemoTableArray objectAtIndex:[indexPath row]];
    memo.font = [UIFont fontWithName:@"Helvetica" size:11.0f];
    memo.backgroundColor = [UIColor clearColor];
    memo.textAlignment = 1;
    [cell.contentView addSubview:memo];
    
    //回访时间
    UILabel *trackTime = [[UILabel alloc] initWithFrame:CGRectMake(260, 12, 50, 20)];
    trackTime.text = [[[_notes objectAtIndex:indexPath.row] objectForKey:@"TRACKTIME"] substringWithRange:NSMakeRange(0, 10)];//[[trackTimeTableArray objectAtIndex:[indexPath row]] substringWithRange:NSMakeRange(0, 10)];
    trackTime.font = [UIFont fontWithName:@"Helvetica" size:9.0f];
    trackTime.backgroundColor = [UIColor clearColor];
    trackTime.textAlignment = 1;
    [cell.contentView addSubview:trackTime];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    app = [[UIApplication sharedApplication] delegate];
    app.trackID = [[_notes objectAtIndex:indexPath.row] objectForKey:@"TRACKID"];
    
    VisitViewController *visit = [[VisitViewController alloc] initWithNibName:@"VisitViewController" bundle:nil];
    [self presentViewController:visit animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
