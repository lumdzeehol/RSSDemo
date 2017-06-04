//
//  CreateProjectViewController.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/4/25.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "CreateProjectViewController.h"
#import "AppDelegate.h"
#import <FMDB.h>
#import "RSSUser.h"

@interface CreateProjectViewController ()

@property (nonatomic,strong) UIBarButtonItem *doneBtn;

@property (nonatomic,strong) UITextField *projectName;

@property (nonatomic,strong) UIButton *projectTypeBtn;

@property (nonatomic,assign) BOOL projectType;// NO for 'private',YES for 'public'.Default is NO;

-(NSString *)getDBPath;

@end

@implementation CreateProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UINavigationBar * navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    
//
    navigationBar.translucent = NO;
    navigationBar.tintColor = THEME_COLOR;
    UIBarButtonItem *dismissBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction)];
    self.doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction:)];
    self.doneBtn.enabled = NO;
    
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"新项目"];

    navItem.leftBarButtonItem = dismissBtn;
    navItem.rightBarButtonItem = self.doneBtn;
    navItem.title = @"新项目";
    navItem.leftBarButtonItem = dismissBtn;
    navItem.rightBarButtonItem = self.doneBtn;
    
    [navigationBar pushNavigationItem:navItem animated:YES];
    
    
    self.projectName = [[UITextField alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 64)];
    
    
    self.projectName.placeholder = @"项目名称";
    self.projectName.borderStyle = UITextBorderStyleNone;
    self.projectName.backgroundColor = [UIColor whiteColor];
    self.projectName.font = [UIFont systemFontOfSize:18];
    
    [self.projectName addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
    //设置uitextfield左视图，使其光标起始位置右移
    self.projectName.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 64)];
    self.projectName.leftViewMode = UITextFieldViewModeAlways;

    self.projectName.layer.shadowColor = [UIColor blackColor].CGColor;
    self.projectName.layer.shadowOffset = CGSizeMake( 0 , 0.5);
    self.projectName.layer.shadowRadius = 0.5;
    self.projectName.layer.shadowOpacity = 0.1;

    
    self.projectTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 168, self.view.frame.size.width, 50)];
    [self.projectTypeBtn setTitle:@"私有" forState:UIControlStateNormal];
    [self.projectTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.projectTypeBtn addTarget:self action:@selector(chooseTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    self.projectTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.projectTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0 );
    self.projectTypeBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.projectName];
    [self.view addSubview:navigationBar];
    [self.view addSubview:self.projectTypeBtn];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)dismissAction{
    [self dismissViewControllerAnimated:self completion:nil];
}

-(void)doneAction:(UIButton *) sender{
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
    if ([dataBase open]) {
//        NSString *query = @"INSERT INTO Projects VALUES (NULL," @")";
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        int userid = [[defaults objectForKey:@"currentUserID"] intValue];
        
        NSString *query = [NSString stringWithFormat:@"INSERT INTO RSSProjectList VALUES (NULL,'%@',%d,%d)",self.projectName.text,self.projectType?1:0,userid];
        BOOL result = [dataBase executeUpdate:query];
        if (result ) {
            NSLog(@"插入数据成功");
        }
    }
    [dataBase close];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)chooseTypeAction:(UIButton *) sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"项目公开性" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *publicAction = [UIAlertAction actionWithTitle:@"公开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"公开" forState:UIControlStateNormal];
        self.projectType = YES;
        
    }];
    UIAlertAction *privateAction = [UIAlertAction actionWithTitle:@"私有" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"私有" forState:UIControlStateNormal];
        self.projectType = NO;
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:publicAction];
    [alertController addAction:privateAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)textChange:(UITextField *) textField{
    NSLog(@"run textchange");
    if (textField.text.length > 0) {
        self.doneBtn.enabled = YES;
    }else{
        self.doneBtn.enabled = NO;
    }
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
