//
//  ZYWeekView.h
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZRCalendarManager.h"

@interface FZRWeekView : UIView
@property (nonatomic, strong) NSDate *theMonthFirstDay;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, weak)FZRCalendarManager *manager;

@end
