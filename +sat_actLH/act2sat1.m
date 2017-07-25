function satV = act2sat1(actV)
% Convert ACT (combined) to SAT I (math + verbal) scores
%{
Conversion table from Dorans (1999)
Same as Table 3 in Schneider and Dorans (1999): "Concordance Between SAT® I and ACTTM Scores for
Individual Students"

If ACT outside of conversion table range: NaN
%}

% Table A.1 in Dorans (1999)
tbM = [36	1600
35	1580
34	1520
33	1470
32	1420
31	1380
30	1340
29	1300
28	1260
27	1220
26	1180
25	1140
24	1110
23	1070
22	1030
21	990
20	950
19	910
18	870
17	830
16	780
15	740
14	680
13	620
12	560
11	500];

satV = nan(size(actV));

for i1 = 1 : size(tbM, 1)
   satV(actV == tbM(i1,1)) = tbM(i1,2);
end

validateattributes(satV, {'double'}, {'real',  'size', size(actV)})

end