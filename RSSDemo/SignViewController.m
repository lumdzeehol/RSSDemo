//
//  SignViewController.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/4/17.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "SignViewController.h"
#import <FMDB.h>

@interface SignViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic,strong) UIImage *avatar;
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;



@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarChange)];
    [self.imgView addGestureRecognizer:tap];
    self.avatar = [UIImage imageNamed:@"avatar"];
    self.imgView.image = self.avatar;
    [self.nickNameTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    self.passwordTextField.secureTextEntry = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signAction:(id)sender {

    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
    
    NSData *imgData = UIImagePNGRepresentation(self.avatar);
    
    if ([dataBase open]) {
        
        
        NSString *query = @"INSERT INTO RSSUsers VALUES (NULL,?,?,?,?)";
        BOOL result = [dataBase executeUpdate:query,self.userTextField.text,self.passwordTextField.text,self.nickNameTextField.text,imgData];
        if (result) {
            NSLog(@"注册成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    
}

-(void)textChange{
    if (self.userTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        self.registerBtn.enabled = YES;
        self.registerBtn.backgroundColor = THEME_COLOR;
    }
}



-(void)avatarChange{
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
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self.imgView setImage:img];
    self.avatar = img;
    NSLog(@"%@",info);
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
    
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
