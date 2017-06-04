//
//  MyTableViewCell.h
//  RSSDemo
//
//  Created by lumdzeehol on 2017/3/25.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell

@property (nonatomic,assign,getter=isChecked) BOOL checked;

@property (nonatomic,strong) UIButton *checkBox;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *subTitle;



@end
