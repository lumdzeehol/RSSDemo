//
//  CreateFileViewController.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/18.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "CreateFileViewController.h"
#import "ChooseProjectViewController.h"
#import "RSSProject.h"
#import "RSSImage.h"
#import <FMDB.h>

@interface CreateFileViewController () <UITableViewDelegate,UITableViewDataSource,RSSCreateMissionProjectDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) RSSProject *projectModel;
@property (nonatomic,strong) RSSImage *imageModel;

@property (nonatomic,strong) UIBarButtonItem *doneBtn;

@end

@implementation CreateFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UINavigationBar * navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    
    //
    navigationBar.translucent = NO;
    navigationBar.tintColor = THEME_COLOR;
    UIBarButtonItem *dismissBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction)];
    self.doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction:)];
    
    
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"新文件"];
    
    navItem.leftBarButtonItem = dismissBtn;
    navItem.rightBarButtonItem = self.doneBtn;
    navItem.title = @"新文件";
    navItem.leftBarButtonItem = dismissBtn;
    navItem.rightBarButtonItem = self.doneBtn;
    
    [navigationBar pushNavigationItem:navItem animated:YES];

    
    
//    self.dataArr = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:navigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"图片";
    }else{
        return @"保存至";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    if (indexPath.section == 0) {
        if (self.imageModel.imgData != nil) {
            cell.imageView.layer.cornerRadius = 3;
            cell.imageView.clipsToBounds = YES;
            
            UIImage *cellImg =[UIImage imageWithData:self.imageModel.imgData];
            CGSize itemSize = CGSizeMake(36, 36);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
            CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
            [cellImg drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
        }
        
    }else{
        if (self.projectModel != nil) {
            cell.textLabel.text = self.projectModel.projectName;
        }else{
            cell.textLabel.text = @"请选择项目";
        }
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
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
        ChooseProjectViewController *chooseProjectVC = [[ChooseProjectViewController alloc] init];
        chooseProjectVC.delegate = self;
        
        [self.navigationController pushViewController:chooseProjectVC animated:YES];
    }
}

-(void)dismissAction{
    [self dismissViewControllerAnimated:self completion:nil];
}


-(void)didSelectProject:(RSSProject *)project{
    self.projectModel = project;
    [self.tableView reloadData];
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *imgData = UIImagePNGRepresentation(img);

    
    if (self.imageModel == nil) {
        self.imageModel = [[RSSImage alloc] init];
    }
    self.imageModel.imgData = imgData;
    
    
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadData];
    }];
    
}

-(void)doneAction:(UIButton *) sender{
    
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
    if ([dataBase open]) {
        NSString *query = [NSString stringWithFormat:@"INSERT INTO RSSFile VALUES (NULL,%d,?)",[self.projectModel.projectID intValue]];
        BOOL result = [dataBase executeUpdate:query,self.imageModel.imgData];
        if (result == YES) {
            NSLog(@"插入文件成功");
        }
    }
    [dataBase close];
    [self dismissViewControllerAnimated:YES completion:nil];
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
