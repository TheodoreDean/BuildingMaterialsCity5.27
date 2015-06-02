//
//  dateSelectView.h
//  BuildingMaterialsCity
//
//  Created by LYRotoosoft on 15/5/13.
//  Copyright (c) 2015年 LYRotoosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateSelectView : UIView<UITableViewDelegate,UITableViewDataSource> {
    UITableView *tv;//下拉列表
    NSArray *tableArray;//下拉列表数据
    UITextField *textField;//文本输入框
    BOOL showList;//是否弹出下拉列表
    CGFloat tabheight;//table下拉列表的高度
    CGFloat frameHeight;//frame的高度
}

@property (nonatomic,retain) UITableView *tv;
@property (nonatomic,retain) NSArray *tableArray;
@property (nonatomic,retain) UITextField *textField;


-(id)initWithFrame:(CGRect)frame tableviewFrame:(CGRect)tvframe;


@end
