//
//  ViewController.m
//  LocalizedTool-iOS
//
//  Created by xaoxuu on 27/12/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "ViewController.h"
#import "LocalizedTool.h"
#import <AXKit/AXKit.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapped:(UIButton *)sender {
    NSString *path = [LocalizedTool mergeLocalizedStringFile];
    self.textView.text = path;
    AXLogSuccess(@"%@", path);
}


@end
