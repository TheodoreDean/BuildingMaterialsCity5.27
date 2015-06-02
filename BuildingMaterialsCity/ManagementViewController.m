//
//  ManagementViewController.m
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/4/30.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import "ManagementViewController.h"
#import "OrderViewController.h"
#import "InstallViewController.h"
#import "ServiceViewController.h"
#import "DataViewController.h"
#import "UserViewController.h"
#import "DetailViewController.h"
#import "VisitViewController.h"
#import "AddguestViewController.h"
#import "AppDelegate.h"
#import "TableView.h"
#import "DateSelectView.h"
#import "CustomDatePicker.h"
#import "QCheckBox.h"

#define ispager 0
#define pageindex 1
#define pagesize 1



@interface ManagementViewController ()
@end

@implementation ManagementViewController{
    NSArray *dataArray;//数据源，显示每个cell的数据
    NSArray *arr;
    NSArray *arr1;
    InstallViewController *install;
    UIAlertView *alert;
    
    NSMutableDictionary *dict;
    
    UIView *searchView;
    
    CustomDatePicker *pickers;
    CustomDatePicker *pickere;
    
    CustomDatePicker *pickerss;
    CustomDatePicker *pickeree;
    
    NSString *customerclass;//客户类型
    
    UITextField *searchField;//搜索框
    NSString *byFTime;//首次进店时间
    NSString *byIntTime;//预购时间
    
    NSString *sString;//进店开始时间
    NSString *eString;//进店结束时间
    NSString *ssString;//预购开始时间
    NSString *eeString;//预购结束时间
    //意向客户表
    TableView *toGuestTable;
    //订单客户表
    TableView *orderGuestTable;
    
    NSString *orderBy;//排序方式
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
    [self setIntentDefaultParameter];
    [self GetCustomerInfo];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setOrderDefaultParameter];
        [self GetCustomerInfo];
    });
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //页面头部
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    [navBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];

    UILabel *item = [[UILabel alloc] initWithFrame:CGRectMake(0,40,320,20)];
    item.text = @"管理";
    item.textAlignment = 1;
    item.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    item.textColor = [UIColor whiteColor];
    [navBar addSubview:item];
    
    //添加按钮
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setFrame:CGRectMake(270,40,20,20)];
    [right setImage:[UIImage imageNamed:@"tj.png"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:right];
    [self.view addSubview:navBar];
    
    
#pragma - mark  意向客户表  表头显示各列的名称 label显示无操作的数据  button显示可排序的数据
        //意向客户表
    toGuestTable = [[TableView  alloc] initWithFrame:CGRectMake(0 , 110, 320, 197) tableviewFrame:CGRectMake(0, 0, 320, 197)];

    toGuestTable.backgroundColor = [UIColor redColor];
    [self.view addSubview:toGuestTable];
    
    //背景条
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 91, 320, 20)];
    label.backgroundColor = [UIColor colorWithRed:31.0/255 green:138.0/255 blue:204.0/255 alpha:1];
    [self.view addSubview:label];
    
    //客户名
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, 91, 35, 20)];
    nameL.text = @"客户名";
    nameL.textColor = [UIColor whiteColor];
    nameL.textAlignment = 1;
    nameL.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
    [self.view addSubview:nameL];
    
    //小区
    UILabel *communityL = [[UILabel alloc] initWithFrame:CGRectMake(35, 91, 50, 20)];
    communityL.text = @"小区";
    communityL.textColor = [UIColor whiteColor];
    communityL.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
    communityL.backgroundColor = [UIColor clearColor];
    communityL.textAlignment = 1;
    [self.view addSubview:communityL];
    
    //负责人
    UILabel *guiderL = [[UILabel alloc] initWithFrame:CGRectMake(85, 91, 50, 20)];
    guiderL.text = @"负责人";
    guiderL.textColor = [UIColor whiteColor];
    guiderL.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
    guiderL.backgroundColor = [UIColor clearColor];
    guiderL.textAlignment = 1;
    [self.view addSubview:guiderL];
    
    //意向产品
    UILabel *productL = [[UILabel alloc] initWithFrame:CGRectMake(135, 91, 50, 20)];
    productL.text = @"意向产品";
    productL.textColor = [UIColor whiteColor];
    productL.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
    productL.backgroundColor = [UIColor clearColor];
    productL.textAlignment = 1;
    [self.view addSubview:productL];
    
    //排序按钮
    UIButton *visitTime = [[UIButton alloc] initWithFrame:CGRectMake(185, 91, 50, 20)];
    [visitTime setTitle:@"进店时间" forState:UIControlStateNormal];
    [visitTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [visitTime setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [visitTime addTarget:self action:@selector(visitTimeBtn) forControlEvents:UIControlEventTouchUpInside];
    visitTime.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
    [self.view addSubview:visitTime];
    
    //排序按钮
    UIButton *buyTime = [[UIButton alloc] initWithFrame:CGRectMake(235, 91, 50, 20)];
    [buyTime setTitle:@"预装时间" forState:UIControlStateNormal];
    [buyTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buyTime setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [buyTime addTarget:self action:@selector(buyTimeBtn) forControlEvents:UIControlEventTouchUpInside];
    buyTime.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
    [self.view addSubview:buyTime];
    
    //搜索按钮
    UIButton *toSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [toSearch setFrame:CGRectMake(292,91,20,20)];
    [toSearch setImage:[UIImage imageNamed:@"ss.png"] forState:UIControlStateNormal];
    [toSearch addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toSearch];
 
#pragma - mark - 订单客户表  表头显示各列的名称 label显示无操作的数据  button显示可排序的数据
    //订单客户表
    orderGuestTable = [[TableView  alloc] initWithFrame:CGRectMake(0 , 311, 320, 207) tableviewFrame:CGRectMake(0, 0, 320, 207)];
    [self.view addSubview:orderGuestTable];
    
    //背景条
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 291, 320, 20)];
    label1.backgroundColor = [UIColor colorWithRed:31.0/255 green:138.0/255 blue:204.0/255 alpha:1];
    [self.view addSubview:label1];

    //客户名
    UILabel *orderNameL = [[UILabel alloc] initWithFrame:CGRectMake(0, 291, 35, 20)];
    orderNameL.text = @"客户名";
    orderNameL.textColor = [UIColor whiteColor];
    orderNameL.textAlignment = 1;
    orderNameL.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
    [self.view addSubview:orderNameL];
    
    //小区
    UILabel *ordercommunityL = [[UILabel alloc] initWithFrame:CGRectMake(35, 291, 50, 20)];
    ordercommunityL.text = @"小区";
    ordercommunityL.textColor = [UIColor whiteColor];
    ordercommunityL.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
    ordercommunityL.backgroundColor = [UIColor clearColor];
    ordercommunityL.textAlignment = 1;
    [self.view addSubview:ordercommunityL];
    
    //最近订单产品
    UILabel *orderProductL = [[UILabel alloc] initWithFrame:CGRectMake(85, 291, 50, 20)];
    orderProductL.text = @"订单产品";
    orderProductL.textColor = [UIColor whiteColor];
    orderProductL.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
    orderProductL.backgroundColor = [UIColor clearColor];
    orderProductL.textAlignment = 1;
    [self.view addSubview:orderProductL];
    
    //最近订单时间
    UIButton *orderTimeL = [[UIButton alloc] initWithFrame:CGRectMake(135, 291, 50, 20)];
    [orderTimeL setTitle:@"订单时间" forState:UIControlStateNormal];
    [orderTimeL setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [orderTimeL setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [orderTimeL addTarget:self action:@selector(orderTimeBtn) forControlEvents:UIControlEventTouchUpInside];
    orderTimeL.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
    [self.view addSubview:orderTimeL];
    
    //最近订单数
    UIButton *orderCount = [[UIButton alloc] initWithFrame:CGRectMake(185, 291, 50, 20)];
    [orderCount setTitle:@"订单数" forState:UIControlStateNormal];
    [orderCount setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [orderCount setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [orderCount addTarget:self action:@selector(orderCountBtn) forControlEvents:UIControlEventTouchUpInside];
    orderCount.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
    [self.view addSubview:orderCount];
    
    //最近订单金额
    UIButton *orderAmount = [[UIButton alloc] initWithFrame:CGRectMake(235, 291, 50, 20)];
    [orderAmount setTitle:@"订单金额" forState:UIControlStateNormal];
    [orderAmount setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [orderAmount setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [orderAmount addTarget:self action:@selector(orderAmountBtn) forControlEvents:UIControlEventTouchUpInside];
    orderAmount.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
    [self.view addSubview:orderAmount];
    
    //搜索按钮
    UIButton *orderSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [orderSearch setFrame:CGRectMake(295,294,14,14)];
    [orderSearch setImage:[UIImage imageNamed:@"ss.png"] forState:UIControlStateNormal];
    [orderSearch addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderSearch];

}

#pragma - mark 设置初始化页面时模糊查询的参数
-(void)setIntentDefaultParameter
{
    byFTime = @"0";
    sString = @"2015-01-01";
    eString = @"2015-01-01";
    byIntTime = @"0";
    ssString = @"2015-01-01";
    eeString = @"2015-01-01";
    searchField = [[UITextField alloc] init];
    searchField.text = @"";
    customerclass = @"0";
    orderBy = [NSString stringWithFormat:@"CUSTOMERNAME DESC"];//排序
}

-(void)setOrderDefaultParameter
{
    byFTime = @"0";
    sString = @"2015-01-01";
    eString = @"2015-01-01";
    byIntTime = @"0";
    ssString = @"2015-01-01";
    eeString = @"2015-01-01";
    searchField = [[UITextField alloc] init];
    searchField.text = @"";
    customerclass = @"1";
    orderBy = [NSString stringWithFormat:@"CUSTOMERNAME DESC"];//排序
}

//进店时间排序
-(void)visitTimeBtn{
    byFTime = @"0";
    sString = @"2015-01-01";
    eString = @"2015-01-01";
    byIntTime = @"0";
    ssString = @"2015-01-01";
    eeString = @"2015-01-01";
    searchField = [[UITextField alloc] init];
    searchField.text = @"";

    orderBy = [NSString stringWithFormat:@"FTIME DESC"];//排序
    
    [self GetCustomerInfo];
}

//预装时间排序
-(void)buyTimeBtn{
    byFTime = @"0";
    sString = @"2015-01-01";
    eString = @"2015-01-01";
    byIntTime = @"0";
    ssString = @"2015-01-01";
    eeString = @"2015-01-01";
    searchField = [[UITextField alloc] init];
    searchField.text = @"";

    orderBy = [NSString stringWithFormat:@"INTTIME DESC"];//排序
    [self GetCustomerInfo];
}


//订单时间排序
-(void)orderTimeBtn{
    orderBy = [NSString stringWithFormat:@"INTTIME DESC"];//排序
}

//订单数排序
-(void)orderCountBtn{
    orderBy = [NSString stringWithFormat:@"INTTIME DESC"];//排序
}

//订单金额排序
-(void)orderAmountBtn{
    orderBy = [NSString stringWithFormat:@"INTTIME DESC"];//排序
}

//搜索事件
-(void)search{
    searchView = [[UIView alloc] initWithFrame:CGRectMake(35, self.view.frame.origin.y*0.5+200, 250, 200)];
    searchView.backgroundColor = [UIColor colorWithRed:31.0/255 green:138.0/255 blue:204.0/255 alpha:1];
    [self.view addSubview:searchView];
    
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(50, self.view.frame.origin.y*0.5+15, 136, 20)];
    searchField.layer.cornerRadius=0.0f;
    searchField.layer.masksToBounds=YES;
    searchField.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    searchField.layer.borderWidth= 0.5f;
    searchField.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:250.0/255 alpha:1];
    searchField.delegate = self;
    searchField.font = [UIFont fontWithName:@"Helvetica" size:11.0f];
    [searchView addSubview:searchField];
    
    //搜索按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(190, self.view.frame.origin.y*0.5+18, 14, 14)];//CGRectMake(20,24,14,14)];
    [left setImage:[UIImage imageNamed:@"ss.png"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(searchBtn) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:left];

    //进店时间 label
    UILabel *inLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 50, 25)];
    inLabel.text = @"进店时间:";
    inLabel.font = [UIFont fontWithName:@"Helvetica" size:11.0f];
    [searchView addSubview:inLabel];
    
    //预装时间 label
    UILabel *buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, 50, 25)];
    buyLabel.text = @"预装时间:";
    buyLabel.font = [UIFont fontWithName:@"Helvetica" size:11.0f];
    [searchView addSubview:buyLabel];
    
    //选择框
    QCheckBox *checki = [[QCheckBox alloc] initWithDelegate:self frame:CGRectMake(15, 75, 25, 25)];
    checki.tag = 0;
     byFTime = @"0";
    [searchView addSubview:checki];

    QCheckBox *checky = [[QCheckBox alloc] initWithDelegate:self frame:CGRectMake(15, 150, 25, 25)];
    checky.tag = 1;
     byIntTime = @"0";
    [searchView addSubview:checky];
    
    pickers = [[CustomDatePicker alloc] initWithFrame:CGRectMake(50, 50, 50, 25)];
    [pickers setUserInteractionEnabled:NO];
    [searchView addSubview:pickers];
    
    
    pickere = [[CustomDatePicker alloc] initWithFrame:CGRectMake(50, 75, 50, 25)];
    [pickere setUserInteractionEnabled:NO];
    [searchView addSubview:pickere];
    
    pickerss = [[CustomDatePicker alloc] initWithFrame:CGRectMake(50, 125, 50, 25)];
    [pickerss setUserInteractionEnabled:NO];
    [searchView addSubview:pickerss];
    
    pickeree = [[CustomDatePicker alloc] initWithFrame:CGRectMake(50, 150, 50, 25)];
    [pickeree setUserInteractionEnabled:NO];
    [searchView addSubview:pickeree];

    customerclass = @"0";
}

//模糊查询时 搜索按钮事件
-(void)searchBtn{
    
    sString = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)pickers.yearString,(long)pickers.monthString,(long)pickers.dayString];
    NSLog(@"test date 1  ==%@",sString);
    
    eString = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)pickere.yearString,(long)pickere.monthString,(long)pickere.dayString];
    NSLog(@"test date 2  ==%@",eString);
    
    ssString = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)pickerss.yearString,(long)pickerss.monthString,(long)pickerss.dayString];
    NSLog(@"test date 3  ==%@",ssString);
    
    eeString = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)pickeree.yearString,(long)pickeree.monthString,(long)pickeree.dayString];
    NSLog(@"test date 4  ==%@",eeString);
    
    [self GetCustomerInfo];
    
    searchView.hidden = YES;

}

