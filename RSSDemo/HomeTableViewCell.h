//
//  HomeTableViewCell.h
//  RSSDemo
//
//  Created by lumdzeehol on 2017/3/20.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

/*
 
 @prama cellView    覆盖于contentview上的容器视图
 
 @prama iconView    项目图标
 
 @prama title       项目标题
 
 @prama subTitle    项目类型
 
 @prama progress    项目进度(完成数量)
 
 */
@property (nonatomic,strong) UIView *cellView;
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *subTitle;
@property (nonatomic,strong) UILabel *progress;


@end
