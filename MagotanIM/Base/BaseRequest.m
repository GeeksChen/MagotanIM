//
//  BaseRequest.m
//  MagotanIM
//
//  Created by 新银河 on 2019/10/30.
//  Copyright © 2019 MJDev. All rights reserved.
//

#import "BaseRequest.h"

@implementation BaseRequest

- (instancetype)init {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    http://localhost/MagotanIM/public/index/index/loadUserList
    // 网络请求全局配置
    [XMCenter setupConfig:^(XMConfig *config) {
        config.generalServer = @"http://192.168.1.60/MagotanIM/public/";
        config.generalHeaders = nil;
        config.generalParameters = nil;
        config.generalUserInfo = nil;
        config.callbackQueue = dispatch_get_main_queue();
#ifdef DEBUG
        config.consoleLog = YES;
#endif
    }];
    
    // 对域名下的接口做 SSL Pinning 验证
    //    [XMCenter addSSLPinningURL:BEBSocketBaseUrl];
    //    [XMCenter addSSLPinningURL:BEBWebBaseUrl];
    //
    //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"bihao" ofType:@"cer"];//证书的路径
    //    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    //    [XMCenter addSSLPinningCert:cerData];
    
    // 请求预处理插件
    [XMCenter setRequestProcessBlock:^(XMRequest *request) {
        // Do the custom request pre processing logic by yourself.
    }];
    
    // 响应后处理插件
    // 如果 Block 的返回值不为空，则 responseObject 会被替换为 Block 的返回值
    [XMCenter setResponseProcessBlock:^id(XMRequest * _Nonnull request, id  _Nullable responseObject, NSError *__autoreleasing  _Nullable * _Nullable error) {
        // Do the custom response data processing logic by yourself.
        // You can assign the passed in `error` argument when error occurred, and the failure block will be called instead of success block.
        NSLog(@"%@",responseObject);
        
        return responseObject;
    }];
    
    // 错误统一过滤处理
    [XMCenter setErrorProcessBlock:^(XMRequest *request, NSError *__autoreleasing * error) {
        
        // 比如对不同的Error Code统一错误提示等
        NSLog(@"XMNetwork Error:====%@",request);
        
    }];
    
    return self;
}
@end
