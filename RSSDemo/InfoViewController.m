//
//  InfoViewController.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/4/11.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "InfoViewController.h"
#import "InfoTableViewCell.h"
#import <FMDB.h>
#import "RSSMission.h"
#import "RSSUser.h"
#import "InfoMission.h"

@interface InfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataforTable;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataforTable = [NSMutableArray array];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView = [[UITableView alloc ] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.rowHeight = 70;
    self.tableView.scrollEnabled = NO;
    
    self.tableView.dataSource = self;
    self.tableView.delegate  =self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of anythat can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataforTable.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero] ;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor lightGrayColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont systemFontOfSize:14 weight:0.1];
    headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
    
    headerLabel.text = @"将要截止的任务";
    
    [customView addSubview:headerLabel];
    
    return customView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InfoTableViewCell *cell = [[InfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    InfoMission *missionModel  = [self.dataforTable objectAtIndex:indexPath.row];
    cell.missionName.text = missionModel.missionName;
    cell.deadline.text = missionModel.deadline;
    cell.fromProject.text = [NSString stringWithFormat:@"来自项目%@",missionModel.projectName];
    
    return cell;
}


-(void)refresh{
    [self.dataforTable removeAllObjects];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
        if ([dataBase open]) {
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            
                NSString *query1 = [NSString stringWithFormat:@"SELECT * FROM RSSMissions WHERE executorid = %@",[[defaults valueForKey:@"currentUserID"] stringValue]];
                
                FMResultSet *set = [dataBase executeQuery:query1];
                while ([set next]) {
                    NSLog(@"%@",set);
                    InfoMission *missionModel = [[InfoMission alloc] init];
                    
                    missionModel.missionID =[NSNumber numberWithInt:[set intForColumn:@"id"]];
                    missionModel.missionName = [set stringForColumn:@"missionname"];
                    missionModel.deadline = [set stringForColumn:@"deadline"];
                    missionModel.executorID = [NSNumber numberWithInt:[set intForColumn:@"executorid"]];
                    missionModel.projectID = [NSNumber numberWithInt:[set intForColumn:@"projectid"]];
                    if ([set intForColumn:@"iscompleted"] == 0) {
                        missionModel.isCompleted = NO;
                    }else{
                        missionModel.isCompleted = YES;
                    }
                    
                    NSString *query2 = [NSString stringWithFormat:@"SELECT * FROM RSSProjectList WHERE id = %@",missionModel.projectID];
                    FMResultSet *projectSet = [dataBase executeQuery:query2];
                    while ([projectSet next]) {
                        missionModel.projectName = [projectSet stringForColumn:@"projectname"];
                    }
                    
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd aa KK:mm"];
                    NSDate *date = [dateFormatter dateFromString:missionModel.deadline];
                        if ([self isDateBeforeDeadline:date] && missionModel.isCompleted == NO) {
                            [self.dataforTable addObject:missionModel];
                        }

                }
                
            
            [dataBase close];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
        
    });
    
    
}

- (BOOL)isDateBeforeDeadline:(NSDate *) date{
    
    
    //最大日期最小日期
    NSDate *dateBeforedeadline = [NSDate dateWithTimeInterval:-(24*60*60) sinceDate:[NSDate date]];
    
    NSDate *today = [NSDate date];
    
    if ([today compare:dateBeforedeadline]==NSOrderedDescending && [today compare:date]==NSOrderedAscending)
    {
        return YES;
    }
    return NO;
    
    
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
