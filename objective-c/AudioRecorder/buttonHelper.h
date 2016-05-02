//
//  buttonHelper.h
//  AudioRecorder
//
//  Created by david roman on 5/1/16.
//  Copyright © 2016 davidsdemos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface buttonHelper : UIButton{
    UIView *parent;
    
}



-(id) initWithRect:(CGRect )_frame : (UIView *)_parent;

-(void) setTitle:(NSString *)_title;

-(void) setBackgroundcolor:(NSString *)_color;


@end
