%{
#include <stdio.h>
#include "xml2mnx.tab.h"
%}

%x PARTLIST PARTSTATE MEASURE_STATE NOTE_STATE
%option yylineno

delim       [ \t\r\n\rn]+

header_score_partwise 	"<score-partwise version=\""([0-9]+\.[0-9]+)"\">" 
score_partwise_end 		"</score-partwise>"
header_score_timewise	"<score-timewise version=\""([0-9]+\.[0-9]+)"\">"

part_list_start "<part-list>"
part_list_end "</part-list>"

part_start ("<part id=\""){id}("\">")
part_end "</part>"

id ([A-Za-z0-9]+)

measure_start      		"<measure number=\""([0-9]+)"\">"
measure_end      		"</measure>"

fifths 		"<fifths>"(-?[0-9]+)"</fifths>"
mode    	"<mode>"([a-zA-Z]+)"</mode>"

beats 		"<beats>"([0-9]+)"</beats>"
beat_type 	"<beat-type>"([0-9]+)"</beat-type>"
clef_sign 		"<sign>"([A-Za-z]+)"</sign>"
clef_line		"<line>"([0-9]+)"</line>"


note_start     "<note>"
note_end		"</note>"

step            "<step>"([A-Za-z]+)"</step>"
octave          "<octave>"([0-9]+)"</octave>"
note_type 	    "<type>"([A-Za-z]+)"</type>"
rest 			"<rest></rest>"
chord           "<chord></chord>"
accidental	 	"<accidental>"([A-Za-z]+)"</accidental>"
dot            	"<dot></dot>"

%%


{header_score_partwise} { 
	return HEADER_SCORE_PARTWISE;
}
{header_score_timewise} { 
	return HEADER_SCORE_TIMEWISE;
}

{delim} {
	;
}

{part_list_start} {
    BEGIN(PARTLIST);
	return PART_LIST_START;
}
<PARTLIST>{part_list_end} {
    BEGIN(INITIAL);
    return PART_LIST_END;
}
<PARTLIST>. {
	;
}

<PARTLIST>{delim} {
	;
}



{part_start} {
	BEGIN(PARTSTATE);
	
	char* new_str = malloc(strlen(yytext));
	int length = strlen(yytext) - strlen("<part id= ") - strlen("> ");
	strncpy(new_str, strlen("<part id= ")+yytext, length);
	strcpy(yylval.name, new_str);

	return PART_START;
}
<PARTSTATE>{part_end} {
	BEGIN(INITIAL);
    return PART_END;
}
<PARTSTATE>{delim} {
	;
}
<PARTSTATE>{measure_start} {
	BEGIN(MEASURE_STATE);
	return MEASURE_START;
}
<MEASURE_STATE>{measure_end} {
	BEGIN(PARTSTATE);
    return MEASURE_END;
}
<MEASURE_STATE>{delim} {
	;
}


<MEASURE_STATE>{beats} {
    char* new_str = malloc(strlen(yytext));
	int length = strlen(yytext) - strlen("<beats>") - strlen("</beats>");
	strncpy(new_str, strlen("<beats>")+yytext, length);
	strcpy(yylval.name, new_str);
    return BEATS;
}
<MEASURE_STATE>{beat_type} {
    char* new_str = malloc(strlen(yytext));
	int length = strlen(yytext) - strlen("<beat-type>") - strlen("</beat-type>");
	strncpy(new_str, strlen("<beat-type>")+yytext, length);
	strcpy(yylval.name, new_str);
    return BEATTYPE;
}
<MEASURE_STATE>{clef_sign} {
    char* new_str = malloc(strlen(yytext));
	int length = strlen(yytext) - strlen("<sign>") - strlen("</sign>");
	strncpy(new_str, strlen("<sign>")+yytext, length);
	strcpy(yylval.name, new_str);
    return CLEF_SIGN;
}
<MEASURE_STATE>{clef_line} {
    char* new_str = malloc(strlen(yytext));
	int length = strlen(yytext) - strlen("<line>") - strlen("</line>");
	strncpy(new_str, strlen("<line>")+yytext, length);
	strcpy(yylval.name, new_str);
    return CLEF_LINE;
}
<MEASURE_STATE>{fifths} {
    char* new_str = malloc(strlen(yytext));
	int length = strlen(yytext) - strlen("<fifths>") - strlen("</fifths>");
	strncpy(new_str, strlen("<fifths>")+yytext, length);
	strcpy(yylval.name, new_str);
    return FIFTHS;
}
<MEASURE_STATE>{mode} {
	;
}
<MEASURE_STATE>. {
	;
}


<MEASURE_STATE>{note_start} {
	BEGIN(NOTE_STATE);
	return NOTE_START;
}
<NOTE_STATE>{note_end} {
	BEGIN(MEASURE_STATE);
    return NOTE_END;
}
<NOTE_STATE>{chord} {
	return CHORD;
}
<NOTE_STATE>{step} {
    char* new_str = malloc(strlen(yytext));
	int length = strlen(yytext) - strlen("<step>") - strlen("</step>");
	strncpy(new_str, strlen("<step>")+yytext, length);
	strcpy(yylval.name, new_str);
    return STEP;
}
<NOTE_STATE>{octave} {
    char* new_str = malloc(strlen(yytext));
	int length = strlen(yytext) - strlen("<octave>") - strlen("</octave>");
	strncpy(new_str, strlen("<octave>")+yytext, length);
	strcpy(yylval.name, new_str);
    return OCTAVE;
}
<NOTE_STATE>{note_type} {
    char* new_str = malloc(strlen(yytext));
	int length = strlen(yytext) - strlen("<type>") - strlen("</type>");
	strncpy(new_str, strlen("<type>")+yytext, length);
	strcpy(yylval.name, new_str);
    return NOTE_TYPE;
}
<NOTE_STATE>{rest} {
	return REST;
}
<NOTE_STATE>{dot} {
	return DOT;
}
<NOTE_STATE>{accidental} {
	char* new_str = malloc(strlen(yytext));
	int length = strlen(yytext) - strlen("<accidental>") - strlen("</accidental>");
	strncpy(new_str, strlen("<accidental>")+yytext, length);
	strcpy(yylval.name, new_str);
	return ACCIDENTAL;
}
<NOTE_STATE>. {
	;
}
<NOTE_STATE>{delim} {
	;
}


{score_partwise_end} { 
	return SCORE_PARTWISE_END;
}


%%
