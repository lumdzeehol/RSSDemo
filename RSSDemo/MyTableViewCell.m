//
//  MyTableViewCell.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/3/25.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "MyTableViewCell.h"


@interface MyTableViewCell ()


@end

@implementation MyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.checkBox = [[UIButton alloc] init];
    self.title = [[UILabel alloc] init];
    self.subTitle = [[UILabel alloc] init];
    UIView *bottom = [[UIView alloc] init];
    
    [self addSubview:self.checkBox];
    [self addSubview:self.title];
    [self addSubview:self.subTitle];
    [self addSubview:bottom];
    
    [self.checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.width.equalTo(self.mas_height).with.offset(-12);
        make.height.equalTo(self.mas_height).with.offset(-12);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).with.offset(-5);
        make.left.equalTo(self.checkBox.mas_right).with.offset(10);
        make.height.equalTo(@16);
        make.right.equalTo(self.mas_right).with.offset(10);
    }];
    
    
    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).with.offset(5);
        make.left.equalTo(self.title);
        make.right.equalTo(self.title);
        make.height.equalTo(@13);
    }];
    
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@2);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
    }];
    bottom.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.title.font = [UIFont systemFontOfSize:16];
    self.subTitle.font = [UIFont systemFontOfSize:13];
    [self.subTitle setTextColor:[UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.00]];
    
    self.title.text = @"Title";
    self.subTitle.text = @"Subtitle Subtitle ";
    
    [self.checkBox setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [self.checkBox setImage:[UIImage imageNamed:@"checkbox_set"] forState:UIControlStateSelected];
//    [self.checkBox addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];

    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self;
}


//-(void)click{
//    if (self.checkBox.selected) {
//        [self.checkBox setSelected:NO];
//        self.checked = NO;
//    }else{
//        [self.checkBox setSelected:YES];
//        self.checked = YES;
//    }
//}

@end
