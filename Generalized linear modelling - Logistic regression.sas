/*IMPORT DATA*/
proc import datafile="/home/u62868661/Datasets/Logistic regression/Titanic.csv"
dbms=csv
out=df
replace;
run;

/*DESCRIPTIVE TABLES*/
proc means data=df chartype mean std min max median n range vardef=df clm 
		alpha=0.05 q1 q3 qmethod=os;
	var Age;
	class Survived;
run;
proc freq data=df;
	tables  (PClass Sex) *(Survived) / chisq relrisk nocol nocum 
		plots(only)=(freqplot mosaicplot);
run;

/*HISTOGRAMS*/
proc univariate data=df vardef=df noprint;
	var Age;
	class Survived;
	histogram Age / normal(noprint) kernel;
	inset mean std min max median n range q1 q3 / position=nw;
run;

/*BOXPLOTS*/
proc boxplot data=df;
	plot (Age)*Survived / boxstyle=schematic;
	insetgroup mean stddev min max n q1 q2 q3 range / position=top;
run;

/*SIMPLE LOGISTIC REGRESSION MODELS*/
proc logistic data=df plots=(oddsratio(cldisplay=serifarrow) roc);
	class PClass / param=glm;
	model Survived(event='1')=PClass / link=logit clodds=wald alpha=0.05 pcorr 
		technique=fisher;
run;
proc logistic data=df plots=(oddsratio(cldisplay=serifarrow) roc);
	class Sex / param=glm;
	model Survived(event='1')=Sex / link=logit clodds=wald alpha=0.05 pcorr 
		technique=fisher;
run;
proc logistic data=df plots=(oddsratio(cldisplay=serifarrow) roc);
	model Survived(event='1')=Age / link=logit clodds=wald alpha=0.05 pcorr 
		technique=fisher;
run;

/*MULTIPLE FORCED-ENTRY LOGISTIC REGRESSION MODEL*/
proc logistic data=df plots=(oddsratio(cldisplay=serifarrow) roc);
	class PClass Sex / param=glm;
	model Survived(event='1')=PClass Sex Age / link=logit clodds=wald alpha=0.05 
		pcorr technique=fisher;
run;

/*MULTIPLE FORCED-ENTRY GENERALIZED LINEAR MODEL WITH BINOMIAL DISTRIBUTION AND A LOGIT LINK FUNCTION*/
proc genmod data=df descending plots=(predicted cooksd resraw(index xbeta) 
		stdreschi(index) );
	class PClass Sex / param=glm;
	model Survived=PClass Sex Age / dist=binomial link=logit waldci alpha=0.05;
run;