//
//  LDPopView.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/4/4.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "LDPopView.h"
#import "CreateProjectViewController.h"

//plusBtn长款
#define PLUS_BTN_WIDTH 47
#define PLUS_BTN_HEIGHT 47

//popView按钮长款
#define BTN_WIDTH 45
#define BTN_HEIGHT 45



@implementation LDPopView

-(NSInteger)buttonsCount{
    if (!_buttonArray) {
        return 0;
    }
    return _buttonArray.count;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame andButtonIcons:(NSArray<UIImage *> *)buttonIcons andButtonNames:(NSArray<NSString *> *)buttonNames{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.front = [[UIView alloc] initWithFrame:CGRectMake(self.center.x - PLUS_BTN_WIDTH/2.0f, self.frame.size.height - 1 - PLUS_BTN_HEIGHT, PLUS_BTN_WIDTH, PLUS_BTN_HEIGHT)];
        _frontHeight = frame.size.height;
        self.front.layer.cornerRadius = PLUS_BTN_WIDTH/2.0f;
        [self setFrontColor:THEME_COLOR];
        [self addSubview:self.front];
        
        
        self.buttonArray = [NSMutableArray array];


        for (int i = 0; i<buttonIcons.count; i++) {
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(self.center.x - BTN_HEIGHT/2.0f, self.frame.size.height - PLUS_BTN_HEIGHT, BTN_WIDTH, BTN_HEIGHT );
            btn.tag = i;
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.cornerRadius = BTN_WIDTH/2.0f;
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            
            [btn setTintColor:THEME_COLOR];
            
            [btn setTitle:buttonNames[i] forState:UIControlStateNormal];
            [btn setTitle:buttonNames[i] forState:UIControlStateHighlighted];

            
            UIImage *btnImage = buttonIcons[i];
            [btnImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [btn setImage:btnImage forState:UIControlStateNormal];
            [btn setImage:btnImage forState:UIControlStateHighlighted];
            

            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.imageEdgeInsets = UIEdgeInsetsMake(BTN_WIDTH*0.2f, BTN_WIDTH*0.2f, BTN_WIDTH*0.2f, BTN_WIDTH*0.2f);
            btn.titleEdgeInsets = UIEdgeInsetsMake(BTN_WIDTH + 4 , -BTN_WIDTH + (BTN_WIDTH - 30)/2, 0, 0);

            btn.alpha = 0.0f;
            [self addSubview:btn];
//            [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonArray addObject:btn];
        }
    }
    return self;
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self.front];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    
    return view;
}

-(void)didMoveToSuperview{
    self.plusButton = [[UIButton alloc] initWithFrame:CGRectMake(self.center.x - PLUS_BTN_WIDTH/2.0f, self.frame.size.height - PLUS_BTN_HEIGHT - 1 , PLUS_BTN_WIDTH, PLUS_BTN_HEIGHT)];
    [self.plusButton setImage:[UIImage imageNamed:@"PlusBtn"] forState:UIControlStateNormal];
    [self.plusButton setImage:[UIImage imageNamed:@"PlusBtn"] forState:UIControlStateHighlighted];
    [self.plusButton addTarget:self action:@selector(dismissPopView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.plusButton];
    
    CGFloat padding = 20.0f;
    CGFloat margin = (self.frame.size.width - padding * 2 - BTN_WIDTH * self.buttonsCount)/(self.buttonsCount - 1);
    [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:0.8f options:UIViewAnimationOptionBeginFromCurrentState  animations:^{
        self.front.frame = CGRectMake(0, self.frame.size.height - self.frontHeight, self.frame.size.width, self.frontHeight);
        for (int i = 0; i < self.buttonsCount; i++) {
            UIButton *btn =  [self.buttonArray objectAtIndex:i];
            if (i == 0) {
                btn.frame = CGRectMake(20, self.front.frame.origin.y + 20, BTN_WIDTH, BTN_HEIGHT);
            }else{
                btn.frame = CGRectMake(20 + BTN_WIDTH * i + margin * i, self.front.frame.origin.y + 20, BTN_WIDTH, BTN_HEIGHT);
            }
            btn.alpha = 1.0f;
        }
    } completion:nil];
    CABasicAnimation *animCorner = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animCorner.fromValue = [NSNumber numberWithFloat:PLUS_BTN_WIDTH/2.0f];
    animCorner.toValue = [NSNumber numberWithFloat:0];
    animCorner.fillMode = kCAFillModeForwards;
    animCorner.removedOnCompletion = NO;
    animCorner.duration = 0.3f;
    [self.front.layer addAnimation:animCorner forKey:nil];

    CABasicAnimation *animBtn = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animBtn.toValue = [NSNumber numberWithFloat:(M_PI_4)];
    animBtn.fromValue = [NSNumber numberWithFloat:0];
    animBtn.fillMode = kCAFillModeForwards;
    animBtn.removedOnCompletion = NO;
    animBtn.duration = 0.2f;
    [self.plusButton.layer addAnimation:animBtn forKey:nil];
}



-(void)dismissPopView{

    CABasicAnimation *btnAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    btnAnim.fillMode = kCAFillModeForwards;
    btnAnim.removedOnCompletion = NO;
    btnAnim.fromValue = [NSNumber numberWithFloat:M_PI_4];
    btnAnim.toValue = [NSNumber numberWithFloat:0.0f];
    btnAnim.duration = 0.3f;
    [self.plusButton.layer addAnimation:btnAnim forKey:nil];
    
    CABasicAnimation *frontAnim = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    frontAnim.fillMode = kCAFillModeForwards;
    frontAnim.removedOnCompletion = NO;
    frontAnim.fromValue = [NSNumber numberWithFloat:0.0f];
    frontAnim.toValue = [NSNumber numberWithFloat:PLUS_BTN_WIDTH/2.0f];
    frontAnim.duration = 0.3f;
    [self.front.layer addAnimation:frontAnim forKey:nil];
    
    [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:0.8f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.front.frame = CGRectMake(self.center.x - PLUS_BTN_WIDTH/2.0f, self.frame.size.height - PLUS_BTN_HEIGHT - 1 , PLUS_BTN_WIDTH, PLUS_BTN_HEIGHT);
        self.alpha = 0.0f;
        for (int i = 0; i<self.buttonsCount; i++) {
            UIButton *btn = [self.buttonArray objectAtIndex:i];
            btn.frame = CGRectMake(self.center.x - BTN_HEIGHT/2.0f, self.frame.size.height - PLUS_BTN_HEIGHT, BTN_WIDTH, BTN_HEIGHT);
        }
    } completion:^(BOOL finished) {
            [self removeFromSuperview];
    }];

    
}

//-(void)click:(UIButton *)sender{
//    
//}

-(void)setFrontColor:(UIColor *)color{
    self.frontBackGroundColor = color;
    self.front.backgroundColor = color;
}

@end
