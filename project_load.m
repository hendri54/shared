function pS = project_load(suffixStr)

plS = ProjectListLH;
plS.load;

pS = plS.retrieve_suffix(suffixStr);


end