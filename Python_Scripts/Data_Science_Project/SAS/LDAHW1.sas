Libname datasets 'C:\Users\harve\Downloads';


/*PROC IMPORT OUT= datasets.Bmilda*/
/*            DATAFILE= 'C:\Users\harve\Downloads\bmilda.tab'*/
/*            DBMS=DLM REPLACE;*/
/*     DELIMITER='09'x;*/
/*     GETNAMES=YES;*/
/*     DATAROW=2; */
/*RUN;*/

/*old dataset*/
proc print data=datasets.Bmilda;
run;
/*new dataset*/
proc print data=datasets.Bmilda_new;
run;
data datasets.Bmilda_new;  
   set datasets.Bmilda_new; 
   timecont = time; 
run;

/*Individual plot*/
goptions reset=all ftext=swiss device=psepsf gsfname=fig1 gsfmode=replace
rotate=landscape i=join;
/*remove the missing values from smoking*/

data datasets.Bmilda_new;
   set datasets.Bmilda;
   if not missing(smoking);
run;


/* Create a random sample of 100 subjects with their time points*/
data datasets.Bmilda_Random;
   call streaminit(123); /* Set a seed for reproducibility */
   retain selected_id;
   do until (eof);
      set datasets.Bmilda_new end=eof;
      random_number = ranuni(123);
      if random_number <= 200/14975 then selected_id = id;
      if selected_id = id then output;
   end;
run;

/* Create the plot using the sample data */
proc sgplot data=datasets.Bmilda_random;
   series x=time y=bmi / group=id;
   xaxis label='Time';
   yaxis label='BMI';
run;

/*mean structure plot*/
goptions reset=all;
proc means data=datasets.Bmilda_new noprint;
  class time;
  var bmi;
  output out=MeanStdErr(drop=_type_ _freq_) mean=MeanBMI std=StdErrBMI;
run;

proc sgplot data=MeanStdErr;
  series x=time y=MeanBMI / lineattrs=(thickness=2);
  xaxis label="Time";
  yaxis label="Mean BMI";
run;

/* Define your dataset and sort it by the subject (e.g., ID) and time variables */
proc sort data=datasets.Bmilda_new;
   by id time;
run;

/* Analysis of each time point for summary statistics*/
proc sort data=datasets.Bmilda_new;
  by time;
run;

ods graphics off;
proc reg data=datasets.Bmilda_new;
  model bmi=sex fage smoking;
  by time;
run;
/*Area under the curve for summary statistics*/
data datasets.Area_under_curve;
	set datasets.Bmilda_new;
	by id;
		last_time = lag(time);
		last_bmi= lag(bmi);
		diff_time = time - last_time;
		Area = diff_time*(bmi + last_bmi)/2;
		if first.id then do;
		last_time = .;
		last_bmi = .;
		diff_time = .;
		Area = .;
		end;
run;
/*Calculate the AUC for each subject*/
proc sql;
create table summation as
select id, sum(Area) as AUC
from datasets.Area_under_curve
group by id;
quit;
/*Merge the datasets by id*/
data datasets.Area_under_curve_new;
	merge summation(where=(id ne .)) datasets.Bmilda_new;
	by id;
run;
/*Result for the Area under the curve using regression*/
/*proc reg data = datasets.Area_under_curve_new;*/
/*	model auc = time sex fage smoking;*/
/*run;*/

/*Result for the Area under the curve using GLM BOTH GLM and REG gave same result*/
proc glm data=datasets.Area_under_curve_new;
model auc = time sex fage smoking/ solution;
run;
/*Analysis of Increment*/
/*Calculate the Increment*/
data datasets.bmilda_increment_analysis;
    set datasets.bmilda_new;
    by id;
    retain measurement1;
    if first.id then measurement1 = bmi;
    if last.id then do;
        measurement_diff = bmi - measurement1;
        output;
end;
run;
/*Analysis of Increment result*/
proc glm data=datasets.bmilda_increment_analysis;
class sex smoking;
model measurement_diff = sex smoking fage / solution;
run;
/*****Model 1a - Time Categorical - UN*****/
proc mixed data = datasets.Bmilda_new method = ml;
class id time smoking sex;
model bmi = fage sex smoking time*fage time*sex time*smoking /noint ddfm=satterth s;
repeated time / type = un subject = id r rcorr;
run;

