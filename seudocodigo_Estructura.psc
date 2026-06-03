// ============================================================
//   SISTEMA DE GESTIÓN DE PROCESOS - PSeInt (Corregido Estricto)
//   Estructuras: Lista Enlazada, Cola de Prioridad, Pila (Base 1)
// ============================================================

Algoritmo SistemaGestionProcesos
	
	Definir MAX Como Entero
	MAX <- 100
	
	// --- Declaración de Tipos para Arreglos ---
	Definir lista_id, lista_prioridad, lista_memoria, lista_rafaga, lista_sig Como Entero
	Definir lista_nombre, lista_estado Como Caracter
	Definir cola_id, cola_prioridad, cola_rafaga, cola_sig Como Entero
	Definir pila_id, pila_memoria Como Entero
	Definir pila_nombre Como Caracter
	Definir log_id, log_tiempo Como Entero
	Definir log_evento Como Caracter
	
	// --- Arreglos Lista Enlazada ---
	Dimension lista_id[100], lista_nombre[100], lista_prioridad[100]
	Dimension lista_memoria[100], lista_estado[100], lista_rafaga[100], lista_sig[100]
	
	// --- Arreglos Cola de Prioridad ---
	Dimension cola_id[100], cola_prioridad[100], cola_rafaga[100], cola_sig[100]
	
	// --- Arreglos Pila ---
	Dimension pila_id[100], pila_memoria[100], pila_nombre[100]
	
	// --- Log / Historial ---
	Dimension log_id[100], log_evento[100], log_tiempo[100]
	
	// --- Inicialización de Punteros (0 = NULL) ---
	Definir lista_cabeza, lista_libre, lista_tam Como Entero
	Definir cola_cabeza,  cola_libre,  cola_tam  Como Entero
	Definir pila_tope, pila_tam                  Como Entero
	Definir log_tam, tiempo_global               Como Entero
	
	lista_cabeza <- 0  
	lista_libre  <- 1  
	lista_tam    <- 0
	cola_cabeza  <- 0
	cola_libre   <- 1
	cola_tam     <- 0
	pila_tope    <- 0  
	pila_tam     <- 0
	log_tam      <- 0
	tiempo_global<- 0
	
	// --- Variables auxiliares ---
	Definir opcion, sub_opcion           Como Entero
	Definir continuar, continuar_sub     Como Logico
	Definir i, actual, anterior, nuevo, aux Como Entero
	Definir temp_id, temp_prior, temp_mem, temp_rafaga Como Entero
	Definir temp_nombre                  Como Caracter
	Definir encontrado                   Como Logico
	Definir archivo                      Como Caracter
	
	Escribir "Iniciando sistema con estructuras limpias en memoria (Base 1)..."
	
	// -------------------------------------------------------
	//  MENÚ PRINCIPAL
	// -------------------------------------------------------
	continuar <- Verdadero
	Mientras continuar Hacer
		
		Escribir ""
		Escribir "======================================================"
		Escribir "         SISTEMA DE GESTIÓN DE PROCESOS (SGP)         "
		Escribir "======================================================"
		Escribir "  Tiempo de sistema: ", tiempo_global, " unidades"
		Escribir "------------------------------------------------------"
		Escribir "  1. Modulo de Gestion de Procesos"
		Escribir "  2. Modulo de Planificacion de CPU"
		Escribir "  3. Modulo de Gestion de Memoria"
		Escribir "  4. Ver Historial / Log del sistema"
		Escribir "  5. Guardar estado (Simulado)"
		Escribir "  6. Cargar estado (Simulado)"
		Escribir "  0. Salir"
		Escribir "------------------------------------------------------"
		Escribir "Seleccione una opcion: "
		Leer opcion
		
		Segun opcion Hacer
			
			1: // ================================================
				//  MÓDULO 1: GESTIÓN DE PROCESOS
				// ================================================
				continuar_sub <- Verdadero
				Mientras continuar_sub Hacer
					Escribir ""
					Escribir "--- GESTIÓN DE PROCESOS ---"
					Escribir "  1. Agregar nuevo proceso"
					Escribir "  2. Eliminar proceso por ID"
					Escribir "  3. Buscar proceso por ID"
					Escribir "  4. Buscar proceso por nombre"
					Escribir "  5. Modificar prioridad"
					Escribir "  6. Mostrar todos los procesos"
					Escribir "  0. Volver"
					Escribir "Seleccione: "
					Leer sub_opcion
					
					Segun sub_opcion Hacer
						
						1: // -- Agregar --
							Escribir "=== AGREGAR PROCESO ==="
							Escribir "ID del proceso: "
							Leer temp_id
							encontrado <- Falso
							actual <- lista_cabeza
							Mientras actual <> 0 Y NO encontrado Hacer
								Si lista_id[actual] = temp_id Entonces
									encontrado <- Verdadero
								SiNo
									actual <- lista_sig[actual]
								FinSi
							FinMientras
							
							Si encontrado Entonces
								Escribir "ERROR: Ya existe un proceso con ese ID."
							SiNo
								Si lista_libre > MAX Entonces
									Escribir "ERROR: No hay espacio en la memoria estatica."
								SiNo
									Escribir "Nombre: "
									Leer temp_nombre
									Escribir "Prioridad (1=alta, 2=media, 3=baja): "
									Leer temp_prior
									Escribir "Memoria requerida (MB): "
									Leer temp_mem
									Escribir "Rafaga de CPU (unidades de tiempo): "
									Leer temp_rafaga
									
									nuevo <- lista_libre
									lista_libre <- lista_libre + 1 
									
									lista_id[nuevo]        <- temp_id
									lista_nombre[nuevo]    <- temp_nombre
									lista_prioridad[nuevo] <- temp_prior
									lista_memoria[nuevo]   <- temp_mem
									lista_estado[nuevo]    <- "listo"
									lista_rafaga[nuevo]    <- temp_rafaga
									
									lista_sig[nuevo]       <- lista_cabeza
									lista_cabeza           <- nuevo
									lista_tam              <- lista_tam + 1
									
									log_tam             <- log_tam + 1
									log_id[log_tam]     <- temp_id
									log_evento[log_tam] <- "CREADO"
									log_tiempo[log_tam] <- tiempo_global
									
									tiempo_global       <- tiempo_global + 1
									// CORRECCIÓN línea ~154: eliminadas comillas simples del Escribir
									Escribir "Proceso ", temp_nombre, " (ID:", temp_id, ") agregado."
								FinSi
							FinSi
							
						2: // -- Eliminar --
							Escribir "=== ELIMINAR PROCESO ==="
							Escribir "ID a eliminar: "
							Leer temp_id
							encontrado <- Falso
							actual     <- lista_cabeza
							anterior   <- 0
							Mientras actual <> 0 Y NO encontrado Hacer
								Si lista_id[actual] = temp_id Entonces
									encontrado <- Verdadero
								SiNo
									anterior <- actual
									actual   <- lista_sig[actual]
								FinSi
							FinMientras
							Si encontrado Entonces
								Si anterior = 0 Entonces
									lista_cabeza <- lista_sig[actual]
								SiNo
									lista_sig[anterior] <- lista_sig[actual]
								FinSi
								lista_tam <- lista_tam - 1
								
								log_tam             <- log_tam + 1
								log_id[log_tam]     <- temp_id
								log_evento[log_tam] <- "ELIMINADO"
								log_tiempo[log_tam] <- tiempo_global
								
								tiempo_global       <- tiempo_global + 1
								Escribir "Proceso ID:", temp_id, " eliminado."
							SiNo
								Escribir "Proceso no encontrado."
							FinSi
							
						3: // -- Buscar por ID --
							Escribir "=== BUSCAR POR ID ==="
							Escribir "ID a buscar: "
							Leer temp_id
							encontrado <- Falso
							actual     <- lista_cabeza
							Mientras actual <> 0 Y NO encontrado Hacer
								Si lista_id[actual] = temp_id Entonces
									encontrado <- Verdadero
									Escribir "----------------------------"
									Escribir "ID       : ", lista_id[actual]
									Escribir "Nombre   : ", lista_nombre[actual]
									Escribir "Prioridad: ", lista_prioridad[actual]
									Escribir "Memoria  : ", lista_memoria[actual], " MB"
									Escribir "Estado   : ", lista_estado[actual]
									Escribir "Rafaga   : ", lista_rafaga[actual], " ut"
									Escribir "----------------------------"
								SiNo
									actual <- lista_sig[actual]
								FinSi
							FinMientras
							Si NO encontrado Entonces
								Escribir "Proceso no encontrado."
							FinSi
							
						4: // -- Buscar por nombre --
							Escribir "=== BUSCAR POR NOMBRE ==="
							Escribir "Nombre a buscar: "
							Leer temp_nombre
							encontrado <- Falso
							actual     <- lista_cabeza
							Mientras actual <> 0 Hacer
								Si lista_nombre[actual] = temp_nombre Entonces
									encontrado <- Verdadero
									Escribir "----------------------------"
									Escribir "ID       : ", lista_id[actual]
									Escribir "Nombre   : ", lista_nombre[actual]
									Escribir "Prioridad: ", lista_prioridad[actual]
									Escribir "Memoria  : ", lista_memoria[actual], " MB"
									Escribir "Estado   : ", lista_estado[actual]
									Escribir "Rafaga   : ", lista_rafaga[actual], " ut"
									Escribir "----------------------------"
								FinSi
								actual <- lista_sig[actual]
							FinMientras
							Si NO encontrado Entonces
								Escribir "No se encontro proceso con ese nombre."
							FinSi
							
						5: // -- Modificar prioridad --
							Escribir "=== MODIFICAR PRIORIDAD ==="
							Escribir "ID del proceso: "
							Leer temp_id
							encontrado <- Falso
							actual     <- lista_cabeza
							Mientras actual <> 0 Y NO encontrado Hacer
								Si lista_id[actual] = temp_id Entonces
									encontrado <- Verdadero
									Escribir "Prioridad actual: ", lista_prioridad[actual]
									Escribir "Nueva prioridad (1=alta, 2=media, 3=baja): "
									Leer temp_prior
									lista_prioridad[actual] <- temp_prior
									
									log_tam             <- log_tam + 1
									log_id[log_tam]     <- temp_id
									log_evento[log_tam] <- "PRIORIDAD_MODIFICADA"
									log_tiempo[log_tam] <- tiempo_global
									
									tiempo_global       <- tiempo_global + 1
									Escribir "Prioridad actualizada."
								SiNo
									actual <- lista_sig[actual]
								FinSi
							FinMientras
							Si NO encontrado Entonces
								Escribir "Proceso no encontrado."
							FinSi
							
						6: // -- Mostrar todos --
							Escribir "=== LISTA DE PROCESOS ==="
							Si lista_cabeza = 0 Entonces
								Escribir "Lista vacia."
							SiNo
								actual <- lista_cabeza
								Mientras actual <> 0 Hacer
									// CORRECCIÓN línea ~154: se separaron los campos en múltiples Escribir para evitar el error de parser con cadenas largas
									Escribir "ID:", lista_id[actual], " Nombre:", lista_nombre[actual]
									Escribir "  Prior:", lista_prioridad[actual], " Mem:", lista_memoria[actual], "MB Estado:", lista_estado[actual], " Rafaga:", lista_rafaga[actual], "ut"
									actual <- lista_sig[actual]
								FinMientras
							FinSi
							
						0:
							continuar_sub <- Falso
							
						De Otro Modo:
							Escribir "Opcion invalida."
					FinSegun
				FinMientras
				
			2: // ================================================
				//  MÓDULO 2: PLANIFICACIÓN CPU
				// ================================================
				continuar_sub <- Verdadero
				Mientras continuar_sub Hacer
					Escribir ""
					Escribir "--- PLANIFICACIÓN DE CPU ---"
					Escribir "  1. Encolar proceso"
					Escribir "  2. Desencolar y ejecutar proceso"
					Escribir "  3. Ver cola de ejecucion"
					Escribir "  4. Ejecutar todos los procesos"
					Escribir "  0. Volver"
					Escribir "Seleccione: "
					Leer sub_opcion
					
					Segun sub_opcion Hacer
						
						1: // -- Encolar --
							Escribir "=== ENCOLAR PROCESO ==="
							Escribir "ID del proceso a encolar: "
							Leer temp_id
							encontrado <- Falso
							actual     <- lista_cabeza
							Mientras actual <> 0 Y NO encontrado Hacer
								Si lista_id[actual] = temp_id Entonces
									encontrado <- Verdadero
								SiNo
									actual <- lista_sig[actual]
								FinSi
							FinMientras
							Si NO encontrado Entonces
								Escribir "Proceso no encontrado en la lista."
							SiNo
								Si cola_libre > MAX Entonces
									Escribir "ERROR: Cola llena."
								SiNo
									nuevo                 <- cola_libre
									cola_libre            <- cola_libre + 1
									cola_id[nuevo]        <- lista_id[actual]
									cola_prioridad[nuevo] <- lista_prioridad[actual]
									cola_rafaga[nuevo]    <- lista_rafaga[actual]
									cola_sig[nuevo]       <- 0
									cola_tam              <- cola_tam + 1
									lista_estado[actual]  <- "en_cola"
									
									Si cola_cabeza = 0 O cola_prioridad[nuevo] < cola_prioridad[cola_cabeza] Entonces
										cola_sig[nuevo] <- cola_cabeza
										cola_cabeza     <- nuevo
									SiNo
										aux <- cola_cabeza
										Mientras cola_sig[aux] <> 0 Y cola_prioridad[cola_sig[aux]] <= cola_prioridad[nuevo] Hacer
											aux <- cola_sig[aux]
										FinMientras
										cola_sig[nuevo] <- cola_sig[aux]
										cola_sig[aux]   <- nuevo
									FinSi
									
									log_tam             <- log_tam + 1
									log_id[log_tam]     <- temp_id
									log_evento[log_tam] <- "ENCOLADO_CPU"
									log_tiempo[log_tam] <- tiempo_global
									
									tiempo_global       <- tiempo_global + 1
									Escribir "Proceso ID:", temp_id, " encolado con prioridad ", cola_prioridad[nuevo]
								FinSi
							FinSi
							
						2: // -- Desencolar y ejecutar --
							Escribir "=== EJECUTAR PROCESO ==="
							Si cola_cabeza = 0 Entonces
								Escribir "Cola vacia."
							SiNo
								actual      <- cola_cabeza
								cola_cabeza <- cola_sig[actual]
								cola_tam    <- cola_tam - 1
								
								Escribir "Ejecutando ID:", cola_id[actual], " | Prioridad:", cola_prioridad[actual], " | Rafaga:", cola_rafaga[actual], "ut"
								Para i <- 1 Hasta cola_rafaga[actual] Con Paso 1 Hacer
									tiempo_global <- tiempo_global + 1
									Escribir "  [t=", tiempo_global, "] Procesando..."
								FinPara
								Escribir "Proceso finalizado en t=", tiempo_global
								
								aux <- lista_cabeza
								Mientras aux <> 0 Hacer
									Si lista_id[aux] = cola_id[actual] Entonces
										lista_estado[aux] <- "terminado"
									FinSi
									aux <- lista_sig[aux]
								FinMientras
								
								log_tam             <- log_tam + 1
								log_id[log_tam]     <- cola_id[actual]
								log_evento[log_tam] <- "EJECUTADO"
								log_tiempo[log_tam] <- tiempo_global
							FinSi
							
						3: // -- Ver cola --
							Escribir "=== COLA DE CPU ==="
							Si cola_cabeza = 0 Entonces
								Escribir "Cola vacia."
							SiNo
								actual <- cola_cabeza
								i      <- 1
								Mientras actual <> 0 Hacer
									Escribir "  [", i, "] ID:", cola_id[actual], " | Prioridad:", cola_prioridad[actual], " | Rafaga:", cola_rafaga[actual], "ut"
									actual <- cola_sig[actual]
									i      <- i + 1
								FinMientras
							FinSi
							
						4: // -- Ejecutar todos --
							Escribir "=== EJECUCION COMPLETA ==="
							Si cola_cabeza = 0 Entonces
								Escribir "Cola vacia."
							SiNo
								Mientras cola_cabeza <> 0 Hacer
									actual      <- cola_cabeza
									cola_cabeza <- cola_sig[actual]
									cola_tam    <- cola_tam - 1
									Escribir ">> ID:", cola_id[actual], " | Rafaga:", cola_rafaga[actual], "ut"
									
									Para i <- 1 Hasta cola_rafaga[actual] Con Paso 1 Hacer
										tiempo_global <- tiempo_global + 1
									FinPara
									Escribir "   Finalizado en t=", tiempo_global
									
									aux <- lista_cabeza
									Mientras aux <> 0 Hacer
										Si lista_id[aux] = cola_id[actual] Entonces
											lista_estado[aux] <- "terminado"
										FinSi
										aux <- lista_sig[aux]
									FinMientras
									
									log_tam             <- log_tam + 1
									log_id[log_tam]     <- cola_id[actual]
									log_evento[log_tam] <- "EJECUTADO_LOTE"
									log_tiempo[log_tam] <- tiempo_global
								FinMientras
								Escribir "Todos los procesos ejecutados."
							FinSi
							
						0:
							continuar_sub <- Falso
							
						De Otro Modo:
							Escribir "Opcion invalida."
					FinSegun
				FinMientras
				
			3: // ================================================
				//  MÓDULO 3: GESTIÓN DE MEMORIA (Pila)
				// ================================================
				continuar_sub <- Verdadero
				Mientras continuar_sub Hacer
					Escribir ""
					Escribir "--- GESTIÓN DE MEMORIA (Pila) ---"
					Escribir "  1. Asignar memoria - Push"
					Escribir "  2. Liberar memoria  - Pop"
					Escribir "  3. Ver estado de la pila"
					Escribir "  4. Ver tope - Peek"
					Escribir "  0. Volver"
					Escribir "Seleccione: "
					Leer sub_opcion
					
					Segun sub_opcion Hacer
						
						1: // -- Push --
							Escribir "=== PUSH (Asignar Memoria) ==="
							Escribir "ID del proceso: "
							Leer temp_id
							encontrado <- Falso
							actual     <- lista_cabeza
							Mientras actual <> 0 Y NO encontrado Hacer
								Si lista_id[actual] = temp_id Entonces
									encontrado <- Verdadero
								SiNo
									actual <- lista_sig[actual]
								FinSi
							FinMientras
							Si NO encontrado Entonces
								Escribir "Proceso no encontrado."
							SiNo
								Si pila_tam >= MAX Entonces
									Escribir "ERROR: Pila de memoria llena."
								SiNo
									pila_tope               <- pila_tope + 1
									pila_id[pila_tope]      <- lista_id[actual]
									pila_nombre[pila_tope]  <- lista_nombre[actual]
									pila_memoria[pila_tope] <- lista_memoria[actual]
									pila_tam                <- pila_tam + 1
									
									log_tam             <- log_tam + 1
									log_id[log_tam]     <- temp_id
									log_evento[log_tam] <- "MEMORIA_ASIGNADA"
									log_tiempo[log_tam] <- tiempo_global
									
									tiempo_global       <- tiempo_global + 1
									// CORRECCIÓN línea ~498: eliminadas comillas simples alrededor del nombre
									Escribir "Asignados ", lista_memoria[actual], " MB al proceso ", lista_nombre[actual]
								FinSi
							FinSi
							
						2: // -- Pop --
							Escribir "=== POP (Liberar Memoria) ==="
							Si pila_tope = 0 Entonces
								Escribir "Pila vacia. No hay memoria que liberar."
							SiNo
								// CORRECCIÓN línea ~489: eliminadas comillas simples alrededor del nombre
								Escribir "Liberando: ID:", pila_id[pila_tope], " (", pila_nombre[pila_tope], ") - ", pila_memoria[pila_tope], " MB"
								
								log_tam             <- log_tam + 1
								log_id[log_tam]     <- pila_id[pila_tope]
								log_evento[log_tam] <- "MEMORIA_LIBERADA"
								log_tiempo[log_tam] <- tiempo_global
								
								pila_tope     <- pila_tope - 1
								pila_tam      <- pila_tam - 1
								tiempo_global <- tiempo_global + 1
								Escribir "Memoria liberada correctamente."
							FinSi
							
						3: // -- Ver pila --
							Escribir "=== ESTADO DE LA PILA ==="
							Si pila_tope = 0 Entonces
								Escribir "Pila vacia."
							SiNo
								Escribir "Contenido (tope -> base):"
								Para i <- pila_tope Hasta 1 Con Paso -1 Hacer
									Escribir "  [Nivel ", i, "] ID:", pila_id[i], " | ", pila_nombre[i], " | ", pila_memoria[i], " MB"
								FinPara
								Escribir "Total bloques: ", pila_tam
							FinSi
							
						4: // -- Peek --
							Escribir "=== TOPE DE LA PILA ==="
							Si pila_tope = 0 Entonces
								Escribir "Pila vacia."
							SiNo
								Escribir "ID:", pila_id[pila_tope], " | ", pila_nombre[pila_tope], " | ", pila_memoria[pila_tope], " MB"
							FinSi
							
						0:
							continuar_sub <- Falso
							
						De Otro Modo:
							Escribir "Opcion invalida."
					FinSegun
				FinMientras
				
			4: // ================================================
				//  MÓDULO 4: HISTORIAL / LOG
				// ================================================
				Escribir ""
				Escribir "=== HISTORIAL DE EVENTOS ==="
				Si log_tam = 0 Entonces
					Escribir "Sin eventos registrados."
				SiNo
					Escribir "Total de eventos: ", log_tam
					Escribir "-----------------------------------"
					Para i <- 1 Hasta log_tam Con Paso 1 Hacer
						Escribir "[t=", log_tiempo[i], "] PID:", log_id[i], " -> ", log_evento[i]
					FinPara
					Escribir "-----------------------------------"
				FinSi
				
			5: // ================================================
				//  GUARDAR (Simulado)
				// ================================================
				Escribir "Estado guardado en memoria volatil del simulador. Procesos: ", lista_tam
				log_tam             <- log_tam + 1
				log_id[log_tam]     <- 0
				log_evento[log_tam] <- "GUARDADO_SIMULADO"
				log_tiempo[log_tam] <- tiempo_global
				tiempo_global       <- tiempo_global + 1
				
			6: // ================================================
				//  CARGAR (Simulado)
				// ================================================
				Escribir "Estructuras sincronizadas. Procesos en el sistema: ", lista_tam
				
			0: // ================================================
				//  SALIR
				// ================================================
				Escribir "Sistema cerrado correctamente. Hasta pronto."
				continuar <- Falso
				
			De Otro Modo:
				Escribir "Opcion invalida. Ingrese un numero del 0 al 6."
		FinSegun
	FinMientras

FinAlgoritmo
