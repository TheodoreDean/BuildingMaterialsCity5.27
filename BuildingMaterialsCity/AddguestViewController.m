//
//  AddguestViewCOntroller.m
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/7.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import "AddguestViewController.h"
#import "DateSelectView.h"
#import "AppDelegate.h"

@interface AddguestViewController ()

@end


@implementation AddguestViewController
{
    UIAlertView *alert;
    NSMutableDictionary *dict;
    AppDelegate *app;
    NSString *ftime;//进店时间
    NSString *inttime;//意向时间
    
    DateSelectView * yearView;
    DateSelectView * monthView;
    DateSelectView * dayView;
    DateSelectView * yearIntentView;
    DateSelectView * monthIntentView;
    DateSelectView * dayIntentView;
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
    item.text = @"添加客户";
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
    
    //客户姓名
    self.toName.layer.cornerRadius=0.0f;
    self.toName.layer.masksToBounds=YES;
    self.toName.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.toName.layer.borderWidth= 0.5f;
    
    //手机号码
    self.toTel.layer.cornerRadius=0.0f;
    self.toTel.layer.masksToBounds=YES;
    self.toTel.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.toTel.layer.borderWidth= 0.5f;
    
    //地址
    self.toAdderss.layer.cornerRadius=0.0f;
    self.toAdderss.layer.masksToBounds=YES;
    self.toAdderss.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.toAdderss.layer.borderWidth= 0.5f;
    
    //小区
    self.toXiaoQu.layer.cornerRadius=0.0f;
    self.toXiaoQu.layer.masksToBounds=YES;
    self.toXiaoQu.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.toXiaoQu.layer.borderWidth= 0.5f;
    
    //意向产品
    self.toProduct.layer.cornerRadius=0.0f;
    self.toProduct.layer.masksToBounds=YES;
    self.toProduct.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.toProduct.layer.borderWidth= 0.5f;
    
    //备注
    self.beizhu.layer.cornerRadius = 0.0f;
    self.beizhu.layer.masksToBounds=YES;
    self.beizhu.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.beizhu.layer.borderWidth= 0.5f;
    
    //负责人ID
    self.chargerID.layer.cornerRadius=0.0f;
    self.chargerID.layer.masksToBounds=YES;
    self.chargerID.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.chargerID.layer.borderWidth= 0.5f;
    
    //身份证号
    self.cardNo.layer.cornerRadius=0.0f;
    self.cardNo.layer.masksToBounds=YES;
    self.cardNo.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    self.cardNo.layer.borderWidth= 0.5f;
    
    /*_____________new________________*/
    NSMutableArray *array1 =[[NSMutableArray alloc ]init];
    NSMutableArray *array2 = [[NSMutableArray alloc ] init];
    
    for( int i = 2015 ; i >2000; i--)
    {
        NSString *string = [NSString stringWithFormat:@"%d",i] ;
        NSLog(@"%@",string);
        [array1 addObject:string];
    }
    NSArray *yearArray = array1;
    NSLog(@"array1 = %@  ",yearArray);
    
    for( int i = 1; i< 32; i++)
    {
        NSString *string = [NSString stringWithFormat:@"%02d",i];
        [array2 addObject:string];
    }
    NSArray *monthArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
    
    
    NSArray *dayArray = array2;
    //  添加进店年月日
    yearView = [[DateSelectView  alloc] initWithFrame:CGRectMake(115, 276, 70, 30) tableviewFrame:CGRectMake(0, 20, 52, 0)];
    yearView.textField.placeholder = @"2015";
    yearView.tableArray = yearArray;
    [self.view addSubview:yearView];
    UILabel *yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, -5, 30, 30)];
    yearLabel.text = @"年";
    yearLabel.font = [UIFont fontWithName:@"Helvetica" size:9.0f];
    [yearView addSubview:yearLabel];
    
    monthView = [[DateSelectView  alloc] initWithFrame:CGRectMake(175, 276, 70, 30) tableviewFrame:CGRectMake(0, 20, 52, 0)];
    monthView.textField.placeholder = @"01";
    monthView.tableArray = monthArray;
    [self.view addSubview:monthView];
    UILabel *monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, -5, 30, 30)];
    monthLabel.text = @"月";
    monthLabel.font = [UIFont fontWithName:@"Helvetica" size:9.0f];
    [monthView addSubview:monthLabel];
    
    dayView = [[DateSelectView  alloc] initWithFrame:CGRectMake(235, 276, 70, 30) tableviewFrame:CGRectMake(0, 20, 52, 0)];
    dayView.textField.placeholder = @"01";
    dayView.tableArray = dayArray;
    [self.view addSubview:dayView];
    UILabel *dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, -5, 30, 30)];
    dayLabel.text = @"日";
    dayLabel.font = [UIFont fontWithName:@"Helvetica" size:9.0f];
    [dayView addSubview:dayLabel];
    
    //添加意向年月日
    yearIntentView = [[DateSelectView  alloc] initWithFrame:CGRectMake(115, 306, 70, 30) tableviewFrame:CGRectMake(0, 20, 52, 0)];
    yearIntentView.textField.placeholder = @"2015";
    yearIntentView.tableArray = yearArray;
    [self.view addSubview:yearIntentView];
    UILabel *yearIntentLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, -5, 30, 30)];
    yearIntentLabel.text = @"年";
    yearIntentLabel.font = [UIFont fontWithName:@"Helvetica" size:9.0f];
    [yearIntentView addSubview:yearIntentLabel];
    
    monthIntentView = [[DateSelectView  alloc] initWithFrame:CGRectMake(175, 306, 70, 30) tableviewFrame:CGRectMake(0, 20, 52, 0)];
    monthIntentView.textField.placeholder = @"1";
    monthIntentView.tableArray = monthArray;
    [self.view addSubview:monthIntentView];
    UILabel *monthIntentLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, -5, 30, 30)];
    monthIntentLabel.text = @"月";
    monthIntentLabel.font = [UIFont fontWithName:@"Helvetica" size:9.0f];
    [monthIntentView addSubview:monthIntentLabel];
    
    dayIntentView = [[DateSelectView  alloc] initWithFrame:CGRectMake(235, 306, 70, 30) tableviewFrame:CGRectMake(0, 20, 52, 0)];
    dayIntentView.textField.placeholder = @"1";
    dayIntentView.tableArray = dayArray;
    [self.view addSubview:dayIntentView];
    UILabel *dayIntentLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, -5, 30, 30)];
    dayIntentLabel.text = @"日";
    dayIntentLabel.font = [UIFont fontWithName:@"Helvetica" size:9.0f];
    [dayIntentView addSubview:dayIntentLabel];

    
    //传值
    app = [[UIApplication sharedApplication] delegate];
    
    
    
    
    
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - 创建新客户
-(void)CreateCustomer{
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
    //app.nameid 创建用户ID
    //app.shopName 商铺名称
    ftime = [NSString stringWithFormat:@"%@-%@-%@",yearView.textField.text,monthView.textField.text,dayView.textField.text];

    inttime = [NSString stringWithFormat:@"%@-%@-%@",yearIntentView.textField.text,monthIntentView.textField.text,dayIntentView.textField.text];
    NSLog(@"inttime:%@",inttime);
    
    //设置之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签想对应
    matchingElement = @"CreateCustomerResult";
    //创建SOAP消息，内容格式就是网站声提示的请求豹纹的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope "
                         "xmlns:xsi=\"http://www.w3.org/2001/XMLSchems-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<CreateCustomer xmlns=\"http://tempuri.org/\">"
                         "<customerclass>%@</customerclass>"
                         "<customername>%@</customername>"
                         "<customertel>%@</customertel>"
                         "<customeraddr>%@</customeraddr>"
                         "<customerar>%@</customerar>"
                         "<salesuserid>%@</salesuserid>"
                         "<intproduct>%@</intproduct>"
                         "<cmemo>%@</cmemo>"
                         "<createuserid>%@</createuserid>"
                         "<ftime>%@</ftime>"
                         "<inttime>%@</inttime>"
                         "<shopname>%@</shopname>"
                         "<idcard>%@</idcard>"
                         "</CreateCustomer>"
                         "</soap12:Body>"
                         "</soap12:Envelope>",@"0" ,self.toName.text,self.toTel.text,self.toAdderss.text,self.toXiaoQu.text,app.nameid,self.toProduct.text,self.beizhu.text,app.nameid,ftime,inttime,app.shopName,self.cardNo.text];
    
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

- (IBAction)save:(id)sender {
    [self CreateCustomer];
    
    
//    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
