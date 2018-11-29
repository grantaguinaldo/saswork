data main;
  input x y z;
  cards;
  1 2 3
  7 8 9;
run;

/* 1. Use one SET statement when you have the same variables, but different observations */
data more_people;
  input x y z;
  cards;
  4 5 6
  3 6 9;
run;

data final;
  set main more_people;
run;

proc print data=final; run;

/* 2. Use two SET statements when you have different variables, but the same observations */
data more_vars;
  input a b c;
  cards;
  20 40 60
  10 20 30;
run;

data new_final;
  set main;
  set more_vars;
run;

proc print data=new_final;
run;

/* 3. Use the MERGE statement when you have a common index variable, and any new variables or observations */
data more_vars_and_people;
  input x a b c;
  cards;
  1 20 40 60
  7 10 20 30
  2 11 12 13
  3 14 15 16;
run;

/*  The MERGE statement requires that you use an index variable to merge on (e.g. an ID variable).;
    Thus, you must SORT your data BY that index variable.; */

proc sort data=main;
  by x;

proc sort data=more_vars_and_people;
  by x;
run;

data merged_final;
  merge main more_vars_and_people;
  by x;
run;

proc print data=merged_final;
run;


/* 4. SQL is an advanced programming language for databases.
      Here, I provide a basic example to merge the two datasets using a LEFT JOIN.
      I will include more information about JOIN types in a follow up video.
      For now, think of a LEFT JOIN as one that only includes the data from the second dataset (more_vars_and_people)
      that corresponds to data from the original dataset (main). */
proc sql;
  create table sql_final as
  select L.*, R.*
  from main as L
  LEFT JOIN more_vars_and_people as R
  on L.x = R.x;
quit;

proc print data=sql_final; run;


* Helpful Notes:

* 1. The LIBNAME statement is used to point SAS towards a specific folder on your computer.
* 2. The INFILE statement "reads" data into SAS if it is of a certain format (usually comma, space, or tab delimited).
* 3. PROC IMPORT - imports data of any of several different file formats into SAS.
* 4. The SET statement imports data from a library into SAS at the DATA STEP.
* 5. The library name in a data step's data name "writes" data from SAS into your library folder using SAS's own file format system.

data main;
  input x y z;
  cards;
  1 2 3
  7 8 9;
run;

proc contents data=main;
run;

proc print data=main;
run;

/* TEMPLATED CODE: .txt file type, with or without delimiters */
data [appropriate data set name here];
    infile "[your file location here, including .txt extension]"
    LRECL=[a logical length of your data to emcompass ENTIRE data] DLM=',';
  input
  [variable names here]
  ;
run;

data infile_main;
  infile "C:\My SAS Files\main.txt";
  input x y z;
run;

proc print data=infile_main;
run;

/* TEMPLATED CODE: Microsoft Excel (.xls) file type */
proc import out=[your data set name here]
  datafile='[your file location here, including .xls extension]'
  dbms=excel replace;
   *Optional statements are below;
    sheet='[specify sheet to obtain]';
    getnames=[yes/no - first row = variable names];
    mixed=[yes/no - refers to data types, if num AND char varibles, use yes];
    usedate=[yes/no - read date formatted data as date formatted SAS data];
    scantime=[yes/no - read in time formatted data as long as variable is not date format];
run;

proc import out=imported_excel
  datafile='C:\My SAS Files\main.xls'
  dbms=excel replace;
   *Optional statements are below;
    sheet='Sheet1';
    getnames=yes;
run;

proc print data=imported_excel;
run;

libname home "C:\My SAS Files\";

data sas_format; set home.main;
run;

data home.sas_format; set infile_main;
run;

proc import datafile="/home/grantaguinaldo0/EPG194/data/airfoil.csv"
  dbms=csv
  out=airfoil
  replace;
run;

proc print data=airfoil;
run;

proc contents data=airfoil;
run;

proc means data=airfoil;
run;

proc ttest data=airfoil h0=50 sides=U alpha=0.05;
  var free_stream_vel_m_s;
run;

ods graphics on;
proc corr data=airfoil plots=matrix(histogram);
run;
ods graphics off;

proc reg data=airfoil;
  model sound_pressure_deci = freq_hz
                angle_deg;
run;



