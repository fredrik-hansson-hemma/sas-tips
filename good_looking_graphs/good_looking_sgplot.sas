

ods path work.template(update) sashelp.tmplmst(read);

/* Create a global template that all tables will inherit from */
  proc template ;
  	define style mystyle;
     parent=styles.htmlblue;
	end;

     define table base.template.table;
        cellstyle mod(_row_, 2) and
                  ^(_style_ like '%Header') as {backgroundcolor=lightgray},
                  ^(mod(_row_, 2)) and
                  ^(_style_ like '%Header') as {backgroundcolor=white};
     end;

	* delete base.template.table;
	* delete base.template.column;
     /* Just some extra eye candy *
     define column base.template.column;
        cellstyle _val_ > 70 as {color=red};
     end; ******/
  run;



  /* Run some procs *
  ods pdf file="c:\tmp\striped.pdf" startpage=no;

  proc means data=sashelp.class;
     class age;
     var height weight;
  run;

  proc contents data=sashelp.class;
  run;

  ods pdf close;
*/

* Introduktion ;


* Ny sida ;

* F�rsvenskar datasetet	;
proc format;
	value $pojkar_flickor
		'M'='Pojkar'
		'F'='Flickor';
quit;
data work.class;
	label sex="K�n" age="�lder";
	format sex $pojkar_flickor.;
	set sashelp.class;
run;



ods html file="/tmp/good_looking_sgplots.html" gpath="/tmp/" style=mystyle;

ods graphics on / reset=all imagefmt=png reset=index height=300px width=400px;

ods layout gridded columns=2;

ods region;
proc odstext;
	p "S�h�r ser en sgplot ut med default-uteseende.";
	p "Grafen visar medel�ldern f�r elever i en klass, grupperat p� flickor och pojkar.";
	p "Men i bilden finns en del element som inte hj�lper oss att ta till oss datat.";
run;
ods region;
proc sgplot data=work.class;
  vbar sex / response=age stat=mean;
run;

ods region;

proc odstext;
	p "H�r har vi tagit bort ramen runt bilden.";
run;
ods region;
ods graphics / border=off;
proc sgplot data=work.class;
  vbar sex / response=age stat=mean;
run;






* Skapar ny style utan ram runt grafen	;
proc template;
   define style mystyle2;
   parent=mystyle;
      class graphwalls / 
            frameborder=off;
      * class graphbackground / 
            color=white;
   end;
run;


ods html style=mystyle2;
ods region;
proc odstext;
	p "Den inre rutan tillf�r inte heller n�got. Och om den inte har n�gon funktion, s� �r det b�ttre att vara utan den.";
run;
ods region;
ods graphics / border=off;
proc sgplot data=work.class;
  vbar sex / response=age stat=mean;
run;




ods html style=mystyle2;
ods region;
proc odstext;
	p "Beh�vs verkligen tick-marks p� X-axeln? Inte i den h�r grafen i alla fall, och v�ldigt s�llan f�r kategoriska variabler �ver huvud taget.";
run;
ods region;
ods graphics / border=off;
proc sgplot data=work.class;
	XAXIS DISPLAY=(NOTICKS);
  vbar sex / response=age stat=mean;
run;






ods html style=mystyle2;
ods region;
proc odstext;
	p "F�r kategoriska variabler(klassvariabler) �r det s�llan n�dv�ndigt att skriva ut variabelnamnet (i det h�r fallet 'k�n'). Det �r ju ganska uppenbart. Och om det inte hj�lper oss s�...";
	p "Lite senare i den h�r rapporten kommer vi dessutom f� med det i rubriken.";
run;
ods region;
ods graphics / border=off;
proc sgplot data=work.class;
	XAXIS DISPLAY=(NOTICKS NOLABEL);
  vbar sex / response=age stat=mean;
run;




ods html style=mystyle2;
ods region;
proc odstext;
	p "Anpassa skalan s� att den blir l�tt att relatera till.";
run;
ods region;
ods graphics / border=off;
proc sgplot data=work.class;
	XAXIS DISPLAY=(NOTICKS NOLABEL);
	YAXIS INTEGER VALUES=(0 to 14 by 1);
  vbar sex / response=age stat=mean;
run;





ods layout end;
ods _all_ close;