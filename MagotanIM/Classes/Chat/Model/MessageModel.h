//
//  MessageModel.h
//  MagotanIM
//
//  Created by 新银河 on 2019/10/30.
//  Copyright © 2019 MJDev. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageModel : JSONModel

@property (nonatomic,strong)NSString *toUser;
@property (nonatomic,strong)NSString *fromUser;
@property (nonatomic,strong)NSString *msg;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *ext;

@end

NS_ASSUME_NONNULL_END
