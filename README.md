ModeSplitPugetSound
===================

An example of using literate programming to report travel trends from Census data.

Structure
---------
The general idea here is that R handles the data loading, formatting, processing, and plotting. Org-babel or knitr then embeds those R products into a report.

HTML output includes an interactive googleVis motion plot, however due to flash security issues does not load in most web browsers from a local file URL (e.g. file:///path/to/ModeSplit.html). Motionchart should display correctly when served via a web server.

**Warning:** The R code here is a pretty janky and non-modular