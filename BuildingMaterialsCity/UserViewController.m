//
//  UserViewController.m
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/6.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import "UserViewController.h"
#import "AddUserViewController.h"
#import "AppDelegate.h"
#import "ResetViewController.h"
#import "AddProductViewController.h"
#import "ProductDetailsViewController.h"

@interface UserViewController ()

@end

@implementation UserViewController
{
    UINavigationBar *navBar;
    NSMutableArray *arrUser;
    NSMutableArray *arrName;
    NSMutableArray *arrStatus;
    UIAlertView *alert;
    NSMutableDictionary *dict;
    AppDelegate * app;
    NSString *odstr;//按照什么排序
    UITextField *stest;//搜索文本
    UIButton *left;
    
    NSInteger selected;
    
    UILabel *label;
    UILabel *label1;
    UILabel *label2;
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;

}

@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize conn;


- (void)viewDidLoad {
    [super viewDidLoad];
    navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    [navBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *item = [[UILabel alloc] initWithFrame:CGRectMake(0,40,320,20)];
    item.text = @"管理";
    item.textAlignment = 1;
    item.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    item.textColor = [UIColor whiteColor];
    [navBar addSubview:item];
    
    //搜索按钮
    left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(76,40,20,20)];
    [left setImage:[UIImage imageNamed:@"ss.png"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:left];
    
    //搜索文本框
    stest = [[UITextField alloc] initWithFrame:CGRectMake(15, 40, 60, 20)];
    stest.layer.cornerRadius=10.0f;
    stest.layer.masksToBounds=YES;
    stest.layer.borderColor=[UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1].CGColor;
    stest.layer.borderWidth= 0.5f;
    stest.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:250.0/255 alpha:1];
    stest.delegate = self;
    stest.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    [navBar addSubview:stest];
    
    //新添加用户
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setFrame:CGRectMake(270,40,20,20)];
    [right setImage:[UIImage imageNamed:@"tj.png"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:right];
    
    [self.view addSubview:navBar];
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:250.0/255 alpha:1];
    
//    if (![app.jiaose  isEqual: @"A"] ) {
//        [right removeFromSuperview];
//    }用于角色判断，是管理员，有添加功能
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(8, 121, 70, 20)];
    label.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    label.textAlignment = 1;
    
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(78, 121, 70, 20)];
    
    [button1 setBackgroundColor:[UIColor clearColor]];
    
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    [button1 addTarget:self action:@selector(showNameBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setFrame:CGRectMake(156, 121, 70, 20)];
    
    [button2 setBackgroundColor:[UIColor clearColor]];
    
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    [button2 addTarget:self action:@selector(userStateBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setFrame:CGRectMake(234, 121, 80, 20)];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    [button3 addTarget:self action:@selector(createTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(125, 121, 70, 20)];
    label1.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    label1.textAlignment = 1;
    
    label2 = [[UILabel alloc] initWithFrame:CGRectMake(234, 121, 80, 20)];
    label2.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    label2.textAlignment = 1;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewDidLoad];
    if (selected == 0)
    {
        label.text = @"用户名";
        [self.view addSubview:label];
        
        [button1 setTitle:@"显示名" forState:UIControlStateNormal];
        [self.view addSubview:button1];
        
        [button2 setTitle:@"用户状态" forState:UIControlStateNormal];
        [self.view addSubview:button2];

        [button3 setTitle:@"创建时间" forState:UIControlStateNormal];
        [self.view addSubview:button3];

        odstr = @"USERNAME";///默认排序类型
        [self search];
    }
}

#pragma SearchUserInfoByNameLikeANDShopNameWithOD  按用户名或显示名模糊查询指定商铺的用户列表
//搜索特定的数据
-(void)search{
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
    NSString * text = stest.text;
    NSString * shop = app.shopName;
    
    //设置之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签想对应
    matchingElement = @"SearchUserInfoByNameLikeANDShopNameWithODResult";
    //创建SOAP消息，内容格式就是网站声提示的请求豹纹的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope "
                         "xmlns:xsi=\"http://www.w3.org/2001/XMLSchems-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<SearchUserInfoByNameLikeANDShopNameWithOD xmlns=\"http://tempuri.org/\">"
                         "<key>%@</key>"
                         "<shopname>%@</shopname>"
                         "<odstr>%@</odstr>"
                         "</SearchUserInfoByNameLikeANDShopNameWithOD>"
                         "</soap12:Body>"
                         "</soap12:Envelope>",text,shop,odstr];
    
    NSLog(@"!!!!!!!!!!!!!:%@  %@    %@",text,shop,odstr);
    
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

-(void)add{
    if (selected == 0) {
        AddUserViewController *add = [[AddUserViewController alloc] initWithNibName:@"AddUserViewController" bundle:nil];
        [self presentViewController:add animated:YES completion:nil];
    }
    else if (selected == 1){
        AddProductViewController *addProduct = [[AddProductViewController alloc] initWithNibName:@"AddProductViewController" bundle:nil];
        [self presentViewController:addProduct animated:YES completion:nil];
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
//        NSLog(@"========_notes======%@",_notes);
    }
}

//追加找到的元素值，一个元素值可能要分几次追加
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    dict = [_notes lastObject];
    if ([_currentTagName isEqualToString:@"USERID"] && dict) {//用户ID
        [dict setObject:string forKey:@"USERID"];
    }
    if ([_currentTagName isEqualToString:@"USERNAME"] && dict) {//用户名
        [dict setObject:string forKey:@"USERNAME"];
    }
    
    if ([_currentTagName isEqualToString:@"SHOWNAME"] && dict) {//显示名
        [dict setObject:string forKey:@"SHOWNAME"];
    }
    if ([_currentTagName isEqualToString:@"USERSTATUS"] && dict) {//账号状态
        [dict setObject:string forKey:@"USERSTATUS"];
    }
    if ([_currentTagName isEqualToString:@"CREATETIME"] && dict) {//创建时间
        [dict setObject:string forKey:@"CREATETIME"];
    }
    
    if ([_currentTagName isEqualToString:@"info"] && dict) {//更改结果
        [dict setObject:string forKey:@"info"];
    }
    
    if ([_currentTagName isEqualToString:@"PRODUCTNAME"] && dict) {//商品名称
        [dict setObject:string forKey:@"PRODUCTNAME"];
    }
    
    if ([_currentTagName isEqualToString:@"PCLASS"] && dict) {//商品类型
        [dict setObject:string forKey:@"PCLASS"];
    }
    
    if ([_currentTagName isEqualToString:@"PRODUCTDES"] && dict) {//商品描述
        [dict setObject:string forKey:@"PRODUCTDES"];
    }
    
    
}

