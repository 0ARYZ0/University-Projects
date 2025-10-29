int: i = 20;
float: money = 63389.6824476876;

int: n = 20;
%int: m = 16;

array[1..n] of float: gold7 ;
array[1..n] of float: stock7 ;

array[1..n] of float: gold30 ;
array[1..n] of float: stock30 ;
array[1..n] of float: bonds30 ; % an array of 5 elements which are 1.054 percent

var int : C17;
var int : C27;
var int : C33;

constraint C17 >=0 ;
constraint C27 >=0 ;
constraint C33 >=0 ;
constraint C17 + C27 + C33 = 1; %choose one option
var float: Objective =  C17*stock7[i]*money + C27*gold7[i]*money + C33*bonds30[i]*money ;

solve maximize Objective;


