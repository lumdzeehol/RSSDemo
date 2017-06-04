//
//  ProjectDetailViewController.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/2.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "ProjectDetailViewController.h"
#import <FMDB.h>
#import "ProjectFileView.h"
#import "MissionView.h"
#import <MJRefresh.h>
#import "CreateMissionViewController.h"

@interface ProjectDetailViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) UIButton *btn1;

@property (nonatomic,strong) UIButton *btn2;

@property (nonatomic,strong) ProjectFileView *fileView;

@property (nonatomic,strong) MissionView *missionView;

@property (nonatomic,strong) UIBarButtonItem *addBtn;

@property (nonatomic,assign) NSInteger indexofSelectedView;



@end

@implementation ProjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIBarButtonItem *moreBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addAction)];
    self.navigationItem.rightBarButtonItems = @[moreBtn,addBtn];
    
    UILabel *creatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-10, 30)];
    
    creatorLabel.font = [UIFont systemFontOfSize:16 weight:0.5];
    [creatorLabel setTextColor:[UIColor lightGrayColor]];
    
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
    
    if ([dataBase open]) {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM RSSUsers WHERE id = %d",[self.projectModel.creatorID intValue]];
        FMResultSet *set=[dataBase executeQuery:query];
        while ([set next]) {
            creatorLabel.text = [NSString stringWithFormat:@"该项目由 %@ 创建",[set stringForColumn: @"usernickname"]];
            
        }
    }
    
    
    creatorLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:creatorLabel];
    
    UIView *segControl = [[UIView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 50)];
//    segControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    segControl.backgroundColor = [UIColor whiteColor];
    segControl.layer.shadowOffset = CGSizeMake(0, 0.2f);
    segControl.layer.shadowOpacity = 0.1f;
    segControl.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2.0f, 50)];
    self.btn2 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0f, 0, self.view.frame.size.width/2.0f, 50)];
    self.btn1.tag = 1;
    self.btn2.tag = 2;
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0f, 5, 1, 40)];
    midView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.btn1 setTitle:@"任务" forState:UIControlStateNormal];
    [self.btn2 setTitle:@"文件" forState:UIControlStateNormal];
    
    
    [self.btn1 setTitleColor:[UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1.00] forState:UIControlStateNormal];
    [self.btn2 setTitleColor:[UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1.00] forState:UIControlStateNormal];
    
    [self.btn1 setTitleColor:THEME_COLOR forState:UIControlStateSelected];
    [self.btn2 setTitleColor:THEME_COLOR forState:UIControlStateSelected];
    
    self.btn1.titleLabel.font = [UIFont systemFontOfSize:16];
    self.btn2.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.btn1 addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn2 addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [segControl addSubview:self.btn1];
    [segControl addSubview:self.btn2];
    [segControl addSubview:midView];
    [self.view addSubview:segControl];
    
    self.fileView = [[ProjectFileView alloc] initWithFrame:CGRectMake(0, 85, self.view.frame.size.width, self.view.frame.size.height - 55 )];
    self.fileView.projectModel = self.projectModel;
    self.missionView = [[MissionView alloc] initWithFrame:CGRectMake(0, 85, self.view.frame.size.width, self.view.frame.size.height - 55 )];
    self.missionView.projectModel = self.projectModel;
    
    [self.view addSubview:self.missionView];
    [self.view addSubview:self.fileView];
    self.fileView.hidden = YES;
    self.btn1.selected = YES;
    self.indexofSelectedView = 0;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.missionView refresh];
    [self.fileView refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)moreAction{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除项目" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
        if ([dataBase open]) {
            NSString *queryProject = [NSString stringWithFormat:@"DELETE FROM RSSProjectList WHERE id = %d",[self.projectModel.projectID intValue]];
            NSString *queryMission = [NSString stringWithFormat:@"DELETE FROM RSSMissions WHERE projectid = %d",[self.projectModel.projectID intValue]];
            NSString *queryFile = [NSString stringWithFormat:@"DELETE FROM RSSFile WHERE projectid = %d",[self.projectModel.projectID intValue]];
            BOOL result1 = [dataBase executeUpdate:queryProject];
            BOOL result2 = [dataBase executeUpdate:queryMission];
            BOOL result3 = [dataBase executeUpdate:queryFile];
            if (result1 && result2 && result3) {
                NSLog(@"删除项目成功");
            }
        }
        [dataBase close];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alertC addAction:deleteAction];
    [alertC addAction:cancelAction];
    
    [self presentViewController:alertC animated:YES completion:nil];
}

-(void)addAction{
    if (self.indexofSelectedView == 1) {
        UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
        
        pickerC.delegate = self;
//        pickerC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerC.allowsEditing = NO;

        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:0 handler:^(UIAlertAction * _Nonnull action) {
            pickerC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self.navigationController presentViewController:pickerC animated:YES completion:^{
            }];
        }];
        UIAlertAction *camAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            pickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.navigationController presentViewController:pickerC animated:YES completion:^{
            }];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alertC addAction:albumAction];
        [alertC addAction:camAction];
        [alertC addAction:cancelAction];

        [self.navigationController presentViewController:alertC animated:YES completion:nil];
        
    }else{
        
        CreateMissionViewController *createMissionVC = [[CreateMissionViewController alloc] init];
//        createMissionVC.projectModel = self.projectModel;
        RSSProject *project = self.projectModel;
        [createMissionVC.dataDict setObject:project forKey:@"project"];
        RSSProject *project2 = [createMissionVC.dataDict objectForKey:@"project"];
        NSLog(@"finish setobject %@",project2.projectName);
        createMissionVC.projectModel = project;
        UINavigationController *createNav = [[UINavigationController alloc] initWithRootViewController:createMissionVC];
        
        [self presentViewController:createNav animated:YES completion:^{
            [createMissionVC.tableView reloadData];
            createMissionVC.setProject = YES;
        }];
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"%@",info);
    
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    NSData *imgData = UIImagePNGRepresentation(img);
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
    if ([dataBase open]) {
        int projectid = [self.projectModel.projectID intValue];
        
        NSString *query = @"INSERT INTO RSSFile VALUES (NULL,?,?)";

        BOOL result =  [dataBase executeUpdate:query,[NSString stringWithFormat:@"%d",projectid],imgData];
        if (result) {
            NSLog(@"插入图片成功");
        }
    }
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
    
    
}

-(NSString *)getDBPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *DBPath = [documentPath stringByAppendingPathComponent:@"RSS.db"];//RSS数据库
    return DBPath;
}


-(void)clickBtnAction:(UIButton *) sender{
    NSLog(@"click!!!!");
    sender.selected = YES;
    if (sender.tag == 1) {
        self.btn2.selected = NO;
        self.missionView.hidden = NO;
        self.fileView.hidden = YES;
        self.indexofSelectedView = 0;
        [self.missionView.tableView.mj_header beginRefreshing];
    }else{
        self.btn1.selected = NO;
        self.missionView.hidden = YES;
        self.fileView.hidden = NO;
        self.indexofSelectedView = 1;
        [self.fileView.tableView.mj_header beginRefreshing];
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
