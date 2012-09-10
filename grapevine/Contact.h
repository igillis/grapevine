//
//  Contact.h
//  grapevine
//
//  Created by Brian Cohen on 9/5/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic) BOOL following;

-(id) initWithName:(NSString*) name;

@end
