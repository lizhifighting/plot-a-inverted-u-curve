cd "D:\Projects\视频录制\20210608"

import excel "Population and CO2 per capita_Countries.xlsx" , sheet("CO2") firstrow clear
rename CO2 year 
foreach x of varlist Austria-Uruguay {
rename  `x' co2`x'
}
reshape long co2 , i(year) j(country) string
tempfile co2
save `co2'

import excel "Population and CO2 per capita_Countries.xlsx" , sheet("percapital") firstrow clear
rename RealGDP year 
foreach x of varlist Austria-Uruguay {
rename  `x' percapital`x'
}
reshape long percapital , i(year) j(country) string
gen lnpercapital = ln(percapital)
tempfile percapital
save `percapital'

import excel "Population and CO2 per capita_Countries.xlsx" , sheet("CO2 per capita") firstrow clear
rename CO2percapita year
foreach x of varlist Austria-Uruguay {
rename  `x' co2_per_capital`x'
}
reshape long co2_per_capital , i(year) j(country) string
tempfile co2_per_capital
save `co2_per_capital'


merge 1:1 year country using `co2'
drop _merge
merge 1:1 year country using `percapital'
drop _merge
save forekc,replace

twoway (scatter co2_per_capital percapital) (qfit  co2_per_capital percapital), by(country)
// twoway (scatter co2_per_capital lnpercapital) (qfit  co2_per_capital lnpercapital), by(country)
encode country,gen(country_new)
drop country 
rename country_new country
xtset country year
gen percapital_2=percapital*percapital
gen percapital_3=percapital_2*percapital
xtreg co2_per_capital percapital , fe r
xtreg co2_per_capital percapital percapital_2 percapital_3, fe r