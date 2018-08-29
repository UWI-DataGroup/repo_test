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

codebook year
codebook country
ttest actual sex
gr twoway line actual year if cid==5
