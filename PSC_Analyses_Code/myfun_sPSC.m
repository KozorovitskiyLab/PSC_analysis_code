function y = myfun_sPSC(Para,x)
%%%%%% Exponential fitting

y = Para(1) + Para(2)*exp(-x/Para(3));