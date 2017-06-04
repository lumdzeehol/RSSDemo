//
//  MyNavigationBar.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/3/27.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "MyNavigationBar.h"
#import "MySegmentControlView.h"

@interface MyNavigationBar ()


@property (nonatomic,strong) MySegmentControlView *segView;

@property (nonatomic,strong) UIImageView *userIcon;

@property (nonatomic,strong) UILabel *userNameLabel;

@end

@implementation MyNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//-(CGSize)sizeThatFits:(CGSize)size{
//    CGSize navigationBarSize = [super sizeThatFits:size];
//    
//    navigationBarSize.height += 40.0f;
//    
//    return navigationBarSize;
//}

-(instancetype)init{
    self = [super init];
    if (self) {
        
        
        
//        self.segView = [[MySegmentControlView alloc] initWithTitles:titleArray];
        [self addSubview:self.userIcon];
        [self addSubview:self.userNameLabel];
        [self addSubview:_segView];
        
        [self setTitleVerticalPositionAdjustment:-40.0f forBarMetrics:UIBarMetricsDefault];
    }
    return self;
}

-(void)layoutSubviews{
    for (UIView *view in self.subviews) {
        NSLog(@"self.subviews %@",self.subviews);
        if ([view isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            [view removeFromSuperview];
        }
    }
}

@end
