% Number of observations
int: N = 800;
%int: N;
% Observed data (features)
array[1..N] of float: X;

% Target values
array[1..N] of float: Y;

% Weights to fit (slope and intercept)
var float: W_slope;
var float: W_intercept;

% Calculate squared error
array[1..N] of var float: Est;
%array[1..N] of var int: Est = [W_slope * X[i] + W_intercept - Y[i] | i in 1..N];
constraint forall(i in 1..N) (Est[i] >= W_slope * X[i] + W_intercept - Y[i]);
constraint forall(i in 1..N) (Est[i] >= Y[i] - W_slope * X[i] - W_intercept);
%array[1..N] of var int: Err = [Est[i] - Y[i] | i in 1..N];

% Objective function: Minimize the sum of squared errors
%var int: Objective = sum(i in 1..N)(Err[i]*Err[i]);
var float: Objective = sum(i in 1..N)(Est[i]);

% Solve the linear regression problem
solve minimize Objective;

% Output the Weight vector (slope and intercept)
output ["slept =" ,show(W_slope),"intercept =" , show(W_intercept), "Objective: ", show(Objective)];