//结束解析这个元素名
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:matchingElement]) {
        //修改用户状态
        if ([_currentTagName isEqualToString:@"info"]) {
            if ([[dict objectForKey:@"info"] isEqualToString:@"ok"]) {
            
                [self search];
                
            }else{
                alert  = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:[dict objectForKey:@"info"]
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
                [alert show];
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
    
    [self.userDataTable reloadData];
}

//出错时，例如强制结束解析
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    if (soapResults) {
        soapResults = nil;
    }
}

#pragma mark - Table view data source

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
    //用户名
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 70, 20)];
    
    nameL.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textAlignment = 1;
    [cell.contentView addSubview:nameL];
    
    //显示名
    UILabel *snameL = [[UILabel alloc] initWithFrame:CGRectMake(78, 10, 70, 20)];
    snameL.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    snameL.backgroundColor = [UIColor clearColor];
    snameL.textAlignment = 1;
    [cell.contentView addSubview:snameL];
    
    //用户状态
    UILabel *stL = [[UILabel alloc] initWithFrame:CGRectMake(156, 10, 70, 20)];
        stL.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    stL.backgroundColor = [UIColor clearColor];
    stL.textAlignment = 1;
    [cell.contentView addSubview:stL];
    
    //创建时间
    UILabel *ctimeL = [[UILabel alloc] initWithFrame:CGRectMake(234, 10, 80, 20)];
    ctimeL.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    ctimeL.backgroundColor = [UIColor clearColor];
    ctimeL.textAlignment = 1;
    [cell.contentView addSubview:ctimeL];

    if (selected == 0) {
        nameL.text = [[_notes objectAtIndex:indexPath.row] objectForKey:@"USERNAME"];
        snameL.text = [[_notes objectAtIndex:indexPath.row] objectForKey:@"SHOWNAME"];
        //把0，1转换为状态
        switch ([[[_notes objectAtIndex:indexPath.row] objectForKey:@"USERSTATUS"] integerValue]) {
            case 0:
                stL.text = [NSString stringWithFormat:@"无效"];
                break;
            case 1:
                stL.text = [NSString stringWithFormat:@"有效"];
                break;
            default:
                break;
        }
        ctimeL.text = [[[_notes objectAtIndex:indexPath.row] objectForKey:@"CREATETIME"] substringWithRange:NSMakeRange(0, 10)];
    }
    
    else if (selected == 1){
        nameL.text =[[_notes objectAtIndex:indexPath.row] objectForKey:@"PRODUCTNAME"];
        snameL.frame = CGRectMake(125, 10, 70, 20);
        snameL.text = [[_notes objectAtIndex:indexPath.row] objectForKey:@"PCLASS"];
        ctimeL.text = [[_notes objectAtIndex:indexPath.row] objectForKey:@"PRODUCTDES"];
    }
    
    return cell;
}

#pragma delete 滑动删除

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"修改";
}

//单元格返回的编辑风格，包括删除 添加 和 默认  和不可编辑三种风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete ;//返回编辑风格：  -：删除； +：添加  无：不可编辑
}


