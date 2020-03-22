* merge lockdown data with census population 

* preliminaries 
clear all 
set rmsg on 
set more off 
set scheme burd 
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
*** prep lock downdata
*************************************************

* read lgd data 
import excel using "$input/covid-19-district-lockdown.xlsx", clear firstrow sheet("data")

* rename
rename *, lower 

* clean string variables
ds, has(type string)
foreach var in `r(varlist)' {
    replace `var' = strtrim(stritrim(lower(`var')))
}

* drop missing obs 
missings dropobs, force
drop if notes == "total"

* sanity check 
destring districtcode2020, replace 
isid districtcode2020 

* prep to merge 
drop sno-census2001code 
clonevar district_ = census2011code

* merge pca data 
merge m:1 district_ using "$temp/census_2011_pca.dta", gen(m_pca)

* 3 districts that are lockdown dont have pca data 
tab m_pca if lockdown_center == 1

* drop unmatched districts 
drop if m_pca != 3 

* label 
label define lockdown 0 "No lockdown" 1 "Lockdown (80 districts)"
label values lockdown_center lockdown

* save 
compress 
save "$output/lockdown-pca.dta", replace 


