%{
	#import <Foundation/Foundation.h>
	
	#import "y.tab.h"
	
	#define YY_USER_ACTION yylloc->first_line = yylloc->last_line = yylineno;
%}

%option reentrant bison-bridge bison-locations noyywrap
%option debug
%option yylineno

%x expect_string

REAL				-?(0|[1-9]+)\.[0-9]+(e[+-]?[0-9]+)?
INTEGER				-?(0|[1-9]+)+(e[+-]?[0-9]+)?
STRING				[a-zA-Z][a-zA-Z0-9_-]*

%%

\"						{
							BEGIN(expect_string);
							yylval->mutableData = [ NSMutableData data ] ;
						}
<expect_string>\\u[0-9a-fA-F]{4}	[ yylval->mutableData appendBytes:&(uint16_t){ strtol( &yytext[2], NULL, 16 ) } length:sizeof( uint16_t ) ] ;
<expect_string>\\n				[ yylval->mutableData appendBytes:&"\n" length:1 ] ;
<expect_string>\\r				[ yylval->mutableData appendBytes:&"\r" length:1 ] ;
<expect_string>\\\"				[ yylval->mutableData appendBytes:&"\"" length:1 ] ;
<expect_string>\\\\				[ yylval->mutableData appendBytes:&"\\" length:1 ] ;
<expect_string>\"			{
							BEGIN(INITIAL);
							NSMutableData * data = yylval->mutableData ;
							yylval->string = [ [ NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding ] ;
							[ yylval->string autorelease ] ;
							return STRING ;
						}
<expect_string>.|\n			[ yylval->mutableData appendBytes:yytext length:1 ] ;

\/\/.*$					/* eat line comment */

{INTEGER}				{
							yylval->number = @( strtoll( yytext, &(char*){0}, 0 ) ); return INTEGER ;
						}
{REAL}					{
							yylval->number = @( strtod( yytext, &(char*){0} )); return REAL ;
						}
(?i:null)					{
							return NULLVALUE ;
						}
(?i:true)					{
							yylval->number = @YES; return BOOLEAN ;
						}
(?i:false)					{
							yylval->number = @NO; return BOOLEAN ;
						}
{STRING}					{
							yylval->string = [ NSString stringWithCString:yytext encoding:NSUTF8StringEncoding ] ;
							return STRING ;
						}
[[:space:]]					/* eat whitespace */
.						return yytext[0];
