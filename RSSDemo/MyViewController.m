//
//  MyViewController.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/3/25.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "MyViewController.h"
#import "MyTableViewCell.h"
#import "MySegmentControlView.h"
#import "MyNavigationBar.h"
#import "SignViewController.h"
#import "HomeViewController.h"
#import "MySegmentControlView.h"
#import <Photos/Photos.h>
#import "CreateMissionViewController.h"
#import <FMDB.h>
#import "RSSUser.h"
#import <MJRefresh.h>
#import "MissionDetailViewController.h"


#define BTN_NUM 4
#define SEGCONTROL_HEIGHT 34


static const CGFloat padding = 50.0f;
static const CGFloat margin = 5.0f;
static NSString *cellID = @"cell";


@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) MySegmentControlView *segControl;

@property (nonatomic,strong) UITableView *tableView;

//@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSMutableArray *dataforTable;

@property (nonatomic,strong) UIImageView *userIcon;

@property (nonatomic,strong) UILabel *userNameLabel;

@property (nonatomic,assign) NSInteger selectedButtonIndex;

@property (nonatomic,strong) RSSUser *currentUser;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int userid = [[defaults objectForKey:@"currentUserID"] intValue];
    
    RSSUser *currentUser = [[RSSUser alloc] init];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
    if ([dataBase open]) {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM RSSUsers WHERE id = %d",userid];
        FMResultSet *set  = [dataBase executeQuery:query];
        while ([set next]) {
            currentUser.userID = [NSNumber numberWithInt:userid];
            currentUser.userNickName = [set stringForColumn:@"usernickname"];
            UIImage *avatar = [UIImage imageWithData:[set dataForColumn:@"avatar"]];
            currentUser.avatar = avatar;
        }
    }
    
    self.userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 34, 34)];
    
    self.userIcon.image = currentUser.avatar;
    self.userIcon.layer.cornerRadius = 17.0f;
    self.userIcon.layer.masksToBounds = YES;
    

    self.userIcon.contentMode = UIViewContentModeScaleAspectFill;
    
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 5, 100, 34)];
    self.userNameLabel.font = [UIFont systemFontOfSize:16];
    self.userNameLabel.text = currentUser.userNickName;
    
    UIView *userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [userInfoView addSubview:self.userIcon];
    [userInfoView addSubview:self.userNameLabel];
    
    UIBarButtonItem *userInfo = [[UIBarButtonItem alloc] initWithCustomView:userInfoView];
    self.navigationItem.leftBarButtonItem = userInfo;
    self.navigationItem.title = @"";
    
//    self.dataArr = [NSMutableArray array];
    
    
    self.dataforTable = [NSMutableArray array];

    
    NSArray *titleArray = [NSArray arrayWithObjects:@"最近",@"任务",@"未完成",@"项目", nil];

    self.segControl = [[MySegmentControlView alloc] initWithTitles:titleArray];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    
//    [self.navigationController setValue:bar forKey:@"navigationBar"];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 34, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //设置数据源和代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(dragRefresh)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    
    self.selectedButtonIndex = 0;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.segControl];
    [self.segControl.btn1 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.segControl.btn2 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.segControl.btn3 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.segControl.btn4 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int userid = [[defaults objectForKey:@"currentUserID"] intValue];
    

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
        if ([dataBase open]) {
            self.currentUser = [[RSSUser alloc ] init];
            NSString *query = [NSString stringWithFormat:@"SELECT * FROM RSSUsers WHERE id = %d",userid];
            FMResultSet *set  = [dataBase executeQuery:query];
            while ([set next]) {
                self.currentUser.userID = [NSNumber numberWithInt:userid];
                self.currentUser.userNickName = [set stringForColumn:@"usernickname"];
                UIImage *avatar = [UIImage imageWithData:[set dataForColumn:@"avatar"]];
                self.currentUser.avatar = avatar;
            }
        }
        [dataBase close];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.userIcon.image = self.currentUser.avatar;
            self.userNameLabel.text = self.currentUser.userNickName;
        }); 
        
    });
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    return self.dataforTable.count;
    return self.dataforTable.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74.0f;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    RSSMission *missionModel = [self.dataforTable objectAtIndex:indexPath.row];
    cell.title.text = missionModel.missionName;
    NSString *deadline = missionModel.deadline;
    
    cell.checkBox.tag = indexPath.row+1;
    
    NSArray *StrArr = [deadline componentsSeparatedByString:@"-"];
    NSString *deadlineStr=  [NSString stringWithFormat:@"%@-%@  截止",[StrArr objectAtIndex:1],[StrArr objectAtIndex:2]];
    
    cell.subTitle.text = deadlineStr;
    
    if (missionModel.isCompleted) {
        cell.checked = YES;
        
    }else{
        cell.checked = NO;
    }
    cell.checkBox.selected = cell.checked;
    [cell.checkBox addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    if (cell.checkBox.selected) {
        [cell.title setTextColor:[UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.00]];
    }else{
        [cell.title setTextColor:[UIColor blackColor]];
    }
    
    return cell;

}

