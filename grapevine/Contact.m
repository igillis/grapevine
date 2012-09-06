//
//  Contact.m
//  grapevine
//
//  Created by Brian Cohen on 9/5/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "Contact.h"


@implementation Contact
@synthesize name = name_;
@synthesize following = following_;

-(id) init {
    return [self initWithName:@""];
}


-(id) initWithName:(NSString*) name {
    self = [super init];
    if(!self) { return nil; }
    name_ = name;
    following_ = NO;
    return (self);
}


@end
