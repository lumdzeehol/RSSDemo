//
//  ChooseExecutorViewController.h
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/2.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSUser.h"

@protocol RSSCreateMissionUserDelegate <NSObject>

-(void)didSelectUser:(RSSUser *) user;

@end

@interface ChooseExecutorViewController : UIViewController

@property (nonatomic,weak) id<RSSCreateMissionUserDelegate> delegate;

@end
