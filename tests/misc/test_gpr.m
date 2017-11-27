% Test file for gpr.m.

function pass = test_gpr( pref )

% Generate a few random points to use as test values.
seedRNG(20);
xx = 2 * rand(100, 1) - 1;
% The values to match
yy = exp(xx).*sin(2*xx);

[f,~,fsamples] = gpr(xx,yy,'samples',2);

% test the accuracy of the posterior mean
err = norm(f(xx) - yy,Inf);
pass(1) = err < 1e-6;

% test the accuracy of the samples
err = norm(fsamples(xx,1) - yy, Inf);
pass(2) = err < 5e-4;

err = norm(fsamples(xx,2) - yy, Inf);
pass(3) = err < 5e-4;

% test adding noise to the data
yy = yy + .1*randn(size(yy));
f = gpr(xx,yy,'noise',.1);
pass(4) = std(f(xx)-yy) < .2;

% scaling tests
xx = 2e-100*rand(10,1)-1e-100;
yy = randn(10,1);
f = gpr(xx,yy);
err = norm(f(xx) - yy,Inf);
pass(5) = err < 1e-6;

yy = 1e100*randn(10,1);
f = gpr(xx,yy);
err = norm(f(xx) - yy,Inf)/norm(f(xx),Inf);
pass(6) = err < 1e-6;

xx = 2*rand(10,1)-1;
yy = 1e-100*rand(10,1);
f = gpr(xx,yy,'hyperparams',[1,.1]);
err = norm(f(xx) - yy,Inf)/norm(f(xx),Inf);
pass(7) = err < 1e-6;

end
