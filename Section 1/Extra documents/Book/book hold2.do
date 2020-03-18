clear all
texdoc init book.tex, replace
/*tex
\documentclass[a4paper,12pt,oneside]{book}
\usepackage{stata}
\usepackage{graphicx}
\usepackage{tikz}
\usepackage{longtable}
\usepackage[utf8]{inputenc}
\usepackage[english]{babel}
\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\fancyhead[CE,CO]{\leftmark}
\fancyhead[LE,RO]{\thepage}
\fancyfoot[RE,LO]{Najib A. Mozahem}
\fancyfoot[LE,RO]{Fundamentals of Data Analytics}
\renewcommand{\headrulewidth}{2pt}
\renewcommand{\footrulewidth}{1.5pt}
\title{Fundamentals of Data Analytics}
\author{Najib Mozahem}
\setlength{\parskip}{1em}
\setlength{\parindent}{0pt}
\renewcommand{\baselinestretch}{1.5}
\begin{document}
\begin{titlepage}
    \begin{center}
        \vspace*{1cm}
 
        \Huge
        \textbf{Fundamentals of Data Analytics}
 
        \vspace{0.5cm}
        \LARGE
        An Introduction for Data Scientists
 
        \vspace{1.5cm}
 
        \textbf{Najib A. Mozahem}
 
        \vfill
 
        \vspace{0.8cm}
 
    \end{center}
\end{titlepage}
\tableofcontents
\chapter{Visualizing Data - The Concepts}
Graphs are an excellent tool that allow us to visualize what a variable looks like. There are many types of graphs, and each is used for a different purpose. In this chapter, we will cover the different types of 
graphs that are used for different situations. 
\section{Distribution Graphs}
\subsection{Histograms}
Before we start data analysis, we need to get a feel for the variables. This means that we want to know whether the values that are taken by a certain variable are high or low, or whether there is a large amount of dispersion.
For example, imagine if you took an exam and the instructor showed you the graph which is displayed in Figure ~\ref{fig:histogramgrades}. This graph is called a histogram. The x-axis marks the grades. Notice that each bar
coversd a certain range, or class as it is called in statistics. The height of each bar, which is represented by the y-axis, indicates the percent of students that achieved a grade within each class. For example, we can see
that more than 30\% of students got a grade between 70 and 75. Of course, we can change the number of classes that are displayed. Figure ~\ref{fig:histogramgrades2} on the other hand shows the histogram when the same data are 
divided into five classes. 

tex*/
qui use gpaenglish, clear
texdoc stlog, cmdstrip nooutput
histogram gpa, percent width(5) start(40) color(green) graphregion(color(white)) lcolor(black) xtitle(grade) xlabel(40(5)95, labsize(small)) ylabel(0(10)40)
texdoc stlog close
texdoc graph, caption(The histogram of the grades.) label(fig:histogramgrades) figure(h) optargs(width=0.7\textwidth)
/*tex 

tex*/
qui use gpaenglish, clear
texdoc stlog, cmdstrip nooutput
histogram gpa, percent bin(5) color(green) graphregion(color(white)) lcolor(black) xtitle(grade) xlabel(40(5)95, labsize(small)) ylabel(0(10)40)
texdoc stlog close
texdoc graph, caption(The histogram of the grades using five classes.) label(fig:histogramgrades2) figure(h) optargs(width=0.7\textwidth)
/*tex 

So why is the histogram a useful tool? Looking again at Figure ~\ref{fig:histogramgrades}, we see that the majority of the grades are between 70 and 85 which is good. We also see that although there are failed grades,
the percent is low, so there is nothing to be alarmed about. 

Imagine on the other hand that the instructor showed you the histogram shown in Figure ~\ref{fig:histogramgrades3}. In this case, we see that the percent of grades in the lower classes (less than 65) is higher than the
previous case. Just by comparing the two graphs we can say that the grades in the first case were, in general, better. 

tex*/
qui use gpaenglish2, clear
texdoc stlog, cmdstrip nooutput
histogram gpa, percent width(5) color(green) graphregion(color(white)) lcolor(black) xtitle(grade) xlabel(40(5)95, labsize(small)) ylabel(0(10)30)
texdoc stlog close
texdoc graph, caption(The histogram of the new grades.) label(fig:histogramgrades3) figure(h) optargs(width=0.7\textwidth)
/*tex 

\subsection{Frequency Polygons}
A frequency polygon is similar to a histogram, except that it consists of lines that are connecting the points that are plotted using the frequency and the midpoint of each class. Note that the midpoints are
represented on the horizontal axis. In addition, in order to anchor the polygon to the horizontal axis, we add two points with zero frequencies, one before the first class and another after the last class.

Figure ~\ref{fig:freqpoly1} shows the frequency polygon for the grades example that we have been working with. Notice that the shape is exactly the same as the histogram. The two differences are that instead of bars we 
use dots that are connected with lines, and that the x-axis marks represent the midpoint of each class instead of the endpoints of the classes. The advantage that these types of graphs have over histograms will become
apparent when we compare groups, which we will be doing in a another section. 

tex*/
qui use gpaenglish, clear
gen gpapoly = . 
local j = 1 
qui forval i = 40(5)95 { 
	count if gpa >= `i' & gpa < `=`i' + 5' 
	replace gpapoly = r(N) in `j++'
}
gen gpa2 = 37.5 + 5 * _n if gpapoly < .
qui count if gpa < .
qui replace gpapoly = gpapoly/r(N)*100
_crcslbl gpa2 gpa
texdoc stlog, cmdstrip nooutput
twoway connect gpapoly gpa2, color(green) graphregion(color(white)) xlabel(40(5)95) xtitle(grade)
texdoc stlog close
texdoc graph, caption(Comparing the frequency polygons.) label(fig:freqpoly1) figure(h) optargs(width=0.7\textwidth)
/*tex 

\subsection{Boxplots}
Another useful graph when it comes to distributions is the boxplot. In order to understand the boxplot, you need to understand the concept of quartiles. Quartiles divide the data into 4 equal groups, where each group 
contains 25 percent of the data values. The symbols $Q_1, Q_2, Q_3, and Q_4$ refer to the first, second, third, and fourth quartile. The basic idea behind quartiles  is that they tell you where you stand relative to everyone 
else. The first quartile, $Q_1$, is the value that 25\% of the observations are below. The second quartile, $Q_2$ is the value that 50\% of the observations are below. As you recall, the median is the halfway point. It divides 
the data values into two equal groups. Therefore, the median is the second quartile, or $Q_2$.The third quartile, $Q_3$ is the value that 75\% of the observations are below. As an example, on a certain exam $Q_1$ was 60, then
this means that 25\% of the students obtained a grade that is less than 60. 

Let us find the quartiles for the following data that represent income: 36000, 56000, 24000, 20000, 29000, 45000, 15000, 70000, 40000, 21000.
\begin{itemize}
	\item First we need to arrange the list in order: 15000, 20000, 21000, 24000, 29000, 36000, 40000, 45000, 56000, 70000.
	\item The median is the halfway point. Since the number of values is even (10), the halfway point is between 29000 and 36000, which is $\frac{29000+36000}{2}=32500$. This is $Q_2$.
	\item The values to the left 32,500 are: 15000, 20000, 21000, 24000, 29000. The median of these values is 21,000. This is $Q_1$. 
	\item The values to the right 32,500 are: 36000, 40000, 45000, 56000, 70000. The median of these values is 45,000. This is $Q_3$.
\end{itemize} 

Once we have found the quartiles, we can find the \textbf{interquartile range (IQR)}.
$$IQR=Q_3-Q_1$$
This is the range the includes the middle 50\% of the data values. In our previous example, the IQR is 45000 - 21000 = 24,000. This means that the middle 50\% of the data values lie in a range that
has a width of 24,000. As you can see, the IQR is also a measure of variability. The larger it is, the higher the variability in the data.

The IQR is useful when we want to see whether there are \textbf{outlier} in the data. An outlier is a value that is very high or very low in comparison to the rest of the data values. To check for outliers, we use the 
following steps:
\begin{itemize}
	\item Find $Q_1$ and $Q_3$.
	\item Find the interquartile range which is $Q_3-Q_1$.
	\item Multiply the IQR by 1.5.
	\item Any data value that is smaller than $Q_1-1.5\times{IQR}$ or larger than $Q_3+1.5\times{IQR}$ is considered an outlier. This basically means that any data value that is less than $Q_1$ by more than 1.5 times
	the IQR is an outlier. In addition, any data value that is greater than $Q_3$ by more than 1.5 times the IQR is also an outlier. 
\end{itemize}

Now that we know what quartiles are and what is an interquartile range, we can talk about boxplots. A \textbf{boxplot} is an extremely useful tool to visually represent information about quartiles, the interquartile range, 
and outliers. Boxplots show the following five values:
\begin{itemize}
	\item The lowest value in the dataset.
	\item $Q_1$.
	\item The median, or $Q_2$.
	\item $Q_3$.
	\item The highest value in the dataset.
\end{itemize}

Figure ~\ref{fig:boxplot1} shows the boxplots for the grades of females and males. The dots at the top and bottom represent the highest and lowest values respectively. The top border of the rectangular area represents $Q_3$,
the lower border of the rectangular area represents $Q_1$, and the horizontal line in the middle of the rectangular area represents $Q_2$ which is the median. From the figure, we see that the highest grade is 95, and the lowest
is somewhere around 40. We also see that $Q_1$ is just above 70, which means that 25\% of the grades are less than 71 or 72. We also see that $Q_3$ is around 80, which means that 75\% of the grades are less than 80.
 
tex*/
qui use gpaenglish, clear
qui egen median = median(gpa)
qui egen upq = pctile(gpa), p(75)  
qui egen loq = pctile(gpa), p(25) 
qui egen iqr=iqr(gpa)
qui egen upper = max(gpa)
qui egen lower = min(gpa)
qui gen hold = 1
texdoc stlog, cmdstrip nooutput
twoway (rbar med upq hold, color(green) lcolor(black) barw(0.35)) (rbar med loq hold, color(green) lcolor(black) barw(0.35)) (rspike upq upper hold, color(black)) (rspike loq lower hold, color(black)) (scatter upper upper hold, mcolor(black black)) (scatter lower lower hold, mcolor(black black)), graphregion(color(white)) legend(off) ylabel(50(5)100) xlabel(0 " " 2 " ") xtitle(" ")
texdoc stlog close
texdoc graph, caption(Boxplot that shows the quartiles and the highest and lowest values. The rectangular area is the interquartile range.) label(fig:boxplot1) figure(h) optargs(width=0.7\textwidth)
/*tex 

A boxplot can be modified in order to display other pieces of information. For example, instead of displaying the highest and lowest values, the boxplot can display the range outside which data values would be considered to 
be outliers. Figure ~\ref{fig:boxplot2} shows the modified boxplot of the grades. The rectangular area remains unchanged since it is bounded by $Q_1$ and $Q_3$, both of which remain unchanged. What is different is that the points
that previously marked the maximum and minimum values now mark the edges of the IQR. Any point outside this range is considered an outlier. As we can see from Figure ~\ref{fig:boxplot2}, the hollow circles at the lower
end indicate the outliers. In general, most statistical packages display the modified bxplot since it is important to identify whether outliers exist or not. Therefore, I would advise that you make yourself familiar with
the modified version.

tex*/
qui use gpaenglish, clear
qui egen median = median(gpa)
qui egen upq = pctile(gpa), p(75)
qui egen loq = pctile(gpa), p(25)
qui egen iqr=iqr(gpa), by(gender)
qui egen upper = max(min(gpa, upq + 1.5 * iqr))
qui egen lower = min(max(gpa, loq - 1.5 * iqr))
qui gen hold = 1
texdoc stlog, cmdstrip nooutput
twoway (rbar med upq hold, color(green) lcolor(black) barw(0.35)) (rbar med loq hold, color(green) lcolor(black) barw(0.35)) (rspike upq upper hold, color(black)) (rspike loq lower hold, color(black)) (rcap upper upper hold, color(black black)) (rcap lower lower hold, color(black black)) (scatter gpa hold if !inrange(gpa, lower, upper), msymbol(Oh) mcolor(black)), graphregion(color(white)) legend(off) xlabel(0 " " 2 " ") xtitle("") ylabel(50(5)100)
texdoc stlog close
texdoc graph, caption(Modified boxplot that shows the outliers and the range that is defined by 1.5 times the interquartile range.) label(fig:boxplot2) figure(h) optargs(width=0.7\textwidth)
/*tex

\section{Testing for Normality}
There are many different shapes of distributions. Many statistical methods require that the variable be normally distributed (or approximately normal). This is why it is important to check for normality. 
Figure ~\ref{fig:normal} shows the shape of a normal distribution. As can be seen from the figure, the normal distribution curve is symmetric with the mean, median, and mode being equal.

tex*/
qui clear all
qui set obs 5000
qui gen grade1 = rnormal(75, 2)
texdoc stlog, cmdstrip nooutput
qui histogram grade1, percent graphregion(color(white)) color(green) lcolor(black) ylabel(none) xtitle(" ")
texdoc stlog close
texdoc graph, caption(Normal distribution of grades.) label(fig:normal) figure(h) optargs(width=0.7\textwidth)
/*tex

There are several ways to graphically check for normaility, two of which will be covered in this section. The first way is to overlay the histogram with a normal curve. This will allow us to visually compare the
distribution of the variable with an actual normal distribution. As an example, in Figure ~\ref{fig:histogramgrades2} we plotted the distribution of the grades. We can tell the statistical package to overlay the histogram
with a nornmal curve, as displayed in Figure ~\ref{fig:histogramgrades22}. Comparing the histogram and the normal curve that are displayed in the figure, we see that the grades seem to be normally distributed although
the left tail seems to be longer than what we would expect in a normal curve.  

tex*/
qui use gpaenglish, clear
texdoc stlog, cmdstrip nooutput
histogram gpa, percent width(5) start(40) color(green) graphregion(color(white)) lcolor(black) xtitle(grade) xlabel(40(5)95, labsize(small)) ylabel(0(10)40) normal
texdoc stlog close
texdoc graph, caption(The histogram of the grades overlayed with a normal curve.) label(fig:histogramgrades22) figure(h) optargs(width=0.7\textwidth)
/*tex

The second way to check for normaility is to use a quantile-normal plot. First, however, you need to understand what a quantile is. Quantiles divide the data into several parts. They represent the values below which a certain 
fraction of the data lies. The 0.1 quantile is the value that 10% of the observations are less than or equal to. The 0.3 quantile is the value below which 30% of the observations lie. 
The 0.5 quantile is the value under which half of the observations lie, so it is the median (this should be familiar because quartiles, which were discussed above, use the same logic but divide the data into four groups).

A quantile-normal plot compares the quantiles of the variable with the quantiles of the normal curve. This is done by plotting the two sets of quantiles against each other. If you recall from math, if two similar
variables are plotted against each other the result will be a straight diagonal line (which is the line y=x). Therefore, if when we plot the quantiles of our variable against the quantiles of a normal variable the result
is a straight diagonal line, then we can conclude that the quantiles of our variable are equal to the quantiles of a normal variable. This means that we our variable is normal. If the result is not a straight diagonal
line, then we conclude that our variable is not normal in distribution.

Figure ~\ref{fig:quantiles} displays the quantile-normal plot of the grades. Notice that the statstical software draws the diagonal line for us in order to help us compare the actual plot, which is represented by the dots,
to the expected outcome if our variable is normal. We see that most of the dots tend to lie on the diagonal line, which supports the assumption of normality. However, we note that at the lower end of the scale the dots seem
to diverge from the line. This indicates that the variablle is normal except for the lower end of the scale. This is similar to the observation that was made when discussing Figure ~\ref{fig:histogramgrades22}, where it was
noted that the left-tail of the distribution does not correspond well with a normal curve.

tex*/
qui use gpaenglish, clear
texdoc stlog, cmdstrip nooutput
qnorm gpa, graphregion(color(white)) xtitle(Normal quantiles) ytitle(Grades)
texdoc stlog close
texdoc graph, caption(The histogram of the grades overlayed with a normal curve.) label(fig:quantiles) figure(h) optargs(width=0.7\textwidth)
/*tex

\section{Group Differences in Distributions}

Now that we know how to visualize the distribution of a variable, we can extend the concepts to cases where we want to compare the distributions of two groups. For example, what if we wanted to investigate whether there were
differences between the grades of females and males? 

\subsection{Histograms}
We start by comparing the histograms of males and females. Figure ~\ref{fig:comparehistogram1} plots both histograms side-by-side. Looking at the figure, we see that males have a higher percent of observations than females
near the lower end of the grade scale. We also see that females have a higher percent of observations than males near the higher end. It seems from the figure that females tend to have higher grades. 

tex*/
qui use gpaenglish, clear
texdoc stlog, cmdstrip nooutput
twoway histogram gpa, percent color(green) lcolor(black) width(5) start(40) by(gender) xtitle(grades) graphregion(color(white)) scheme(lean2)
texdoc stlog close
texdoc graph, caption(Comparing both histograms side-by-side.) label(fig:comparehistogram1) figure(h) optargs(width=0.7\textwidth)
/*tex

It would be easier for us to compare if the two histograms were plotted on the same graph, which is what we do in Figure ~\ref{fig:comparehistogram2}. Here we run into a problem, which is that one of the histograms is
drawn on top of the other thus blocking some of the information. Clearly, this is not a good way to compare the two graphs. Fortunately, there is a way around this proble, and that is to use frequency polygons. 

tex*/
qui use gpaenglish, clear
texdoc stlog, cmdstrip nooutput
twoway (histogram gpa if gender==1, percent color(green) lcolor(black) width(5) start(40)) (histogram gpa if gender==2, frequency color(orange) lcolor(black) width(5) start(40)), legend(label(1 "female") label(2 "male")) xtitle(grades) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Comparing both histograms on the same graph.) label(fig:comparehistogram2) figure(h) optargs(width=0.7\textwidth)
/*tex 

\subsection{Frequency Polygons}
Frequency polygons are much better than histograms when it comes to comparing groups. Figure ~\ref{fig:comparefreqpoly} shows the frequency polygons for males and females plotted on the same graph. Notice that unlike the case
of the histogram, both graphs are visible at all points. Comparing the two distributions now is much easier. It is clear from the figure that the frequencies are higher at the lower end for males and they are higher at the upper 
end for females. 

tex*/
qui use gpaenglish, clear
gen gpapoly1 = . 
gen gpapoly2 = .
local j = 1 
qui forval i = 40(5)95 { 
	count if gpa >= `i' & gpa < `=`i' + 5' & gender==1
	replace gpapoly1 = r(N) in `j++'
}
local j = 1 
qui forval i = 40(5)95 { 
	count if gpa >= `i' & gpa < `=`i' + 5' & gender==2
	replace gpapoly2 = r(N) in `j++'
}
qui count if gpa < . & gender==1
qui replace gpapoly1 = gpapoly1/r(N)*100
qui count if gpa < . & gender==2
qui replace gpapoly2 = gpapoly2/r(N)*100
gen gpa2 = 37.5 + 5 * _n if gpapoly1 < .
_crcslbl gpa2 gpa
texdoc stlog, cmdstrip nooutput
twoway connect gpapoly1 gpapoly2 gpa2, color(green orange) legend(label(1 "female") label(2 "male")) graphregion(color(white)) xlabel(42.5(5)97.5) xtitle(grades)
texdoc stlog close
texdoc graph, caption(Comparing the frequency polygons.) label(fig:comparefreqpoly) figure(h) optargs(width=0.7\textwidth)
/*tex 

tex*/
qui use gpaenglish, clear
qui egen median = median(gpa), by(gender)
qui egen upq = pctile(gpa), p(75)  by(gender)
qui egen loq = pctile(gpa), p(25)  by(gender)
qui egen iqr=iqr(gpa), by(gender)
qui egen upper = max(min(gpa, upq + 1.5 * iqr)), by(gender)
qui egen lower = min(max(gpa, loq - 1.5 * iqr)), by(gender)
texdoc stlog, cmdstrip nooutput
twoway (rbar med upq gender, color(green) lcolor(black) barw(0.35)) (rbar med loq gender, color(green) lcolor(black) barw(0.35)) (rspike upq upper gender, color(black)) (rspike loq lower gender, color(black)) (rcap upper upper gender, color(black black)) (rcap lower lower gender, color(black black)) (scatter gpa gender if !inrange(gpa, lower, upper), msymbol(Oh) mcolor(black)), graphregion(color(white)) legend(off) xlabel(1 "female" 2 "male") xtitle("") ylabel(50(5)100)
texdoc stlog close
texdoc graph, caption(Modified boxplot that compares the grades of males and females.) label(fig:comparebox) figure(h) optargs(width=0.7\textwidth)
/*tex

\subsection{Boxplots}
Boxplots can also be used to compare the distribution of a variable across two groups. Figure ~\ref{fig:comparebox} shows the boxplots of grades for both males and females. Note that the figure shows the modifiedboxplot.
The figure clearly shows that females score higher grades than males. We see that $Q_1$, $Q_2$, and $Q_3$ are all higher for females. We also see that there are several outliers for males, mostly at the lower end of the 
scale. 

\section{Group Differences in Parameters}
Although vosualizing group differences in distributions is very useful, it may be the case that it is more than what we want. What if all that we were interested in were the differences between the average grade for females
and the average grade for males? In such a case, we do not need to look at the entire distribution of the variable. All we need to do is to compare a single parameter. In such cases two particular types of graphs lend
themselves well to the analysis, and they are bar graphs and dot plots.

\subsection{Bar Graphs}
A bar graph shows the qualitative classes on one axis and the class frequencies or percentages on the other axis. In our case, the qualitative variable is gender. Figure ~\ref{fig:bar1} compares the differences between
the average grade of males and the average grade of females. In this case, the parameter that we are comparing is average. It is possible to compare other parameters such as the median for example. 

tex*/
qui use gpaenglish, clear
texdoc stlog, cmdstrip nooutput
graph bar gpa, over(gender) bar(1, bcolor(green)) scheme(lean2) ytitle(Mean of grade)
texdoc stlog close
texdoc graph, caption(Bar graph comparing average grade for males and females.) label(fig:bar1) figure(h) optargs(width=0.7\textwidth)
/*tex

tex*/
qui use universities, clear
qui keep if year == 2013
qui keep if major == "Civil Engineer" |  major == "Medicine" |  major == "Biology"  |  major == "Social Sciences"  | major == "Education" |  major == "Industrial Engineering"
texdoc stlog, cmdstrip nooutput
qui graph bar males, over(major, label(labsize(small)) sort(1)) bar(1, bcolor(green)) scheme(lean2) ytitle(Frequency) name(enrollmentmale1)
qui graph hbar males, over(major, label(labsize(small)) sort(1)) bar(1, bcolor(green)) scheme(lean2) ytitle(Frequency) name(enrollmentmale2)
graph combine enrollmentmale1 enrollmentmale2, graphregion(color(white)) cols(1)
texdoc stlog close
texdoc graph, caption(Bar graph of the number of male students in selected areas of study in universities in 2013.) label(fig:enrollmentmale) figure(h) optargs(width=0.7\textwidth)
/*tex

tex*/
qui use universities, clear
qui keep if year == 2013
qui keep if major == "Civil Engineer" |  major == "Medicine" |  major == "Biology"  |  major == "Social Sciences"  | major == "Education" |  major == "Industrial Engineering"
texdoc stlog, cmdstrip nooutput
graph bar males females, over(major, label(labsize(small)) sort(1)) bar(1, bcolor(green)) bar(2, color(orange)) legend(label(1 "males") label(2 "females")) graphregion(color(white)) ytitle(Frequency)
texdoc stlog close
texdoc graph, caption(Compound bar graph.) label(fig:enrollmentboth) figure(h) optargs(width=0.7\textwidth)
/*tex

Bar graphs are much more useful when there are more than two categories in the qualitative variable. For example, Figure ~\ref{fig:enrollmentmale} shows a bar graphs that compares the total number of enrolled students
in a select number of majors in Lebanon. Here, the parameter that we are comparing is the total number of enrolled students. The figure also shows that we can draw the bar graph either vertically or horizontally. The choice
is up to the researcher.  

Bar graphs can also be used to compare a parameter across two or more groups. For example, what if we wanted to compare the enrollment numbers of males and females in several majors? Figure ~\ref{fig:enrollmentboth}
shows such a comparison using what is referred to as a \textbf{compound bar graph}. The graph allows us to note that enrollment numbers for males are higher in majors such as civil engineering and industrial engineering,
while the numbers are higher for females in majors such as education and biology. This graph actually highlights a well-documented phenomena which is that females tend to gravitate away from fields such as engineering
and computer science.  

\subsection{Dot Plots}

Dot plots are very similar to bar graphs except that instead of a bar the parameter is plotted using a simple dot. Figure ~\ref{fig:enrollmentmaledot} and Figure ~\ref{fig:enrollmentbothdot} are the dot plot versions of
Figure ~\ref{fig:enrollmentmale} and Figure ~\ref{fig:enrollmentboth}. 

tex*/
qui use universities, clear
qui keep if year == 2013
qui keep if major == "Civil Engineer" |  major == "Medicine" |  major == "Biology"  |  major == "Social Sciences"  | major == "Education" |  major == "Industrial Engineering"
texdoc stlog, cmdstrip nooutput
graph dot males, over(major, label(labsize(small)) sort(1)) marker(1, mcolor(green) msymbol(O)) scheme(lean2) ytitle(Frequency)
texdoc stlog close
texdoc graph, caption(Dot plot of the number of male students in selected areas of study in universities in 2013.) label(fig:enrollmentmaledot) figure(h) optargs(width=0.7\textwidth)
/*tex 

tex*/
qui use universities, clear
qui keep if year == 2013
qui keep if major == "Civil Engineer" |  major == "Medicine" |  major == "Biology"  |  major == "Social Sciences"  | major == "Education" |  major == "Industrial Engineering"
texdoc stlog, cmdstrip nooutput
graph dot males females, over(major, label(labsize(small)) sort(1)) marker(1, mcolor(green) msymbol(O)) marker(2, mcolor(orange) msymbol(O)) legend(label(1 "males") label(2 "females")) graphregion(color(white)) ytitle(Frequency)
texdoc stlog close
texdoc graph, caption(Compound dot plot.) label(fig:enrollmentbothdot) figure(h) optargs(width=0.7\textwidth)
/*tex

\section{Visualizing the Relationship Between Two Variables}
So far, we have discussed creating graphs that inform us about single variables. When we took other variables into consideration, we did so by considering categorical variables that divided the observations into group. 
However, a significant part of analysis involves studying the relationship between two variables when both of these variables are not categorical. For example, is there a relationship between the grade of a student 
and his/her English level? Is it true that students with a better command of the English language outperform those who are weak in English because they can understand the material more? What about the 
relationship between grade and class attendance? Do university administrators have it right when they say that attending classes is beneficial? To answer these questions, we need to use graphs that allow us to see
what happens to one variable when another variable changes values.

\subsection{Scatter Plots}
Scatter plots are a very powerful tool that allow us to investigate whether there is a relationship between two variables. The beaty of scatter plots is that they make no assumptions about the data. We just plot the
values and look at the resulting figure in order to see whether there is any relationship between the variables. Figure ~\ref{fig:scatter1} shows a scatter plot where the students' grades are plotted on the y-axis
and the grades that the students obtained on the English language courses are plotted on the x-axis. Looking at the figure we can see that as the grade on the English course increases, so does the students' grades. Therefore,
the scatter plots seems to support the claim that the English level of the student has an effect on their course grades.

tex*/
qui use linear_project, clear
texdoc stlog, cmdstrip nooutput
twoway scatter gpa english, scheme(lean2) mcolor(green) msymbol(O) ytitle(Grades)
texdoc stlog close
texdoc graph, caption(Scatter plot of course grade and grade on English courses.) label(fig:scatter1) figure(h) optargs(width=0.7\textwidth)
/*tex 

As another example, consider the relationship between student grade and the attendance level of the student. Figure ~\ref{fig:scatter2} shows the scatter plot. We can clearly see that the higher the attendance level the higher
the students' grades. 

tex*/
qui use linear_project, clear
texdoc stlog, cmdstrip nooutput
twoway scatter gpa attendance, scheme(lean2) mcolor(green) msymbol(O) ytitle(Grades)
texdoc stlog close
texdoc graph, caption(Scatter plot of course grade and grade on attendance.) label(fig:scatter2) figure(h) optargs(width=0.7\textwidth)
/*tex 

In some cases however, the pattern might not be clearly visible from the scatter plot. As an example, consider a survey that was conducted in Germany. The survey contained the following statement: "Immigrants make country 
worse or better place to live". Respondents were then asked to indicate to respond on a scale of zero to 10 with zero indicating that immgrants make the country worse and a ten indicating that immigrants make the country
better. This means that higher values of this variable indicated a more favorable attitude towards immigrants. Respondents were also asked to indicate how hwppy they are again on a scale of 
zero to 10, with zero indicating that they are extremely unhappy and ten indicating that they were extremely happy. Therefore, higher levels of this variable indicate higher levels of happiness. 

We can use a scatter plot in order to see whether there is a relationship between the two variables. Are people who are happier more likely to have a friendlier attitude towards immigrants? Figure ~\ref{fig:scatter3} shows
the scatter plot that is produced when the attitude towards immigrants is plotted on the y-axis and the happiness level is plotted on the x-axis. The scatter plot is not very readable. This is partly due to the large
number of dots, but it is also due to the fact that the variables are categorical, since each of them can only take eleven possible values (from zero to 10). Fortunately, we can supplement the scatter plot with another
type of graph that will allow us to discern any underlying pattern. The next section illustrates this point.  

tex*/
qui use "ESS8DE Working File  Thesis2", clear
qui keep imwbcnt sclmeet imueclt stflife ppltrst happy pplhlp imbgeco stfeco hincfel psppipla trstplt trstprt psppsgva stfgov gndr agea edulvlb lrscale prtvede1 pplfair region stfdem pspwght dweight pweight
qui recode ppltrst 77 88 99 = .
qui recode pplhlp 77 88 99 = .
qui recode pplfair 77 88 99 = .
qui recode psppsgva 7 8 9 = .
qui recode psppipla 7 8 9 = .
qui recode trstplt 77 88 99 = .
qui recode trstprt 77 88 99 = .
qui recode lrscale 77 88 99 = .
qui recode stflife 77 88 99 = .
qui recode stfeco 77 88 99 = .
qui recode stfgov 77 88 99 = .
qui recode stfdem 77 88 99 = .
qui recode imbgeco 77 88 99 = .
qui recode imueclt 77 88 99 = .
qui recode imwbcnt 77 88 99 = .
qui recode happy 77 88 99 = .
qui recode sclmeet 77 88 99 = .
qui recode edulvlb 7777 8888 9999 = .
qui recode hincfel 7 8 9 = .
qui recode prtvede1 66 77 88 99 = .
qui replace agea = . if agea > 900
texdoc stlog, cmdstrip nooutput
twoway scatter imwbcnt happy, jitter(50) scheme(lean2) mcolor(green) msymbol(O) ytitle(, size(small)) xtitle(, size(small))
texdoc stlog close
texdoc graph, caption(Scatter plot of view of immigrants plotted against happiness level.) label(fig:scatter3) figure(h) optargs(width=0.7\textwidth)
/*tex 

\subsection{Loess}
A loess curve allows us to "smooth" the scatter plot. How this is accomplished is not of primary interest for us. What the reader needs to know is that a loess curve is a locally smoothed scatter plot. The utility
of such a curve is illustrated in Figure ~\ref{fig:loess}. The loess curve is drawn in orange. I have made the dots transparent and hollow in order to focus on the loess curve. As can be seen, we see that the smoothed
curve is increasing as the level of happiness is increasing. This means that there is reason to believe that individuals who are generally happier in their lives tend to have a more favorable attituide toward immigrants.

tex*/
qui use "ESS8DE Working File  Thesis2", clear
qui keep imwbcnt sclmeet imueclt stflife ppltrst happy pplhlp imbgeco stfeco hincfel psppipla trstplt trstprt psppsgva stfgov gndr agea edulvlb lrscale prtvede1 pplfair region stfdem pspwght dweight pweight
qui recode ppltrst 77 88 99 = .
qui recode pplhlp 77 88 99 = .
qui recode pplfair 77 88 99 = .
qui recode psppsgva 7 8 9 = .
qui recode psppipla 7 8 9 = .
qui recode trstplt 77 88 99 = .
qui recode trstprt 77 88 99 = .
qui recode lrscale 77 88 99 = .
qui recode stflife 77 88 99 = .
qui recode stfeco 77 88 99 = .
qui recode stfgov 77 88 99 = .
qui recode stfdem 77 88 99 = .
qui recode imbgeco 77 88 99 = .
qui recode imueclt 77 88 99 = .
qui recode imwbcnt 77 88 99 = .
qui recode happy 77 88 99 = .
qui recode sclmeet 77 88 99 = .
qui recode edulvlb 7777 8888 9999 = .
qui recode hincfel 7 8 9 = .
qui recode prtvede1 66 77 88 99 = .
qui replace agea = . if agea > 900
texdoc stlog, cmdstrip nooutput
twoway (scatter imwbcnt happy, jitter(50) mcolor(green%30) msymbol(Oh)) (lowess imwbcnt happy, lcolor(orange) lwidth(thick)), ytitle(, size(small)) xtitle(, size(small)) legend(off) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Adding a locally weighted smoothed curve.) label(fig:loess) figure(h) optargs(width=0.7\textwidth)
/*tex 

tex*/
qui use wagestemp, clear
texdoc stlog, cmdstrip nooutput
twoway scatter incwage uhrswork, jitter(50) mcolor(green) msymbol(O) ytitle(, size(small)) xtitle(, size(small)) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Scatter plot of view of income plotted against weekly hours worked.) label(fig:loess2) figure(h) optargs(width=0.7\textwidth)
/*tex 

tex*/
qui use wagestemp, clear
texdoc stlog, cmdstrip nooutput
twoway (scatter incwage uhrswork, jitter(50) mcolor(green%30) msymbol(Oh)) (lowess incwage uhrswork, lcolor(orange) lwidth(thick)), ytitle(, size(small)) xtitle(, size(small)) legend(off) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Adding a locally weighted smoothed curve.) label(fig:loess3) figure(h) optargs(width=0.7\textwidth)
/*tex 

As another example, consider data that was collected from the U.S. The data records the income of individuals as well as the number of hours worked per week. Figure ~\ref{fig:loess2} shows the scatter plot. Once again we
see that the relationship cannot be easily deduced. Figure ~\ref{fig:loess3} shows the loess curve overlaid on the scatter plot. The loess curve indicates that as the number of hours worked per week increases, so does the
income of the individual. Once again, the loess curve allowed us to visualize a relationship that was not easily observed when looking at the scatter plot.

\subsection{Parametric Fits: Linear and Quadratic curves}
The graphical tools used so far in this chapter are referred to as nonparametric tools. Nonparametric tools make no assumptions about the data. The data is left to speak for itself. Quantile plots calculate and plot the quantiles 
without assuming anything about the distribution. Scatter plots on the other hand only plot the values and leave it up to us to see whether there seems to be a relationship. Loess curves go 
further than scatter plots because they smooth the data, but the process of smoothing the data is performed without making any assumptions about the shape of the data.

However, there are cases where we can make assumptions about the nature of the relationship. For example, if you go back and look at Figure ~\ref{fig:scatter2} you will notice that the relationship between grade and
attendance seems to be linear. In such a case, we might tell the statistical package to draw the line that best fits the data (finding the best-fit line will be discussed in the chapter about Linear Regression). 
When we believe that we have sufficient evidence to make assumptions about the data, we can start use parametric tools.

Figure ~\ref{fig:lfit1} shows the same scatter plot as Figure ~\ref{fig:scatter2} in addition to the line that best fits the data. We see that the line is sloping upwards, meaning that when attendance increases so does the
grade. Notice that the line cuts through the data points, i.e. it passes in the middle. This is one of the properties of the best-fit line which will be discussed when we talk about linear regression. For now, the point
that is being made is that we can use parametric tools in graphs when we believe that the relationship has a mathematical form.

tex*/
qui use linear_project, clear
texdoc stlog, cmdstrip nooutput
twoway (scatter gpa attendance, mcolor(green%30) msymbol(O)) (lfit gpa attendance, color(orange) lwidth(thick)), ytitle(Grades) legend(off) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Linear fit of course grade and grade on attendance.) label(fig:lfit1) figure(h) optargs(width=0.7\textwidth)
/*tex

Consider now the case of Figure ~\ref{fig:scatter1} which showed the scatter plot when grade was plotted against the grade on the English course. It has already been noted that as the grade on the English course increased,
so did the grade of the student on other courses. Therefore, it might be safe to assume that the relationship is linear. Figure ~\ref{fig:lfit2} shows the best-fit line. Notice here that the line doesn't seem to be as well
fit as the line shown in Figure ~\ref{fig:lfit1}. Note that at the right end of the graph, most of the data points tend to lie below the line. This means that the line is not cutting through the data points. The reason
for this is that the relationship shown in the scatter plot is not linear. Note that initially, as the grade on English increases, so does the grade on other courses. However, the scatter plot seems to level off near the
right end. It seems that beyond a certain point, having higher grades on English does not result in higher grades on other courses. When the relationship between two variables changes at certain points, a line is no longer
the best representation of that relationship because a line, by definition, has a constant slope. It never changes direction.  

tex*/
qui use linear_project, clear
texdoc stlog, cmdstrip nooutput
twoway (scatter gpa english, mcolor(green%30) msymbol(O)) (lfit gpa english, color(orange) lwidth(thick)), ytitle(Grades) legend(off) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Linear fit of course grade and grade on English courses.) label(fig:lfit2) figure(h) optargs(width=0.7\textwidth)
/*tex 

In order to allow for this change in slope, it would be better to conceptualize the relationship as a curve. To do that, we use a quadratic term. As you recall from basic math, the equation $y=ax^2+bx+c$ represents a parabola.
Therefore, instead of telling teh statistical package to draw the best-fit line, we can tell it instead to draw the best fit curve. Figure ~\ref{fig:lfit3} shows the curve plotted over the scatter plot. As you can see, this
curve fits the data much better than the line. At the right end of the graph we see that the curve levels off, i.e. its slope starts to decrease. 

Soi when should we use a loess curve to uncover the nature of the relationship and when should we use a linear or quadratic graph? I would advise to start with a loess curve. If the resulting curve looks like a line, then
it would make sense to use a linear curve. If the loess curve curves at a certain point, i.e. it changes direction, then using a quadratic fit would make sense. If on the other hand the loess curve is neither linear nor
quadratic, then it would be better to stick with the nonparametric tools.  

tex*/
qui use linear_project, clear
texdoc stlog, cmdstrip nooutput
twoway (scatter gpa english, mcolor(green%30) msymbol(O)) (qfit gpa english, color(orange) lwidth(thick)), ytitle(Grades) legend(off) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Quadratic fit of course grade and grade on English courses.) label(fig:lfit3) figure(h) optargs(width=0.7\textwidth)
/*tex 

\subsection{Time Series}
A time series graph represents data that occur over a specific period of time. This type of graphs allows us to look at how one variable changes with time. Figure ~\ref{fig:enrollmentbothvoc} shows how the number of 
enrolled students in hospitality and in car mechanics in Lebanon has changed overtime. We see that there has been a drop in the number of students enrolled in hospitality and that the drop started somewhere around 2011. This
also happens to be the time in which several Gulf countries warned, and in some cases forbade, their residents from travelling to Lebanon for security concerns. As you can imagine, this dealt a blow to the tourism industry
in the country.   

tex*/
qui use vocational, clear
qui keep if major == "Hospitality" |  major == "Car mechanics"
qui gen total = males + females
qui label variable total "Enrolled students"
texdoc stlog, cmdstrip nooutput
twoway (connect total year if major =="Hospitality", color(green)) (connect total year if major =="Car mechanics", color(orange)), legend(label(1 "Hospitality") label(2 "Car mechanics")) xlabel(2005(2)2017) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Time series graph of number of students in vocational school in Lebanon in certain majors.) label(fig:enrollmentbothvoc) figure(h) optargs(width=0.7\textwidth)
/*tex

As another example of a time series graph, consider the graph shown in Figure ~\ref{fig:fertility}. The graph plots the changes in the fertility rates of females in Singapore. Different plots are produced for different
ethnic groups in the country. We see that in all three cases, the fertility rate has dropped significantly with time. We also see that the most recent data suggests that the fertility rate of females originally from
Malaysia us slightly higher than the fertility rate of females originally from China or India. 

tex*/
qui use singapore, clear
texdoc stlog, cmdstrip nooutput
twoway scatter chinese malays indian year, mcolor(green orange blue) msymbol(O O O) msize(small small small) legend(label(1 "Chinese") label(2 "Malaysian") label(3 "Indian") position(6) cols(3)) xtitle("") ytitle(Fertility Rate (per female), size(small)) plotregion(lcolor(white)) scheme(lean1)
texdoc stlog close
texdoc graph, caption(Fertility rates of the three ethnic groups in Singapore.) label(fig:fertility) figure(h) optargs(width=0.7\textwidth)
/*tex

\chapter{Visualizing Data - Case Study}

\chapter{Linear Regression - The Theory}
\section{Simple Linear Regression}
\subsection{The Slope}
In order to use linear regression, it is important for the student to understand the concept behind the technique. Fortunately, this can be accomplished without having to resort to complex mathematical equations. 
The important thing is to understand the idea.

I was once discussing with one of my colleagues whether universities should require students to attend classes. Some people argue that students who attend end up doing better, while others argue that this is not 
necessarily the case. In order to resolve this problem, we decided to look at the data. Table ~\ref{table:datapoints} displays the GPA and the attendance score of some students. The table isn’t of much help, since it requires 
us to look at a large number of columns and to compare these columns. This is why, whenever linear regression is involved, one of the first things that we should do is to produce a graph that will help us visualize the relationship. 
Figure ~\ref{fig:scatterdatapoints} displays the scatter plot of the data points from Table ~\ref{table:datapoints}.
\begin{table}[h!t]
	\caption{The data points.} \label{table:datapoints}
	\centering
	\begin{tabular}{c c}
	\hline
	\bf GPA & \bf Attendance \\
	\hline
	95 & 75 \\
	60 & 65 \\
	65 & 64 \\
	70 & 72 \\
	78 & 75 \\
	82 & 80 \\
	84 & 80 \\
	77 & 74 \\
	79 & 75 \\
	89 & 84 \\
	60 & 63 \\
	71 & 69 \\
	74 & 70 \\
	82 & 77 \\
	79 & 75 \\
	68 & 64 \\
	90 & 88 \\
	75 & 76 \\
	77 & 74 \\
	\hline
	\end{tabular}
\end{table}

tex*/
qui use linear1, clear
texdoc stlog, cmdstrip nooutput
scatter gpa attendance, graphregion(color(white)) mcolor(green)
texdoc stlog close
texdoc graph, caption(Scatter plot of the data points.) label(fig:scatterdatapoints) figure(h) optargs(width=0.7\textwidth)
/*tex

Looking at the graph, one might deduce that the higher the grade on attendance, the higher the overall GPA of the student. There seems to be some exceptions to this, most notably the student who has a 75 on attendance and a 
GPA of 95. However, most people would conclude that this seems to be the exception to the case. The scatter plot resembles a straight line, and the straight line has a positive slope. As you know, the equation of a straight 
line is:

$$ y=ax+b $$

In our case, the y variable is GPA, and the x variable is attendance. The y variable is called the \textbf{dependent} variable because we believe that it’s value depends on some other variables. The x variable is called the 
\textbf{independent} variable. Logically speaking, we would expect that the grade depends on the attendance level of the student. Therefore, our equation becomes:

$$ GPA = a(attendance)+b $$

In this equation, the a represents the slope of the line, and the b represents the y-intercept. It is the value of the dependent variable when the independent variable is zero. The concept of the slope is very important, 
because it defines the relationship between the dependent and independent variables. As an example, assume that we have the following linear equation:

$$ y=3x+2 $$

If x is equal to 2, y will be equal to 8, and if x is equal to 3, y will be equal to 11. Note that for every one unit increase in x, the value of y increases by 3, which is the value of the slope. This is the 
definition of the slope. It is the amount by which the dependent variable changes when the independent variable increases by 1. Now let us look at a case where the slope is negative:

$$ y=-3x+2 $$

In this case, if x is equal to 2, y will be equal to -4, and if x is equal to 3, y will be equal to -7. Therefore, when x increases by 1, y will increase by -3, or in other words, y will decrease by 3.

Now you can see that the slope is important for two reasons. The first reason relates to the sign. If the slope is positive, then any increase in the independent variable will lead to an increase in the dependent variable. 
The more I ate, the heavier I get. If the slope is negative, then an increase in the independent variable will lead to a decrease in the dependent variable. The more I buy food, the less money I have. 

The second reason relates to the magnitude of the slope. The larger the magnitude of the slope, the greater the effect that the independent variable has on the dependent variable. If the slope is 2, then a one unit 
increase in the independent variable will result in an increase of 2 in the dependent variable. If, however, the slope is 10, then a one unit increase in the independent variable will result in an increase of 10 in 
the dependent variable. So the sign of the slope tells us about the direction of the relation and the magnitude tells us about the magnitude of the effect that one variable might have on the other.

In the case of our scatter plot, we saw that the graph has the shape of a line with a positive slope. However, what is the magnitude of the slope? In order to know, we use linear regression. Linear regression is the 
statistical tool that we use in order to find the equation of the best-fit line that represents the data. The word best-fit line is very important. There are an infinite number of lines that we can draw for 
any given scatter plot. What linear regression does is that it finds the line that fits the data the best. This is usually done by minimizing the square of the error terms. I do not want you to worry about this now. 
We will cover this in more detail later. For now, the most important thing to know is that we use linear regression in order to calculate the values of a and b in the equation:

$$ GPA=a(attendance)+b $$

If we perform linear regression, the output will tell us that the following is the equation of the best-fit line:

$$ GPA=1.22(attendance)-13.20 $$

You do not need to worry how we got these numbers. The statistical software will calculate them for us. Later on in this course, we will be seeing how to do this. For now, just look at the values. We see that the 
slope is 1.22. This means that if a student increases his or her attendance grade by one point, their GPA will increase by 1.22.
\subsection{R-Squared}
So far, we have seen how linear regression helps us calculate the slope, and how the slope helps us understand the nature of the relationship between the dependent variable and in the independent variable. It was also stated 
that the line which is calculated is the best-fit line. However, just because something is the best doesn’t mean that it is good. If you got the best grade in your class on an exam, and that grade was a 40 out of 100, you 
still got a bad great, even though it was the best. The same logic applies to linear regression. The fact is that no matter what the relationship between the two variables is, if you ask any statistical software to calculate 
the best-fit line, the software will provide you with the equation of the line, even if the line was not a good fit. To illustrate this, look at the scatter plot shown in Figure ~\ref{fig:scatternorelationship}. 

tex*/
qui clear all
qui set obs 20
qui gen x = rnormal(80, 2)
qui gen y = rnormal(75, 3)
texdoc stlog, cmdstrip nooutput
scatter y x, graphregion(color(white)) mcolor(green)
texdoc stlog close
texdoc graph, caption(A scatter plot where there is no clear relationship between the variables y and x.) label(fig:scatternorelationship) figure(h) optargs(width=0.7\textwidth)
/*tex

Clearly the relationship does not resemble a line. Nonetheless, ask a statistical software to find the best-fit line, and the answer will be:

$$ y=0.019(x)+75.05 $$

As the above example illustrates, just because the statistical software gives us the equation of the best-fit line, we should not assume that the line actually fits the data well.

So what can we do in order to know if the best-fit line is actually a good line? We look at something that is called R-squared. This statistic calculates the proportion of the variation in the dependent variable 
that is explained by the line. This statement may seem complicated but it is actually easy to understand. In our original example, the dependent variable is GPA. Different students have different GPAs, and what we 
are trying to do is to explain how the value of GPA varies when we take into consideration the grade on attendance. A line that fits the data well will do a good job in explaining the variation in the dependent 
variable with respect to the independent variable. A line that does not fit the data well will fail to explain this variation. R-squared is calculated by dividing the variation that is explained by the line by the 
actual variation that is observed in the independent variable: 

$$ R^2=\frac{variation\, of\, the\, dependent\, variable\, explained\, by\, the\, line}{variation\, observed\, in\, the\, dependent\, variable} $$

If the line explains most of the observed variation, the value of R-squared will be close to 1 because the value of the numerator will be close to the value of the denominator. Otherwise, if the line fails to 
explain a large part of the variation, then the value of R-squared will be close to 0. In the figure above, the value of R-squared is 0.0005, which is very close to 0. This means that the best-fit line does not 
fit the data well. In the original dataset, which included the variables GPA and attendance, the value of R-squared is 0.75, which is considered to be good.
\subsection{The P-value}
We now come to one of the most important concepts in statistics, and it is the p-value. There is a saying that a broken clock is right twice a day. If my favorite TV show starts at 8:00, and the moment that it starts I 
look at my watch, and I see that it is 8:00, I assume that my watch is correct. However, this might not be the case. What if the watch was broken and it had stopped at 8:00. It just happened that I looked at it is 8:00. 
Although this might be the case, most people would not make that assumption. Instead, we assume that the watch is working. Even though there is a probability that the watch can be broken, this probability is too small, 
so we go about our day as usual. 

The p-value tells us about the probability that a certain observation was due to randomness and nothing else. An example will illustrate. Imagine a women who was sitting next to you and drinking tea. This women likes to 
drink her tea with milk. As she is drinking her tea, she suddenly turns to you and says that the tea tastes better when you pour the milk into the tea. She says that if you pour the tea into the milk the taste will 
not be the same. 

This is a strange statement to make. Why should there be a difference? In order to test her, you conduct a small test. You blindfold her and tell her that you will give her a cup of tea that has milk in it. Her job is to 
identify whether you poured the milk into the tea or vice versa. You give her the first cup and she guesses correctly. Does this mean that she is right? Does it mean that she can tell the difference? No necessarily. Maybe 
it was a random lucky guess. After all, she has a probability of 0.5 to guess the correct answer. So you decide to try with another cup. Again she guesses correctly. Did she prove her point? The probability of her making 
two lucky guesses is 0.5 x 0.5 = 0.25. What if she guesses three cups in a row? The probability for her to do that purely out of luck is 0.125. The probability for her to guess four cups completely out of luck is 0.0625, 
and the probability for her to guess five cups is 0.03125.

How many guesses must she make in order for her to prove that what we are observing is not due to luck, or randomness? The common cut-off value for the probability is 0.05. If the probability of something happening out of 
randomness or luck is less than 0.05, then we reject the claim that what we are observing is purely due to luck or randomness. It would be safe for us to conclude that our observation is in fact \textbf{significant}. In the case 
of the lady drinking tea, if she is able to answer correctly five times in a row, then we reject the claim that she was just lucky and we can conclude that she actually know what she is talking about.

The above explanation is not mathematically sound, but it does not matter. What matters is the idea. The example illustrates the idea. This brings us back to our line. As we saw, the statistical software has 
told us that the best-fit line is:

$$ GPA=1.22(attendance)-13.20 $$

The software has also told us that the value of R-squared is 0.75. Another piece of information that the statistical software gives us is the p-value of the slope. If the p-value of the slope is less than 0.05, 
then we reject the claim that the value that we have observed is due to randomness. Instead, we conclude that the value is significant. If, on the other hand, the p-value of the slope is greater than or equal to 0.05, 
then we cannot reject the claim that the value is due to randomness. In our case, the statistical software tells us that the p-value of the slope is less than 0.05, therefore we reject the claim that the value that we 
obtained for the slope might have been due to randomness and nothing more. We therefore conclude that the value of the slope is significant.
\subsection{The Residuals}
Now that we have the equation for the best-fit line, we can calculate how accurate the line is. This is done by predicting values. We predict values, when we enter the value of the independent variable into the 
equation in order to calculate the value of the dependent variable. What we want is for the predicted value to be as close to the observed value as possible. Table ~\ref{table:datapointspredicted} shows the predicted values of GPA when we use 
the linear equation. It also shows the residuals, which are calculated using the equation $(actual\, GPA)-(predicted\, GPA)$.
\begin{table}[h!t]
	\caption{Calculating the predicted values and the residuals.} \label{table:datapointspredicted}
	\centering
	\begin{tabular}{c c c c}
	\hline
	\bf GPA & \bf Attendance & \bf Predicted & \bf Residuals \\
	\hline
	95 & 75 & 78.18	16.82 \\
	60 & 65 & 66 & -6 \\
	65 & 64 & 64.78 & 0.22 \\
	70 & 72 & 74.53 & -4.53 \\
	78 & 75 & 78.18 & -0.18 \\
	82 & 80 & 84.27 & -2.27 \\
	84 & 80 & 84.27 & -0.27 \\
	77 & 74 & 76.96 & 0.04 \\
	79 & 75 & 78.18 & 0.82 \\
	89 & 84 & 89.15 & -0.15 \\
	60 & 63 & 63.56 & -3.56 \\
	71 & 69 & 70.87 & 0.13 \\
	74 & 70 & 72.09 & 1.91 \\
	82 & 77 & 80.62 & 1.38 \\
	79 & 75 & 78.18 & 0.82 \\
	68 & 64 & 64.78 & 3.22 \\
	90 & 88 & 94.02 & -4.02 \\
	75 & 76 & 79.4 & -4.4 \\
	77 & 74 & 76.96 & 0.04 \\
	\hline
	\end{tabular}
\end{table}
The residuals are very important for two reasons. The first reason is that they tell us how accurate our equation is. If the residuals are large, then this means that the predicted values are not close to the actual values. 
Therefore, what we want is for the residuals to be as small as possible. We also want almost half of the residuals to be negative and the other half positive. The reason for this is that if most residuals are negative, 
then this means that most predicted values are greater than the actual values. This implies that the line is always over predicting the values. 

Graphically speaking, most of the points would lie below the line. If, on the other hand, most of the residuals are positive, then this means that the line is always under predicting the values. Graphically, 
this would mean that most of points would lie above the line. A well-fit line must pass between the points, which means that roughly half of the points are above the line and the other half below the line. If this 
is the case, the average of the residuals would be close to zero, since when we add the residuals the positive values will cancel out the negative values. If you calculate the average of the residuals in the above 
table, you will find that it is around 0.001, which is very close to zero. Figure ~\ref{fig:bestfitsimple} plots both the scatter plot and the best-fit line on the same graph. We can see from the graph that the line passes through the points. 
Some of the points are above the line, and others are below the line. We also see that the points are in general close to the line. This means that the magnitude of the residuals is generally small.

tex*/
qui use linear1, clear
texdoc stlog, cmdstrip nooutput
twoway (scatter gpa attendance, mcolor(green) msymbol(O))(lfit gpa attendance, lcolor(orange) lpattern(dash)), graphregion(color(white))
texdoc stlog close
texdoc graph, caption(The best-fit line as computed by the simple regression model.) label(fig:bestfitsimple) figure(h) optargs(width=0.7\textwidth)
/*tex

The second reason that residuals are extremely important is that after we fit a linear model, we need to test the validity of the assumptions that we have made. Residuals play a crucial role in this. This topic will be 
discussed in a later section. For now, what is important is that you understand how to calculate the predicted value and the values of the residuals.
\section{Multiple Linear Regression}
At this point, it would make perfectly good sense for someone to object to the fact that we have been using the grade on attendance to predict the overall GPA of the student. Surely there are other factors at play here. 
It cannot be that the only thing that affects students’ GPA is how much they attend classes. This is a very valid concern. Actually, you would be hard pressed to see a publication where the author uses a model that includes 
only one independent variable. The reality is that the dependent variable is influenced by several factors. We started with the simple case of a single independent variable in order to illustrate the concept of linear 
regression. Now that we understand the basic concept, expanding it to include more than one independent variable is quite easy.
\subsection{The Slopes}
When we have more than one independent variable, the equation becomes:

$$ y=a_1x_1+a_2x_2+...+b $$

The independent variables are represented by the variable x, and the slopes associated with each are represented by the variable a. There is nothing new in the equation except that we added extra terms. 
In order to understand what each slope represents, consider the following case:

$$ y=2x_1+3x_2+4 $$

To calculate the value of y we will need to know the values of both $x_1$ and $x_2$. Assume that we start with $x_1$ equal to 2 and $x_2$ equal to 3. This means that y will 2(2) + 3(3) + 4 = 17. If the value of $x_1$ increased by 
one and became 3, the value of y will become 2(3) + 3(3) + 4 = 19. As you can see, the dependent variable increased by 2 points, which is the value of the coefficient that is attached to the independent variable 
that increased by one unit. This means that nothing has changed. The coefficient by which the independent variable is multiplied still tells us about the relationship between the dependent and the independent variable. 
We know that if $x_1$ increased by one, y will increase by two.

What about the other independent variable, $x_2$? When $x_1$ equals 2 and $x_2$ equals 3, y is equal to 17. If the value of $x_2$ increases by one and becomes 4, y will become 2(2) + 3(4) + 4 = 20. The value of the dependent 
variable increases by the value of the coefficient which is attached to the independent variable, which happens to be 3 in this case. There is nothing new here. This is just the same as when there was one independent 
variable. No matter how many independent variables there are, when we want to understand the relationship between any single independent variable and the dependent variable, we just look at the value of the coefficient 
that is associated with the independent variable.

An important point to note here is that since the slope of $x_1$ is 2 and the slope of $x_2$ is 3, we see that a change in $x_2$ results in a larger change in the dependent variable than a change in $x_1$. If $x_1$ 
increases by one the dependent variable will increase by 2, but if $x_2$ increases by one the dependent variable will increase by 3. We therefore conclude that the effect of $x_2$ on y is larger than the effect of $x_1$ on y. 

Let us now see this concept in action. In our previous example, we gathered data about the students’ GPAs and their grade on attendance. Since it is too simplistic to assume that GPA only depends on attendance, 
we go around and ask the students how many hours they studied over the past week. The results are shown in Table ~\ref{table:datapointsnewvariable}. The values of GPA and attendance are the same as before. The only new thing in the table is the column 
that records the number of hours studied by the student over the past week.
\begin{table}[h!t]
	\caption{The data points.} \label{table:datapointsnewvariable}
	\centering
	\begin{tabular}{c c c}
	\hline
	\bf GPA & \bf Attendance & \bf Study \\
	\hline
	95 & 75 & 45 \\
	60 & 65 & 19 \\
	65 & 64 & 15 \\
	70 & 72 & 22 \\
	78 & 75 & 28 \\
	82 & 80 & 33 \\
	84 & 80 & 40 \\
	77 & 74 & 30 \\
	79 & 75 & 28 \\
	89 & 84 & 37 \\
	60 & 63 & 10 \\
	71 & 69 & 29 \\
	74 & 70 & 31 \\
	82 & 77 & 36 \\
	79 & 75 & 38 \\
	68 & 64 & 25 \\
	90 & 88 & 30 \\
	75 & 76 & 30 \\
	77 & 74 & 30 \\
	\hline
	\end{tabular}
\end{table}
So now what? Previously we created a scatter plot of the variables GPA and attendance in order to see whether there was any type of pattern. Let us now do the same for the new variable study. Figure ~\ref{fig:scatterwithstudy} shows the scatter plot for 
the variables GPA and study. Once again, we see evidence that students who have a higher GPA tend to study more than students who have a low GPA. Therefore, it would make sense to include this variable in our model.

tex*/
texdoc stlog, cmdstrip nooutput
twoway scatter gpa study, mcolor(green) msymbol(O) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Scatter plot of GPA and study.) label(fig:scatterwithstudy) figure(h) optargs(width=0.7\textwidth)
/*tex

When we run a linear regression model that includes GPA as the dependent variable and the variables attendance and study as the independent variables, we find that the best-fit line has the following form:

$$ GPA=0.71(attendance)+0.59(study)+6.98 $$

What does this mean? It means that if two students have the same level of attendance, but one student studies one hour more than the other, then that student will have a GPA that is 0.59 higher than the GPA of the other student. 
It also means that if two students study the same amount of time, but one student has one extra point on his or her attendance than the other, the that student will have a GPA that is 0.71 higher than the other student. We also see 
that the coefficient of the variable attendance is larger than the coefficient of the variable study. This means that attendance has a larger effect on the GPA than studying.
\subsection{R-squared}
Which model is better? In the original model, we just had one independent variable. We now have two. How can we choose? There are several ways to test this. In this section, we will only look at one of these ways (there is a section later on 
dedicated to this topic). In the original mode, the value of R-squared was 0.75. In the new model, the value of R-squared is 0.90, which is much closer to one. As you recall, R-square is a measure of the proportion of the variation in the dependent 
variable that is explained by our model. The closer it is to one, the better our model at explaining the variation. Therefore, we see that by taking into consideration the variable study, the model now accounts for around 90\% of the observed variation. 
This means that this model is better than the first model.
\subsection{The P-values}
The meaning of the p-values also remains the same, whether we have one independent variable or more than one. The only difference is that there is one p-value associated with each independent variable. In order to know whether an independent variable 
is significant, all we need to do is to look at its p-value. In the output of the model that includes both attendance and study, both p-values are found to be less than 0.05. As you recall, a p-value that is less than 0.05 means that we can reject the 
claim, or hypothesis, that what we are observing is just due to chance or randomness. This means that the values for both coefficient are significant.
\subsection{The Residuals}
Now that we have our equation, we can use it to predict the values of GPA. Once we have the predicted values, we can calculate the residuals. Once again, there is no difference between having one independent variable or two. All we need to do is to plug 
in the values into our equation. The results are shown in Table ~\ref{table:datapointspredictedmulti}. 
\begin{table}[h!t]
	\caption{Calculating the predicted values and the residuals.} \label{table:datapointspredictedmulti}
	\centering
	\begin{tabular}{c c c c c}
	\hline
	\bf GPA & \bf Attendance & \bf Study & \bf Predicted GPA & \bf Residuals \\
	\hline
	95 & 75 & 45 & 86.78 & 8.22 \\
	60 & 65 & 19 & 64.37 & -4.37 \\
	65 & 64 & 15 & 61.31 & 3.69 \\
	70 & 72 & 22 & 71.11 & -1.11 \\
	78 & 75 & 28 & 76.77 & 1.23 \\
	82 & 80 & 33 & 83.27 & -1.27 \\
	84 & 80 & 40 & 87.38 & -3.38 \\
	77 & 74 & 30 & 77.24 & -0.24 \\
	79 & 75 & 28 & 76.77 & 2.23 \\
	89 & 84 & 37 & 88.46 & 0.54 \\
	60 & 63 & 10 & 57.66 & 2.34 \\
	71 & 69 & 29 & 73.09 & -2.09 \\
	74 & 70 & 31 & 74.98 & -0.98 \\
	82 & 77 & 36 & 82.9 & -0.9 \\
	79 & 75 & 38 & 82.65 & -3.65 \\
	68 & 64 & 25 & 67.19 & 0.81 \\
	90 & 88 & 30 & 87.19 & 2.81 \\
	75 & 76 & 30 & 78.66 & -3.66 \\
	77 & 74 & 30 & 77.24 & -0.24 \\
	\hline
	\end{tabular}
\end{table}
Take the first row for example. We know that the equation is: 

$$ GPA=0.71(attendance)+0.59(study)+6.98 $$

We replace the values of attendance and study to get:

$$ GPA=0.71(75)+0.59(45)+6.98 $$

Therefore, the error is $95 – 86.78 = 8.22$. This is a large error, but it seems to be the exception. If you calculate the average of the errors you will find it to be around -0.00053, which is very close to zero. As you recall, when the average is close 
to zero, what we have is that the positive errors and the negative errors are cancelling each other out, which is what we want since this shows that the line passes through the data as opposed to passing above or below the data.
\section{Binary Variables}
So far, the independent variables have been numerical in nature. Both GPA and attendance levels are recorded as numbers. Sometimes however, including variables that are not numeric in nature is necessary. For example, what if we wanted to 
investigate whether the variation in GPA could be explained by the gender of the students? We saw that students who attend more have higher GPAs, but what if we wanted to investigate whether males have higher GPAs than females? Here, the variable gender 
is not numeric. It is categorical, in that it divides the observations into categories. Since biological gender is either male or female, there are two categories in which each student might fall.

In such a case, we can create a binary variable to represent the two categories. A binary number takes on the values of zero or one. We next assign each of these values to a category. Let us assign a zero to males and a one to females. 
Table ~\ref{table:binary} shows the result of this process. By assigning numbers to gender, we have quantified the variable. We can now include it in the regression model. The equation will be:
\begin{table}[h!t]
	\caption{Adding a binary variable to study the effect of gender.} \label{table:binary}
	\centering
	\begin{tabular}{c c c c c}
	\hline
	\bf GPA & \bf Attendance & \bf Study & \bf Gender & \bf Binary  \\
	\hline
	95 & 75 & 45 & female & 1 \\
	60 & 65 & 19 & male & 0 \\
	65 & 64 & 15 & male & 0 \\
	70 & 72 & 22 & male & 0 \\
	78 & 75 & 28 & female & 1 \\
	82 & 80 & 33 & female & 1 \\
	84 & 80 & 40 & female & 1 \\
	77 & 74 & 30 & male & 0 \\
	79 & 75 & 28 & female & 1 \\
	89 & 84 & 37 & female & 1 \\
	60 & 63 & 10 & male & 0 \\
	71 & 69 & 29 & male & 0 \\
	74 & 70 & 31 & male & 0 \\
	82 & 77 & 36 & female & 1 \\
	79 & 75 & 38 & male & 0 \\
	68 & 64 & 25 & male & 0 \\
	90 & 88 & 30 & female & 1 \\
	75 & 76 & 30 & male & 0 \\
	77 & 74 & 30 & male & 0 \\
	\hline
	\end{tabular}
\end{table}
$$ GPA=a_1(attendance)+a_2(study)+a_3(gender)+b $$

If we run the regression model, we will find that the value of the coefficients are as such:

$$ GPA=0.51(attendance)+0.56(study)+4.29(gender)+21.18 $$

We already know how to interpret the coefficients of the variables attendance and study. However, what does it mean that the coefficient of gender is 4.29? Remember that for males the value of gender is zero, while for females the value of gender is one. 
Take the following example. Calculate the predicted value of GPA for a student who has an attendance grade of 80, and who studied for 35 hours in the last week. Do this once for a male and once for a female:

Male: $ 0.51(80)+0.56(35)+4.29(0)+21.18=81.58 $

Female: $ 0.51(80)+0.56(35)+4.29(1)+21.18=85.87$

What we see is that the female has a higher GPA, and that the GPA is higher by 4.29. Therefore, the coefficient of the binary variable is the difference between an individual who belongs to the group that is assigned a zero value and an individual 
who belongs to the group that is assigned the value one.

At this point, you might ask what if we coded the variable differently? What if we assigned a value of zero to females and a value of one to males? If you do this, the output from linear regression will be:

$$ GPA=0.51(attendance)+0.56(study)-4.29(gender)+25.47 $$

The coefficients for attendance and study remain the same. Looking at the coefficient of gender, we notice that the magnitude is the same as before but that the sign has been reversed. We also notice that the value of the intercept term has changed. 
Let us now do the same calculations as before:

Male: $ 0.51(80)+0.56(35)-4.29(1)+25.47=81.58 $

Female: $ 0.51(80)+0.56(35)-4.29(0)+25.47=85.87$

The predicted values remain the same. As you can see, it doesn’t make a difference how we code the variable. What matters is that we be aware of the coding in order to properly interpret the value of the coefficient. In the first case, 
a positive coefficient indicated that the group which was assigned the value one (females) had a higher GPA. In the second case, the negative coefficient indicated that the group which was assigned the value one (males) had a lower GPA.
\section{Categorical Variables with more than Two Categories}
When we included gender in the equation, we used a binary variable since gender can take on one of two values. What if we had a categorical variable that divided the observations into more than two groups? For example, students enroll in different majors. 
Assume that the students included in our dataset were majoring in business, engineering, biology, or philosophy. In this case, we cannot use a binary variable because there are four groups instead of two. What we can do however, is to use more than one 
binary variable, as shown in Table ~\ref{table:threecat}. 
\begin{table}[h!t]
	\caption{Coding the categorical variable.} \label{table:threecat}
	\centering
	\begin{tabular}{c c c c}
	\hline
	{} & $\mathbf{x_1}$ & $\mathbf{x_2}$ & $\mathbf{x_3}$  \\
	\hline
	Business & 0 & 0 & 0 \\
	Engineering & 1 & 0 & 0 \\
	Biology & 0 & 1 & 0 \\
	Philosophy & 0 & 0 & 1 \\
	\hline
	\end{tabular}
\end{table}
If you look at the column for the variable x1, you will notice that the variable takes a value of one for engineering, and zero otherwise. X2 takes on a value of one for biology and zero otherwise. X3 takes on a value of one for philosophy and 
zero otherwise. How did we know that we need three binary variables? The number of binary variables needed is the number of categories minus one. In our case, we have four categories, so it is 4 – 1 = 3. The equation now becomes:
 
$$ GPA=a_1(attendance)+a_2(study)+a_3(gender)+a_4x_1+a_5x_2+a_6x_3+b $$
 
For a business student, $x_1$, $x_2$, and $x_3$ are zero. For an engineering student, only $x_1$ is one and the rest are zero. For a biology student only $x_2$ is one. For a philosophy student only $x_3$ is one. Assume that we ran the regression model, 
and that we got the following output:

$ GPA=0.47(attendance)+0.43(study)+4.13(gender)+2.31x_1+2.17x_2+-3.45x_3+23.02 $

How do we interpret this result? It is actually simpler than it looks. The coefficient of $x_1$ is 2.31. This variable is one only when the student is an engineering student. Therefore, if a student is engineering we add 2.31 to the predicted GPA. 
The coefficients of $x_2$ and $x_3$ do not matter because the values of $x_2$ and $x_3$ for an engineering student are zero. So an engineering student has a GPA that is 2.31 points higher, but higher than who? Let us calculate the GPAs of female students, 
one from each major, who have a grade of 80 on attendance, and who have studied 35 hours the last week:

Business: $ GPA=0.47(80)+0.43(35)+4.13(1)+2.31(0)+2.17(0)+-3.45(0)+23.02=80 $

Engineering: $ GPA=0.47(80)+0.43(35)+4.13(1)+2.31(1)+2.17(0)+-3.45(0)+23.02=82.31 $

Biology: $ GPA=0.47(80)+0.43(35)+4.13(1)+2.31(0)+2.17(1)+-3.45(0)+23.02=82.17 $

Philosophy: $ GPA=0.47(80)+0.43(35)+4.13(1)+2.31(0)+2.17(0)+-3.45(1)+23.02=76.55 $

The difference between a business student and an engineering student is 2.31, which is the coefficient of $x_1$. The difference between a business student and a biology student is 2.17, which is the coefficient of $x_2$. The difference between a 
business student and a philosophy student is negative 3.45, which is the coefficient of $x_3$. Therefore, as you can see, the coefficients of each binary variable represent the difference between individuals who are assigned a value of one for that 
variable and between the students who have been assigned zeros for all variables. This is why the group for which all the binary variables are zero is called the referent group. The coefficients compare each group with the referent group. In our 
case, the referent group is business.
\section{Quadratic Terms}
Assume that someone told you that a student’s command of the English language also affects his or her GPA. The argument here is that students who are better at English, are in a better position to read more and to express themselves more. 
In addition, they might be more confident, and this would affect their performance. Table ~\ref{table:quadratic} displays the GPAs along with the grade obtained on the English course. The scatter plot of the above data is show in Figure ~\ref{fig:scatterenglish}. 
\begin{table}[h!t]
	\caption{Data points for the variables GPA and English.} \label{table:quadratic}
	\centering
	\begin{tabular}{c c}
	\hline
	\bf GPA & \bf English \\
	\hline 
	95 & 95 \\
	60 & 55 \\
	65 & 55 \\
	70 & 58 \\
	78 & 66 \\
	82 & 69 \\
	84 & 82 \\
	77 & 67 \\
	79 & 70 \\
	89 & 87 \\
	60 & 54 \\
	71 & 60 \\
	74 & 64 \\
	82 & 71 \\
	79 & 73 \\
	68 & 57 \\
	90 & 80 \\
	75 & 70 \\
	77 & 72 \\
	\hline
	\end{tabular}
\end{table}	
 
tex*/
texdoc stlog, cmdstrip nooutput
scatter gpa english, mcolor(green) msymbol(O) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Scatter plot of the variables GPA and English.) label(fig:scatterenglish) figure(h) optargs(width=0.7\textwidth)
/*tex

We can see that students with a higher grade on English tend to have a higher GPA. If we fit a simple linear regression model, we get the following equation:

$$ GPA=0.80(english)+21.95 $$

The output will also tells is that the p-value of the coefficient of the independent variable English is less than 0.05, so the result is significant. In addition, the R-squared value of the model is 0.89, which is very close to one. 
Everything looks good. If we take a closer look at the scatter plot, we will notice that the dots don’t seem to fall on a line. This is best illustrated by drawing the best-fit line on the same curve. Figure ~\ref{fig:scatterlinearfitenglish} shows the result obtained.

tex*/
texdoc stlog, cmdstrip nooutput
twoway (scatter gpa english, mcolor(green) msymbol(O)) (lfit gpa english, lcolor(orange) lpattern(dash)), graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Drawing the best-fit line resulting from regressing GPA on English.) label(fig:scatterlinearfitenglish) figure(h) optargs(width=0.7\textwidth)
/*tex

We notice that there seems to be a steep rise in the dots initially, and that the rise tends to level off. When we suspect that the relationship between two variables might be non-linear, we can include a quadratic term in order to test our 
suspicion. If you recall from high school algebra, the equation of a quadratic formula is:

$$ y=ax^2+bx+c $$

This is the same as the linear equation only with an extra quadratic term, where the variable x is squared. We can do the same in our model. Instead of fitting this model:

$$ GPA=a(english)+b $$

We can fit this model:

$$ GPA=a_1(english)^2+a_2(english)+b $$

Since we already have the values of the variable English, we can just create a new column that contains the square of these values. Table ~\ref{table:quadraticsquare} displays the result of squaring the variable English.
\begin{table}[h!t]
	\caption{Data points after we add the square of the variable English.} \label{table:quadraticsquare}
	\centering
	\begin{tabular}{c c c}
	\hline
	\bf GPA & \bf English & $\mathbf{English^2}$\\
	\hline 
	95 & 95 & 9025 \\
	60 & 55 & 3025 \\
	65 & 55 & 3025 \\
	70 & 58 & 3364 \\
	78 & 66 & 4356 \\
	82 & 69 & 4761 \\
	84 & 82 & 6724 \\
	77 & 67 & 4489 \\
	79 & 70 & 4900 \\
	89 & 87 & 7569 \\
	60 & 54 & 2916 \\
	71 & 60 & 3600 \\
	74 & 64 & 4096 \\
	82 & 71 & 5041 \\
	79 & 73 & 5329 \\
	68 & 57 & 3249 \\
	90 & 80 & 6400 \\
	75 & 70 & 4900 \\
	77 & 72 & 5184 \\
	\hline
	\end{tabular}
\end{table}	
We can next fit a linear regression model by including these two variables. The output of such a model will be:

$$ GPA=-0.01(english)^2+2.35(english)-32.82 $$

The output will also indicate that the p-value of the quadratic term is less than 0.05, which means that it is significant. The R-squared value of this model is 0.92, while the R-squared value of the model that did not contain the quadratic term was 0.89. 
Therefore, we can conclude that including the quadratic term is the right thing to do. This is why when you perform linear regression, you should always start by producing plots. Plots are an excellent way for us to investigate what sort of relationship 
exists between the dependent variable and each independent variable. Any good regression analysis must start with graphs.
\section{Checking Model Fit and Assumptions}
Linear regression models make several assumptions about the data. The validity of the model depends on the validity of these assumptions. This is why, one of the most important topics in regression, is testing the assumptions. This is usually done 
after we do linear regression. We first find the best-fit model, and then we test the assumptions that linear regression makes using the best-fit model. In this section, we will go over some of the most important assumptions.
\subsection{Prediction}
The first thing that you should do after you fit a model is to see whether the values predicted by the model are close to the observed values. This can be easily accomplished by plotting the predicted values against the observed values. 
If the predicted values are similar to the observed values, then the scatter plot will lie along the diagonal line that represents the equation y = x. We had previously fit a model in which the dependent variable was GPA and the independent 
variables were attendance, study, and gender. The best-fit line turned out to be the following:

$$ GPA=0.51(attendance)+0.56(study)+4.29(gender)+21.18 $$

Figure ~\ref{fig:modelfit} plots the predicted values against the observed values. The figure also shows the diagonal line along which the points should fall if the predicted values and the observed values are similar. 
In our case, the predicted values seem to be close to the actual values.

tex*/
qui regress gpa attendance study i.gender
qui predict gpahat
texdoc stlog, cmdstrip nooutput
twoway (scatter gpahat gpa, mcolor(green) msymbol(O)) (lfit gpa gpa, lcolor(orange) lpattern(dash)), graphregion(color(white)) ytitle(Fitted values) xtitle(Observed values)
texdoc stlog close
texdoc graph, caption(Checking model fit: Plotting the predicted values against the observed values (The dashed line represents the 45 degree diagonal along which the points should fall if the model was well fit).) label(fig:modelfit) figure(h) optargs(width=0.7\textwidth)
/*tex

\subsection{Residuals}
We have previously seen that the residuals are calculated using the following formula:

$$ Observed\, value - Predicted\, value $$

Linear regression makes several assumptions about the distribution of the residuals. This is why after we fit a model, we need to calculate the residuals and test whether these assumptions are valid or not.
\subsubsection{Normality}
One assumption is that the residuals have a normal distribution. In order to test this, we can plot the histogram of the residuals. Let’s look at an example. We had previously fit a model in which the dependent variable was GPA and the 
independent variables were attendance, study, and gender. The best-fit line turned out to be the following:

$$ GPA=0.51(attendance)+0.56(study)+4.29(gender)+21.18 $$

Figure ~\ref{fig:normality} displays the histogram of the residuals with an overlaid normal distribution. Looking at the graph we can see that the residuals do not seem to follow a normal distribution, since the left tail of the histogram is cut abruptly. This 
result casts a shadow on our model and should make us question the results.

tex*/
qui predict res, residual
texdoc stlog, cmdstrip nooutput
histogram res, color(green) lcolor(black) graphregion(color(white)) normal normopts(lcolor(black))
texdoc stlog close
texdoc graph, caption(Checking the normality of the residuals: A histogram of the residuals overlaid with a normal curve.) label(fig:normality) figure(h) optargs(width=0.7\textwidth)

