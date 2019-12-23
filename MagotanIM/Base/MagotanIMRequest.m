//
//  MagotanIMRequest.m
//  MagotanIM
//
//  Created by 新银河 on 2019/10/30.
//  Copyright © 2019 MJDev. All rights reserved.
//

#import "MagotanIMRequest.h"

@implementation MagotanIMRequest

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

- (void)loadUserListWithUID:(NSString *)uid completion:(void (^)(id response))completion {
    
    __block XMRequest *req = nil;
    
    [XMCenter sendRequest:^(XMRequest *request) {
        
        request.api = @"index/index/loadUserList";
        request.parameters = nil;
        request.httpMethod = kXMHTTPMethodGET; // 可选，默认为 `POST`
        request.requestType = kXMRequestNormal; // 可选，默认为 `Normal`
        request.responseSerializerType = kXMResponseSerializerJSON;
        req = request;
        
    } onSuccess:^(id responseObject) {
        
        NSLog(@"%@请求内容：%@",req.api,responseObject);
        completion(responseObject);
        
    } onFailure:^(NSError *error) {
        
        NSLog(@"%@",error.description);
    }];
    
}
@end
