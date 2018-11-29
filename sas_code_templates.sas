/****************************/
/*******  IMPORTING  ********/
/*******    DATA     ********/
/****************************/

/* Access (.mdb) file type */
proc import table="<the specific table in the access database here>"
      out=<your data set name here> replace dbms=access;
      database="<put your file location here, include .mdb extension>";
run;

/* .csv file type */
proc import datafile="<your file location here, including .csv extension>"
      out=<your data set name here> replace dbms=csv;
run;

/* .dat file type */
data <appropriate data set name here>;
  infile "<your file location here, including .dat extension>"
  LRECL=<a logical length of your data to emcompass the ENTIRE data>;
  input
    <variable names and their fixed field locationss here>
    ;
run;
*****Example: Raw_Data.dat file;
data main;
  infile "C:\Data\Your_Study\Raw_Data.dat" LRECL=1000;
  input
    ID        07-14
    Name      47-55
    ;
run;

/* dBase (.dbf) file type */
proc import datafile="<your file location here, including .dbf extension>"
      out=<your data set name here> replace dbms=dbf;
run;

/* excel (.xls) file type */
proc import out=<your data set name here>
  datafile="<your file location here, including .xls extension>"
  dbms=excel replace;
    *optional statements;
    sheet="<specify sheet to obtain>";
    getnames=<yes/no - first row = variable names>;
    mixed=<yes/no - refers to data types, if num AND char varibles, use yes>;
    usedate=<yes/no - read date formatted data as date formatted SAS data>;
    scantime=<yes/no - read in time formatted data as long as variable is not date format>;
run;

/* Text (.txt) file type, space delimited */
data <appropriate data set name here>;
  infile "<your file location here, including .txt extension>"
  LRECL=<a logical length of your data to emcompass ENTIRE data>;
  input
    <variable names here>
    ;
run;

/* Text (.txt) file type, comma delimited */
data <appropriate data set name here>;
    infile "<your file location here, including .txt extension>"
    LRECL=<a logical length of your data to emcompass ENTIRE data> DLM=",";
  input
  <variable names here>
  ;
run;

/* .txt file type, tab delimited */
data <appropriate data set name here>;
    infile "<your file location here, including .txt extension>"
    LRECL=<a logical length of your data to emcompass ENTIRE data> DLM='09'x;
  input
  <variable names here>
  ;
run;

/***************************/
/*****   REMOVE      *******/
/*****  DUPLICATES   *******/
/***************************/
data <data>; set <data>;
  by <ID variable>;
  /* Choose one of the options below. YOu can either keep only the first duplicate observation, or the second. */
  if first.<ID variable>; *Choose to keep only the first observation;
  if  last.<ID variable>; *Choose to keep only the last  observation;
run;

/* How to count the number of unique ID numbers */
proc SQL;
  create table temp as
  select unique(<ID VARIABLE HERE>)
  from <your dataset>;
quit;
proc print data=temp;
run;

/****************************/
/*******   MERGING   ********/
/*******    DATA     ********/
/****************************/

* If you need to merge data, use proc sort first!!!;
* In new data set to receive the imported data, use the following syntax;

* Sort the first data set by the merging variable;
proc sort data=<old data set 1>;
  by <sorted variable such as an ID variable>;
run;
* Sort the second data set by the merging variable;
proc sort data=<old data set 2>;
  by  <sorted variable, this must be the same as the one above since thats what theyre being merged by>;
run;
* Perform the merge of the two data sets;
data <your data set name>;
  merge <all of the imported data sets in a single line here>;
  by <sorted variable>;
run;


/****************************/
/*******             ********/
/****** PROC TABULATE *******/
/*******             ********/
/****************************/

proc tabulate data=<your data set>;
  class <by variables here>;
  var <cell information here>;
  table <rows> all, MEAN*<cols>*(<sub-cols> all);
run;
***Example: Give separate means for vitamin c intake for low and high fruit consumption by gender;
proc tabulate data=nutrition_dataset;
  class gender citrus;                           *low and high fruit consumption and sex break down;
  var vitamin_c;                                 *means for what? vitamin_c!;
  table citrus all, MEAN*vitamin_c*(gender all); *how do you want?;
