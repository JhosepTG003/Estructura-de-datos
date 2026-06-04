// ============================================================================
// A. LISTA (GESTOR DE PROCESOS)
// ============================================================================

SubProceso BuscarProceso(listaIds Por Referencia, cantActual Por Valor, idBuscado Por Valor, posEncontrada Por Referencia)
	Definir i Como Entero
	
	posEncontrada <- 0
	
	Para i <- 1 Hasta cantActual Hacer
		Si listaIds[i] = idBuscado Entonces
			posEncontrada <- i
		FinSi
	FinPara
FinSubProceso

SubProceso AgregarProceso(listaIds Por Referencia, listaNombres Por Referencia, listaPrioridades Por Referencia, cantActual Por Referencia, capMax Por Valor)
	Definir id, prioridad, posicion, i, posExiste Como Entero
	Definir nombre Como Cadena
	
	Escribir "=== [LISTA] REGISTRAR NUEVO PROCESO ==="
	
	Si cantActual >= capMax Entonces
		Escribir "[Error] No hay espacio dinamico en la lista."
	Sino
		Escribir "ID del proceso:"
		Leer id
		
		BuscarProceso(listaIds, cantActual, id, posExiste)
		
		Si posExiste <> 0 Entonces
			Escribir "[Error] El ID ya existe."
		Sino
			Escribir "Nombre del proceso (sin espacios):"
			Leer nombre
			Escribir "Prioridad (1=Alta, 2=Media, 3=Baja):"
			Leer prioridad
			
			posicion <- 1
			Mientras (posicion <= cantActual) Y (listaPrioridades[posicion] <= prioridad) Hacer
				posicion <- posicion + 1
			FinMientras
			
			Para i <- cantActual Hasta posicion Con Paso -1 Hacer
				listaIds[i+1] <- listaIds[i]
				listaNombres[i+1] <- listaNombres[i]
				listaPrioridades[i+1] <- listaPrioridades[i]
			FinPara
			
			listaIds[posicion] <- id
			listaNombres[posicion] <- nombre
			listaPrioridades[posicion] <- prioridad
			cantActual <- cantActual + 1
			
			Escribir "[OK] Guardado en Lista General de Procesos."
		FinSi
	FinSi
FinSubProceso

SubProceso CambiarPrioridad(listaIds Por Referencia, listaNombres Por Referencia, listaPrioridades Por Referencia, cantActual Por Referencia)
	Definir idBuscar, nuevaPrioridad, i, posEncontrada, nuevaPos Como Entero
	Definir encontrado Como Logico
	Definir tId, tPri Como Entero
	Definir tNom Como Cadena
	
	Escribir "=== [LISTA] MODIFICAR PRIORIDAD ==="
	Escribir "Ingrese ID a buscar:"
	Leer idBuscar
	
	encontrado <- Falso
	posEncontrada <- 0
	
	Para i <- 1 Hasta cantActual Hacer
		Si listaIds[i] = idBuscar Entonces
			encontrado <- Verdadero
			posEncontrada <- i
		FinSi
	FinPara
	
	Si encontrado Entonces
		Escribir "Proceso localizado: ", listaNombres[posEncontrada]
		Escribir "Nueva prioridad (1-3):"
		Leer nuevaPrioridad
		
		tId <- listaIds[posEncontrada]
		tNom <- listaNombres[posEncontrada]
		tPri <- nuevaPrioridad
		
		Para i <- posEncontrada Hasta (cantActual - 1) Hacer
			listaIds[i] <- listaIds[i+1]
			listaNombres[i] <- listaNombres[i+1]
			listaPrioridades[i] <- listaPrioridades[i+1]
		FinPara
		
		cantActual <- cantActual - 1
		
		nuevaPos <- 1
		Mientras (nuevaPos <= cantActual) Y (listaPrioridades[nuevaPos] <= tPri) Hacer
			nuevaPos <- nuevaPos + 1
		FinMientras
		
		Para i <- cantActual Hasta nuevaPos Con Paso -1 Hacer
			listaIds[i+1] <- listaIds[i]
			listaNombres[i+1] <- listaNombres[i]
			listaPrioridades[i+1] <- listaPrioridades[i]
		FinPara
		
		listaIds[nuevaPos] <- tId
		listaNombres[nuevaPos] <- tNom
		listaPrioridades[nuevaPos] <- tPri
		cantActual <- cantActual + 1
		
		Escribir "[OK] Prioridad alterada. Lista reordenada."
	Sino
		Escribir "[Error] ID no registrado."
	FinSi
