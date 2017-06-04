//
//  LDTabBarController.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/3/23.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "LDTabBarController.h"
#import "LDTabBar.h"
#import "AppDelegate.h"
#import "LDPopView.h"
#import "CreateProjectViewController.h"
#import <CoreImage/CoreImage.h>
#import "CreateMissionViewController.h"
#import "CreateFileViewController.h"
#import "HomeViewController.h"
#import "MyViewController.h"
#import "InfoViewController.h"
#import "SetViewController.h"

#define PLUS_BTN_WIDTH 47

#define PLUS_BTN_HEIGHT 47


@interface LDTabBarController ()<UIGestureRecognizerDelegate,CAAnimationDelegate>

@property (nonatomic,strong) LDTabBar *LDtabBar;
@property (nonatomic,strong) LDPopView *popView;

@end

@implementation LDTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //向TabBarController中添加子控制器
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    MyViewController *myVC = [[MyViewController alloc] init];
    InfoViewController *infoVC = [[InfoViewController alloc] init];
    SetViewController *chatVC = [[SetViewController alloc] init];
    
    UINavigationController *navHome = [[UINavigationController alloc] initWithRootViewController:homeVC];
    navHome.navigationBar.translucent = NO;
    navHome.navigationBar.tintColor = THEME_COLOR;
    
    UINavigationController *navMy = [[UINavigationController alloc] initWithRootViewController:myVC];
    navMy.navigationBar.translucent = NO;
    navMy.navigationBar.tintColor = THEME_COLOR;
    
    UINavigationController *navInfo = [[UINavigationController alloc] initWithRootViewController:infoVC];
    navInfo.navigationBar.translucent = NO;
    navInfo.navigationBar.tintColor = THEME_COLOR;
    
    UINavigationController *navChat = [[UINavigationController alloc] initWithRootViewController:chatVC];
    navChat.navigationBar.translucent = NO;
    navChat.navigationBar.tintColor = THEME_COLOR;
    
    
    //设置TabbarButton样式
    homeVC.title = @"首页";
    [homeVC.tabBarItem setImage:[[UIImage imageNamed:@"Home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [homeVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"Home"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    myVC.title = @"我的";
    [myVC.tabBarItem setImage:[[UIImage imageNamed:@"My"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [myVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"My"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    infoVC.title = @"通知";
    [infoVC.tabBarItem setImage:[[UIImage imageNamed:@"Info"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [infoVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"Info"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    chatVC.title = @"设置";
    [chatVC.tabBarItem setImage:[[UIImage imageNamed:@"set"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [chatVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"set"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    
    [self addChildViewController:navHome];
    [self addChildViewController:navMy];
    [self addChildViewController:navInfo];
    [self addChildViewController:navChat];

    self.navigationItem.hidesBackButton = YES;
    
    self.LDtabBar = [[LDTabBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];
    self.LDtabBar.translucent = NO;
    [self.LDtabBar.plusBtn addTarget:self action:@selector(clickPlusBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self setValue:self.LDtabBar forKey:@"tabBar"];
    self.tabBar.tintColor = THEME_COLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
}

-(void)clickPlusBtn:(UIButton *) sender{
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeModalView)];
    tapGes.delegate = self;

    NSArray *imgArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"project"],[UIImage imageNamed:@"mission"],[UIImage imageNamed:@"file"], nil];
    NSArray *nameArray = [NSArray arrayWithObjects:@"项目",@"任务",@"文件", nil];
    self.popView = [[LDPopView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250) andButtonIcons:imgArray andButtonNames:nameArray];
    [self.popView addGestureRecognizer:tapGes];
    for (UIButton *btn in self.popView.buttonArray) {

        [btn addTarget:self action:@selector(clickPopupBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }

    [self.view addSubview:self.popView];
    
}

-(void)removeModalView{
    [self.popView dismissPopView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[LDPopView class]]) {
        return YES;
    }else{
        return NO;
    }
}

-(void)clickPopupBtn:(UIButton *) sender{
    if (sender.tag == 0) {
        CreateProjectViewController *createProjectView  = [[CreateProjectViewController alloc] init];
        [self presentViewController:createProjectView animated:YES completion:^{
            [self removeModalView];
        }];
    }else if (sender.tag == 1){
        CreateMissionViewController *createMissionView = [[CreateMissionViewController alloc] init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:createMissionView];
        nav.navigationBar.hidden = YES;
        [self presentViewController:nav animated:YES completion:^{
            [self removeModalView];
        }];
    }else{
        CreateFileViewController *createFileView = [[CreateFileViewController alloc] init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:createFileView];
        nav.navigationBar.hidden = YES;
        [self presentViewController:nav animated:YES completion:^{
            [self removeModalView];
        }];
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
