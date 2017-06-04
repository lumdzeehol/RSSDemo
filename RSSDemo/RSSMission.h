//
//  RSSMission.h
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/1.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
    @pramas:
 
        missionID:      任务ID
 
        missionName;    任务名
 
        executorID:     执行者ID
 
        remarks:        备注
 
 */



@interface RSSMission : NSObject

@property (nonatomic,assign) NSNumber *missionID;

@property (nonatomic,copy) NSString *missionName;

@property (nonatomic,assign) NSNumber *executorID;

@property (nonatomic,copy) NSString *deadline;

@property (nonatomic,assign) BOOL isCompleted;

@property (nonatomic,assign) NSNumber *projectID;

@end
