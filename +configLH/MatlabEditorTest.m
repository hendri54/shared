function MatlabEditorTest

compS = configLH.Computer([]);
fileName = fullfile(compS.testFileDir, 'editor_state');

meS = configLH.MatlabEditor;

sS = meS.get_state;

meS.save_state(fileName);
s2S = meS.load_state(fileName);
assert(isequal(sS, s2S));

meS.restore_state(fileName);


end