/*tex

\subsubsection{Independence}
Another assumption that is made by the linear regression model is that the residuals are independent. This means that if the residuals were plotted on the y-axis and any of the independent variables on the x-axis, we should see no pattern. 
Figure ~\ref{fig:independent} for example is a plot of the residuals against the variable attendance. There doesn’t seem to be a clear pattern, so it doesn’t seem that the assumption of independence has been violated.

tex*/
texdoc stlog, cmdstrip nooutput
scatter res attendance, mcolor(green) graphregion(color(white)) 
texdoc stlog close
texdoc graph, caption(Testing for independence of the residuals: Plotting the residuals against the independent variable attendance.) label(fig:independent) figure(h) optargs(width=0.7\textwidth)
/*tex

In order to see what sort of figure would indicate that the assumption of independence is violated, look at Figure ~\ref{fig:violate} which plots the residuals against an independent variable named X. In the figure, the residuals display a pattern. 
We see that they tend to decrease and then start to increase again. This figure would raise a flag.

tex*/
qui clear all
qui set obs 20
qui gen X = .
qui gen residuals = .
qui replace X =  0.007 in 1
qui replace residuals = 6.2  in 1

qui replace X =  0.01 in 2
qui replace residuals = 3  in 2

qui replace X =  0.012 in 3
qui replace residuals = 1.8  in 3

