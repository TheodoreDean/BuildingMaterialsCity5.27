//
//  UICustomDatePicker.m
//  Seldon_2
//
//  Created by admin on 12.08.13.
//  Copyright (c) 2013 Zorin Evgeny. All rights reserved.
//

#import "CustomDatePicker.h"
#import "CustomPickerView.h"

#define MIN_YEAR_VALUE 1900 

@interface  CustomDatePicker() <CustomPickerControllerDelegate>
{
    CustomPickerView* _dayPicker;
    CustomPickerView* _yearPicker;
    CustomPickerView* _monthPicker;
    
    
    NSInteger _year;
    
    NSInteger _minYear;
    
}

@property(strong,retain)UIImage* dayImage;
@property(strong,retain)UIImage* monthImage;
@property(strong,retain)UIImage* yearImage;



-(void) defaultDataInit;
 
@end

@implementation CustomDatePicker

@synthesize dayImage = _dayImage;
@synthesize monthImage = _monthImage;
@synthesize yearImage = _yearImage;
@synthesize delegate;

#pragma mark - Init functions

-(id)initWithCoder:(NSCoder *)aDecoder
{
    
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self defaultDataInit];
    }
    return self;

}


-(id)init
{
    if (self = [super init])
    {
        [self defaultDataInit];
    }
    
    return self;
}
-(id)initWithImageForDay:(UIImage*)dayImage andMonthImage:(UIImage*)monthImage andYearImage:(UIImage*)yearImage forRect:(CGRect)rect
{
    self = [self initWithFrame:rect];
    
    if (self)
    {
        _dayImage = dayImage;
        _monthImage = monthImage;
        _yearImage = yearImage;
    }
    
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultDataInit];
        
    }
    return self;
}

-(void) defaultDataInit
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 50, 25);
    _dayImage = [UIImage imageNamed:@"daytest"];
    _monthImage = [UIImage imageNamed:@"month(1)"];
    _yearImage = [UIImage imageNamed:@"daytest"];
    
    _dayPicker= nil;
    _yearPicker = nil;
    _monthPicker = nil;
    
    _year = MIN_YEAR_VALUE;
    
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _date = [NSDate date];
    _minYear = MIN_YEAR_VALUE;
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:MIN_YEAR_VALUE];
    
    _minimumDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    _maximumDate = [NSDate date];
    
}


#pragma mark prepare View
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _dayImage.size.width + _monthImage.size.width + _yearImage.size.width - 2*TABLE_RECT_OFFSET, _dayImage.size.height);
    
    if (_maximumDate < _date)
    {
        _date = _maximumDate;
    }
    
    NSDateComponents *components = [_calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:_maximumDate];
    
    NSInteger year = [components year];
    
    NSMutableArray* years = [NSMutableArray array];

    _minYear = [[_calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:_minimumDate] year];
    
    for (int i = _minYear; i<=year; i++)
    {
        [years addObject:[NSString stringWithFormat:@"%d年",i]];
    }
    
