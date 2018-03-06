{
module Grammar where
import Tokens


}


%name killme
%tokentype { Token }
%error { parseError }
%token
    '='     { TokenEq _ } 
    ','     { TokenComma _ } 
    and     { TokenAnd _ } 
    where   { TokenWhere _ } 
    '('     { TokenLBracket _ } 
    ')'     { TokenRBracket _ } 
    int     { TokenInt _ $$ }
    var     { TokenVar _ $$ }
    
%right where
%left and ','
%nonassoc '(' ')'
%%

Exp : Numbers where Pred {ExpNorm $1 $3}

Numbers : int ',' Numbers {Number $1 $3}
        | int             {NumberEnd $1}

Pred : Pred and Pred {PredAnd $1 $3}
     | var '(' Numbers ')' {PredSource $1 $3}
     | int '=' int {PredEq $1 $3}

{

parseError :: [Token] -> a
parseError _ = error "Parse error"

data Exp = ExpNorm Numbers Pred deriving Show

data Numbers = Number Int Numbers
    | NumberEnd Int deriving Show

data Pred = PredAnd Pred Pred
    | PredSource String Numbers
    | PredEq Int Int deriving Show
}