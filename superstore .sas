/* Importing the data*/
proc import datafile="/home/u61739232/My Projects/superstore_dataset2011-2015 - Copy.csv"
            out=store
            dbms=csv
            replace; /* use REPLACE option to replace existing data set */
run;

/* checking the dataset content*/
PROC CONTENTS DATA = store; 
RUN;

/* Determine the number of unique values in each categorical variable */
proc freq data=store;
  tables ShipMode	Segment	Region	OrderPriority	Sales	Quantity	Discount	Profit	ShippingCost	TotalSale	SalesAfterDiscount;
run;

/* Data summary*/
proc means data=store;
   var _numeric_;
   output out=summary_stats mean= Mean std=StdDev min=Minimum max=Maximum; 
run;

/* Treatment of missing Data*/
PROC FORMAT;
	VALUE $missing_char
		' ' = 'Missing'
		other = 'Present';
	
	VALUE missing_num
		. = 'Missing'
		other = 'Present';
RUN;

TITLE 'Listing of Present and Missing Data for Each Variable';
PROC FREQ DATA = store;
	TABLES _all_ / missing;
	FORMAT _character_ $missing_char. _numeric_ missing_num.;
RUN;
TITLE;

/* DATA EXPLORATION*/

proc sgplot data=store;
  boxplot TotalSale; 
  xaxis label="Region";
  yaxis label="Total Sales";
run;


/*Boxplot of Discount based on Segment*/
PROC SGPLOT  DATA = store;
   VBOX DISCOUNT / category = Segment;
   title 'Boxplot of Discount based on Segment'
RUN;

/*Average sales after discount by segment*/
proc means data=STORE mean;
  class Segment;
  var SalesAfterDiscount;
  output out=means mean=Mean;
run;
proc sgplot data=means;
  vbar Segment / response=Mean stat=mean datalabel datalabelpos=data datalabelattrs=(size=10pt) datalabelpercent;
  yaxis grid label="Mean Sales After Discount" offsetmin=0.02;
  xaxis label="Segment";
  title 'Average sales after discount by segment'
run;

/*Average Profit by Region*/
proc means data=STORE mean;
  class Region;
  var Discount;
  output out=means mean=Mean;
run;
proc sgplot data=means;
  vbar Region / response=Mean stat=mean datalabel datalabelpos=data datalabelattrs=(size=10pt) datalabelpercent;
  yaxis grid label="Profit" offsetmin=0.02;
  xaxis label="Region";
  title 'Average Profit by Region'
run;

/*Average Profit by Shipmode*/
proc means data=STORE mean;
  class shipmode;
  var Discount;
  output out=means mean=Mean;
run;
proc sgplot data=means;
  vbar Shipmode / response=Mean stat=mean datalabel datalabelpos=data datalabelattrs=(size=10pt) datalabelpercent;
  yaxis grid label="Profit" offsetmin=0.02;
  xaxis label="shipmode";
  title 'Average Profit by shipmode'
run;

/*Average Sales by Shipmode*/
proc means data=STORE mean;
  class shipmode;
  var sales;
  output out=means mean=Mean;
run;
proc sgplot data=means;
  vbar Shipmode / response=Mean stat=mean datalabel datalabelpos=data datalabelattrs=(size=10pt) datalabelpercent;
  yaxis grid label="Sales" offsetmin=0.02;
  xaxis label="shipmode";
  title 'Average Sales by shipmode'
run;

/*Average Sales after Discount by Shipmode*/
proc means data=STORE mean;
  class shipmode;
  var salesafterdiscount;
  output out=means mean=Mean;
run;


proc sgplot data=means;
  vbar Shipmode / response=Mean stat=mean datalabel datalabelpos=data datalabelattrs=(size=10pt) datalabelpercent;
  yaxis grid label="Salessfterdiscount" offsetmin=0.02;
  xaxis label="shipmode";
  title 'Average Sales after Discount by Shipmode'
run;

/*Average sales by Ship Mode*/
proc means data=STORE mean;
  class shipmode;
  var Sales;
  output out=means mean=Mean;
run;
proc sgplot data=means;
  vbar shipmode / response=Mean stat=mean datalabel datalabelpos=data datalabelattrs=(size=10pt) datalabelpercent;
  yaxis grid label="Mean Sales" offsetmin=0.02;
  xaxis label="shipmode";
  title 'Average sales by Ship Mode'
