//
//  MySegmentControlView.h
//  RSSDemo
//
//  Created by lumdzeehol on 2017/4/14.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySegmentControlView : UIView


@property (nonatomic,strong) UIButton *btn1;
@property (nonatomic,strong) UIButton *btn2;
@property (nonatomic,strong) UIButton *btn3;
@property (nonatomic,strong) UIButton *btn4;

@property (nonatomic,strong) UIView *blockView; //按钮选中效果view



-(instancetype)initWithTitles:(NSArray<NSString *> *) titles;

@end
