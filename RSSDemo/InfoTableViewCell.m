//
//  InfoTableViewCell.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/18.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "InfoTableViewCell.h"

@implementation InfoTableViewCell

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
    
    if (self!=nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:view];
        
        self.missionName = [[UILabel alloc] init];
        self.deadline = [[UILabel alloc] init];
        self.fromProject =[[ UILabel alloc] init];
        
        [self.contentView addSubview:_missionName];
        [self.contentView addSubview:_deadline];
        [self.contentView addSubview:_fromProject];
        
        [self.missionName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(10);
//            make.centerY.equalTo(self.mas_centerY);
            make.top.equalTo(self.mas_top).with.offset(5);
            make.height.equalTo(@34);
            make.width.equalTo(@120);
        }];
        
        [self.deadline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.missionName.mas_left);
//            make.centerY.equalTo(self.mas_centerY);
            make.top.equalTo(self.missionName.mas_bottom).with.offset(5);
            make.bottom.equalTo(self.mas_bottom).with.offset(-5);
            make.width.equalTo(@200);
//            make.height.equalTo(@30);
        }];
        
        
        
        [self.fromProject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.left.equalTo(self.missionName.mas_right).with.offset(20);
            make.height.equalTo(@34);
//            make.centerY.equalTo(self.mas_centerY);
            make.bottom.equalTo(self.missionName.mas_bottom);
        }];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.width.equalTo(@400);
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left);
        }];
        
        self.missionName.font = [UIFont systemFontOfSize:16];
        self.deadline.font = [UIFont systemFontOfSize:14];
        [self.deadline setTextColor:[UIColor lightGrayColor]];
        self.fromProject.font = [UIFont systemFontOfSize:14];
        self.fromProject.textAlignment = NSTextAlignmentRight;
    }
    
    return self;
}

@end
