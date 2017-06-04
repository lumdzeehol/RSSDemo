//
//  NameChangeViewController.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/18.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "NameChangeViewController.h"
#import <FMDB.h>

@interface NameChangeViewController ()

@property (nonatomic,strong) UITextField *nameField;
@property (nonatomic,strong) UIBarButtonItem *doneBtn;

@end

@implementation NameChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 50)];
    [self.view addSubview:self.nameField];
    self.nameField.text = self.name;
    self.nameField.backgroundColor = [UIColor whiteColor];
    
    self.doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStyleDone target:self action:@selector(changeName)];
    self.navigationItem.rightBarButtonItem = self.doneBtn;
    self.doneBtn.enabled = NO;
    [self.nameField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textChanged{
    self.doneBtn.enabled = YES;
}

-(void)changeName{
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int userid = [[defaults valueForKey:@"currentUserID"] intValue];
    
    if ([dataBase open]) {
        
        NSString *query = [NSString stringWithFormat: @"UPDATE RSSUsers SET usernickname = '%@' WHERE id = %d",self.nameField.text,userid];
        BOOL result = [dataBase executeUpdate:query];
        if (result == YES) {
            NSLog(@"更改名称成功");
        }
        
    }
    [dataBase close];
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate didChangeName];
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
