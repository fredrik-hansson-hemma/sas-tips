data cars;
  length URL $25;
  set sashelp.cars;
  max=60;
    if type eq 'Sedan' then URL='http://www.sas.com';
    else URL='https://support.sas.com';
run;

proc template;
  define statgraph BoxURL;
    begingraph;
      layout overlay;
        boxplot x=type y=mpg_city;
        barchart x=type y=max / url=url datatransparency=0.8 stat=mean;
     endlayout;
   endgraph;
  end;
run;
ods html file='BoxURL.htm'  path='c:\temp';
ods graphics / reset imagemap=on width=5in height=3in imagename='BoxURL';
proc sgrender data=cars template=BoxURL;
run;
ods html close;