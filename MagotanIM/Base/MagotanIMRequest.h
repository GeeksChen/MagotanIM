//
//  MagotanIMRequest.h
//  MagotanIM
//
//  Created by 新银河 on 2019/10/30.
//  Copyright © 2019 MJDev. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MagotanIMRequest : BaseRequest

+ (instancetype)sharedInstance;

- (void)loadUserListWithUID:(NSString *)uid completion:(void (^)(id response))completion;

@end

NS_ASSUME_NONNULL_END
