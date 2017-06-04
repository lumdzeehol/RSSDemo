//
//  RSSUser.h
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/1.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
@pramas     userID    用户ID
 
@pramas     userName  用户名
 
@pramas     avatar    头像地址
 
 
 */


@interface RSSUser : NSObject

@property (nonatomic,assign) NSNumber *userID;

@property (nonatomic,copy) NSString *userNickName;

@property (nonatomic,strong) UIImage *avatar;







@end
