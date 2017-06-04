//
//  HomeViewController.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/3/20.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "HomeTableViewHeaderView.h"
#import "SignViewController.h"
#import <FMDB.h>
#import "RSSProject.h"
#import "ProjectDetailViewController.h"
#import <MJRefresh.h>

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.dataArr = [NSMutableArray array];
    //初始化tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    //使tableView视图不延伸到navBar和tabBar下方
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];

    //设置数据源和代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //设置tableHeaderView
    HomeTableViewHeaderView *header = [[HomeTableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 40)];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    MJRefreshStateHeader *refreshHeader = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    self.tableView.mj_header = refreshHeader;
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.dataArr removeAllObjects];
        FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
        if ([dataBase open]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            int userid = [[defaults objectForKey:@"currentUserID"] intValue];
            NSString *query = [NSString stringWithFormat:@"SELECT * FROM RSSProjectList WHERE creatorID = %d OR projecttype = 1",userid];
            
            FMResultSet *set = [dataBase executeQuery:query];
            while ([set next]) {
                
                RSSProject *project = [[RSSProject alloc] init];
                project.projectID = [NSNumber numberWithInt:[set intForColumnIndex:0]];
                ;
                project.projectName = [set stringForColumnIndex:1];
                if ([set intForColumnIndex:2]) {
                    project.projectType = YES;
                }else{
                    project.projectType = NO;
                }
                project.creatorID = [NSNumber numberWithInt:[set intForColumnIndex:3]];
                
                NSString *query2 = [NSString stringWithFormat:@"SELECT * FROM RSSMissions WHERE projectid = %d",[project.projectID intValue]];
                FMResultSet *missionSet = [dataBase executeQuery:query2];
                NSInteger numofMission = 0;
                NSInteger numofCompletedMission = 0;
                while ([missionSet next]) {
                    numofMission = numofMission + 1;
                    BOOL isCompleted = [missionSet boolForColumn:@"iscompleted"];
                    if (isCompleted == YES) {
                        numofCompletedMission = numofCompletedMission + 1;
                    }
                }
                project.completedMissionNum = numofCompletedMission;
                project.sumofMission = numofMission;
                [self.dataArr addObject:project];
            }
        }
        [dataBase close];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

-(void)refreshTableView{
    [self.dataArr removeAllObjects];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
    if ([dataBase open]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int userid = [[defaults objectForKey:@"currentUserID"] intValue];
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM RSSProjectList WHERE creatorID = %d OR projecttype = 1",userid];

        FMResultSet *set = [dataBase executeQuery:query];
        while ([set next]) {
        
            RSSProject *project = [[RSSProject alloc] init];
            project.projectID = [NSNumber numberWithInt:[set intForColumnIndex:0]];
            ;
            project.projectName = [set stringForColumnIndex:1];
            if ([set intForColumnIndex:2]) {
                project.projectType = YES;
            }else{
                project.projectType = NO;
            }
            project.creatorID = [NSNumber numberWithInt:[set intForColumnIndex:3]];
            
            NSString *query2 = [NSString stringWithFormat:@"SELECT * FROM RSSMissions WHERE projectid = %d",[project.projectID intValue]];
            FMResultSet *missionSet = [dataBase executeQuery:query2];
            NSInteger numofMission = 0;
            NSInteger numofCompletedMission = 0;
            while ([missionSet next]) {
                numofMission = numofMission + 1;
                BOOL isCompleted = [missionSet boolForColumn:@"iscompleted"];
                if (isCompleted == YES) {
                    numofCompletedMission = numofCompletedMission + 1;
                }
            }
            project.completedMissionNum = numofCompletedMission;
            project.sumofMission = numofMission;
            [self.dataArr addObject:project];
        }
    }
    [dataBase close];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num;
    num = self.dataArr.count;
    //改变tableHeaderView中的项目数
    if ([(HomeTableViewHeaderView *)self.tableView.tableHeaderView respondsToSelector:@selector(refreshNumberInLabel:)]) {
        [(HomeTableViewHeaderView *)self.tableView.tableHeaderView refreshNumberInLabel:num];
    }
    
    return num;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell"];
    [cell layoutIfNeeded];
    if (cell == nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeCell"];
    }
    RSSProject *project = [self.dataArr objectAtIndex:indexPath.row];
    cell.title.text = project.projectName;
    if (project.projectType) {
        cell.subTitle.text = @"公共";
    }else{
        cell.subTitle.text = @"私有";
    }
//    [cell.iconView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"project%li",indexPath.row%2+1]]];
    cell.iconView.layer.cornerRadius = 10.0f;
    cell.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"project%li",indexPath.row%2+1]];
    
    cell.progress.text = [NSString stringWithFormat:@"已完成 %li/%li ",(long)project.completedMissionNum,(long)project.sumofMission];
    //取消选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.hidesBottomBarWhenPushed = YES;
    
    ProjectDetailViewController *detailVC = [[ProjectDetailViewController alloc] init];
    detailVC.title = ((RSSProject *)[self.dataArr objectAtIndex:indexPath.row]).projectName;
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.projectModel = [self.dataArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
}


-(NSString *)getDBPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *DBPath = [documentPath stringByAppendingPathComponent:@"RSS.db"];//RSS数据库
    return DBPath;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
