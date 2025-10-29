int: i = 13;
float: money = 57396.90982609695;

int: n = 20;
%int: m = 4;

array[1..n] of float: gold7 ;
array[1..n] of float: stock7 ;

array[1..n] of float: gold30 ;
array[1..n] of float: stock30 ;
array[1..n] of float: bonds30 ; % an array of 5 elements which are 1.054 percent


var int : C33;
var int : C13;
var int : C23;
constraint C13 >=0 ;
constraint C23 >=0 ;
constraint C33 >=0 ;
constraint  C33 + C13 + C23 = 1; %choose one option
var float: Objective = ( C33*bonds30[i]*money + C13*stock30[i]*money + C23*gold30[i]*money);

solve maximize Objective;


