function tests = KureLHtest

tests = functiontests(localfunctions);

end

function constructorTest(testCase)
   clusterV = {'killdevil', 'longleaf'};
   
   for i1 = 1 : length(clusterV)
      kS = KureLH(clusterV{i1}, 'testMode', true);
      assert(isa(kS.is_mounted, 'logical'));
      assert(isa(kS.make_remote_dir('/Users/lutz'), 'char'));
      kS.upload_shared_code;
      kS.updownload_command('/Users/lutz', [], 'up');
   end
end


%% Command to run on cluster (e.g. sbatch)
function commandTest(testCase)
   serverStr = {'killdevil', 'longleaf'};
   for i1 = 1 : length(serverStr)
      kS = KureLH(serverStr{i1});
      suffixStr = 'rs5';
      argV = {1, 'test'};
      jobNameStr = 'jobName';
      logStr = 'test_log.out';
      nCpus = 8;
      cmdStr = kS.command(suffixStr, argV, jobNameStr, logStr, nCpus)
   end
end