/*****Model 1b - Time Continuous - AR(1)*****/
proc mixed data = datasets.Bmilda_new method = ml;
class id time smoking sex;
model bmi = time*fage time*sex time*smoking /noint ddfm=satterth s;
repeated time / type = AR(1) subject = id r rcorr;
run;
/*****Model 1c - Time Continuous - Compound Symmetry*****/
proc mixed data = datasets.Bmilda_new method = ml;
class id time smoking sex;
model bmi = time*fage time*sex time*smoking /noint ddfm=satterth s;
repeated time / type = CS subject = id r rcorr;
run;
/*****Model 1d - Time Continuous - Toepltz*****/
proc mixed data = datasets.Bmilda_new method = ml;
class id time smoking sex;
model bmi = time*fage time*sex time*smoking /noint ddfm=satterth s;
repeated time / type = toep subject = id r rcorr;
run;
/*****Model 1 - Time Categorical - UN*****/
proc mixed data = datasets.Bmilda_new method = ml;
class id time smoking sex;
model bmi = time*fage time*sex time*smoking /noint ddfm=satterth s;
repeated time / type = un subject = id r rcorr;
run;
/*****Model 2 - Time Continuous - UN *****/
proc mixed data = datasets.Bmilda_new method = ml;
class id time smoking sex;
model bmi = fage*timecont sex*timecont smoking*timecont / ddfm = satterth s;
repeated time / type = un subject = id;
run;

/*****Model 3 - Time Categorical - Toeplitz*****/
proc mixed data = datasets.Bmilda_new method = ml;
class id time smoking sex;
model bmi = fage sex smoking time*sex / ddfm = satterth s;
repeated time / type = toep subject = id;
run;
/*****Model 4 - Time Continuous - Toeplitz*****/
proc mixed data = datasets.Bmilda_new method = ml;
class id timecont smoking sex;
model bmi = fage sex smoking time*sex / ddfm = satterth s;
repeated timecont / type = toep subject = id;
run;

/*****Model 5 - Time continuous - Toeplitz*****/
proc mixed data = datasets.Bmilda_new method = ml;
class id time smoking sex;
model bmi = fage sex smoking timecont*sex timecont*smoking timecont*fage / ddfm = satterth s;
repeated time / type = toep subject = id;
run;

/*Two Stage analysis*/
/*Sort dataset*/
/*Stage I*/
proc sort data=datasets.Bmilda_new out=datasets.Bmilda_new1;
by Id;
run;

ods graphics off;
proc reg data=datasets.Bmilda_new1 outest=stage1 noprint;
by Id;
model bmi = time;
/*title 'Two-stage analysis - stage 1 (linear)';*/
run;
proc print data=stage1; run;quit;

/*Stage II*/
data datasets.stage2;
set stage1;
Intercept1=Intercept;keep id time Intercept1;
run;
data datasets.Bmilda_stage;  
   set datasets.Bmilda_new; 
run;
proc sort data=datasets.Bmilda_stage nodupkey out=datasets.Bmilda_stage_next;
by id;run;
proc sort data=datasets.stage2;
by id;run;

/*Merge parameters*/
data datasets.Bmilda_stage_final;
merge datasets.Bmilda_stage_next datasets.stage2;by id;slope=time;
drop timecont time;run;

proc glm data=datasets.Bmilda_stage_final;
class sex smoking;
model slope=fage sex smoking/solution noint;run;quit;
/*LINEAR MIXED MODEL 1*/
proc mixed data=datasets.bmilda_new method=reml empirical covtest nobound;
class id sex smoking time;
model bmi= fage smoking sex*timecont / noint solution chisq;
random intercept timecont / type=un subject=id g gcorr v vcorr solution;
repeated time / type=simple subject=id r rcorr;
contrast "slope difference" sex*timecont 1 -1;
estimate "slope" sex*timecont 1 -1;
run;
/*LINEAR MIXED MODEL 2*/
proc mixed data=datasets.bmilda_new method=reml empirical covtest nobound;
class id sex smoking time;
model bmi= fage*timecont smoking*timecont sex*timecont / noint solution chisq;
random intercept timecont / type=un subject=id g gcorr v vcorr solution;
repeated time / type=simple subject=id r rcorr;
run;

/*clear result views*/
 dm 'odsresults; clear';





