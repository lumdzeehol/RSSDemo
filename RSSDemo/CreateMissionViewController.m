//
//  CreateMissionViewController.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/2.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "CreateMissionViewController.h"
#import <FMDB.h>



@interface CreateMissionViewController ()<UITableViewDataSource,UITableViewDelegate,RSSCreateMissionUserDelegate,RSSCreateMissionDateDelegate,RSSCreateMissionProjectDelegate>

@end

@implementation CreateMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.setName = NO;
    self.setExecutor = NO;
    self.setDeadline = NO;
    self.setProject = NO;
    
    self.dataDict  = [NSMutableDictionary dictionary];
    
    self.missionModel = [[RSSMission alloc] init];
    self.executorModel = [[RSSUser alloc] init];
    
    self.executorModel.userNickName = @"设置执行者";
    
    self.deadline = [[NSDate alloc] init];
//    [self.dataDict setObject:self.projectModel forKey:@"project"];
//    NSLog(@"%@",self.projectModel.projectName );
    [self.dataDict setObject:self.executorModel forKey:@"executor"];
    
    
    UINavigationBar * navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationBar.translucent = NO;
    navigationBar.tintColor = THEME_COLOR;
    
    UIBarButtonItem *dismissBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction)];
    self.doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction:)];
    self.doneBtn.enabled = NO;
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    item.leftBarButtonItem =dismissBtn;
    item.rightBarButtonItem = self.doneBtn;
    item.title = @"新任务";
    
    self.missionName = [[UITextField alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50)];
    self.missionName.backgroundColor = [UIColor whiteColor];
    self.missionName.placeholder = @"任务名称";
    
    [self.missionName addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 114, self.view.frame.size.width, 500) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    [navigationBar pushNavigationItem:item animated:YES];
    
    [self.view addSubview:self.missionName];
    [self.view addSubview:self.tableView];
    [self.view addSubview:navigationBar];

    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissAction{
    [self dismissViewControllerAnimated:self completion:nil];
}

-(void)doneAction:(UIButton *) sender{
    
    NSDate *date = [self.dataDict objectForKey:@"deadline"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd aa KK:mm"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSString *projectid = [NSString stringWithFormat:@"%@" ,self.projectModel.projectID];
    
    NSString *executorid = [NSString stringWithFormat:@"%@",((RSSUser *)[self.dataDict objectForKey:@"executor"]).userID];
    
    NSString *isCompleted = @"0";
    
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self  getDBPath]];
    if ([dataBase open]) {
        NSString *query= @"INSERT INTO RSSMissions VALUES (NULL,?,?,?,?,?)";
        BOOL result = [dataBase executeUpdate:query,self.missionName.text,dateString,projectid,executorid,isCompleted];
        if (result) {
            NSLog(@"添加任务成功");
        }
    }
    [dataBase close];
    [self dismissViewControllerAnimated:YES completion:^{
    }];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"保存至";
    }
    return @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    else
        return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            RSSUser *user = [self.dataDict objectForKey:@"executor"];
            cell.imageView.image = user.avatar;
            cell.textLabel.text  = user.userNickName;
        }
        else{
            if (![self.dataDict objectForKey:@"deadline"]) {
                cell.textLabel.text = @"设置截止时间";
            }else{
                NSDate *date = [self.dataDict objectForKey:@"deadline"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd aa KK:mm"];
                NSString *dateString = [dateFormatter stringFromDate:date];
                cell.textLabel.text = dateString;
            }
        }
    }else{
        if (indexPath.row == 0) {
            NSLog(@"finish display cell %@",self.projectModel.projectName);
//            RSSProject *project = [self.dataDict objectForKey:@"project"];
            RSSProject *project = self.projectModel;
            cell.textLabel.text = project.projectName;

        }
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSLog(@"!!!!");
        ChooseExecutorViewController *chooseEVC = [[ChooseExecutorViewController alloc] init];
            chooseEVC.delegate = self;
        [self.navigationController pushViewController:chooseEVC animated:YES];
        }else{
            ChooseDateViewController *chooseDVC = [[ChooseDateViewController alloc] init];
            chooseDVC.delegate = self;
            [self.navigationController pushViewController:chooseDVC animated:YES];
        }
    }else{
        ChooseProjectViewController *choosePVC = [[ChooseProjectViewController alloc] init];
        choosePVC.delegate = self;
        [self.navigationController pushViewController:choosePVC animated:YES ];
    }
    
    
}

-(NSString *)getDBPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *DBPath = [documentPath stringByAppendingPathComponent:@"RSS.db"];//RSS数据库
    return DBPath;
}

-(void)textChange{
    self.setName = YES;
    [self.tableView reloadData];
}

-(void)didSelectUser:(RSSUser *)user{
    [self.dataDict setObject:user forKey:@"executor"];
    self.setExecutor = YES;
    [self.tableView reloadData];
    [self doneChange];
}

-(void)didSelectDate:(NSDate *)date{
    [self.dataDict setObject:date forKey:@"deadline"];
    self.setDeadline = YES;
    [self.tableView reloadData];
    [self doneChange];
}

-(void)didSelectProject:(RSSProject *)project{
//    [self.dataDict setObject:project forKey:@"project"];
    self.projectModel = project;
    self.setProject = YES;
    [self.tableView reloadData];
    [self doneChange];
}

-(void)doneChange{
    if (self.setExecutor && self.setDeadline && self.setProject) {
        self.doneBtn.enabled = YES;
    }
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
