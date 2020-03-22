* export collapsed lockdown+census data to xls 

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

* read data 
use "$output/lockdown-pca.dta", clear

* collapse 
collapse (sum) no_hh_* tot_?_*, by(lockdown)

* format 
format no_hh_rural-tot_f_urban %15.0gc

* export to excel 
export excel using "$output/lockdown-pca-2011.xlsx", replace  firstrow(variables)
