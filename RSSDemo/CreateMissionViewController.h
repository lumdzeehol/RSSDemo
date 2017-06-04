//
//  CreateMissionViewController.h
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/2.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSMission.h"
#import "RSSProject.h"
#import "ChooseExecutorViewController.h"
#import "ChooseDateViewController.h"
#import "ChooseProjectViewController.h"

@interface CreateMissionViewController : UIViewController


@property (nonatomic,strong) NSMutableDictionary *dataDict;

@property (nonatomic,strong) UITextField *missionName;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIBarButtonItem *doneBtn;

@property (nonatomic,strong) RSSMission *missionModel;

@property (nonatomic,strong) RSSUser *executorModel;

@property (nonatomic,strong) NSDate *deadline;

@property (nonatomic,strong) RSSProject *projectModel;

@property (nonatomic,assign) BOOL setExecutor;

@property (nonatomic,assign) BOOL setDeadline;

@property (nonatomic,assign) BOOL setProject;

@property (nonatomic,assign) BOOL setName;


@end
