//
//  mJSON.h
//  mJSON
//
//  Created by Niels Gabel on 10/17/13.
//
//

#import <Foundation/Foundation.h>

@interface mJSONParser : NSObject

+(id)objectFromData:(NSData*)data ;
+(id)objectFromData:(NSData*)data error:(NSError**)error ;

@end