run;


/*Average sales after discount by Ship Mode*/
proc means data=STORE mean;
  class shipmode;
  var SalesAfterDiscount;
  output out=means mean=Mean;
run;
proc sgplot data=means;
  vbar shipmode / response=Mean stat=mean datalabel datalabelpos=data datalabelattrs=(size=10pt) datalabelpercent;
  yaxis grid label="Mean Sales After Discount" offsetmin=0.02;
  xaxis label="shipmode";
  title 'Average sales after discount by Ship Mode'
run;

/*Average Quantity by Ship Mode*/
proc means data=STORE mean;
  class shipmode;
  var quantity;
  output out=mean mean=Mean;
run;
proc sgplot data=means;
  vbar shipmode / response=Mean stat=mean datalabel datalabelpos=data datalabelattrs=(size=10pt) datalabelpercent;
  yaxis grid label="Mean Quantity" offsetmin=0.02;
  xaxis label="shipmode";
  title 'Average Quantity by Ship Mode'
run;

/*Quantity distribution by order priority*/
proc sgplot data=store;
  histogram Quantity;
  title 'Quantity distribution by order priority';
run;

/*Profit by shipping cost scatter plot*/
proc sgplot data=store;
  scatter x=ShippingCost y=Profit;
  title 'Profit by shipping cost scatter plot';
run;

/*Sales distribution by ship mode and region*/
proc sgplot data=store;
  histogram Sales / group=ShipMode group=Region;
  title 'Sales distribution by ship mode and region';
run;

/*Discount distribution*/
proc sgplot data=store;
  histogram Discount;
  title 'Discount distribution';
run;

/*Average shipping cost by region and segment*/
proc means data=store mean;
  class Region Segment;
  var ShippingCost;
run;

/* Average profit margin by segment and region */
proc sql;
  select Segment, Region, (sum(Profit) / sum(Sales)) as Avg_Profit_Margin
  from store
  group by Segment, Region;
quit;

/*TotalSales distribution*/
proc sgplot data=store;
  histogram TotalSale;
  title 'TotalSales distribution';
run;

/*Average discount by region*/
proc means data=store mean;
  class Region;
  var Discount;
run;

/*Total sales by product Region*/
proc sql;
  select Region, sum(TotalSale) as TotalSales
  from store
  group by region;
quit;

/*Profit by sales after discount scatter plot*/
proc sgplot data=store;
  scatter x=SalesAfterDiscount y=Profit;
  title 'Profit by sales after discount scatter plot';
run;

/*Profit by sales after discount scatter plot*/
proc sgplot data=store;
  scatter x=SalesAfterDiscount y=Profit;
  title 'Profit by sales after discount scatter plot';
run;

/* Plot histograms to visualize the distribution of continuous variables */
proc univariate data=store;
  var Sales Quantity Discount Profit ShippingCost TotalSale SalesAfterDiscount;
  histogram / normal; /* plot histograms */
run;

/*CORRELATION ANALYSIS*/
/* Calculate correlation coefficients */
proc corr data=store;
  var Sales Quantity Discount Profit ShippingCost TotalSale SalesAfterDiscount;
run;

/* Plot scatter plot matrix */
proc sgscatter data=store;
  matrix Sales Quantity Discount Profit ShippingCost TotalSale SalesAfterDiscount;
  title 'Plot scatter plot matrix'
run;

/* Compute means and percentages */
proc means data=store mean;
  class shipmode;
  var profit;
  output out=means mean=Mean;
run;


/*STATISTICAL TESTS*/
/* Chi-squared test */
proc freq data=store;
  tables ShipMode * OrderPriority;
run;

/* T-test on Sales based on Segment */
proc ttest data=store;
  class Segment;
  var Sales;
run;

/* ANOVA using PROC GLM */
proc glm data=store;
  class OrderPriority;
  model Sales = OrderPriority;
  means Order_Priority / hovtest=levene;
  ods output HOVTESTS=leveneTest; /* output the Levene's test results */
  means Order_Priority / tukey; /* perform Tukey's post-hoc test for pairwise comparisons */
run;


/*REGRESSION MODEL*/
/* Linear regression to predict Sales based on Quantity and Discount */
proc reg data=store;
  model Sales = Quantity Discount;
run;


