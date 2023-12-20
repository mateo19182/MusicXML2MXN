%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

void yyerror (char const *);
extern int yylex();

typedef struct {
    char* step;
    char* octave;
    char* type;
	int measur;
	bool chord;
	bool dot;
	int accidental; // 0 = natural, 1 = sharp, -1 = flat, 2 = none, 3 = error
} Note;

Note* note_array = NULL;
int length = 0; 
int note_pos = 0;

char* beats = "";
char* beat_type = "";
char* clef_line = "";
char* clef_sign = "";

char* name_of_parts[10];
int fifths=0;
int nParts=0;
int nMeasures=0;


int getAccidentalType(char* accidental);
Note* insertNote(Note* note_array, int* length, const char* step, const char* octave, const char* type);
void writeFile(void);

extern int yylineno;

%}
//%define parse.trace
%union{
    char name[64];
}

//simbolos terminales
%token HEADER_SCORE_TIMEWISE HEADER_SCORE_PARTWISE SCORE_PARTWISE_END PART_LIST_START PART_LIST_END PART_END MEASURE_START MEASURE_END NOTE_START NOTE_END REST DOT CHORD
%token <name> PART_START BEATS CLEF_SIGN CLEF_LINE BEATTYPE STEP OCTAVE NOTE_TYPE FIFTHS ACCIDENTAL


//no terminales
%type part_list parts part measures measure attributes notes note

//símbolo de arranque
%start S

%%

S :

	HEADER_SCORE_PARTWISE part_list parts SCORE_PARTWISE_END{
			printf("Ended analysis\n");
	}
	| HEADER_SCORE_TIMEWISE {
			printf("LINEA %d:",yylineno);printf("Error: Formato timewise no aceptado, transfórmalo a partwise.\n"); yyclearin;exit(0);}
	| HEADER_SCORE_PARTWISE parts SCORE_PARTWISE_END{
			printf("LINEA %d:",yylineno);printf("Error: falta objeto part_list.\n"); yyclearin;exit(0);
	}
	| HEADER_SCORE_PARTWISE part_list parts {
			printf("LINEA %d:",yylineno);printf("Error: falta tag de score partwise final.\n"); yyclearin;exit(0);}
	| part_list parts SCORE_PARTWISE_END{
			printf("LINEA %d:",yylineno);printf("Error: falta tag de score partwise inicial.\n"); yyclearin;exit(0);}
	;

part_list:
	PART_LIST_START PART_LIST_END
	| PART_LIST_START {
		printf("LINEA %d:",yylineno);printf("Error: falta tag de part-list final.\n"); yyclearin;exit(0);}
	| PART_LIST_END {
		printf("LINEA %d:",yylineno);printf("Error: falta tag de part-list inicial.\n"); yyclearin;exit(0);}
	;


parts:  
	part
	| part parts
	;

	
part:
	PART_START measures PART_END {name_of_parts[nParts]=strdup($1);nParts++;}
	;

measures: 
	measure
	| measure measures
	;

measure:
	MEASURE_START attributes notes  MEASURE_END {nMeasures++;}
	| MEASURE_START notes MEASURE_END {nMeasures++;}
	| MEASURE_START attributes MEASURE_END {nMeasures++;}
	| MEASURE_START MEASURE_END {
		printf("LINEA %d:",yylineno);printf("Error: measure vacio de contenido.\n"); yyclearin;exit(0);
	}

	;

attributes:
	BEATS BEATTYPE	{beats=strdup($1);beat_type=strdup($2);}
	| CLEF_SIGN CLEF_LINE{fifths=0;clef_sign=strdup($1);clef_line=strdup($2);}
	| BEATS BEATTYPE CLEF_SIGN CLEF_LINE {fifths=0;beats=strdup($1);beat_type=strdup($2);clef_sign=strdup($3);clef_line=strdup($4);}
	| FIFTHS BEATS BEATTYPE CLEF_SIGN CLEF_LINE {fifths=atoi($1);beats=strdup($2);beat_type=strdup($3);clef_sign=strdup($4);clef_line=strdup($5);}
    | BEATS | BEATTYPE | CLEF_SIGN | CLEF_LINE | FIFTHS  {
        printf("LINEA %d:",yylineno);printf("Error: faltan atributo(s).\n"); yyclearin;exit(0);
    }
	;

notes: 
	note
	| note notes
	;

