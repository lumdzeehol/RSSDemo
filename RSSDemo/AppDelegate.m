//
//  AppDelegate.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/3/19.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "AppDelegate.h"
#import "LDTabBarController.h"
#import "HomeViewController.h"
#import "MyViewController.h"
#import "InfoViewController.h"
#import "SetViewController.h"
#import "LoginViewController.h"
#import "SignViewController.h"
#import <FMDB.h>

@interface AppDelegate ()

@property (nonatomic,strong) FMDatabase *dataBase;


-(NSString *)getDBPath;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    LDTabBarController *tabBarC = [[LDTabBarController alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [defaults boolForKey:@"isLogin"];
//    if (isLogin) {
//        UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:tabBarC];
//    }else{
//    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//    }
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:isLogin?tabBarC:loginVC];
    
    rootNav.navigationBarHidden = YES;
    
    self.window.rootViewController = rootNav;

    
    [self.window makeKeyAndVisible];
    
    self.dataBase = [FMDatabase databaseWithPath:[self getDBPath]];
    if (![self.dataBase open]) {
        NSLog(@"create database failed");
    }else{
        //创建 项目、任务、文件、用户 表
        
        FMResultSet *set= [self.dataBase executeQuery:@"SELECT * FROM RSSUsers"];
        
        while ([set next]) {
            NSLog(@"%d %@ %@",[set intForColumnIndex:0],[set stringForColumnIndex:1],[set stringForColumnIndex:2]);
        }
        
        BOOL results1 = [self.dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS RSSProjectList (id integer PRIMARY KEY AUTOINCREMENT, projectname nvarchar NOT NULL, projecttype bit NOT NULL,creatorID integer NOT NULL );"];
        
        BOOL results2 = [self.dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS RSSMissions (id integer PRIMARY KEY AUTOINCREMENT, missionname nvarchar NOT NULL ,deadline nvarchar , projectid integer NOT NULL, executorid integer NOT NULL , iscompleted bit NOT NULL)"];
        
        BOOL results3 = [self.dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS RSSFile (id integer PRIMARY KEY AUTOINCREMENT,projectid integer NOT NULL,filedata blob NOT NULL);"];
        
        BOOL results4 = [self.dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS RSSUsers (id integer PRIMARY KEY AUTOINCREMENT,username nvarchar UNIQUE NOT NULL,userpassword nvarchar NOT NULL,usernickname nvarchar NOT NULL,avatar blob );"];
        
        
        if (results1 && results2 &&results3 && results4) {
            NSLog(@"create Table success");
        }
    }
    
    [self.dataBase close];
    
    return YES;
}

-(NSString *)getDBPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *DBPath = [documentPath stringByAppendingPathComponent:@"RSS.db"];//RSS数据库
    return DBPath;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
