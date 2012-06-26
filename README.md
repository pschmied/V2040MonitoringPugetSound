V2040Monitoring
===================
Examples of automated generation of reporting products from original data sources.

Structure
---------
The general idea here is that R handles the data loading, formatting, processing, and plotting. Org-babel or knitr then embeds those R products into a report. As more output products are needed, a move toward something akin to a traditional build system may be more intelligent.

HTML output includes an interactive googleVis motion plot, however due to flash security issues does not load in most web browsers from a local file URL (e.g. file:///path/to/ModeSplit.html). Motionchart should display correctly when served via a web server.

**Warning:** The R code here is a pretty janky and non-modular


Interactive example
-------------------
For an interactive example of the Google Motionchart used here, please see:
http://pschmied.github.com/MotionChartExample.html