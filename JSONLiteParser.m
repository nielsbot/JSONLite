//
//  JSONLite.m
//  JSONLite
//
//  Created by Niels Gabel on 10/17/13.
//
//

#import "JSONLiteParser.h"
#import "y.tab.h"
#import "lex-scanner.h"

@implementation JSONLiteParser

+(id)objectFromData:(NSData*)data error:(NSError**)error ;
{
//	NSError * error = nil ;
	id result = nil ;
	
	if ( data.length > 0 )
	{
		yyscan_t scanner = NULL ;
		
		BOOL ok = 0 == yylex_init(&scanner) ;
		
		YY_BUFFER_STATE buffer = NULL ;
		if ( ok )
		{
			NSMutableData * mutableData = [ data mutableCopy ]  ;
			[ mutableData appendBytes:&(uint32_t){0} length:sizeof( uint32_t ) ] ;
			
			buffer = yy_scan_string( [ mutableData bytes ], scanner ) ;
			[ mutableData release ] ;
			
			ok = buffer != NULL ;
		}
		
		if ( ok )
		{
			// debug Bison:
//			yydebug = 1 ;
			
			// debug Flex:
//			yyset_debug( 1, scanner) ;
			
			/*BOOL success = 0 ==*/ yyparse( scanner, & result, error ) ;
//			if ( success && result )
//			{
//				printf( "%s\n", [ [ result description ] UTF8String ] ) ;
//			}
		}
		
		if ( scanner )
		{
			yylex_destroy(scanner);
		}
	}
		
	return result ;
}

+(id)objectFromData:(NSData*)data
{
	return [[ self class ] objectFromData:data error:NULL ] ;
}

@end
