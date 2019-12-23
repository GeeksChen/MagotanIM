//
//  RoomChatViewController.m
//  MagotanIM
//
//  Created by 新银河 on 2019/11/9.
//  Copyright © 2019 MJDev. All rights reserved.
//

#import "RoomChatViewController.h"
#import "MessageModel.h"
#import "ChatCell.h"

#define kHeight 80

@interface RoomChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)UITableView *chatTableView;
@property (nonatomic,strong)UITextField *msgField;
@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong)UIView *bottomView;

@end

@implementation RoomChatViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[SocketIOManager sharedInstance] emitOrder:@"leave" with:@{@"userid":self.uid,@"roomid":self.roomid}];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *titles = @[@"iOS开发",@"安卓开发",@"前端开发",@"PHP开发",@"Python开发",@"Lua开发"].mutableCopy;

    int idx = [self.roomid intValue]-1;
    
    self.title = [NSString stringWithFormat:@"%@",titles[idx]];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
    
    [self.view addSubview:self.selectTableView];
    
    [self setUpBottomView];
    
    [[SocketIOManager sharedInstance] onOrder:@"sendMsg" completion:^(id  _Nonnull response) {
        
        if (response) {
            MessageModel *model = [[MessageModel alloc] init];
            model.toUser = response[0][@"toUser"];
            model.fromUser = response[0][@"fromUser"];
            model.msg = response[0][@"msg"];
            model.type = response[0][@"type"];
            model.ext = response[0][@"ext"];
            
            [self.dataArray addObject:model];

            [self.chatTableView reloadData];
            [self scrollTableViewToBottom];
            
            self.msgField.text = @"";
        }
        
    }];
    [[SocketIOManager sharedInstance] onOrder:@"leave" completion:^(id  _Nonnull response) {
        
        if ([response[0][@"msg"] isEqualToString:@"1"]) {
            NSLog(@"用户退出房间成功");
        }
    }];
}

- (void)setUpBottomView {
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:self.msgField];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
}

- (UITextField *)msgField {
    if (!_msgField) {
        _msgField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 40)];
        _msgField.backgroundColor = [UIColor lightGrayColor];
        _msgField.placeholder = @"请输入信息";
        _msgField.returnKeyType = UIReturnKeySend;
        _msgField.delegate = self;
    }
    return _msgField;
}

- (UITableView *)selectTableView{
    if (!_chatTableView) {
        _chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40) style:(UITableViewStylePlain)];
        _chatTableView.rowHeight = 60;
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        _chatTableView.backgroundColor = [UIColor colorWithRed:249 green:249 blue:212 alpha:1];
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _chatTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
    if (!cell) {
        cell = [[ChatCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"chatCell"];
    }
    
    MessageModel *model = self.dataArray[indexPath.row];
    
    cell.nicknameLabel.text = model.fromUser;
    cell.contentLabel.text = model.msg;
    
    if ([self.uid isEqualToString:model.fromUser]) {
        cell.nicknameLabel.textAlignment = NSTextAlignmentRight;
        cell.contentLabel.textAlignment = NSTextAlignmentRight;
    }else {
        cell.nicknameLabel.textAlignment = NSTextAlignmentLeft;
        cell.contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:@"" forKey:@"toUser"];
    [dic setValue:self.uid forKey:@"fromUser"];
    [dic setValue:self.msgField.text forKey:@"msg"];
    [dic setValue:@"roomChat" forKey:@"type"];
    [dic setValue:@"" forKey:@"ext"];
    
    if (self.msgField.text.length) {
        //发送order
        [[SocketIOManager sharedInstance] emitOrder:@"sendMsg" with:dic];
    }else {
        NSLog(@"不能发送空消息");
    }

    return YES;
}

-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //    (origin = (x = 0, y = 270.5), size = (width = 320, height = 297.5))
    
    [UIView animateWithDuration:duration animations:^{
        CGRect rec = CGRectMake(0, self.view.frame.size.height-rect.size.height-60, self.view.frame.size.width, 60);
        self.bottomView.frame = rec;
        self.chatTableView.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height-rect.size.height-65);
        [self scrollTableViewToBottom];

    }];
}

-(void)keyboardWillHide:(NSNotification *)note
{
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        CGRect rec = CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60);
        self.bottomView.frame = rec;
        self.chatTableView.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height-60);
        [self scrollTableViewToBottom];
    }];
    
}

- (void)scrollTableViewToBottom {
    if(self.dataArray.count > 0){
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
        [self.chatTableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

//滑动屏幕时回退键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

//当有键盘弹出、回退时，都会发通知，如果此控制器已销毁，通知会根据原来的地址找此控制器，程序会崩溃
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
