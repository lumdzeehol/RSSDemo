//
//  MySegmentControlView.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/4/14.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "MySegmentControlView.h"

#define BTN_NUM 4
#define SEGCONTROL_HEIGHT 34

static const CGFloat padding = 50.0f;
static const CGFloat margin = 5.0f;


@interface MySegmentControlView ()


@end

@implementation MySegmentControlView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithTitles:(NSArray<NSString *> *)titles{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SEGCONTROL_HEIGHT)];
    if (self) {
        CGFloat btnWidth = ([UIScreen mainScreen].bounds.size.width - padding * 2 -(BTN_NUM - 1) * margin) / BTN_NUM;
        
        self.blockView = [[UIView alloc] init];
        self.blockView.backgroundColor = THEME_COLOR;
        

        self.btn1 = [[UIButton alloc] init];
        self.btn2 = [[UIButton alloc] init];
        self.btn3 = [[UIButton alloc] init];
        self.btn4 = [[UIButton alloc] init];
        
        
        [self addSubview:self.blockView];
        [self addSubview:self.btn1];
        [self addSubview:self.btn2];
        [self addSubview:self.btn3];
        [self addSubview:self.btn4];
        
        
        [self.btn1 setTitle:titles[0] forState:UIControlStateNormal];
        [self.btn2 setTitle:titles[1] forState:UIControlStateNormal];
        [self.btn3 setTitle:titles[2] forState:UIControlStateNormal];
        [self.btn4 setTitle:titles[3] forState:UIControlStateNormal];
        
        [self.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btn2 setTitleColor:[UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1.00] forState:UIControlStateNormal];
        [self.btn3 setTitleColor:[UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1.00] forState:UIControlStateNormal];
        [self.btn4 setTitleColor:[UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1.00] forState:UIControlStateNormal];
        
        self.btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        self.btn2.titleLabel.font = [UIFont systemFontOfSize:14];
        self.btn3.titleLabel.font = [UIFont systemFontOfSize:14];
        self.btn4.titleLabel.font = [UIFont systemFontOfSize:14];
        
        self.btn1.tag = 1;
        self.btn2.tag = 2;
        self.btn3.tag = 3;
        self.btn4.tag = 4;
        
        CGSize size = CGSizeMake(btnWidth, 30);
        self.blockView.backgroundColor = THEME_COLOR;
        self.blockView.layer.cornerRadius = 30/2;
        [self.blockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo([NSValue valueWithCGSize:size]);
            make.left.equalTo(self.mas_left).with.offset(padding);
            make.top.equalTo(self.mas_top).with.offset(2);
        }];
        
        [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo([NSValue valueWithCGSize:size]);
            make.left.equalTo(self.mas_left).with.offset(padding);
            make.top.equalTo(self.mas_top).with.offset(2);
        }];
        [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo([NSValue valueWithCGSize:size]);
            make.left.equalTo(self.btn1.mas_right).with.offset(margin);
            make.top.equalTo(self.mas_top).with.offset(2);
        }];
        [self.btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo([NSValue valueWithCGSize:size]);
            make.left.equalTo(self.btn2.mas_right).with.offset(margin);
            make.top.equalTo(self.mas_top).with.offset(2);
        }];
        [self.btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo([NSValue valueWithCGSize:size]);
            make.left.equalTo(self.btn3.mas_right).with.offset(margin);
            make.right.equalTo(self.mas_right).with.offset(-padding);
            make.top.equalTo(self.mas_top).with.offset(2);
        }];
        

        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake( 0 , 0.5);
        self.layer.shadowRadius = 0.5;
        self.layer.shadowOpacity = 0.3;


        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


//-(void)clickAction:(UIButton *)sender{
//    NSLog(@"tag of button %li",sender.tag);
//    CGFloat btnWidth = ([UIScreen mainScreen].bounds.size.width - padding * 2 -(BTN_NUM - 1) * margin) / BTN_NUM;
//    CGSize size = CGSizeMake(btnWidth, 30);
//    
//    
//    [self.blockView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.size.equalTo([NSValue valueWithCGSize:size]);
//        make.left.equalTo(sender.mas_left);
//        make.top.equalTo(self.mas_top).with.offset(2);
//    }];
//    [UIView animateWithDuration:0.3 animations:^{
//        [self layoutIfNeeded];
//        [self.btn1 setTitleColor:[UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1.00] forState:UIControlStateNormal];
//        [self.btn2 setTitleColor:[UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1.00] forState:UIControlStateNormal];
//        [self.btn3 setTitleColor:[UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1.00] forState:UIControlStateNormal];
//        [self.btn4 setTitleColor:[UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1.00] forState:UIControlStateNormal];
//        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    }];
//    
//}


@end
