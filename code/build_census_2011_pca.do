* build primary census abstract data tables (india & states/uts - district level) (excel format)
* source: http://censusindia.gov.in/2011census/population_enumeration.html

* preliminaries 
clear all 
set rmsg on 
set more off 
if "`c(username)'" == "aadit" {
	global path = "C:/Users/`c(username)'/Documents/GitHub/covid-19-india-lockdown/"
}
else if "`c(username)'" == "USER" {
	global path = "C:/Users/`c(username)'/Indian School of Business/Aaditya Dar - prohibition"
}
else {
	display as error "Please specify root directory" ///
	"Your username is: `c(username)'" ///
	"Replace yourName with `c(username)'" 
	exit 
}

* global build path 
global input "$path/input"
global code "$path/code"
global output "$path/output"
global temp "$path/temp"

*************************************************
*** pca data 
*************************************************

* read xls 
import excel using "$input/censusindiagovin_DDW_PCA0000_2011_Indiastatedist.xlsx", clear firstrow

* rename 
rename *, lower 
rename * *_

* clean string variables
ds, has(type string)
foreach var in `r(varlist)' {
    replace `var' = strtrim(stritrim(lower(`var')))
} 

* mop up 
drop if level != "district"
drop subdistt-level 

* reshape to wide 
reshape wide no_hh-non_work_f, i(state district name) j(tru) string

* save 
compress
isid district
save "$temp/census_2011_pca.dta", replace 
