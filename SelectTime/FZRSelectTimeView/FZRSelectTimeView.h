//
//  FZRSelectTimeView.h
//  SelectTime
//
//  Created by fuzhaurui on 2017/1/11.
//  Copyright © 2017年 fuzhaurui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FZRSelectTimeBlock)(NSMutableArray *array);

@interface FZRSelectTimeView : UIView

///MARK: - 初始化共享视图
+ (FZRSelectTimeView*)sharedView;

/*
 * MARK: - 单选时间
 * canSelectPastDays: YES 过去时间可选  NO 过去时间不可选
 * selectTimeBlock:   返回选中时间
 */
-(void)selectTimeCanSelectPastDays:(BOOL)canSelectPastDays andSingle:(FZRSelectTimeBlock)selectTimeBlock;


/*
 * MARK: - 多选时间
 * canSelectPastDays: YES 过去时间可选  NO 过去时间不可选
 * selectTimeBlock:   返回选中时间
 */
-(void)selectTimeCanSelectPastDays:(BOOL)canSelectPastDays andMultiple:(FZRSelectTimeBlock)selectTimeBlock;


/*
 * MARK: - 范围时间
 * canSelectPastDays: YES 过去时间可选  NO 过去时间不可选
 * selectTimeBlock:   返回选中时间
 */
-(void)selectTimeCanSelectPastDays:(BOOL)canSelectPastDays andRange:(FZRSelectTimeBlock)selectTimeBlock;

@end
