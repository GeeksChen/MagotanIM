//
//  RoomListViewController.m
//  MagotanIM
//
//  Created by 新银河 on 2019/11/9.
//  Copyright © 2019 MJDev. All rights reserved.
//

#import "RoomListViewController.h"
#import "RoomModel.h"
#import "RoomChatViewController.h"

@interface RoomListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *roomListTableView;
@property (nonatomic,strong)NSMutableArray *roomListArray;

@end

@implementation RoomListViewController

- (NSMutableArray *)roomListArray {
    if (!_roomListArray) {
        _roomListArray = [NSMutableArray array];
    }
    return _roomListArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[SocketIOManager sharedInstance] emitOrder:@"roomList" with:@{}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"房间列表";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.roomListTableView];
//    1iOS开发 2安卓开发 3前端开发 4PHP开发 5Python开发 6Lua开发
    NSArray *titles = @[@"iOS开发",@"安卓开发",@"前端开发",@"PHP开发",@"Python开发",@"Lua开发"].mutableCopy;
    
    for (int i = 0; i < titles.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:titles[i] forKey:@"title"];
        [dic setValue:@"0" forKey:@"number"];
        [dic setValue:[NSString stringWithFormat:@"%d",i+1] forKey:@"roomId"];
        [self.roomListArray addObject:dic];
    }
    
    [self addRefresh];
    
    [[SocketIOManager sharedInstance] emitOrder:@"roomList" with:@{}];

    [[SocketIOManager sharedInstance] onOrder:@"roomList" completion:^(id  _Nonnull response) {

        NSArray *roomList = response[0][@"roomList"];
        
        if (roomList.count) {
            [roomList enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSLog(@"=====%@",obj);
                if ([obj[@"roomid"] intValue] != 0) {
                    NSInteger index = [obj[@"roomid"] intValue]-1;
                    NSMutableDictionary *dd = self.roomListArray[index];
                    [dd setValue:obj[@"number"] forKey:@"number"];
                }
            }];
            [self.roomListTableView reloadData];
            [self.roomListTableView.mj_header endRefreshing];
            
        }else {
            NSLog(@"没有用户");
        }
    }];
    
    [[SocketIOManager sharedInstance] onOrder:@"join" completion:^(id  _Nonnull response) {
        
        NSString *msg = response[0][@"msg"];
        
        if ([msg isEqualToString:@"1"]) {

            RoomChatViewController *roomChatVC = [RoomChatViewController new];
            roomChatVC.roomid = response[0][@"roomid"];
            roomChatVC.uid = self.uid;
            [self.navigationController pushViewController:roomChatVC animated:YES];

        }else {
            NSLog(@"用户进入房间失败");
        }
    }];
}
-(void)addRefresh{

    self.roomListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[SocketIOManager sharedInstance] emitOrder:@"roomList" with:@{}];
    }];

}
- (UITableView *)roomListTableView{
    if (!_roomListTableView) {
        _roomListTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
        _roomListTableView.rowHeight = 75;
        _roomListTableView.delegate = self;
        _roomListTableView.dataSource = self;
        UIView * footer = [[UIView alloc] initWithFrame:CGRectZero];
        _roomListTableView.tableFooterView = footer;
    }
    return _roomListTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.roomListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"selectCell"];
    }
    
    NSDictionary *model = self.roomListArray[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"当前在线%@人",model[@"number"]];
    cell.textLabel.text = model[@"title"];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *info = self.roomListArray[indexPath.row];
    [self loginWithRoomInfo:info];
    
}

- (void)loginWithRoomInfo:(NSMutableDictionary *)info{
    
    [[SocketIOManager sharedInstance] emitOrder:@"join" with:@{@"userID":self.uid,@"roomid":info[@"roomId"]}];
}

@end
