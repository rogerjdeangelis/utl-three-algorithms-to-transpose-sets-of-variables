%let pgm=utl-three-algorithms-to-transpose-sets-of-variables;

Three algorithms to transpose sets of variables;

github
https://tinyurl.com/42puau8n
https://github.com/rogerjdeangelis/utl-three-algorithms-to-transpose-sets-of-variables

stackoverflow
https://tinyurl.com/wvhj2sar
https://stackoverflow.com/questions/74438398/transpising-observations-into-one-row-in-sas

    Four Solutions
         1. Art et all. Transpose macro (best)
            By Arthur Tabachneck, Xia Ke Shan, Robert Virgile and Joe Whitehurst
         2. Concat
         3. Array
            Stu Sztukowski
            https://stackoverflow.com/users/5342700/stu-sztukowski
         4. Double transpose
            Bartosz Jablonski
            yabwon@gmail.com
         5. WPS ART
            No changes were required for Art's macro to work in WPS
         6. Pure SQL code

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

data have;
    input vin$ company$ start$ end$;
cards4;
A company1 01JAN2020 05JAN2020
A company2 06JAN2020 10JAN2020
A company3 11JAN2020 15JAN2020
A company4 16JAN2020 19JAN2020
B company5 01FEB2020 02FEB2020
B company6 03FEB2020 10FEB2020
B company7 11FEB2020 20FEB2020
B company8 21FEB2020 28FEB2020
;;;;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* Up to 40 obs from last table WORK.HAVE total obs=8 01MAY2023:13:47:38                                                  */
/*                                                                                                                        */
/* Obs    VIN    COMPANY      START        END                                                                            */
/*                                                                                                                        */
/*  1      A     company1    01JAN202    05JAN202                                                                         */
/*  2      A     company2    06JAN202    10JAN202                                                                         */
/*  3      A     company3    11JAN202    15JAN202                                                                         */
/*  4      A     company4    16JAN202    19JAN202                                                                         */
/*                                                                                                                        */
/*  5      B     company5    01FEB202    02FEB202                                                                         */
/*  6      B     company6    03FEB202    10FEB202                                                                         */
/*  7      B     company7    11FEB202    20FEB202                                                                         */
/*  8      B     company8    21FEB202    28FEB202                                                                         */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/

/**************************************************************************************************************************/
/*                                                                                                                        */
/* WANT_ART total obs=2 01MAY2023:13:51:59                                                                                */
/*         COMPANY_                            COMPANY_                            COMPANY_                               */
/*  VIN       1        START_1      END_1         2        START_2      END_2         3        START_3      END_3   ...   */
/*                                                                                                                        */
/*   A     company1    01JAN202    05JAN202    company2    06JAN202    10JAN202    company3    11JAN202    15JAN202 ...   */
/*   B     company5    01FEB202    02FEB202    company6    03FEB202    10FEB202    company7    11FEB202    20FEB202 ...   */
/*                                                                                                                        */
/*            Variables in Creation Order                                                                                 */
/*                                                                                                                        */
/* #    Variable     Type    Len    Format    Label                                                                       */
/*                                                                                                                        */
/* 1    VIN          Char      8                                                                                          */
/* 2    COMPANY_1    Char      8    $8.       COMPANY                                                                     */
/* 3    START_1      Char      8    $8.       START                                                                       */
/* 4    END_1        Char      8    $8.       END                                                                         */
/*                                                                                                                        */
/* 5    COMPANY_2    Char      8    $8.       COMPANY                                                                     */
/* 6    START_2      Char      8    $8.       START                                                                       */
/* 7    END_2        Char      8    $8.       END                                                                         */
/*                                                                                                                        */
/* 8    COMPANY_3    Char      8    $8.       COMPANY                                                                     */
/* 9    START_3      Char      8    $8.       START                                                                       */
/* 0    END_3        Char      8    $8.       END                                                                         */
/*                                                                                                                        */
/* 1    COMPANY_4    Char      8    $8.       COMPANY                                                                     */
/* 2    START_4      Char      8    $8.       START                                                                       */
/* 3    END_4        Char      8    $8.       END                                                                         */
/*                                                                                                                        */
/**************************************************************************************************************************/
/*          _     _
  __ _ _ __| |_  | |_ _ __ __ _ _ __  ___ _ __   ___  ___  ___   _ __ ___   __ _  ___ _ __ ___
 / _` | `__| __| | __| `__/ _` | `_ \/ __| `_ \ / _ \/ __|/ _ \ | `_ ` _ \ / _` |/ __| `__/ _ \
| (_| | |  | |_  | |_| | | (_| | | | \__ \ |_) | (_) \__ \  __/ | | | | | | (_| | (__| | | (_) |
 \__,_|_|   \__|  \__|_|  \__,_|_| |_|___/ .__/ \___/|___/\___| |_| |_| |_|\__,_|\___|_|  \___/
                                         |_|
*/

