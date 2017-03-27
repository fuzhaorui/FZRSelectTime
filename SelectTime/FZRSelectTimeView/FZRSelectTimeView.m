//
//  FZRSelectTimeView.m
//  SelectTime
//
//  Created by fuzhaurui on 2017/1/11.
//  Copyright © 2017年 fuzhaurui. All rights reserved.
//

#import "FZRSelectTimeView.h"
#import "FZRCalendarView.h"
#import "AppDelegate.h"

@interface FZRSelectTimeView()
{
    NSMutableArray *_array;
    FZRSelectTimeBlock _fzrSelectTimeBlock;
}

@property(strong ,nonatomic)AppDelegate *appDelegate;
@property(strong ,nonatomic)UIView *weekTitlesView;
@property(strong ,nonatomic)FZRCalendarView *FZRCalendarView;
@property(strong ,nonatomic)UIButton *determineButton;
@end

@implementation FZRSelectTimeView



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


///MARK: - 初始化共享视图
+ (FZRSelectTimeView*)sharedView {

    static dispatch_once_t once;

    static FZRSelectTimeView *sharedView;

    dispatch_once(&once, ^ {

        sharedView = [[FZRSelectTimeView alloc] initWithFrame:[UIScreen mainScreen].bounds];

        sharedView.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

        [sharedView.appDelegate.window addSubview:sharedView];
        
        sharedView.backgroundColor = [UIColor whiteColor];

        [sharedView addSubview:sharedView.weekTitlesView];
        
        [sharedView addSubview:sharedView.determineButton];
        
        [sharedView.determineButton setHidden:YES];
        
        sharedView.alpha = 0;
        
    });
    
    

    [sharedView.appDelegate.window bringSubviewToFront:sharedView];
    
    return sharedView;
}

-(UIView *)weekTitlesView
{
    if (!_weekTitlesView) {
        
        _weekTitlesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
        
        CGFloat weekW = [UIScreen mainScreen].bounds.size.width/7;
        
        NSArray *titles = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
        
        for (int i = 0; i < 7; i++) {
            
            UILabel *week = [[UILabel alloc] initWithFrame:CGRectMake(i*weekW, 20, weekW, 44)];
            
            week.textAlignment = NSTextAlignmentCenter;
            
            week.textColor = ZYHEXCOLOR(0x666666);
            
            week.text = titles[i];
            
            [_weekTitlesView addSubview:week];
           
        }
    }
    return _weekTitlesView;
}

