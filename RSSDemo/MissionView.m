//
//  ProjectFileView.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/2.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "MissionView.h"
#import <FMDB.h>
#import <MJRefresh.h>
#import "RSSMission.h"
#import "ProjectDetailViewController.h"
#import "MyTableViewCell.h"
#import "MissionDetailViewController.h"

static NSString *cellID = @"missionCell";

@interface MissionView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArr;

-(NSString *)getDBPath;
@end

@implementation MissionView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    self.dataArr = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 74.0f;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(dragRefresh)];
    
    [self addSubview:self.tableView];
    
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return self;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    RSSMission *missionModel = [self.dataArr objectAtIndex:indexPath.row];
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


//-(void)deleteImageAction:(UIButton *) sender{
//    NSLog(@"!!!!!!!!!");
//    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:1 handler:^(UIAlertAction * _Nonnull action) {
//    }];
//    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:2 handler:^(UIAlertAction * _Nonnull action) {
//        FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
//        if ([dataBase open]) {
//            RSSImage *imageModel = [[RSSImage alloc] init];
//            imageModel = [self.dataArr objectAtIndex:sender.tag - 1];
//            NSString *query = [NSString stringWithFormat:@"DELETE FROM RSSMissions WHERE id = %d",[imageModel.imgID intValue]];
//            BOOL result =  [dataBase executeUpdate:query];
//            if (result) {
//                NSLog(@"删除任务成功");
//            }
//            [dataBase close];
//            [self.tableView.mj_header beginRefreshing];
//        }
//    }];
//    [alertC addAction:cancelAction];
//    [alertC addAction:deleteAction];
//    
//    UIViewController* vc = [[UIViewController alloc] init];
//    for (UIView* next = [self superview]; next; next = next.superview) {
//        UIResponder* nextResponder = [next nextResponder];
//        if ([nextResponder isKindOfClass:[ProjectDetailViewController class]]) {
//            vc = (UIViewController*)nextResponder;
//        }
//    }
//    [vc.navigationController presentViewController:alertC animated:YES completion:^{
//    }];
//}

-(void)refresh{
    
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
    if ([dataBase open]) {
        [self.dataArr removeAllObjects];
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM RSSMissions WHERE projectid = %d",[self.projectModel.projectID intValue]];
 
        FMResultSet *set = [dataBase executeQuery:query];
        while ([set next]) {
            RSSMission *missionModel = [[RSSMission alloc] init];
            missionModel.missionID =[NSNumber numberWithInt: [set intForColumn:@"id"]];
            missionModel.missionName = [set stringForColumn:@"missionname"];
            missionModel.deadline = [set stringForColumn:@"deadline"];
            missionModel.executorID = [NSNumber numberWithInt:[set intForColumn:@"executorid"]];
            missionModel.projectID = [NSNumber numberWithInt:[set intForColumn:@"projectid"]];
            if ([set intForColumn:@"iscompleted"] == 0) {
                missionModel.isCompleted = NO;
            }else{
                missionModel.isCompleted = YES;
            }
            [self.dataArr addObject:missionModel];
        }
        
    }
    
    [dataBase close];
    [self.tableView reloadData];
    
}

-(void)dragRefresh{
    [self refresh];
    [self.tableView.mj_header endRefreshing];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MissionDetailViewController * detailVC = [[MissionDetailViewController alloc] init];
    RSSMission *missionModel = [self.dataArr objectAtIndex:indexPath.row];
    detailVC.missionID = missionModel.missionID;
    
    UIViewController* vc = [[UIViewController alloc] init];
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[ProjectDetailViewController class]]) {
            vc = (UIViewController*)nextResponder;
        }
    }
//    if([vc.navigationController.topViewController isKindOfClass:[ProjectDetailViewController class]]) {
        [vc.navigationController pushViewController:detailVC animated:YES];
//    }

}

-(NSString *)getDBPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *DBPath = [documentPath stringByAppendingPathComponent:@"RSS.db"];//RSS数据库
    return DBPath;
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
        RSSMission *missionModel = [self.dataArr objectAtIndex:sender.tag - 1];
        BOOL result = [dataBase executeUpdate:query,sender.selected?@"0":@"1",[NSString stringWithFormat:@"%d",[missionModel.missionID intValue]]];
        if (result) {
            NSLog(@"set iscompleted 成功");
        }
    }
    [dataBase close];
    
    
    [self refresh];
}

@end