qui replace X =  0.013 in 4
qui replace residuals = -4.1  in 4

qui replace X =  0.0132 in 5
qui replace residuals = -1.8  in 5

qui replace X =  0.0133 in 6
qui replace residuals = 0.1  in 6

qui replace X =  0.014 in 7
qui replace residuals = -1.84  in 7

qui replace X =  0.014 in 8
qui replace residuals = -2.4  in 8

qui replace X =  0.015 in 9
qui replace residuals = -4.8  in 9

qui replace X =  0.016 in 10
qui replace residuals = -2.2  in 10

qui replace X =  0.017 in 11
qui replace residuals = 0  in 11

qui replace X =  0.018 in 12
qui replace residuals = -1  in 12

qui replace X =  0.019 in 13
qui replace residuals = 0  in 13

qui replace X =  0.019 in 14
qui replace residuals = 0.3  in 14

qui replace X =  0.02 in 15
qui replace residuals = 0.4  in 15

qui replace X =  0.02 in 16
qui replace residuals = 0.5  in 16

qui replace X =  0.024 in 17
qui replace residuals = 0.7  in 17

qui replace X =  0.02 in 18
qui replace residuals = 2  in 18

qui replace X =  0.02 in 19
qui replace residuals = 2.2  in 19

qui replace X =  0.024 in 20
qui replace residuals = 3  in 20


texdoc stlog, cmdstrip nooutput
scatter res X, mcolor(green) graphregion(color(white)) ytitle(Residuals) xtitle(X)
texdoc stlog close
texdoc graph, caption(Testing for independence of the residuals: A case where the assumption is violated.) label(fig:violate) figure(h) optargs(width=0.7\textwidth)
/*tex

If we have a multiple linear model that contains several independent variables, instead of plotting the residuals against each independent variable by itself we can just plot the residuals against the predicted values of the dependent variable. 
Figure ~\ref{fig:plotagainstfitted} shows this graph for the model that contains the three independent variables attendance, study, and gender. Since there doesn’t seem to be a patter, we can assume that the independence assumption is met. The graph however does show that 
there is another type of problem, which will be discussed next.

tex*/
qui clear all
qui set obs 20
qui gen X = .
qui gen residuals = .
qui replace X =  59 in 1
qui replace residuals = 1.8  in 1

qui replace X =  63 in 2
qui replace residuals = 3  in 2

qui replace X =  64 in 3
qui replace residuals = -4.2  in 3

qui replace X =  67 in 4
qui replace residuals = 0.4  in 4

qui replace X =  70 in 5
qui replace residuals = 0.1  in 5

qui replace X =  73 in 6
qui replace residuals = -1.4  in 6

qui replace X =  75 in 7
qui replace residuals = 0  in 7

qui replace X =  76 in 8
qui replace residuals = 1  in 8

qui replace X =  77 in 9
qui replace residuals = -0.8  in 9

qui replace X =  79 in 10
qui replace residuals = -1  in 10

qui replace X =  79 in 11
qui replace residuals = 0  in 11

qui replace X =  81 in 12
qui replace residuals = -1.4  in 12

qui replace X =  85 in 13
qui replace residuals = -2.2  in 13

qui replace X =  86 in 14
qui replace residuals = -2.4  in 14

qui replace X =  87 in 15
qui replace residuals = 3.5  in 15

qui replace X =  88 in 16
qui replace residuals = -4.1  in 16

qui replace X =  89 in 17
qui replace residuals = 4  in 17

qui replace X =  90 in 18
qui replace residuals = 6  in 18

qui replace X =  90 in 19
qui replace residuals = -5  in 19

texdoc stlog, cmdstrip nooutput
scatter res X, mcolor(green) graphregion(color(white)) ytitle(Residuals) xtitle(X)
texdoc stlog close
texdoc graph, caption(Testing for the independence of the residuals: Plotting the residuals against the predicted values of the dependent variable.) label(fig:plotagainstfitted) figure(h) optargs(width=0.7\textwidth)

/*tex

\subsubsection{Constant Variance}
In addition to being normal and independent, the residuals must also have a constant variance. This is called the homoskedasticity assumption. To investigate whether this assumption is valid or not, we again plot the residuals against an independent 
variable. This time however, instead of looking at whether there are patterns in the residuals, we would look at whether the variation of the residuals around the x-axis is constant. As you recall, some residuals are positive while others are negative. 
This is due to the fact that the line passes between the data points, so some of the data points are above the line while others are below the line. This means that for some points the observed value is greater than the predicted value, while in other 
cases the opposite is true. The residuals are therefore scattered on both sides of the y = 0 line, which is the x-axis. This can be seen from the two figures above. Homoskedasticity means that the variation of the errors around this line should be constant. 
For example, Figure ~\ref{fig:homoviolate} shows a case where the assumption of homoskedasticity is clearly violated. We can see that the residuals tend to get further away from the x-axis as we move from left to right, thus indicating that their variance 
is increasing.

tex*/
qui clear all
qui set obs 20
qui gen X = .
qui gen residuals = .
qui replace X =  -4.4 in 1
qui replace residuals = 0.015  in 1

qui replace X =  -4.1 in 2
qui replace residuals = 0.012  in 2

qui replace X =  -3 in 3
qui replace residuals = 0.013  in 3

qui replace X =  -2.4 in 4
qui replace residuals = 0.017  in 4

qui replace X =  -1.7 in 5
qui replace residuals = 0.013  in 5

qui replace X =  -1.7 in 6
qui replace residuals = 0.017  in 6

qui replace X =  -0.8 in 7
qui replace residuals = 0.02  in 7

qui replace X =  0.1 in 8
qui replace residuals = 0.017  in 8

qui replace X =  0.2 in 9
qui replace residuals = 0.012  in 9

qui replace X =  0.4 in 10
qui replace residuals = 0.018  in 10

qui replace X =  0.05 in 11
qui replace residuals = 0.02  in 11

qui replace X =  1.6 in 12
qui replace residuals = 0.01  in 12

qui replace X =  2 in 13
qui replace residuals = 0.022  in 13

qui replace X =  2.1 in 14
qui replace residuals = 0.02  in 14

qui replace X =  3 in 15
qui replace residuals = 0.01  in 15

qui replace X =  3.2 in 16
qui replace residuals = 0.023  in 16

qui replace X =  6.5 in 17
qui replace residuals = 0.007  in 17

qui replace X =  6.6 in 18
qui replace residuals = 0.025  in 18

