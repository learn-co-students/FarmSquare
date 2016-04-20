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
        _produceTextView = [self setUpProduceTextViewWithText:@"Fruits and Vegetables"
                                                 textColor:[UIColor blackColor]];
        _scheduleLabel = [self setUpLabelWithText:@"Mon-Fri 7am-4pm" textColor:[UIColor blackColor]];
        _yelpButton = [self setUpButtonWithImageName:@"yelp_review_btn_red" action:@selector(yelpButtonPressed)];
        _directionsButton = [self setUpButtonWithImageName:@"direction24px" action:@selector(directionsButtonPressed)];
    }
    [self addSubview:_produceTextView];
    [self addSubview:_scheduleLabel];
    [self addSubview:_yelpButton];
    [self addSubview:_directionsButton];
    
    self.backgroundColor = [UIColor whiteColor];
    [self setBorder];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideButtonPressed)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipe];
    return self;
}

/*
func setBorder() {
    let width = CGFloat(10.0)
    border.borderColor = UIColor(colorLiteralRed: 38/255.0, green: 89/255.0, blue: 15/255.0, alpha: 1.0).CGColor
    border.frame = CGRect(x: -width, y:  self.frame.size.height-width, width: self.frame.size.width + 2*width, height: self.frame.size.height)
    border.borderWidth = width
    self.layer.addSublayer(border)
    self.layer.masksToBounds = true
}
*/

-(void)setBorder {
    UIView *fauxBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 10.0)];
    fauxBorder.backgroundColor = [UIColor colorWithRed:38/255.0 green:89/255.0 blue:15/255.0 alpha:1.0];
    fauxBorder.translatesAutoresizingMaskIntoConstraints = NO;
    self.border = fauxBorder;

    [self addSubview:self.border];
    
    [self.border.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.border.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.border.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
    [self.border.heightAnchor constraintEqualToConstant:10.0].active = YES;
}


-(UILabel *)setUpLabelWithText:(NSString *)text textColor:(UIColor *)color {
    
    //create new label using parameters
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.font = [UIFont fontWithName:@"Helvetica" size:16];
    label.textColor = color;
    label.numberOfLines = 0;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    return label;
}

-(UITextView *)setUpProduceTextViewWithText:(NSString *)text textColor:(UIColor *)color {
 
    //create TextView to display produce list
    UITextView *textView = [[UITextView alloc]init];
    textView.text = text;
    textView.font = [UIFont fontWithName:@"Helvetica" size:16];
    textView.textColor = color;
    textView.editable = NO;
    textView.selectable = YES;
    textView.scrollEnabled = YES;
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    textView.backgroundColor = [UIColor clearColor];
    return textView;
}

-(UIButton *)setUpButtonWithImageName:(NSString *)imageName action:(SEL)action {
    
    //method modified to create all buttons
    UIButton *button = [[UIButton alloc]init];
    UIImage *buttonImage = [UIImage imageNamed:imageName];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    return button;
}

-(void)constrainViews {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.produceTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scheduleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.yelpButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.directionsButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.widthAnchor constraintEqualToAnchor:self.superview.widthAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor].active = YES;
    [self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor].active = YES;
    [self.heightAnchor constraintEqualToConstant:self.superview.frame.size.height * 0.3].active = YES;

    
    [self.scheduleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:13].active = YES;
    [self.scheduleLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20].active = YES;
    [self.scheduleLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    
    CGFloat textViewPadding = 30; //30 here, makes it perfectly alligned with text labels!!!
    CGFloat textViewWidth = self.bounds.size.width - textViewPadding;
    CGFloat textViewHeight = self.bounds.size.height * 0.3;
    [self.produceTextView.topAnchor constraintEqualToAnchor:self.scheduleLabel.bottomAnchor constant:3].active = YES;
    [self.produceTextView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.produceTextView.widthAnchor constraintEqualToConstant:textViewWidth].active = YES;
    [self.produceTextView.heightAnchor constraintEqualToConstant:textViewHeight].active = YES;
    
    [self.yelpButton.topAnchor constraintEqualToAnchor:self.produceTextView.bottomAnchor constant:5].active = YES;
    [self.yelpButton.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20].active = YES;
    
    [self.directionsButton.topAnchor constraintEqualToAnchor:self.produceTextView.bottomAnchor constant:5].active = YES;
    [self.directionsButton.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    
}

-(void)hideButtonPressed {
    [self hideDetailView];
    MKCoordinateRegion region = self.previousRegion;
    NSValue *regionStruct = [NSValue value:&region withObjCType:@encode(MKCoordinateRegion)];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZoomBackOutKThxBai" object:regionStruct];
    
}

-(void)hideDetailView {
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height);
    } completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwiperNoSwiping" object:nil];
}

-(void)showDetailView {
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

-(void)yelpButtonPressed {
    
    NSString *nameForSearch = [self.name.lowercaseString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    //http://www.yelp.com/search?find_desc=hernandez+farmer%27s+market&find_loc=10004
    NSString *yelpSearchURL = [NSString stringWithFormat:@"http://www.yelp.com/search?find_desc=%@&find_loc=%@", nameForSearch, self.zip];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:yelpSearchURL]];
}

-(void)directionsButtonPressed {
    
    CLLocationCoordinate2D currentLocation = self.locationManager.location.coordinate;
    
    NSString *directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f", currentLocation.latitude, currentLocation.longitude, self.selectedLatitude, self.selectedLongitude];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:directionsURL]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