FinSubProceso

SubProceso EliminarProceso(listaIds Por Referencia, listaNombres Por Referencia, listaPrioridades Por Referencia, cantActual Por Referencia, colaIds Por Referencia, colaNombres Por Referencia, colaPrioridades Por Referencia, cantCola Por Referencia)
	Definir idBuscar, posEncontrada, posCola, i Como Entero
	
	Escribir "=== [LISTA] ELIMINAR PROCESO ==="
	Escribir "Ingrese ID a eliminar:"
	Leer idBuscar
	
	BuscarProceso(listaIds, cantActual, idBuscar, posEncontrada)
	
	Si posEncontrada = 0 Entonces
		Escribir "[Error] ID no registrado."
	Sino
		Para i <- posEncontrada Hasta cantActual - 1 Hacer
			listaIds[i] <- listaIds[i+1]
			listaNombres[i] <- listaNombres[i+1]
			listaPrioridades[i] <- listaPrioridades[i+1]
		FinPara
		cantActual <- cantActual - 1
		
		BuscarEnCola(colaIds, cantCola, idBuscar, posCola)
		Si posCola <> 0 Entonces
			Para i <- posCola Hasta cantCola - 1 Hacer
				colaIds[i] <- colaIds[i+1]
				colaNombres[i] <- colaNombres[i+1]
				colaPrioridades[i] <- colaPrioridades[i+1]
			FinPara
			cantCola <- cantCola - 1
		FinSi
		
		Escribir "[OK] Proceso eliminado."
	FinSi
FinSubProceso


// ============================================================================
// B. COLA DE PRIORIDAD (PLANIFICADOR DE CPU)
// ============================================================================

SubProceso BuscarEnCola(colaIds Por Referencia, cantCola Por Valor, idBuscado Por Valor, posEncontrada Por Referencia)
	Definir i Como Entero
	
	posEncontrada <- 0
	
	Para i <- 1 Hasta cantCola Hacer
		Si colaIds[i] = idBuscado Entonces
			posEncontrada <- i
		FinSi
	FinPara
FinSubProceso

SubProceso OrdenarColaPorPrioridad(colaIds Por Referencia, colaNombres Por Referencia, colaPrioridades Por Referencia, cantCola Por Valor)
	Definir i, j, auxId, auxPri Como Entero
	Definir auxNom Como Cadena
	
	Si cantCola > 1 Entonces
		Para i <- 1 Hasta cantCola - 1 Hacer
			Para j <- 1 Hasta cantCola - i Hacer
				Si colaPrioridades[j] > colaPrioridades[j+1] Entonces
					auxId <- colaIds[j]
					auxNom <- colaNombres[j]
					auxPri <- colaPrioridades[j]
					
					colaIds[j] <- colaIds[j+1]
					colaNombres[j] <- colaNombres[j+1]
					colaPrioridades[j] <- colaPrioridades[j+1]
					
					colaIds[j+1] <- auxId
					colaNombres[j+1] <- auxNom
					colaPrioridades[j+1] <- auxPri
				FinSi
			FinPara
		FinPara
	FinSi
FinSubProceso

SubProceso EncolarProceso(listaIds Por Referencia, listaNombres Por Referencia, listaPrioridades Por Referencia, cantActual Por Valor, colaIds Por Referencia, colaNombres Por Referencia, colaPrioridades Por Referencia, cantCola Por Referencia)
	Definir idBuscar, posEncontrada, i Como Entero
	
	Escribir "=== [COLA] ENCOLAR POR PRIORIDAD ==="
	Escribir "Ingrese ID del proceso:"
	Leer idBuscar
	
	BuscarProceso(listaIds, cantActual, idBuscar, posEncontrada)
	
	Si posEncontrada = 0 Entonces
		Escribir "[Error] ID no registrado."
	Sino
		BuscarEnCola(colaIds, cantCola, idBuscar, i)
		Si i <> 0 Entonces
			Escribir "[Error] El proceso ya esta en la cola."
		Sino
			cantCola <- cantCola + 1
			colaIds[cantCola] <- listaIds[posEncontrada]
			colaNombres[cantCola] <- listaNombres[posEncontrada]
			colaPrioridades[cantCola] <- listaPrioridades[posEncontrada]
			
			OrdenarColaPorPrioridad(colaIds, colaNombres, colaPrioridades, cantCola)
			Escribir "[OK] Proceso agregado a la cola."
		FinSi
	FinSi
