//
//  RSSProject.h
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/1.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 @pramas:
    
    projectName:         项目名
 
    projectType:         项目类型
 
    picture:             项目封面图片
 
    creatorID:           创建者ID
 
    missionListID:       任务列表ID
 
    completedMissions:   完成任务数量
 
 */

@interface RSSProject : NSObject

@property (nonatomic,assign) NSNumber *projectID;

@property (nonatomic,copy) NSString *projectName;

@property (nonatomic,assign) BOOL projectType;

@property (nonatomic,assign) NSNumber  *creatorID;

@property (nonatomic,assign) NSInteger completedMissionNum;

@property (nonatomic,assign) NSInteger sumofMission;

@end
