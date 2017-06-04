//
//  ProjectFileView.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/2.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "ProjectFileView.h"
#import "ProjectFileTableViewCell.h"
#import <FMDB.h>
#import <Photos/Photos.h>
#import <MJRefresh.h>
#import "RSSImage.h"
#import "ProjectDetailViewController.h"
#import "BroswerViewController.h"

static NSString *cellID = @"fileCell";

@interface ProjectFileView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArr;



-(NSString *)getDBPath;
@end

@implementation ProjectFileView

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
    self.tableView.rowHeight = 50.0f;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(dragRefresh)];
    
    [self addSubview:self.tableView];
    
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataArr.count;
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProjectFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ProjectFileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.moreBtn.tag = indexPath.row + 1;
    [cell.moreBtn addTarget:self action:@selector(deleteImageAction:) forControlEvents:UIControlEventTouchUpInside];
    RSSImage *img = [self.dataArr objectAtIndex:indexPath.row];
    NSData *dataBaseImgData = img.imgData;
    
    UIImage *image = [UIImage imageWithData:dataBaseImgData];
    
    [cell.imageView setImage:image];
    
    return cell;
}

-(void)deleteImageAction:(UIButton *) sender{
    NSLog(@"!!!!!!!!!");
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:1 handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:2 handler:^(UIAlertAction * _Nonnull action) {
        FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
        if ([dataBase open]) {
            RSSImage *imageModel = [[RSSImage alloc] init];
            imageModel = [self.dataArr objectAtIndex:sender.tag - 1];
            NSString *query = [NSString stringWithFormat:@"DELETE FROM RSSFile WHERE id = %d",[imageModel.imgID intValue]];
            BOOL result =  [dataBase executeUpdate:query];
            if (result) {
                NSLog(@"删除图片成功");
            }
            [dataBase close];
            [self.tableView.mj_header beginRefreshing];
        }
    }];
    [alertC addAction:cancelAction];
    [alertC addAction:deleteAction];
    
    UIViewController* vc = [[UIViewController alloc] init];
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[ProjectDetailViewController class]]) {
            vc = (UIViewController*)nextResponder;
        }
    }
    [vc.navigationController presentViewController:alertC animated:YES completion:^{
    }];
}

-(void)refresh{
    [self.dataArr removeAllObjects];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
    if ([dataBase open]) {
        int projectid = [self.projectModel.projectID intValue];
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM RSSFile WHERE projectid = %d",projectid];
        
        FMResultSet *set = [dataBase executeQuery:query];
        while ([set next]) {
            
            RSSImage *img = [[RSSImage alloc] init];
            NSData *dataBaseImgData = [set dataForColumnIndex:2];
            
            
            img.imgData = dataBaseImgData;
            img.imgID =[NSNumber numberWithInt:[set intForColumnIndex:0]];
            [self.dataArr addObject:img];
        }
    }
    [dataBase close];
    [self.tableView reloadData];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BroswerViewController *broswerViewController = [[BroswerViewController alloc] init];
    RSSImage *img = [self.dataArr objectAtIndex:indexPath.row];
    NSData *dataBaseImgData = img.imgData;
    UIImage *image = [UIImage imageWithData:dataBaseImgData];
    broswerViewController.image = image;
    id responder = self.nextResponder;
    while (![responder isKindOfClass: [UIViewController class]] && ![responder isKindOfClass: [UIWindow class]])
    {
        responder = [responder nextResponder];
    }
    if ([responder isKindOfClass: [UIViewController class]])
    {
        [responder presentViewController:broswerViewController animated:YES completion:nil];
    }
}

-(void)dragRefresh{
    [self refresh];
    [self.tableView.mj_header endRefreshing];
}


-(NSString *)getDBPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *DBPath = [documentPath stringByAppendingPathComponent:@"RSS.db"];//RSS数据库
    return DBPath;
}

@end