FinSubProceso


// ============================================================================
// C. PILA (GESTOR DE MEMORIA)
// ============================================================================

SubProceso EjecutarEnCPU(listaIds Por Referencia, listaNombres Por Referencia, listaPrioridades Por Referencia, cantActual Por Referencia, colaIds Por Referencia, colaNombres Por Referencia, colaPrioridades Por Referencia, cantCola Por Referencia, pilaMemoria Por Referencia, topePila Por Referencia)
	Definir i, idActual, idProcesado Como Entero
	Definir nombreActual Como Cadena
	
	Escribir "=== [COLA / PILA] SIMULACION DE PROCESADOR Y MEMORIA ==="
	
	Si cantCola = 0 Entonces
		Escribir "No hay tareas pendientes en la cola del planificador."
	Sino
		Escribir ">> Despachando procesos secuencialmente por prioridad... <<"
		
		Mientras cantCola > 0 Hacer
			idActual <- colaIds[1]
			nombreActual <- colaNombres[1]
			
			Escribir ""
			Escribir "[CPU] -> Atendiendo: ", nombreActual, " (ID: ", idActual, ")"
			
			topePila <- topePila + 1
			pilaMemoria[topePila] <- idActual
			Escribir "   [RAM] Asignando bloque de memoria al proceso ID: ", idActual, " (PUSH)"
			
			Escribir "   [CPU] Computando rafagas de tiempo..."
			
			Escribir "   [RAM] Liberando bloque de memoria asignado (POP) -> ID: ", pilaMemoria[topePila]
			pilaMemoria[topePila] <- 0
			topePila <- topePila - 1
			
			Para i <- 1 Hasta cantCola - 1 Hacer
				colaIds[i] <- colaIds[i+1]
				colaNombres[i] <- colaNombres[i+1]
				colaPrioridades[i] <- colaPrioridades[i+1]
			FinPara
			
			cantCola <- cantCola - 1
		FinMientras
		
		Escribir ""
		Escribir ">> [OK] Cola de ejecucion vacia. Todos los bloques de la pila RAM liberados. <<"
	FinSi
FinSubProceso


// ============================================================================
// D. MOSTRAR SISTEMA
// ============================================================================

SubProceso MostrarSistema(listaIds Por Referencia, listaNombres Por Referencia, listaPrioridades Por Referencia, cantActual Por Valor, colaIds Por Referencia, colaNombres Por Referencia, colaPrioridades Por Referencia, cantCola Por Valor, pilaMemoria Por Referencia, topePila Por Valor)
	Definir i Como Entero
	
	Escribir "=== REPOSITORIO GENERAL ACTIVO ==="
	Si cantActual = 0 Entonces
		Escribir "Planificador vacio."
	Sino
		Escribir "Pos | ID    | Nombre      | Prioridad"
		Escribir "-------------------------------------"
		Para i <- 1 Hasta cantActual Hacer
			Escribir " ", i, "  | ", listaIds[i], "   | ", listaNombres[i], "      | ", listaPrioridades[i]
		FinPara
	FinSi
	
	Escribir ""
	Escribir "=== COLA DE PRIORIDAD ==="
	Si cantCola = 0 Entonces
		Escribir "Cola vacia."
	Sino
		Escribir "Pos | ID    | Nombre      | Prioridad"
		Escribir "-------------------------------------"
		Para i <- 1 Hasta cantCola Hacer
			Escribir " ", i, "  | ", colaIds[i], "   | ", colaNombres[i], "      | ", colaPrioridades[i]
		FinPara
	FinSi
	
	Escribir ""
	Escribir "=== PILA DE MEMORIA ==="
	Si topePila = 0 Entonces
		Escribir "Pila vacia."
	Sino
		Escribir "Bloques ocupados: ", topePila
		Para i <- topePila Hasta 1 Con Paso -1 Hacer
			Escribir "Bloque ", i, " -> Proceso ID: ", pilaMemoria[i]
		FinPara
	FinSi