//修改用户状态
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
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
        NSString *uid = [[_notes objectAtIndex:indexPath.row] objectForKey:@"USERID"];
        NSInteger ustatus = [[[_notes objectAtIndex:indexPath.row] objectForKey:@"USERSTATUS"] integerValue];
        NSString *upuid = app.nameid;
        NSLog(@"upuid:%@",upuid);
        //设置之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签想对应
        matchingElement = @"SetUserStatusResponse";
        //创建SOAP消息，内容格式就是网站声提示的请求豹纹的实体主体部分
        NSString *soapMsg = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap12:Envelope "
                             "xmlns:xsi=\"http://www.w3.org/2001/XMLSchems-instance\" "
                             "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                             "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                             "<soap12:Body>"
                             "<SetUserStatus xmlns=\"http://tempuri.org/\">"
                             "<uid>%@</uid>"
                             "<ustatus>%d</ustatus>"
                             "<upuid>%@</upuid>"
                             "</SetUserStatus>"
                             "</soap12:Body>"
                             "</soap12:Envelope>",uid,!ustatus,upuid];
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

/////////////////////////////////////////////
//重置密码
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selected == 0) {
        app.showName = [[_notes objectAtIndex:indexPath.row] objectForKey:@"SHOWNAME"];
        app.backNameid = [[_notes objectAtIndex:indexPath.row] objectForKey:@"USERID"];
        
        ResetViewController *reset = [[ResetViewController alloc] initWithNibName:@"ResetViewController" bundle:nil];
        [self presentViewController:reset animated:YES completion:nil];
    }
    else if (selected == 1){
        app = [[UIApplication sharedApplication] delegate];
        app.productName = [[_notes objectAtIndex:indexPath.row] objectForKey:@"PRODUCTNAME"];
        app.pClass = [[_notes objectAtIndex:indexPath.row] objectForKey:@"PCLASS"];
        app.productDes = [[_notes objectAtIndex:indexPath.row] objectForKey:@"PRODUCTDES"];
        
        NSLog(@"   %@,      %@,    %@",app.productName,app.pClass,app.productDes);
        ProductDetailsViewController *productDetails = [[ProductDetailsViewController alloc] initWithNibName:@"ProductDetailsViewController" bundle:nil];
        [self presentViewController:productDetails animated:YES completion:nil];
    }
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
//跳转到客户管理页面
- (IBAction)custom:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)showNameBtn:(id)sender {
    odstr = @"SHOWNAME";
    [self search];
    
}

- (void)userStateBtn:(id)sender {
    odstr = @"USERSTATUS DESC, SHOWNAME";
    [self search];
}

- (void)createTimeBtn:(id)sender {
    odstr = @"CREATETIME";
    [self search];
}


- (IBAction)choose:(id)sender {
    selected = self.segmentController.selectedSegmentIndex;
    if (selected == 0) {
        label.text = @"用户名";
        [self.view addSubview:label];
        [button1 setFrame:CGRectMake(78, 121, 70, 20)];
        [button1 setTitle:@"显示名" forState:UIControlStateNormal];
        [self.view addSubview:button1];
        [button2 setFrame:CGRectMake(156, 121, 70, 20)];
        [button2 setTitle:@"用户状态" forState:UIControlStateNormal];
        [self.view addSubview:button2];
        [button3 setFrame:CGRectMake(234, 121, 80, 20)];
        [button3 setTitle:@"创建时间" forState:UIControlStateNormal];
        [self.view addSubview:button3];
        [navBar addSubview:stest];
        [navBar addSubview:left];
        
        [label1 removeFromSuperview];
        [label2 removeFromSuperview];

        odstr = @"USERNAME";///默认排序类型
        [self search];
    }
    else if (selected == 1){
        label.text = @"商品名称";
        [self.view addSubview:label];
        
        label1.text = @"商品类型";
        [self.view addSubview:label1];
        
        label2.text = @"商品描述";
        [self.view addSubview:label2];
 
        [button1 removeFromSuperview];
        [button2 removeFromSuperview];
        [button3 removeFromSuperview];
        [stest removeFromSuperview];
        [left removeFromSuperview];
        
        
        [self GetSProductByShopName];//调用显示商品信息方法
    }
}

#pragma mark - GetSProductByShopName 获取指定商铺的所有商品列表
/*
 获取指定商铺的所有商品列表
 shname:商品名称
 返回XML：TableName:result 错误信息ElementName:info
 */

-(void)GetSProductByShopName
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
    //设置之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签想对应
    matchingElement = @"GetSProductByShopNameResult";
    //创建SOAP消息，内容格式就是网站声提示的请求豹纹的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope "
                         "xmlns:xsi=\"http://www.w3.org/2001/XMLSchems-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<GetSProductByShopName xmlns=\"http://tempuri.org/\">"
                         "<shname>%@</shname>"
                         "</GetSProductByShopName>"
                         "</soap12:Body>"
                         "</soap12:Envelope>",app.shopName];
    
    NSLog(@"app.showName: %@",app.shopName);
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


@end
