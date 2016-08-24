function TopicTest

classDateV = datetime(2016,8,24) : 3 : datetime(2016,12,7);


titleIn = 'OLG Models';

topicV = cell(10, 1);
topicV{1} =  markdownLH.SubTopic({'[Dynamics and steady state](olg/olg_analysis_sl.pdf)', '[solution for example](olg/OLG_example.pdf)', ...
   '[PS1](olg/OLG_PS.pdf)'});
topicV{2} = markdownLH.SubTopic({'Recitation, OLG examples'}, classDateV(5));
topicV{3} = markdownLH.SubTopic({'[Efficiency and Social Security](olg/OLG_SS_SL.pdf)', ...
   '[RQ](olg/OLG_RQ.pdf) (review questions, not to be handed in)'}, [], 'sameDate');
topicV{4} = markdownLH.SubTopic({'[Bequests](olg/OLG_Bequest_SL.pdf)'});

topicV(5 : end) = [];

tS = markdownLH.Topic(titleIn, topicV, classDateV);

tS.write_topic(3)

end