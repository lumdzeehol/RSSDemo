//
//  ProjectFileTableViewCell.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/2.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "ProjectFileTableViewCell.h"

@implementation ProjectFileTableViewCell

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
        self.imageModel = [[RSSImage alloc] init];
        
        self.backgroundColor = [UIColor clearColor];
        self.moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        UIImage *btnImg = [[UIImage imageNamed:@"pulldown"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        [self.moreBtn setImage:btnImg forState:UIControlStateNormal];
        [self.contentView addSubview:self.moreBtn];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@44);
            make.height.equalTo(@44);
            make.right.equalTo(self.mas_right).with.offset(-5);
            make.centerY.equalTo(self.mas_centerY);
        }];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)layoutSubviews{
    self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height - 1);
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@36);
        make.height.equalTo(@36);
        make.left.equalTo(self.mas_left).with.offset(5);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).with.offset(10);
        make.right.equalTo(self.moreBtn.mas_left).with.offset(10);
        make.top.equalTo(self.mas_top).with.offset(5);
        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
    }];
    
}

@end
