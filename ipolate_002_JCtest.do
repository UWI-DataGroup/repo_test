** HEADER -----------------------------------------------------
**  DO-FILE METADATA
//  algorithm name			    ipolate_002.do
//  project:				        Ipolate missing data
//  analysts:						    Ian HAMBLETON
//	date last modified	    28-Aug-2018
//  algorithm task			    Plotting mortality data

** General algorithm set-up
version 15
clear all
macro drop _all
set more 1
set linesize 80

** Set working directories: this is for DATASET and LOGFILE import and export
** DATASETS to encrypted SharePoint folder
local datapath "X:\The University of the West Indies\DataGroup - repo_data\data_test"
** LOGFILES to unencrypted OneDrive folder
local logpath X:\OneDrive - The University of the West Indies\repo_datagroup\repo_test

** Close any open log fileand open a new log file
capture log close
cap log using "`logpath'\ipolate_002", replace
** HEADER -----------------------------------------------------


** Load dataset
use "`datapath'\version01\1-input\ageadjustedrates.dta", clear

** Numeric for country
egen cid = group(country)
labmask cid, values(country)
label var cid "Internal country ID"
drop country
order cid

** Example usng Antigua
** keep if cid==2 & sex==1
** Example using Babbados
keep if cid==5 & sex==1

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

** Make graphic nicer

#delimit ;

graph twoway
  /// Line 1
  (line rate_f2 year , lc(gs0) lw(0.05) fc(purple))
  /// Line 2
  (line rate_f3 year , lc(red) lw(0.05) fc(brown))
  ,

  plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
  graphregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
  ysize(15) xsize(12.5)

  ///xlabel(-1 "-100%" -.5 "-50%" 0 "0" .5 "50%" 1 "100%" 1.5 "150%" 2 "200%", labsize(2))

  ylabel(, notick valuelabel angle(0) labsize(3))
  ///ytitle("") xtitle("Mortality rate",margin(top))
  yscale(noline)

  legend( order(1 2)
  label(3 "Fitted line 1")
  label(2 "Fitted line 2")
  cols(1) size(3) symysize(3) symxsize(3)
  )
  legend(region(lcolor(none))
  )
;
#delimit cr
