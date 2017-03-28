//
//  NavigationViewController.m
//  FFKit
//
//  Created by fan on 16/12/6.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "NavigationViewController.h"
#import "UIViewController+FYAdd.h"

@interface NavigationViewController ()<UITableViewDelegate,UITableViewDataSource> {
    
}
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* dataList;

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUp {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataList = @[@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1"];
    
    self.navBarColor = [UIColor orangeColor];
    [self setNavLeftItemBack:nil];
    
    [self setNavRightItemWithImage:[UIImage imageNamed:@"nav_back"] selector:@selector(rightItemClick:)];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - events
- (void)rightItemClick:(UIButton*)sender {
    NSLog(@"%@",sender);
}

- (void)leftItemClick:(UIButton*)sender {
    NSLog(@"%@",sender);
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        CellRegister([UITableViewCell class]);
    }
    return _tableView;
}

@end