texdoc stlog, cmdstrip nooutput
scatter res X, mcolor(green) graphregion(color(white)) ytitle(Residuals) xtitle(X)
texdoc stlog close
texdoc graph, caption(Testing for homoskedasticity: A case where the assumption is violated.) label(fig:homoviolate) figure(h) optargs(width=0.7\textwidth)
/*tex

When we discussed the assumption of normality, it was stated that if we were running a multiple linear regression model where there were several independent variables, we can plot the residuals against the predicted values of the dependent variable. 
The same can be done here. In fact, we have already produced this graph (Figure ~\ref{fig:plotagainstfitted}). In this case the graph clearly shows that the assumption of homoskedasticity is clearly violated. The residuals near the two ends of the graph 
show a larger variability than the residuals near the middle.
\subsection{Multicollinearity}
In the case of multiple linear regression we have more than one independent variable. An important assumption of multiple linear regression is that multicolinearity does not exist. This means that the independent variables should not 
be correlated with one another, and that no variable is a linear combination of other variables. This basically means that knowing the values of one or more of the independent variables should not allow us to predict the value of another 
independent variable.

If there are only two independent variables in the model, then testing for multicolinearity is easy. All we have to do is to calculate the correlation between the two independent variables. However, it is more often the case that there are more than two 
independent variables in any given model. Although one might think that we should calculate the correlation between each pair of independent variables, this is not the best solution, since multicollinearity might be a result of an independent variable 
being a linear combination of two or more other independent variables. Therefore, to test for multicollinearity, we can calculate the variance inflation factor (VIF) for each independent variable. Multicollinearity exists if the value of the VIF for any 
variable is greater than 10. If this is the case, it might be necessary to eliminate the variable from the analysis.
\section{Diagnostics}
What if we checked the model fit and the assumptions of independence, normality, and homoscedasticity and found that some of these assumptions were violated? Does this mean that we should just through away our model? Fortunately, the answer is no. 
What we should do at this point is to take a closer look at the individual data points in order to see whether some points are responsible for the problems that we have uncovered. If this is the case, we will then have to decide what to do with 
these observations.
\subsection{Outliers}
An outlier is an observation that does not fit well with the rest of the point. It is quite easy to identify outliers because they are located very far from the rest of the points. Outliers by themselves are not a problem. There are some cases 
where an outlier can cause problems and other cases where it is not the case. Let us look at an example. Figure ~\ref{fig:outlier} shows a scatter plot of the exact same data that we have been using so far except that there is an addition observation, which is 
colored in red in the figure. All the other points remain unchanged. This red dot represents a student who does not attend classes (he or she has an attendance grade of 30%) but manages to maintain a very high GPA (94%). The student is an outlier 
because the point that represents him or her is very far from the other points.

tex*/
qui use linear2, clear
texdoc stlog, cmdstrip nooutput
twoway (scatter gpa attendance if attendance > 40, mcolor(green)) (scatter gpa attendance if attendance < 40, mcolor(red)), graphregion(color(white)) 
texdoc stlog close
texdoc graph, caption(Outliers: The red dot is a new observation.) label(fig:outlier) figure(h) optargs(width=0.7\textwidth)
/*tex

In order to see why this outlier may be a problem, look at Figure ~\ref{fig:outliereffect}. The figure shows the scatter plot just like the one before it, but it also shows two lines. The line with short dashes is the best-fit line that is calculated when all the points 
(the original points and the new outlier point) are included. The line with long dashes is the best-fit line when we just include the original data points (the outlier is not included). What we see is that the outlier has a huge effect on the result.

tex*/
texdoc stlog, cmdstrip nooutput
twoway (scatter gpa attendance if attendance > 40, mcolor(green)) (scatter gpa attendance if attendance < 40, mcolor(red)) (lfit gpa attendance, color(orange) lpattern(dash)) (lfit gpa attendance if attendance > 40, color(blue) lpattern(dash)), graphregion(color(white)) legend(label(1 "original points") label(2 "new outlier") label(3 "line that includes all observations") label(4 "line that does not include the outlier") size(small) cols(2))
texdoc stlog close
texdoc graph, caption(The effect that an outlier has: The short dashed line includes all observations, the long dashed line includes only the original observations (excludes the outlier).) label(fig:outliereffect) figure(h) optargs(width=0.7\textwidth)
/*tex

When we include the outlier, the slope of the best-fit line decreases substantially, thus weakening the effect that attendance has on the GPA. If you run both models, you will get the following:

Excluding outlier: $ GPA=1.22(attendance)-13.20 $

Including outlier: $ GPA=0.11(attendance)+69.65 $

Not only does the coefficient significantly drop, but the other statistics are also affected. In the first model the p-value for attendance is less than 0.05 while in the second model it is 0.59. Also, the R-squared value for the first model is 0.75 
while in the second model it is 0.02. This is why, when we test our model for its goodness of fit and for the assumptions, looking at individual data points is very useful. If a single observation is causing too many problems, then a case can be made to 
exclude it. This is actually what I would do in this case. For the majority of students, there is a strong relationship between attending and between GPA. However, there is a single student who is able to get very high grades without attending. 
This student however is the exception.

It is important to remember that not all outliers cause problems. Some outliers are more influential than others. This is why, in addition to checking whether there are outliers, we also need to calculate the influence of each observation.
\subsection{Influential Observations}
There are several statistics that are used in order to measure the influence that each observation has. The idea behind them is very similar. An observation is influential if the results obtained from running a regression model differ 
significantly when that observation is included and when it is excluded. Basically, a model that includes the observation is fit. The output from the model is recorded. Then another model is run this time excluding the observation. 
Again the output is recorded. We then check whether the output has differed significantly. If there is no significant change, the observation is not influential. If, on the other hand, there is a large change in the output, the observation is deemed 
significant and a flag is raised. The three most common statistics used to measure influence are DFBETAS, DFFITS, and Cook’s D statistics. The difference between them is what change do they measure. DFBETAS measures the change in the regression 
coefficients when an observation is excluded. DFFITS and Cook’s D statistic measure the change in the predicted values when an observation is excluded.

Table ~\ref{table:influence} shows the observations and the three statistics calculated for each and every one of them. Notice that in all cases the magnitudes of the three statistics are small except in the case of the very last observation which is 
the outlier. As we can see, all three statistics agree that this is a very influential point.
\begin{table}[h!t]
	\caption{Influence statistics: Calculating DFBETAS, DFFITS, and Cook's D for all observations.} \label{table:influence}
	\centering
	\begin{tabular}{c c c c c}
	\hline
	\bf GPA & \bf Attendance & \bf DFBETAS & \bf DFFITS & \bf Cook’s D \\
	\hline
	95 & 75 & .1279324 & .4392341 & .085373 \\
	60 & 65 & .233627 & -.4746602 & .1004364 \\
	65 & 64 & .1798848 & -.3292105 & .0529771 \\
	70 & 72 & -.0073852 & -.1699561 & .0148148 \\
	78 & 75 & .0011442 & .0039286 & 8.17e-06 \\
	82 & 80 & .0616364 & .1036714 & .0056474 \\
	84 & 80 & .0961818 & .1617761 & .0136056 \\
	77 & 74 & -.0035099 & -.0165167 & .0001444 \\
	79 & 75 & .0079601 & .0273297 & .0003951 \\
	89 & 84 & .27144 & .368775 & .0675833 \\
	60 & 63 & .3048394 & -.5127347 & .1175016 \\
	71 & 69 & .0303108 & -.1426349 & .0105424 \\
	74 & 70 & .0095857 & -.0740856 & .0028884 \\
	82 & 77 & .042779 & .0991198 & .0051558 \\
	79 & 75 & .0079601 & .0273297 & .0003951 \\
	68 & 64 & .1310648 & -.2398641 & .0291732 \\
	90 & 88 & .3999571 & .4874556 & .116761 \\
	75 & 76 & -.0259086 & -.0710761 & .0026616 \\
	77 & 74 & -.0035099 & -.0165167 & .0001444 \\
	94 & 30 & -11.61065 & 12.04787 & 16.59359 \\
	\hline
	\end{tabular}
\end{table}
\section{Selection of Independent Variables}
An important issue that we face when we have a number of independent variables is how to decide which variables to add to the model and in what order. There are generally four ways to do this. The first three all rely on an algorithm and you are 
advised not to trust them. This is a very important point. You should never let the computer pick the independent variables. However, the three methods will be described since many statistical packages allow the user to use them. In addition, 
I do not think that there is anything wrong with using them as an investigative tool, i.e. in order to get an idea of what independent variables are significant and which are not.

The first selection method is referred to as forward selection. As the name suggests, this method adds independent variables one step at a time. Originally, we start with no independent variables. The algorithm then adds one of the variables 
(based on an F-test). If the p-value of that variable turns out to be less than 0.05, the variable is kept in the model. The algorithm then selects another variable (again based on an F-test) and adds it to the model. These models are 
repeated until there are no further independent variables left.

The second selection method is referred to as backward elimination. As you can imagine, we start with a model that includes all possible independent variables. The algorithm them selects the least significant independent variable 
(the one with the highest p-value). If the p-value of the selected independent variable is greater than 0.05 (which means that it is not significant) the variable is removed. The algorithm then repeats and selects the least significant 
variables from the ones that are still in the model. These steps are repeated until all variables that are included in the model have p-values that are less than 0.05 (which means that they are all significant).

The third selection method is referred to as stepwise regression. This method is a combination of the previous two. The model starts in forward mode with no independent variables. The algorithm selects the most significant independent variable and 
adds in to the model. Next, the algorithm goes into backward mode by checking to see whether any variable can be eliminated. Next, the algorithm goes back into forward mode and selects a variable from the pool of remaining variables, and then it goes 
back into backward mode. This process continues until there are no more variables to be added or dropped.

As I said, the above three algorithms should not be used to find the final model. You can, however, initially use them in order to get an initial picture of which independent variables are selected and which are not. As an initial step, there is nothing 
wrong with doing this. Ultimately however, you need to rely on the fourth method to select when and how to add the variables, and that method is to use your knowledge. Any good research must be informed by theory. The better you understand the theory, 
the better you can determine which variables to include and which to ignore. 

As you recall, the R-squared calculates how well the model explains the variation that is observed in the dependent variable. Therefore, when we are comparing two different models, we should favor the one with a higher value of R-squared. An important 
point to note here is that there is another statistics that is a variation of the R-squared statistic and it is called the adjusted R-squared. If we are comparing two models with the same number of independent variables, we can use R-squared to 
guide our decision. If, however, the models contain different numbers of variables, it would be better to look at the adjusted R-squared. Just like R-squared, the adjusted R-squared is between zero and one, and the closer it is to one, the better. 

You can also rely on the AIC and BIC statistics when you are comparing two models. These statistics can be easily calculated by statistical software. When comparing two models, we tend to favor the one with smaller values of both AIC and BIC statistics. 

\chapter{Linear Regression - Case Study}
We are now in a position to use what we have learned in a small case study. In this section, we will look at a dataset that contains information about students. What we are interested in is understanding differences in overall
GPA. The dataset contains the following variables:
\begin{itemize}
	\item gpa: overall GPA of the student (this is the dependent variable)
	\item english: the average grade on all English courses taken by the student (data is taken from a non-English speaking country where the language of instruction in university is English)
	\item college: whether the student is in the engineering school or the business school (zero means business, one means engineering)
	\item credits: the total number of credits completed so far by the student
	\item gender: whether the student is a male or a female (zero means female, one means male)
	\item attendance: attendance and participation grade last semester
	\item siblings: Number of brothers and sisters that the student has
	\item income: family income per year (\$)
	\item work: records whether the student works full time, part time, or whether the student doesnt work at all.
\end{itemize}
\section{Simple Regression}
We start by building simple models in which we include the variables separately. This will give us a feel as to the nature of the relationship between each independent variable and the dependent variable GPA. There are two
types of independent variables in our dataset, continuous and binary. We start by looking at the continuous variables.
\subsection{Continuous Variables}
The first continuous variable that we will look at is attendance, which is a measure of how much a student attends his or her assigned classes. We would like to see whether students who attend classes more often get higher GPAs.

When it comes to continuous variables, it is always best to start with a scatter plot of the dependent variables against the independent variable. The scatter plot os shown in Figure ~\ref{fig:caselinearscatter1}.

tex*/
qui use linear_project, clear
texdoc stlog, cmdstrip nooutput
scatter gpa attendance, mcolor(green) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Scatter plot of GPA and attendance.) label(fig:caselinearscatter1) figure(h) optargs(width=0.7\textwidth)
/*tex

From the graph, we see strong evidence that the more a student attends, the higher the GPA. This result is further supported by fitting a simple linear regression model:

tex*/
texdoc stlog, cmdstrip
regress gpa attendance
texdoc stlog close
/*tex

We see that the coefficient of the independent variable attendance is both positive and signififcant (p-value is less than 0.05). The output tells us that when attendance increases by one-unit, GPA increases by 0.74 points.

Another continuous variable that we need to look at is the grade on English. We would expect that students with a better command of the English language would get higher GPAs betcause they will be able to both understand
and communicate the material better. As usual, we start with a scatter plot. The scatter plot os shown in Figure ~\ref{fig:caselinearscatter2}.

tex*/
texdoc stlog, cmdstrip nooutput
scatter gpa english, mcolor(green) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Scatter plot of GPA and english.) label(fig:caselinearscatter2) figure(h) optargs(width=0.7\textwidth)
/*tex

Looking at the scatter plot, we again see that the higher the grade on Ebglish, the higher the overall GPA. However, there is a difference between this scatter plot and the one shown in Figure ~\ref{fig:caselinearscatter1}. 
The scatter plot of GPA and attendance resembles a line to a large extent. In other words, the relationship seems to be extremely linear. This is not the same as the relationship between GPA and the grade on English. We see
that the scatter plot starts to level off at a certain point. From Figure ~\ref{fig:caselinearscatter2}, we see that once the grade on English reaches around 80, further increases do not result in higher GPAs. What this means
is that once you attain a certain higher level when it comes to English, further gains mean little. A student who has an 85 on English is just as capable of understanding and communicating ideas as a student who has a 95.

What all of this means is that there is reason to suspect that the relationship between GPA and between English is non-linear. In order to see that, we can overlay the scatter plot with a line and a curve, as shown in 
Figure ~\ref{fig:caselinearscatter3}. I have made the scatter plot transparent in order to make the line and curve more visible.

tex*/
texdoc stlog, cmdstrip nooutput
twoway (scatter gpa english, mcolor(green%20) msize(small)) (lfit gpa english, color(orange)) (qfit gpa english, color(blue)), legend(label(1 "scatter plot") label(2 "linear fit") label(3 "quadratic fit") cols(3)) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Scatter plot of GPA and english.) label(fig:caselinearscatter3) figure(h) optargs(width=0.7\textwidth)
/*tex

In this figure, we see that we have drawn a line and a curve in order to see which fits the 
data best. If you notice, both do a good job from the lower english grades up to the middle grades. However, when it comes to the high end of the English grades, we see that the line passes above the points while the curve
passes through the points. This means that the curve is doing a better job of fitting the data. This figure, leads us to suspect that we should include a quadratic term when we fit a regression model, as such:

tex*/
qui gen english2 = english*english
texdoc stlog, cmdstrip
regress gpa english english2
texdoc stlog close
/*tex

From the output, we see that both english and the square of english are significant. 

The third continuous independent variable is income, which records the family yearly income. We basically want to see if children from rich families do better academically, or if children from poorer fanilies do 
better. The scatter plot is shown in Figure ~\ref{fig:caselinearscatter4}. We very clearly see that the relationship is not linear. In fact, the graph is shaped like an inverted-U. It seems that the highest GPAs are obtained
by students from middle income families. Children from very poor families and from rish families do not do as well as children from middle income families.

tex*/
texdoc stlog, cmdstrip nooutput
scatter gpa income, mcolor(green) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Scatter plot of GPA and income.) label(fig:caselinearscatter4) figure(h) optargs(width=0.7\textwidth)
/*tex

Given that the relationship between GPA and income is not linear, we fit a regression model that contains both the original income variable as well as the squared value:

tex*/
qui gen income2 = income*income
texdoc stlog, cmdstrip
regress gpa income income2
texdoc stlog close
/*tex

Once again we see that both variables are significant. 

The conclusion so far is that the variables attedance, english, and income are significant predictors of GPA. However, while attendance should be included as a linear term, our results indicate that we need to account
for non-linearity when including english and income.

There are still two more continuous variables and they are credits and siblings. We start with credits. We want to see whether students who have completed a higher number of courses have a higher GPA. Universities 
expect that students become better with time. The scatter plot is shown in Figure ~\ref{fig:caselinearscatter5}. 

tex*/
texdoc stlog, cmdstrip nooutput
scatter gpa credits, mcolor(green) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Scatter plot of GPA and credits.) label(fig:caselinearscatter5) figure(h) optargs(width=0.7\textwidth)
/*tex

The scatter plot does not really indicate that there is a relationship. Nonetheless, we fit a simple regression model:

tex*/
texdoc stlog, cmdstrip
regress gpa credits
texdoc stlog close
/*tex

The output of the model indicates that the variable credits is not significant. In fact, it is highly insignificant, given that the p-value is greater than 0.9. Therefore, we conclude that this variable does not contribute
to our understanding of how GPA varies from student to student.

We next turn our attention to the last continuous variable, which is siblings. It would be interesting to see if the larger the number of children at home the lower the GPA, since this would mean that parents will have to 
divide their resources, in terms of money and time, amongst their various children. The scatter plot is shown in Figure ~\ref{fig:caselinearscatter6}. 

tex*/
texdoc stlog, cmdstrip nooutput
scatter gpa siblings, mcolor(green) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Scatter plot of GPA and siblings.) label(fig:caselinearscatter6) figure(h) optargs(width=0.7\textwidth)
/*tex

This scatter plot stands out from the previous ones. The reason is that the independent variable siblings, in our dataset, takes on only 6 variables. The smallest value is takes is zero and the larges value it takes is five.
This is why we see that the points tend to be divided along six vertical lines. The graph is not really a nice one, although we can see that, in general, there is a tendancy for GPA to decrease as we move from the left to 
the right. In such cases, it would be useful to produce a "smooth" graph. One of the most used techniques is to produce a loess curve. Such a curve is shown in Figure ~\ref{fig:caselinearscatter7}. We see that the smoothed
plot is decreasing as the variable siblings increases.  

tex*/
texdoc stlog, cmdstrip nooutput
twoway (scatter gpa siblings, mcolor(green)) (lowess gpa siblings, color(orange)), legend(label(1 "scatter plot") label(2 "Smoothed curve")) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Scatter plot of GPA and siblings.) label(fig:caselinearscatter7) figure(h) optargs(width=0.7\textwidth)
/*tex

We now include the variable singlings in a simple regression model:

tex*/
texdoc stlog, cmdstrip
regress gpa siblings
texdoc stlog close
/*tex

Looking at the output, we see that the coefficient is both negative and significant. Therefore, it seems that the larger the number of siblings, the lower the GPA.
\subsection{Binary Variables}
We now turn our attention towards the binary variables. Our dataset contains two binary variables, and they are college and gender. We start by looking at college. Unlike continuous variables, we do not use graphs in order
to investigate the relationship when the independent variable is binary (there are some curves that allow for a comparison but I personally do not find any utility in using them before fitting a regression model). We therefore
fit a simple linear regression model where we include the variable college:

tex*/
texdoc stlog, cmdstrip
regress gpa i.college
texdoc stlog close
/*tex 

Looking at the output we see that the coefficient is positive and significant. We also notice in the output that the label "Engineering" is included and not business. This is because the base group is engineering (in the dataset
the value zero is assigned to business). Therefore, the coefficient 1.47 is comparing engineering students to business students. What we see is that, on average, engineering students have a GPA that is 1.47 points higher than
business students.

We next fit a regression model where we include gender:

tex*/
texdoc stlog, cmdstrip
regress gpa i.gender
texdoc stlog close
/*tex 

From the output, we see that, ob average, female students have a GPA that is 2.81 points higher than their male colleagues. The result is significant.
\subsection{Categorical Variables (more than two groups)}
The dataset that we are using also contains the variable work. Unlike binary variables, this variable divides the observations into three groups: those that have a full time job, those that have a part time job, and those 
that have no job at all. Once again, we include the variable in a regression model:

tex*/
texdoc stlog, cmdstrip
regress gpa i.work
texdoc stlog close
/*tex

We see that the output shows the groups "Part time" and "Full time". This means that the referent group is the one that contains the students who do not work. Looking at the coefficients, we see that, on average, students 
who work on a part time basis have a GPA that is 4.98 points higher than students who do not work at all. We also see that, on average, students who have a full time job have a GPA that is -2.62 points lower than students
who do not work at all. This means that student who do not work do better than students who have a full time job, and students who have a part time job do better than students who do not work. Both coefficients are
significant. 
\section{Multiple Regression}
From the previous section, it seems that we need a model that includes the variables attendance, english, the square of english, income, the square of income, siblings, college, gender, and work. We can now fit a 
multiple regression model that includes all of these variables:

tex*/
texdoc stlog, cmdstrip
regress gpa attendance english english2 income income2 siblings i.college i.gender i.work
texdoc stlog close
/*tex

If you look at the output, you will notice something interesting, and that is that the variable gender is no longer significant. This is a very important point. You will see that a variable that was signififant wne it was 
included by itself turns out to be not significant when included with other variables. Why is this the case? In our case, we saw that gender was significant by itself and now it is no longer significant. In out dataset, the 
average GPA for males is 78.76 and the average GPA for females is 81.57. So why did it turn out to be insignificant in the mutiple regression model? Digging deeper into the dataset would uncover that the average attendance
grade for males is 78.62 and that the average attendance grade for females is 83.29. Therefore, it seems that the difference in GPAs between males and females is due to females attending more. When we included gender
by itself in a simple model, the regression results told us that females do better. When we included the same variable in another model that also included attendance, the result turned out that the difference in GPAs between
males and females can be explained by their different attendance records. Therefore, the variable gender is no longer contributing to the model. 

Given the above, we can go ahead and fit a model that does not include gender:

tex*/
texdoc stlog, cmdstrip
regress gpa attendance english english2 income income2 siblings i.college i.work
texdoc stlog close
/*tex 

We now see that all variables are significant.
\section{Model Fit}
\subsection{R-squared}
It is now time to assess the goodness of fit of our model. The first piece of information is actually included in the regression output above. We see that the value of R-squared is 0.88, which is high. This means that the model
is explaining around 88% of the observed variability in the dependent variable. 
\subsection{Plotting predicted values against observed values}
We can also visualise the goodness of fit by producing a figure that plots the observed values against the predicted values. If the model is a well fit model, we would expect to see that the predicted values are very close
to the observed values. Figure ~\ref{fig:caselinearfit1} shows this plot. If the model was a good fit, then we would expect that the dots would lie on the diagonal line, which represents y = x. We see that the tendancy for the
points to be very close to the diagonal line, thereby illustrating that the model seems to be doing a good job.  

tex*/
qui predict gpa_predicted
qui label variable gpa_predicted "Predicted GPAs"
texdoc stlog, cmdstrip nooutput
twoway (scatter gpa_predicted gpa, mcolor(green)) (line gpa gpa, color(orange)), legend(label(1 "scatter plot") label(2 "diagonal line")) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Comparing predicted values to observed values.) label(fig:caselinearfit1) figure(h) optargs(width=0.7\textwidth)
/*tex 

\section{Assumptions}
As was discussed in the theory section, regression models make some assumptions, and it is important that we test whether these assumptions are met or not. 
\subsection{Normality of the Residuals}
The first assumption is that the residuals are normal. Figure ~\ref{fig:caselinearnormality1} shows a histogram of the residuals. The histogram is overlayed with a normal curve in order to help us compare the two distributions.
We can see that the residuals appear to be normal.  

tex*/
qui predict residuals
qui label variable residuals "Residuals"
texdoc stlog, cmdstrip nooutput
histogram residuals, normal fcolor(green) lcolor(white) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Comparing predicted values to observed values.) label(fig:caselinearnormality1) figure(h) optargs(width=0.7\textwidth)
/*tex

Another graphical way to test the assumption of normality is to produce a quantil-normal plot of the resilduals. This plot compares the distribution of the residuals with a normal distribtion. 
Figure ~\ref{fig:caselinearnormality2} shows the plot. Since most of the dots are on the line, the plot supports the finding that the residuals are normal.  

tex*/
texdoc stlog, cmdstrip nooutput
qnorm residuals, mcolor(green) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Comparing predicted values to observed values.) label(fig:caselinearnormality2) figure(h) optargs(width=0.7\textwidth)
/*tex

We can also use non-graphical tests to test the asusmption of normality. One way to do this is to use the skewness-kurtosis test:

tex*/
texdoc stlog, cmdstrip
sktest residuals
texdoc stlog close
/*tex 

We see that the p-value is 0.0396, which is less than 0.05. This means that the null hypothesis, which is that the resilduals are normal, is rejected. What this means is that we cannot safetly conclude that the residuals
are normal. 

Another test is the Shapiro-Wilk test:

tex*/
texdoc stlog, cmdstrip
swilk residuals
texdoc stlog close
/*tex 

Once again, we see that the p-value produced by this test is less than 0.05, thereby leading us to reject the null hypothesis that the resilduals are normal. 

These results indicate that we have a problem, since the assumption of linearity is not met, despite the fact that the model seems to be a well fit model. We will get back to this once we test the other assumptions.
\subsection{Homoscedasticity}
Another assumption is that the residuals have a constant variance. In order to test this assumption, we can use the Breusch-Pagan test:

tex*/
texdoc stlog, cmdstrip
estat hettest
texdoc stlog close
/*tex

Since the p-value is less than 0.05, we reject the null hypothesis that the residuals are homoscedastic. Again, this result is problematic to us.
\subsection{Addressing Assumption Violations}
Given that we have rejected the assumptions of normality and homoscedasticity, does this mean that we disregard our regression resukts? Fortunately no. As mentioned in the theory part, what we can do in this case is to fit
the model while telling the statistical software to use robust standard errors. This way, the assumptions are relaxed and we can have more faith in the resulting model:

tex*/
texdoc stlog, cmdstrip
regress gpa attendance english english2 income income2 siblings i.college i.work, vce(robust)
texdoc stlog close
/*tex

The output of the model wshows that all varibales retain their significance. Therefore, it is safe to continue using our model while specifying the robust option.
\subsection{Multicollinearity}
The final assumption that we will test is that of multicollinearity. This is a very important assumoption which states that no independent variable is a function of one or more other variables. This basically means
that the independent variables should not be correlated with one another or with a combination of variables. To test this assumption, we can produce the VIF statistics:

tex*/
texdoc stlog, cmdstrip
vif
texdoc stlog close
/*tex

As mentioned in the theory part, values that are greater than 10 are problematic. In our case, we see that english, english2, income, and income2 have values that are greater than 10. However, this is not a problem 
because we know that english2 is the square of english and income2 is the square of income. It is therefore expected that these variables be correlated with one another. What we care about is that the vif for 
other variables, the ones that do not include a quadratic term, are less than 10, and this is indeed the case. Therefore, this result indicates that multicollinearity is not an issue in our model.
\section{Diagnostics}
The next step is to investigate whether there are outliers and influential observations in the dataset.
\subsection{Outliers}
In order to identify whether there are outliers, we can plot a scatter plot of two variables. Any observation that is located away from most of the points is considered to be an outlier. The problem is that this method
works when we just have one independent variable. We can easily plot a scatter plot of the dependent variable vs the independent variable. However, in our model, there are several independent variables. Fortunately, there is
a tool that allows us to work around this problem, and this tool is the added-variable plot. What these plots do is that they produce a scatter plot of the dependent variable against each independent variable while accounting
for the presence of the other independent variables. The main thing to understand is that if we have six independent variables, we produce six added variable plots, one for each independent variable.

In our case, there are eight independent variables. However, two of them (the quadratic terms) are just the square of two other terms. If an observation is an outlier with regards to the variable income for example, it will
also be an outlier with regards to the square of income. Therefore, there is no need to look at the added value plots of the quadratic terms. This means that we need to look at six added variable plots. The plots are
displayed in Figure ~\ref{fig:caselinearoutlier}. What we want to look for are points that stray away from the rest. 

tex*/
qui avplot attendance, mcolor(green) msymbol(Oh) msize(small) ytitle("") graphregion(color(white)) name(avplot1)
qui avplot english, mcolor(green) msymbol(Oh) msize(small) ytitle("") graphregion(color(white)) name(avplot2)
qui avplot income, mcolor(green) msymbol(Oh) msize(small) ytitle("") graphregion(color(white)) name(avplot3)
qui avplot siblings, mcolor(green) msymbol(Oh) msize(small) ytitle("") graphregion(color(white)) name(avplot4)
qui avplot college, mcolor(green) msymbol(Oh) msize(small) ytitle("") graphregion(color(white)) name(avplot5)
qui avplot work, mcolor(green) msymbol(Oh) msize(small) ytitle("") graphregion(color(white)) name(avplot6)
texdoc stlog, cmdstrip nooutput
graph combine avplot1 avplot2 avplot3 avplot4 avplot5 avplot6, graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Added variable plots for each independent variable.) label(fig:caselinearoutlier) figure(h) optargs(width=0.7\textwidth)
/*tex

Looking at Figure ~\ref{fig:caselinearoutlier}, it doesnt seem that there are significant outliers in the case of the variables attendance, english, siblings, college, and work. With regards to income, we see that seems 
to be some outliers. Specifically, there is a point on the left side of the plot that seems to be floating alone. In addition, on the right hand side there are two dots on the very top and soem few other dots at the bottom.
However, I do not see any reason to worry because the general result is that there are no significant outliers despite the fact that there are is a relatively large number of observations. 
\subsection{Influential Observations}
We next investigate whether there are any particularly influential observations in our dataset. As discussed in the theory part, we can do this by calculating the DFBETAS, DFFITS, and Cook's D statistic. A useful exercise
would be to plot the DFFITS and Cook's D on the same plot. This would help us identify whether there are points with high values of both of these statistics. This graph is shown in Figure ~\ref{fig:caselinearinfluence1}. 

tex*/
qui regress gpa attendance english english2 income income2 siblings i.college i.work
qui dfbeta
qui predict dfits if e(sample), dfits
qui predict cook, cooksd
texdoc stlog, cmdstrip nooutput
scatter dfits cook, mcolor(green) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Plotting DFFITS and Cook's D.) label(fig:caselinearinfluence1) figure(h) optargs(width=0.7\textwidth)
/*tex

Looking at the figure, we see that there is a single point that seems to be problematic since it has a higher than average values of both statistics. We note that this data point is the only one that has a Cook's D that
is greater than 0.08. 

When discussing the outliers, we noted that there seems to be some outliers with respect to the independent variable income (Figure ~\ref{fig:caselinearoutlier}). It would be interesting to look at this graph again, but this
time while we are paying attention to the value of Cook's D. 

tex*/
texdoc stlog, cmdstrip nooutput
avplot income, mcolor(green) msymbol(Oh) msize(small) ytitle("") graphregion(color(white)) mlabel(cook)
texdoc stlog close
texdoc graph, caption(Added variable plot with Cook's D used as labels.) label(fig:caselinearinfluence2) figure(h) optargs(width=0.7\textwidth) 
/*tex

Take a look at Figure ~\ref{fig:caselinearinfluence2}. This figure is the added variable plot of the variable income, except that we have labelled each dot
with the value of Cook's D. We now see that the outlier on the left hand side is actually the point that also has a Cook's D that is greater than 0.08. This means that this point is not only an outlier, but it is also 
influential. What do we do with it? The best thing to do about these points is to fit two models, one that includes all observations, and one that excludes these problematic observations. We can then compare the results.
If there is no difference, then we conclude that the points are not causing any problems. If, however, there are significant differences between the two models, then we might consider eliminating these points all together.

Table ~\ref{table:linearcompareinfluence} shows the results of this comparison. We see that the results do not change significantly. The level of significance of the variables is still the same, and the signs of the
coefficients is also still the same. Therefore, we conclude that we do not have a problem with this particular point.

tex*/
qui preserve
qui label variable income "Family income per year - U.S. dollars"
texdoc stlog, cmdstrip nooutput
qui regress gpa attendance english english2 income income2 siblings i.college i.work, vce(robust)
qui estimates store model1
qui regress gpa attendance english english2 income income2 siblings i.college i.work if cook < 0.08, vce(robust)
qui estimates store model2
esttab model1 model2 using linearcompareinfluence.tex, replace not label nomtitles title(Comparing estimates of both models\label{table:linearcompareinfluence})
texdoc stlog close
texdoc write \input{linearcompareinfluence.tex}
qui restore
/*tex

\section{Visualizing the Result}
The regression output is useful because it allows us to quantify the relationship between the dependent variable and the independent variables. However, graphs are a more intuitive tool to use when trying to understand things.
This is why an extremely useful thing to do after you have fit a regression model is produce graphs that visualise the results. The logic is simple. We need to plot the value of the dependent variable for various values
of the independent variables.

tex*/
qui regress gpa attendance english c.english#c.english income c.income#c.income siblings i.college i.work, vce(robust) 
qui margins, at(attendance=(60(1)100) college=(0 1))
texdoc stlog, cmdstrip nooutput
marginsplot, noci graphregion(color(white)) ytitle(Predicted GPA) title("")
texdoc stlog close
texdoc graph, caption(Visualizing how GPA varies with varying levels of the variables attendance and college.) label(fig:linearvisual1) figure(h) optargs(width=0.7\textwidth) 
/*tex 

As an example, consider Figure ~\ref{fig:linearvisual1}. This figure shows, according to our model, how the predicted GPA of both business and engineering students changes with attendance. The graph gives us two pieces of
information. First, engineering students in general have a slightly higher GPA. Second, the higher the level of ettendance, the higher the GPA.

Let us now look at Figure ~\ref{fig:linearvisual2}. This figure shows how the predicted GPA changes as the grade on English changes for students who do nto work, who have a full time job, and those that have a part time
job. We see that unlike in the case of attendance, the relationship is not linear. We also see that students who work part time, on average, have a higher GPA, and that those who work full time have the lowest GPA. 

tex*/
qui margins, at(english=(60(1)100) work=(0 1 2))
texdoc stlog, cmdstrip nooutput
marginsplot, noci graphregion(color(white)) ytitle(Predicted GPA) title("")
texdoc stlog close
texdoc graph, caption(Visualizing how GPA varies with varying levels of the variables english and work.) label(fig:linearvisual2) figure(h) optargs(width=0.7\textwidth) 
/*tex

Finally, consider Figure ~\ref{fig:linearvisual3}. This figure shows us how there is a constant decrease in GPA as the number of siblings increases.

As you can see from this section, looking at graphs makes understand models much easier, especially if you want to present your results to audience members who do not have a background in regression.

tex*/
qui margins, at(siblings=(0(1)5))
texdoc stlog, cmdstrip nooutput
marginsplot, noci graphregion(color(white)) ytitle(Predicted GPA) title("")
texdoc stlog close
texdoc graph, caption(Visualizing how GPA varies with varying numbers of siblings.) label(fig:linearvisual3) figure(h) optargs(width=0.7\textwidth) 
/*tex
 
\chapter{Logistic Regression - The Theory}
\section{Contingency Tables}
\subsection{Two-by-Two Tables}
When the outcome that we are interested in can take on one of two values, the variable is referred to as a binary variable. As an example, consider the data shown in Table ~\ref{table:logfirst}. The table shows the records for 31 
students, where the first column indicates whether the student has withdraw from or completed a certain course, while the second column shows the major of the student. In this case, the outcome of interest is 
whether the student completed the course or whether he/she withdrew from the course. These are the only two possible outcomes. Hence, the variable is binary. The other variable is also binary since it also has two 
possible values: engineering and business. 
\begin{longtable}[c]{ c c }
	\caption{Records of students.\label{table:logfirst}}\\
		\hline
		\bf Outcome & \bf College \\
		\hline
		Withdraw & Engineering \\
		Withdraw & Engineering \\
		Finish & Business \\
		Finish & Business \\
		Finish & Business \\
		Finish & Engineering \\
		Finish & Engineering \\
		Finish & Engineering \\
		Withdraw & Engineering \\
		Finish & Business \\
		Withdraw & Engineering \\
		Finish & Business \\
		Withdraw & Engineering \\
		Withdraw & Engineering \\
		Finish & Business \\
		Finish & Business \\
		Withdraw & Business \\
		Withdraw & Business \\
		Withdraw & Business \\
		Finish & Business \\
		Finish & Engineering \\
		Withdraw & Engineering \\
		Finish & Business \\
		Finish & Business \\
		Finish & Engineering \\
		Withdraw & Business \\
		Withdraw & Engineering \\
		Withdraw & Engineering \\
		Finish & Engineering \\
		Finish & Business \\
		Finish & Business \\
	\hline
\end{longtable}
The question that we would like to ask is whether students from both colleges are equally likely to withdraw from the course. To find the answer, we create a two-by-two table. 
The table is shown in Table ~\ref{table:countfirst}. This table sums up the results. We see that there is a total of 16 business students, four of whom withdrew from the course. We also see that there is a total of 15 engineering students, 
nine of whom withdrew from the course. This means that a proportion of 4/16 = 0.25 of business students withdrew from the course, compared to a proportion of 9/15 = 0.6 of engineering students. If an engineering student 
enrolls in the course, we calculate that the probability that he or she will withdraw from the course is 0.6. If a business student enrolled in the course, we calculate that the probability that he or she will withdraw 
from the course is 0.25. Therefore, we see that engineering students are more likely to withdraw from the course than business students.
\begin{table}[h!t]
	\caption{Cross classification of college and outcome.} \label{table:countfirst}
	\centering
	\begin{tabular}{c |c c| c}
	\hline
	{} & \multicolumn{2}{|c|}{Outcome} & {} \\
	\hline
	\bf College & \bf Withdraw & \bf Finish & \bf Total \\
	Business & 4 & 12 & 16 \\
	Engineering & 9 & 6 & 15 \\
	\hline
	\end{tabular}
\end{table}
\subsection{The Odds Ratio}
In order to better compare the two groups, we can use the concept of \textbf{odds ratios}. To do that, we need to calculate the odds that a student will withdraw from the course. This can be done using the equation:

$$ odds=\frac{Probability\, of\, withdrawal}{1-(probability\, of\, withdrawal)} $$

The odds of withdrawal for an engineering student is 0.6/(1-0.6) = 1.5. The odds of withdrawal for a business student is 0.25/(1-0.25) = 0.33. 

The odds are never negative. They are zero or greater than zero. When the odds are equal to one, this means that the probability of both outcomes are equal (0.5/(1-0.5) = 1). In the case of engineering students, 
since the odds of withdrawal are 1.5, this means that the probability of withdrawal is 1.5 times the probability of finishing the course. For business students, the probability of withdrawal is 0.33 times the 
probability of finishing the course.

Now that we have the odds for each row in Table ~\ref{table:countfirst}, we can calculate the odds ratio:

$$ odds\, ratio = \frac{odds_{engineering}}{odds_{business}}=\frac{1.5}{0.33}=4.5 $$

Since the odds cannot be negative, the odds ratio cannot be negative as well. When the odds of an event are equal in both rows (Table ~\ref{table:countfirst}), the odds ratio will be equal to one. When the odds of the numerator is greater 
than the odds of the denominator, the odds ratio will be greater than one. This means that the probability of the event is higher in the row that is associated with the numerator. In our case, the odds ratio is 4.5, 
which is larger than one. This means that the probability of the event, which is withdrawal in our case, is higher in the numerator, which is engineering students in our case. This means that engineering students are more likely to withdraw 
from the course than business students. If, on the other hand, the odds ratio is less than one, then this means that the probability of the event in the denominator are higher.

As you can see, the odds ratio allows us to compare the incidence of an event between groups. If the event is equally probable in both groups, then the odds ratio will be one. In such a case, we say that 
the event (withdrawal in our case) and the group (college in our case) are independent. This means that withdrawal does not depend on college.
\subsection{Two-by-Three Tables}
The above logic remains intact when instead of a binary variable such as college, we have a variable that divides students into the groups sophomore, junior, and senior. In this case, the outcome variable is binary, 
but the other variable is not, since it divides the students into more than two groups.

As an example, consider the data shown in Table ~\ref{table:countcatmore}. The odds of withdrawal for sophomores, junior, and senior students are:

$$ odds_{sophomore}=\frac{12/32}{1-\frac{12}{32}}=0.6 $$

$$ odds_{junior}=\frac{6/36}{1-\frac{6}{36}}=0.2 $$

$$ odds_{senior}=\frac{5/30}{1-\frac{5}{30}}=0.2 $$

Since the odds for all groups are less than one, then the probability of course withdrawal is less than the probability of finishing the course in each of them. We can also compute the odds ratios in order to compare 
the odds of each group:

$$ \frac{odds_{sophomore}}{odds_{junior}}=\frac{0.6}{0.2}=3 $$

$$ \frac{odds_{sophomore}}{odds_{senior}}=\frac{0.6}{0.2}=3 $$

$$ \frac{odds_{junior}}{odds_{senior}}=\frac{0.2}{0.2}=1 $$

The results indicate that the probability of withdrawal are highest in sophomore students.
\begin{table}[h!t]
	\caption{Cross classification of standing and outcome.} \label{table:countcatmore}
	\centering
	\begin{tabular}{c |c c| c}
	\hline
	{} & \multicolumn{2}{|c|}{Outcome} & {} \\
	\hline
	\bf Standing & \bf Withdraw & \bf Finish & \bf Total \\
	Sophomore & 12 & 20 & 32 \\
	Junior & 6 & 30 & 36 \\
	Senior & 5 & 25 & 30 \\
	\hline
	\end{tabular}
\end{table}
The above exercise is useful when we want to compare the probabilities of an event across certain groups. We saw that the probability of withdrawal is affected by the major of the student. 
In the second example, we saw that the probability of withdrawal was affected by whether the student was a sophomore, junior, or senior.

This type of analysis however will not take us very far. The reason is that usually, we are interested in studying the effect that several variables have on the outcome. What if we wanted to see 
whether the withdrawal rate was affected by the major, standing, and GPA, all at the same time? In this case, we need to use the statistical technique of logistic regression. 
\section{Logistic Regression}
We will start by considering the simplest case in which there is a single independent variable. In linear regression, the model is represented by the linear equation:

$$ y=ax+b $$

In the above equation, y is the dependent variable, x is the independent variable, a is the slope, and b is the y-intercept. One of the nice things about linear regression is how easy it is to interpret 
the relationship between the dependent variable and the independent variable. As an example, assume that we have the following linear equation:

$$y=3x+2$$

If x is equal to 2, y will be equal to 8, and if x is equal to 3, y will be equal to 11. Note that for every one unit increase in x, the value of y increases by 3, which is the value of the slope. 
This is the definition of the slope. It is the amount by which the dependent variable changes when the independent variable increases by one. The slope is important for two reasons. The first reason 
relates to the sign. If the slope is positive, then any increase in the independent variable will lead to an increase in the dependent variable. The more I eat, the heavier I get. If the slope is negative, 
then an increase in the independent variable will lead to a decrease in the dependent variable. The more I buy food, the less money I have.

The second reason relates to the magnitude of the slope. The larger the magnitude of the slope, the greater the effect that the independent variable has on the dependent variable. If the slope is 2, then a one unit 
increase in the independent variable will result in an increase of 2 in the dependent variable. If, however, the slope is 10, then a one unit increase in the independent variable will result in an increase of 10 
in the dependent variable. So the sign of the slope tells us about the direction of the relation and the magnitude tells us about the magnitude of the effect that one variable might have on the other.

Unfortunately, in logistic regression things are not that simple. The reason is that the logistic regression model has the following form:

$$ \log(\frac{p}{1-p})=ax+b $$

In the above equation, p is the probability that the event will happen. As we can see, instead of the left hand side of the equation being the dependent variable, what we have is a strange function that is the log 
of the odds. This function is called the logit function, hence the name logistic regression. This means that the interpretation of the slope a is that when x increases by one unit, the log of the odds increases by one. 
This doesn’t make much sense. Fortunately, there is something that we can do to make the interpretation more intuitive. All we need to do is to take the exponential of both sides:

$$ e^{\log(\frac{p}{1-p})}=e^{ax+b} $$

$$ \frac{p}{1-p}=e^{ax+b} $$

There is nothing complicated in what we did. We know from algebra that an equality is maintained when we perform the same operation to both sides. In our case, we first took the exponent of both sides. 
We then took advantage of the rule $e^{\log(k)}=k$.

Why is the new form of the equation better? Because now instead of the log of the odds we have the odds on the left hand side of the equation. Therefore, if the slope a is positive, when x increases the 
term $e^{ax+b}$ will increase. Since this term is equal to the odds, this means that the odds will increase. This means that when a is positive, the odds that the event will happen will increase with increasing 
values of x. On the other hand, when a is negative, when x increases the odds will decrease. 

Let us take an example. Assume that we perform logistic regression where the dependent variable is whether a student withdraws from a course or not and the independent variable is the number of courses that 
the student is currently taking. Assume that once we fit this model we get the following equation:

$$ \log(\frac{p}{1-p})=2.21(number\, of\, courses)-11.25 $$

What this means is that when the number of courses that a student is currently taking increases by one, the logit function increases by 2.21. Since, as we said, this is hard to understand, let’s consider the 
more intuitive form:

$$ \frac{p}{1-p}=e^{2.21(number\, of\, courses)-11.25} $$

Now consider two students, one currently taking four courses, and the other currently taking five courses. According to our model, the odds that each will withdraw from a course is:

Student taking four courses: $ \frac{p}{1-p}=e^{2.21(4)-11.25}=0.0898 $

Student taking five courses: $ \frac{p}{1-p}=e^{2.21(5)-11.25}=0.8187 $

This means that the odds that a student taking four courses withdraws from a course is 0.0898, while the odds that a student taking five courses withdraws from a course is 0.8187. 
This means that the student taking five courses is more likely to withdraw. How much more likely? In order to compare, we need to calculate the odds ratio:

$$ odds\, ratio = \frac{odds_{five\, courses}}{odds_{four\, courses}}=\frac{0.8187}{0.0898}=9.12 $$

What this means is that a student who is taking one more course than another student has 9.12 times greater odds of withdrawing from a course. The great news is that 9.12 is actually $e^{2.21}$. 
We now have a very intuitive meaning for the slope a. When we fit a logistic regression model and obtain a value for the coefficient associated with an independent variable, we know that when the 
independent variable x increases by one unit, the odds of the event happening is multiplied by $e^a$. When a is positive, $e^a>1$, which means that the odds increase when x increases. When a is negative, 
$e^a<1$, which means that the odds decrease when x increases.

Although the above might seem complicated, it is actually very easy. As a recap, when we fit a logistic model, we are finding a line with the equation ax + b, just like in linear regression. 
The difference however is in the interpretation of the coefficient of x. In linear regression, when x increases by one unit, the dependent variable increases by the magnitude of a. In logistic 
regression, when x increases by one unit, the odds of an event happening are multiplied by $e^a$. If a is zero we have $e^0=1$, which means that the odds are multiplied by one, so they do not change. 
This means that x does not affect the odds. If a is greater than zero, then $e^a>1$, which means that the odds are multiplied by a number greater than one, so they increase. If a is less than zero, then 
$e^a<1$, which means that the odds are multiplied by a number that is less than one, so they decrease.

To see how simple the above is, assume that we fit a logistic model where the dependent variable is whether an individual has a heart problem or not, and where the independent variable is age. 
Once we fit the model, we get the following result:

$$ \log(\frac{p}{1-p})=1.09(age)-9.68 $$

Here, p is the probability that a person has a heart problem. What does this output mean? Since the value of the coefficient associated with the independent variable, which is age, is 1.09, 
this means that when age increases by one year, the odds of having a heart condition is multiplied by $e^{1.09}=2.97$. This means that a 40-year old individual has 2.97 times greater odds of having a heart condition 
than an individual who is 39-years old. 

As another example, consider that we fit a logistic model where the dependent variable is whether a student goes out at night during the weekdays, and where the independent variable is the student’s grades. 
The output of the model is the following:

$$ \log(\frac{p}{1-p})=-0.24(grades)+17.84 $$ 

Here, the coefficient is negative. Since $e^{-0.24}=0.79$, the output indicates that the odds that a student goes out during the weekdays are multiplied by 0.79 (so they decrease) when grades increase by a single unit. 
This means that students with higher grades are less likely to go out during the weekdays. 

As you can see, when the coefficient is positive, the odds increase, and when the coefficient is negative, the odds decrease. Since we are mostly interested in the exponential of the coefficient, and not the coefficient 
itself, statistical software packages usually display the value $e^a$ instead of displaying the value of a. In that case, when $e^a$ is greater than one, the odds increase, and when $e^a$ is less than one, the odds decrease.
\subsection{Binary Variables}
So far, the independent variable has been numerical in nature. Sometimes however, including variables that are not numeric in nature is necessary. For example, what if we wanted to investigate whether the 
probability of withdrawing from a course could be explained by the gender of the students? Here, the variable gender is not numeric. It is categorical, in that it divides the observations into categories. 
Since biological gender is either male or female, there are two categories in which each student might fall.

In such a case, we can create a binary variable to represent the two categories. A binary number takes on the values of zero or one. We next assign each of these values to a category. 
Let us assign a zero to males and a one to females. The data is shown in Table ~\ref{table:logisticbinary}. Note that the table is similar to Table ~\ref{table:logfirst} except that we have added a new column which is gender.

Now that the variable gender has been quantified, it is possible to include it in a regression model. The result of running a logistic model would be again in the form:

$$ \log(\frac{p}{1-p})=ax+b $$

If we use a statistical software to run the model, we will get the following output:

$$ \log(\frac{p}{1-p})=-1.90(gender)+0.51 $$

\begin{longtable}[c]{ c c c}
	\caption{Records of students.\label{table:logisticbinary}}\\
		\hline
		\bf Outcome & \bf Gender & \bf Binary \\
		\hline
		Withdra & male & 0 \\
		Withdraw & male & 0 \\
		Finish & male & 0 \\
		Finish & female & 1 \\
		Finish & female & 1 \\
		Finish & female & 1 \\
		Finish & female & 1 \\
		Finish & male & 0 \\
		Withdraw & female & 1 \\
		Finish & male & 0 \\
		Withdraw & female & 1 \\
		Finish & male & 0 \\
		Withdraw & male & 0 \\
		Withdraw & male & 0 \\
		Finish & female & 1 \\
		Finish & female & 1 \\
		Withdraw & female & 1 \\
		Withdraw & male & 0 \\
		Withdraw & male & 0 \\
		Finish & female & 1 \\
		Finish & male & 0 \\
		Withdraw & male & 0 \\
		Finish & female & 1 \\
		Finish & female & 1 \\
		Finish & male & 0 \\
		Withdraw & male & 0 \\
		Withdraw & male & 0 \\
		Withdraw & male & 0 \\
		Finish & female & 1 \\
		Finish & female & 1 \\
		Finish & female & 1 \\
	\hline
\end{longtable}
We already know how to interpret the coefficients of continuous variables, such as age and grades. However, what does it mean that the coefficient of gender is -1.90? Remember 
that for males the value of gender is zero, while for females the value of gender is one. In order to calculate the odds for a male and a female student, we need to use the form:

$$ \frac{p}{1-p}=e^{ax+b}=e^{-1.90(gender)+0.51} $$

We can now calculate the odds for each student:

Male: $ \frac{p}{1-p}=e^{-1.90(0)+0.51}=1.67 $
Female: $ \frac{p}{1-p}=e^{-1.90(1)+0.51}=0.25 $

From these odds, we can calculate the odds ratio:

$$ Odds\, ratio = \frac{odds_{female}}{odds_{male}}=\frac{0.25}{1.67}=0.15 $$

This means that males have higher odds to withdraw than females. The nice thing is that the number 0.15 happens to be $e^{-1.90}$. This means that when we are dealing with binary variables, 
the exponent of the coefficient is the odds ratio when we compare an individual who belongs to the group that is assigned a value of one and an individual who belongs to the group that is 
assigned the value zero. In our case, since males were assigned a value of zero, the exponent of the coefficient is the odds ratio that we obtain when we divide the odds of a female by the 
odds of males. In other words, since the coefficient is -1.90, the odds for females is 0.15 times the odds for males.

If you recall, we had actually calculated the odds ratio for the information shown in Table ~\ref{table:countfirst}, which cross-classifies the variables outcome and engineering. 
When we did this manually, we found that the odds ratio was 4.5. If we run the logistic model, where the value zero is assigned to business and the value one is 
assigned to engineering, we will get the following output:

$$ \log(\frac{p}{1-p})=1.50(college)-1.10 $$

Since $e^{1.5}=4.5$, we conclude that the odds of withdrawal for engineering students are 4.5 times the odds of withdrawal for business students. 

Let us take another example. Assume that we run a logistic regression model where the dependent variable is whether a visitor to our website subscribes to our services or not, 
and where the independent variable is whether the user accessed our website using a mobile device or using a desktop computer. The independent variable is binary, so we need to 
assign zero to a category and a one to the other category. In our case, let’s say that we chose to assign a zero to users using a mobile device and a one to users using a desktop 
computer. We fit the model and get the following result:

$$ \log(\frac{p}{1-p})=1.26(device\, type)-1.01 $$

This means that users who use a desktop computer have $e^{1.26}=3.53$ times the odds of subscribing than users who use a mobile device. Since we are again mostly concerned with the exponent 
of the coefficient, statistical software packages tend to display the odds ratio directly, instead of displaying the value of the coefficient in the output.
\subsection{Multiple Independent Variables} 
Now that we have seen how to interpret the output from logistic regression when there is a single independent variable, let us see what changes when there are two independent variables. 
Table ~\ref{table:multiple} shows the records for students. The table includes the dependent variable outcome and the independent variables college and courses. Therefore, we have one binary variable and one continuous variable.
In this case, we want to see if the dependent variable, which is withdrawing from a course, depends on the college of the student and on the number of courses. 

The equation of this model is:

$$ \log(\frac{p}{1-p})=a_1x_1+a_2x_2+b $$

Each independent variable has its own coefficient now. If we run the model, the output will be:

$$ \log(\frac{p}{1-p})=-0.02(college)+2.22(courses)-11.27 $$

 \begin{longtable}[c]{ c c c}
	\caption{The case of two independent variables.\label{table:multiple}}\\
		\hline
		\bf Outcome & \bf College & \bf Courses\\
		\hline
		Withdraw & Engineering & 6 \\
		Withdraw & Engineering & 6 \\
		Finish & Business & 4 \\
		Finish & Business & 6 \\
		Finish & Business & 4 \\
		Finish & Engineering & 3 \\
		Finish & Engineering & 5 \\
		Finish & Engineering & 6 \\
		Withdraw & Engineering & 6 \\
		Finish & Business & 4 \\
		Withdraw & Engineering & 5 \\
		Finish & Business & 4 \\
		Withdraw & Engineering & 6 \\
		Withdraw & Engineering & 5 \\
		Finish & Business & 4 \\
		Finish & Business & 4 \\
		Withdraw & Business & 5 \\
		Withdraw & Business & 6 \\
		Withdraw & Business & 5 \\
		Finish & Business & 4 \\
		Finish & Engineering & 5 \\
		Withdraw & Engineering & 6 \\
		Finish & Business & 4 \\
		Finish & Business & 4 \\
		Finish & Engineering & 5 \\
		Withdraw & Business & 5 \\
		Withdraw & Engineering & 6 \\
		Withdraw & Engineering & 5 \\
		Finish & Engineering & 4 \\
		Finish & Business & 3 \\
		Finish & Business & 4 \\
	\hline
\end{longtable}

Let us now calculate the odds for two students where both of them are currently taking five courses, but one is studying business and the other is studying engineering:

Business: $ \frac{p}{1-p}=e^{-0.02(0)+2.22(5)-11.27}=0.84 $
Engineering: $ \frac{p}{1-p}=e^{-0.02(1)+2.22(5)-11.27}=0.83 $

This means that the odds ratio is:

$$ Odds\, ratio = \frac{0.83}{0.84}=0.98 $$

A simpler way to get this value is just to calculate the exponent of the coefficient, $e^{-0.02}=0.98$. This shows that even when there are several independent variables, the coefficients 
retain their meanings. Therefore, to find the difference between two groups of students, just calculate $e^{a_1}$. The implication of this is that in a multiple regression model, where there are 
several independent variables, when we want to investigate the effect that an independent variable has on the dependent variable, we just need to take into consideration the coefficient of the 
independent variable, given that the rest of the variables do not change.

To further illustrate this, let us now calculate the odds for two engineering students, one of whom has three courses and the other has four courses:

Three courses: $ \frac{p}{1-p}=e^{-0.02(1)+2.22(3)-11.27}=0.00975476 $

Four courses: $ \frac{p}{1-p}=e^{-0.02(1)+2.22(4)-11.27}=0.08981529 $ 

This means that the odds ratio is:

$$ Odds\, ratio=\frac{0.08981529}{0.00975476}=9.21 $$

This is also obtained by finding the exponent of the coefficient, $e^{2.22}=9.21$. This same logic applies whether we have three independent variables, four independent variables, or even nine 
independent variables. It also doesn’t matter whether the variables are binary or continuous. The coefficient of each independent variable gives us information about the relationship between 
the independent variable and the dependent variable. All we have to do is to take the exponent of the coefficient in order to calculate the effect that the independent variable has on the odds of the event happening.
\subsection{Categorical Variables with more than Two Categories} 
When we included gender in the equation, we used a binary variable since gender can take on one of two values. What if we had a categorical variable that divided the observations into more than two groups? 
If you recall, Table ~\ref{table:countcatmore} presented a cross-classification of the variables outcome and standing, where students are classified as being in their sophomore year, junior year, or senior year 
(The table is reproduced in Table ~\ref{table:countcatmore2}). In this case, we cannot use a binary variable because there are three groups instead of two. What we can do however, is to use more than one binary 
variable, as shown in Table ~\ref{table:countcatmorecode}.
\begin{table}[h!t]
	\caption{Cross classification of standing and outcome.} \label{table:countcatmore2}
	\centering
	\begin{tabular}{c |c c| c}
	\hline
	{} & \multicolumn{2}{|c|}{Outcome} & {} \\
	\hline
	\bf Standing & \bf Withdraw & \bf Finish & \bf Total \\
	Sophomore & 12 & 20 & 32 \\
	Junior & 6 & 30 & 36 \\
	Senior & 5 & 25 & 30 \\
	\hline
	\end{tabular}
\end{table} 
\begin{table}[h!t]
	\caption{Coding the categorical variable.} \label{table:countcatmorecode}
	\centering
	\begin{tabular}{c c c}
	\hline
	{} & $\mathbf{x_1}$ & $\mathbf{x_2}$ \\
	Sophomore & 0 & 0 \\
	Junior & 1 & 0 \\
	Senior & 0 & 1 \\
	\hline
	\end{tabular}
\end{table}
If you look at the column for the variable $x_1$, you will notice that the variable takes a value of one for junior, and zero otherwise. The other binary variable, $x_2$, 
takes on a value of one for senior and zero otherwise. How did we know that we need three binary variables? The number of binary variables needed is the number of categories minus one. 
In our case, we have three categories, so it is 3 – 1 = 2. The logit equation now becomes: 

$$ \log(\frac{p}{1-p})=a_1x_1+a_2x_2+b $$

For a sophomore student, $x_1$ and $x_2$ are zero. For a junior student, $x_1$ is one and $x_2$ is zero. For a senior student only $x_2$ is one and $x_1$ is zero. If we fit this model to the data, the output will be:

$$ \log(\frac{p}{1-p})=-1.10x_1-1.10x_2-0.51 $$

Let us now calculate the odds for the three types of students:

Sophomore: $ \frac{p}{1-p}=e^{-1.10(0)-1.10(0)-0.51}=0.6 $

Junior: $ \frac{p}{1-p}=e^{-1.10(1)-1.10(0)-0.51}=0.2 $

Senior: $ \frac{p}{1-p}=e^{-1.10(0)-1.10(1)-0.51}=0.2 $

We can now calculate the odds ratios:

$$ \frac{odds_{junior}}{odds_{sophomore}}=\frac{0.2}{0.6}=0.33 $$

$$ \frac{odds_{senior}}{odds_{sophomore}}=\frac{0.2}{0.6}=0.33 $$

We can get the same values by calculating the exponents of the coefficients:

$$ e^{-1.1}=0.33 $$

We see that the exponent of the coefficient for each variable produces the odds ratio when we compare the group associated with the variable to the base group, which is the group that is assigned the 
values of zero. In other words, in our example, sophomore students are the base, or referent, group, since they have a value of zero for both $x_1$ and $x_2$. Junior students have a value of one for $x_1$, which 
means that the exponent of the coefficient of $x_1$ is the odds ratio of junior students to sophomore students. Senior students have a value of one for $x_2$, which means that the exponent of the coefficient of 
$x_2$ is the odds ratio of senior students to sophomore students. Therefore, just like in the case of binary variables, the coefficient compares a group to another group. The only difference here is that there 
is more than one binary variable, where each is associated with a different group. In both cases, the referent group is the same.
\subsection{Nonlinearity}
In linear regression, the relationship between the independent variable and the dependent variable is expected to be linear. If it is not, then we need to account for the linearity by including a power term, 
such as the quadratic term. In the case of linear regression, detecting nonlinearity is easy, since all we have to do is to produce a scatter plot of the dependent variable against the independent variable. 
In the case of logistic regression, the equation is not y = ax + b. Instead, it is:

$$ \log(\frac{p}{1-p})=ax+b $$

This means that the logit function, which is the log of the odds, is linear with respect to the independent variable. When we have a continuous variable as an independent variable, we need to test this assumption of 
linearity. We can perform a graphical test and a non-graphical test.
\subsubsection{Box-Tidwell Test}
The non-graphical way is to use the Box-Tidwell test. As an example, assume that the dependent variable is whether a customer buys from our website or not (buy), and the independent variable is the previous 
number of visits of the customer to our website (visit). To test the assumption of linearity between the logit function and the independent buy using the Box-Tidwell test, we should create a new variable using the 
following formula:

$$ new\, variable=(visit)(\log(visit)) $$

This means that the new variable is the product of the independent variable and the log of the independent variable. After we calculate this new variable, we should fit a new logistic regression model that 
includes both the variable (visit) and the new variable. If the new variable turned out to have a p-value that is less than 0.05, i.e. if the variable was significant, then the assumption of linearity between 
the logit function and the independent variable is violated.
\subsubsection{Graphical Tests}
\paragraph{Lowess}
Although the Box-Tidwell test is very useful, it does not inform us of the shape of the nonlinearity. It only tells us if the relationship is not linear. However, we would also like to know what sort of 
nonlinearity exists. In linear regression, the graphical method is basically a scatter plot. In linear regression, this graph does not inform us about the nonlinearity. To illustrate, let us take the example in 
Figure ~\ref{fig:scatterlinear}.
 
tex*/
qui clear all
qui set obs 1000
qui gen x = runiform(0, 10)
qui gen xb = log(x)
qui gen pr = exp(xb)/(1+exp(xb))
qui gen outcome = 0
qui replace outcome = 1 if pr > 0.5
qui replace outcome = 1 if outcome == 0 & runiform() > 0.95
qui replace outcome = 0 if outcome == 1 & runiform() > 0.95
qui egen xcat = cut(x), group(4)
texdoc stlog, cmdstrip nooutput
scatter outcome x, scheme(lean2) mcolor(green) msymbol(O)
texdoc stlog close
texdoc graph, caption(Scatter plot of a binary outcome and a continuous variable x.) label(fig:scatterlinear) figure(h) optargs(width=0.7\textwidth)
/*tex

The graph looks different from the scatter plots that we are used to. This is because the variable outcome, which is the dependent variable, can only take on two values, either a zero or a one. This is why the dots lie 
along one of two lines, the outcome equal zero line and the outcome equal one line. The graph, however, can be informative, as shown in Figure ~\ref{fig:scatterlowess}, which plots the loess curve of the data. A loess plot is simply a smoothed 
scatter plot. Therefore, it allows us to visualize the relationship when the scatter plot is not very clear. This is an extremely useful graph when the variable on the y-axis is binary. As you can see from Figure 4, the 
curve initially increases with increasing values of the dependent variable x, and then levels of when x reaches a value of four. Therefore, we conclude that the relationship between the logit function and the independent 
variable x is not linear.

tex*/
texdoc stlog, cmdstrip nooutput
lowess outcome x, graphregion(color(white)) mcolor(green) msymbol(O) scheme(lean2) adjust subtitle("")
texdoc stlog close
texdoc graph, caption(Loess graph of a binary outcome and a continuous variable x.) label(fig:scatterlowess) figure(h) optargs(width=0.7\textwidth)
/*tex
\paragraph{Linearity of Slopes} 
Another graphical test is the linearity of the slopes test. The idea behind this test is that the independent variable x is categorized. This means that instead of having a continuous independent variable, we end up 
with a categorical variable. Assume for example that we want to categorize the variable age, where age is between 18 years and 60 years. We create a new variable that takes on the value of zero when age is between 18 and 
30, the value one when age is between 30 and 40, the value two when age is between 40 and 50, and the value three when age is greater than 50 (Table ~\ref{table:categorize}). 
\begin{table}[h!t]
	\caption{Categorizing a continuous variable.} \label{table:categorize}
	\centering
	\begin{tabular}{c c}
	\hline
	\bf Categorized age & \bf Age \\
	\hline 
	0 & 18$\leq$age$<$30 \\
	1 & 30$\leq$age$<$40 \\
	2 & 40$\leq$age$<$50 \\
	3 & 50$\leq$age \\
	\hline
	\end{tabular}
\end{table} 
Once we have our new categorized variable, we can fit a logistic regression with the categorized variable as the independent variable. Therefore, instead of having a continuous variable in the model we now have a categorical 
variable. We have already seen how to interpret the results obtained from including a categorical variable. Once the model is fit, we plot a graph of the predicted value of the logit function and the different levels of 
the categorical variable. Figure ~\ref{fig:linearityofslopes} shows the graph that is produced for the same data that was used to produce Figure ~\ref{fig:scatterlowess}, where the independent variable x has been categorized and named xcat. Since when we fit the logistic 
model we obtained the value of the coefficient for each level, we calculate the value of the logit function for each coefficient. If the relationship between the independent variable and the logit function is linear, 
then the graph should resemble a line. This is clearly not the case. In fact, there is a considerable amount of similarity between Figure ~\ref{fig:scatterlowess} and Figure ~\ref{fig:linearityofslopes}. 

tex*/
texdoc stlog, cmdstrip nooutput
qui logistic outcome i.xcat
qui margins xcat
marginsplot, noci graphregion(color(white)) plotopts(mcolor(green) msymbol(Oh) lcolor(green))
texdoc stlog close
texdoc graph, caption(Linearity of slopes test.) label(fig:linearityofslopes) figure(h) optargs(width=0.7\textwidth)
/*tex
\section{Selection of Independent Variables}
An important issue that we face when we have a number of independent variables is how to decide which variables to add to the model and in what order. There are generally four ways to do this. 
The first three all rely on an algorithm and you are advised not to trust them. This is a very important point. You should never let the computer pick the independent variables. However, the three methods 
will be described since many statistical packages allow the user to use them. In addition, I do not think that there is anything wrong with using them as an investigative tool, i.e. in order to get an idea 
of what independent variables are significant and which are not. The first selection method is referred to as forward selection. As the name suggests, this method adds independent variables one step at a time. 
Originally, we start with no independent variables. The algorithm then adds one of the variables. If the p-value of that variable turns out to be less than 0.05, the variable is kept in the model. The algorithm 
then selects another variable and adds it to the model. These models are repeated until there are no further independent variables left.

The second selection method is referred to as backward elimination. As you can imagine, we start with a model that includes all possible independent variables. The algorithm them selects the least significant 
independent variable (the one with the highest p-value). If the p-value of the selected independent variable is greater than 0.05 (which means that it is not significant) the variable is removed. The algorithm 
then repeats and selects the least significant variables from the ones that are still in the model. These steps are repeated until all variables that are included in the model have p-values that are less than 0.05 
(which means that they are all significant).

The third selection method is referred to as stepwise regression. This method is a combination of the previous two. The model starts in forward mode with no independent variables. The algorithm selects the most 
significant independent variable and adds in to the model. Next, the algorithm goes into backward mode by checking to see whether any variable can be eliminated. Next, the algorithm goes back into forward mode 
and selects a variable from the pool of remaining variables, and then it goes back into backward mode. This process continues until there are no more variables to be added or dropped.

As I said, the above three algorithms should not be used to find the final model. You can, however, initially use them in order to get an initial picture of which independent variables are selected and which are not. 
As an initial step, there is nothing wrong with doing this. Ultimately however, you need to rely on the fourth method to select when and how to add the variables, and that method is to use your knowledge. Any good 
research must be informed by theory. The better you understand the theory, the better you can determine which variables to include and which to ignore. In general, we prefer models in which the number of independent 
variables is as small as possible. In linear regression we can rely on the value of R-squared, or adjusted R-squared, when choosing between two models. Although some statistical packages display a statistic that is 
called pseudo R-squared when you run a logistic model, this statistic does not have the same meaning as R-squared does in linear regression, so you should not pay attention to it. We can, however, rely on the AIC and 
BIC statistics when comparing two models. These statistics can be easily calculated by statistical software. When comparing two models, we tend to favor the one with smaller values of both AIC and BIC statistics.

\section{Prediction}
In linear regression, because the left-hand side of the equation is the dependent variable y, we can easily calculate the predicted value of y and then plot it on the y-axis. In logistic regression however, 
the left hand side is not the dependent variable:

$$ \log(\frac{p}{1-p})=ax+b $$

Once we fit the logistic regression model, we are able to calculate the values of a and b. This means that the equation will have one unknown in it, and this unknown is p, which is the probability that the event 
will happen. Since we have one equation and one unknown, we can find the value of the unknown. This means that using logistic regression we can, for each observation, calculate the probability that the event will occur. 
Once we calculate the predicted probability, we can produce graphs in which the predicted probability is plotted on the y-axis and any of the independent variables can be plotted on the x-axis. 
This will allow us to visualize how the probability of an outcome changes with changing values of the independent variable. An example is shown in Figure ~\ref{fig:prediction}, where we can see that the probability of withdrawing from 
a course decreases as the GPA increases.

tex*/
texdoc stlog, cmdstrip nooutput
qui use logistic_project, clear
qui logistic withdraw gpa
qui predict mu
scatter mu gpa, graphregion(color(white)) mcolor(green) ytitle(Predicted probability)
texdoc stlog close
texdoc graph, caption(Visualizing the result of logistic regression: Relationship between the probability of withdrawing from a course and student GPAs.) label(fig:prediction) figure(h) optargs(width=0.7\textwidth)
/*tex
\section{Goodness of Fit}
Once we have chosen the variables that we wish to include in the model, we should test how effectively the model describes the outcome variable. There are several ways to do this. In order to illustrate each 
of these ways, consider the data shown in Table ~\ref{table:goodnessoffit}. The output of running a logistic model on this data will be:

$$ \log(\frac{p}{1-p})=2.21(courses)-11.25 $$

By now we know that this means that when the number of courses increases by one, the odds of withdrawing is multiplied by $e^{2.21}=9.12$. The odds, therefore, increase when the course loads increases.
\begin{longtable}[c]{ c c }
	\caption{The dependent variable is outcome and the independent variable is courses.\label{table:goodnessoffit}}\\
		\hline
		\bf Outcome & \bf Courses \\
		\hline
		Withdraw & 6 \\
		Withdraw & 6 \\
		Finish & 4 \\
		Finish & 6 \\
		Finish & 4 \\
		Finish & 3 \\
		Finish & 5 \\
		Finish & 6 \\
		Withdraw & 6 \\
		Finish & 4 \\
		Withdraw & 5 \\
		Finish & 4 \\
		Withdraw & 6 \\
		Withdraw & 5 \\
		Finish & 4 \\
		Finish & 4 \\
		Withdraw & 5 \\
		Withdraw & 6 \\
		Withdraw & 5 \\
		Finish & 4 \\
		Finish & 5 \\
		Withdraw & 6 \\
		Finish & 4 \\
		Finish & 4 \\
		Finish & 5 \\
		Withdraw & 5 \\
		Withdraw & 6 \\
		Withdraw & 5 \\
		Finish & 4 \\
		Finish & 3 \\
		Finish & 4 \\
	\hline
\end{longtable}
\subsection{Likelihood Ratio Test}
This test compares our model with a constant-only model. In other words, this test checks whether the model with the chosen independent variables in significantly better than a model that contains no independent variables. 
If the result of the test is statistically significant (p < 0.05), then we reject the null hypothesis that both models are the same, and we conclude that the model with the independent variables is significantly better. 
Otherwise, if p $\geq$ 0.05, we cannot reject the null hypothesis, thereby we conclude that the model with the added independent variables does not do significantly better than the model with no added variables. With regards to 
the dataset shown in Table ~\ref{table:goodnessoffit}, running a logistic model will result in a p-value that is less than 0.05, thus indicating that the model does significantly better than a constant-only model. 
\subsection{Hosmer-Lemeshow GOF Test}
The Hosmer-Lemeshow test is considered to be one of the best ways to assess the fit of a logistic model. What this test does is that it divides the dataset into groups (usually ten groups), and then compares the 
observed and fitted values within each group. If there is considerable discrepancy between the observed values and the fitted values, the Hosmer-Lemeshow statistic will be large, and this will result in a small p-value. 
What we ideally want to see is that the discrepancy between the observed and the fitted values is small, thereby resulting in a small Hosmer-Lemeshow statistic, which would result in a large p-value. This means that in 
this test, the null hypothesis is that the model fits. If the p-value is less than 0.05, then we reject the null hypothesis and we conclude that the model is not a good fit. 

If we conduct this test on the data in Table ~\ref{table:goodnessoffit}, we will get a p-value of 0.0565 which is only slightly greater than the cut-off value of 0.05. Since the p-value is greater than 0.05, we cannot reject the null 
hypothesis that the model is a good fit.
\subsection{Classification Tables}
An intuitive way of determining whether the model is well-fit or not is to compare the predicted outcome with the actual observed outcome. However, before doing that, we need to determine the point at which the model 
predicts that the outcome will occur. We know that after fitting the logistic model we can calculate the probability that the outcome will occur for each observation. In order for us to be able to construct a classification 
table, we need to determine the probability above which we would consider that the outcome value has occurred. For example, if the predicted probability of the outcome for an observation is 0.88, do we consider that the 
model predicts that the outcome will occur? What about if the probability was 0.52? Usually, a cut-off value of 0.5 is used. If the predicted probability is greater than 0.5, then the model predicts that the dependent 
variable will have a value of one (outcome will occur).

A better way to determine the cutoff value is to actually let the data inform us of the best value to use. The idea here is to calculate the sensitivity and the specificity of the model. Sensitivity represents the 
probability that the model will correctly predict that the outcome has occurred. For example, if the outcome has occurred in 150 of the observations, and the model correctly predicts 140 of them, then the sensitivity 
is 140/150, which is 93.33\%. Specificity on the other hand represents the probability that the model will correctly predict that the outcome has not occurred. For example, if the outcome has not occurred in 200 of the 
observations, and the model correctly predicts 170 of them, then the sensitivity is 170/200, which is 85.00\%. The ideal cutoff value is the one at which sensitivity and specificity are equal.
\begin{table}[h!t]
	\caption{Classification table.} \label{table:classification}
	\centering
	\begin{tabular}{c |c c| c}
	\hline
	{} & \multicolumn{2}{|c|}{Observed} & {} \\
	\hline
	\bf Classified & \bf Outcome = 1 & \bf Outcome = 0 & \bf Total \\
	Outcome = 1 & 7 & 2 & 9 \\
	Outcome = 0 & 6 & 16 & 22 \\
	Total & 13 & 18 & 31 \\
	\hline
	\end{tabular}
\end{table}

As an example, Table ~\ref{table:classification} shows the classification table for the logistic regression model that is fit using the data in Table ~\ref{table:goodnessoffit}. We see that the model correctly predicts seven cases where the observed outcome variable is one, 
which means that the sensitivity is 7/13 which is 53.85\%, and 16 of the cases where the outcome variable is zero, which means that the specificity is 16/18 which is 88.89\%. In two cases, the model predicts a one where the 
observed value is a zero, and in six cases the model predicts a zero where the observed value is one. Therefore, the model correctly classifies (7+16)/31 = 74.19\% of the observations. This is considered to be an acceptable 
value.
\subsection{ROC Analysis}
Another way to test the model fit is to use ROC curves, where we are interested in the area under the curve. This area, which ranges from zero to one, is a measure of the model’s ability to discriminate between 
observations where the outcome of interest is experienced and observations where the outcome of interest is not experienced. The higher the value, the stronger the ability of the model to discriminate. As a general 
guideline:
\begin{itemize}
	\item ROC = 0.5: No ability to discriminate
	\item ROC is between 0.7 and 0.8: Acceptable discrimination
	\item ROC between 0.8 and 0.9: Excellent discrimination
	\item ROC greater than 0.9: Outstanding discrimination
\end{itemize}
If we calculate the area under the ROC curve for the data in Table ~\ref{table:goodnessoffit}, we will find it to be 0.88, thus indicating that the model has an excellent ability to discriminate.
\subsection{Residual Analysis}
Residuals are the difference between the observed outcome and the model’s predicted outcome. As you can imagine, a well-fit model should have small residual values. In linear regression, residual analysis is extremely 
important because linear regression makes strong assumptions about the residuals. In the case of logistic regression, we need to look at the size of the residuals in order to see whether there might be influential 
observations that are biasing our results. 

There are many types of residuals that are used in logistic regression. However, the three most commonly used ones are the standardized residuals, deviance residuals, and the DeltaX residuals. Just like in linear 
regression, these statistics are plotted against the predicted variable in order to visualize the results.
\subsection{Influential Observations}
In linear regression, the three statistics that are used to measure influence are DFBETAS, DFFITS, and Cook’s D statistics. High magnitudes of these statistics indicate that an observation is influential. 
In logistic regression, we use the hat diagonal statistic and the delta-beta influence statistic in order to measure influence. Just as in the case of the residual statistics described above, these statistics are 
plotted against the predicted probabilities in order to visualize the results.

Although there are no fixed-set of rules with regards to determining the values that determine whether an observation is an outlier or whether it is influential, Table ~\ref{table:guidlines} offers some general guidelines that are 
useful in many situations.
\begin{table}[h!t]
	\caption{Guidelines for residual and influence statistics.} \label{table:guidlines}
	\centering
	\begin{tabular}{c c}
	\hline
	\bf Measure & \bf Value above which there might be a problem \\
	\hline
	Deviance residual & Greater than two \\
	DeltaX residual & Greater than four \\
	Hat diagonal statistic & Greater than two times the average hat statistic \\
	Delta-beta influence & Greater than one \\
	\hline
	\end{tabular}
\end{table}

\chapter{Logistic Regression - Case Study}
We now have the necessary tools that allow us to analyze a dataset where the dependent variable takes on two values. In this section, we will be looking at a dataset that contains the following variables:
\begin{itemize}
	\item withdraw: this is the dependent variable which records whether the student withdrew from the course or finished the course (zero means continued, one means withdraw)
	\item college: whether the student is in the engineering school or the business school (zero means business, one means engineering)
	\item gender: whether the student is a male or a female (zero means female, one means male)
	\item gpa: overall GPA of the student
	\item semester: records whether the course was taken in the spring, fall, or summer semester (zero means fall, one means spring, two means summer)
	\item level: records whether the level of the course (zero means remedial, one means one-hundred level course, two means two-hundred level course, three means three-hundred level course, 
			four means four-hundred level course, and five means five-hundred level course)
\end{itemize}
\section{Univariable Tests}
The first thing that we should do when conducting regression analysis is to perform univariate analysis, where we try and uncover whether there is a relationship between the dependent variable and each independent 
variable separately. Once we have a good idea about the nature of these individual relationships, we can start building the model.
\subsection{Continuous Variables}
In linear regression, when we have a continuous independent variable, we start our analysis by plotting a scatter plot. Graphs are also useful as a starting step in logistic regression, but their shape is 
different from what we are used to due to the nature of the dependent variable. For example, let us produce a scatter plot of the dependent variable withdraw and the continuous independent variable GPA.

tex*/
qui use logistic_project, clear
texdoc stlog, cmdstrip nooutput
scatter withdraw gpa, graphregion(color(white)) mcolor(green)
texdoc stlog close
texdoc graph, caption(Scatter plot of withdraw and GPA.) label(fig:scatterplot) figure(h) optargs(width=0.7\textwidth)
/*tex

The graph produced is shown in Figure ~\ref{fig:scatterplot}. The reason that the graph looks different is that the variable withdraw can only take on two values, either a zero or a one. This is why the dots lie along 
one of two lines, the withdraw equal zero line and the withdraw equal one line. The graph, however, is informative. Notice, for example, that the students who have a value of one for the withdraw variable 
(these are the students who withdraw from the course) tend to have a GPA that is lower than 85. Students with higher GPAs do not seem to withdraw from courses. However, this does not mean that all students 
with a low GPA withdraw. If you look at the lower horizontal line, we see that the range of GPAs is very wide. We have students who have very low GPAs but who didn’t withdraw from the course, we have students 
with average GPAs who did not withdraw from the course, and we have students with very high GPAs who did not withdraw from the course. The difference between the two horizontal lines is that there is an 
absence of very high GPAs in the line at the top.

We can investigate this further by calculating the average GPA for students who withdraw from courses and then to compare it to the GPA of students who do not withdraw:

tex*/
texdoc stlog, linesize(80) cmdstrip
by withdraw, sort: summarize gpa
texdoc stlog close
/*tex

We can see that the average GPA of students who did not withdraw is 77.38 while the average for students who did withdraw is 71.19.

We next fit a logistic model where the only independent variable is GPA:

tex*/
texdoc stlog, cmdstrip
logistic withdraw gpa
texdoc stlog close
/*tex

The output displays the odds ratio. The value of this odds ratio indicates that an increase of one-unit in the GPA causes the odds to be multiplied by 0.87. This means that the odds decrease by 13\%.

We can tell the statistical program to display the coefficient by specifying the coef option:

tex*/
texdoc stlog, cmdstrip
logistic withdraw gpa, coef
texdoc stlog close
/*tex

The value of the coefficient is -0.1371. We already know that the odds ratio is $e^{-0.1371}=0.87$, which is the odds ratio displayed when we ran the model without the coef option.

The output also shows that the p-value of GPA is less than 0.05, indicating that the result is significant. Therefore, it seems that including the variable in the model is a good idea. However, as 
discussed in the theory section of this course, when we have continuous variables we need to test the assumption of linearity. We know that the form of the logistic model is:

$$ \log(\frac{p}{1-p})=ax+b $$

This means that the independent variable is linear with respect to the logit function. As also discussed in the theory section, there are three ways to test this assumption: the Box-Tidwell test, 
the loess curve, and the linearity of sloped test. We will perform each of these three tests.
\subsubsection{Box-Tidwell Test}
To perform this test we need to create a new variable and to include this variable in the logistic regression model:

tex*/
qui gen boxtid = gpa*ln(gpa)
texdoc stlog, cmdstrip
logistic withdraw gpa boxtid
texdoc stlog close
/*tex

The new variable is the product of GPA and the log function of GPA. Since the newly created variable is significant (the p-value is less than 0.05), the result indicates that the relationship between 
the logit function and the variable GPA is not linear.
\subsubsection{Loess Curve}
We next produce the loess curve of the outcome variable, which is withdraw, and the continuous variable, which is GPA. The result is shown in Figure ~\ref{fig:lowesstest}. The curve clearly shows that the relationship 
is not linear, thus providing extra evidence.

tex*/
texdoc stlog, cmdstrip nooutput
lowess withdraw gpa, logit graphregion(color(white)) subtitle("")
texdoc stlog close
texdoc graph, caption(Loess curve of withdraw and GPA.) label(fig:lowesstest) figure(h) optargs(width=0.7\textwidth)
/*tex

\subsubsection{Linearity of Slopes Test}
In order to perform the linearity of slopes test, we need to categorize the continuous variable GPA. In this case, we will generate a new variable, which we named gpacat, 
by cutting the variable GPA into groups: GPA between 40 and 50 in one group, 50 and 60 in a second group, 60 and 70 in a third group, 70 and 80 in a fourth group, 80 and 90 in a fifth group, and finally 90 and 100 in a 
sixth group.

We can take a closer look at our newly created variable:

tex*/
qui egen gpacat = cut(gpa), at(40(10)100)
texdoc stlog, cmdstrip
tabulate gpacat
texdoc stlog close
/*tex

We see that there are four groups where each contains roughly the same number of observations. The groups are in order. This means that group zero contains the GPAs which are in the bottom quartile and group 
three contains the GPAs which are in the top quartile.

Now that we have our categorical variable, we include it by itself in a logistic model:

tex*/
texdoc stlog, cmdstrip
logistic withdraw i.gpacat
texdoc stlog close
/*tex

We would next want to produce a graph in order to see whether the relationship is linear or not.

tex*/
texdoc stlog, cmdstrip nooutput
margins gpacat, predict(xb) 
marginsplot, noci title("") graphregion(color(white)) plotopts(color(green))
texdoc stlog close
texdoc graph, caption(Testing the linearity of the slopes assumption.) label(fig:marginslinearity) figure(h) optargs(width=0.7\textwidth)
/*tex

The graph is shown in Figure ~\ref{fig:marginslinearity}. Once again, the nonlinearity is evident in the graph as it curves downward.
\subsection{Including a Quadratic Term}
Now that we have seen that there is nonlinearity when it comes to the independent variable GPA, we need to do something to account for this nonlinearity. One way to include nonlinearity in a 
regression model is to add a quadratic term, where this term is the square of the variable. By including the original variable and the squared term, we will be modeling the following equation:

$$ \log(\frac{p}{1-p})=a_1x^2+a_2x+b $$

tex*/
gen gpa2 = gpa*gpa
texdoc stlog, cmdstrip
logistic withdraw gpa gpa2
texdoc stlog close
logistic withdraw gpa c.gpa#c.gpa
texdoc stlog, cmdstrip nooutput
margins, at(gpa=(40(1)100)) predict(xb)
marginsplot, noci title("") graphregion(color(white)) plotopts(color(green))
texdoc graph, caption(Including a quadratic term.) label(fig:quadratic1) figure(h) optargs(width=0.7\textwidth)
texdoc stlog close
/*tex

The result is shown in Figure ~\ref{fig:quadratic1}.
\subsection{Binary Variables} 
Now that we have seen how to analyze the relationship between the binary dependent variable and a continuous independent variable, we move onto other types of variables. Looking at our dataset, we notice 
that the variables gender and college are binary. Both take on two values. While graphs are used to investigate the relationship when a continuous variable is involved, contingency tables are used to investigate 
the relationship when the independent variable is binary.

We start by looking at the variable gender.

tex*/
texdoc stlog, cmdstrip
tabulate gender withdraw, row
texdoc stlog close
/*tex

We see that 0.95\% of females withdrew from courses as opposed to the 2.50\% of males. This result indicates that there seems to be a difference between the two groups. To verify this, we fit a logistic model:

tex*/
texdoc stlog, cmdstrip
logistic withdraw i.gender
texdoc stlog close
/*tex

The output shows that the odds ratios is 2.68. This means that the odds of males are 2.68 times the odds of females. The result is significant since 
the p-value is less than 0.05. Therefore, when building our final model, it would make sense to include this variable.

We next perform the same analysis for the variable college:

tex*/
texdoc stlog, cmdstrip
tab college withdraw, row
logistic withdraw i.college
texdoc stlog close
/*tex

The odds ratio is 0.76 indicating that the odds for an engineering student to withdraw is less than the odds of a business student, since the odds ratio is less than one. The result is also 
statistically significant. It therefore seems that this variable merits inclusion in the model.
\subsection{Categorical Variables with More than Two Groups} 
Our dataset also contains variables that are categorical in nature, but unlike binary variables, these variables contain more than one group.

tex*/
texdoc stlog, cmdstrip
tabulate semester withdraw, row
tabulate level withdraw, row
texdoc stlog close
/*tex

It seems that the largest percentages of withdrawals are in the spring semester. It addition, it also seems that the largest percent of withdrawals are in 200-level courses. 
It should be noted that 100-level courses are the courses that are taken during the freshman year before students have decided on their major. Once a student has enrolled in the major of 
his or her choice, they start taking the 200-level courses. During the third and fourth year of their studies, students take the 300-hundred and the 400-hundred level courses. For majors 
that extend beyond four years, students take 500-hundred level courses in their final year. Therefore, what this output shows is that the largest percentage of withdrawals takes place in 
the first year after students have enrolled in their major.

We next fit a logistic model with semester as the independent variable:

tex*/
texdoc stlog, cmdstrip
logistic withdraw i.semester
texdoc stlog close
/*tex

Since the base category is fall, the odds ratio compare the odds of withdrawing in spring and summer to the odds of withdrawing in the fall semester.

If you look at the output in which the fall semester is the base, you will notice that the p-value for the category spring is less than 0.05 while the p-value for the category summer 
is greater than 0.05. This means that the difference between the spring semester and the fall semester is significant, while the difference between the summer semester and the fall semester is not. Given this 
result, we might want to consider collapsing the variable semester. Since the odds ratio for summer when compared to fall is not significant, it might be better if we just treated these two as a single group. 
In other words, we can create a binary variable that takes a value of zero when the semester is fall or summer, and takes a value of one when the semester is spring:

tex*/
recode semester 0 2=0 1=1, gen(spring)
label define spring 0 "Fall or Summer" 1 "Spring"
label values spring spring
label variable spring "Spring semester"
texdoc stlog, cmdstrip
tabulate semester spring
texdoc stlog close
/*tex

We can see that all observations with a value of spring for the semester variable have a value of spring in the new variable. We also see that all observations with a fall or summer value have a value of 
“Fall or Summer” in the new variable. Therefore, we confirm that the new variable has been coded correctly. 

We next include this new variable in the logistic model:

tex*/
texdoc stlog, cmdstrip
logistic withdraw i.spring
texdoc stlog close
/*tex

We see that the odds ratio is greater than one and is significant. We therefore conclude that for courses that are taken in the spring semester, the odds of withdrawal is 1.24 times the odds 
of withdrawal in the other two semesters. Which model should we use, the one with the spring/fall/summer division or the one with the spring/not spring division? I usually prefer to use the model 
with the collapsed variable for the sake of simplicity.

We now perform the same analysis on the level variable:

tex*/
texdoc stlog, cmdstrip
logistic withdraw i.level
texdoc stlog close
/*tex

We see that the result for 200-level courses and 500-level courses is significant, with 200-level courses having odds that are 2.84 times higher than the odds of intensive courses (the base category), 
and 500-level courses having odds that are 0.08 times the odds of intensive courses. The other categories have p-values that are less than 0.05. Looking at this output, we might deduce that 
once students have reached the very end of their studies, the probability that they will withdraw from a course decreases significantly since such a decision will probably postpone their graduation. 
We can also deduce that students who have just enrolled in a major face the largest uncertainty in terms of not being sure whether this is the correct major for them, thus leading to a higher probability 
of withdrawal. Given that the other categories are not significant, we might choose to collapse this variable as well by creating a new three-group variable that contains the groups 200-level courses, 
500-level courses, and the remaining courses.

tex*/

recode level 0 1 3 4=0 2=1 5=2, gen(level3)
label define level3 0 "Other courses" 1 "200 level courses" 2 "500 level courses"
label values level3 level3 

texdoc stlog, cmdstrip
tabulate level level3
texdoc stlog close
/*tex

We see that the coding operation was successful. The remedial, 100-hundred level, 300-level, and 400-level courses all end up in the first group of the new variable. The 200-hundred level courses end up in the 
second group, and the 500-level courses end up in the third group.

We now include this new variable in the model:

tex*/
texdoc stlog, cmdstrip
logistic withdraw i.level3
texdoc stlog close
/*tex

Both groups of the variable are significant.
\section{Multivariate Analysis}
After looking at each independent variable by itself, we need to start building a more complex model. This means that we need a model that includes more than one independent variable. 
We start with a model that includes all the variables that were found to be significant when we conducted the univariate analysis:

tex*/
texdoc stlog, cmdstrip
logistic withdraw gpa gpa2 i.gender i.college i.spring i.level3
texdoc stlog close
/*tex

Notice that we include the quadratic term of the variable GPA, since we had uncovered that the logit function is not linear with respect to GPA. We also include the collapsed versions of the 
variables semester and level. We see that all of the variables are significant except for the variable college. Therefore,  it seems like a good idea to remove this variable from the model:

tex*/
texdoc stlog, cmdstrip
logistic withdraw gpa gpa2 i.gender i.spring i.level3
texdoc stlog close
/*tex

We now see that all the independent variables are significant. When we have several independent variables, it is quite difficult to make sense of the individual odds ratios, especially 
when it comes to quadratic terms. This is why Stata provides us with powerful graphical tools that allow us to visualize the effect that each independent variable has on the probability of withdrawal. 
Before interpreting the result of the model however, we need to check the goodness-of-fit of the model using the tests that were discussed in the theory section.
\section{Analysis of Model Fit}
\subsection{Likelihood Ratio Test}
This test is usually displayed whenever we run a logistic model:

tex*/
texdoc stlog, cmdstrip
logistic withdraw gpa gpa2 i.gender i.spring i.level3
texdoc stlog close
/*tex

From the top right corner of the output, we can see that the test yields a p-value that is less than 0.05, thereby indicating that our model does a significantly better job than a constant-only model. 

\subsection{Hosmer-Lemeshow Test}
We next perform the Hosmer-Lemeshow test:

tex*/
texdoc stlog, cmdstrip
estat gof, group(10)
texdoc stlog close
/*tex

Hosmer-Lemeshow recommend that the data be divided into 10 groups, which is what we did in the command. The Hosmer-Lemeshow statistics is 6.76, 
which is low, thus resulting in a p-value that is much larger than 0.05. This means that the model is a good, if not excellent, fit.

\subsection{Classification Table}
The classification table allows us to compare the observed outcome with the outcome as predicted by our model. Before producing the classification table, we first need to determine the cutoff 
probability. As discussed in the theory section, the cutoff value is the optimal probability value that separates the predicted and observed outcomes. This ideal cutoff value is the point at which the 
sensitivity and the specificity are equal. Stata has a command called lsens that allows us to produce a graph of the sensitivity and the specificity in order for us to see where the graphs intersect. 

tex*/
texdoc stlog, cmdstrip nooutput
lsens, gense(se) gensp(sp) genp(cutp) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(The sensitivity-specificity curves.) label(fig:sensspec) figure(h) optargs(width=0.7\textwidth)
/*tex

Figure ~\ref{fig:sensspec} shows the point of intersection of the specificity and the sensitivity. 
We see that the sensitivity and the specificity curves intersect at a very small probability. The exact value of the point of intersection is 0.024088. We can now produce the classification table:

tex*/
texdoc stlog, cmdstrip
estat class, cut(0.024088)
texdoc stlog close
/*tex

We see that the model correctly classifies 71.72\% of the observations, which is an acceptable value. 
\subsection{ROC Curve}
As discussed in the theory section, another way to test the model fit is to calculate the area under the ROC curve, which is shown in Figure ~\ref{fig:roc}. The output shows that the area under the curve is 0.7803. According 
to the set of rules that were mentioned in the theory section, this is considered acceptable discrimination.

tex*/
texdoc stlog, cmdstrip nooutput
lroc, graphregion(color(white))
texdoc stlog close
texdoc graph, caption(The ROC curve.) label(fig:roc) figure(h) optargs(width=0.7\textwidth)
/*tex

\subsection{Residual Analysis}
When discussing the theory of logistic regression, it was mentioned that the three most commonly used ones are the standardized residuals, the deviance residuals, and the DeltaX residuals. 
At this point in the analysis, we need to calculate these residuals and produce the appropriate plots.
\subsubsection{Standardized Residuals}
We start with the plot of the standardized residuals against the predicted probabilities. The graph is shown in Figure ~\ref{fig:res1}.

tex*/

predict residuals, rstandard
predict prob
texdoc stlog, cmdstrip nooutput
scatter residuals prob, yline(0) msize(vsmall) mcolor(green) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Plotting the standardized residuals against the predicted probabilities.) label(fig:res1) figure(h) optargs(width=0.7\textwidth)
/*tex

\subsubsection{Deviance Residuals} 
We now do the same for the deviance residuals. The graph is shown in Figure ~\ref{fig:res2}. Both Figure ~\ref{fig:res1} and Figure ~\ref{fig:res2} show that there are some observations that have residual values that 
are large when compared to other observations. In general, when the sample size is large enough, as is the case in our dataset, an observation that has a deviance residual that is greater than two should raise a flag, 
which is why we drew a horizontal line at the point y equal to two when plotting the deviance residuals. 

tex*/
predict dv, deviance
texdoc stlog, cmdstrip nooutput
scatter dv prob, yline(2) msize(vsmall) mcolor(green) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Plotting the deviance residuals against the predicted probabilities (values above two are considered to be outliers).) label(fig:res2) figure(h) optargs(width=0.7\textwidth)
/*tex

\subsubsection{DeltaX}
We now produce the scatter plot of the DeltaX residuals against the predicted probabilities. The output is shown in Figure ~\ref{fig:res3}. We draw a horizontal line at the y equal 4 point since values above four 
are considered to be outliers. 

tex*/

