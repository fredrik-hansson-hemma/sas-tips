
title; footnote;
ods path work.template(update) sashelp.tmplmst(read);


* Skapar en template mest f�r att slippa den bl� bakgrunden i styles.htmlblue	;
proc template;
	define style mystyle;

		parent=styles.htmlblue;

		style Body from Body/
			pagebreakhtml = _undef_
			backgroundcolor = #cxFFFFFF;
		style paragraph from paragraph /
			backgroundcolor=cxFFFFFF;
		style TitlesAndFooters from TitlesAndFooters/
			foreground=CX000000
			background=CXFFFFFF;
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
ods graphics on / reset=all reset=index imagename="good_looking_sgplot" imagefmt=png height=300px width=200px ;






* Introduktion ;
ods layout gridded columns=1 width=600px;

ods region;
title "The data, the whole data and nothing but the data";
proc odstext;
	p "Har Du ocks� h�rt ""sgplot:ar ser ut som gchart borde ha gjort ""?.";
	p "Det kanske �r sant, men hur borde egentligen sgplot:ar se ut?";
	p "H�r fokuserar jag p� att plocka bort on�diga detaljer fr�n ett stapeldiagram, f�r att g�ra det l�ttare f�r den som ska se diagrammet att fokusera p� datat.";
run;
title;
ods layout end;




* sgplot utan modifieringar	;
ods layout gridded columns=2 width=600px;

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







* sgplot utan yttre ram ;
ods region;

proc odstext;
	p "H�r har vi tagit bort ramen runt bilden.";
run;
ods region;
ods graphics / border=off;
proc sgplot data=work.class;
  vbar sex / response=age stat=mean;
run;










* sgplot utan inre ram	;

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
	p "Den inre ramen tillf�r inte heller n�got. Och om den inte har n�gon funktion, s� �r det b�ttre att vara utan den.";
run;
ods region;
ods graphics / border=off;
proc sgplot data=work.class;
  vbar sex / response=age stat=mean;
run;











* sgplot utan tickmarks p� X-axeln	;
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










* sgplot utan label till X-axeln	;
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











* sgplot utan kontur runt staplarna	;
ods region;
proc odstext;
	p "Vad �r egentligen po�ngen med konturen runt staplarna? Det naturliga n�r man ritar grafer f�r hand, �r att man f�rst ritar staplarnas konturer med linjal, och sedan fyller i dem. N�r man anv�nder en dator f�r att rita grafen, har vi inget behov av att arbeta p� det s�ttet.";
	p "Vi skippar konturen runt staplarna. F�r att inte staplarna ska sm�lta ihop med bakgrunden, byter vi ocks� f�rg till en som tydligare avtecknar sig mot bakgrunden";
run;
ods region;
ods graphics / border=off;
proc sgplot data=work.class;
	XAXIS DISPLAY=(NOTICKS NOLABEL);
  vbar sex / response=age stat=mean FILL fillattrs=(color=cx7F7F7F);
run;





* sgplot med titel	;
ods region;
proc odstext;
	p "En beskrivande rubrik blir pricken �ver i.";
run;
ods region;
ods graphics / border=off;
proc sgplot data=work.class;
	title "Medel�lder i klassen, f�rdelat p� k�n";
	XAXIS DISPLAY=(NOTICKS NOLABEL);
  vbar sex / response=age stat=mean FILL fillattrs=(color=cx7F7F7F);
run;










* Snyggar till Y-axeln	;
ods region;
proc odstext;
	p "I just den h�r grafen �r skalan p� Y-axeln lite sv�r att relatera till. 2,5 �r mellan skalstrecken k�nns lite onaturligt.";
	p "Vi anpassar skalan s� att den blir l�tt att relatera till.";
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






* J�mf�relse mellan f�rsta och sista bilden	;
title justify=center "F�re- och efterbilder";
data _null_;
	declare odsout obj(); 
	obj.layout_gridded(columns: 2);
	obj.region(width: "3.25in");
	obj.title(text: "F�re");
	obj.image(file: "C:\tmp\good_looking_sgplot.png"); 
	obj.region();
	obj.image(file: "C:\tmp\good_looking_sgplot7.png"); 
	obj.layout_end(); 
	obj.delete(); 
run;



ods _all_ close;