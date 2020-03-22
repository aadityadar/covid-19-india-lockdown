* graph population affected by lockdown

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

* relabel 
* label drop lockdown
* label define lockdown 0 "No lockdown (563 districts)" 1 "Lockdown (77 districts)"
* label values lockdown_center lockdown

* total population  
graph pie tot_p_total, over(lockdown_center) noclockwise ///
plabel(_all percent, size(*1.5)) ///
pie(1, explode c("127 201 127")) ///
pie(2, c("190 174 212")) ///
legend(position(6)) ///
title("Population affected by COVID-19 district lockdown in India", pos(12)) ///
subtitle("(Estimated from Census of India 2011)") /// 
note("Code and data: https://github.com/aadityadar/covid-19-india-lockdown")

graph export "$output/lockdown-total-population.png", replace 

* urban population
colorpalette Accent
graph pie tot_p_urban, over(lockdown_center) noclockwise ///
plabel(_all percent, size(*1.5)) ///
pie(1, explode c("`r(p5)'")) ///
pie(2, c("`r(p3)'")) ///
legend(position(6)) ///
title("Fraction of urban population affected by Indian district lockdown", pos(12)) ///
subtitle("(Estimated from Census of India 2011)") /// 
note("Code and data: https://github.com/aadityadar/covid-19-india-lockdown")

graph export "$output/lockdown-urban-population.png", replace 
