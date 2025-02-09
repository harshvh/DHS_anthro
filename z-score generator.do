/*	Example: survey_restricted.do using survey.dta */

clear

set more 1

/*	Higher memory might be necessary for larger datasets */

set memory 20m
set maxvar 10000

/* Indicate to the Stata compiler where the igrowup_restricted.ado file is stored*/

adopath + "E:\DHS\WHO standard\stata"

/* Load the data file */

use "E:\DHS\1 raw data KR\India\IAKR71DT\IAKR71FL.dta", clear

/* generate the first three parameters reflib, datalib & datalab	*/

gen str60 reflib="E:\DHS\WHO standard\stata"
lab var reflib "Directory of reference tables"

gen str60 datalib="E:\DHS\WHO standard\stata"
lab var datalib "Directory for datafiles"

gen str30 datalab="mysurvey"
lab var datalab "Working file"

/*	check the variable for "sex"	1 = male, 2=female */
rename b4 gender
desc gender
tab gender


/*	check the variable for "age"	*/
rename hw1 agemons
desc agemons
summ agemons


/*	define your ageunit	*/
gen str6 ageunit="months"				/* or gen ageunit="days" */
lab var ageunit "=days or =months"


/*	check the variable for body "weight" which must be in kilograms*/
/* 	NOTE: if not available, please create as [gen weight=.]*/
gen weight=hw2/10
desc weight 
summ weight

/* 	check the variable for "height" which must be in centimeters	*/ 
/* 	NOTE: if not available, please create as [gen height=.]*/
gen height=hw3/10
desc height 
summ height


/*	check the variable for "measure"*/
/* 	NOTE: if not available, please create as [gen str1 measure=" "]*/
gen str1 measure=" "
desc measure
tab measure

/* 	check the variable for "oedema"*/
/* 	NOTE: if not available, please create as [gen str1 oedema="n"]*/
gen str1 oedema="n"
desc oedema
tab oedema


/*	check the variable for "sw" for the sampling weight*/
/* 	NOTE: if not available, please create as [gen sw=1]*/
rename v005 sw
desc sw
summ sw

/* 	Fill in the macro parameters to run the command */
igrowup_restricted reflib datalib datalab gender agemons ageunit weight height measure oedema sw

