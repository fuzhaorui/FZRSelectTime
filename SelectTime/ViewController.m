//
//  ViewController.m
//  SelectTime
//
//  Created by fuzhaurui on 2017/1/11.
//  Copyright © 2017年 fuzhaurui. All rights reserved.
//

#import "ViewController.h"
#import "FZRSelectTimeView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *array = @[@"单选",@"多选",@"范围选择"];
    for (int i=0; i<array.count; i++) {
        UIButton *button =[[UIButton alloc]initWithFrame:CGRectMake(50, 200+(60*i), 200, 50)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTintColor:[UIColor blackColor]];
        button.backgroundColor = [UIColor blueColor];
        button.tag = 1000 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
   
}

-(void)buttonAction:(UIButton *)sender
{
    
    if (sender.tag == 1000) {
       [[FZRSelectTimeView sharedView]selectTimeCanSelectPastDays:NO andSingle:^(NSMutableArray *array)
           {
               NSLog(@"%@",array);
           }
       ];
    }
    else if(sender.tag == 1001)
    {
       [[FZRSelectTimeView sharedView]selectTimeCanSelectPastDays:NO andMultiple:^(NSMutableArray *array)
           {
               NSLog(@"%@",array);
           }
       ];
    }
    else if(sender.tag == 1002)
    {
       [[FZRSelectTimeView sharedView]selectTimeCanSelectPastDays:NO andRange:^(NSMutableArray *array)
           {
               NSLog(@"%@",array);
               
               NSLog(@"%@",[self statisticsTime:array[0] endDate:array[1]]);
           }
        ];
    }
    
}


/*
 * MARK:       - 统计两个时间之前的所以时间
 * startDate:  开始时间
 * endDate:    结束时间
 */
-(NSMutableArray *)statisticsTime:(NSDate *)startDate endDate:(NSDate *)endDate
{

    NSMutableArray *dateArray = [[NSMutableArray alloc]init];
    [dateArray addObject:startDate];
    for (int i = 1;i>0 ;) {
        NSDate *date = dateArray[dateArray.count-1];
        NSDate *continueDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];
        if ([continueDate isEqual:endDate]) {
            i = 0;
        }
        else
        {
            [dateArray addObject:continueDate];
        }
        
    }
    [dateArray addObject:endDate];
    return  dateArray;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
