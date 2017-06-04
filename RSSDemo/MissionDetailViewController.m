//
//  MissionDetailViewController.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/11.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "MissionDetailViewController.h"
#import <FMDB.h>

@interface MissionDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) RSSMission  *missionModel;

@property (nonatomic,strong) UIBarButtonItem *moreBtn ;

@end

@implementation MissionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 500) style:UITableViewStyleGrouped];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.scrollEnabled = NO;
    
    [self.view addSubview:self.tableView];
    
    self.moreBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
    self.navigationItem.rightBarButtonItem = self.moreBtn;
    
    [self refresh];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tabBarController.tabBar setHidden:YES];
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refresh{
    self.missionModel = [[RSSMission alloc] init];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
    if ([dataBase open]) {
        FMResultSet *set = [dataBase executeQuery:@"SELECT * FROM RSSMissions WHERE id = ?",[NSString stringWithFormat:@"%d",[self.missionID intValue]]];
        while ([set next]) {
            self.missionModel.missionID = [NSNumber numberWithInt: [set intForColumn:@"id"]];
            self.missionModel.missionName = [set stringForColumn:@"missionname"];
            self.missionModel.deadline = [set stringForColumn:@"deadline"];
            self.missionModel.projectID = [NSNumber numberWithInt:[set intForColumn:@"projectid"]];
        }
    }
    [dataBase close];
    [self.tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"任务名称";
    }else if (section == 1){
        return @"截止时间";
    }else{
        return @"所属项目";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"missioncell"];
    if (indexPath.section == 0) {
        cell.textLabel.text = self.missionModel.missionName;
    }else if (indexPath.section == 1){
        cell.textLabel.text = self.missionModel.deadline;
    }else{
        
        FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
        if ([dataBase open]) {
            NSString *query = @"SELECT * FROM RSSProjectList WHERE id = ?";
            FMResultSet *set = [dataBase executeQuery:query,[NSString stringWithFormat:@"%d",[self.missionModel.projectID intValue]]];
            while ([set next]) {
                cell.textLabel.text = [set stringForColumn:@"projectname"];
            }
        }
        
        [dataBase close];
    }
    return cell;
}


-(NSString *)getDBPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *DBPath = [documentPath stringByAppendingPathComponent:@"RSS.db"];//RSS数据库
    return DBPath;
}


-(void)moreAction{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction  =[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除任务" style:  UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
        if([dataBase open]){
            NSString *query = [NSString stringWithFormat:@"DELETE FROM RSSMissions WHERE id = %@",self.missionID];
            BOOL result = [dataBase executeUpdate:query];
            if (result) {
                NSLog(@"删除任务成功");
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
        [dataBase close];
    }];
    
    [alertC addAction:cancelAction];
    [alertC addAction:deleteAction];
    [self presentViewController:alertC animated:YES completion:nil];
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
