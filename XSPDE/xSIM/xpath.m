
function [a,av,raw] = xpath(a,nc,r)
%   [a,data,astore] = XPATH(a,nc,r) solves stochastic equation trajectories.
%   Initial condition is the 'a' field, returned value 'a' is the final field.
%   Input parameters in the 'r' structure including equation function handles.
%   Input 'nc' indicates the check index.
%   Output 'a' is the propagated field, 'o' contains averages and errors, 
%   'raw' is the raw trajectories.
%   xSPDE functions are licensed by Peter D. Drummond, (2015) - see License

      %%Initialize stored data
raw = 0;
av = cell(1,r.averages);
if r.raw                                       %%if store fields                                     
  raw = zeros(r.d.raw);                        %%initialize storage
end                                            %%end if field stored
for  n = 1:r.averages
    av{n} = zeros(r.d.av{n});
end
a(r.fields+1:r.fieldsplus,:) = r.define(a,zeros(r.d.noises),r);
      %%Loop over all the time points
totsteps = r.steps*r.errorchecks;
for np = 1:r.points(1);                        %%loop until time tmax
  if np > 1                                    %%If NOT first point 
      
      %%Loop over steps within a time point
    
    for step = 1:totsteps;                     %%loops over step 
      z = r.noisegen(r);                       %%Calculate  noise
      if (nc<r.errorchecks)&&(step>2*floor(step/2)) %%If low res  & odd
          z1 = z;                              %%Stores noise 
      else                                     %%Else do integration
          if (nc < r.errorchecks)              %%If low res check, even
              z = (z + z1)/2.;                 %%Average noise terms 
          end                                  %%End if low res check
          a=[a(1:r.fields,:);r.define(a,z,r)];
          a = r.step(a,z,r);                   %One step integration
          r.t = r.t+r.dtr;                     %%Increment time
      end                                      %%End if low res  & odd
    end                                        %%End for steps
  end                                          %%End if NOT first point
  
      %%Store data for the time point

  if r.raw         
      astore = reshape(a,r.d.fieldsplus);
      raw(:,:,np,:) = astore(:,:,1,:);
  end                                          %%end if store data
  for n = 1:r.averages
        av{n}(:,:,np,:) = xdata(a,n,r);        %%store time-domain data
  end
end                                            %%end time loop
end                                            %%end trajectory function

function av = xdata(a,n,r)  
%   av = XDATA(a,n,r) stores data averages from an equation trajectory.
%   Input is the 'a' field of stochastic variables, stored in parallel.
%   Input index n gives the number of the observe function.
%   Input parameters in the 'r' structure include observe function handles.
%   Returned array 'av' is the average observable array, at current time.
%   xSPDE functions are licensed by Peter D. Drummond, (2015) - see License
 
trans = r.transforms{n};                       %%transform switch
if sum(trans(2:r.dimension))>0                 %%if transform needed
    a = xgraphicsfft(a,trans,r);               %%Fourier transform
end                                            %%no transform needed
o1 = r.observe{n}(a,r);                        %%Get stochastic observable
av = mean(reshape(o1,r.d.obs{n}),2);           %%Take average
end                                            %%end function
                