run;

/****************************/
/*******             ********/
/******* PROC REPORT ********/
/*******             ********/
/****************************/

proc report nowindows headline headskip data=<your data set here>;
  Title "<An informative title given here helps clarify what the report is about>";
  column <row_variable> <column_variable>, <cell_variable>, (mean std);             *separate columns with a comma (,);
  define <cell information>/ format=6.2;                                            *format: field width.#decimal places;
  define <row grouping variable>/group;                                             *group variable along rows;
  define <col grouping variable>/across;                                            *across puts things on top;
run;
***Example: Give separate means for rvitc for low and high fruit consumption by sex;
proc report nowindows headline headskip data=master;
  Title "Vitamin C by citrus fruit consumption and gender";
  column gender citrus, vitamin_c, (mean std);
  define vitamin_c/ format=6.2;
  define gender/group;
  define citrus/across;
run;

/****************************/
/**          ODS           **/
/**  OUTPUT DISPLAY SYSTEM **/
/****************************/

*Use ODS Trace to figure out the output name from the LOG WINDOW;
ods trace on;
ods output <output log name>=<appropriate data set name here>;
*---> MAKE SURE THAT THE OUTPUT STATEMENT IS IN THE PROC YOU WANT TO DISPLAY INFO FROM!!!;
ods trace off;

*ODS HTML TAG SET;
*Step1: use the following code, making sure to label appropriate HTML files;
*Step2: use ODS trace and output to output to HTML files;
*Step3: close ODS HTML;

ODS HTML
BODY    ="test.html"
contents  ="testTOC.html"
page    ="testpage.html"
frame   ="testframe.html"
path    ="&drive:\School\Classes\Winter 2008\Stat557\Laboratory\Lab2\Lab2SAS\"
style   =Styles.statdoc;

ods trace on;
ods output <output log name>=<data set name>;
ods trace off;
/* USE ODS PROCLABEL ""; in front of a proc to label that proc in your ods table of contents */
ODS HTML CLOSE;

/* ODS PDF TAG SET */
ODS PDF
color = full
file = "<file location, including .pdf extension>"
pdftoc = # /* toc is table of contents, # = 1 if collapsed, 2=if collapsed at second level */;
/* USE ODS PROCLABEL ""; in front of a proc to label that proc in your ODS table of contents */
ODS pdf close;


/* ODS EXCEL TAG SET */
ODS TAGSETS.EXCELXP
file="&MYDOC\VALID.xls"
STYLE=minimal
OPTIONS ( Orientation = "landscape"
embedded_titles="Yes"
embedded_footers="No"
FitToPage = "yes"
Pages_FitWidth = "1"
Pages_FitHeight = "100"
sheet_interval="Proc");

ods tagsets.excelxp close;

/****************************/
/*******             ********/
/*******    Macros   ********/
/*******             ********/
/****************************/

/*
  Syntax:
    %macro <macro name>(<first catch variable>, <next or last catch variable>);
      <Code to be run here>;
    %mend;

  Operators:
    % = macro statement
    & = macro variable substitution modifier (defines where macro variable begins)
    . = macro variable substitution modifier (defines where macro variable ends)
    "double quotes" = in order to do macro variable substitution in quotations,
      you must use double quote markers => single quotes will not work!!!
      (MAKE SURE TO CHECK FOR THIS DURING CODE CORRECTON)

  If you're doing variable recoding - use arrays + do loops!

  Examples:
    %let <variable> = <value>;
    put "&<variable> is <value>!";
    &<variable>.1 = <value>+1;
*/

/****************************/
/*******             ********/
/*******    Arrays   ********/
/*******             ********/
/****************************/

/*
  Syntax:
    array <array name>(<array size>) <variables to store into array>;

  Optional:
    <array size> can be * if unknown or not important
    <variables> can be blank if <array name>1 - <array name>n is okay
    () {} [] doesn't matter around <array size> - {} is preferred.
    dim(<array name>) - function that returns the number of elements within the array

  Notes:
    the <array name> may NOT be the same name as any variable in the data set.
*/