note:
	NOTE_START CHORD STEP OCTAVE NOTE_TYPE NOTE_END {note_array = insertNote(note_array, &length, $3, $4, $5); note_array[length-1].chord=true;}
	| NOTE_START CHORD STEP OCTAVE NOTE_TYPE DOT NOTE_END {note_array = insertNote(note_array, &length, $3, $4, $5); note_array[length-1].chord=true;note_array[length-1].dot=true;}
	| NOTE_START STEP OCTAVE NOTE_TYPE NOTE_END {note_array = insertNote(note_array, &length, $2, $3, $4);}
	| NOTE_START STEP OCTAVE NOTE_TYPE DOT NOTE_END {note_array = insertNote(note_array, &length, $2, $3, $4);note_array[length-1].dot=true;}

	| NOTE_START STEP OCTAVE NOTE_TYPE ACCIDENTAL NOTE_END {note_array = insertNote(note_array, &length, $2, $3, $4);
		if(getAccidentalType($5)==3){
			printf("LINEA %d:",yylineno);printf("Error: tipo de accidental no reconocido.\n"); yyclearin;exit(0);
		}
		else{
			note_array[length-1].accidental=getAccidentalType($5);
		}
	};
	| NOTE_START STEP OCTAVE NOTE_TYPE ACCIDENTAL DOT NOTE_END {note_array = insertNote(note_array, &length, $2, $3, $4);note_array[length-1].dot=true;
		if(getAccidentalType($5)==3){
			printf("LINEA %d:",yylineno);printf("Error: tipo de accidental no reconocido.\n"); yyclearin;exit(0);
		}
		else{
			note_array[length-1].accidental=getAccidentalType($5);
		}
	};

	| NOTE_START REST NOTE_TYPE NOTE_END {note_array = insertNote(note_array, &length, "rest", "0", $3);}
	| NOTE_START REST NOTE_TYPE DOT NOTE_END {note_array = insertNote(note_array, &length, "rest", "0", $3);note_array[length-1].dot=true;}
	| error {printf("LINEA %d:",yylineno);printf("Error: nota no reconocida.\n"); yyclearin;exit(0);}
	;


%%

int main(int argc, char *argv[]) {
extern FILE *yyin;
FILE *outfile;
//#ifdef YYDEBUG
//  yydebug = 1;
//#endif
	switch (argc) {
		case 1:	yyin=stdin;
			yyparse();
			printf("Writing new file on output.json...\n");
			writeFile();
			printf("Finished\n");
			break;
		case 2: yyin = fopen(argv[1], "r");
			if (yyin == NULL) {
				printf("ERROR: El fichero no se ha podido abrir.\n");
			}
			else {
				yyparse();
				fclose(yyin);
			}
			break;
		default: printf("ERROR: Demasiados argumentos.\nSintaxis: %s [fichero_entrada]\n\n", argv[0]);
	}
	return 0;
}

Note* insertNote(Note* note_array, int* length, const char* step, const char* octave, const char* type) {
    Note newNote;

    newNote.step = malloc(strlen(step) + 1);
    strcpy(newNote.step, step);

    newNote.octave = malloc(strlen(octave) + 1);
    strcpy(newNote.octave, octave);

    newNote.type = malloc(strlen(type) + 1);
    strcpy(newNote.type, type);

	newNote.measur = nMeasures;
	newNote.chord = false;
	newNote.accidental = 2;
	newNote.dot = false;
    (*length)++;
    note_array = realloc(note_array, (*length) * sizeof(Note));

    note_array[*length - 1] = newNote;

    return note_array;
}

void freeNoteArray(Note* note_array, int length) {
    for (int i = 0; i < length; i++) {
        free(note_array[i].step);
        free(note_array[i].octave);
        free(note_array[i].type);
    }
    free(note_array);
}

int getAccidentalType(char* accidental) {
    if (strcmp(accidental, "sharp") == 0) {
        return 1;
    } else if (strcmp(accidental, "flat") == 0) {
        return -1;
    } else if (strcmp(accidental, "natural") == 0) {
        return 0;
    } else {
        return 3;
    }
}

