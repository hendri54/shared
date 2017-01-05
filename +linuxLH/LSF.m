% UNIX LSF methods
classdef LSF
   
methods
   %% Create a string that can be submitted to run matlab on kure
   %{
   IN
      nCpus
         no of cpus to run on
      mFileStr
         the command to be run, including parameters
         e.g. run_batch('fminsearch', 1)
      logStr
         log file name, e.g. set1.out
   %}
   function cmdStr = command(lS, mFileStr, logStr, nCpus)

   if nCpus == 1 
      bsubStr = 'bsub matlab -nodisplay -nosplash -singleCompThread -r ';
   else
      parallelStr = sprintf(' -n %i -R "span[hosts=1]" ',  nCpus);
      bsubStr = ['bsub ', parallelStr, ' matlab -nodisplay -nosplash -singleCompThread -r '];
   end

   cmdStr = [bsubStr,  '"',  mFileStr, '"  ',  logStr];

   clipboard('copy', cmdStr);

   end


end

end