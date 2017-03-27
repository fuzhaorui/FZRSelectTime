//
//  ZYCalendarView.h
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZRCalendarManager.h"

@class FZRCalendarView;

@interface FZRCalendarView : UIScrollView
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, strong)FZRCalendarManager *manager;
@property (nonatomic, copy)void(^dayViewBlock)(id);

@end
