//
//  NameChangeViewController.h
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/18.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NameChangeDelegate <NSObject>

-(void)didChangeName;

@end

@interface NameChangeViewController : UIViewController

@property (nonatomic,copy) NSString* name;

@property (nonatomic,weak) id<NameChangeDelegate> delegate;

@end
