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
							yylval->string = [ [ NSMutableString alloc ] init ] ;
						}
<expect_string>\\.			CFStringAppendCString( (CFMutableStringRef)yylval->string, yytext, kCFStringEncodingUTF8 ) ;
<expect_string>\"			{
							BEGIN(INITIAL);
							return STRING ;
						}
<expect_string>.|\n			CFStringAppendCString( (CFMutableStringRef)yylval->string, yytext, kCFStringEncodingUTF8 ) ;

\/\/.*$					/* eat line comment */

{INTEGER}				{
							yylval->number = @( strtoll( yytext, &(char*){0}, 10 ) ); return INTEGER ;
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
