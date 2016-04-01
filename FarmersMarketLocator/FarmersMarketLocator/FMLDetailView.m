//
//  FMLDetailView.m
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/1/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "FMLDetailView.h"
#import "FMLMapViewController.h"

@implementation FMLDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _nameLabel = [self setUpLabelWithText:@"Greenhouse Farmer's Market" textColor:[UIColor blackColor]];
        _addressLabel = [self setUpLabelWithText:@"123 Easy Street, Manhattan, NY, 11002" textColor:[UIColor blackColor]];
        _arrowButton = [self setUpButton];
        _addressLabel.numberOfLines = 3;
    }
    [self addSubview:_nameLabel];
    [self addSubview:_addressLabel];
    [self addSubview:_arrowButton];
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
        blurView.frame = self.bounds;
        blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:blurView];
        [self sendSubviewToBack:blurView];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


-(UILabel *)setUpLabelWithText:(NSString *)text textColor:(UIColor *)color{
    
    //create new label using parameters
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.font = [UIFont fontWithName:@"Helvetica" size:16];
    label.textColor = color;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    return label;
}

-(UIButton *)setUpButton{
    
    //create button with down arrow image
    UIButton *button = [[UIButton alloc]init];
    UIImage *arrowImage = [UIImage imageNamed:@"down arrow"];
    [button setImage:arrowImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(hideButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    return button;
}

-(void)constrainViews {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.arrowButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.widthAnchor constraintEqualToAnchor:self.superview.widthAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor].active = YES;
    [self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor].active = YES;
    [self.heightAnchor constraintEqualToConstant:self.superview.frame.size.height / 5].active = YES;
    
    [self.arrowButton.topAnchor constraintEqualToAnchor:self.topAnchor constant:6].active = YES;
    [self.arrowButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    
    [self.nameLabel.topAnchor constraintEqualToAnchor:self.arrowButton.bottomAnchor constant:8].active = YES;
    [self.nameLabel.centerXAnchor constraintEqualToAnchor: self.centerXAnchor].active = YES;
    
    [self.addressLabel.topAnchor constraintEqualToAnchor:self.nameLabel.bottomAnchor constant:8].active = YES;
    [self.addressLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
}

-(void)hideButtonPressed {
    [self hideDetailView];
    MKCoordinateRegion region = self.previousRegion;
    NSValue *regionStruct = [NSValue value:&region withObjCType:@encode(MKCoordinateRegion)];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZoomBackOutKThxBai" object:regionStruct];
}

-(void)hideDetailView{
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height);
        
    } completion:nil];
}

-(void)showDetailView{
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
        
    } completion:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