#pragma mark - 查询客户信息
//查询客户信息
-(void)GetCustomerInfo
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
    NSString *byUserId = @"1";//是否匹配当前用户ID
    NSString *byCustomerClass = @"1";//是否匹配客户类型
    NSString *byShopname = @"1";//是否匹配商铺名称
    NSLog(@"opnames : %@",app.opnames);
    if([app.opnames containsObject:@"用户管理"])
    {
        byUserId = @"0";
    }

    //设置之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签想对应
    matchingElement = @"GetCustomerInfoResult";
    //创建SOAP消息，内容格式就是网站声提示的请求豹纹的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?> "
                         "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<GetCustomerInfo xmlns=\"http://tempuri.org/\">"
                         "<byuserid>%@</byuserid>"
                         "<userid>%@</userid>"
                         "<bycustomerclass>%@</bycustomerclass>"
                         "<customerclass>%@</customerclass>"
                         "<byshopname>%@</byshopname>"
                         "<shopname>%@</shopname>"
                         "<ispager>%d</ispager>"
                         "<pageindex>%d</pageindex>"
                         "<pagesize>%d</pagesize>"
                         "<searchkey>%@</searchkey>"
                         "<byftime>%@</byftime>"
                         "<startftime>%@</startftime>"
                         "<endftime>%@</endftime>"
                         "<byinttime>%@</byinttime>"
                         "<startinttime>%@</startinttime>"
                         "<endinttime>%@</endinttime>"
                         "<orderby>%@</orderby>"
                         "</GetCustomerInfo>"
                         "</soap12:Body>"
                         "</soap12:Envelope>",byUserId,app.nameid,byCustomerClass,customerclass,byShopname,app.shopName,ispager,pageindex,pagesize,searchField.text,byFTime,sString,eString,byIntTime,ssString,eeString,orderBy];
    
    NSLog(@"%@   %@   %@  %@   %@   %@  %d   %d   %d  %@   %@   %@  %@   %@   %@ %@   %@  ",byUserId,app.nameid,byCustomerClass,customerclass,byShopname,app.shopName,ispager,pageindex,pagesize,searchField.text,byFTime,sString,eString,byIntTime,ssString,eeString,orderBy);
    
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
    if ([_currentTagName isEqualToString:@"CUSTOMERNAME"] && dict) {//客户姓名
        [dict setObject:string forKey:@"CUSTOMERNAME"];
    }
    if ([_currentTagName isEqualToString:@"CUSTOMERID"] && dict) {//客户ID
        [dict setObject:string forKey:@"CUSTOMERID"];
    }
    if ([_currentTagName isEqualToString:@"CUSTOMERAR"] && dict) {//小区
        [dict setObject:string forKey:@"CUSTOMERAR"];
    }
    
    if ([_currentTagName isEqualToString:@"SALESUSERSHOWNAME"] && dict) {//负责人
        [dict setObject:string forKey:@"SALESUSERSHOWNAME"];
    }
    if ([_currentTagName isEqualToString:@"INTPRODUCT"] && dict) {//意向产品
        [dict setObject:string forKey:@"INTPRODUCT"];
    }
    if ([_currentTagName isEqualToString:@"FTIME"] && dict) {//进店时间
        [dict setObject:string forKey:@"FTIME"];
    }
    if ([_currentTagName isEqualToString:@"INTTIME"] && dict) {//预装时间
        [dict setObject:string forKey:@"INTTIME"];
    }
    
    if ([_currentTagName isEqualToString:@"CUSTOMERADDR"] && dict) {//地址
        [dict setObject:string forKey:@"CUSTOMERADDR"];
    }
    if ([_currentTagName isEqualToString:@"CUSTOMERTEL"] && dict) {//电话
        [dict setObject:string forKey:@"CUSTOMERTEL"];
    }
    
    if ([_currentTagName isEqualToString:@"info"] && dict) {//结果
        [dict setObject:string forKey:@"info"];
    }
    
    if ([_currentTagName isEqualToString:@"CUSTOMERCLASS"] && dict) {// 客户类型
        [dict setObject:string forKey:@"CUSTOMERCLASS"];
    }
    //等订单模块完成
