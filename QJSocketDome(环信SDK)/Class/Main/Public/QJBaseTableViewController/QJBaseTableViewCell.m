//
//  QJBaseTableViewCell.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/8.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "QJBaseTableViewCell.h"
#import "QJSwitchModel.h"
#import "QJArrowModel.h"

#define kDefaultSelectedBackground [UIColor colorWithWhite:0.85 alpha:1.0]

@interface QJBaseTableViewCell()

@property (nonatomic , strong) UILabel * hintLabel ;

@end

@implementation QJBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView * selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = kDefaultSelectedBackground;
    self.selectedBackgroundView = selectedBackgroundView ;
    
    [self.contentView addSubview:self.hintLabel];
    self.imageView.clipsToBounds = YES ;
    self.imageView.layer.cornerRadius = 3 ;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView * selectedBackgroundView = [[UIView alloc] init];
        selectedBackgroundView.backgroundColor = kDefaultSelectedBackground;
        self.selectedBackgroundView = selectedBackgroundView ;
        self.detailTextLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        
        [self.contentView addSubview:self.hintLabel];
        
        self.imageView.clipsToBounds = YES ;
        self.imageView.layer.cornerRadius = 3 ;
    }
    return self ;
}

-(void)setModel:(QJBaseModel *)model {
    
    _model = model ;
    
    [self.imageView setImage:model.image];
    self.textLabel.text = model.title ;
    self.hintLabel.text = model.hintText ;
    self.detailTextLabel.text = model.subTitle ;
    self.separatorInset = model.separatorInset ;
    
    // 设置 accessory
    self.accessoryType = UITableViewCellAccessoryNone ;
    if ([model isKindOfClass:[QJArrowModel class]]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
    } else if ([model isKindOfClass:[QJSwitchModel class]]) {
        UISwitch * switchView = [[UISwitch alloc] init];
        switchView.on = ((QJSwitchModel *)model).on ;
        [switchView addTarget:self action:@selector(switchViewDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.accessoryView = switchView ;
    }
    self.selected = NO ;
    
    [self layoutIfNeeded];
}

-(void)switchViewDidClicked:(UISwitch *)switchView {
    QJSwitchModel * model = (QJSwitchModel *)self.model ;
    switchView.on = !switchView.on ;
    if ([model.delegate respondsToSelector:@selector(switchModel:switchClicked:)]) {
        [model.delegate switchModel:model switchClicked:switchView];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.hintLabel sizeToFit];
    CGFloat w = self.hintLabel.frame.size.width ;
    CGFloat h = w > 10 ? self.hintLabel.frame.size.height : w ;
    CGFloat x = CGRectGetMaxX(self.textLabel.frame) + 10 ;
    CGFloat y = (self.frame.size.height - h)  / 2.0 ;
    self.hintLabel.frame = CGRectMake(x, y , w , h);
    self.hintLabel.layer.cornerRadius = h / 2 ;
}

#pragma mark - 懒加载
-(UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:12];
        _hintLabel.backgroundColor = [UIColor redColor];
        _hintLabel.textColor = [UIColor whiteColor];
        _hintLabel.textAlignment = UITextAlignmentCenter ;
        _hintLabel.clipsToBounds = YES ;
    }
    return _hintLabel ;
}

@end
