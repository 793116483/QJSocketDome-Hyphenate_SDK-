//
//  QJMeHeaderView.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/9.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJMeHeaderView.h"
@interface QJMeHeaderView ()

@property (nonatomic , strong) UIImageView * iconView ;
@property (nonatomic , strong) UILabel * nameLabel ;
@property (nonatomic , strong) UILabel * accountLabel ;

@end

@implementation QJMeHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
        
        self.iconView = [[UIImageView alloc] init];
        self.iconView.clipsToBounds = YES ;
        self.iconView.layer.cornerRadius = 4 ;
        self.iconView.contentMode = UIViewContentModeScaleAspectFit ;
        [self addSubview:self.iconView];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
        [self addSubview:self.nameLabel];
        
        self.accountLabel = [[UILabel alloc] init];
        self.accountLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        self.accountLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:self.accountLabel];
        
        // 布局
        __weak typeof(self) weakSelf = self ;
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf);
            make.left.equalTo(weakSelf).offset(20);
            make.height.offset(60);
            make.width.offset(60);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.iconView.mas_top);
            make.left.equalTo(weakSelf.iconView.mas_right).offset(10);
        }];
        [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.iconView.mas_bottom);
            make.left.equalTo(weakSelf.iconView.mas_right).offset(10);
        }];
    }
    return self ;
}

-(void)setUser:(QJUserModel *)user {
    _user = user ;
    
    self.nameLabel.text = user.name ;
    self.accountLabel.text = [NSString stringWithFormat:@"微信号: %@",user.account];
    self.iconView.image = [UIImage imageNamed:user.iconUrlStr];
}


@end
