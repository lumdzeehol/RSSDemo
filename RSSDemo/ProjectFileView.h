//
//  ProjectFileView.h
//  RSSDemo
//
//  Created by lumdzeehol on 2017/5/2.
//  Copyright © 2017年 lumdzeehol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSProject.h"

@interface ProjectFileView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) RSSProject *projectModel;

-(void)refresh;

@end
