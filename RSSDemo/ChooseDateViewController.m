//
//  ChooseDateViewController.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/8.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "ChooseDateViewController.h"

@interface ChooseDateViewController ()

@property (nonatomic,strong) UIDatePicker *datePicker;

@property (nonatomic,strong) UIBarButtonItem *doneBtn;

@end

@implementation ChooseDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = THEME_COLOR;
    
    self.doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction:)];
//    self.doneBtn.enabled = NO;
    
    
//    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@""];
    
    self.navigationItem.rightBarButtonItem = self.doneBtn;
//    self.navigationItem.leftBarButtonItem = dismissBtn;
//    self.navigationItem.rightBarButtonItem = self.doneBtn;
//    
//    [self.navigationController.navigationBar pushNavigationItem:navItem animated:YES];
//    
//    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 300)];
    
    [self.view addSubview:self.datePicker];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneAction:(UIBarButtonItem *) btn{
    [self.delegate didSelectDate:self.datePicker.date];
    NSLog(@"%@",self.datePicker.date);
    [self.navigationController popViewControllerAnimated:YES];
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
