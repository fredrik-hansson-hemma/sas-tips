%let temp_path = %sysfunc(pathname(WORK));
filename tempfile temp;
ods HTML file=tempfile gpath="&temp_path" style=styles.printer;

ODS escapechar="^";
 
ods layout gridded 
	columns=24
	rows=1
	order_type=row_major
	column_widths=(	30px 30px 30px 30px 30px 30px 
					30px 30px 30px 30px 30px 30px 
					30px 30px 30px 30px 30px 30px 
					30px 30px 30px 30px 30px 30px)
	column_gutter=10
	;
ods region col;

* title Spanning over the whole page ;
ODS text=" ^{style[fontsize=48 font=(Arial) foreground=darkgray]Going-to-the-amusement-park-or-not-report}";
* ODS text=" ^{style[fontsize=48 font=(Arial)]Going-to-the-amusement-park-or-not-report}";



* three columns ;

	* First column - Logo	;
	ODS text=" ^{style [color=green fontsize=48] ^animtext2 ^{unicode '2603'} ^{unicode '2744'}}";

	* Second column - Length limits	;
	
	
	* Third column - picture of amusementpark	;
	ODS text=" ^{style [color=green fontsize=48] ^animtext2 ^{unicode '2603'} ^{unicode '2744'}}";


* two columns ;
	* First column - Text	;
	* Second column - Length limits	;


* three columns ;
	* First column - girls lengths	;
proc template;
define statgraph sgdesign;
dynamic _HEIGHT _NAME _SEX2 _title;
begingraph / designwidth=298 designheight=331 border=false;
   entrytitle halign=center _title;
   layout lattice / rowdatarange=data columndatarange=data rowgutter=10 columngutter=10;
      layout overlay / walldisplay=(FILL)
							xaxisopts=( display=(TICKVALUES LINE ) discreteopts=( tickvaluefitpolicy=splitrotate) linearopts=(minorgrid=OFF minorticks=OFF))
							yaxisopts=( display=(TICKS TICKVALUES LINE ) griddisplay=on linearopts=( viewmin=0.0 minorgrid=OFF minorticks=OFF tickvaluesequence=( start=50.0 end=75.0 increment=5.0)));
         barchart category=_NAME response=_HEIGHT / group=_SEX2 name='bar' display=(FILL) stat=mean barwidth=0.85 groupdisplay=Cluster clusterwidth=0.85 grouporder=ascending;
      endlayout;
   endlayout;
endgraph;
end;
run;

proc sgrender data=SASHELP.CLASS(where=(sex="F")) template=sgdesign;
dynamic _HEIGHT="HEIGHT" _NAME="NAME" _SEX2="SEX" _title='Girls height';
run;

	* Second column - text	;
	proc odstext;
		p "TExt";
	run;

	* Third column - boys lengths	;
	proc sgrender data=SASHELP.CLASS(where=(sex="M")) template=sgdesign;
		dynamic _HEIGHT="HEIGHT" _NAME="NAME" _SEX2="SEX" _title='Boys height';
	run;



* traffic lights ;



proc print data=sashelp.class(obs=2);
run;

ods layout end;


ODS _ALL_ CLOSE;



/*

proc fontreg msglevel=verbose;
fontpath "%sysget(systemroot)\fonts";
run;

*/