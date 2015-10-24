
title; footnote;
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

* Försvenskar datasetet	;
proc format;
	value $pojkar_flickor
		'M'='Pojkar'
		'F'='Flickor';
quit;
data work.class;
	label sex="Kön" age="Ålder";
	format sex $pojkar_flickor.;
	set sashelp.class;
run;



ods html file="/tmp/good_looking_sgplots.html" gpath="/tmp/" style=mystyle;
ods graphics on / reset=all reset=index imagename="good_looking_sgplot" imagefmt=png height=300px width=200px ;

ods layout gridded columns=2;

ods region;
proc odstext;
	p "Såhär ser en sgplot ut med default-uteseende.";
	p "Grafen visar medelåldern för elever i en klass, grupperat på flickor och pojkar.";
	p "Men i bilden finns en del element som inte hjälper oss att ta till oss datat.";
run;
ods region;
proc sgplot data=work.class;
  vbar sex / response=age stat=mean;
run;

ods region;

proc odstext;
	p "Här har vi tagit bort ramen runt bilden.";
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
	p "Den inre rutan tillför inte heller något. Och om den inte har någon funktion, så är det bättre att vara utan den.";
run;
ods region;
ods graphics / border=off;
proc sgplot data=work.class;
  vbar sex / response=age stat=mean;
run;




ods html style=mystyle2;
ods region;
proc odstext;
	p "Behövs verkligen tick-marks på X-axeln? Inte i den här grafen i alla fall, och väldigt sällan för kategoriska variabler över huvud taget.";
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
	p "För kategoriska variabler(klassvariabler) är det sällan nödvändigt att skriva ut variabelnamnet (i det här fallet 'kön'). Det är ju ganska uppenbart. Och om det inte hjälper oss så...";
	p "Lite senare i den här rapporten kommer vi dessutom få med det i rubriken.";
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
	p "Vad är egentligen poängen med konturen runt staplarna? Det naturliga när man ritar grafer för hand, är att man först ritar staplarnas konturer med linjal, och sedan fyller i dem. När man använder en dator för att rita grafen, har vi inget behov av att arbeta på det sättet.";
	p "Vi skippar konturen runt staplarna. För att inte staplarna ska smälta ihop med bakgrunden, byter vi också färg till en som tydligare avtecknar sig mot bakgrunden";
run;
ods region;
ods graphics / border=off;
proc sgplot data=work.class;
	XAXIS DISPLAY=(NOTICKS NOLABEL);
  vbar sex / response=age stat=mean FILL fillattrs=(color=cx7F7F7F);
run;





ods html style=mystyle2;
ods region;
proc odstext;
	p "En beskrivande rubrik blir pricken över i.";
run;
ods region;
ods graphics / border=off;
proc sgplot data=work.class;
	title "Medelålder i klassen, fördelat på kön";
	XAXIS DISPLAY=(NOTICKS NOLABEL);
  vbar sex / response=age stat=mean FILL fillattrs=(color=cx7F7F7F);
run;






ods html style=mystyle2;
ods region;
proc odstext;
	p "I just den här grafen är skalan på Y-axeln lite svår att relatera till. 2,5 år mellan skalstrecken känns lite onaturligt.";
	p "Vi anpassar skalan så att den blir lätt att relatera till.";
run;
ods region;
ods graphics / border=off;
proc sgplot data=work.class;
	XAXIS DISPLAY=(NOTICKS NOLABEL);
	YAXIS INTEGER VALUES=(0 to 14 by 1);
  vbar sex / response=age stat=mean FILL fillattrs=(color=cx7F7F7F);
run;

ods layout end;

title;

data _null_;
	declare odsout obj(); 
	obj.layout_gridded(columns: 2);
	obj.region(width: "3.25in"); 
	obj.image(file: "C:\tmp\good_looking_sgplot.png"); 
	obj.region();
	obj.image(file: "C:\tmp\good_looking_sgplot7.png"); 
	obj.layout_end(); 
	obj.delete(); 
run;



ods _all_ close;