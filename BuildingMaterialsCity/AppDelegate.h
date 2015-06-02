//
//  AppDelegate.h
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/4/30.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (copy, nonatomic)NSString * nameid;//用户ID
@property (copy, nonatomic)NSString * name;//用户名
@property (copy, nonatomic)NSString * showName;//显示名
@property (copy, nonatomic)NSString * passWord;//密码
@property (copy, nonatomic)NSString * jiaose;//角色
@property (copy, nonatomic)NSString * shopName;//角色
@property (copy, nonatomic)NSString * uNameid;//管理用户 ID
@property (copy, nonatomic)NSString * backNameid;//返回的创建用户ID
@property (copy, nonatomic)NSString * FTime;//用户名
@property (copy, nonatomic)NSString * address;//地址
@property (copy, nonatomic)NSString * xiaoQu;//小区
@property (copy, nonatomic)NSString * Ftime;//进店时间
@property (copy, nonatomic)NSString * IntTime;//意向时间
@property (copy, nonatomic)NSString * product;//意向产品
@property (copy, nonatomic)NSString * salesUserID;//负责人
@property (copy, nonatomic)NSString * telNumber;//电话
@property (copy, nonatomic)NSString * customerName;//客户名字
@property (copy, nonatomic)NSString * customerID;//客户ID
@property (copy, nonatomic)NSArray  * opnames;//用户所有的管理权限


@property (copy, nonatomic)NSString * userAccess;//用户管理权限
@property (copy, nonatomic)NSString * userAccess1;//店长管理权限

@property (copy, nonatomic)NSString * trackID;//回访记录ID

@property (copy, nonatomic)NSString * customClass;//客户类型

@property (copy, nonatomic)NSString * productName;//产品名称
@property (copy, nonatomic)NSString * pClass;//产品类型
@property (copy, nonatomic)NSString * productDes;//产品描述

@end

