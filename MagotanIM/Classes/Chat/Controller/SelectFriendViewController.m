//
//  SelectFriendViewController.m
//  MagotanIM
//
//  Created by 新银河 on 2019/10/30.
//  Copyright © 2019 MJDev. All rights reserved.
//

#import "SelectFriendViewController.h"
#import "ChatViewController.h"
#import "UserModel.h"

@interface SelectFriendViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *selectTableView;
@property (nonatomic,strong)NSMutableArray *userListArray;

@end

@implementation SelectFriendViewController

- (NSMutableArray *)userListArray {
    if (!_userListArray) {
        _userListArray = [NSMutableArray array];
    }
    return _userListArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[SocketIOManager sharedInstance] emitOrder:@"userList" with:@{}];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"好友列表";

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.selectTableView];
    
    [self addRefresh];
    
    [[SocketIOManager sharedInstance] emitOrder:@"userList" with:@{}];

    [[SocketIOManager sharedInstance] onOrder:@"userList" completion:^(id  _Nonnull response) {
        
        NSArray *userList = response[0][@"userList"];
        if (userList.count) {
            
            if (self.userListArray) {
                [self.userListArray removeAllObjects];
            }
            for (NSDictionary *dic in userList) {
                UserModel *model = [[UserModel alloc] initWithDictionary:dic error:nil];
                [self.userListArray addObject:model];
            }
            
            [self.selectTableView reloadData];
            [self.selectTableView.mj_header endRefreshing];
        }else {
            NSLog(@"没有用户");
        }
        
    }];
}
-(void)addRefresh{
    
    self.selectTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[SocketIOManager sharedInstance] emitOrder:@"userList" with:@{}];
    }];
    
}
- (UITableView *)selectTableView{
    if (!_selectTableView) {
        _selectTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
        _selectTableView.rowHeight = 75;
        _selectTableView.delegate = self;
        _selectTableView.dataSource = self;
        UIView * footer = [[UIView alloc] initWithFrame:CGRectZero];
        _selectTableView.tableFooterView = footer;
    }
    return _selectTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"selectCell"];
    }
    
    UserModel *model = self.userListArray[indexPath.row];
    
    cell.textLabel.text = model.userid;
    
    if ([model.status intValue] == 0) {
        cell.detailTextLabel.text = @"离线";
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.userInteractionEnabled = NO;
        
    }else{
        cell.detailTextLabel.text = @"在线";
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.userInteractionEnabled = YES;
        if (model.userid == self.uid) {
            cell.detailTextLabel.text = @"(当前用户)在线";
            cell.userInteractionEnabled = NO;
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UserModel *model = self.userListArray[indexPath.row];

    ChatViewController *chatVC = [ChatViewController new];
    chatVC.toUser = model.userid;
    chatVC.currentUser = self.uid;
    [self.navigationController pushViewController:chatVC animated:YES];
}

//废弃 通过http请求获取用户列表
//- (void)loadUserList {
//
//    [[MagotanIMRequest sharedInstance] loadUserListWithUID:@"" completion:^(id  _Nonnull response) {
//
//        if (response) {
//
//            if (self.userListArray) {
//                [self.userListArray removeAllObjects];
//            }
//            for (NSDictionary *dic in response) {
//                UserModel *model = [[UserModel alloc] initWithDictionary:dic error:nil];
//                [self.userListArray addObject:model];
//            }
//            [self.selectTableView reloadData];
//
//            [self.selectTableView.mj_header endRefreshing];
//        }
//    }];
//
//}

@end