-(void)click:(UIButton *) sender{
    
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
    
    if ([dataBase open]) {
        NSString *query = @"UPDATE RSSMissions SET iscompleted = ? WHERE id = ?";
        
        //    if (sender.selected) {
        //        [sender setSelected:NO];
        //        sender.checked = NO;
        //    }else{
        //        [sender setSelected:YES];
        //        self.checked = YES;
        //    }
        RSSMission *missionModel = [self.dataforTable objectAtIndex:sender.tag - 1];
        BOOL result = [dataBase executeUpdate:query,sender.selected?@"0":@"1",[NSString stringWithFormat:@"%d",[missionModel.missionID intValue]]];
        if (result) {
            NSLog(@"set iscompleted 成功");
        }
    }
    [dataBase close];
    
    
    [self refresh];
    
    NSLog(@"!!!");
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MissionDetailViewController * detailVC = [[MissionDetailViewController alloc] init];
    RSSMission *missionModel = [self.dataforTable objectAtIndex:indexPath.row];
    detailVC.missionID = missionModel.missionID;
    detailVC.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)clickAction:(UIButton *)sender{

    CGFloat btnWidth = ([UIScreen mainScreen].bounds.size.width - padding * 2 -(BTN_NUM - 1) * margin) / BTN_NUM;
    CGSize size = CGSizeMake(btnWidth, 30);
    
    
    [self.segControl.blockView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo([NSValue valueWithCGSize:size]);
        make.left.equalTo(sender.mas_left);
        make.top.equalTo(self.segControl.mas_top).with.offset(2);
    }];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.segControl layoutIfNeeded]; //给选中效果移动加入动画效果
        
        [self.segControl.btn1 setTitleColor:[UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1.00] forState:UIControlStateNormal];
        [self.segControl.btn2 setTitleColor:[UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1.00] forState:UIControlStateNormal];
        [self.segControl.btn3 setTitleColor:[UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1.00] forState:UIControlStateNormal];
        [self.segControl.btn4 setTitleColor:[UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1.00] forState:UIControlStateNormal];
        
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }];
    NSLog(@"run click");
    [self.dataforTable removeAllObjects];
//    [self.dataforTable addObjectsFromArray:[self.dataArr objectAtIndex:sender.tag-1]];
    self.selectedButtonIndex = sender.tag - 1 ;
    [self refresh];
    
    
}

-(void)dragRefresh{
    [self refresh];
    [self.tableView.mj_header endRefreshing];
}


-(void)refresh{
    [self.dataforTable removeAllObjects];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
        if ([dataBase open]) {

            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            
            if (self.selectedButtonIndex != 3) {
                NSString *query1 = [NSString stringWithFormat:@"SELECT * FROM RSSMissions WHERE executorid = %@",[[defaults valueForKey:@"currentUserID"] stringValue]];
                
                FMResultSet *set = [dataBase executeQuery:query1];
                while ([set next]) {
                    NSLog(@"%@",set);
                    RSSMission *missionModel = [[RSSMission alloc] init];
                    
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
                    
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd aa KK:mm"];
                    NSDate *date = [dateFormatter dateFromString:missionModel.deadline];
                    if (self.selectedButtonIndex == 0) {
                        if ([self isDateBetweenYesterdayAndTomorrow:date]) {
                            [self.dataforTable addObject:missionModel];
                        }
                    }else if (self.selectedButtonIndex == 1){
                        [self.dataforTable addObject:missionModel];
                    }else if (self.selectedButtonIndex == 2){
                        if (missionModel.isCompleted == NO) {
                            [self.dataforTable addObject:missionModel];
                        }
                    }
                }
                
            }else{
                NSString *query = [NSString stringWithFormat:@"SELECT * FROM RSSProjectList WHERE creatorID = %@",[[defaults valueForKey:@"currentUserID"] stringValue]];
                FMResultSet *set = [dataBase executeQuery:query];
                while ([set next]) {
                    int projectid = [set intForColumn:@"id"];
                    NSString *queryMission = [NSString stringWithFormat:@"SELECT * FROM RSSMissions WHERE projectid = %d",projectid];
                    NSLog(@"%@",queryMission);
                    FMResultSet *missionSet = [dataBase executeQuery:queryMission];
                    while ([missionSet next]) {
                        RSSMission *missionModel = [[RSSMission alloc] init];
                        missionModel.missionID =[NSNumber numberWithInt:[missionSet intForColumn:@"id"]];
                        missionModel.missionName = [missionSet stringForColumn:@"missionname"];
//                        missionModel.missionName = [set stringForColumnIndex:2];
                        missionModel.deadline = [missionSet stringForColumn:@"deadline"];
                        missionModel.executorID = [NSNumber numberWithInt:[missionSet intForColumn:@"executorid"]];
                        missionModel.projectID = [NSNumber numberWithInt:[missionSet intForColumn:@"projectid"]];
                        if ([missionSet intForColumn:@"iscompleted"] == 0) {
                            missionModel.isCompleted = NO;
                        }else{
                            missionModel.isCompleted = YES;
                        }
                        
                        
                        [self.dataforTable addObject:missionModel];
                    }
                }
            }
            
            [dataBase close];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
        
    });


    
}

- (BOOL)isDateBetweenYesterdayAndTomorrow:(NSDate *) date{
    
    
    //最大日期最小日期
    NSDate *dateMinus = [NSDate dateWithTimeInterval:-(24*60*60) sinceDate:[NSDate date]];
    NSDate *datePlus = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]];
    
    
    if ([date compare:dateMinus]==NSOrderedDescending && [date compare:datePlus]==NSOrderedAscending)
    {
        NSLog(@"该时间在 :00-:00 之间！");
        return YES;
    }
    return NO;
   
    
}


- (NSDate *)getCustomDateWithDay:(NSInteger) day Hour:(NSInteger)hour Minute:(NSInteger) minute
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:day];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSLog(@"%@",[resultCalendar dateFromComponents:resultComps]);
    return [resultCalendar dateFromComponents:resultComps];
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
