//
//  BroswerViewController.m
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/26.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import "BroswerViewController.h"

@interface BroswerViewController ()

@property (nonatomic,strong) UIImageView *imgView;



@end

@implementation BroswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.imgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.imgView.image = self.image;
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imgView];
    UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    bar.backgroundColor = [UIColor blackColor];
    bar.alpha = 0.5f;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 25, 34, 34)];
    [backBtn setImage:[UIImage imageNamed:@"cha"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:backBtn];
    [self.view addSubview:bar];
}

-(void)dismiss{
    NSLog(@"!!!!");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
