ModeSplitPugetSound
===================

An example of using literate programming to report travel trends from Census data.

Structure
---------
The general idea here is that R handles the data loading, formatting, processing, and plotting. Org-babel or knitr then embeds those R products into a report.

HTML output includes an interactive googleVis motion plot, however due to flash security issues does not load in most web browsers from a local file URL (e.g. file:///path/to/ModeSplit.html). Motionchart should display correctly when served via a web server.

**Warning:** The R code here is a pretty janky and non-modular



An example, purely for fun
----------------------------

<!-- MotionChart generated in R 2.15.0 by googleVis 0.2.16 package -->
<!-- Fri Jun 22 13:47:54 2012 -->


<!-- jsHeader -->
<script type="text/javascript" src="http://www.google.com/jsapi">
</script>
<script type="text/javascript">
 
// jsData 
function gvisDataMotionChartID7c051bfa22dc ()
{
  var data = new google.visualization.DataTable();
  var datajson =
[
 [
 "Drove alone",
new Date(2006,0,1),
1231475,
14482.90941,
70.43947345,
0.6355378019 
],
[
 "Carpooled",
new Date(2006,0,1),
204090,
8388.804086,
11.67379942,
0.4716831438 
],
[
 "Public transport",
new Date(2006,0,1),
131690,
6429.194662,
7.532572125,
0.3633286024 
],
[
 "Bicycled",
new Date(2006,0,1),
12784,
1749.509931,
0.7312354928,
0.09991854306 
],
[
 "Walked",
new Date(2006,0,1),
53676,
 3989.12083,
3.070228122,
0.2269962942 
],
[
 "Worked at home",
new Date(2006,0,1),
94654,
4298.824142,
5.414139889,
0.2424738811 
],
[
 "Drove alone",
new Date(2007,0,1),
1264960,
13655.19447,
70.54141832,
0.564761091 
],
[
 "Carpooled",
new Date(2007,0,1),
205123,
7568.275695,
11.43883392,
0.4138426908 
],
[
 "Public transport",
new Date(2007,0,1),
142653,
6781.316981,
7.955148738,
0.3737520635 
],
[
 "Bicycled",
new Date(2007,0,1),
12846,
1940.757069,
0.7163665727,
0.1081033522 
],
[
 "Walked",
new Date(2007,0,1),
61301,
4776.818188,
3.418495039,
0.2652301389 
],
[
 "Worked at home",
new Date(2007,0,1),
86572,
4808.436128,
4.827750812,
0.2658574257 
],
[
 "Drove alone",
new Date(2008,0,1),
1276601,
15682.83877,
 68.8225032,
0.7144265501 
],
[
 "Carpooled",
new Date(2008,0,1),
226314,
8950.888783,
12.20075497,
0.4758456843 
],
[
 "Public transport",
new Date(2008,0,1),
147489,
6564.341551,
7.951240971,
0.3500121717 
],
[
 "Bicycled",
new Date(2008,0,1),
16599,
1655.829097,
0.8948643552,
0.08907318175 
],
[
 "Walked",
new Date(2008,0,1),
68571,
6113.269829,
3.696713278,
0.3286748979 
],
[
 "Worked at home",
new Date(2008,0,1),
94770,
5310.131166,
5.109120727,
0.284298652 
],
[
 "Drove alone",
new Date(2009,0,1),
1259061,
 15057.5069,
69.46160212,
0.6316070052 
],
[
 "Carpooled",
new Date(2009,0,1),
203601,
9408.334284,
11.23253889,
0.5116651145 
],
[
 "Public transport",
new Date(2009,0,1),
156083,
6959.020764,
8.611000772,
0.378052565 
],
[
 "Bicycled",
new Date(2009,0,1),
16661,
2539.817513,
0.919176873,
0.1399380834 
],
[
 "Walked",
new Date(2009,0,1),
64054,
5291.828606,
3.533818824,
0.2906533828 
],
[
 "Worked at home",
new Date(2009,0,1),
93334,
7054.560298,
5.149177976,
  0.3871347 
],
[
 "Drove alone",
new Date(2010,0,1),
1248870,
12296.00016,
70.31870244,
0.4079991773 
],
[
 "Carpooled",
new Date(2010,0,1),
182465,
 6834.57709,
10.27384919,
0.3760492624 
],
[
 "Public transport",
new Date(2010,0,1),
144307,
6597.168862,
8.125330093,
0.3657931867 
],
[
 "Bicycled",
new Date(2010,0,1),
18184,
2697.344064,
1.023865803,
0.151657761 
],
[
 "Walked",
new Date(2010,0,1),
66472,
5524.101556,
3.742763289,
0.3096112119 
],
[
 "Worked at home",
new Date(2010,0,1),
96727,
5029.724148,
5.446297158,
0.2798697951 
] 
];
data.addColumn('string','year');
data.addColumn('date','mode');
data.addColumn('number','estimate');
data.addColumn('number','MOE');
data.addColumn('number','pctestimate');
data.addColumn('number','pctMOE');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartMotionChartID7c051bfa22dc() {
  var data = gvisDataMotionChartID7c051bfa22dc();
  var options = {};
options["width"] =    900;
options["height"] =    600;
options["thickness"] =      5;
options["state"] = "{\"yAxisOption\":\"4\",\"time\":\"2010\",\"yZoomedDataMax\":1.023865803,\"showTrails\":false,\"nonSelectedAlpha\":0.4,\"colorOption\":\"_UNIQUE_COLOR\",\"xZoomedDataMin\":1136073600000,\"xZoomedIn\":false,\"sizeOption\":\"_UNISIZE\",\"xLambda\":1,\"uniColorForNonSelected\":false,\"orderedByX\":false,\"xAxisOption\":\"_TIME\",\"yZoomedIn\":false,\"iconType\":\"LINE\",\"duration\":{\"timeUnit\":\"D\",\"multiplier\":1},\"xZoomedDataMax\":1262304000000,\"yZoomedDataMin\":0,\"iconKeySettings\":[{\"key\":{\"dim0\":\"Bicycled\"}}],\"yLambda\":1,\"dimensions\":{\"iconDimensions\":[\"dim0\"]},\"playDuration\":15000,\"orderedByY\":false};";
options["showChartButtons"] = false;
options["showHeader"] = false;
options["showXMetricPicker"] = false;
options["showYMetricPicker"] = false;
options["showXScalePicker"] = false;
options["showYScalePicker"] = false;
options["showAdvancedPanel"] = true;

     var chart = new google.visualization.MotionChart(
       document.getElementById('MotionChartID7c051bfa22dc')
     );
     chart.draw(data,options);
    

}
  
 
// jsDisplayChart 
function displayChartMotionChartID7c051bfa22dc()
{
  google.load("visualization", "1", { packages:["motionchart"] }); 
  google.setOnLoadCallback(drawChartMotionChartID7c051bfa22dc);
}
 
// jsChart 
displayChartMotionChartID7c051bfa22dc()
 
<!-- jsFooter -->  
//-->
</script>
 
<!-- divChart -->
  
<div id="MotionChartID7c051bfa22dc"
  style="width: 900px; height: 600px;">
</div>


