int: i = 8;
float: money = 56986.06523848742;

int: n = 20;
%int: m = 16;

array[1..n] of float: gold7 ;
array[1..n] of float: stock7 ;

array[1..n] of float: gold30 ;
array[1..n] of float: stock30 ;
array[1..n] of float: bonds30 ; % an array of 5 elements which are 1.054 percent

var int : C17;
var int : C27;


constraint C17 >=0 ;
constraint C27 >=0 ;

%constraint C17 <=1 ;
%constraint C27 <=1 ;

constraint C17 + C27  = 1; %choose one option or dont choose at all
%var float: Objective =  money - (C17*(1 - stock7[i])*money + C27*(1 - gold7[i])*money) ;
var float: Objective = (  C17*stock7[i]*money + C27*gold7[i]*money);

solve maximize Objective;


