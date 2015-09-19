

* Introduktion ;


* Ny sida ;


ods latex file="/tmp/test.tex" gpath="/tmp/";

proc print data=sashelp.class;
run;

proc sgplot data=sashelp.prdsale;
  yaxis label="Sales" min=200000;
  vbar country / response=predict;
  vbar country / response=actual
                  barwidth=0.5
                  transparency=0.2;
run;


ods _all_ close;