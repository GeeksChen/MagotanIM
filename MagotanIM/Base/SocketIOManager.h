//
//  SocketIOManager.h
//  MagotanIM
//
//  Created by 新银河 on 2019/10/30.
//  Copyright © 2019 MJDev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SocketIOManager : NSObject

+ (instancetype)sharedInstance;

- (void )connectSocketIO;

- (void )onOrder:(NSString *)order completion:(void (^)(id response))completion;

- (void )emitOrder:(NSString *)order with:(NSDictionary *)dic;

- (void )disconnectSocketIO;



@end

NS_ASSUME_NONNULL_END