predict dx2, dx2
texdoc stlog, cmdstrip nooutput
scatter dx2 prob, yline(4) msize(vsmall) mcolor(green) graphregion(color(white)) ytitle(DeltaX)
texdoc stlog close
texdoc graph, caption(Plotting the DeltaX residuals against the deviance residuals (values above four are considered to be outliers).) label(fig:res3) figure(h) optargs(width=0.7\textwidth)
/*tex

\subsection{Influential Observations}
\subsubsection{The Hat Diagonal Statistic}
Figure ~\ref{fig:influence1} shows the hat statistic plotted against the predicted probability. We draw a horizontal line at the y equal 0.00519402 point since values that are more than two times greater 
than the average are considered to be influential (the mean of the variable hat is 0.002597). 
\subsubsection{Delta-Beta Statistic}
Figure ~\ref{fig:influence2} shows the delta-beta influence statistic plotted against the predicted probability. We draw a horizontal line at the y = 1 point because values greater than one indicate that the 
observation is influential.

What we are doing here is that we are producing a scatter plot of the DeltaX residuals against the predicted probabilities. We have actually already done this in Figure ~\ref{fig:res3}. This time however, 
the size of the dots are weighted by the value of the delta-beta statistic. Since DeltaX is a residual measure, the larger the value, the worse the fit of the observation, since residuals 
are a measure of the difference between the observed value and the predicted value. Since delta-measure is a measure of influence, and since we are weighing the dots by this variable, 
the larger the dot, the more influential it is. What this means is that when we produce this plot, the most problematic points are the large points in the upper left corner. 
This means that they are influential (hence their large size) and they are not a good fit with the model (high value of the residual which leads to them being near the top).

tex*/

