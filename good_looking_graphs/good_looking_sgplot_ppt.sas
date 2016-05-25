options nodate nonumber;
ods powerpoint 
	file="c:\tmp\test.pptx" 
	style=styles.powerPointLight
	layout=titleslide;
proc odstext;
   p "My Presentation" / style=PresentationTitle;
   p "ABC Company"/ style=PresentationTitle2;
run;

ods powerpoint 
style=styles.powerPointLight 
layout=TitleAndContent;

title "Titel";
proc odstext;
   p "ABC Company"/ style=PresentationTitle2;
   p "Textmassa faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord faktiskt en himla massa ord";
run;

ods powerpoint style=styles.powerPointLight layout=TwoContent;
title "Titel";
proc odstext;
   p "ABC Company"/ style=PresentationTitle2;
   p "Textmassa";
run;

proc odstext;
   p "ABC Company"/ style=PresentationTitle2;
   p "Textmassa";
run;
ods powerpoint layout=_null_;