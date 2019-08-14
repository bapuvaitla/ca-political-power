Filename: state_g16_sov_data_by_g16_srprec.dbf, state_g16_sov_data_by_g16_srprec.csv

File URL: http://statewidedatabase.org/pub/data/G16/state/state_g16_sov_data_by_g16_srprec.zip

Dataset: 2016 General Election Precinct Data

Description: Statewide Statement of Vote data file containing precinct level voting results for statewide races.

Unit of analysis: SR precincts are derived from consolidated precincts and are a geographic unit constructed for statistical merging purposes by the Statewide Database.

Data source:	Statewide Database - University of California, Berkeley

Technical documentation:	http://statewidedatabase.org/d10/Creating%20CA%20Official%20Redistricting%20Database.pdf

Codebooks:	The 58 Statement of Vote data county codebooks can be accessed from the election's precinct data page,
http://statewidedatabase.org/d10/g16.html

County records unavailable at time of file creation:	none

Date last modified:	02/19/2019 

Previous versions:	01/26/2018,	08/27/2017 		

Note 1. How to use the SOV codebooks to determine the names of the candidates that were on the ballot in a specific precinct.

The SOV data file codebooks are county and election specific. The names of the candidates that ran in the Assembly, Senate, Congressional and Board of Equalization 
district based races vary by county for each election depending on which Assembly, Senate, Congressional and Board of Equalization districts are within the county.

The specific Assembly, Congressional, Senate and Board of Equalization districts that each precinct are in can be located in the SOV data file fields labeled 
'ADDIST,' 'CDDIST,' 'SDDIST' and 'BOEDIST.'

In order to determine the names of the candidates that were on a ballot this election in a given precinct, retrieve the district number from the SOV data table for that precinct record 
and then look up the candidate's name in the sov data codebook for that county.
 
For example in the 2012 Primary Election, Sonoma County SV precinct '1001' was located in the 5th Congressional distric according to the state_p12_sov_data_by_p12_svprec.dbf. 

Referring to 2012 Primary Sonoma County sov data codebook, 097.codes allows one to determine that the 'cngdem01' candidate that ran in the 5th congressional district i.e.  
'CNG05DEM01' was Mike Thompson. According to the same file, SV precinct '1048' is located in the 2nd Congressional and in this precinct, the 'cngdem01' candidate running 
for the district, 'CNG02DEM01' was Susan Adams. 

In cases where there was no party candidate running in the race, the records in the sov data table will be all zeros. Please see the 2012 Primary 2nd Congressional Green 
Party candidate, 'cnggrn01' in the state_p12_sov_data_by_p12_svprec.dbf for an example of this scenario. 	