FinSubProceso


// ============================================================================
// 2. ALGORITMO PRINCIPAL (CONTROLADOR DEL MENÚ)
// ============================================================================

Algoritmo SistemaPlanificadorCPU
	
	Definir capMax, cantActual, cantCola, topePila, opcion Como Entero
	Definir listaIds, listaPrioridades, colaIds, colaPrioridades, pilaMemoria Como Entero
	Definir listaNombres, colaNombres Como Cadena
	
	capMax <- 100
	cantActual <- 5
	cantCola <- 0
	topePila <- 0
	
	Dimension listaIds[100]
	Dimension listaNombres[100]
	Dimension listaPrioridades[100]
	Dimension colaIds[100]
	Dimension colaNombres[100]
	Dimension colaPrioridades[100]
	Dimension pilaMemoria[100]
	
	// Valores iniciales
	listaIds[1] <- 101
	listaNombres[1] <- "System"
	listaPrioridades[1] <- 1
	
	listaIds[2] <- 102
	listaNombres[2] <- "Explorer"
	listaPrioridades[2] <- 2
	
	listaIds[3] <- 103
	listaNombres[3] <- "Chrome"
	listaPrioridades[3] <- 2
	
	listaIds[4] <- 104
	listaNombres[4] <- "Antivirus"
	listaPrioridades[4] <- 3
	
	listaIds[5] <- 105
	listaNombres[5] <- "Notepad"
	listaPrioridades[5] <- 3
	
	Repetir
		Escribir ""
		Escribir "=========================================="
		Escribir "    CONTROLADOR DE PROCESOS"
		Escribir "=========================================="
		Escribir "1. Insertar Proceso (Lista)"
		Escribir "2. Buscar Proceso"
		Escribir "3. Modificar Prioridad"
		Escribir "4. Eliminar Proceso"
		Escribir "5. Encolar por Prioridad"
		Escribir "6. Ejecutar a la CPU y RAM"
		Escribir "7. Mostrar Sistema"
		Escribir "8. Salir"
		Escribir "=========================================="
		Escribir "Seleccione opcion:"
		Leer opcion
		
		Segun opcion Hacer
			1:
				Limpiar Pantalla
				AgregarProceso(listaIds, listaNombres, listaPrioridades, cantActual, capMax)
			2:
				Limpiar Pantalla
				Definir idBuscado, pos Como Entero
				Escribir "=== [LISTA] BUSCAR PROCESO ==="
				Escribir "Ingrese ID:"
				Leer idBuscado
				BuscarProceso(listaIds, cantActual, idBuscado, pos)
				Si pos = 0 Entonces
					Escribir "[Error] Proceso no encontrado."
				Sino
					Escribir "ID: ", listaIds[pos]
					Escribir "Nombre: ", listaNombres[pos]
					Escribir "Prioridad: ", listaPrioridades[pos]
				FinSi
			3:
				Limpiar Pantalla
				CambiarPrioridad(listaIds, listaNombres, listaPrioridades, cantActual)
			4:
				Limpiar Pantalla
				EliminarProceso(listaIds, listaNombres, listaPrioridades, cantActual, colaIds, colaNombres, colaPrioridades, cantCola)
			5:
				Limpiar Pantalla
				EncolarProceso(listaIds, listaNombres, listaPrioridades, cantActual, colaIds, colaNombres, colaPrioridades, cantCola)
			6:
				Limpiar Pantalla
				EjecutarEnCPU(listaIds, listaNombres, listaPrioridades, cantActual, colaIds, colaNombres, colaPrioridades, cantCola, pilaMemoria, topePila)
			7:
				Limpiar Pantalla
				MostrarSistema(listaIds, listaNombres, listaPrioridades, cantActual, colaIds, colaNombres, colaPrioridades, cantCola, pilaMemoria, topePila)
			8:
				Escribir "Terminando el programa de simulacion..."
			De Otro Modo:
				Escribir "[Error] Opcion no valida."
		FinSegun
		
	Hasta Que opcion = 8
	
FinAlgoritmo