//
//  ChooseExecutorViewController.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/2.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "ChooseExecutorViewController.h"
#import <FMDB.h>
#import "RSSMission.h"



@interface ChooseExecutorViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;


@property (nonatomic,strong) RSSUser *executorModel;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation ChooseExecutorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.dataArr = [NSMutableArray array];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
    if ([dataBase open]) {
        NSString *query = @"SELECT * FROM RSSUsers";
        FMResultSet *set = [dataBase executeQuery:query];
        while ([set next]) {
            RSSUser *user = [[RSSUser alloc] init];
            user.userID = [NSNumber numberWithInt:[set intForColumn:@"id"]];
            user.userNickName = [set stringForColumn:@"usernickname"];
            
            NSData *imgData = [set dataForColumn:@"avatar"];
            UIImage *img = [UIImage imageWithData:imgData];
            user.avatar = img;
            [self.dataArr addObject:user];
        }
    }
    [dataBase close];
    [self.view addSubview: self.tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    RSSUser *user = [self.dataArr objectAtIndex:indexPath.row];
    
    UIImage *avatar = user.avatar;
    if (avatar == nil) {
        avatar = [[UIImage alloc] init];
    }
    
    [cell.imageView setImage:avatar];
    cell.textLabel.text = user.userNickName;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didSelectUser:[self.dataArr objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
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