//    if ([_currentTagName isEqualToString:@"INTTIME"] && dict) {//订单产品
//        [dict setObject:string forKey:@"INTTIME"];
//    }
//    if ([_currentTagName isEqualToString:@"INTTIME"] && dict) {//订单时间
//        [dict setObject:string forKey:@"INTTIME"];
//    }
//    if ([_currentTagName isEqualToString:@"INTTIME"] && dict) {//订单数
//        [dict setObject:string forKey:@"INTTIME"];
//    }
//    if ([_currentTagName isEqualToString:@"INTTIME"] && dict) {//订单金额
//        [dict setObject:string forKey:@"INTTIME"];
//    }
   

}

//结束解析这个元素名
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:matchingElement]) {
       

/*__________________*/
        

        if ([customerclass isEqualToString:@"0"]) {
            toGuestTable.tableArray =  [[NSMutableArray alloc] init];
            toGuestTable.tableArray1 = [[NSMutableArray alloc] init];
            toGuestTable.tableArray2 = [[NSMutableArray alloc] init];
            toGuestTable.tableArray3 = [[NSMutableArray alloc] init];
            toGuestTable.tableArray4 = [[NSMutableArray alloc] init];
            toGuestTable.tableArray5 = [[NSMutableArray alloc] init];
            toGuestTable.tableArray6 = [[NSMutableArray alloc] init];
            toGuestTable.tableArray7 = [[NSMutableArray alloc] init];
            toGuestTable.tableArray8 = [[NSMutableArray alloc] init];
            toGuestTable.tableArray9 = [[NSMutableArray alloc] init];

            
            for(int i = 0 ; i < [_notes count]; i++)
            {
                
                [toGuestTable.tableArray addObject: [[_notes objectAtIndex:i] objectForKey:@"CUSTOMERNAME"]];
                [toGuestTable.tableArray1 addObject:[[_notes objectAtIndex:i] objectForKey:@"CUSTOMERAR"]];
                [toGuestTable.tableArray2 addObject:[[_notes objectAtIndex:i]  objectForKey:@"SALESUSERSHOWNAME"]];
                [toGuestTable.tableArray3 addObject:[[_notes objectAtIndex:i]  objectForKey:@"INTPRODUCT"]];
                [toGuestTable.tableArray4 addObject:[[_notes objectAtIndex:i]  objectForKey:@"FTIME"]];
                [toGuestTable.tableArray5 addObject:[[_notes objectAtIndex:i]  objectForKey:@"INTTIME"]];
                [toGuestTable.tableArray6 addObject:[[_notes objectAtIndex:i] objectForKey:@"CUSTOMERADDR"]];
                [toGuestTable.tableArray7 addObject:[[_notes objectAtIndex:i] objectForKey:@"CUSTOMERTEL"]];
                [toGuestTable.tableArray8 addObject:[[_notes objectAtIndex:i] objectForKey:@"CUSTOMERID"]];
                [toGuestTable.tableArray9 addObject:[[_notes objectAtIndex:i] objectForKey:@"CUSTOMERCLASS"]];

            }
            NSLog(@"tableArray 0-5 ======= %@ \n %@ \n %@\n %@ \n %@ \n%@",_notes,toGuestTable.tableArray,toGuestTable.tableArray2,toGuestTable.tableArray3,toGuestTable.tableArray4,toGuestTable.tableArray5);
        }
        if ([customerclass isEqualToString:@"1"]) {
            orderGuestTable.tableArray =  [[NSMutableArray alloc] init];
            orderGuestTable.tableArray1 = [[NSMutableArray alloc] init];
            orderGuestTable.tableArray2 = [[NSMutableArray alloc] init];
            orderGuestTable.tableArray9 = [[NSMutableArray alloc] init];

            for(int i = 0 ; i < [_notes count]; i++)
            {
                [orderGuestTable.tableArray addObject: [[_notes objectAtIndex:i] objectForKey:@"CUSTOMERNAME"]];
                [orderGuestTable.tableArray1 addObject:[[_notes objectAtIndex:i] objectForKey:@"CUSTOMERAR"]];
                [orderGuestTable.tableArray2 addObject:[[_notes objectAtIndex:i]  objectForKey:@"INTPRODUCT"]];
                [orderGuestTable.tableArray9 addObject:[[_notes objectAtIndex:i]  objectForKey:@"CUSTOMERCLASS"]];

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
    
    [toGuestTable.tv reloadData];
    [orderGuestTable.tv reloadData];
}

//出错时，例如强制结束解析
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    if (soapResults) {
        soapResults = nil;
    }
}


//添加事件
-(void)add{
    AddguestViewController *addGuest = [[AddguestViewController alloc] initWithNibName:@"AddguestViewController" bundle:nil];
    [self presentViewController:addGuest animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)orderBtn:(id)sender {
    OrderViewController *order = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
    [self presentViewController:order animated:NO completion:nil];
}

- (IBAction)instalBtn:(id)sender {
    InstallViewController *instal = [[InstallViewController alloc] initWithNibName:@"InstallViewController" bundle:nil];
    [self presentViewController:instal animated:NO completion:nil];
}
- (IBAction)serviceBtn:(id)sender {
    ServiceViewController *service = [[ServiceViewController alloc] initWithNibName:@"ServiceViewController" bundle:nil];
    [self presentViewController:service animated:NO completion:nil];
}

- (IBAction)dataBtn:(id)sender {
    DataViewController *data = [[DataViewController alloc] initWithNibName:@"DataViewController" bundle:nil];
    [self presentViewController:data animated:NO completion:nil];
}

- (IBAction)userBtn:(id)sender {
    app = [[UIApplication sharedApplication] delegate];
    if (![app.userAccess isEqualToString: @"用户管理"]) {
        NSLog(@"app.jiaose %@",app.userAccess);
        self.userM.backgroundColor = [UIColor lightGrayColor];
        self.userM.enabled = NO;
        
    }else{
        UserViewController *user = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
        [self presentViewController:user animated:NO completion:nil];
    }
     NSLog(@"11111111app.jiaose %@",app.userAccess);
}

#pragma mark - QCheckBoxDelegate
//选中某些权限

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    if (checkbox.tag == 0 && checked) {
        byFTime = @"1";
        [pickers setUserInteractionEnabled:YES];
        [pickere setUserInteractionEnabled:YES];
        }
    else if(checkbox.tag == 1 && checked)
    {
        byIntTime = @"1";
        [pickerss setUserInteractionEnabled:YES];
        [pickeree setUserInteractionEnabled:YES];
        
    }else if(!checked && checkbox.tag == 0){
        byFTime = @"0";
        [pickers setUserInteractionEnabled:NO];
        [pickere setUserInteractionEnabled:NO];
    }
    else {
        byIntTime = @"0";
        [pickerss setUserInteractionEnabled:NO];
        [pickeree setUserInteractionEnabled:NO];
    }

}






@end
