function LatexTableLHtest

disp('Testing LatexTableLH');
lhS = const_lh;

nr = 4;
nc = 3;
rowHeaderV = stringLH.vector_to_string_array(1 : nr, 'Row%i');
colHeaderV = stringLH.vector_to_string_array(1 : nc, 'Var%i');
filePath = fullfile(lhS.dirS.testFileDir,  'LatexTableLHtest.tex');

tS = LatexTableLH(nr, nc, 'filePath', filePath, 'rowHeaderV', rowHeaderV, 'colHeaderV', colHeaderV);

ir = nr-1;
ic = nc-1;
[ir2, ic2] = tS.find(rowHeaderV{ir}, colHeaderV{ic});
assert(isequal([ir2, ic2], [ir, ic]));

tS.fill(ir, ic, 'test1');
assert(isequal(tS.tbM{ir, ic},  'test1'));

tS.fill_row(ir, 1 : nc, '%i');
tS.fill_col(ic, 1 : nr, '%i');

tS.write_table;
tS.cell_table;
tS.write_text_table;


end