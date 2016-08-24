function ClassScheduleTest

classDateS = markdownLH.ClassDates(datetime(2016,8,24), datetime(2016,12,7), {'Monday', 'Wednesday'});
classDateV = classDateS.date_list;

topicListV = cell(10, 1);
iTopic = 0;

%% Sub topic 1

titleIn = 'OLG Models';

topicV = cell(10, 1);
topicV{1} =  markdownLH.SubTopic({'[Dynamics and steady state](olg/olg_analysis_sl.pdf)', '[solution for example](olg/OLG_example.pdf)', ...
   '[PS1](olg/OLG_PS.pdf)'});
topicV{2} = markdownLH.SubTopic({'Recitation, OLG examples'}, classDateV(4));
topicV{3} = markdownLH.SubTopic({'[Efficiency and Social Security](olg/OLG_SS_SL.pdf)', ...
   '[RQ](olg/OLG_RQ.pdf) (review questions, not to be handed in)'});
topicV{4} = markdownLH.SubTopic({'[Bequests](olg/OLG_Bequest_SL.pdf)'});

topicV(5 : end) = [];

iTopic = iTopic + 1;
topicListV{iTopic} = markdownLH.Topic(titleIn, topicV, classDateV);

%% Sub topic 2

titleIn = 'Sub 2';

n = 4;
topicV = cell(n, 1);
for i1 = 1 : n
   topicV{i1} = markdownLH.SubTopic({'Subtopic 2, 1', 'Subtopic 2,2'});
end

iTopic = iTopic + 1;
topicListV{iTopic} = markdownLH.Topic(titleIn, topicV, classDateV);


%% Write schedule

cS = markdownLH.ClassSchedule(classDateV, topicListV);

cS.write


end