//
//  DownloadViewController.m
//  FFKit
//
//  Created by fan on 16/12/20.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "DownloadViewController.h"
#import "FYDownloadManager.h"
#import "FYDownloaderOperation.h"

@interface DownloadViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
}
@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) NSMutableArray* dataList;

@property (nonatomic, strong) FYDownloaderOperation* operation;

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"下载";
    
    self.dataList = [NSMutableArray array];
    
    [self setNavRightItemWithTitle:@"取消" selector:@selector(rightItemClick:)];
    
    [self.view addSubview:self.tableView];
    

        
    NSArray* array = @[
                       @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4",
                       @"http://baobab.wdjcdn.com/14525705791193.mp4",
                       @"http://baobab.wdjcdn.com/1456665467509qingshu.mp4",
                       @"http://baobab.wdjcdn.com/1455968234865481297704.mp4",
                       @"http://baobab.wdjcdn.com/14564977406580.mp4"
                       ];
    
    self.operation = [[FYDownloaderOperation alloc] initWithRequest:array[3] inSession:nil options:0 progress:nil completed:^(NSError* error){
        NSLog(@"下载完毕 %@",error);
    } cancelled:^{
        NSLog(@"取消");
    }];
    [self.operation start];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = ({
        CGRect rect;
        rect.size.width = 100;
        rect.size.height = 100;
        rect.origin.x = (self.view.width - CGRectGetWidth(rect)) / 2;
        rect.origin.y = self.view.height - CGRectGetHeight(rect) - 50;
        rect;
    });
    btn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - events
- (void)rightItemClick:(UIButton*)sender {
    [self.operation cancel];
}

- (void)btnClick:(UIButton*)sender {
    [self.operation deleteTask];
}

#pragma mark - tableviewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataList.count;
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    self.operation.progressedBlock = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        dispatch_async(dispatch_get_main_queue(), ^{
          cell.textLabel.text = [NSString stringWithFormat:@"%f",totalBytesWritten / (CGFloat)totalBytesExpectedToWrite];
        });
    };
    
    return cell;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        CellRegister([UITableViewCell class]);
    }
    return _tableView;
}

@end
