function [error,input,data,raw] = xspde(input)       
%   [error,input,data,raw] = XSPDE(input) is the xSPDE control function.
%   Input:  input cell array of simulation parameter structures, 'input'.
%   Output: sum of step-size, sampling, comparison errors, labeled 'error',
%   copy of input cell array including preferences, labeled 'input',
%   data cell array of average data, raw data labeled 'data' and 'raw'.
%   licensed by Peter D. Drummond, (2015) - see License.txt 

fprintf ('\nxSPDE starting up...\n\n');          %%Start-up message
[errorsim,input,data,raw] = xsim(input);         %%Simulation program
errorgraph = xgraph(data,input);                 %%Graphics program   
error = errorgraph+errorsim;                     %%calculate total error

fprintf ('\nxSPDE error score = %e, time = %f \n\n',error) 
end                                              %%End simulation program