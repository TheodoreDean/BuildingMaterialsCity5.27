//
//  TableView.h
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/18.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableView : UIView<UITableViewDelegate,UITableViewDataSource>{
    CGFloat tabheight;//table下拉列表的高度
    CGFloat frameHeight;//frame的高度
}

@property (nonatomic,retain) UITableView *tv;


@property (nonatomic) NSMutableArray *tableArray; // 名字
@property (nonatomic) NSMutableArray *tableArray1;// 小区
@property (nonatomic) NSMutableArray *tableArray2;// 负责人
@property (nonatomic) NSMutableArray *tableArray3;// 意向产品
@property (nonatomic) NSMutableArray *tableArray4;// 进店时间
@property (nonatomic) NSMutableArray *tableArray5;// 意向时间
@property (nonatomic) NSMutableArray *tableArray6;// 地址
@property (nonatomic) NSMutableArray *tableArray7;// 电话
@property (nonatomic) NSMutableArray *tableArray8;// 客户ID
@property (nonatomic) NSMutableArray *tableArray9;// 客户类型


-(id)initWithFrame:(CGRect)frame tableviewFrame:(CGRect)tvframe;



@end
