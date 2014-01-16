%token-table

%define api.pure
/*%define lr.type canonical-lr*/

%locations
%verbose
%debug

%code top {
	#import <Foundation/Foundation.h>
}

%code {
	#import "lex-scanner.h"

	extern void yyerror (YYLTYPE *locp, yyscan_t scanner, id * result, NSError ** error, char const *msg);
	
	#define YY_USER_ACTION yylloc->first_line = yylloc->last_line = yylineno; yylloc->first_column = yycolumn; yycolumn += yyleng; yylloc->last_column = yycolumn ;
}

%param { void * scanner }
%parse-param { id * result }
%parse-param { NSError ** error }

%token <string>		STRING
%token <number>		INTEGER
%token <number>		REAL
%token <number>		BOOLEAN
%token <object>		NULLVALUE

%type <object> file
%type <object> object
%type <string> string
%type <object> value
%type <number> number
%type <mutableArray> array
%type <mutableArray> value_list
%type <mutableDictionary> key_value_list

%union {
	NSObject *			object ;
	NSString *			string ;
	NSNumber *			number ;
	NSMutableArray *		mutableArray ;
	NSMutableDictionary *	mutableDictionary ;
}

%%

file:		object
		{
			*result = $1 ;
		}
		| array
		{
			*result = $1 ;
		}
;

key_value_list:		/* empty */
				{
					$$ = [ NSMutableDictionary dictionary ] ;
				}
				| key_value_list string ':' value
				{
					[ $1 setObject:$4 forKey:$2 ] ;
				}
				| key_value_list ',' string ':' value
				{
					[ $1 setObject:$5 forKey:$3 ] ;
				}
;

object:	'{' key_value_list '}'
		{
			$$ = $2 ;
		}
;

array:	'[' value_list ']'
		{
			$$ = $2 ;
		}
;

value_list:		/* empty */
			{ $$ = [ NSMutableArray array ] ; }
			| value_list value
			{ [ $$ addObject:$2 ] ; }
			| value_list ',' value
			{ [ $$ addObject:$3 ] ; }
;

string:		STRING
;

value:		BOOLEAN
			| STRING
			| number
			| NULLVALUE
			| object
			| array
			{
				$$ = $1 ;
			}
;

number:		INTEGER
			| REAL
;
