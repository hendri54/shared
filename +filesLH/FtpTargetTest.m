function FtpTargetTest

lhS = const_lh;

disp('Testing FtpTarget');

kS = filesLH.FtpTarget('testMode', false);
isMounted = kS.is_mounted;

if isMounted
   kS.upload_shared_code;

   testDir = lhS.localS.testFileDir;
   kS.updownload(testDir, testDir, 'up');
else
   warning('Cannot test upload / download unless KURE is mounted as drive');
end

end