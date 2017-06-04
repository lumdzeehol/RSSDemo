//
//  ChooseProjectViewController.h
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/8.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSProject.h"

@protocol RSSCreateMissionProjectDelegate <NSObject>

-(void)didSelectProject:(RSSProject *) project;

@end

@interface ChooseProjectViewController : UIViewController

@property (nonatomic,weak) id<RSSCreateMissionProjectDelegate> delegate;

@end
