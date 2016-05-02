//
//  buttonHelper.m
//  AudioRecorder
//
//  Created by david roman on 5/1/16.
//  Copyright © 2016 davidsdemos. All rights reserved.
//

#import "buttonHelper.h"

@implementation buttonHelper

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

 
}
*/



-(id) initWithRect:(CGRect )_frame : (UIView *)_parent {
    if (self = [super init]) {
        /*  */
        
        [self setFrame:_frame];
        
        [_parent addSubview:self];
        
        self.backgroundColor = [UIColor redColor];
        
        self.layer.cornerRadius = 7.0;
        
        self->parent = _parent;
        
        

    }
    return(self);
    
    
}

-(void)setTitle:(NSString *)_title{
    [self setTitle:_title forState:UIControlStateNormal];

}


-(void)setBackgroundcolor:(NSString *)_color{
    
    self.backgroundColor = [self colorFromHexString:_color];
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}




@end
