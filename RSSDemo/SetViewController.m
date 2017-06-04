//
//  SetViewController.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/5.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "SetViewController.h"
#import "LoginViewController.h"
#import <FMDB.h>
#import "NameChangeViewController.h"

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,NameChangeDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    [self refresh];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 230) style:UITableViewStyleGrouped];
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [ UIColor groupTableViewBackgroundColor];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2   ;
    }else{
        return 2;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"个人信息";}
//    }else{
//        return @"昵称";
else{
    return @"";
}
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"user"];
            cell.textLabel.text = [self.dataArr objectAtIndex:1];
        }else{
        UIImage *image = [UIImage imageWithData:[self.dataArr objectAtIndex:0]];
    
        CGSize itemSize = CGSizeMake(80, 80);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
        CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
        [image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        

        cell.imageView.layer.cornerRadius = 6;
        cell.imageView.clipsToBounds = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;}
    }else{
        if (indexPath.row == 0) {
        cell.textLabel.text = @"收藏";
        cell.imageView.image = [UIImage imageNamed:@"collection"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            cell.textLabel.text = @"提到我";
            cell.imageView.image = [UIImage imageNamed:@"at"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 90;
    }else{
        return 44;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
        UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
        
        pickerC.delegate = self;
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
            NameChangeViewController *nameChangeVC = [[NameChangeViewController alloc] init];
            nameChangeVC.name = [self.dataArr objectAtIndex:1];
            nameChangeVC.hidesBottomBarWhenPushed = YES;
            nameChangeVC.delegate = self;
            [self.navigationController pushViewController:nameChangeVC animated:YES];
        }
    }else{

    }
}

-(void)didChangeName{
    [self refresh];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *imgData = UIImagePNGRepresentation(img);
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
    if ([dataBase open]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int userid = [[defaults valueForKey:@"currentUserID"] intValue];
        NSString *query = [NSString stringWithFormat:@"UPDATE RSSUsers SET avatar = ? WHERE id = %d",userid];
        
        BOOL result = [dataBase executeUpdate:query,imgData];
        if (result == YES) {
            NSLog(@"更改头像成功");
        }
    }
    [dataBase close];
    
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self refresh];
    }];
    
}

-(void)refresh{
    [self.dataArr removeAllObjects];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int userid = [[defaults valueForKey:@"currentUserID"] intValue];
    if ([dataBase open]) {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM RSSUsers WHERE id = %d",userid];
        FMResultSet *set = [dataBase executeQuery:query];
        while ([set next]) {
            NSData *imgData = [set dataForColumn:@"avatar"];
            NSString *nickName = [set stringForColumn:@"usernickname"];
            
            [self.dataArr addObject:imgData];
            [self.dataArr addObject:nickName];
        }
    }
    [dataBase close];
    [self.tableView reloadData];
}



- (IBAction)logoutAction:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"currentUserID"];
    [defaults removeObjectForKey:@"isLogin"];
    
    UIViewController *VC = [[UIViewController alloc] init];

    if (![self.tabBarController.navigationController.viewControllers[0] isKindOfClass:[LoginViewController class]]) {

        LoginViewController *loginVC = [[LoginViewController alloc] init];

        NSMutableArray *vcArray = [NSMutableArray array];
        [vcArray addObject:loginVC];
        [vcArray addObjectsFromArray:self.tabBarController.navigationController.viewControllers];
        self.tabBarController.navigationController.viewControllers = vcArray;
    }
    VC = self.tabBarController.navigationController.viewControllers[0];
    
    [self.tabBarController.navigationController popToViewController:VC animated:YES];
    
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
