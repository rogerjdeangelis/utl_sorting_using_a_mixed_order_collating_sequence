Sorting using a mixed order collating sequence not linguistic sorting

 Two Solutions  (Same result in SAS and WPS)

     1. WPS Proc R
     2. WPS/SAS proc sql

   Possible other methods (not shown)

     3. Could do it with proc reprort and substr function in formats (not shown)
     4. Proc sort groupformat does not work (Bug?)

HAVE
====

 SD1.HAVE total obs=6

   As

   A2
   A22
   A222
   A1
   A11
   A111

EXAMPLE OUTPUT  ( 1 < 2< 11 < 22 < 111 < 222 )

   WANT

   A1
   A2
   A11
   A22
   A111
   A222


PROCESS (WORKING CODE)
=======================

  want<-mixedsort(have$AS);


OUTPUT
======

 1. WPS Proc R

  WORK.WANT total obs=6

    WANT

    A1
    A2
    A11
    A22
    A111
    A222

 2. WPS/SAS proc sql

   proc sql;
      select
          *
      from
         have
      order
         by input(substr(as,2),best.)
   ;quit;

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
  input as $;
cards4;
A2
A22
A222
A1
A11
A111
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

%utl_submit_wps64('
libname sd1 "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk  sas7bdat "%sysfunc(pathname(work))";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(haven);
library(gtools);
have<-read_sas("d:/sd1/have.sas7bdat");
head(have);
have;
want<-mixedsort(have$AS);
want;
endsubmit;
import r=want data=wrk.want;
run;quit;
');


%utl_submit_wps64('
libname wrk sas7bdat "%sysfunc(pathname(work))";
   proc sql;
      select
          *
      from
         wrk.have
      order
         by input(substr(as,2),best.)
   ;quit;
');