qui predict hat, hat
texdoc stlog, cmdstrip nooutput
scatter hat prob, yline(0.00519402) msize(vsmall) mcolor(green) graphregion(color(white)) ytitle(Hat statistic)
texdoc stlog close
texdoc graph, caption(Plotting the hat statistic residuals against the predicted probabilities (values that are more than two times greater than the average are considered to be influential).) label(fig:influence1) figure(h) optargs(width=0.7\textwidth)

qui predict dbeta, dbeta
texdoc stlog, cmdstrip nooutput
scatter dbeta prob, yline(1) msize(vsmall)  graphregion(color(white)) mcolor(green)
texdoc stlog close
texdoc graph, caption(Plotting the Delta-Beta statistic against the predicted probabilities.) label(fig:influence2) figure(h) optargs(width=0.7\textwidth)

texdoc stlog, cmdstrip nooutput
scatter dx2 prob [aweight=dbeta], msymbol(Oh)  graphregion(color(white)) mcolor(green) ytitle(DeltaX)
texdoc stlog close
texdoc graph, caption(Plot of DeltaX versus estimated probability weighted by the variable delta-beta.) label(fig:influence3) figure(h) optargs(width=0.7\textwidth)
/*tex

The large circle in the top left-hand side of the graph raises concerns. We need to take a closer look at these values, so we display the values of the variables for the observations that have DeltaX statistics that are 
greater than 200. 

tex*/
texdoc stlog, cmdstrip
list withdraw gender gpa college spring level3 if dx2 > 200, noobs
texdoc stlog close
/*tex

We see that there are six observations (the noobs option tells Stata not to list the observation numbers). We also notice that they all have a similar pattern: male engineering student with a GPA of 79.3, 
taking a 500-level course in a semester other than the spring semester. It seems that our model is not doing a good job of predicting the probability for observations with these covariate patterns. What would happen if we 
fit the model without including these observations?

Table ~\ref{table:compareinfluence} shows a side by side comparison of both models. The table displays the output from two models, one that 
included all observations, and a second that excluded the observations that have a dx2 value greater than 200. This means that the six observations that have a 
DeltaX residual that is greater than 200 are excluded. We see that neither values of the coefficients, nor the significance levels of any of the variables changes significantly. This means that our results are robust.

tex*/
texdoc stlog, cmdstrip nooutput
qui logistic withdraw gpa c.gpa#c.gpa gender spring i.level3
qui estimates store model1
qui logistic withdraw gpa c.gpa#c.gpa gender spring i.level3 if dx2 <= 200
qui estimates store model2
esttab model1 model2 using compareinfluence.tex, replace not label nomtitles title(Comparing estimates of both models\label{table:compareinfluence})
texdoc stlog close
texdoc write \input{compareinfluence.tex}
/*tex

\section{Interpreting the Results}
Now that we have seen that the model fit is good, it is time to interpret the obtained model parameters. It is important to note that logistic regression has the following linear form:

$$ \log(\frac{p}{1-p})=ax+b $$

Therefore, once we fit the model we can calculate the value of the logit function for each observation. From this logit function, we are able to calculate the individual probabilities. Ultimately, we are interested 
in knowing the effect that each independent variable has on the probability of the event occurring. Does taking a course in the spring semester lead to an increase in the probability that a student might 
withdraw from the course? If so, what is the increase in the probability? Therefore, when we interpret the results, it is useful to know how the probability of the event occurring changes with changing values of the 
independent variables.
\subsection{Graphical Interpretation}
One of the most useful tools to use to understand the results of regression models are graphs. As an example, take the case of the independent variable GPA. We would like to know what is the change in the probability of 
withdrawing from a course when GPA changes. The graph is shown in Figure ~\ref{fig:visual1}. Notice that the probability drops to almost zero for values of GPA that are higher than 80. 

tex*/
qui logistic withdraw gpa c.gpa#c.gpa i.gender i.spring i.level3 
qui margins, at(gpa=(40(1)100)) noatlegend
texdoc stlog, cmdstrip nooutput
marginsplot, noci title("") graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Graphing the probability of withdrawing from a course for each value of GPA.) label(fig:visual1) figure(h) optargs(width=0.7\textwidth)
/*tex

We can also produce a more informative graph by including one of the categorical variables, as illustrated in Figure ~\ref{fig:visual2}. This graph is interesting because it shows that for 500-level courses, 
the probability of withdrawal is close to zero no matter what the GPA is. The GPA has the largest effect on probability for 200-level courses. This makes sense since at this stage, students will still be uncertain 
about their choice of major. Getting a low GPA will raise a flag that perhaps they are enrolled in the wrong type of course.

tex*/
margins, at(gpa=(40(1)100) level3=(0 1 2)) noatlegend
texdoc stlog, cmdstrip nooutput
marginsplot, noci title("") graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Graphing the probability of withdrawing from a course for different values of GPA for different level courses.) label(fig:visual2) figure(h) optargs(width=0.7\textwidth)
/*tex

A final example will illustrate how we can graph the results when all variables are categorical as illustrated in Figure ~\ref{fig:visual3}. Here, we are calculating the probabilities while varying 
the variables gender and level3. We see that the probabilities  are calculated for females in the three different course levels, as well as for males. We also see that at the 500-level courses, the difference between 
females and males is minimal, while at the 200-level courses the difference is considerable.

tex*/
qui margins, at(gender=(0 1) level3=(0 1 2))
texdoc stlog, cmdstrip nooutput 
marginsplot, noci title("") graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Graphing the probability of withdrawing from a course for different values of gender for different level courses.) label(fig:visual3) figure(h!t) optargs(width=0.7\textwidth)
/*tex

\chapter{Count Models - The Theory}
\section{Introduction}
Perhaps the most known and used regression technique is linear regression, where the dependent variable is continuous in nature. For example, if the dependent variable was salaries, then we can use linear regression, 
because a salary can take on any value in a certain interval. Linear regression can also be used when the dependent variable is student grades where the grade can be any value between zero and 100, including decimal values. 
As you know, any regression model makes certain mathematical assumptions. If these assumptions are violated, then the use of the regression model is questioned. This is why we cannot use linear regression when the 
dependent variable is not continuous in nature. When the dependent variable can take on only two values for example (i.e. a student either passes or fails a course) then linear regression cannot be used. In 
such a case we can use logistic regression. What about when the dependent variable represents a count? For example, what if the dependent variable is the number of courses that a student has failed in? In this 
case the dependent variable cannot be negative since the minimum value is zero. In addition, the dependent variable cannot take on decimal values since students cannot fail in 2.5 courses for example. Another issue 
is that the maximum number of failed courses has a ceiling. A student cannot fail in 100 courses since the entire program does not have 100 courses. When the dependent variable is created by counting the times 
that a certain event has happened, we use regression techniques that are referred to as count models. In order to understand how these techniques work, let us first consider a simple count table. As an example, 
consider the data displayed in Table ~\ref{table:countcountfirst}. The table contains the records of twenty students. The data includes the total number of courses in which each student has failed, the total number of courses in which the 
student has passed, and the college in which the student is enrolled. What we want to see is whether students in engineering fail in more courses than business students. This means that the variable that we intend to 
study is the number of courses in which the student has failed. This is an example of a count variable. To help us answer our question we can create a count table that summarizes the data.
\begin{table}[h!t]
	\caption{Records of students.} \label{table:countcountfirst}
	\centering
	\begin{tabular}{ c c c }
		\hline
		\bf Number of failed courses & \bf Number of passed courses & \bf College \\
		\hline
		3 & 20 & Business \\
		0 & 9 & Business \\
		5 & 25 & Business \\
		7 & 21 & Business \\
		1 & 26 & Engineering \\
		2 & 15 & Business \\
		2 & 13 & Business \\
		0 & 18 & Business \\
		4 & 23 & Engineering \\
		2 & 8 & Engineering \\
		5 & 23 & Engineering \\
		3 & 14 & Engineering \\
		8 & 19 & Business \\
		0 & 24 & Business \\
		1 & 5 & Engineering \\
		2 & 13 & Engineering \\
		3 & 17 & Business \\
		4 & 21 & Engineering \\
		5 & 27 & Business \\
		9 & 25 & Engineering \\
	\hline
	\end{tabular}
\end{table}
\section{Count Tables}
Consider Table ~\ref{table:counttablefirst}, which summarizes the data shown in Table ~\ref{table:countcountfirst}. We see that out of a total of 243 courses taken by business students, there are 35 failing grades and 208 passing grade. For engineers, 
out of a total of 189 courses, there are 31 failing grades and 158 passing grades. Therefore, the count of failed courses for engineers is actually smaller than the count for business 
(31 for engineers and 35 for business). Does this mean that the failure rate in business is higher? The answer is no because we did not take into account the total number of courses. In other words, we need to 
calculate the proportion of courses which resulted in a failed grade. This means that we need to look at the risk.
\begin{table}
	\caption{Count table showing number of failed and not failed courses for students in the business and engineering schools.} \label{table:counttablefirst}
	\centering
	\begin{tabular}{c |c c| c}
	\hline
	{} & \multicolumn{2}{|c|}{College} & {} \\
	\hline
	\bf Failed & \bf Business & \bf Engineering & \bf Total \\
	No & 208 & 158 & 366 \\
	Yes & 35 & 31 & 66 \\
	Total & 243 & 189 & 432 \\
	\hline
	\end{tabular}
\end{table}
\subsection{Risk}
Now that we have seen Table ~\ref{table:counttablefirst}, we would like to calculate the risk that a student in business would fail a course and to compare it to the risk that a student in engineering would fail a course. 
Risk here indicates the probability of the event happening. For business students for example, out of a total of 243 courses, 35 resulted in a failed grade. This means that the probability of failure, 
or the risk of failure, is 35/243 = 0.144. For an engineering student, the risk is 31/189 = 0.164. Therefore, we see that this risk of failure for engineers is greater than the risk of failure of business students. 
\subsection{Incidence-rate Ratio}
We now know that the risk of failure for business students is larger than the risk of failure of engineering students. To directly compare the two risks we can calculate the incidence-rate ratio, 
which is simply the ratio of the two numbers:

\centerline{\(Risk ratio=0.144/0.164=0.878\)}

What does this value mean? Simply that the likelihood of a business student failing a course is 0.878 times the likelihood of an engineering student failing the course. 
We could have calculated the incidence-rate ratio by dividing the risk for engineers by the risk for business students:

\centerline{\(Risk ratio=0.164/0.144=1.139\)}

This means that the likelihood of an engineering student failing a course is 1.139 times the likelihood of a business student failing a course.
\subsection{2x3 Tables}
The above logic is maintained even when we have more than two groups. Consider Table ~\ref{table:countsecond} for example. This table contains the same information as Table ~\ref{table:counttablefirst} with the addition of a new college which is 
the life sciences college. We already know that the risk of failure for business and engineering students are 0.144 and 0.164 respectively. The risk for students in the life sciences school is 20/202 = 0.099, 
which is smaller than the other two risks.
\begin{table}
	\caption{Count table showing number of failed and not failed courses for students in the business, engineering, and life sciences schools.} \label{table:countsecond}
	\centering
	\begin{tabular}{c |c c c| c}
	\hline
	{} & \multicolumn{3}{|c|}{College} & {} \\
	\hline
	\bf Failed & \bf Business & \bf Engineering & \bf Life Scences & \bf Total \\
	No & 208 & 158 & 182 & 548 \\
	Yes & 35 & 31 & 20 & 86 \\
	Total & 243 & 189 & 202 & 634 \\
	\hline
	\end{tabular}
\end{table}
Using these risks, we can also calculate the risk ratios. What is different is this case is that we can calculate two different risk ratios:

\centerline{\({Risk ratio}_1=0.144/0.164=0.878\)}

\centerline{\({Risk ratio}_2=0.099/0.164=0.604\)}

The first ratio is comparing the risk of business students to the risk of engineering students, while the second ratio is comparing the risk of life sciences students to the risk of engineering students. 
In both cases, the referent group is engineering students. It is up to you to pick and choose the referent category that suits your goals. In our case, the two risk ratios above are less than one, which indicates 
that the risk for both business and life sciences students is smaller than that of engineering students.

The above exercise is useful when we want to compare the risk across certain groups. This type of analysis however will not take us very far. The reason is that usually, we are interested in studying 
the effect that several variables have on the probability of the outcome. What if we wanted to see whether the risk of failure was affected by the college, gender, and the GPA, all at the same time? 
In this case, we need to use regression models.
\section{Poisson Regression}
First, you need to understand that there are several count models to choose from. The choice of the model depends on the data that we are analyzing. Usually, we start the analysis by assuming a Poisson model 
since this is considered to be the basic count model. In this type of regression, we are interested in the number of occurrences of a certain event, i.e. how many times a student will fail for example. As such, 
the dependent variable $\mu$ refers to the rate of occurrence or the expected number of times an event will occur. In order to visualize the distribution of a variable that follows the Poisson distribution, consider 
Figure ~\ref{fig:poissonall} which shows the probability distribution functions for different average rates. The y-axis represents the probability that a certain event will happen a certain number of times. For example, looking at 
the graph for mean = 1, we see that the probability of the event not happening at all (zero) or happening once is high, while the probability of the event happening four times is very low. 

tex*/
use poi, clear
texdoc stlog, cmdstrip
twoway connect yp1 yp2 yp3 yp9 y, graphregion(color(white)) msymbol(Oh Th Dh Sh) xtitle(Number of events) xlabel(0(1)11) ytitle(Probability)
texdoc stlog close
texdoc graph, caption(The Poisson distribution for different means.) label(fig:poissonall) figure(h!b) optargs(width=0.7\textwidth)
/*tex

If the expected average 
increases, i.e. the mean increases, then the probability of events happening more frequently also increases. This is why as the mean increases the graph starts to rise on the right side while dropping at the left side. 
The purpose of Poisson regression is to look at the factors that would increase the probability of an event happening more frequently.

In linear regression, the relationship between the dependent variable and the independent variable is formulated as:

\centerline{\(y = ax + b\)}

In the above equation, y is the dependent variable, x is the independent variable, a is the slope, and b is the y-intercept. One of the nice things about linear regression is how easy it is to interpret the 
relationship between the dependent variable and the independent variable. As an example, assume that we have the following linear equation:

\centerline{\(y = 3x + 2\)}

If x is equal to 2, y will be equal to 8, and if x is equal to 3, y will be equal to 11. Note that for every one unit increase in x, the value of y increases by 3, which is the value of the slope. This is the definition 
of the slope. It is the amount by which the dependent variable changes when the independent variable increases by one. The slope is important for two reasons. The first reason relates to the sign. If the slope 
is positive, then any increase in the independent variable will lead to an increase in the dependent variable. The more I eat, the heavier I get. If the slope is negative, then an increase in the independent variable 
will lead to a decrease in the dependent variable. The more I buy food, the less money I have.

The second reason relates to the magnitude of the slope. The larger the magnitude of the slope, the greater the effect that the independent variable has on the dependent variable. If the slope is 2, then a one unit 
increase in the independent variable will result in an increase of 2 in the dependent variable. If, however, the slope is 10, then a one unit increase in the independent variable will result in an increase of 10 in 
the dependent variable. So the sign of the slope tells us about the direction of the relation and the magnitude tells us about the magnitude of the effect that one variable might have on the other.

Unfortunately, in Poisson regression things are not that simple. The reason is that the Poisson regression model has the following form:

\centerline{\(\ln(\mu) = ax + b\)}

As already mentioned, $\mu$ is the rate of occurrences, which is the dependent variable. The above equation is linear, but instead of having the dependent variable on the left hand side we have the 
natural logarithm of the dependent variable. This means that the slope a represents the amount by which $\ln\mu$ increases when x increases by one unit. As you can see, this is not a natural way of 
interpreting things. Fortunately, there is something that we can do to make the interpretation more intuitive. All we need to do is to take the exponential of both sides:

$$e^{\ln(\mu)} = e^{ax+b}$$

$$\mu=e^{ax+b}$$

There is nothing complicated in what we did. We know from algebra that an equality is maintained when we perform the same operation to both sides. In our case, we first took the exponent of both sides. 
We then took advantage of the rule $e^{\ln(k)}=k$.

This new form is better because now the dependent variable, which is the rate $\mu$, is on the left side. For example, if a is positive, when x increases the term \(e^{ax+b}\) will increase. Since this term is 
equal to the rate of occurrence of the event, this means that the number of times that the event is expected to occur will also increase. On the other hand, when a is negative, when x increases the 
expected number of occurrences will decrease. 
\subsection{Continuous Variables}
Let us take an example. Assume that we perform Poisson regression where the dependent variable is the number of courses in which a student has failed and the independent variable is the GPA of the student. 
Basically, we want to see if having a higher GPA predicts fewer course failures. Assume that once the model was fit that we get the following equation:

$$ \ln(\mu)=-0.099(GPA)+7.091$$

What this means is that when the GPA of the student increases by one, the function $\ln(\mu)$ decreases by -0.099. Since, as we said, this is hard to understand, let’s consider the other more intuitive form:

$$ \mu = e^{-0.099(GPA)+7.091} $$

Now consider two students, one with a GPA of 77 and the other with a GPA of 78. According to our model, the expected number of withdrawals for each is:

Student with a GPA of 77: $ \mu=e^{-0.099(77)+7.091}=0.587 $

Student with a GPA of 78: $ \mu=e^{-0.099(78)+7.091}=0.532 $

This means that the expected number of failed courses for a student with a GPA of 77 is 0.587, and the expected number of failure courses for a student with a GPA of 77 is 0.532. To compare these 
two numbers, we can divide them in order to find the incidence-rate ratio:

Incidence-rate ratio: $ 0.532/0.587=0.906 $

What this means is that the expected count for a student with a GPA of 78 is 0.906 times the expected count of a student with a GPA of 77. The great news is that 0.906 is actually $e^{-0.099}$.  
We now have a very intuitive interpretation of the slope a. When we fit a Poisson model and obtain a value for the coefficient associated with an independent variable, we know that when the independent variable 
x increases by one unit, the expected number of occurrences is multiplied by $e^a$. When a is positive, $e^a>1$, which means that the expected number of occurrences increases when x increases. When a is negative, $e^a<1$, 
which means that the expected number of occurrences decreases when x increases.

As a recap, when we fit a Poisson model, we are finding a line with the equation \(ax + b\), just like in linear regression. The difference however is in the interpretation of the coefficient of x. In linear regression, 
when x increases by one unit, the dependent variable increases by the magnitude of a. In Poisson regression, when x increases by one unit, the expected number of occurrences are multiplied by $e^a$. If a is zero we have $e^0=1$, 
which means that the expected number of occurrences are multiplied by one, so they do not change. This means that x does not affect the expected number of occurrences. If a is greater than zero, then $e^a>1$, which means that 
the expected number of occurrences are multiplied by a number greater than one, so they increase. If a is less than zero, then $e^a<1$, which means that the expected number of occurrences are multiplied by a number that 
is less than one, so it decreases.

As another illustration, assume that we fit a Poisson model where the dependent variable is the number of customers that entered the store today, and where the independent variable is the number of advertisements that were 
ran on radio the preceding day. Once we fit the model we get the following results:

$$ \ln(\mu)=0.447(ads)+0.241 $$ 

Here, $\mu$ is the expected number of customers that will enter the shop. What does this output mean? Since the value of the coefficient associated with the independent variable, which is ads, is 0.447, 
this means that when ads increases by one, the expected number of customers is multiplied by $e^{0.447}=1.564$. This means if the shop runs five radio ads the expected number of customers that will come 
is 1.564 times the expected number of customers if it runs four ads.

As another example, consider that we fit a Poisson regression model where the dependent variable is the number of times that a student goes out with his or her friends during the week and the independent 
variable is the student’s grades. The output of the model is the following:

$$ \ln(\mu)=-0.073(grades)+6.629 $$

Here, the coefficient is negative. Since $e^{-0.073}=0.930$, the output indicates that the expected number of times that a student goes out during the week are multiplied by 0.93 (so they decrease) 
when grades increase by a single unit. This means that students with higher grades go out fewer times during the week. 

As you can see, when the coefficient is positive, the expected count increases, and when the coefficient is negative, the expected count decrease. Since we are mostly interested in the exponential of 
the coefficient, and not the coefficient itself, statistical software packages allows us to directly display the value $e^a$ instead of displaying the value of a. In that case, when $e^a$ is greater than one, 
the expected count increases, and when $e^a$ is less than one, the expected count decreases.
\subsection{Binary Variables}
So far, the independent variable has been numerical in nature. Sometimes however, including variables that are not numeric in nature is necessary. For example, what if we wanted to investigate whether the 
count of failed courses could be explained by the gender of the students? Here, the variable gender is not numeric. It is categorical, in that it divides the observations into categories. Since biological gender 
is either male or female, there are two categories in which each student might fall.

In such a case, we can create a binary variable to represent the two categories. A binary number takes on the values of zero or one. We next assign each of these values to a category. Let us assign a zero to males 
and a one to females. The data is shown in Table ~\ref{table:binaryfirst}.
\begin{table}[h!t]
	\caption{Records of students.} \label{table:binaryfirst}
	\centering
	\begin{tabular}{ c c c }
		\hline
		\bf Number of failed courses & \bf Gender & \bf Binary \\
		\hline
		2 & male & 0 \\
		0 & male & 0 \\
		3 & male & 0 \\
		0 & female & 1 \\
		2 & female & 1 \\
		3 & female & 1 \\
		8 & female & 1 \\
		0 & male & 0 \\
		5 & female & 1 \\
		7 & male & 0 \\
		5 & female & 1 \\
		3 & male & 0 \\
		1 & male & 0 \\
		1 & male & 0 \\
		2 & female & 1 \\
		9 & female & 1 \\
		5 & female & 1 \\
		4 & male & 0 \\
		4 & male & 0 \\
		2 & female & 1 \\
	\hline
	\end{tabular}
\end{table}
Now that the variable gender has been quantified, it is possible to include it in a regression model. The result of running a Poisson model would be again in the form:

$$ \ln(\mu)=ax+b $$

If we use a statistical software to run the model, we will get the following output:

$$ \ln(\mu)=0.495(gender)+0.916 $$

We already know how to interpret the coefficients of continuous variables, such as grades and number of advertisements. However, what does it mean that the coefficient of gender 
is 0.495? Remember that for males the value of gender is zero, while for females the value of gender is one. In order to calculate the expected count for a male and a female student, 
we need to use the form: 

$$ \mu=e^{0.495(gender)+0.916} $$

We can now calculate the expected count for each student:

Male: $ \mu=e^{0.495(0)+0.916}=2.499 $

Female: $ \mu=e^{0.495(1)+0.916}=4.1 $

From these expected counts, we can calculate the incidence-rate ratio:

Incidence-rate ratio: $ 4.1/2.499=1.64 $

This means that females have higher expected count than males. The nice thing is that the number 1.64 happens to be $e^{0.495}$. This means that when we are dealing with binary variables, 
the exponent of the coefficient is the incidence-rate ratio when we compare an individual who belongs to the group that is assigned a value of one and an individual who belongs to the group 
that is assigned the value zero. In our case, since males were assigned a value of zero, the exponent of the coefficient is the incidence-rate ratio that we obtain when we divide the expected 
count of females by the expected count of males. In other words, since the coefficient is 0.495, the expected count for females is 1.64 times the expected count for males.

Let us take another example. Assume that we run a Poisson regression model where the dependent variable is the number of goals a player scores, and where the independent variable is whether the 
player got a good night sleep the night before or not. The independent variable is binary (either you get a good night sleep or not), so we need to assign zero to a category and a one to the other 
category. In our case, let’s assign a zero to not getting a good night sleep and a one to getting a good night sleep. We fit the model and get the following result:

$$  \ln(\mu)=1.104(sleep)+0.357 $$

This means that the expected number of goals scored by those who get a good night sleep is $e^{1.104}=3.016$ times the expected number of goals scored by those who did not get a good night sleep.
\subsection{Multiple Independent Variables}
Now that we have seen how to interpret the output from Poisson regression when there is a single independent variable, let us see what changes when there are two independent variables. 
Table ~\ref{table:multi} shows the records for students. The table includes the dependent variable which is the number of courses in which the student has failed and the independent variables gender and GPA.
\begin{table}[h!t]
	\caption{The case of two independent variables.} \label{table:multi}
	\centering
	\begin{tabular}{ c c c c }
		\hline
		\bf Number of failed courses & \bf GPA & \bf Gender & \bf Binary \\
		\hline
		2 & 80 & male & 0 \\
		0 & 95 & male & 0 \\
		3 & 77 & male & 0 \\
		0 & 90 & female & 1 \\
		2 & 75 & female & 1 \\
		3 & 72 & female & 1 \\
		8 & 60 & female & 1 \\
		0 & 82 & male & 0 \\
		5 & 74 & female & 1 \\
		7 & 69 & male & 0 \\
		5 & 69 & female & 1 \\
		3 & 79 & male & 0 \\
		1 & 81 & male & 0 \\
		1 & 78 & male & 0 \\
		2 & 83 & female & 1 \\
		9 & 62 & female & 1 \\
		5 & 72 & female & 1 \\
		4 & 70 & male & 0 \\
		4 & 71 & male & 0 \\
		2 & 87 & female & 1 \\
	\hline
	\end{tabular}
\end{table}
Therefore, we have one binary variable and one continuous variable. In this case, we want to see if the dependent variable, which is the number of failed courses, depends on the gender of 
the student and on the GPA of the student. The equation of this model is:

$$ \ln(\mu)=a_1x_1 + a_2x_2 + b $$

Each independent variable has its own coefficient now. If we run the model, the output will be:

$$  \ln(\mu)=-0.086(GPA)+0.033(gender)+7.464 $$

Let us now calculate the expected count for two students where both of them have a GPA of 74, but one is male and the other is female. First, we use the more intuitive form of the equation:

$$  \mu=e^{-0.086(GPA)+0.033(gender)+7.464} $$

Male: $ \mu = e^{-0.086(74)+0.033(0)+7.464}=3.004 $

Female: $ \mu = e^{-0.086(74)+0.033(1)+7.464}=3.105 $

This means that the incidence-rate ratio is:

Incidence-rate ratio: $3.105/3.004=1.034$

A simpler way to get this value is just to calculate the exponent of the coefficient, $e^{0.033}=1.034$. This shows that even when there are several independent variables, the coefficients retain 
their meanings. Therefore, to find the difference between two groups of students, just calculate $e^{a_1}$. The implication of this is that in a multiple regression model where there are several 
independent variables, when we want to investigate the effect that an independent variable has on the dependent variable, we just need to take into consideration the coefficient of the independent 
variable, given that the rest of the variables do not change.

To further illustrate this, let us now calculate the expected count for two female students, one of whom has a GPA of 79 and another who has a GPA of 80:

GPA of 79: $  \mu = e^{-0.086(79)+0.033(1)+7.464}=2.02 $

GPA of 80: $ \mu = e^{-0.086(80)+0.033(1)+7.464}=1.853 $

This means that the incidence-rate ratio is:

Incidence-rate ratio: $1.853/2.02=0.917$

This is also obtained by finding the exponent of the coefficient, $e^{-0.086}=0.917$. Therefore, we see that when GPA increases by one, the expected count is multiplied by 0.917, which means that the 
expected count decreases.

This same logic applies whether we have three independent variables, four independent variables, or even nine independent variables. It also doesn’t matter whether the variables are binary or continuous. 
The coefficient of each independent variable gives us information about the relationship between the independent variable and the dependent variable. All we have to do is to take the exponent of the 
coefficient in order to calculate the effect that the independent variable has on the odds of the event happening.
\subsection{Categorical Variables with more than Two Categories}
If you recall, Table ~\ref{table:countcountfirst} presented data that included the variable college, which took on two values, business and engineering. In such a case, when we perform Poisson regression, we use a binary variable since the 
variable college can take on one of two values. What if we had a categorical variable that divided the observations into more than two groups? In this case, we cannot use a single binary variable because there are 
three groups instead of two. As an example, consider the data displayed in Table ~\ref{table:category}. 
\begin{table}
	\caption{Records of students.} \label{table:category}
	\centering
	\begin{tabular}{ c c}
		\hline
		\bf Number of failed courses & \bf College \\
		\hline
		3 & Business \\
		0 & Business \\
		5 & Business \\
		7 & Business \\
		1 & Engineering \\
		2 & Business \\
		2 & Business \\
		0 & Business \\
		4 & Engineering \\
		2 & Engineering \\
		5 & Engineering \\
		3 & Engineering \\
		8 & Business \\
		0 & Business \\
		1 & Engineering \\
		2 & Engineering \\
		3 & Business \\
		4 & Engineering \\
		5 & Business \\
		9 & Engineering \\
		0 & Life sciences \\
		1 & Life sciences \\
		1 & Life sciences \\
		3 & Life sciences \\
		5 & Life sciences \\
		4 & Life sciences \\
		3 & Life sciences \\
		1 & Life sciences \\
		2 & Life sciences \\
	\hline
	\end{tabular}
\end{table}
This is the same data that we used in Table ~\ref{table:countcountfirst} except that nine new records have been added for students in the college of life sciences 
(the count table for Table ~\ref{table:category} was actually used in Table ~\ref{table:countsecond}). This means that the variable college is no longer binary, since it can take on more than two values.

What we can do in this case, is to use more than one binary variable, as illustrated in Table ~\ref{table:codingcategory}. If you look at the column for the variable $x_1$, you will notice that the variable takes a value of one for 
business, and zero otherwise. The other binary variable, $x_2$, takes on a value of one for life sciences and zero otherwise.
\begin{table}
	\caption{Coding the categorical variable.} \label{table:codingcategory}
	\centering
	\begin{tabular}{ c c c}
		\hline
		{} & $\mathbf{x_1}$ & $\mathbf{x_2}$ \\
		\hline
		Engineering & 0 & 0 \\
		Business & 1 & 0 \\
		Life sciences & 0 & 1 \\
	\hline
	\end{tabular}
\end{table}
How did we know that we need three binary variables? The number of binary variables needed is the number of categories minus one. In our case, we have three categories, so it is 3 – 1 = 2. Table ~\ref{table:codedcategory} displays 
the result of this coding exercise.  
\begin{table}
	\caption{Records of students.} \label{table:codedcategory}
	\centering
	\begin{tabular}{ c c c c}
		\hline
		\bf Number of failed courses & \bf College & $\mathbf{x_1}$ & $\mathbf{x_2}$ \\
		\hline
		3 & Business & 1 & 0 \\
		0 & Business & 1 & 0 \\
		5 & Business & 1 & 0 \\
		7 & Business & 1 & 0 \\
		1 & Engineering & 0 & 0 \\
		2 & Business & 1 & 0 \\
		2 & Business & 1 & 0 \\
		0 & Business & 1 & 0 \\
		4 & Engineering & 0 & 0 \\
		2 & Engineering & 0 & 0 \\
		5 & Engineering & 0 & 0 \\
		3 & Engineering & 0 & 0 \\
		8 & Business & 1 & 0 \\
		0 & Business & 1 & 0 \\
		1 & Engineering & 0 & 0 \\
		2 & Engineering & 0 & 0 \\
		3 & Business & 1 & 0 \\
		4 & Engineering & 0 & 0 \\
		5 & Business & 1 & 0 \\
		9 & Engineering & 0 & 0 \\
		0 & Life sciences & 0 & 1 \\
		1 & Life sciences & 0 & 1 \\
		1 & Life sciences & 0 & 1 \\
		3 & Life sciences & 0 & 1 \\
		5 & Life sciences & 0 & 1 \\
		4 & Life sciences & 0 & 1 \\
		3 & Life sciences & 0 & 1 \\
		1 & Life sciences & 0 & 1 \\
		2 & Life sciences & 0 & 1 \\
	\hline
	\end{tabular}
\end{table}
The regression equation now becomes:

$$  \ln(\mu)=a_1x_1 + a_2x_2 + b $$

For an engineering student, $x_1$ and $x_2$ are zero. For a business student, $x_1$ is one and $x_2$ is zero. For a life sciences student only $x_1$ is zero and $x_2$ is one. If we fit this model, the output will be:

$$  \ln(\mu)=-0.079x_1-0.438x_2+1.237 $$

Let us now calculate the expected number of occurrences for each student. As usual, we use the more intuitive form of the equation:

$$  \mu = e^{-0.079(x_1)-0.438(x_2)+1.237} $$

Engineering: $ \mu=e^{-0.079(0)-0.438(0)+1.237}=3.445 $

Business: $ \mu=e^{-0.079(1)-0.438(0)+1.237}=3.184 $

Life Sciences: $ \mu=e^{-0.079(0)-0.438(1)+1.237}=2.223 $  

We can now calculate the incidence-rate ratios in order to be able to compare different groups:

Business/Engineering=$3.184/3.445=0.924$

Life sciences/Engineering=$2.223/3.445=0.645$

The above means that the expected number of failed courses for business students is 0.924 times the expected number of failed courses for engineering students, and that the expected number of failed 
courses for life sciences students is 0.645 times the expected number of failed courses for engineering students. We can get the same values by calculating the exponents of the coefficients:

$$ e^{-0.079}=0.924\, and\, e^{-0.438}=0.645 $$

We see that the exponent of the coefficient for each variable produces the incidence-rate ratio when we compare the group associated with the variable to the base group, which is the group that is 
assigned the values of zero. In other words, in our example, engineering students are the base, or referent group, since they have a value of zero for both $x_1$ and $x_2$. Business students have a value 
of one for $x_1$, which means that the exponent of the coefficient of $x_1$ is the incidence-rate ratio of business students to engineering students. Life sciences students have a value of one for $x_2$, which 
means that the exponent of the coefficient of $x_2$ is the incidence-rate ratio of life sciences students to engineering students. Therefore, just like in the case of binary variables, the coefficient compares 
a group to another group. The only difference here is that there is more than one binary variable, where each is associated with a different group. In both cases, the referent group is the same.
\subsection{Exposure}
There is an issue here which you have probably not noticed. In the previous section, we calculated the incidence-rate ratios when the categorical variable took on three values, business, engineering, and 
life sciences. This was done using Poisson regression. However, earlier in this book, we had calculated the incidence rate ratios for the exact same data using the count table (Table ~\ref{table:countsecond}). 
In both cases, although the same data was used, the results are different. To make comparison easier, Table ~\ref{table:compareexposure} shows the different values for the incidence-rate ratios obtained using each method.
\begin{table}
	\caption{Comparison of incidence-rate ratios when using count tables and when using Poisson regression.} \label{table:compareexposure}
	\centering
	\begin{tabular}{c c c}
		\hline
		{} & \bf Count tables & \bf Poisson regression \\
		\hline
		Business / Engineering & 0.878 & 0.924 \\
		Life sciences / Engineering & 0.604 & 0.645 \\
	\hline
	\end{tabular}
\end{table}
Why are the results different? The answer is actually simple. When we calculated the incidence-rate ratios using the count tables, we took into consideration the total number of courses taken by each group of 
students. In the count tables section, we did not compare the total number of failed courses for business students with the total number of failed courses for engineering students. We compared the proportion 
of failed courses for business students with the proportion of failed courses for engineering students (this is why we were dividing the number of failed courses by the total number of courses). This is an 
important point because the larger the number of courses taken by a group, the larger the expected number of failures. For example, a student who has taken twenty courses in university has a higher probability 
of having failed one of these courses than a student who has only taken two courses so far. We say that the first student was exposed to the risk of failure for a longer period time. Using the same logic, a player 
who spends more time on the field is expected to score more goals than a player who does not spend less time on the field. Someone who has smoked for thirty years is expected to have been hospitalized more than someone 
who has been smoking for one year. 

Because the concept of exposure is important, we need to tell the statistical package to take it into account when calculating the regression equation. So far, we have not been doing that. All what we have been 
doping is telling the statistical package to compare the number of occurrences while taking into consideration one or more independent variables.

Going back to the last regression model that we fit, we found that the equation was:

$$ \ln(\mu)=-0.079x_1-0.438x_2+1.237 $$

The above equation was obtained without taking into consideration the concept of exposure. Let us now tell the statistical software to take into account the exposure in each observation. In this case, 
the exposure is the total number of courses taken by each student. The data that includes the exposure variable is shown in Table ~\ref{table:exposure}.
\begin{table}
	\caption{Records that contain the exposure variable.} \label{table:exposure}
	\centering
	\begin{tabular}{c c c}
		\hline
		\bf Number of failed courses & \bf College & \bf Total number of courses \\
		\hline
		3 & Business & 23 \\
		0 & Business & 24 \\
		5 & Business & 30 \\
		7 & Business & 28 \\
		1 & Engineering & 6 \\
		2 & Business & 17 \\
		2 & Business & 15 \\
		0 & Business & 18 \\
		4 & Engineering & 27 \\
		2 & Engineering & 15 \\
		5 & Engineering & 28 \\
		3 & Engineering & 17 \\
		8 & Business & 27 \\
		0 & Business & 9 \\
		1 & Engineering & 27 \\
		2 & Engineering & 10 \\
		3 & Business & 20 \\
		4 & Engineering & 25 \\
		5 & Business & 32 \\
		9 & Engineering & 34 \\
		0 & Life sciences & 17 \\
		1 & Life sciences & 16 \\
		1 & Life sciences & 20 \\
		3 & Life sciences & 28 \\
		5 & Life sciences & 32 \\
		4 & Life sciences & 26 \\
		3 & Life sciences & 17 \\
		1 & Life sciences & 18 \\
		2 & Life sciences & 28 \\
	\hline
	\end{tabular}
\end{table}
Now we need to tell the statistical software to run a Poisson regression model using the number of failed courses as a dependent variable and college as an independent variable while taking into account that 
different students have gone through a different number of courses. The following is the output of this model:

$$ \ln(\mu)=-0.130x_1-0.505x_2-1.808 $$

We see that the equation has changed. Let us now calculate the expected number of occurrences for each student using the new output. As usual, we use the more intuitive form of the equation:

$$ \mu=e^{-0.130(x_1)-0.505(x_2)-1.808} $$

Engineering: $ \mu=e^{-0.130(0)-0.505(0)-1.808}=0.164 $

Business: $ \mu=e^{-0.130(1)-0.505(0)-1.808}=0.144 $

Life Sciences: $ \mu=e^{-0.130(0)-0.505(1)-1.808}=0.099 $

We can now calculate the incidence-rate ratios in order to be able to compare different groups:

Business/Engineering: $0.144/0.164=0.878$

Life sciences/Engineering: $0.099/0.164=0.604$

These are the exact same values we got when we calculated the incidence-rate ratios using the count tables (refer to Table ~\ref{table:exposure}). This exercise should illustrate why when running a count model, 
you need to account for the different exposure times in which each subject was exposed to the risk of the event happening.
\section{Negative Binomial Regression}
Although the Poisson regression model is the basic count model, it actually rarely fits the data because of what is referred to as overdispersion. An important characteristic of the Poisson probability density function 
is that the mean and the variance are equal. This means that as the mean increases, so does the variability in the data, a characteristic that is called equidispersion. When this assumption is violated, we say 
that the data displays overdispersion.

In order to address this issue, a negative binomial regression model is used. This model accounts for overdispersion by adding the parameter alpha to the equation. To illustrate the difference, 
look at Figure ~\ref{fig:poivsneg}. The figure shows the probability density function of both the negative binomial and the Poisson distributions (alpha is 1.5 in all plots). We see that in all plots, the negative binomial model 
allocates a higher probability for smaller counts, specifically the probability of a count of zero. Therefore, you can think of the negative binomial model as a correction to the under prediction of zero, or low, counts.

tex*/
twoway connect ynb1 yp12 y, msymbol(Oh Th) legend(size(vsmall) region(lstyle(none))) graphregion(color(white)) xtitle(Number of events) ytitle(Probability) xlabel(0(1)11) name(g1)
twoway connect ynb2 yp22 y, msymbol(Oh Th) legend(size(vsmall) region(lstyle(none))) graphregion(color(white)) xtitle(Number of events) ytitle(Probability) xlabel(0(1)11) name(g2)
twoway connect ynb3 yp32 y, msymbol(Oh Th) legend(size(vsmall) region(lstyle(none))) graphregion(color(white)) xtitle(Number of events) ytitle(Probability) xlabel(0(1)11) name(g3)
twoway connect ynb9 yp92 y, msymbol(Oh Th) legend(size(vsmall) region(lstyle(none))) graphregion(color(white)) xtitle(Number of events) ytitle(Probability) xlabel(0(1)11) name(g4)
texdoc stlog, cmdstrip
graph combine g1 g2 g3 g4, graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Poisson vs negative binomial at alpha = 1.5.) label(fig:poivsneg) figure(h!b) optargs(width=0.7\textwidth)
/*tex

What implication does this have for us? Fortunately, very little. Since we are not interested in the math that goes on behind the scenes, all you need to know is that when we fit a Poisson regression model, we 
should always follow it up with a negative binomial regression model in order to test whether overdispersion exists. The beauty of it all is that everything we have covered with regards to the meaning of the 
coefficients when adding the independent variables still applies the exact way. The output of a negative binomial model is very similar to the output of a Poisson model. We get the coefficients of the variables, 
and when we calculate $e^a$ we get the incidence-rate ratio. Nothing has changed.

So how do we test whether overdispersion exists? This is done by a likelihood-ratio test that tests the null hypothesis that alpha (which is the extra parameter that is included in the negative binomial model) 
is equal to zero. If we fail to reject the null hypothesis, we conclude that alpha is zero, and when alpha is zero we end up with the Poisson model. This means that there is no reason to believe that there is 
overdispersion. If, on the other hand, we reject the null hypothesis that alpha is zero, we conclude that the overdispersion exists and that the negative binomial model should be used instead of the Poisson model.

As an example, consider the data shown in Table Table ~\ref{table:exposure}. We have already fit a Poisson regression model on this data while taking into consideration the different exposure of each subject. 
The resulting model was:

$$ \ln(\mu)=-0.130x_1-0.505x_2-1.808 $$

If we fit a negative binomial model to the same dataset (while accounting for exposure), we get the following equation:

$$ \ln(\mu)=-0.130x_1-0.505x_2-1.808 $$

This is the exact same equation as before. The likelihood-ratio test that is produced automatically by the statistical software tells us that the p-value of the null hypothesis is 0.5, which is much larger than 
the cut-off value of 0.05. This means that we cannot reject the null hypothesis (that alpha is zero). The conclusion is that we should use the Poisson model.

Usually, the difference between the parameters of the Poisson model and the negative binomial model is in the p-vales of the coefficients and not the coefficients themselves. The p-values produced by a negative 
binomial model are larger than those produced by a Poisson model. The result is that a variable that is found to be statistically significant using a Poisson model will turn out not to be significant when a negative 
binomial model is used even though the value of the coefficient will be almost the same.
\section{Truncated Models}
Sometimes the data that we collect does not contain records with zero counts. An example is a dataset where the dependent variable is the number of semesters that a student spends in university. All students 
included in the dataset would have at least spent one semester in the university. As another example, I once received a dataset that contained the number of goals scored by each striker is various 
football (or soccer) leagues around the world. The data only contained records for players who had appeared on the scoresheet at least once, i.e. if a player never scored a goal, he was excluded from the list. 
This means that the minimum possible number of events was one and not zero. Figure ~\ref{fig:trunc} shows the histogram of the dependent variable, which is the total number of goals scored. In this case, the minimum is not one, 
but five. This means that the variable is truncated at the goals = 4 point.

tex*/
use trunc_goals, clear
texdoc stlog, cmdstrip nooutput
histogram goals, frequency discrete color(green) lcolor(black) graphregion(color(white)) xtitle(Goals)
texdoc stlog close
texdoc graph, caption(Histogram of a truncated variable.) label(fig:trunc) figure(h) optargs(width=0.7\textwidth)
/*tex  

In such cases, whether the data is zero-truncated or truncated at any other point, we use what is referred to as truncated models. These models take into account that a count that is less than a certain value is not 
possible. Once again, there is a truncated Poisson model and a truncated negative binomial model. Everything that we have said previously about the Poisson and the negative binomial models applies to the truncated 
models: the meaning of the coefficients, the incidence-rate ratios, and testing for overdispersion.
\section{Zero-Inflated Models}
When we discussed the negative binomial model, it was noted that the model corrects for the underprediction of zero counts. This is why in Figure ~\ref{fig:poivsneg} we saw that the probability of low counts, specifically zero, 
in the negative binomial model is greater than the probability of these counts in the Poisson model.

Sometimes the number of zeros in the dataset is much larger than what both the Poisson and the negative binomial model assume. In such a case, we say that the number of zeros is inflated, i.e. it is greater than usual. 
Why would the number of zeros be inflated? This might be due to an underlying mechanism that is acting like a hurdle. As an example, assume that we want to model the number of heart attacks that men under 45 have suffered. 
In such a case, we would expect that most men at such a young age would not have suffered from a heart attack. A normal male under 45 years of age should not have suffered from a heart attack. This means that the dataset 
would contain a disproportionately large number of zeros. In this case, we can think of the dataset as containing two different types of men: healthy men who have a zero count, and men with health issues who have a count 
that is greater than zero. 

When we have this type of situation, we use a zero-inflated model to account for the large number of zero counts. The math behind these models is not simple, so we will not get into it. However, it is very important to 
understand the idea behind these models, and this is what we will do now using the example of heart attacks for males under the age of 45.
\begin{itemize}
	\item Step 1: If a male is healthy and living under normal conditions, we would expect that he has had no heart attacks, i.e. the count is zero. For males that are unhealthy for their age, or who lead a 
					very stressful life, we would expect that the count would be greater than zero. This means that we can divide the observations into two groups. The members of the first group have a count of zero and the 
					members of the second group have a count that is greater than zero. To model this situation, we can think of a dependent variable that is binary: an individual is either in the first group or in the second group. 
					This is done by using a binary model that predicts the probability that the event has never occurred as opposed to it having occurred at least once.
	\item Step 2: After predicting whether an individual is in the first group (where the count is zero) or the second group (where the count is greater than zero), the analysis moves on to predicting the counts 
					for those in the second group. This is done by using a count model, such as a Poisson model or a negative binomial model.
\end{itemize}
As can be seen above, zero-inflated models are thus made up of two parts. The first part is a logistic model that predicts whether someone has never experienced the event or has experienced it at least once. 
The second part models the number of times that the event has been experienced by those who have experienced the event at least once. This is why the output of zero-inflated models is divided into two parts, one 
part for each model. The output helps us understand what are the independent variables that lead to someone being in either of the two groups, and what are the independent variables that increase the frequency of 
the count for those who have experienced the event. The two sets of the variables need not be the same. This means that the variables that determine to which group an individual belong can be different than the 
variables that lead to a higher count.

Going back to our heart attack example, assume that we have a variable that indicates how much someone smokes, since exposure to tobacco is one of the causes of heart attacks. If someone has never smoked, this would 
increase the probability that they will belong to the group that contains the zero counts. It might also be the case that the variable smoke also leads to a higher count of heart attacks, but this is not necessary the case. 
We might find that smoking increases the probability of someone suffering at least once from a heart attack but that smoking does not increase the frequency of heart attacks for those who have suffered from it at least once.

As another example, consider a dataset that contains the count variable visits which records the number of times that a patient visits the doctor in the past year. Assume that this variable has an unusually large 
number of zeros. This means, that many of the patients have had no need to visit the doctor during the past year. Also, assume that recently the hospital has modified its internal policies in order to increase the 
efficiency of their patient care. The purpose of these reforms is to make sure that the hospital staff are able to respond quickly and efficiently to the needs of the patients thereby reducing the number of subsequent 
visits from the same patient. In this case, we would expect that the new reforms would reduce the frequency of the counts, but they would not have an effect on whether a patient initially visits or not. In other words, 
the reforms do not make people healthier, so people will continue to visit their doctor. However, the reforms make sure that when a patient visits, there will be less need for subsequent visits in the short term.

To make this clearer, consider the output that is shown in Table ~\ref{table:zeroinflated}. This is a sample output from running a zero-inflated model where the dependent variable is the number of doctor visits during the past year. 
The variable male is a binary variable that indicates whether the individual is a male or not. The variable age records the age of the individual. Finally, the variable reform is a binary variable that indicates 
whether the observation is from the period before the reforms or after the reforms. We see that the output is divided into two parts, with the first part title “count” and the second part titled “inflate”. The “count” 
part is the regression output from modeling the count variable. The “inflate” part is the regression output from modeling the binary variable. The same three variables have been included in both parts in order to see 
which is significant and which is not.
\begin{table}
	\caption{Sample output of a zero-inflated model.} \label{table:zeroinflated}
	\centering
	\begin{tabular}{c c c c}
		\hline
		{} & \bf Coefficient & $\mathbf{e^{Coefficient}}$ & \bf P-value \\
		\hline
		Count & {} & {} & {} \\
		male & 0.20 & 1.22 & 0.07 \\
		age & 0.30 & 1.35 & 0.00 \\
		reform & -0.19 & 0.83 & 0.00 \\
		\hline
		Inflate & {} & {} & {} \\
		male & 0.64 & 1.90 & 0.01 \\
		age & -0.55 & 0.58 & 0.00 \\
		reform & 0.20 & 1.22 & 0.12 \\
	\hline
	\end{tabular}
\end{table}
Starting with the “count” part, we see that all three variables are significant (p-value is less than 0.05). Looking at t heir coefficients, we see that the coefficients of male and age are positive. 
This output is just regular count model output. As we were doing previously, all we need to do is to calculate $e^{Coefficient}$ in order to find the incidence-rate ratio. We see that males have an expected 
count that is 1.22 times that of females. This means that among those who visited the hospital, males visit the doctors more frequently. We also see that when age increases by one, the expected count is 
multiple by 1.35, so it increases. The coefficient of the variable reform is negative, with the incidence-rate ratio being 0.83. This means that among those who visited the hospital, patients who have visited 
the doctor after the reforms have an expected count that is 0.83 times the expected count of those who have visited the doctor before the reform. This means that the reforms have decreased the frequency of visits.

We now move onto the second part of the output which is titled “inflate”. The reason why it is called inflate is that we are investigating which variables are responsible for inflating the number of zeros. 
Looking at the p-values of the three variables, we see that only male and gender are significant. Since the “inflate” section presents the results of a binary regression, when we calculate $e^{Coefficient}$ we are 
finding the odds ratio (not the incidence-rate ratio). Looking at the table, we see that males have an odds that is 1.90 times the odds of females of not visiting the doctor. I have written “not visiting” in bold 
because what the second part is doing is testing which variables increase the odds of being in the zero group (this inflating the number of zeros) compared to the odds of being in the non-zero group. Since the 
coefficient of male is positive, it means that this variable increases the odds of being in the zero-group. Looking now at the coefficient of age, we see that it is negative. This means that when age increases, 
the odds of being in the zero-group decrease. Specifically, the odds of being in the zero-group are multiplied by 0.58 when age increases by one unit. This means that the older the patient is, the smaller the 
probability of him or her being in the zero group. Finally, the variable reform has a positive coefficient with an odds ratio of 1.22. This would mean that after the reforms, the odds of being in the zero-group 
are multiplied by 1.22 (so they increase). The result however is not significant.

As a recap, the results in Table ~\ref{table:zeroinflated} indicate that for the count model:
\begin{itemize}
	\item Among those who have visited the hospital during the past year, the expected number of visits for males is 1.22 times the expected number of visits of females
	\item Among those who have visited the hospital during the past year, the expected number of visits are multiplied by 1.35 when age increases by one year
	\item Among those who visited the hospital during the past year, the expected number of visits for those who came after the reform is 0.83 times the expected number of visits of those who came after the reforms.
\end{itemize}
With regards to the logistic model, the results indicate that:
\begin{itemize}
	\item The odds of males not visiting the doctor is 1.90 times the odds of females
	\item The odds of not visiting the doctor in the past year are multiplied by 0.58 when age increases by one year
	\item The reforms have no effect on the probability of a patient having visited the doctor during the past year
\end{itemize}
This example illustrates how the variables that are used in both parts of the model can be different. The variable that will increase the probability that we end up in the group with counts greater 
than zero might or might not be also responsible for increasing the frequency of the counts.
\section{Model Comparisons}
As you see, count data present an interesting dilemma, in that there are several models to choose from. So now the question becomes, how do we determine whether to use a Poisson model, a negative binomial model, 
a zero-inflated Poisson model, or a zero-inflated negative binomial model? Fortunately, there are several tests that we can use in order to help us make these decisions.
\subsection{Comparing Predicted Values with Observed Values}
In linear regression, one of the ways to see whether the model has a good fit or not is to plot the actual observed values of the dependent variable and the predicted values on the same graph. 
Ideally what we want is to see that the predicted values are very close to the observed values. We can use the same tool in count models. However, instead of plotting the observed probabilities and the predicted 
probabilities, we can plot the difference between them. This means that when we run the four models (Poisson, negative binomial, zero-inflated Poisson, and zero-inflated negative binomial), we calculate the probabilities 
as predicted by each model and then calculate the difference between these probabilities and between the observed probabilities. We then plot these differences on the same graph to see which model results in the 
smallest differences. Figure ~\ref{fig:modelcomparison} presents such a graph.

We see that the Poisson regression model (PRM) produces large differences with the observed probabilities for the counts zero, one and two. Clearly, this is not the right model to use. 
Looking at the other three models, we see that the zero-inflated negative binomial model (ZINB) and the negative binomial regression model (NBRM) produce the smallest differences, since their 
graphs are the closest to the zero axis.

tex*/
use count_project, clear
qui poisson total_fail gpa english i.college i.gender, exposure(total_courses)
mgen, stub(PRM) pr(0/9) meanpred
qui nbreg total_fail gpa english i.college i.gender, exposure(total_courses)
mgen, stub(NBRM) pr(0/9) meanpred
qui zip total_fail gpa english i.college i.gender, inflate(gpa college gender) exposure(total_courses)
mgen, stub(ZIP) pr(0/9) meanpred
qui zinb total_fail gpa english i.college i.gender, inflate(gpa college gender) exposure(total_courses)
mgen, stub(ZINB) pr(0/9) meanpred
gen PRMdiff = PRMpreq - PRMobeq
gen NBRMdiff = NBRMpreq - PRMobeq
gen ZIPdiff = ZIPpreq - PRMobeq
gen ZINBdiff = ZINBpreq - PRMobeq
texdoc stlog, cmdstrip
twoway connect PRMdiff NBRMdiff ZIPdiff ZINBdiff PRMval, graphregion(color(white)) color(green orange blue red) msymbol(Oh Th Dh Sh) xtitle(Count variable) ytitle(Average predicted probability) xlabel(0(1)9)
texdoc stlog close
texdoc graph, caption(Plotting differences between average observed and predicted counts after fitting all models.) label(fig:modelcomparison) figure(h) optargs(width=0.7\textwidth)
/*tex

\subsection{Likelihood-Ratio Test of Alpha}
It was previously stated that a likelihood-ratio test helps us decide whether we should use a Poisson model or a negative binomial model. This test can be used to compare the Poisson model to the 
negative binomial model, and it can also be used to compare the zero-inflated Poisson model to the zero-inflated negative binomial model. If the test results in a p-value that is less than 0.05, 
then we reject the null hypothesis that alpha = 0 and we conclude that overdispersion exists, thus justifying the use of the negative binomial model.
\subsection{Vuong Test}
The likelihood-ratio test for alpha allows us to compare the Poisson model to the negative binomial model. What if we wanted to compare the Poisson model to the zero-inflated model? 
In this case we use the Vuong test. Like the likelihood-ratio test, if the Vuong test produces a p-value that is less than 0.05, we conclude that the zero-inflated model should be used.
\subsection{AIC and BIC Statistics}
Another group of tests that can be used to compare two models are the information criteria fit tests. These statistics are only used to compare models. This means that calculating these statistics 
for a single model does not inform us about the goodness of fit of the model. Instead, we calculate the statistics for the two or more models that we wish to compare. The most commonly used form 
of statistics in this group are the AIC and BIC. These statistics can be easily calculated by statistical software. When comparing two models, we tend to favor the one with smaller values of both AIC and BIC statistics.
\section{Prediction}
Once we have determined the best-fit model, it is time to calculated predicted values. In linear regression we use the model in order to predict the dependent variable. In logistic regression, we use the model 
in order to predict the probability of an event happening. In count models, we can do both. First, we can predict the value of the dependent variable by predicting the number of events for certain values of the 
independent variables. For example, if we are modeling the number of courses in which a student has failed, we can use the best-fit model in order to predict the number of courses in which a student fails for several 
values of the independent variables. Take Figure ~\ref{fig:predictnumber} as an example. This figure shows the predicted number of events, which is course failures in this case, for students with different grades. As you can see, students with 
lower grades tend to fail more. As grades increase, the number of failed courses decrease. We also see that the graph starts to level off when the grades are above 80.

tex*/
qui poisson total_fail gpa english i.college i.gender, exposure(total_courses)
qui margins, at(gpa=(60(1)90))
texdoc stlog, cmdstrip nooutput
marginsplot, noci graphregion(color(white)) title("")
texdoc stlog close
texdoc graph, caption(Predicting the number of events.) label(fig:predictnumber) figure(h) optargs(width=0.7\textwidth)
/*tex

Second, we can use count models in order to predict the probabilities for several values of the count variable. For example, instead of predicting the number of events for certain values of a variable, we can 
predict the probability that the number of events will be a specific value. Figure ~\ref{fig:predictprob} shows an example of this. Unlike Figure ~\ref{fig:predictnumber}, Figure ~\ref{fig:predictprob} shows how the probability of failing in exactly four courses changes as 
the students’ grades change.

tex*/
qui margins, at(gpa=(60(1)90)) predict(pr(4))
texdoc stlog, cmdstrip nooutput
marginsplot, noci graphregion(color(white)) title("")
texdoc stlog close
texdoc graph, caption(Predicting the probability that an event will occur four times.) label(fig:predictprob) figure(h) optargs(width=0.7\textwidth)
/*tex

\chapter{Count Models - Case Study}
We now have the necessary tools that allow us to analyze a dataset where the dependent variable is a count. In this section, we will be looking at the dataset that contains the following variables:
\begin{itemize}
	\item id: unique student identifier
	\item gpa: overall GPA of the student
	\item total\_fail: the total number of courses in which the student has failed (this is the dependent variable)
	\item college: whether the student is in the engineering school or the business school (one means business, two means engineering)
	\item gender: whether the student is a male or a female (one means female, two means male)
	\item english: the average grade on all English courses taken by the student (data is taken from a non-English speaking country where the language of instruction in university is English)
	\item total\_courses: the total number of courses taken by the student so far in the university
\end{itemize}
\section{Univariable Tests}
The first thing that we should do when conducting regression analysis is to perform univariate analysis, where we try and uncover whether there is a relationship between the 
dependent variable and each independent variable separately. Once we have a good idea about the nature of these individual relationships, we can start building the model. 
In the case of count data, it is always a good idea to look at the histogram of the dependent variable in order to get an idea of the variable that we are dealing with. The histogram is displayed in 
Figure ~\ref{fig:histototalfail}. 

tex*/
texdoc stlog, cmdstrip nooutput
histogram total_fail, discrete color(green) lcolor(black) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Histogram of the dependent variable.) label(fig:histototalfail) figure(h) optargs(width=0.7\textwidth)
/*tex

As we can see, the variable is not normally distributed, an outcome that is expected when looking at count data. 
We also see that there is a large number of zeros, which leads us to suspect that perhaps a zero-inflated model should be eventually used.
\subsection{Continuous Variables}
In linear regression, when we have a continuous independent variable, we start our analysis by plotting a scatter plot. Graphs are also useful as a starting step in count models, 
but their shape is different from what we are used to due to the nature of the dependent variable. For example, let us produce a scatter plot of the dependent variable total\_fail 
and the continuous independent variable GPA. 

tex*/
texdoc stlog, cmdstrip nooutput
scatter total_fail gpa, mcolor(green) graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Scatterplot of total\_fail and GPA.) label(fig:scattertotalfail) figure(h) optargs(width=0.7\textwidth)
/*tex

The output is shown in Figure ~\ref{fig:scattertotalfail}. The graph isn’t visually appealing. The reason for this is that the outcome can only take on specific values. 
This is why we see that the points tend to cluster along the horizontal lines. However, if we look closely we see that when the GPA is around 80 and above, almost all of the points lie on the x-axis 
(the horizontal line that represents an outcome of zero). Therefore, it seems that students with high GPAs do not fail in courses.

In order to make things clearer, we can produce a smoothed scatter plot on top of the scatter plot. The resulting figure is shown in Figure ~\ref{fig:smoothedscattertotalfail}.  

tex*/
texdoc stlog, cmdstrip nooutput
twoway (scatter total_fail gpa, mcolor(green)) (lowess total_fail gpa), graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Smoothed scatterplot.) label(fig:smoothedscattertotalfail) figure(h) optargs(width=0.7\textwidth)
/*tex

As can be seen in the figure, as the GPA increases, there is a visible drop in the count variable.

We next fit a Poisson model where we specify total\_fail as the dependent variable and gpa as the independent variable.

tex*/
texdoc stlog, cmdstrip 
poisson total_fail gpa
texdoc stlog close
/*tex

Looking at the output, we see that the coefficient of the gpa is -0.095. Recalling what we covered in the theory section, this means that when GPA increases by one, 
the expected number of occurrences is multiplied by \(e^{-0.095}=0.909\).

Most statistical packages allow us to display the incidence-rate ratio instead of displaying the value of the coefficient.

tex*/
texdoc stlog, cmdstrip
poisson total_fail gpa, irr
texdoc stlog close
/*tex

We see that now the value 0.909 is displayed in the column titled “IRR”. We also see that the p-value is less than 0.05, hence the result is significant.

We have however, disregarded one important factor so far, and it is the exposure time. As you recall from the theory part of the course, we need to account for the fact that 
different subjects were exposed to the probability of the event occurring for different period of time. In our dataset, the variable total\_courses contains the total number 
of courses taken by the student. Statistical packages allow us to iclude an exposure variable. The output after dincluding total\_courses as ab exposure variable is shown below.

tex*/
texdoc stlog, cmdstrip
poisson total_fail gpa, irr exposure(total_courses)
texdoc stlog close
/*tex

As we can see, the value of IRR for the variable gpa is now slightly different. We also see that there is a new row in the regression table that contains the elements ln(total\_courses). 
From this point forward, we will be including the variable total\_courses as an exposure in all the output.

We next take a look at the other continuous variable in our dataset, which is the variable english:

tex*/
texdoc stlog, cmdstrip nooutput
twoway (scatter total_fail english, mcolor(green)) (lowess total_fail english), graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Smoothed scatterplot of total\_fail and english.) label(fig:smoothedscattertotalfail2) figure(h) optargs(width=0.7\textwidth)
/*tex

The scatter plot of the variable english and the dependent variable is shown in Figure ~\ref{fig:smoothedscattertotalfail2}. Once again we see evidence that as the value of english increases that the number of events decreases. 
This makes sense because if students don’t have a good grasp of the English language then they will have difficulties in passing subjects that are taught in English.

We next include the variable in a Poisson model:

tex*/
texdoc stlog, cmdstrip
poisson total_fail english, irr exposure(total_courses)
texdoc stlog close
/*tex

We see that when english increases by one, that the expected number of failed courses is multiplied by 0.889.
\subsection{Binary Variables} 
Now that we have seen how to analyze the relationship between the binary dependent variable and a continuous independent variable, we move onto other types of variables. 
Looking at our dataset, we notice that the variables gender and college are binary. Both take on two values. Let us include each of these two variable separately:

tex*/
texdoc stlog, cmdstrip
poisson total_fail i.college, irr exposure(total_courses)
texdoc stlog close
/*tex

Looking at the output, we see that the IRR is 0.818. What this means is that the expected number of course withdrawals for engineers is 0.818 times the expected number of course withdrawals 
for the reference group, which is business students in this case. We can also see that the result is significant at the p < 0.05 level.

We next include the binary variable gender:

tex*/
texdoc stlog, cmdstrip
poisson total_fail i.gender, irr exposure(total_courses)
texdoc stlog close
/*tex

We see that the expected number of failed courses for males is 2.845 times the expected number of failed courses for females.
\section{Multivariate Analysis} 
After looking at each independent variable by itself, we need to start building a more complex model. This means that we need a model that includes more than one independent variable. 
We start with a model that includes all the variables that were found to be significant when we conducted the univariate analysis:

tex*/
texdoc stlog, cmdstrip
poisson total_fail gpa english i.college i.gender, irr exposure(total_courses)
texdoc stlog close
/*tex

Looking at the model, we see that all variable retain their significance levels except for the variable college.
\section{Negative Binomial Regression}
Now it is time to see whether the data displays overdispersion. As you recall, when there is evidence that overdispersion exists, we will need to fit a negative binomial model 
that will estimate the new parameter alpha.

tex*/
texdoc stlog, cmdstrip
nbreg total_fail gpa english i.college i.gender, irr exposure(total_courses) nolog
texdoc stlog close
/*tex

Of primary importance for us is the last line in the output, the one which reports 
the result of the likelihood-ratio test with regards to the value of alpha. As you recall, a likelihood-ratio test is used to test the null hypothesis that alpha is equal to zero, 
which means that there is no overdispersion. Looking at our output, we see that the p-value is less than 0.05, thus leading to the rejection of the null hypothesis. 
We therefore conclude that there is overdispersion and that the negative binomial regression model should be used instead of the Poisson model.
\section{Zero-Inflated Models}
When we plotted the histogram of the dependent variables, we noted that the number of zeros seems to be too high. This means that perhaps a zero-inflated model would be of better use. 
The zero-inflated Poisson model is fit using the zip command and the zero-inflated negative binomial model is fit using the zinb command. Since we have found that there is overdispersion in the data, 
it would make sense for us to fit the zero-inflated negative binomial regression model:

tex*/
texdoc stlog, cmdstrip
zinb total_fail gpa english i.college i.gender, exposure(total_courses) ///
 inflate(gpa english i.college i.gender) nolog
