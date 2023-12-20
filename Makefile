FUENTE = xml2mnx
PRUEBA1 = /home/mateo/uni/cuarto/PL/XML2MNX/ejemplos/1.xml
PRUEBA2 = /home/mateo/uni/cuarto/PL/XML2MNX/ejemplos/2.xml
PRUEBA3 = /home/mateo/uni/cuarto/PL/XML2MNX/ejemplos/3.xml
PRUEBA4 = /home/mateo/uni/cuarto/PL/XML2MNX/ejemplos/4.xml
PRUEBA5 = /home/mateo/uni/cuarto/PL/XML2MNX/ejemplos/5.xml
PRUEBA6 = /home/mateo/uni/cuarto/PL/XML2MNX/ejemplos/error1.xml
PRUEBA7 = /home/mateo/uni/cuarto/PL/XML2MNX/ejemplos/error2.xml
PRUEBA8 = /home/mateo/uni/cuarto/PL/XML2MNX/ejemplos/error3.xml
PRUEBA9 = /home/mateo/uni/cuarto/PL/XML2MNX/ejemplos/error4.xml
PRUEBA10 = /home/mateo/uni/cuarto/PL/XML2MNX/ejemplos/error5.xml


LIB = lfl

all: compile run

compile:
	flex $(FUENTE).l
	bison -o $(FUENTE).tab.c $(FUENTE).y -yd -Wcounterexamples
	gcc -o $(FUENTE) lex.yy.c $(FUENTE).tab.c -$(LIB) -ly

run:
	./$(FUENTE) < $(PRUEBA1)


run2:
	./$(FUENTE) $(PRUEBA)

clean:
	rm $(FUENTE) lex.yy.c $(FUENTE).tab.c $(FUENTE).tab.h

