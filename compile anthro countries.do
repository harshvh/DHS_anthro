local type KR


******************************
***Import full country list***
******************************

import delimited "1 raw data `type'/ID.txt", delimiter(";") clear
rename v1 abbrev
rename v2 full_name
sort abbrev
replace full_name = ustrltrim(full_name)


**********************
***Select countries***
**********************

levelsof full_name, local(countries)

**********************************
***Select variables of interest***
**********************************

local child_health caseid v000 v005 b4 hw1 hw2 hw3

***************************
***Save reduced datasets***
***************************


foreach c of local countries {

	local directories: dir "1 raw data `type'/`c'" dirs "*"

	foreach d of local directories {
	
		display as text "Folder: `d'"
		local f: subinstr local d "DT" "FL", all 	
		display as text "File: `f'"
		use "1 raw data `type'/`c'/`d'/`f'", clear
		
		local keeplist_full `child_health'
		local keeplist_new `keeplist_full'
		
		foreach k of local keeplist_full {
				
			capture confirm variable `k' 
			
			if _rc {
			
				di in red "`k' does not exist in `f'"
				local keeplist_new: list keeplist_new - k
				display as text `" `keeplist_new' "'
			
			} 
		
		}
		
		keep `keeplist_new' 
		gen country = "`c'"
		save "2 modified data/temporary/`f'_mod", replace	
			
	}

}


******************************************************************
***Append all reduced datasets and drop irrelevant observations***
******************************************************************

local first AF`type'70FL_mod.dta   // first dataset to which all others will be appended (change if necessary)

local mod_files: dir "2 modified data/temporary" files "*.dta"
display as text `" `first' "'
display as text `" `mod_files' "'
local mod_files: list mod_files - first
display as text `" `mod_files' "'

use "2 modified data/temporary/`first'", clear

gen source = "`first'"

foreach f of local mod_files {

	display as text `" `f' "'
	qui append using "2 modified data/temporary/`f'", gen(appended)
	erase "2 modified data/temporary/`f'"
	replace source = "`f'" if appended == 1
	drop appended


}

erase "2 modified data/temporary/`first'"

************************
***Save compiled data***
************************

save "2 modified data/compiled_data_`type'.dta", replace
