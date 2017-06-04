//
//  HomeTableViewCell.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/3/20.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "HomeTableViewCell.h"

@interface HomeTableViewCell ()



@end

@implementation HomeTableViewCell

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
    if (self) {
        self.cellView = [[UIView alloc] init];
        self.iconView = [[UIImageView alloc] init];
        self.title = [[UILabel alloc] init];
        self.subTitle = [[UILabel alloc] init];
        self.progress = [[UILabel alloc] init];
        [self.contentView addSubview:self.cellView];
        
        [self.cellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
        }];
        
        [self.cellView addSubview:self.iconView];
        [self.cellView addSubview:self.title];
        [self.cellView addSubview:self.subTitle];
        [self.cellView addSubview:self.progress];
        
        [self.iconView.layer setCornerRadius:10.0f];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cellView.mas_left).with.offset(10);
            make.bottom.equalTo(self.cellView.mas_bottom).with.offset(-10);
            make.top.equalTo(self.cellView.mas_top).with.offset(10);
            make.height.equalTo(self.iconView.mas_width).multipliedBy(1.0f);
        }];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).with.offset(20);
            make.top.equalTo(self.iconView.mas_top).with.offset(10);
            make.width.equalTo(@150);
            make.height.equalTo(@30);
        }];
        [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title.mas_left);
            make.bottom.equalTo(self.iconView.mas_bottom).with.offset(-10);
            make.width.equalTo(@70);
            make.height.equalTo(@20);
        }];
        [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.cellView.mas_right).with.offset(-10);
            make.bottom.equalTo(self.subTitle.mas_bottom);
            make.width.equalTo(@70);
            make.height.equalTo(@20);
        }];
        
        
        
        self.subTitle.font = [UIFont systemFontOfSize:11];
        [self.subTitle setTextColor:[UIColor lightGrayColor]];

        self.progress.font = [UIFont systemFontOfSize:11];
        [self.progress setTextColor:[UIColor lightGrayColor]];
        
        self.iconView.layer.cornerRadius = 8;
        self.iconView.clipsToBounds = YES;
        
        self.cellView.layer.cornerRadius = 10;
        self.cellView.backgroundColor = [UIColor whiteColor];
    }
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}


@end
