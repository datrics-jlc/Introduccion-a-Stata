* Primera Ayudantia: Introduccion a Stata
* Ayudante: Javiera Lobos


/* Tipos de STATA

1. Stata/IC (Version Estandar),
2. Stata/SE (version Extendida) 
3. Stata/MP (Version para Multiproposito) */

********************************************
* Comando utiles para el uso de STATA

clear //Permite Limpiar la base de datos de todo lo que contenga la base de datos
set more off, perm  //  Imprime todos los resultados sin saltos
capture log close // Cierra cualquier log file que pudiese estar abierto

* Directorio
cd "/Users/jlobos/Desktop/UAI/MEPP 2019" // 
mkdir "ayudantia1" // Crea un nueva carpeta dentro del directorio
pwd

* log file 
log using "/Users/jlobos/Desktop/UAI/MEPP 2019/Intro a stata.smcl"
log using "/Users/jlobos/Desktop/UAI/MEPP 2019/Intro a stata.txt"

/* Importar bases de datos */
*  Cuando el archivo tiene una extension .dta y  esta en la carpeta del directorio
use "carsdata.dta", clear
*  Cuando el archivo tiene una extension .dta y no esta en la carpeta del directorio
use "/Users/jlobos/Desktop/UAI/MEPP 2019/dataset1.dta", clear
* Cuando el archivo tiene una extension .dta y no quiero todas las variables
use ccars using "carsdata.dta", clear
* Cuando el archivo es .txt .xlsx o .csv
 insheet using "/Users/jlobos/Desktop/UAI/MEPP 2019/dataset1.txt", clear
* Cuando el archivo es .txt .xlsx o .csv y tiene un separador determinado
insheet using "/Users/jlobos/Desktop/UAI/MEPP 2019/cdataset1.txt", delimiter(“;”)


/* Tipos de datos 

byte : enteros entre  -127 and 100 
int : enteros entre -32,767 and 32,740 
long : enteros entre  -2,147,483,647 and 2,147,483,620
float : numeros reales de 8 cifras de largo
double : numero reales con 16 cifras de largo */


/*  Comandos basicos */
use http://fmwww.bc.edu/ec-p/data/wooldridge/wage1

describe  //Describe el contenido de una base de datos en la memoria
codebook //Muestra en detalle las variables en la base de datos
list  //Muestra una lista de variables
list if female == 1 
count //cuenta las observaciones que cumplen una determinada condicion
count if exper>10

summarize //Calcula estadistica descriptiva univariada

tabulate female // Genera tablas descriptivas.
tab female married, row column

tabstat wage, by(married)
tabstat wage, by(married) stats(N mean median sd range min max)

/* Manipulacion de datos */

generate lnw=ln(wage)

* Generare una variable denominada nowhite_married para cada persona no blanca que esta casada
generate nowhite_married=0 
replace nowhite_married=1 if  married==1 & nonwhite==1

* Genero grupos para una variable continua 

egen wagecat = cut(wage), at(1,10,20,30,40,50,60,70,80,90,100)

*Cambio de nombre alguna variable
rename wage salario

* Crear etiquetas para variables
label define grupos 1 "grupo 1"  0 "grupo 2"
label values nowhite_married grupos


* boto variables o observaciones
drop o keep

compress //Compress data in memory

save  database.dta // guardo mi base de datos

/* Regresion */
ssc install estout, replace

reg lwage female exper 
estimates store m1, title(Model 1)

reg lwage female exper educ 
estimates store m2, title(Model 2)


reg lwage female exper educ services
estimates store m3, title(Model 3)

estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2)))


/* Grafico */
twoway (scatter lwage exper) (lfit lwage exper), title(Fitted Regression Line)

histogram lwage

/* Pegar bases de datos */

merge 1:1 varlist using filename
merge m:1 varlist using filename
merge 1:m varlist using filename
merge m:m varlist using filename


/*Ejercicios :  Casen 2017
http://observatorio.ministeriodesarrollosocial.gob.cl/casen-multidimensional/casen/docs/Manual_del_Investigador_Casen_2017.pdf
1. Abrir la base de datos 
2. Hacer estadistica descriptiva relavante por sexo, region y edad. 
3. Generar las siguientes variables
	-  Índice de envejecimiento Indicador demográfico que mide la relación entre el número de
adultos/as mayores (personas de 60 años o más) por cada 100 niños/as (personas de 0 a 14 años). 

gen aux1= 1 if edad>=60
egen pob60=sum(aux1)
gen aux2=1 if edad<15
egen pob15=sum(aux2)
gen ind_envejecimiento=pob60/pob15 * 100

	- Ingreso del trabajo promedio de los hogares: 
	
sum ytrabajocorh [w=expr] if pco1==1
scalar itrabpromhog= r(mean)
	
	- Ingreso del trabajo per cápita del hogar, promedio
	de los hogares
	
gen ytrabcacorh=ytrabajocorh/numper
sum ytrabcacorh [w=expr] if pco1==1
scalar itrabpromcahog=_r(mean)

4. Caracterize los hogares del ingreso per capita del hogar es mayor a $800.000

5, Si tuviera que pegarle la base de datos con las caracteristicas de los hogares, Como lo haria?

	
