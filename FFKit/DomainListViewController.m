//
//  DomainListViewController.m
//  FFKit
//
//  Created by fan on 16/7/14.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "DomainListViewController.h"

#define TITLE             @"DIC_TITLE"
#define VALUE           @"DIC_VALUE"
@interface DomainListViewController ()<UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray* _dataList;
}
@property (nonatomic, strong) UITableView* tableView;

@end

@implementation DomainListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (self.index == 0) {
        _dataList = [NSMutableArray arrayWithObjects:
                     @{TITLE:@"Keyboard",VALUE:@"KeyboardViewController"},
                     @{TITLE:@"裁剪图片",VALUE:@"ClipViewController"},
                     @{TITLE:@"textfield",VALUE:@"TextFieldViewController"},
                     @{TITLE:@"控制器",VALUE:@"NavigationViewController"},
                     nil];
    }else if (self.index == 2) {
        _dataList = [NSMutableArray arrayWithObjects:
                     @{TITLE:@"显示照相机视图",VALUE:@"CameraViewController"},
                     @{TITLE:@"录制视频",VALUE:@"VideoRecordViewController"},
                     @{TITLE:@"摄像头美颜",VALUE:@""},
                     @{TITLE:@"录制视频",VALUE:@"VideoRecordViewController"},
                     @{TITLE:@"人脸识别",VALUE:@"CameraViewController"},
                     @{TITLE:@"实时滤镜",VALUE:@"CameraViewController"},
                     @{TITLE:@"录制视频",VALUE:@"VideoRecordViewController"},
                     nil];
    }else if (self.index == 3) {
        _dataList = [NSMutableArray arrayWithObjects:
                     @{TITLE:@"微信(登录/分享/支付)",VALUE:@"WeChatViewController"},
                     @{TITLE:@"腾讯",VALUE:@""},
                     @{TITLE:@"微博",VALUE:@""},
                     @{TITLE:@"综合(微信/腾讯/微博)",VALUE:@""},
                     @{TITLE:@"升级与统计",VALUE:@""},
                     @{TITLE:@"第三方短信验证",VALUE:@""},
                     nil];
    }else if (self.index == 4) {
        _dataList = [NSMutableArray arrayWithObjects:
                     @{TITLE:@"下载管理",VALUE:@""},
                     @{TITLE:@"二维码扫描",VALUE:@""},
                     @{TITLE:@"录制UIView视频",VALUE:@"RecordViewViewController"},
                     nil];
    }else if (self.index == 5) {
        _dataList = [NSMutableArray arrayWithObjects:
                     @{TITLE:@"弹窗",VALUE:@"DialogViewController"},
                     @{TITLE:@"Loading",VALUE:@"FYLoadingViewController"},
                     @{TITLE:@"模糊",VALUE:@""},
                     @{TITLE:@"卡牌效果",VALUE:@""},
                     @{TITLE:@"卡牌效果",VALUE:@""},
                     @{TITLE:@"评价星际",VALUE:@""},
                     @{TITLE:@"日历",VALUE:@""},
                     @{TITLE:@"图片选择器",VALUE:@""},
                     @{TITLE:@"自定义上拉下拉",VALUE:@""},
                     @{TITLE:@"百度地图自定义大头针",VALUE:@""},
                     @{TITLE:@"图文混排",VALUE:@""},
                     @{TITLE:@"长文本输入",VALUE:@""},
                     @{TITLE:@"警告框",VALUE:@""},
                     @{TITLE:@"加载视图",VALUE:@""},
                     @{TITLE:@"引导页",VALUE:@""},
                     @{TITLE:@"常用样式的uitableviewcell",VALUE:@""},
                     @{TITLE:@"尺子",VALUE:@""},
                     @{TITLE:@"弹出的uitableview",VALUE:@""},
                     @{TITLE:@"搜索框",VALUE:@""},
                     @{TITLE:@"常用样式的自定义转场动画",VALUE:@""},
                     @{TITLE:@"抽奖（九宫格）",VALUE:@""},
                     @{TITLE:@"城市选择器",VALUE:@""},
                     @{TITLE:@"搜索框",VALUE:@""},
                     @{TITLE:@"常用样式的自定义转场动画",VALUE:@""},
                     @{TITLE:@"抽奖（九宫格）",VALUE:@""},
                     @{TITLE:@"城市选择器",VALUE:@""},
                     nil];
    }else if (self.index == 8) {
        _dataList = [NSMutableArray arrayWithObjects:
                     @{TITLE:@"下载文件",VALUE:@"DownloadViewController"},
                     nil];
    }else if (self.index == 7) {
        _dataList = [NSMutableArray arrayWithObjects:
                     @{TITLE:@"身份证/电话号码验证",VALUE:@""},
                     @{TITLE:@"卡牌效果",VALUE:@""},
                     @{TITLE:@"卡牌效果",VALUE:@""},
                     @{TITLE:@"评价星际",VALUE:@""},
                     @{TITLE:@"日历",VALUE:@""},
                     @{TITLE:@"图片选择器",VALUE:@""},
                     @{TITLE:@"自定义上拉下拉",VALUE:@""},
                     @{TITLE:@"百度地图自定义大头针",VALUE:@""},
                     @{TITLE:@"图文混排",VALUE:@""},
                     @{TITLE:@"跳转AppStore",VALUE:@""},
                     @{TITLE:@"二维码扫描/生成二维码",VALUE:@""},
                     @{TITLE:@"百度地图自定义大头针",VALUE:@""},
                     nil];
    }
    
    
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
    @try {
        UIViewController* vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:[_dataList[indexPath.row] objectForKey:VALUE]];
        [self.navigationController pushViewController:vc animated:YES];
    } @catch (NSException *exception) {
        UIViewController* vc = [[NSClassFromString([_dataList[indexPath.row] objectForKey:VALUE]) alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
