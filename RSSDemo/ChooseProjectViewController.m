//
//  ChooseProjectViewController.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/8.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "ChooseProjectViewController.h"
#import <FMDB.h>
#import "RSSProject.h"

@interface ChooseProjectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation ChooseProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.dataArr = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
    if ([dataBase open]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int userid = [[defaults objectForKey:@"currentUserID"] intValue];
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM RSSProjectList WHERE creatorID = %d OR projecttype = 1",userid];
        FMResultSet *set = [dataBase executeQuery:query];
        while ([set next]) {
            RSSProject *project = [[RSSProject alloc] init];
            project.projectID =[NSNumber numberWithInt: [set intForColumn:@"id"]];
            project.projectName = [set stringForColumn:@"projectname"];
            [self.dataArr addObject:project];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    RSSProject *project = [self.dataArr objectAtIndex:indexPath.row];
    cell.textLabel.text = project.projectName;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didSelectProject:[self.dataArr objectAtIndex:indexPath.row]];
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
