//
//  HomeTableViewHeaderView.h
//  RSSDemo
//
//  Created by lumdzeehol on 2017/3/20.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewHeaderView : UIView

@property (nonatomic,strong) UILabel *projectNumberLabel;


-(void)refreshNumberInLabel:(NSInteger) number;

@end
