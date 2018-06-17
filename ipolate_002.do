** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a999\003-ecological_predictors\2017-07"
log using ipolate_001, replace

**  GENERAL DO-FILE COMMENTS
//  program:      ipolate_001.do
//  project:      Ipolate missing data
//  author:       HAMBLETON \ 16-JUL-2017

** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 80 

** Load dataset
use ageadjustedrates.dta, clear

** Numeric for country
egen cid = group(country)
labmask cid, values(country)
label var cid "Internal country ID"
drop country
order cid

** Example usng Antigua
keep if cid==2 & sex==1

** Register missing as missing
mvdecode actual , mv(0=.)

** METHOD 1
** Fillin missing using ipolate
ipolate actual year , gen(rate_f1)
order rate_f1, after(actual)
label var rate_f1 "Rate with filled values: method 1"

** METHOD 2
** Fillin missing using lowess smoothing
lowess actual year , gen(rate_t1) bw(0.5) nogr
ipolate rate_t1 year , gen(rate_f2) 
drop rate_t1
order rate_f2, after(rate_f1)
label var rate_f2 "Rate with filled values: method 2"

** METHOD 3
** Fillin missing using robust nonlinear smoother
smooth 3rssh,twice rate_f1, gen(rate_f3) 
*ipolate rate_t1 year , gen(rate_f2) epolate 
order rate_f3, after(rate_f2)
label var rate_f3 "Rate with filled values: method 3"
