//
//  UserModel.h
//  MagotanIM
//
//  Created by 新银河 on 2019/10/30.
//  Copyright © 2019 MJDev. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : JSONModel

@property (nonatomic,strong)NSString *userid;
@property (nonatomic,strong)NSString *connectid;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *roomid;

@end

NS_ASSUME_NONNULL_END
