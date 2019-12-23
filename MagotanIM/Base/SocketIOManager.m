//
//  SocketIOManager.m
//  MagotanIM
//
//  Created by 新银河 on 2019/10/30.
//  Copyright © 2019 MJDev. All rights reserved.
//

#import "SocketIOManager.h"
@import SocketIO;

@interface SocketIOManager ()

@property (nonatomic,strong)SocketIOClient *socket;
@property (nonatomic,strong)SocketManager *manager;

@end

@implementation SocketIOManager

static id _instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

- (void )connectSocketIO {
    
    NSURL* url = [[NSURL alloc] initWithString:@"http://192.168.1.60:8080"];
    SocketManager* manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"compress": @YES,@"transports":@[@"polling", @"websocket"]    }];
    SocketIOClient* socket = manager.defaultSocket;
    
    //连接
    [socket on:@"/" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"=======socket connected==========");
    }];
    
    [socket connect];
    
    self.socket = socket;
    self.manager = manager;
    
    NSLog(@"socketIO 连接");
}

- (void )disconnectSocketIO {
    
    NSLog(@"socketIO 断开");
    [self.socket disconnect];
}

- (void )onOrder:(NSString *)order completion:(void (^)(id response))completion {
    
    [self.socket on:order callback:^(NSArray* data, SocketAckEmitter* ack) {

        completion(data);
    }];
    
}

- (void )emitOrder:(NSString *)order with:(NSDictionary *)dic
{
    [self.socket emit:order with:@[dic]];
}

@end
