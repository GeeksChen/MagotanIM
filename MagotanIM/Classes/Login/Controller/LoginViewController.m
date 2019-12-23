//
//  LoginViewController.m
//  MagotanIM
//
//  Created by 新银河 on 2019/10/30.
//  Copyright © 2019 MJDev. All rights reserved.
//

#import "LoginViewController.h"
#import "SelectFriendViewController.h"
#import "RoomListViewController.h"

@interface LoginViewController ()

@property (nonatomic,strong)UITextField *userField;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"登陆";
    
    [[SocketIOManager sharedInstance] connectSocketIO];

    UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    logoLabel.text = @"MagotanIM";
    logoLabel.font = [UIFont boldSystemFontOfSize:30];
    logoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:logoLabel];
    
    UITextField *userField = [[UITextField alloc] initWithFrame:CGRectZero];
    userField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    userField.layer.borderWidth = 1;
    userField.layer.masksToBounds = YES;
    userField.layer.cornerRadius = 40;
    userField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    userField.placeholder = @"请输入账号";
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    leftView.backgroundColor = [UIColor clearColor];
    // 保证点击缩进的view，也可以调出光标
    leftView.userInteractionEnabled = NO;
    userField.leftView = leftView;
    userField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:userField];
    self.userField = userField;
    
    UIButton *chatBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [chatBtn setTitle:@"单聊" forState:(UIControlStateNormal)];
    [chatBtn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    chatBtn.layer.masksToBounds = YES;
    chatBtn.layer.borderColor = [UIColor blueColor].CGColor;
    chatBtn.layer.borderWidth = 2;
    chatBtn.layer.cornerRadius = 30;
    [chatBtn addTarget:self action:@selector(chatAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:chatBtn];
    
    UIButton *groupChatBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [groupChatBtn setTitle:@"群聊" forState:(UIControlStateNormal)];
    [groupChatBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    groupChatBtn.layer.masksToBounds = YES;
    groupChatBtn.layer.borderColor = [UIColor redColor].CGColor;
    groupChatBtn.layer.borderWidth = 2;
    groupChatBtn.layer.cornerRadius = 30;
    [groupChatBtn addTarget:self action:@selector(groupChatAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:groupChatBtn];
    
    [logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.mas_equalTo(80);
        make.top.mas_equalTo(self.view).offset(100);
    }];
    
    [userField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.mas_equalTo(80);
        make.top.mas_equalTo(logoLabel.mas_bottom).offset(80);
    }];
    
    [chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(140, 60));
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(-100);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(130);
    }];
    
    [groupChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(140, 60));
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(100);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(130);
    }];
        
    [[SocketIOManager sharedInstance] onOrder:@"login" completion:^(id  _Nonnull response) {
        
        NSString *msg = response[0][@"msg"];
        
        if ([response[0][@"type"] isEqualToString:@"chat"]) {//单聊
            if ([msg isEqualToString:@"1"]) {
                
                [[NSUserDefaults standardUserDefaults] setValue:self.userField.text forKey:@"CURRENTUSER"];
                
                SelectFriendViewController *selectVC = [SelectFriendViewController new];
                selectVC.uid = self.userField.text;
                [self.navigationController pushViewController:selectVC animated:YES];
            }else {
                NSLog(@"用户登陆失败");
            }
        }
        else if ([response[0][@"type"] isEqualToString:@"roomChat"]) {//群聊
            if ([msg isEqualToString:@"1"]) {
                RoomListViewController *roomListVC = [RoomListViewController new];
                roomListVC.uid = self.userField.text;
                [self.navigationController pushViewController:roomListVC animated:YES];
            }else {
                 NSLog(@"用户登陆失败");
            }
        }
    }];

}

- (void)chatAction {
    
    [self.view endEditing:YES];
    if (self.userField.text.length) {

        [[SocketIOManager sharedInstance] emitOrder:@"login" with:@{@"userID":self.userField.text,@"type":@"chat"}];
    }else {
        NSLog(@"请输入账号");
    }
}

- (void)groupChatAction {
    
    [self.view endEditing:YES];
    if (self.userField.text.length) {
        
         [[SocketIOManager sharedInstance] emitOrder:@"login" with:@{@"userID":self.userField.text,@"type":@"roomChat"}];
    }else {
        NSLog(@"请输入账号");
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
