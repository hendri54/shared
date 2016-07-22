function FtpTargetTest

lhS = const_lh;

disp('Testing FtpTarget');

kS = filesLH.FtpTarget;
kS.testMode = true;
kS.is_mounted;
kS.upload_shared_code;

testDir = lhS.localS.testFileDir;
kS.updownload(testDir, testDir, 'up');

end