texdoc stlog close
/*tex

As you recall from the theory part, 
the zero-inflated model is made up to two parts. One part is binary, in that it predicts whether an individual will be in the zero group or in the non-zero group. The other part is the count part, 
where the expected number of occurrences is predicted. What I have done here is that I have included all independent variables in both parts of the models in order to see which part do these variables affect.  
In other words, we want to see which variables might be causing the inflated number of zeros. We have included all variables because at the point we do not know which variables will be significant and 
which will not be significant.
 
Notice that the output is divided into two parts. The top part represents the count model regression, while the bottom part, titled “inflate”, represents the binary regression where we are trying to predict group 
membership (the zero-group vs the non-zero group). The following is very important. The bottom part is trying to see which variables are causing the inflated number of zeros. What this means is that if a variable has 
a positive value for the coefficient, then increasing values of this variable will increase the probability that the individual will end up in the zero-group. If you look at the variable gpa in the “inflate” section, 
you can see that the coefficient is 0.352, which is positive. This basically means that higher values of GPA will lead to an increase in the probability that the student will remain in the zero-group. This makes sense. 
Students with higher GPAs are more likely to fail in zero courses. We also see that the coefficient of english is positive. The same logic applies here. Higher grades on the English courses will increase the 
probability that the student will remain in the zero group.

Looking at the variable college, we see that the coefficient is negative. As you know, this is a binary variable, and the reference group here is business. What this coefficient means is that engineering students are 
less likely than business students to remain in the zero group. How much less likely? In count models, when we find \(e^{coefficient}\) we are finding the incidence-rate ratio. In logistic regression, when the dependent 
variable is binary, calculating \(e^{coefficient}\) gives us the odds ratio, which is the ratio of the odds that the event happens in one group compared to the reference group. In our case \(e^{-0.398}=0.672\). 
What this means is that the odds of an engineering student being in the zero group are 0.672 times the odds that a business student being in the zero group.

In some statistical packages, it is possible to request that the exponentiated coefficients be diplayed. The following table is an example:

tex*/
texdoc stlog, cmdstrip
listcoef
texdoc stlog close
/*tex

We see that the output continues to show the coefficients in the first column, in addition to the values \(e^{coefficient}\) in the column title \(e^b\). If you look at the variable college in the bottom part, 
you will see that the coefficient is -0.3982 and that the odds ratio is 0.672, just like we calculated.

We are interested in the p-values of the inflate part since we originally included all the independent variables in order to see which ones might be inflating the number of zeros. We had previously seen that 
that in the “inflate” part, only the variable gpa is significant. This would indicate that we might be better off fitting a model that only included gpa in the "inflate" part:

tex*/
texdoc stlog, cmdstrip
zinb total_fail gpa english i.college i.gender, exposure(total_courses) ///
inflate(gpa) nolog
texdoc stlog close
/*tex

The output shows that gpa is significant both as an inflation variable and as a count variable. The output also shows that the variable college is no longer significant.
\section{Comparing Count Models}
So which is it? Is it the negative binomial model or the zero-inflated binomial model? This is where we need to compare the four models: Poisson, negative binomial, zero-inflated Poisson, and zero-inflated negative binomial. 

As mentioned in the theory section, one way to compare the models is to produce a graph that displays the error produced by each model. What we do is that we calculate the predicted number of counts for each model and we compare
these predicted number of counts to the observed counts in the dataset. Such a graph is displayed in Figure ~\ref{fig:countfit}. 

tex*/
qui use count_project, clear
qui preserve
qui poisson total_fail gpa english i.college i.gender, exposure(total_courses)
mgen, stub(PRM) pr(0/9) meanpred
qui nbreg total_fail gpa english i.college i.gender, exposure(total_courses)
mgen, stub(NBRM) pr(0/9) meanpred
qui zip total_fail gpa english i.college i.gender, inflate(gpa) exposure(total_courses)
mgen, stub(ZIP) pr(0/9) meanpred
qui zinb total_fail gpa english i.college i.gender, inflate(gpa) exposure(total_courses)
mgen, stub(ZINB) pr(0/9) meanpred
gen PRMdiff = PRMpreq - PRMobeq
gen NBRMdiff = NBRMpreq - PRMobeq
gen ZIPdiff = ZIPpreq - PRMobeq
gen ZINBdiff = ZINBpreq - PRMobeq
texdoc stlog, cmdstrip
twoway connect PRMdiff NBRMdiff ZIPdiff ZINBdiff PRMval, graphregion(color(white)) color(green orange blue red) msymbol(Oh Th Dh Sh) xtitle(Count variable) ytitle(Average predicted probability) xlabel(0(1)9)
texdoc stlog close
texdoc graph, caption(Difference between observed and predicted values in each of the four models.) label(fig:countfit) figure(h) optargs(width=0.7\textwidth)
qui restore
/*tex

We see in the figure that the Poisson regression model (PRM) produces the largest differences between observed 
and predicted values, followed by the zero-inflated Poisson model (ZIP). The smallest deviations are produced by the negative binomial regression model (NBRM) and the zero-inflated negative binomial (ZINB) model, 
with the ZINB doing a slightly better job.

Another way to compare the four models is to look at the AIC and BIC statistics for each. As you recall from the theory part, we favor the model that produced the smallest values of these statistics. The following output 
displays side-by-side the output from each model, along with the AIC and BIC statistics of each:

tex*/
qui preserve
texdoc stlog, cmdstrip
countfit total_fail gpa english i.college i.gender, inflate(gpa) nograph nodifferences noprtable nofit
texdoc stlog close
qui restore
/*tex

In the first part, we see the exponentaited parameters for the four models. We note that the values are very similar across the models. Most importantly, the direction of the variables is the same. 
By direction I mean that the models agree whether a variable increases or decreases the counts. Since the values that are displayed are exponentiated, these are incidence-rate ratios. 
This means that values that are greater than one indicate that an increase in the variable will lead to an increase in the count, and a value that is less than one indicates that an increase in the variable
 will lead to a decrease in the count. We also see that the output includes an “inflate” section for the zero-inflated models. The output also contains the AIC and BIC goodness of fit statistics at the bottom. 
 Models that produce lower values of these statistics are considered a better fit. We see that the zero-inflated negative binomial model produces the lowest AIC and BIC statistics.

Therefore, it is safe to deduce that the zero-inflated negative binomial model is the best suited model to be used with this dataset.
\section{Visualizing the Results}
In my opinion, the best way to understand 
models is to summarize them using meaningful graphs. As an example, take the case of the independent GPA. We would like to know how the expedted number of failed courses changes with respect to changes in the value 
of student GPA. Let us start by plotting the relationship between the dependent variable and GPA. I would like to see how the expected number of failed courses changes when GPA varies from 60 to 100. 
The resulting graph is shown in Figure ~\ref{fig:margins1}.   

tex*/
qui zinb total_fail gpa english i.college i.gender, exposure(total_courses) inflate(gpa) nolog
qui margins, at(gpa=(60(1)100)) 
texdoc stlog, cmdstrip nooutput
marginsplot, noci graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Using marginsplot to visualize the relationship between the expected number of events and GPA.) label(fig:margins1) figure(h) optargs(width=0.7\textwidth)
/*tex

We see that there is a drop in the expected number of failed courses as GPA increases, and that this drop tends to level off when the GPA is above 80 since students with a GPA that is higher than 80 are expected to 
fail in zero courses. There is no difference between a student who has a GPA of 87 and one who has a GPA of 94.

We can go a step further and plot group differences across colleges for example. The result is shown in Figure ~\ref{fig:margins2}. 

tex*/
qui margins, at(gpa=(60(1)100) college=(1 2)) 
texdoc stlog, cmdstrip nooutput
marginsplot, noci graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Visualizing the effect that two variables have on the expected number of outcomes.) label(fig:margins2) figure(h) optargs(width=0.7\textwidth)
/*tex

 We see that the differences between engineering students and business students is actually small (as you recall, the result is not significant), 
and that these differences vanish for students with high GPAs.

Not only can we visualize the expected number of events, but we can also visualize the probability that the event will occur a certain number of times. For example, assume that we want to calculate the probability
 that a student will fail in four courses for different values of the variable gpa and for each of the genders. Such a graph is shown in Figure ~\ref{fig:margins3}. If you look at the title of the y-axis, Stata is 
 clearly telling us that the predicted values are the probabilities that the total failed courses is equal to four.  
 
tex*/
qui margins, at(gpa=(60(1)100) gender=(1 2)) predict(pr(4)) 
texdoc stlog, cmdstrip nooutput
marginsplot, noci graphregion(color(white))
texdoc stlog close
texdoc graph, caption(Plotting the probability that the event will occur exactly four times.) label(fig:margins3) figure(h) optargs(width=0.7\textwidth)
/*tex

\chapter{Factor Analysis - The Theory}
\section{Introduction}
In statistics, we are interested in recording the values of certain variables. For example, if we wanted to study the academic performance of 
students, then we would record the GPA values. If we wanted to measure the performance of the defence of a certain sports team then we would
record the number of goals that the team has conceded. In these instances, the variable that we are measure is easily quantified. However, what if
we wanted to measure something that was more abstract? For example, what if we wanted to measure an invdividual's time management skills? How can
we do this? What is the number that represents someone's time management skills? 

In cases such as these, we need to resort to measuring the variable of interest using a set of questions. For example, we might ask the individual
to rate himself or herself on the following:

"I am not easily distracted when I am working on something important."

"I do not find it difficult to work on projects that require a lot of effort even if the due date is close."

"I would rather work on important work now even if I do not find it enjoyable instead of do something that I enjoy."

"I find it easy to plan my week ahead of schedule"

We would expect that an individual who has good time management skills would tend to agree with the above four statements while an individual
with weak time management skills would tend to disagree with the statements. In this case, we are measuring time management skills using more than one
question, or more than one variable. The respondents might be asked to answer on a scale of one to five (strongly disagree, disagree, neutral, agree,
strongly disagree) or even on a scale of one to seven. 

This is where factor analysis is used. It is used to measure variables that cannot be captured by a single question or number. In this case, the 
variable of interest, which is time management skills in this case, is made up of, or constructed from, several other variables. This is why such
variables are referred to as constructs. Factor analysis allows us to calculate a single value from the responses of the above questions for each
individual. This way we can quantify the construct "time management skills". 

\section{Example: Masculinity}
As an example, consider that we might want to measure how masculine someone is. Usually, traits that are associated with men include competitivness, 
risk taking behavior, and individualism. Therefore, in order to measure the consctruct "Masculinity", we might ask the respondents to rate
themselves on the traits found in Table ~\ref{table:masculine1}. We would expect that masculine individuals would state that the traits apply to them
while individuals who are not masculine would state that the traits to do not apply to them.  

\begin{table}[h!t]
	\caption{Masculine Traits.} \label{table:masculine1}
	\centering
	\begin{tabular}{c |c c c c c c c|}
	\hline
	{Trait} & \multicolumn{7}{|c|}{(1) Not at all, (7) Applies to me a lot} \\
	\hline
	assertive & 1 & 2 & 3 & 4 & 5 & 6 & 7 \\
	competitive & 1 & 2 & 3 & 4 & 5 & 6 & 7 \\
	dominant & 1 & 2 & 3 & 4 & 5 & 6 & 7 \\
	makes decisions easily & 1 & 2 & 3 & 4 & 5 & 6 & 7 \\
	individualistic & 1 & 2 & 3 & 4 & 5 & 6 & 7 \\
	\hline
	\end{tabular}
\end{table}

\section{Reliability}
After we gather the responses of the individuals we would need to calculate the value of the construct "Masculinity". However, before we do this, it
is very important that we test what is called the reliability of the instrument. Here the word instrument refers to the instrument, or tool, that we
used to measure the construct, which is simply the five questions shown in Table ~\ref{table:masculine1}. 

What do we mean by reliability? Simply that the questions being asked are actually measuring the same construct. We claimed that rating to what
extent the five traits apply to you are a way of measuring the single construct Masculinity, but is this claim plausible? If the five traits do
actually measure the same construct, then we would expect that individuals in general would respondent in a smilar fashion to all of the questions.
For example, if the instrument used is reliable, then an individual who beleives thet he or she is assertive would also beleive that he or she is
competitive, dominant and individualistic. If an individual is not masculine, then they would rate themselves on the lower level of the scale on all
traits. If all the questions are measuring the same construct, then the answers should be correlated. An instrument that is not reliable would
result in an individual rating himself as assertive, competitive, but neither dominant nor individualistic. If this is the case, then this would 
cast doubt on our claim that the questions are measuring the same construct. Therefore, a reliable instrument is one in which the answers are
correlated. 

Once we establish the instruments reliability, we can use the results obtained from it to calculate the value of the construct. How do we measure
the instrument's reliability? There are several measures, but the one that is most widely used is Conbach's alpha. What we do is we ask the 
statistical software to calculate Cronbach's alpha for us. This statistic is basically how we measure the average correlation between the items.
Values greater than 0.7 indicate a reliable instrument while values that are less than 0.7 indicate that the instrument as it stands is not
reliable.

What do we do if we calculate Cronbach;s alpha and find it to be less than 0.7? Do we throw away our dataset? Fortunately no. Sometimes, a small
number of items in the instrument would be causing most of the problem. It might be the case that most items are actually measuring the same
construct and thus have a high correlation while one or two other items seem to be asking different questions. In such a case what we can do
is to identify these problematic items and to remove them altogether from the dataset. Fortunately for us, statistical software make it very
easy to do that as we will see later.

\section{Calculating the Value of the Construct}
Once the reliability of the instrument is supported, we can go ahead and calculate the value of the construct. It is possible for someone to 
simply calculate the value of Mascilinity by finding the average of the responses to the five items shown in Table ~\ref{table:masculine1}. 
The higher the average, the more masciline the individual is. This is perfectly fine if we want to treat all items equally relevant. However,
it so happens that in most cases, certain items in an instrument might be more relevant than others. Therefore, instead of simply calculating the 
average, we can weight each item according to how relevant it is to the construct being measured. The question therefore becomes, how do we measure
the relevance of each item?

\subsection{Factor Analysis}
This is where factor analysis comes in. By performing factor analysis, we are able to "extract" the factor (which represents our latent variable)
and to calculate the "loading" of each item on the construct being measured. The loading is a number between zero and one. The closer the value to 
one, the more relevant the item is. 

There is one issue here and it deals with how do we extract the factor and how do we calculate the loadings of each item on the factor? This can
be accomplished using \textbf{principal component analysis} and \textbf{common factor analysis}. The main difference between the two methods is that principal component analysis tries to account for all the variance that is
observed in the items while common factor analysis tries to account only for the variance that the items share in common. What does this mean? If you
recall, the respondent is answering a set of questions. Different respondents will have different answers. Some might indicate that the trait 
"assertive" applies to them a lot (7) while others might indicate that it somehow applies to them (4). Therefore, the answers will vary. In principal
component analysis, we try to find the factor that account for all the variance in the responses while in common factor analysis we try to find
the factor that will account for the shared variance, since sometimes different items migth vary the same way from respondent to respondent while
other times they might vary differently.

So which is better? The more widely used method of the two is principal component analysis and it is usually the default in many statistical
packages. As a first step in analyzing the data, it is recommended to use principal component analysis. Note that the output generated from
both principal component analysis and from common factor analysis looks the same. We will see a factor (or factors as we will see later on) and 
we will also see the loading that each item has on the factor. These loadings are always between zero and one.

As an example, assume that we performed principal component analysis on the dataset that contains the items shown in Table ~\ref{table:masculine1}. 
The result is shown in Table ~\ref{table:factormasculine1}. 

\begin{table}[h!t]
	\caption{Loadings of the Masculine Traits.} \label{table:factormasculine1}
	\centering
	\begin{tabular}{c c}
	\hline
	{Variable} & {Factor} \\
	\hline
	assertive & 0.6914 \\
	competitive & 0.6554 \\
	dominant & 0.7836 \\
	individualistic & 0.6122 \\
	makes decisions easily & 0.6873 \\
	\hline
	\end{tabular}
\end{table}

The loadings for each item represents the correlation between the item and the construct that is being measured, or the factor. The higher the loading
the more relevant the item is because a high loading means a high correlation. In general, loadings of 0.4 or greater are taken to be substantial.
If an item has a loading that is less than 0.4, then this is taken to mean that the item is not sufficiently correlated with the construct and as 
such is not relevant. Such items are usually dropped from the analysis. If we square the loading then we find the percent of variance in the item 
that is explained by the factor. So for example, we see that the item "assertive" has a loading of 0.6914 on the factor. This means that 
$0.6914^{2}$, or 47.8\% of the variance in assertive is explained by the factor.  

Looking at Table ~\ref{table:masculine1} we see that all loadings are larger than 0.4. In fact, the smallest loading is 0.6554. This is a good sign
and indicates that all items are relevant. The most relevant item is "dominant" with a loading of 0.7836 and the least relevant is competitive
with a loading of 0.6554.

There is one problem however. It was mentioned before that principal component analysis aims at accounting for all the variance in the items. However,
we see in Table ~\ref{table:factormasculine1} that the factor explains much less than 100\% of the variance of each item. Remember, the variance
of each item that is explained is simply the square of the loading of that item on the factor. As calculated above, the factor explains 47.8\% of
the variance in the item that measures assertiveness. A similar calculation would show that the factor explains $0.6554^2=42.95\%$ of the item 
"competitive". How come? What about the rest of the variance that is supposed to be explained? The reality is that Table ~\ref{table:masculine1} 
does not show the entire output from performing principal component analysis. To see the whole picture, we need to realise factor analysis results
in more than one factor as we will see now.

\subsection{All the Factors}
When we perform factor analysis, the result will always be more than one factor where each factor explains a percent of the variance for each item.
The sum of the total variance for each item that is explained by all factors will be 100\%. At this point you might think that this means that 
our analysis has been useless because we claimed that the items are all measuring the same construct, which is "Masculinity". If we have more than
one factor, then this means that the items are not measuring the same construct. This is logically true only if the "extra" factors are worth looking
at. The number of factors extracted trough principal component analysis will always be equal to the number of items. Since we have five items,
performing principal component analysis will result in five factors. This, however, is not the end of the story. Once we have the factors we need to
determine which ones are worth keeping, i.e. which factors explain a considerable percent of the variance, and which ones explain very little. To do
that we look at the \textbf{eigenvalues} of the extracted factors. The eigenvalue simply represents the total variance of all items that is explained
by the factor. In other words, it is the sum of the square of the loading of each item. Looking at Table ~\ref{table:factormasculine1}, we calculate
the eigenvalue of the factor to be $0.6914^2+0.6554^2+0.7836^2+0.6122^2+0.6873^2=2.3688$. As you recall, when we square each loading, we find the
percent of the variance of the item that is explained by the factor. By adding these terms, we get the eigenvalue, which is the sum of the explained
variances. If the eigenvalue is greater than one, then the factor is beleived to explain a considerable amount of the variance. An eigenvalue
that is less than one means that the factor is not explaining a considerable amount of the variance. In our case, performing principal component
analysis resulted in five factors, since we have five items. However, only one of these factors had an eigenvalue that is greater than one (almost
2.37 actually). The other four factors have eigenvalues that are much less than one. We therefore only retain one factor and simply ignore the other
four. 

The finding that only a single factor has an eigenvalue that is greater than one is very important. By retaining only one factor, we are basically
stating that all the items are measuring a single construct, which is what we wanted.  

We now have found a single factor and we have also calculated the loading of each item on the factor. The next step is to use these loadings
in order to tell the statistical software to calculate the value of the factor for each respondent by taking into consideration the loading of 
each item on that factor. As you recall, unlike calculating the average, factor analysis allows us to calculate a score while taking into account
the relevance of each item, which is represented by the loading. This will allow us to arrive at our goal, which is to find a single number, or score,
to measure a respondents "Masculinity". 

\subsection{The Scores}
The result will be a score for each respondent where the average of all scores is zero and the variance is one. This means that the score is 
standardized. Positive values indicate that an individual scores above the average, i.e. is more masculine than the average respondent, while 
negative scores indicate an individual score below the average, i.e. is less masculine than the average respondent.

So now what? Basically, we now have a number that scores each respondent on "Masculinity". Figure ~\ref{fig:hist1} shows the histogram of the scores
that we obtain. We see that the majority of scores lie between -1 and +1. There are however, some individuals who are "very" masculine, with scores
greater than 1 and some score very low on mascilinity with scores less than -1. 

tex*/
qui use masculine, clear
qui factor assertive-makes, pcf
qui predict the_scores 
texdoc stlog, cmdstrip nooutput
histogram the_scores, scheme(lean1) color(green) lcolor(black) percent
texdoc stlog close
texdoc graph, caption(Histogram of the scores.) label(fig:hist1) figure(h) optargs(width=0.7\textwidth)
/*tex

Assume that, in addition to the five items measured in our instrument, we have also recorded the gender of each respondents. This way we can 
inventigate whether males are more "masculine" then females. Figure ~\ref{fig:histgender} shows the histograms for both males and females. We note
that some females have a high score on masculinity and that some males have a low score. However, the proportion of females with a low score is
larger than that of males. 

tex*/ 
texdoc stlog, cmdstrip nooutput
histogram the_scores, by(gender) scheme(lean1) color(green) lcolor(black) percent
texdoc stlog close
texdoc graph, caption(Histogram of the scores.) label(fig:histgender) figure(h) optargs(width=0.7\textwidth)
/*tex 

\section{Multidimensions}
The analysis so far has been pretty simple. We have a small number of items (five) that were all intended to be measuring just a single construct, 
which is masculinity. Reality is usually more complicated than this. In general, when social scientists work on questionnairs, there are many
questions where each set of question is intended to be measuring a different construct. In other words, in more cases than none, we would have 
items that are measuring more than one construct. In this case, the factor analysis should extract more than one factor where different items
load on different factors.

As an example, let us continue with the case of masculinity. Assume now that the survey that we distributed to respondents actually contained
eleven items shown in Table ~\ref{table:masculinefeminine}. We see that we have the original five items which we claimed measured masculinity, but in
addition we also have six other items which measure how affectionate, compassionate, gentle, underdstanding, sympathetic, and sensitive the 
individual is. Looking at these items, it should be clear that we are no longer just measuring traits which are asosciated with "masculinity". In fact,
one might argue that the new traits are traditionally assiated with femininity. If this was true, then we would expect that by performing factor
analysis we would get two factors where the first five items load on one factor and the next six items load on another factor. We could then call
the first factor "Masulinity" and the second factor "Femininity". 

\begin{table}[h!t]
	\caption{Masculine and Feminine Traits.} \label{table:masculinefeminine}
	\centering
	\begin{tabular}{c |c c c c c c c|}
	\hline
	{Trait} & \multicolumn{7}{|c|}{(1) Not at all, (7) Applies to me a lot} \\
	\hline
	assertive & 1 & 2 & 3 & 4 & 5 & 6 & 7 \\
	competitive & 1 & 2 & 3 & 4 & 5 & 6 & 7 \\
	dominant & 1 & 2 & 3 & 4 & 5 & 6 & 7 \\
	individualistic & 1 & 2 & 3 & 4 & 5 & 6 & 7 \\
	makes decisions easily & 1 & 2 & 3 & 4 & 5 & 6 & 7 \\
	affectionate & 1 & 2 & 3 & 4 & 5 & 6 & 7 \\
	compassionate & 1 & 2 & 3 & 4 & 5 & 6 & 7 \\
	gentle & 1 & 2 & 3 & 4 & 5 & 6 & 7 \\
	understanding & 1 & 2 & 3 & 4 & 5 & 6 & 7 \\
	sympathetic & 1 & 2 & 3 & 4 & 5 & 6 & 7 \\
	sensitive & 1 & 2 & 3 & 4 & 5 & 6 & 7 \\
	\hline
	\end{tabular}
\end{table}

If we do perform principal component analysis on these eleven items, we would find that there are only two factors with en eigenvalue that is 
greater than one. This means that we retain these two factors and ignore the other ones. Table ~\ref{table:factormasculinefeminine} shows the 
loading of each item on both factors.

\begin{table}[h!t]
	\caption{Loadings of the Masculine and Feminine Traits.} \label{table:factormasculinefeminine}
	\centering
	\begin{tabular}{c c c}
	\hline
	{Variable} & {Factor1} & {Factor2} \\
	\hline
	assertive & 0.5061 & 0.4768\\
	competitive & 0.5625 &  0.3496\\
	dominant & 0.4077 &  0.6821\\
	individualistic & 0.2947 & 0.5693 \\
	makes decisions easily & 0.3970 & 0.5675 \\
	affectionate & 0.7359 & -0.1447 \\
	compassionate & 0.7208 & -0.2642 \\
	gentle & 0.6631 & -0.3908 \\
	understanding &  0.5944 & -0.2515 \\
	sympathetic & 0.6559 & -0.3320 \\
	sensitive & 0.6285 & -0.2957 \\
	\hline
	\end{tabular}
\end{table}

Looking at Table ~\ref{table:factormasculinefeminine} we notice that the result is not what we expected. As you recall, it was stated earlier that
a loading that is greater than 0.4 is taken to be substantial. We see that almost all items have a substantial loading on the first factor. This
is not what we expected since we beleived that the eleven items are measuring two different things, masculinity and femininity. To complicate
matters further, we also see that some items, such as assertive and dominant have substantial loadings on both factors. Does this mean that these
items are measuring two different constructs? 

The above results are actually nor surprising when we take into consideration that we have ommitted a very important step. Whenever we have
items that are measuring different constructs, in other words, when two or more factors are involved, we need to \textbf{rotate} the factors
in order to obtain the "proper" loadings of each item on each of the factors. But what is rotation and why do we have to do it? 

\subsection{Rotation}
In order to understand what rotation is, we will need to understand how principal component analysis works. The primary thing to know about it is 
that principal component analysis works by first finding the \textbf{first principal component}, then the \textbf{second principal component} and
so on. The first principal component is the factor that explains as much of the observed variation as possible. The second principal component
is the factor that explains as much of the remaining observed variation (the variation that was not explained by the first factor). The third
principal component is the one that would explain the variation that the first two components did not explain. What this means is that principal
component analysis will always try to find a general factor that explains all the variation first. Therefore, the result will be a principal factor
on which all items have substantial loadings. You can visualize this using Figure ~\ref{figure:principalfactor}. In the figure, the eleven items are
represented using vectors. We see that the vectors that represent the five masculine traits group together and the vectors that represent the 
feminine traits group together. When we perform factor analysis, the statistical software will try to extract the first principal component, which
is the factor that explains the variation observed in all items. As can be seen in the figure, the principal component goes through the middle of
all items in such a way that it is as close as possible to all eleven vectors which represent the eleven items.   

\begin{figure}[!h]
\centering
\begin{tikzpicture}
\draw[->, ultra thick, black] (0,0) -- (2,5) node[above]{$First Principal factor$};
\draw[->](0,0) -- (-3,4) node[above]{five masculine traits};
\draw[->](0,0) -- (-2.5,4);
\draw[->](0,0) -- (-2,4);
\draw[->](0,0) -- (-1.5,4);
\draw[->](0,0) -- (-1,4);
\draw[->](0,0) -- (6,4) node[above]{six feminine traits};
\draw[->](0,0) -- (5.5,4);
\draw[->](0,0) -- (5,4);
\draw[->](0,0) -- (4.5,4);
\draw[->](0,0) -- (4,4);
\draw[->](0,0) -- (3.7,4);
\end{tikzpicture} 
\caption{Finding the principal factor that explains all variation}
\label{figure:principalfactor}
\end{figure}

Once the principal component is found, the statistical software will then go ahead and try to extract a second factor, the second principal component,
which explains the remaining variation that was not explained by the first vector. This second principal component must be perpendicular to the first.
Figure ~\ref{figure:secondprincipalfactor} shows the addition of the second prinipal factor. In our case, since only two factors had an eigenvalue that
is greater than one, the software decided to stop there and concluded that the first two principal factors are enough. Since the first factor was
the one that explained as much variation as possible for all items, the result as that almost all of the items had a sufficiently large loading
on that factor (Table ~\ref{table:factormasculinefeminine}). The second principal component was then computed in order to account for the remaining
unexplained variation. Since the first factor had already accounted for much of the variation, only some of the items ended up with sufficiently
large loadings on the second principal component. 

\begin{figure}[!h]
\centering
\begin{tikzpicture}
\draw[->, ultra thick, black] (0,0) -- (2,5) node[above]{$First Principal factor$};
\draw[->, ultra thick, black] (0,0) -- (5,-2) node[below]{$Second Principal factor$};
\draw[->](0,0) -- (-3,4) node[above]{five masculine traits};
\draw[->](0,0) -- (-2.5,4);
\draw[->](0,0) -- (-2,4);
\draw[->](0,0) -- (-1.5,4);
\draw[->](0,0) -- (-1,4);
\draw[->](0,0) -- (6,4) node[above]{six feminine traits};
\draw[->](0,0) -- (5.5,4);
\draw[->](0,0) -- (5,4);
\draw[->](0,0) -- (4.5,4);
\draw[->](0,0) -- (4,4);
\draw[->](0,0) -- (3.7,4);
\end{tikzpicture} 
\caption{Finding the second principal factor that explains the remaining variation}
\label{figure:secondprincipalfactor}
\end{figure}

The above vidual explanation helps us understand what goes on when the software is finding the principal components. Now comes the issue of rotation.
Figure ~\ref{figure:secondprincipalfactor} shows the first and second principal components. The problem is that when the first component was extracted
the software was attemtping to explain the variation in all items at the same time. Rotation is used in order to position the principal components
in a more meanigful way. Imagine that we now rotate the first and second principal components anti-clockwise. This rotation is illustrated in 
Figure ~\ref{figure:rotate}. We now have a more accurate representation of the factors where we see that each factor represents the two different 
clusters of items. 

\begin{figure}[!h]
\centering
\begin{tikzpicture}
\draw[->, dotted, black] (0,0) -- (2,5);
\draw[->, dotted, black] (0,0) -- (5,-2);
\draw[->, ultra thick, black, rotate=30] (0,0) -- (0,7) node[above]{$First Principal factor$};;
\draw[->, ultra thick, black, rotate=30] (0,0) -- (7,0) node[anchor=west]{$Second Principal factor$};;
\path[->] (4,6) edge [ultra thick, dotted, black, bend right=45] node[above]{$Rotate$} (-2, 7);
\draw[->](0,0) -- (-3,4) node[above]{five masculine traits};
\draw[->](0,0) -- (-2.5,4);
\draw[->](0,0) -- (-2,4);
\draw[->](0,0) -- (-1.5,4);
\draw[->](0,0) -- (-1,4);
\draw[->](0,0) -- (6,4) node[above]{six feminine traits};
\draw[->](0,0) -- (5.5,4);
\draw[->](0,0) -- (5,4);
\draw[->](0,0) -- (4.5,4);
\draw[->](0,0) -- (4,4);
\draw[->](0,0) -- (3.7,4);
\end{tikzpicture} 
\caption{Rotating the principal components}
\label{figure:rotate}
\end{figure} 

Once we rotate the factors, we will get the loadings that are shown in Table ~\ref{table:rotatefactormasculinefeminine}. Looking at the table, we
finally see the results that we were expecting. The items assertive, competitive, dominant, makes decisions easity, and individualistic have a
loading that is greater than 0.4 on one factor (factor 2) with all corresponding loadings on the other factor (factor 1) being less than 0.4. The remainign items on the
other hand (affectionate, compassionate, gentle, understanding, sympathetic, and sensitive) have loadings that are greater than 0.4 on factor 1 while
having small loadings on factor 2. We now see that the different groups of items load on different factors. This is the result that we were
expecting.  

\begin{table}[h!t]
	\caption{Loadings of the traits after rotation.} \label{table:rotatefactormasculinefeminine}
	\centering
	\begin{tabular}{c c c}
	\hline
	{Variable} & {Factor1} & {Factor2} \\
	\hline
	assertive & 0.2033 & 0.6649\\
	competitive & 0.3153 &  0.5824\\
	dominant & 0.0160 &  0.7945\\
	individualistic & -0.0262 & 0.6405 \\
	makes decisions easily & 0.0636 & 0.6897 \\
	affectionate & 0.7109 & 0.2390 \\
	compassionate & 0.7570 & 0.1278 \\
	gentle & 0.7696 & -0.0108 \\
	understanding &  0.6409 & 0.0762 \\
	sympathetic & 0.7342 & 0.0368 \\
	sensitive & 0.6924 & 0.0546 \\
	\hline
	\end{tabular}
\end{table}

\subsection{Types of Rotation}

As discussed above, when there is more than one factor, we need to rotate the extracted factors in order to try to have each factor represent a 
cluster of items. How do we rotate the factors? Do we rotate them by ten degrees? Thirt degrees? This is a crucial question because the answer
will affect the final loadings of each item on each factor. In general, there are two types of rotation, \textbf{orthogonal} and \textbf{oblique}. 
The difference between the two types is actually simple and can be explained by looking at Table ~\ref{table:rotatefactormasculinefeminine}. In
orthogonal rotations, the factors are assumed to be independent. This means that geoetrically they have to be perpendicular to each other. In
oblique rotations on the other hand, the assumption is that the factors are not independent. This means that they are not perpendicular. 

Within each type of rotation, there are several approaches. The three main orthogonal approaches are Varimax, Quartimax, and Equamax.  
As social scientists, we do not need to know the mathematical differences for each. The main thing to know is that
The most commonly used orthogonal approach is varimax. 

The assumption that the factors are independent is actually a very strong one and in many cases it is not met. This is why some researchers
prefer oblique rotations. It happens more often than none that the factors that we are dealing with are conceptualy different but are nonetheless
correlated with each other. There are many approaches to oblique rotations such as Oblimin, Promax, and Orthoblique. The most popular methods
are Oblimin and Promax. 

So which type of rotation should we use? The answer lies in the researcher's knowledge of what is being measured. If the researcher beleives that
the factors are independent of one another, then orthogonal rotation can be used. If the researcher believes that the factors are somehow correlated
then oblique rotation can be used. In our case, we have been measuring masculinity and femininity. If you beleive tha these two constructs are
dependent (the more masculine you are then the less feminine you are) then an oblique rotation would be suitable. If, on the other, hand you 
beleive that the the two constructs are not correlated (a person can be masculine and feminine or a person can be masculine but not feminine) then
an orthogonal rotation can be used. In general, a good litterature review would reveal to you what type of rotation is suitable.

To illustrate, let us continue to use the example of Masculinity and Femininity that we have been using so far. If we perform principal component
analysis on the dataset we will get the results previously displayed in Table ~\ref{table:factormasculinefeminine}. Let us know perform both an
orthogonal rotation and an oblique rotation on the factors. The results are displayed in Table ~\ref{table:rotationsboth}.

\begin{table}[h!t]
	\caption{Ortogonal and Oblique rotations.} \label{table:rotationsboth}
	\centering
	\begin{tabular}{c |c c |c c|}
	\hline
	{} & \multicolumn{2}{|c|}{Orthogonal} & \multicolumn{2}{|c|}{Oblique} \\
	\hline
	\bf Item & \bf Factor1 & \bf Factor2 & \bf \bf Factor1 & \bf Factor2 \\
	assertive & 0.2033 & 0.6649 & 0.1318 & 0.6544 \\
	competitive & 0.3153 &  0.5824 & 0.2553 & 0.5578 \\
	dominant & 0.0160 &  0.7945 & -0.0735 & 0.8075 \\
	individualistic & -0.0262 & 0.6405 & -0.0991 & 0.6554  \\
	makes decisions easily & 0.0636 & 0.6897 & -0.0133 & 0.6954 \\
	affectionate & 0.7109 & 0.2390 & 0.6971 & 0.1634 \\
	compassionate & 0.7570 & 0.1278 & 0.7566 & 0.0449 \\
	gentle & 0.7696 & -0.0108 & 0.7852 & -0.0977 \\
	understanding &  0.6409 & 0.0762 & 0.6442 & 0.0054 \\
	sympathetic & 0.7342 & 0.0368 & 0.7437 & -0.0453 \\
	sensitive & 0.6924 & 0.0546 & 0.6991 & -0.0224 \\
	\hline
	\end{tabular}
\end{table}    

Looking at Table ~\ref{table:rotationsboth}, we see that the results are almost the same. We see that the loadings of each item on each factor
are very similar in magnitude when we compare the results obtained after each type of rotation. This bascially means that the assumption that the
two factors are independent is actually valid, because when we relaxed this strict assumption by using the oblique rotation we got almost the same
results.   

\section{Recap}
The main points about factor analysis can be summarized as follows:
\begin{itemize}
	\item Factor analysis is used when we beleive that sumtiple items can be represented by a single factor. The two types of factor analysis are
	prinicpal component analysis and common factor analysis. The difference between the two is that principal component analysis tries to account 
	for all the variance that is observed in the items while common factor analysis tries to account only for the variance that the items share in 
	common. The more widely used method is principal component analysis.  
	\item Items have loadings on factors where each loading represents the relevance of the item to that factor. The higher the loading, the
	larger the correlation between the factor and the item. Loadings that are greater than 0.4 are considered to be substantial.
	\item We can also measure whether the items are actually measuring the same construct by calculating a reliability statistis such as
	Cronbach's alpha. A value greater than 0.7 is taken to suggest that the items are reliable.
	\item Factors with an eigenvalue greater than one are retained while factors with eigenvalues less than one are dropped. Eigenvalues are
	calculated by adding the total loadings of each item on a factor. The larger the sum, the more that a factor is correlated with the items.
	\item If the factor analysis reveals that there is more than one factor, then we need to rotate the factors. This is necessary in order to allow
	different factors to represent different clusters, especially since the first step in extracting the factors tries to find a single factor that
	accounts for the variation in all items. By rotating the factors, we are adjusting for this and allowing a more sensical interpretation of each
	factor.
	\item The two types of rotation are orthogonal and oblique. In orthogonal rotation the factors are assumed to be independent (perpendicular to
	each other) while in oblique rotation the assumption is that the factors are not independent (not perpendicular to each other). The most
	commonly used ortjogonal rotation is Varimax while the most commonly used oblique rotations are Oblimin and Promax. The choice of which rotation
	is to be used should be guided by your knowldge of the constructs being measured and by performing a suitable literature review. 
	\item Once the factors are rotated, we will have the loading of each item on each factor. This will enable us to calculate the factor score for
	each of the item. This will allow us to ask all sorts of questions, as in "Are there gender differences?" since we have a variable that records
	the gender of the respondent. If we had a variable that recorded the age of the respondent then we could have investigated whether there are
	differences in masculinity and feminity when it comes to age. 
\end{itemize}

\chapter{Factor Analysis - Case Study}

\chapter{Structural Equation Modeling - The Theory}
\chapter{Structural Equation Modeling - Case Study}

\chapter{References}

Bluman, A.G. (2018). Elementary Statistics: A Step by Step Approach. 10th edition. McGraw Hill Education.

Hilbe, J.M. (2009). Logistic Regression Models. CRC Press.

Hilbe, J.M. (2011). Negative Binomial Regression. 2nd edition. Cambridge University Press.

Hosmer, D.W. \& Lemeshow, S. (2000). Applied Logistic Regression. 2nd edition. Wiley.

Long, J.S. \& Freese, J. (2014). Regression Models for Categorical Dependent Variables using Stata. 3rd ediction. Stata Press.

Mitchell, M.N. (2012). Interpreting and Visualizing Regression Models using Stata. Stata Press.

Ryan, T.P. (2009). Modern Regression Methods. 2nd edition. Wiley.

\end{document}
tex*/
