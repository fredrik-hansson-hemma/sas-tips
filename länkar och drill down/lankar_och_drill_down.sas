
*

Huvudprogram
================
* Gör urval
* Anropar sub-rapporter
* Skriver ut en sida med länkar till subrapporter



klasstatistik.sas (subrapport 1)
================================
Skapar en rapport med en graf över någon statistik i en klass
Skapar en annan rapport med detaljdata om vad som visas i grafen
Den förstnämnda rapporten är länkad till den andra



fiskstatistik.sas (subrapport 2)
Skapar en rapport med en graf över någon statistik om fiskar
;




* Test-parametrar	;
%let _STPWORK=%sysfunc(pathname(WORK));
%let _STPWORK=c:\tmp;
filename _WEBOUT "&_STPWORK/main.html";
%let _ODSOPTIONS=gpath="&_STPWORK/"(URL="./");
%let _RESULT=STREAM;
%let _ODSDEST=HTML;

%autolib(APP=AUR, systemname=auricula)





data work.class;
	set sashelp.class;
	URL_for_sgplot="./klasstatistik_detaljdata.html";
	target="_SELF";
run;


%co_stpbegin;


ODS graphics ON /imagemap;

PROC SGPLOT DATA=work.class CYCLEATTRS ;
 TITLE "SGPLOT Grouped Bar Chart" ;
 HBAR name /
 DATALABEL
 FILL
 GROUP = sex
 RESPONSE = age
 STAT = sum
 URL = URL_for_sgplot;
RUN;

%co_stpend;


title;
ods HTML file="&_STPWORK/klasstatistik_detaljdata.html" &_ODSOPTIONS;
proc print data=work.class;
	var sex name age;
run;
ods HTML close;




ods HTML file="&_STPWORK/fiskstatistik.html" &_ODSOPTIONS;
data work.fish;
	set sashelp.fish;
	URL_for_sgplot=cats("./fish_", Species, ".html");
run;

PROC SGPLOT DATA=work.fish CYCLEATTRS ;
* TITLE "SGPLOT Grouped Bar Chart" ;
 HBAR Species /
 DATALABEL
 FILL
 /*GROUP = sex */
 RESPONSE = weight
 STAT = sum
 URL = URL_for_sgplot;
RUN;
ods HTML close;





proc SQL noprint;
	select distinct species into :species1-
	from work.fish;
quit;
%let antal_species=&SQLOBS;


%macro create_fish_details;
	%do i = 1 %to &antal_species;
		ods HTML file="&_STPWORK/fish_&&species&i...html" &_ODSOPTIONS;

		data work.fish;
			set work.fish;
			if species="&&species&i" then group2="color1";
			else group2="color2";
		run;
		PROC SGPLOT DATA=work.fish CYCLEATTRS ;
		* TITLE "SGPLOT Grouped Bar Chart" ;
		 HBAR Species /
		 DATALABEL
		 FILL
		 GROUP = group2
		 RESPONSE = weight
		 STAT = mean
		 URL = URL_for_sgplot;
		RUN;
		ods HTML close;
	%end;
%mend;


%create_fish_details