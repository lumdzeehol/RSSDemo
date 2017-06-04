//
//  LoginViewController.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/4/17.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "LoginViewController.h"
#import "LDTabBarController.h"
#import "SignViewController.h"
#import <FMDB.h>
#import "RSSUser.h"

@interface LoginViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.passwordTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    self.passwordTextField.secureTextEntry = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.userTextField.text = @"";
    self.passwordTextField.text = @"";
}

- (IBAction)loginActino:(id)sender {
    NSLog(@"login!!");
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
    if ([dataBase open]) {
        NSLog(@"open!");
        
        FMResultSet *set = [dataBase executeQuery:[NSString stringWithFormat:@"SELECT * FROM RSSUsers WHERE username = '%@'",self.userTextField.text]];
        
        while([set next]) {
            
            if ([self.passwordTextField.text isEqualToString:[set stringForColumn:@"userpassword"]]) {
                
                RSSUser *user = [[RSSUser alloc] init];
                user.userID =[NSNumber numberWithInt: [set intForColumn:@"id"]];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:user.userID forKey:@"currentUserID"];
                [defaults setBool:YES forKey:@"isLogin"];
                LDTabBarController *ldTabBarVC = [[LDTabBarController alloc] init];
                [self.navigationController pushViewController:ldTabBarVC animated:YES];
            }else{
                NSLog(@"密码错误");
            }
        }

    }
    [dataBase close];
}
- (IBAction)signAction:(id)sender {
    
    SignViewController *signVC = [[SignViewController alloc] init];
    [self.navigationController pushViewController:signVC animated:YES];
    
}


-(void)textChange{
    if (self.userTextField.text.length > 0) {
        self.loginBtn.enabled = YES;
        self.loginBtn.backgroundColor = THEME_COLOR;
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
