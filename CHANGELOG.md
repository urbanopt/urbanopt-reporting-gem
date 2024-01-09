# URBANopt Reporting Gem

## Version 0.9.1
* downgrade json-schema to 2.7 by @vtnate in https://github.com/urbanopt/urbanopt-reporting-gem/pull/145

## Version 0.9.0
Date Range: 6/30/23 - 01/09/24

* Support OpenStudio 3.7 by @vtnate in https://github.com/urbanopt/urbanopt-reporting-gem/pull/142
* add tx incoming and outgoing voltages to power distribution reporting by @vtnate in https://github.com/urbanopt/urbanopt-reporting-gem/pull/138
* fix schema typos and errors by @vtnate in https://github.com/urbanopt/urbanopt-reporting-gem/pull/140
* remove Jenkinsfile by @vtnate in https://github.com/urbanopt/urbanopt-reporting-gem/pull/139
* trigger CI on PR review_request by @vtnate in https://github.com/urbanopt/urbanopt-reporting-gem/pull/141
* Update export modelica loads by @vtnate in https://github.com/urbanopt/urbanopt-reporting-gem/pull/143

## Version 0.8.0
Date Range: 12/12/22 - 6/30/23

- Added the `feature_location` argument in measure.xml
- Updated dependencies & CI for OpenStudio 3.6.1
- Updated license and references to the license file

## Version 0.7.0
Date Range: 08/18/22 - 12/12/22

- Update Dependencies for OpenStudio 3.5.0
- Fixed [#106]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/106 ), Update UO reporting schema to include DISCO outputs
- Fixed [#107]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/107 ), QAQC reporting rollup in feature report and scenario report
- Fixed [#127]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/127 ), Clean up log output to stdout


## Version 0.6.2
Date Range: 06/28/22 - 08/17/22

- Fixed [#118]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/118 ), set up actions with coveralls
- Fixed [#119]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/119 ), emissions bug fix

## Version 0.6.1
Date Range: 05/10-22 - 06/27/22

- Fixed [#114]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/114 ), added natural gas, propane and fuel oil emissions reporting

## Version 0.6.0
Date Range: 11/22/21 - 05/09/22

- Fixed [#95]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/95 ), adding additional PV fields to UO output reports
- Fixed [#98]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/98 ), add RNM results fields to schema
- Fixed [#100]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/100 ), add EV charging control EMS timeseries outputs in default reports
- Fixed [#101]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/101 ), add reopt and opendss fields to reporting schema
- Fixed [#104]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/104 ), Add renewable pct to reporting output
- Fixed [#108]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/108 ), Adding emissions results to UO reports

## Version 0.5.0
Date Range: 11/13/21 - 11/22/21

- Updated dependencies for OpenStudio 3.3

## Version 0.4.3
Date Range: 10/16/21 - 11/12/21

- Fixed [#93]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/93 ), Fix aggregation of storage system typo

## Version 0.4.2
Date Range: 07/01/21 - 10/15/21

- Fixed [#86]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/86 ), Add location of PV to Scenario and Feature optimization reopt reports #86
- Fixed [#77]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/77 ), Fix test_with_openstudio model failures

## Version 0.4.1
Date Range: 04/27/23 - 07/01/21

- Fixed [#80](https://github.com/urbanopt/urbanopt-reporting-gem/issues/80), Update rubocop configs to v4

## Version 0.4.0

Date Range: 03/27/21 - 04/26/21

- Update dependencies for OpenStudio 3.2.0 and Ruby 2.7

## Version 0.3.7

Date Range: 02/12/21 - 03/26/21

- Fixed [#47]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/47 ), Default features report bugfixes and updates
- Fixed [#67]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/67 ), Update copyrights for 2021
- Fixed [#70]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/70 ), feature report bug fix

## Version 0.3.6

Date Range: 02/05/21 - 02/11/21

- Fixed [#64]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/64 ), EnergyPlus changed output fuel names in version 9.4

## Version 0.3.5

Date Range: 01/16/21 - 02/04/21

- Fixed [#58]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/58 ), Feature report saving bug fix.
- Fixed [#60]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/60 ), Added EV/ ExteriorEquipment results to csv and json reports
- Fixed [#61]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/61 ), Enhance the aggregation of enduses.


## Version 0.3.4

Date Range: 01/14/21 - 01/15/21

- Fixed [#53]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/53 ), Make subfolders in feature saving if necessary
- Fixed [#55]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/55 ), Fix new measures

## Version 0.3.3

Date Range: 12/09/20 - 01/13/21

- Fixed [#36]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/36 ), Add reporting measure for district heating/cooling system mass flow rates
- Fixed [#37]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/37 ), Add EUI to default report
- Fixed [#38]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/38 ), Add better error handling around convert_units
- Fixed [#43]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/43 ), Add available_roof_area calculation
- Fixed [#44]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/44 ), Fix coordinates order

## Version 0.3.2

Date Range: 12/07/20 - 12/08/20

- Fixed [#27]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/27 ), reporting measure fails when there are no additional fuels in the model
- Fixed [#29]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/29 ), restore save_feature_report function for backward compatibility
- Fixed [#32]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/32 ), bump extension-gem dependency

## Version 0.3.1

Date Range: 11/26/2020 - 12/07/2020

- Fixed [#19]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/19 ), check for nil values to avoid crashing unit conversion
- Fixed [#24]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/24 ), Support reporting of other fuels
- Fixed [#28]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/28 ), fix for other_fuels being nil and restore save_feature_report function

## Version 0.3.0

Date Range: 11/12/2020 - 11/25/2020

- Updating dependencies to support OpenStudio 3.1.0

## Version 0.2.1

Date Range: 09/22/2020 - 11/12/2020

- Fixed [#12]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/12 ), add units to the json report attributes
- Fixed [#14]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/14 ), Add rdocs
- Fixed [#16]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/16 ), increase sidebar width to show class names
- Fixed [#18]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/18 ), measure: Handle nil values that crash OpenStudio.convert
- Fixed [#20]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/20 ), fixed saving csv results bug

## Version 0.2.0

Date Range: 08/27/2020 - 09/21/2020

- Fixed [#5]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/5 ), bug fixes related to REopt classes
- Fixed [#7]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/7 ), adding TM symbol
- Fixed [#8]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/8 ), New reopt results

## Version 0.1.1

08/26/2020

- Adding thermal storage reporting
- Fix paths for reporting and scenario gems split

## Version 0.1.0

08/17/2020

Initial release of the urbanopt-reporting gem.
