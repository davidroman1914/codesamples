//
//  ViewController.h
//  AudioRecorder
//
//  Created by david roman on 5/1/16.
//  Copyright © 2016 davidsdemos. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

#import "buttonHelper.h"

#import "traverseHelper.h"

@interface ViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>{
 
    
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    
    traverseHelper *traversehelper;
    

    
}


@end

