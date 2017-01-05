% UNIX SBatch methods
classdef SBatch
   
properties
   % Number of days of runtime
   nDays = 7
   % GB of ram to request
   memoryGb = 16;
   % Email at end of job
   emailAtEnd  logical  =  true
end
   
methods
   %% Create a string that can be submitted to run matlab on kure
   %{
   IN
      jobNameStr :: char
         name of job, so we can identify what is running
      nCpus
         no of cpus to run on
      mFileStr
         the command to be run, including parameters
         e.g. run_batch('fminsearch', 1)
      logStr
         log file name, e.g. set1.out
   %}
   function cmdStr = command(lS, jobNameStr, mFileStr, logStr, nCpus)
      assert(ischar(logStr));
      validateattributes(nCpus, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', 'positive', 'scalar'})
      
      % logStr = ' -o out.%J.n24 ';
      matlabStr = [' --wrap="matlab -nodesktop -nosplash -singleCompThread -r ',  mFileStr, '" '];
         % ' -logfile ',  logStr,  '" '];

      nCoresStr = sprintf(' -n %i ',  nCpus);
      memStr  = sprintf(' --mem %i ', lS.memoryGb .* 1024);
      timeStr = sprintf(' -t %0i-00 ', lS.nDays);
      logFileStr = sprintf(' -o "%s" ', logStr);
      if lS.emailAtEnd
         emailStr = ' --mail-type=end  --mail-user=lhendri@email.unc.edu ';
      else
         emailStr = '';
      end
      
      if isempty(jobNameStr)
         nameStr = '';
      else
         assert(ischar(jobNameStr));
         nameStr = [' -J "', jobNameStr, '" '];
      end
      
      cmdStr = ['sbatch -p general -N 1 ', nameStr, timeStr, memStr, nCoresStr, emailStr, logFileStr,  matlabStr];

      clipboard('copy', cmdStr);

   end


end

end