/* Feature engineering */
data vungle.vungle_new;
	set vungle.vungle;
	CompletionRateA = CompletesA / ImpressionsA;
	CompletionRateB = CompletesB / ImpressionsB;
	CtrA = ClicksA / ImpressionsA;
	CtrB = ClicksB / ImpressionsB;
	ConversionRateA = InstallsA / ImpressionsA;
	ConversionRateB = InstallsB / ImpressionsB;
	CompletionRateDiff = CompletionRateB – CompletionRateA;
	CtrDiff = CtrB – CtrA;
	ConversionRateDiff = ConversionRateB – ConversionRateA;
	eRPMDiff = eRPMB – eRPMA;
run;


/* Analysis of A/B testing results using conversion rates */
ods noproctitle;
ods graphics / imagemap=on;

proc univariate data=VUNGLE.VUNGLEPAIRED_NEW normal mu0=0;
	ods select TestsForNormality;
	var ConversionRateDiff;
run;

proc ttest data=VUNGLE.VUNGLEPAIRED_NEW sides=U h0=0 plots(showh0);
	var ConversionRateDiff;
run;


/* Analysis of A/B testing results using eRPM */
ods noproctitle;
ods graphics / imagemap=on;

proc univariate data=VUNGLE.VUNGLEPAIRED_NEW normal mu0=0;
	ods select TestsForNormality;
	var eRPMDiff;
run;

proc ttest data=VUNGLE.VUNGLEPAIRED_NEW sides=2 h0=0 plots(showh0);
	var eRPMDiff;
run;


/* Conclusion:
- The assumptions underlying the analysis include:
	+ Data points collected under versions A and B are randomly assigned.
	+ The assignment to version A or B is mutually exclusive. In other words, 
	a user can only see either version A or version B over the 30 day period, 
	not both.
	+ The distribution of the data points is normal.
- Based on the calculation of the differences between conversion rates 
of versions A and B, and the null hypothesis that 
ConversionRateB – ConversionRateA > 0, we fail to reject the null hypothesis 
because the p-value of ConversionRateDiff = 1. Therefore, version B does not 
do better than version A in terms of conversion rate.
- Based on the calculation of the differences between eRPM of version A and B, 
and the null hypothesis that eRPMB – eRPMA > 0, we reject the null hypothesis 
because the p-value of eRPMDiff = 0.0024. Therefore, version B does better than 
version A in terms of revenue.
- If time and money are not constrained, we would advise Vungle to run the test 
again for a longer period of time to gather more data. We think that the 
performance of version B in terms of conversion rates differents from that in terms
of eRPM because of the noise in the small sample collected over the 30-day period.
- If time and money are constrained, because the goal of the company is to 
generate revenue, we would advise Vungle to adopt the new data science algorithm. 
The results suggest that although version B generates a lower conversion rate, 
it generates higher revenue by showing the ads whose contracts have higher monetary
value.
*/