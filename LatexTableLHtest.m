function tests = LatexTableLHtest
   tests = functiontests(localfunctions);
end

function oneTest(tS)
   nr = 4;
   nc = 3;
   tbS = init_table(nr, nc, 1, 'LatexTableLH1');
   
   ir = nr-1;
   ic = nc-1;
   [ir2, ic2] = tbS.find(tbS.rowHeaderV{ir}, tbS.colHeaderV{ic});
   assert(isequal([ir2, ic2], [ir, ic]));

   tbS.fill(ir, ic, 'test1');
   assert(isequal(tbS.tbM{ir, ic},  'test1'));

   tbS.fill(ir, ic, "test1");
   tS.verifyEqual(tbS.tbM{ir, ic},  'test1');
   
   tbS.fill_row(ir, 1 : nc, '%i');
   tbS.fill_col(ic, 1 : nr, '%i');
   
   rowStrV = stringLH.vector_to_strings(1 : nc,  '%i');
   tbS.fill_row(ir, rowStrV, []);
   for ic = 1 : nc
      tS.verifyEqual(tbS.get(ir, ic),  char(rowStrV(ic)));
   end

   tbS.write_table;
   tbS.cell_table;
   tbS.write_text_table;
end


%% Fill entire table
function fillTest(tS)
   nr = 4;
   nc = 3;
   tbS = init_table(nr, nc, 1, 'LatexTableLH2');
   
   dataM = randn([nr, nc]);
   tbS.fill_body(dataM, '%.3g');
   tbS.write_text_table;
   
   textM = cell([nr, nc]);
   for ir = 1 : nr
      for ic = 1 : nc
         textM{ir, ic} = sprintf('%.3g', dataM(ir, ic));
      end
   end
   tbS.fill_body(textM, []);
   tbS.set_heat_table(max(0, min(100, 10 .* dataM)));
   tbS.write_text_table;
   tbS.write_table;
end


%% Multiple header rows
function multipleHeaderRowsTest(tS)
   nr = 4;
   nc = 5;
   tbS = init_table(nr, nc, 2, 'LatexTableLH3');
   
   hdLineV = {latexLH.multicolumn(nc + 1, 'Header 1'); ...
      [' & ', latexLH.multicolumn(2, 'Sub Header'), ' & ',  latexLH.multicolumn(nc + 1 - 3, 'Sub Header 2')]};
   tbS.set_header_lines(hdLineV);
   
   dataM = randn([nr, nc]);
   tbS.fill_body(dataM, '%.3g');
   tbS.write_table;
end


%% Initialize table object
function tbS = init_table(nr, nc, nHeaderRows, fileName)
   compS = configLH.Computer([]);

   rowHeaderV = stringLH.vector_to_string_array(1 : nr, 'Row%i');
   colHeaderV = cell(nHeaderRows, nc);
   for i1 = 1 : nHeaderRows
      baseStr = sprintf('Var %i', i1);
      colHeaderV(i1,:) = stringLH.vector_to_string_array(1 : nc, [baseStr, ' %i']);
   end
   filePath = fullfile(compS.testFileDir,  [fileName, '.tex']);

   tbS = LatexTableLH(nr, nc, 'filePath', filePath, 'rowHeaderV', rowHeaderV, 'colHeaderV', colHeaderV);
end