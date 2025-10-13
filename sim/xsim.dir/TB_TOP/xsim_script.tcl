set_param project.enableReportConfiguration 0
load_feature core
current_fileset
xsim {TB_TOP} -wdb {result.wdb} -autoloadwcfg
