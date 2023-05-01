%let pgm=utl-three-algorithms-to-transpose-sets-of-variables;


https://tinyurl.com/wvhj2sar
https://stackoverflow.com/questions/74438398/transpising-observations-into-one-row-in-sas

Three algorithms to transpose sets of variables;

    Solutions
         1. Art et all. Transpose macro
            By Arthur Tabachneck, Xia Ke Shan, Robert Virgile and Joe Whitehurst
         2. Concat
         3. Stu Sztukowski
            https://stackoverflow.com/users/5342700/stu-sztukowski
/*                 _
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

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
