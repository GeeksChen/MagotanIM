
//
//  ChatCell.m
//  MagotanIM
//
//  Created by 新银河 on 2019/11/8.
//  Copyright © 2019 MJDev. All rights reserved.
//

#import "ChatCell.h"

@interface ChatCell ()


@end

@implementation ChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
    }
    return self;
}
- (void)setUpView {
    
    // 昵称
    UILabel *nicknameLabel = [[UILabel alloc] init];
    nicknameLabel.font = [UIFont boldSystemFontOfSize:17.f];    
    [self.contentView addSubview:nicknameLabel];
    self.nicknameLabel = nicknameLabel;

    // 正文
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor grayColor];
    contentLabel.font = [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
}

/**
 添加约束/更新约束
 */
-(void)updateConstraints{
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.contentView).offset(5);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.contentView).offset(-5);
    }];
    
    [super updateConstraints];
}
/**
 自动布局
 */
+(BOOL)requiresConstraintBasedLayout{
    return YES;
}
- (void)setFrame:(CGRect)frame
{
    
    [super setFrame:frame];
}
@end
