/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_XML2MNX_TAB_H_INCLUDED
# define YY_YY_XML2MNX_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    HEADER_SCORE_TIMEWISE = 258,   /* HEADER_SCORE_TIMEWISE  */
    HEADER_SCORE_PARTWISE = 259,   /* HEADER_SCORE_PARTWISE  */
    SCORE_PARTWISE_END = 260,      /* SCORE_PARTWISE_END  */
    PART_LIST_START = 261,         /* PART_LIST_START  */
    PART_LIST_END = 262,           /* PART_LIST_END  */
    PART_END = 263,                /* PART_END  */
    MEASURE_START = 264,           /* MEASURE_START  */
    MEASURE_END = 265,             /* MEASURE_END  */
    NOTE_START = 266,              /* NOTE_START  */
    NOTE_END = 267,                /* NOTE_END  */
    REST = 268,                    /* REST  */
    DOT = 269,                     /* DOT  */
    CHORD = 270,                   /* CHORD  */
    PART_START = 271,              /* PART_START  */
    BEATS = 272,                   /* BEATS  */
    CLEF_SIGN = 273,               /* CLEF_SIGN  */
    CLEF_LINE = 274,               /* CLEF_LINE  */
    BEATTYPE = 275,                /* BEATTYPE  */
    STEP = 276,                    /* STEP  */
    OCTAVE = 277,                  /* OCTAVE  */
    NOTE_TYPE = 278,               /* NOTE_TYPE  */
    FIFTHS = 279,                  /* FIFTHS  */
    ACCIDENTAL = 280               /* ACCIDENTAL  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define HEADER_SCORE_TIMEWISE 258
#define HEADER_SCORE_PARTWISE 259
#define SCORE_PARTWISE_END 260
#define PART_LIST_START 261
#define PART_LIST_END 262
#define PART_END 263
#define MEASURE_START 264
#define MEASURE_END 265
#define NOTE_START 266
#define NOTE_END 267
#define REST 268
#define DOT 269
#define CHORD 270
#define PART_START 271
#define BEATS 272
#define CLEF_SIGN 273
#define CLEF_LINE 274
#define BEATTYPE 275
#define STEP 276
#define OCTAVE 277
#define NOTE_TYPE 278
#define FIFTHS 279
#define ACCIDENTAL 280

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 43 "xml2mnx.y"

    char name[64];

#line 121 "xml2mnx.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_XML2MNX_TAB_H_INCLUDED  */