/****************************/
/***                      ***/
/***    Informatting &    ***/
/***  String Manipulation ***/
/***                      ***/
/****************************/
/*
  Informat Modifiers (Use only in input statement):
    $ = specify the data is a text data type
    ## = specify data field length (where ## = actual numbers)
    . = informat marker (specifies that the code before it is informat, not part of the variables name)
    / = goto next line
    mmddyy8. = informat for mm/dd/yy style dates
    mmddyyyy10. = informat for mm/dd/yyyy dates
    # = "jump to" marker - use a number after it to tell it which line to jump to (where # = #, not a number)

  String Manipulation & Associated (Use outside of input & within definition statements):
    Today() - this fx returns today"s date as an integer of the number of days since 01/01/1960
    index(<string variable>, "<search string>") - this fx returns the location of the exact search string
    indexc(<string variable>,"<search string>") - this fx returns the location of any part of the search string
    substr(<string var>,<start location>,<end location>) - this fx returns the sub-string within the locs
*/
* Example: see input statement;
data master;
  infile "C:\Data\address.txt" truncover;
  input FullName $25./Address1 $100./Address2 $100./FullPhone $25./Birthday mmddyy8./;
  Age=(Today()-Birthday)/365.25;
  loc1=index(Address2,",");
  loc2=indexc(Address2,"0123456789");
  City=substr(Address2, 1, loc1-1);
  State=substr(Address2, loc1+1, loc2-loc1-1);
  zip=substr(Address2, loc2, 10);
run;

/****************************/
/*******             ********/
/*******   Do Loops  ********/
/*******             ********/
/****************************/

/*
  Syntax:
    Ordinary Do Loops:
      Do <count variable, usually i>=<start num> to <end num> by <increment num>;
        <code to be run here>;
        <&i is NOT allowed>;
      end;

    Macro Do Loops (Use when <count variable> is desired as a macro variable):
      %Do <count variable>=<start num> %to <end num> by <increment num>;
        <code to be run here>;
        <&i IS allowed>;
      %end;
*/

/****************************/
/*******             ********/
/*******  Regression ********/
/*******             ********/
/****************************/

/* 2x2 Cross-over Design */

/*
  ID = ID variable
  group = sequence variable; either AB or BA
  period = time variable
  treat = treatment / control variable
  interactions = interaction variables

  use repeated statement if repeated measures are collected
  use estimate and contrast (both do the same thing in this case) to compare
    treatment effects
*/
ods graphics on;
proc mixed data=main;
  class ID group period treat;
  model response = group period treat interactions /residual;
  random ID(group);
  *repeated /type=un subject=id r rcorr;
  *estimate "Trt2 - Trt1" trt -1 1;
  *contrast "Trt2 - Trt1" trt -1 1 / chisq;
run;
ods graphics off;

/* Spaghetti Plots */
%MACRO SpaghettiPlot(DSN, y, time, id, numsubj);
  proc sort data=&DSN;
    by ID;
  run;

  axis1 label=(a=90 "&y");
  axis2 label=(a=-90 "&y");
  proc gplot data=omega3;
  plot &y*&time=&ID /vaxis=axis1;
  plot2 &y*&time /vaxis=axis2;
  symbol1 v=none repeat=&numsubj i=join color=cyan;
  symbol2 v=none i=sm50s color=blue width=3;
  label &time="Time of Measurement";
  title "Individual Profiles with Average Trend Line";
  run;
  quit;
%MEND SpaghettiPlot;

/* LOGISTIC REGRESSION */
PROC LOGISTIC DATA=<your data set name here>;
  CLASS <categorical/class variables here> (REF="<reference category name, case-sensitive>" PARAM=REF)
        ; * As of SAS 9.2, the class statement here will automatically dummy-code your class variables for you!;
  MODEL <outcome variable> (EVENT="<outcome code name, case-sensitive | sometimes a "1">")
        = <exposure of interest here>
          <confounders here>
          <confounder-exposure interaction / effect modifier terms here>
  /<logistic regression model options here - see SAS Help file for more information>;
  units <continuous scale variables can be shown as increments of a certain number> = <what is that certain number?>;
RUN;

/******************************/
/*******               ********/
/******* Useful Macros ********/
/*******               ********/
/******************************/

