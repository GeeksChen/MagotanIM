//
//  RoomModel.h
//  MagotanIM
//
//  Created by 新银河 on 2019/11/9.
//  Copyright © 2019 MJDev. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomModel : JSONModel

@property (nonatomic,strong)NSString *number;
@property (nonatomic,strong)NSString *title;


@end

NS_ASSUME_NONNULL_END