-(FZRCalendarView *)FZRCalendarView
{
    if (!_FZRCalendarView) {
        
        _FZRCalendarView = [[FZRCalendarView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];

    }
    return _FZRCalendarView;
}

-(UIButton *)determineButton
{
    if (!_determineButton) {
        _determineButton = [[UIButton alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50)];
        [_determineButton setTitle:@"确定选中" forState:UIControlStateNormal];
        [_determineButton setTintColor:[UIColor blackColor]];
        _determineButton .backgroundColor = ZYHEXCOLOR(0x128963);
        [_determineButton addTarget:self action:@selector(determineAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _determineButton;
    
}


-(void)determineAction:(UIButton *)sender
{
 
    _fzrSelectTimeBlock(_array);
    
    [[FZRSelectTimeView sharedView] dismissSelectTimeView];
}

/*
 * MARK: - 单选时间
 * canSelectPastDays: YES 过去时间可选  NO 过去时间不可选
 * selectTimeBlock:   返回选中时间
 */
-(void)selectTimeCanSelectPastDays:(BOOL)canSelectPastDays andSingle:(FZRSelectTimeBlock)selectTimeBlock
{
    
    [[FZRSelectTimeView sharedView] showSelectTimeView];
   
    [self.determineButton setHidden:YES];
    
    // 不可以点击已经过去的日期
    _FZRCalendarView.manager.canSelectPastDays = canSelectPastDays;
    
    // 可以选择时间段
    _FZRCalendarView.manager.selectionType = ZYCalendarSelectionTypeSingle;
    
    // 设置当前日期
    _FZRCalendarView.date = [NSDate date];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    _FZRCalendarView.dayViewBlock =^(NSDate *dayDate)
    {
        [array addObject:dayDate];
        
        selectTimeBlock(array);
        
        [[FZRSelectTimeView sharedView] dismissSelectTimeView];
    };
}


/*
 * MARK: - 多选时间
 * canSelectPastDays: YES 过去时间可选  NO 过去时间不可选
 * selectTimeBlock:   返回选中时间
 */
-(void)selectTimeCanSelectPastDays:(BOOL)canSelectPastDays andMultiple:(FZRSelectTimeBlock)selectTimeBlock
{
    [[FZRSelectTimeView sharedView] showSelectTimeView];
    
    
    self.FZRCalendarView.frame =  CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-114);
    
    [self.determineButton setHidden:NO];
    
    // 不可以点击已经过去的日期
    _FZRCalendarView.manager.canSelectPastDays = canSelectPastDays;
    
    // 可以选择时间段
    _FZRCalendarView.manager.selectionType = ZYCalendarSelectionTypeMultiple;
    
    // 设置当前日期
    _FZRCalendarView.date = [NSDate date];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    _FZRCalendarView.dayViewBlock =^(NSDate *dayDate)
    {
        
        BOOL switchBool = NO;
        
        if (array.count>0) {
            switchBool  = [array containsObject:dayDate];
        }
        
        if (switchBool == YES) {
            [array removeObject:dayDate];
        }
        else
        {
            [array addObject:dayDate];
        }
        
        if (array.count == 0) {
            [[FZRSelectTimeView sharedView].determineButton setTitle:@"确定选中" forState:UIControlStateNormal];
        }
        else{
            [[FZRSelectTimeView sharedView].determineButton setTitle:[NSString stringWithFormat:@"确定选中(%ld)",array.count] forState:UIControlStateNormal];
        }

    };
    
    _fzrSelectTimeBlock  = selectTimeBlock;
    
    _array = array;
}


/*
 * MARK: - 范围时间
 * canSelectPastDays: YES 过去时间可选  NO 过去时间不可选
 * selectTimeBlock:   返回选中时间
 */
-(void)selectTimeCanSelectPastDays:(BOOL)canSelectPastDays andRange:(FZRSelectTimeBlock)selectTimeBlock
{
    [[FZRSelectTimeView sharedView] showSelectTimeView];
    
    [self.determineButton setHidden:YES];
    
    // 不可以点击已经过去的日期
    _FZRCalendarView.manager.canSelectPastDays = canSelectPastDays;
    
    // 可以选择时间段
    _FZRCalendarView.manager.selectionType = ZYCalendarSelectionTypeRange;
    
    // 设置当前日期
    _FZRCalendarView.date = [NSDate date];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    _FZRCalendarView.dayViewBlock =^(NSDate *dayDate)
    {
        if (array.count == 0) {
            [array addObject:dayDate];
        }
        else{
            
            NSDate *date  = array[0];
            
            NSTimeInterval timeInterval= [dayDate timeIntervalSinceDate:date];
            
            if (timeInterval > 0)
            {
                [array addObject:dayDate];
                selectTimeBlock(array);
            }
            else if (timeInterval < 0)
            {
                [array removeObjectAtIndex:0];
                [array addObject:dayDate];
            }
        }
        
        if (array.count == 2) {
            [[FZRSelectTimeView sharedView] dismissSelectTimeView];
        }
    };
}


-(void)showSelectTimeView
{

    [_FZRCalendarView removeFromSuperview];
    _FZRCalendarView = nil;
    [self addSubview:self.FZRCalendarView];
    
    [[FZRSelectTimeView sharedView] animationAndView:[FZRSelectTimeView sharedView] andAlpha:1 andDuration:1 andDelay:0];
    
}

-(void)dismissSelectTimeView
{
    [[FZRSelectTimeView sharedView] animationAndView:[FZRSelectTimeView sharedView] andAlpha:0 andDuration:1 andDelay:0];
}


/**
 MARK: -  UIView的动画
 1.alpha :动画后 UIView的alpha
 2.duration :动画耗时
 3.delay :动画延迟时间
 **/
-(void)animationAndView:(UIView *)view andAlpha:(CGFloat)alpha andDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay
{
    //创建动画
    [UIView beginAnimations:nil context:nil];
    //动画时间
    [UIView setAnimationDuration:duration];
    //移动后的位置
    view.alpha = alpha;
    //开始动画
    [UIView commitAnimations];
}





@end