/*---- one liner ----*/

%utl_transpose(data=have, out=want_art, by=vin, delimiter=_,var=company start end) ;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* WANT_ART total obs=2 01MAY2023:13:51:59                                                                                */
/*         COMPANY_                            COMPANY_                            COMPANY_                               */
/*  VIN       1        START_1      END_1         2        START_2      END_2         3        START_3      END_3   ...   */
/*                                                                                                                        */
/*   A     company1    01JAN202    05JAN202    company2    06JAN202    10JAN202    company3    11JAN202    15JAN202 ...   */
/*   B     company5    01FEB202    02FEB202    company6    03FEB202    10FEB202    company7    11FEB202    20FEB202 ...   */
/*                                                                                                                        */
/**************************************************************************************************************************/
/*                         _
  ___ ___  _ __   ___ __ _| |_
 / __/ _ \| `_ \ / __/ _` | __|
| (_| (_) | | | | (_| (_| | |_
 \___\___/|_| |_|\___\__,_|\__|

*/
proc transpose
      data=havVue %dosubl('
           data havVue/view=havVue;
               length grp $44;
               set have;
               grp=catx('@',company, start, end);
               drop company start end;
           run;quit;
           ')
      out=havXpo(drop=_name_0;
by vin;
var grp;
run;quit;

data want_concat;
  set havXpo;
  array cols col:;
  company1=scan(col1,1,'@');
  company2=scan(col2,1,'@');
  company3=scan(col3,1,'@');
  company4=scan(col4,1,'@');
  start1=scan(col1,2,'@'); end1=scan(col1,3,'@');
  start2=scan(col2,2,'@'); end2=scan(col2,3,'@');
  start3=scan(col3,2,'@'); end3=scan(col3,3,'@');
  start4=scan(col4,2,'@'); end4=scan(col4,3,'@');
  drop col:;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* 40 obs from last table WORK.WANT_CONCAT total obs=2 01MAY2023:14:07:40                                                 */
/*                                                                                                                        */
/*  VIN    _NAME_    COMPANY1    COMPANY2    COMPANY3    COMPANY4     START1       END1       START2       END2   ...     */
/*                                                                                                                        */
/*   A      GRP      company1    company2    company3    company4    01JAN202    05JAN202    06JAN202    10JAN202 ...     */
/*   B      GRP      company5    company6    company7    company8    01FEB202    02FEB202    03FEB202    10FEB202 ...     */
/*                                                                                                                        */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*
  __ _ _ __ _ __ __ _ _   _
 / _` | `__| `__/ _` | | | |
| (_| | |  | | | (_| | |_| |
 \__,_|_|  |_|  \__,_|\__, |
                      |___/
*/
data have;
    input vin$ company$ start$ end$;
cards4;
A company1 01JAN2020 05JAN2020
A company2 06JAN2020 10JAN2020
A company3 11JAN2020 15JAN2020
A company4 16JAN2020 19JAN2020
B company5 01FEB2020 02FEB2020
B company6 03FEB2020 10FEB2020
B company7 11FEB2020 20FEB2020
B company8 21FEB2020 28FEB2020
;;;;
run;quit;

data want;

    set have;
    by vin;

    array company_[4] $;
    array start_[4] $;
    array end_[4] $;

    /* Do not reset values at the start of each row */
    retain company: start: end: ;

    /* Reset the counter and values for each VIN */
    if(first.vin) then do;
        i = 1;
    end;
        else i+1;

    /* Store each company and date */
    company_[i]    = company;
    start_[i]      = start;
    end_[i]        = end;

    /* Only output one row per VIN */
    if(last.VIN) then output;

    keep vin company_: start_: end_:;
run;

/*   _             _     _        _
  __| | ___  _   _| |__ | | ___  | |_ _ __ __ _ _ __  ___ _ __   ___  ___  ___
 / _` |/ _ \| | | | `_ \| |/ _ \ | __| `__/ _` | `_ \/ __| `_ \ / _ \/ __|/ _ \
| (_| | (_) | |_| | |_) | |  __/ | |_| | | (_| | | | \__ \ |_) | (_) \__ \  __/
 \__,_|\___/ \__,_|_.__/|_|\___|  \__|_|  \__,_|_| |_|___/ .__/ \___/|___/\___|
                                                         |_|
*/

data have;
    input vin$ company$ start$ end$;
cards4;
A company1 01JAN2020 05JAN2020
A company2 06JAN2020 10JAN2020
A company3 11JAN2020 15JAN2020
A company4 16JAN2020 19JAN2020
B company5 01FEB2020 02FEB2020
B company6 03FEB2020 10FEB2020
B company7 11FEB2020 20FEB2020
B company8 21FEB2020 28FEB2020
;;;;
run;quit;

data have;
  set have;
  by vin;
  if first.vin then i=0;
  i+1;
run;
proc print;
run;


proc transpose data = have out = out;
  by vin i;
  var company start end;
run;
proc print;
run;


proc transpose data = out out = out(drop=_name_) prefix;
  by vin;
  var col1;
  id _NAME_ i;
run;
proc print;
run;

/*                               _
__      ___ __  ___    __ _ _ __| |_
\ \ /\ / / `_ \/ __|  / _` | `__| __|
 \ V  V /| |_) \__ \ | (_| | |  | |_
  \_/\_/ | .__/|___/  \__,_|_|   \__|
         |_|
*/


libname sd1 "d:/sd1";

data sd1.have;
    input vin$ company$ start$ end$;
cards4;
A company1 01JAN2020 05JAN2020
A company2 06JAN2020 10JAN2020
A company3 11JAN2020 15JAN2020
A company4 16JAN2020 19JAN2020
B company5 01FEB2020 02FEB2020
B company6 03FEB2020 10FEB2020
B company7 11FEB2020 20FEB2020
B company8 21FEB2020 28FEB2020
;;;;
run;quit;

%symdel status returnVarName / nowarn;

%utl_wpsbegin;
parmcards4;
  options lrecl=1096;
  libname sd1 "d:/sd1";
  data work.have;
    set sd1.have;
  run;quit;
  filename clp clipbrd;
  %utl_transpose(data=have, out=want_wps, by=vin, delimiter=_,var=company start end) ;
  proc print data=want_wps;
  run;quit;
  %let status=&syserr;
  /*---- put value of status in clipboard so SAS can create macro variable status ----*/
  data _null_;file clp ;put "&status";run;
;;;;
run;quit;

%utl_wpsend(returnVarName=status);;

%put status of last step was &status;

/*         _
 ___  __ _| |
/ __|/ _` | |
\__ \ (_| | |
|___/\__, |_|
        |_|
*/

data have;
    input vin$ c$ s$ end$;
cards4;
A c1 01JAN2020 05JAN2020
A c2 06JAN2020 10JAN2020
A c3 11JAN2020 15JAN2020
A c4 16JAN2020 19JAN2020
B c5 01FEB2020 02FEB2020
B c6 03FEB2020 10FEB2020
B c7 11FEB2020 20FEB2020
B c8 21FEB2020 28FEB2020
;;;;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* I like to use array and do_over macros to generate code and assemble the code later. Can save typing with fewer bugs   */
/*                                                                                                                        */
/* You can forgo the code generation and just use array and do_over macros directly                                       */
/*                                                                                                                        */
/* Below I do both                                                                                                        */
/*                                                                                                                        */
/* This kind of code lends itself to muti-tasking                                                                         */
/*                                                                                                                        */
/* Compilers love repetitive code                                                                                         */
/*                                                                                                                        */
/**************************************************************************************************************************/

%array(_r,values=1 2 3 4);
%array(_g,values=A A A A);
%array(_h,values=B B B B);

/*---- generate the select clause utlnopts turns everthing off so just the put statements appear in the log ----*/
%utl_nopts;
data _null_;
put 'select';
%do_over(_r _g,phrase=%str( put ",?_g?_r.*";));
put 'select';
%do_over(_r _h,phrase=%str( put ",?_h?_r.*";));
run;quit;

/*---- generate the select clause utlnopts turns everthing off so just the put statements appear in the log ----*/
data _null_;
%do_over(_r _g,phrase=%str(put
"(select * from have (rename=(c=c?_r s=s?_r end=end?_r)) where mod(monotonic()-1,4)+1 =?_r and vin='?_g' ) as ?_g?_r)"));
put 'union';
%do_over(_r _h,phrase=%str(put
"(select * from have (rename=(c=c?_r s=s?_r end=end?_r)) where mod(monotonic()-1,4)+1 =?_r and vin='?_h' ) as ?_h?_r)"));
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  CODE GENERATED USING ARRA AND DO_OVER MACRO                                                                           */
/*                                                                                                                        */
/*  select                                                                                                                */
/*  ,A1.*                                                                                                                 */
/*  ,A2.*                                                                                                                 */
/*  ,A3.*                                                                                                                 */
/*  ,A4.*                                                                                                                 */
/*  select                                                                                                                */
/*  ,B1.*                                                                                                                 */
/*  ,B2.*                                                                                                                 */
/*  ,B3.*                                                                                                                 */
/*  ,B4.*                                                                                                                 */
/*                                                                                                                        */
/*  (select * from have (rename=(c=c1 s=s1 end=end1)) where mod(monotonic()-1,4)+1 =1 and vin='A' ) as A1).               */
/*  (select * from have (rename=(c=c2 s=s2 end=end2)) where mod(monotonic()-1,4)+1 =2 and vin='A' ) as A2).               */
/*  (select * from have (rename=(c=c3 s=s3 end=end3)) where mod(monotonic()-1,4)+1 =3 and vin='A' ) as A3).               */
/*  (select * from have (rename=(c=c4 s=s4 end=end4)) where mod(monotonic()-1,4)+1 =4 and vin='A' ) as A4)                */
/*  union                                                                                                                 */
/*  (select * from have (rename=(c=c1 s=s1 end=end1)) where mod(monotonic()-1,4)+1 =1 and vin='B' ) as B1).               */
/*  (select * from have (rename=(c=c2 s=s2 end=end2)) where mod(monotonic()-1,4)+1 =2 and vin='B' ) as B2).               */
/*  (select * from have (rename=(c=c3 s=s3 end=end3)) where mod(monotonic()-1,4)+1 =3 and vin='B' ) as B3).               */
/*  (select * from have (rename=(c=c4 s=s4 end=end4)) where mod(monotonic()-1,4)+1 =4 and vin='B' ) as B4).               */
/*                                                                                                                        */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*---- lets assemble the solution ----*/

proc sql;

 create
    table havXpo as
 select
     A1.*
    ,A2.*
    ,A3.*
    ,A4.*
 from
     (select * from have (rename=(c=c1 s=s1 end=end1)) where mod(monotonic()-1,4)+1 =1 and vin='A' ) as A1
    ,(select * from have (rename=(c=c2 s=s2 end=end2)) where mod(monotonic()-1,4)+1 =2 and vin='A' ) as A2
    ,(select * from have (rename=(c=c3 s=s3 end=end3)) where mod(monotonic()-1,4)+1 =3 and vin='A' ) as A3
    ,(select * from have (rename=(c=c4 s=s4 end=end4)) where mod(monotonic()-1,4)+1 =4 and vin='A' ) as A4
 union

 select
     B1.*
    ,B2.*
    ,B3.*
    ,B4.*
 from
     (select * from have (rename=(c=c1 s=s1 end=end1)) where mod(monotonic()-1,4)+1 =1 and vin='B' ) as B1
    ,(select * from have (rename=(c=c2 s=s2 end=end2)) where mod(monotonic()-1,4)+1 =2 and vin='B' ) as B2
    ,(select * from have (rename=(c=c3 s=s3 end=end3)) where mod(monotonic()-1,4)+1 =3 and vin='B' ) as B3
    ,(select * from have (rename=(c=c4 s=s4 end=end4)) where mod(monotonic()-1,4)+1 =4 and vin='B' ) as B4
;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* I shortened the variable names to fit                                                                                  */
/*                                                                                                                        */
/* Up to 40 obs from last table WORK.HAVXPO total obs=2 02MAY2023:16:38:52                                                */
/*                                                                                                                        */
/* VIN C1      S1       END1      C2       S2         END2      C3       S3         END3      C4       S4         END4    */
/*                                                                                                                        */
/*  A  c1   01JAN202  05JAN202    c2    06JAN202    10JAN202    c3    11JAN202    15JAN202    c4    16JAN202    19JAN202  */
/*  B  c5   01FEB202  02FEB202    c6    03FEB202    10FEB202    c7    11FEB202    20FEB202    c8    21FEB202    28FEB202  */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*   _ _               _                                            _
  __| (_)_ __ ___  ___| |_    __ _ _ __  _ __  _ __ ___   __ _  ___| |__
 / _` | | `__/ _ \/ __| __|  / _` | `_ \| `_ \| `__/ _ \ / _` |/ __| `_ \
| (_| | | | |  __/ (__| |_  | (_| | |_) | |_) | | | (_) | (_| | (__| | | |
 \__,_|_|_|  \___|\___|\__|  \__,_| .__/| .__/|_|  \___/ \__,_|\___|_| |_|
                                  |_|   |_|
*/

%array(_r,values=1 2 3 4);
%array(_g,values=A A A A);
%array(_h,values=B B B B);

proc sql;
 create
    table havXpo as
 select
    %do_over(_r _g,phrase=%str(?_g?_r.*),between=comma)
 from
    %do_over(_r _g,phrase=%str(
    (select * from have (rename=(c=c?_r s=s?_r end=end?_r)) where mod(monotonic()-1,4)+1 =?_r and vin="?_g" ) as ?_g?_r),between=comma)
    union
 select
    %do_over(_r _h,phrase=%str(?_h?_r.*),between=comma)
 from
    %do_over(_r _h,phrase=%str(
    (select * from have (rename=(c=c?_r s=s?_r end=end?_r)) where mod(monotonic()-1,4)+1 =?_r and vin="?_h" ) as ?_h?_r),between=comma)
;quit;

%arraydelete(_r);
%arraydelete(_g);
%arraydelete(_h);

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/


