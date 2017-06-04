//
//  HomeTableViewHeaderView.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/3/20.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "HomeTableViewHeaderView.h"

@implementation HomeTableViewHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.projectNumberLabel = [[UILabel alloc] init];
        self.projectNumberLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
        [self addSubview:self.projectNumberLabel];
        [self.projectNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.top.equalTo(self.mas_top).with.offset(10);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
//            make.centerY.equalTo(self.superview);
        }];
        [self refreshNumberInLabel:2];
    }
    
    
    return self;
}

//刷新headerView的项目数
-(void)refreshNumberInLabel:(NSInteger)number{
    self.projectNumberLabel.text  =[NSString stringWithFormat:@"我拥有的项目:%li",number];
}

@end