//    _yearPicker= [[CustomPickerView alloc] initWithFrame:CGRectMake(_dayImage.size.width + _monthImage.size.width-2*TABLE_RECT_OFFSET, 0, _yearImage.size.width, _yearImage.size.height) background:_yearImage itemVerticalOffset:0.0f andData:years];
    
    _yearPicker= [[CustomPickerView alloc] initWithFrame:CGRectMake(0, 0, _yearImage.size.width, _yearImage.size.height) background:_yearImage itemVerticalOffset:0.0f andData:years];

    
    _yearPicker.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    //[_yearPicker setDataIndex:_date.y];
    _yearPicker.delegate = self;
    
    NSDateFormatter *df = [NSDateFormatter new];
    // change locale if the standard is not what you want
    
    NSArray *monthNames = [df shortStandaloneMonthSymbols];
    _monthPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(_yearImage.size.width - TABLE_RECT_OFFSET , 0, _monthImage.size.width, _monthImage.size.height)background:_monthImage itemVerticalOffset:0.0f andData:monthNames];
    _monthPicker.delegate = self;
    _monthPicker.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comps = [[NSDateComponents alloc] init];

    
    NSRange range = [cal rangeOfUnit:NSCalendarUnitDay
                              inUnit:NSCalendarUnitMonth
                             forDate:[cal dateFromComponents:comps]];
    NSLog(@"rang.length  =  %lu", (unsigned long)range.length);
    
    NSMutableArray* days = [NSMutableArray array];
        
    
    for (int i= 1; i<=range.length; i++)
    {
        [days addObject:[NSString stringWithFormat:@"%0d日",i]];
    }
    
    _dayPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(_yearImage.size.width + _monthImage.size.width-2*TABLE_RECT_OFFSET, 0, _dayImage.size.width, _dayImage.size.height) background:_dayImage itemVerticalOffset:0.0f andData:days];
    _dayPicker.delegate = self;
    
    _dayPicker.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [_dayPicker retrieveCustomPickerViewControllerDidSpinCallback:^(int day)
    {
        NSLog(@"Day %02d",day);
        _dayString = day;
        
    }];
    
    
    NSDateComponents *comp = [_calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:_date];
    
    year = [comp year];
    NSInteger month = [comp month];
    NSInteger day = [comp day];
    
    [_yearPicker setDataIndex:year - _minYear];
    [_monthPicker setDataIndex:month - 1];
    [_dayPicker setDataIndex:day - 1];
    
    [self addSubview:_dayPicker];
    [self addSubview:_monthPicker];
    [self addSubview:_yearPicker];
    
    [_yearPicker retrieveCustomPickerViewControllerDidSpinCallback:^(int year)
    {
        _year = _minYear - 1 + year;
        NSLog(@"Year %ld",(long)_year);
        _yearString = _year;
    }];
    
    [_monthPicker retrieveCustomPickerViewControllerDidSpinCallback:^(int month)
    {
        NSCalendar* cal = [NSCalendar currentCalendar];
        
         NSDateComponents* comps = [[NSDateComponents alloc] init];
        [comps setMonth:month];
        [components setYear:_year];
        
        NSRange range = [cal rangeOfUnit:NSCalendarUnitDay
                                  inUnit:NSCalendarUnitMonth
                                 forDate:[cal dateFromComponents:comps]];
        
        NSMutableArray* days = [NSMutableArray array];
        
        for (int i= 1; i<=range.length; i++)
        {
            [days addObject:[NSString stringWithFormat:@"%d日",i]];
        }
        _dayPicker.data4Rows = days;
        
        NSLog(@"Month %02d",month);
        
        _monthString = month;
        
    }];
    _yearString = year;

    _monthString = month;

    _dayString = day;

}

#pragma mark - memory managment

- (void)dealloc
{
    _dayPicker = nil;
    _yearPicker = nil;
    _yearPicker = nil;
    _monthImage = nil;
    _monthImage = nil;
    
    self.dayImage = nil;
    self.yearImage = nil;
    self.monthImage = nil;
    self.calendar = nil;
}

#pragma mark - callback functions

-(void)customDatePickerHasChangedCallBack:(CustomDatePickerChangeCallback)block
{
    self.customDatePickerChangeCallback = block;
}
#pragma mark UICustomPickerConrol Delegate

- (void)pickerControllerDidSpin:(CustomPickerView *)controller;
{

}

- (void)pickerController:(CustomPickerView *)dial didSnapToString:(NSString *)string
{
    NSLog(@"index %ld",(long)dial.selectedIndex);//print index
    if (_customDatePickerChangeCallback)
    {
        
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:1+_dayPicker.selectedIndex];
        [comps setMonth:1 + _monthPicker.selectedIndex];
        [comps setYear:_minYear + _yearPicker.selectedIndex];
         NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
        
        if (self.customDatePickerChangeCallback)
        {
            self.customDatePickerChangeCallback(date);
        }
        
        [self.delegate datePickerDateChange:self forDate:date];
    }
}

@end
