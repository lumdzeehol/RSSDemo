//
//  ViewController.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/3/19.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "ViewController.h"
#import "HomeTableViewCell.h"
#import "HomeTableViewHeaderView.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
 
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, self.view.frame.size.height -48-64) style:UITableViewStylePlain];
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 48, 0);
    self.tableView.rowHeight = 100;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
//    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 40)];
    HomeTableViewHeaderView *header = [[HomeTableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 40)];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
