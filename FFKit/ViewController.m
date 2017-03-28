//
//  ViewController.m
//  FFKit
//
//  Created by fan on 16/6/28.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "ViewController.h"
#import "DomainListViewController.h"

#define TITLE             @"DIC_TITLE"
#define VALUE           @"DIC_VALUE"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray* _dataList;
}
@property (nonatomic, strong) UITableView* tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"FYKit";
    _dataList = [NSMutableArray arrayWithObjects:
                 @{TITLE:@"UI",VALUE:@"DomainListViewController"},
                 @{TITLE:@"播放器",VALUE:@"PlayerViewController"},
                 @{TITLE:@"多媒体",VALUE:@"DomainListViewController"},
                 @{TITLE:@"社交",VALUE:@"DomainListViewController"},
                 @{TITLE:@"工具",VALUE:@"DomainListViewController"},
                 @{TITLE:@"UI效果",VALUE:@"DomainListViewController"},
                 @{TITLE:@"工具",VALUE:@"DomainListViewController"},
                 @{TITLE:@"功能",VALUE:@"DomainListViewController"},
                 @{TITLE:@"网络",VALUE:@"DomainListViewController"},
                 nil];
    [self addUI];
    
    [self.tableView reloadData];
}

#pragma mark - ui
- (void)addUI {
    [self.view addSubview:self.tableView];
}

#pragma mark - tableviewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = [_dataList[indexPath.row] objectForKey:TITLE];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController* vc = [[NSClassFromString([_dataList[indexPath.row] objectForKey:VALUE]) alloc] init];
    if ([vc isKindOfClass:[DomainListViewController class]]) {
        ((DomainListViewController*)vc).index = indexPath.row;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

@end