void writeFile() {
    FILE *outfile = fopen("output.json", "w");
	if (outfile == NULL) {
    	printf("ERROR: The output file could not be opened.\n");
	}
  	else {

		fprintf(outfile, "{\n    \"mnx\": {\n        \"version\": 1\n    },\n");
    	fprintf(outfile,
    	    "    \"global\": {\n"
    	    "        \"measures\": [\n"
    	    "            {\n"
			"				\"key\": {\n"	
			"					\"fifths\": %d\n"
			"				},\n"
    	    "                \"barline\": {\"type\": \"regular\"},\n"
    	    "                \"time\": {\"count\": %s, \"unit\": %s}\n"
    	    "            }\n"
    	    "        ]\n"
    	    "	},\n",
    	    fifths, beats, beat_type);
		if (nParts>0){
			for(int i = 0; i < nParts; i++) {
				fprintf(outfile,
        		"    \"parts\": [\n"
        		"        {\n");

				fprintf(outfile,
        		"		    \"measures\": [\n"
        		"		        {\n"
        		"		            \"clefs\": [\n"
        		"		                {\n"
        		"		                    \"clef\": {\n"
        		"		                        \"position\": -%s,\n"
        		"		                        \"sign\": \"%s\"\n"
        		"		                    }\n"
        		"		                }\n"
        		"		            ],\n"
					,clef_line, clef_sign);
				for(int t = 0; t < nMeasures; t++) {


					if (length>0){
						fprintf(outfile,
        				"			    	\"sequences\": [\n"
        				"			        	{\n"
        				"			            	\"content\": [\n");

						for(note_pos; note_pos < length; note_pos++) {
							if(strcmp(note_array[note_pos].step, "rest")==0){
								fprintf(outfile,
        						"								{\n"
        						"					    			\"type\": \"event\",\n"
        						"					    			\"duration\": {\n"
        						"					    	    		\"base\": \"%s\"",
        						note_array[note_pos].type);
								if(note_array[note_pos].dot){
									fprintf(outfile,
									"										,\n"
									"					    	    		\"dots\": 1\n");
								}
								else{
									fprintf(outfile,"\n");
								}
								fprintf(outfile,
        						"					    			},\n"
								"					    			\"rest\": {}\n"
        						"								}");	
							}
							else if(note_array[note_pos].accidental!=2){
							fprintf(outfile,
							"								{\n"
							"					    			\"type\": \"event\",\n"
							"					    			\"duration\": {\n"
							"					    	    		\"base\": \"%s\"\n"
							"					    			},\n"
							"					    			\"notes\": [\n"
							" 					    				{\n"
							" 					    					\"accidentalDisplay\": {\n"
							" 					    						\"show\": true\n"
							" 					    					},\n"
							"											\"pitch\": {\n"
							"												\"alter\": %d,\n"
							" 					    	    				\"octave\": %s,\n"
							"  		              							\"step\": \"%s\"\n"
							"	            							}\n"
							"	        							}",
							note_array[note_pos].type, note_array[note_pos].accidental, note_array[note_pos].octave, note_array[note_pos].step);
							fprintf(outfile,
        					"	    							]\n"
        					"								}");
							}
							else{
								fprintf(outfile,
        						"								{\n"
        						"					    			\"type\": \"event\",\n"
        						"					    			\"duration\": {\n"
        						"					    	    		\"base\": \"%s\"",
        						note_array[note_pos].type);
								if(note_array[note_pos].dot){
									fprintf(outfile,
									"										,\n"
									"					    	    		\"dots\": 1\n");
								}
								else{
									fprintf(outfile,"\n");
								}
								fprintf(outfile,
        						"					    			},\n"
        						"					    			\"notes\": [\n"
        						" 					    				{\n"
        						"											\"pitch\": {\n"
        						" 					    	    				\"octave\": %s,\n"
        						"  		              							\"step\": \"%s\"\n"
        						"	            							}\n"
        						"	        							}"
								, note_array[note_pos].octave, note_array[note_pos].step);	
								if(note_array[note_pos+1].chord){
									fprintf(outfile,",\n");
								}
								else{
									fprintf(outfile,"\n");
								}
								for(note_pos; note_pos < length; note_pos++) {
									note_pos++;
									if(note_array[note_pos].chord){
									fprintf(outfile,
									" 					    				{\n"
        							"											\"pitch\": {\n"
        							" 					    	    				\"octave\": %s,\n"
        							"  		              							\"step\": \"%s\"\n"
        							"	            							}\n"
        							"	        							}",
									note_array[note_pos].octave, note_array[note_pos].step);
									if(note_array[note_pos+1].chord){
										fprintf(outfile,",\n");
									}
									else{
										fprintf(outfile,"\n");
									}
									note_pos--;
									}
									else{
										note_pos--;
										break;
									}
								}

								fprintf(outfile,
        						"	    							]\n"
        						"								}");
							}


							if(note_pos!=length-1){
								if(note_array[note_pos].measur!=note_array[note_pos+1].measur){
									fprintf(outfile,"\n");
									note_pos++;
									break;
								}
        						fprintf(outfile,",\n");						
							}
							else{
        						fprintf(outfile,"\n");						
							}				
						}

				}

					fprintf(outfile,
					"		        			]\n"
        			"		    			}\n"
        			"					]\n");
				if(t!=nMeasures-1){
        			fprintf(outfile,
					"				},\n"
					"			{\n");						
				}
				else{
        			fprintf(outfile,"				}\n");						
				}	

			}
			fprintf(outfile,
        	"			]\n"
        	"	    }\n");			
			fprintf(outfile,
        	"	], \"name\": \"%s\"\n",
        	name_of_parts[i]);
		}
		
		}
		fprintf(outfile,"}\n");
    	fclose(outfile);
    }
}

