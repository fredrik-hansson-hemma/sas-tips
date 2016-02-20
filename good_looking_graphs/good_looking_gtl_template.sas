
title; footnote;
ods path work.template(update) sashelp.tmplmst(read);
ods escapechar="^";


* Skapar en template mest f�r att slippa den bl� bakgrunden i styles.htmlblue	;
proc template;
	define style mystyle;

		parent=styles.htmlblue;

		style Body from Body/
			pagebreakhtml = _undef_
			backgroundcolor = #cxFFFFFF;
		style paragraph from paragraph /
			backgroundcolor=cxFFFFFF
			fontsize=12px;
		style TitlesAndFooters from TitlesAndFooters/
			foreground=CX000000
			background=CXFFFFFF;
		style UserText from UserText /
			foreground=CX000000
			background=CXFFFFFF;
	end;

	define table base.template.table;
		cellstyle mod(_row_, 2) and
			^(_style_ like '%Header') as {backgroundcolor=lightgray},
			^(mod(_row_, 2)) and
			^(_style_ like '%Header') as {backgroundcolor=white};
	end;

run;






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



ods html	file="D:\Dropbox\Public\Jobbrelaterat\sas-tips\good_looking_sgplots.html"
			gpath="D:\Dropbox\Public\Jobbrelaterat\sas-tips\good_looking_sgplots\"(URL=".\good_looking_sgplots\")
			style=mystyle
			encoding='utf-8';
ods graphics on / reset=all reset=index imagename="good_looking_sgplot" imagefmt=png height=300px width=200px ;








ods layout gridded columns=2 width=600px;


* Introduktion ;
ods region column_span=2;

ods text="^n^n";
ods text="^{style [just=center font_size=24pt] Framh�va grafen eller framh�va data i grafen? - sgplot}"; 
ods text="^n^n";

proc odstext;
	p "Har Du ocks� h�rt ""sgplot:ar ser ut som gchart borde ha gjort ""?.";
	p "Det kanske �r sant, men hur borde egentligen sgplot:ar se ut?";
	p "H�r fokuserar jag p� att plocka bort on�diga detaljer fr�n ett stapeldiagram, f�r att g�ra det l�ttare f�r den som ska konsumera diagrammet att fokusera p� datat.";
run;
title;

ods text="^n^n";



* sgplot utan modifieringar	;
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