/* This Macro attaches a prefix to all of the variables */
%macro rename(lib,dsn,newname);
  proc contents data=&lib..&dsn;
  title "before renaming";
  run;
  proc sql noprint;
  select nvar into :num_vars
  from dictionary.tables
  where libname="&LIB" and memname="&DSN";
  select distinct(name) into :var1-:var%trim(%left(&num_vars))
  from dictionary.columns
  where libname="&LIB" and memname="&DSN";
  quit;
  run;
  proc datasets library = &LIB;
  modify &DSN;
  rename
  %do i = 1 %to &num_vars.;
  &&var&i = &newname._&&var&i.
  %end;
  ;
  quit;
  run;
  proc contents data=&lib..&dsn.;
  title "after renaming";
  run;
%mend rename;
DATA B;
set A;
run;
%rename(WORK,B,Try1);

/* Adding Prefix on Selected Variables */
%macro addprefix(lib,dsn,start,end,newname);
  proc contents data=&lib..&dsn;
  title "before renaming";
  run;
  proc sql noprint;
  select nvar into :num_vars
  from dictionary.tables
  where libname="&LIB" and memname="&DSN";
  select distinct(name) into :var1-:var%trim(%left(&num_vars))
  from dictionary.columns
  where libname="&LIB" and memname="&DSN";
  quit;
  run;
  proc datasets library = &LIB;
  modify &DSN;
  rename
  %do i = &start. %to &end.;
  &&var&i = &newname_&&var&i.
  %end;
  ;
  quit;
  run;
  proc contents data=&lib..&dsn;
  title "Adding Prefix on Selected variables";
  run;
%mend addprefix;
DATA C;
set A;
run;
%addprefix(WORK,C,2,4,Try2);

/* Replacing Prefix on Selected Variables */
%macro replaceprefix(lib,dsn,start,end,oldprefix,newprefix);
  proc contents data=&lib..&dsn.;
  title "before renaming";
  run;
  data temp;
  set &lib..&dsn.;
  run;
  %LET ds=%SYSFUNC(OPEN(temp,i));
  %let ol=%length(&oldprefix.);
  %do i=&start %to &end;
  %let dsvn&i=%SYSFUNC(VARNAME(&ds,&i));
  %let l=%length(&&dsvn&i);
  %let vn&i=&newprefix.%SUBSTR(&&dsvn&i,&ol+1,%EVAL(&l-&ol));
  %end;
  data &lib..&dsn.;
  set temp;
  %do i=&start %to &end;
  &&vn&i=&&dsvn&i;
  drop &&dsvn&i;
  %end;
  %let rc=%SYSFUNC(CLOSE(&ds));
  proc contents data=&lib..&dsn.;
  title "Replacing Prefix on Selected variables ";
  run;
%mend replaceprefix;
DATA D;
set A;
run;
%replaceprefix(WORK,D,2,4,before,Try3);

/* Replacing Suffix on Selected Variables */
%macro replacesuffix(lib,dsn,start,end,oldsuffix,newsuffix);
  proc contents data=&lib..&dsn.;
  title "before renaming";
  run;
  data temp;
  set &lib..&dsn.;
  run;
  %LET ds=%SYSFUNC(OPEN(temp,i));
  %let ol=%length(&oldsuffix.);
  %do i=&start %to &end;
  %let dsvn&i=%SYSFUNC(VARNAME(&ds,&i));
  %let l=%length(&&dsvn&i);
  %let vn&i=%SUBSTR(&&dsvn&i,1,%EVAL(&l-&ol))&newsuffix.;
  %end;
  data &lib..&dsn.;
  set temp;
  %do i=&start %to &end;
  &&vn&i=&&dsvn&i;
  drop &&dsvn&i;
  %end;
  %let rc=%SYSFUNC(CLOSE(&ds));
  proc contents data=&lib..&dsn.;
  title " Replacing Suffix on Selected variables ";
  run;
%mend replacesuffix;
DATA E;
  set A;
run;
%replacesuffix(WORK,E,2,4,after,Try4);

/* Adding Suffix = Replacing BLANK Suffix on Selected Variables */
DATA F;
  set A;
run;
%replacesuffix(WORK,E,2,4, ,_Try4);



