//
//  ChooseDateViewController.h
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/8.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RSSCreateMissionDateDelegate <NSObject>

-(void)didSelectDate:(NSDate *) date;

@end

@interface ChooseDateViewController : UIViewController

@property (nonatomic,strong) id<RSSCreateMissionDateDelegate> delegate;

@end
