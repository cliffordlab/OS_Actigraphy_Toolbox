# Open Source Actigraphy Toolbox
Matlab code to analyze actigraphy data. Each of following methods is stored in their own folder inside this repository.

## Preprocessing
* Bandpass filters
* Cole and Oakley methods for converting accelerometer signal to activity counts
* Conversion to time-day matrix format which is required by Rest-Activity Metric calculation

## Rest-Activity Metrics 
For calculating Rest-Activity Metrics, use **convert2Hours** to get required time-day matrix data format. Then use **preprocessRA** to eliminate missing hours.
* Interday stability
* Intraday variability
* Least active 5 hours
* Most active 10 hours
* testRestActivityFunctions: Testing if new RA functions work as described by the author
* testMissingData: Trying to find optimal method to combat against missing data

## Circadian Rhythm
* Cosinor Rhymometry
* υ<sub>τ</sub> (v_tau), a measure of stability in rest-activity rhythm
* Dichotomy Index (I<O)
* Autocorrelation Coefficient (r24)

## Sleep Detection
* Sleep detection with Oakley method

## Visualize Data
* Double plot for visualizing actigraphy data over a couple of days

## References
For references, please look at header of each code.
