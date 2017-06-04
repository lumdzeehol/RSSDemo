//
//  LDTabBar.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/3/23.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "LDTabBar.h"

@interface LDTabBar ()



//-(void)clickPlusBtn;

@end

@implementation LDTabBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(UIButton *)plusBtn{
    if (_plusBtn == nil) {
        _plusBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 47, 47)];
        [_plusBtn setImage:[UIImage imageNamed:@"PlusBtn"] forState:UIControlStateNormal];
        [_plusBtn setImage:[UIImage imageNamed:@"PlusBtn"] forState:UIControlStateHighlighted];

    }
    return _plusBtn;
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.tintColor = THEME_COLOR;
        [self addSubview:self.plusBtn];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //数组用于存放tabbar子视图中的UITabBarButton
    NSMutableArray *tabBarButtonArray = [NSMutableArray array];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtonArray addObject:view];
        }
    }
    //tabbar的宽度和高度
    CGFloat tabWidth = self.bounds.size.width;
    CGFloat tabHeight = self.bounds.size.height;

//    CGFloat plusBtnHeight = self.plusBtn.frame.size.height;
    self.plusBtn.center = CGPointMake(tabWidth/2, tabHeight/2);
    //每个item的宽度
//    CGFloat barItemWidth = (tabWidth - plusBtnWidth)/tabBarButtonArray.count;
    CGFloat barItemWidth = tabWidth/(tabBarButtonArray.count + 1);
    [tabBarButtonArray enumerateObjectsUsingBlock:^(UIView *  _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = view.frame;
        if (idx > tabBarButtonArray.count/2 - 1) {
            frame.origin.x = idx *barItemWidth + barItemWidth;
        }else{
            frame.origin.x = idx *barItemWidth;
        }
        frame.size.width = barItemWidth;
        view.frame = frame;
    }];
    
    [self bringSubviewToFront:self.plusBtn];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    
    return view;
}



@end
