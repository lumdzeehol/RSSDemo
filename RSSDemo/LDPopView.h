//
//  LDPopView.h
//  RSSDemo
//
//  Created by lumdzeehol on 2017/4/4.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LDPopView : UIView

@property (nonatomic,assign,getter=isOpen) BOOL open;

@property (nonatomic,strong) UIView *front;
@property (nonatomic,weak) UIColor *frontBackGroundColor;
@property (nonatomic,assign,readonly) CGFloat frontHeight;

@property (nonatomic,strong) UIButton *plusButton;

@property (nonatomic,assign,readonly) NSInteger buttonsCount;//number of buttons on the popView

@property (nonatomic,strong) NSMutableArray<UIButton *> *buttonArray;

-(void)dismissPopView;

-(void)setFrontColor:(UIColor *) color; // default is blue:[UIColor colorWithRed:0.13 green:0.59 blue:0.85 alpha:1.00]

-(instancetype)initWithFrame:(CGRect) frame andButtonIcons:(NSArray<UIImage *> *) buttonIcons andButtonNames:(NSArray<NSString *> *) buttonNames;

@end
