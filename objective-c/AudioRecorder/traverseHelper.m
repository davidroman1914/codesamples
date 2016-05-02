//
//  traverseHelper.m
//  AudioRecorder
//
//  Created by david roman on 5/1/16.
//  Copyright © 2016 davidsdemos. All rights reserved.
//

#import "traverseHelper.h"


@implementation traverseHelper



-(id) init{
    if (self = [super init]) {
        
    }
    return(self);
}





-(UIButton *)getButtonByName:(NSString *)_name :(UIView *)_parent{
    
    UIButton *tmpButton;
    
    for ( UIButton * button in _parent.subviews ) {
        
        if ([button.layer.name isEqualToString:_name]) {
            
            return tmpButton = button;
        }
        
    }
    
    return  tmpButton;
    
}


@end
