#### 前沿

>本章主要介绍如何在iOS端实现单聊和群聊，服务端是本地搭建，数据库使用mysql。

##### 1.app演示
>才知道简书不支持video
![444用户登录.jpeg](https://upload-images.jianshu.io/upload_images/1745735-7933689ee5668c6e.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/410)
![444用户选择聊天对象.jpeg](https://upload-images.jianshu.io/upload_images/1745735-1f3bb0dc1eda3e5c.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/410)
![444聊天.jpeg](https://upload-images.jianshu.io/upload_images/1745735-6c2b5d56d534ad6f.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/410)
![333登录.png](https://upload-images.jianshu.io/upload_images/1745735-682a0ef5bf78d345.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/410)
![333选择对象.png](https://upload-images.jianshu.io/upload_images/1745735-c61351dfa867d7ec.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/410)
![333聊天.png](https://upload-images.jianshu.io/upload_images/1745735-af80bc0cf9ebd68f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/410)

#### 2.单聊实现工程

##### 2.1.登录
```
[[SocketIOManager sharedInstance] emitOrder:@"login" with:@{@"userID":self.userField.text,@"type":@"chat"}];
```

##### 2.2.选择好友
```
[[SocketIOManager sharedInstance] emitOrder:@"userList" with:@{}];
```
##### 2.3.聊天
```
NSMutableDictionary *dic = [NSMutableDictionary dictionary];

[dic setValue:self.toUser forKey:@"toUser"];
[dic setValue:self.currentUser forKey:@"fromUser"];
[dic setValue:self.msgField.text forKey:@"msg"];
[dic setValue:@"chat" forKey:@"type"];
[dic setValue:@"" forKey:@"ext"];

//发送order
[[SocketIOManager sharedInstance] emitOrder:@"sendMsg" with:dic];
```

#### 3.群聊实现过程

##### 3.1.登录
```
[[SocketIOManager sharedInstance] emitOrder:@"login" with:@{@"userID":self.userField.text,@"type":@"roomChat"}];
```

##### 3.2.获取房间列表
```
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
```

##### 3.3.选择房间
```
[[SocketIOManager sharedInstance] emitOrder:@"join" with:@{@"userID":self.uid,@"roomid":info[@"roomId"]}];

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

```

##### 3.4.开始聊天
```

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
```

>不管大佬们关不关注公众号，我都会放上本章的[Demo](https://github.com/GeeksChen/MagotanIM)

个人作品1：（匿名聊天）
[http://im.meetyy.cn/](http://im.meetyy.cn/)

个人作品2：（单身交友）
![公众号Meetyy](https://upload-images.jianshu.io/upload_images/1745735-9ba29c862a0268be.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



