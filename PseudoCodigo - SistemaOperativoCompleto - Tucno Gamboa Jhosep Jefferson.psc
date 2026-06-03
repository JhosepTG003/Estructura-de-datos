Algoritmo SistemaOperativoCompleto
    
    // Configuracion general
    Definir MAX_CAPACIDAD Como Entero
    MAX_CAPACIDAD <- 100
    
    // ==========================================
    // 1. VARIABLES PARA LA LISTA (Gestor de Procesos)
    // ==========================================
    Definir cantLista, listaIds Como Entero
    Definir listaNombres Como Cadena
    cantLista <- 0
    Dimension listaIds[MAX_CAPACIDAD]
    Dimension listaNombres[MAX_CAPACIDAD]
    
    // ==========================================
    // 2. VARIABLES PARA LA COLA (Planificador CPU)
    // ==========================================
    Definir cantCola, colaIds, colaPrioridad Como Entero
    cantCola <- 0
    Dimension colaIds[MAX_CAPACIDAD]
    Dimension colaPrioridad[MAX_CAPACIDAD]
    
    // ==========================================
    // 3. VARIABLES PARA LA PILA (Gestor Memoria)
    // ==========================================
    Definir topePila, pilaTamanos Como Entero
    topePila <- 0
    Dimension pilaTamanos[MAX_CAPACIDAD]
    
    // ==========================================
    // PRUEBAS DE LOS ALGORITMOS
    // ==========================================
    Escribir "=== PRUEBA DE LISTA (GESTOR DE PROCESOS) ==="
    RegistrarProceso(listaIds, listaNombres, cantLista, MAX_CAPACIDAD, 101, "Chrome")
    RegistrarProceso(listaIds, listaNombres, cantLista, MAX_CAPACIDAD, 102, "Word")
    
    Escribir " "
    Escribir "=== PRUEBA DE COLA (PLANIFICADOR DE CPU) ==="
    PlanificarProceso(colaIds, colaPrioridad, cantCola, MAX_CAPACIDAD, 101, 3)
    PlanificarProceso(colaIds, colaPrioridad, cantCola, MAX_CAPACIDAD, 102, 1)
    
    Escribir " "
    Escribir "=== PRUEBA DE PILA (GESTOR DE MEMORIA) ==="
    AsignarMemoria(pilaTamanos, topePila, MAX_CAPACIDAD, 1024)
    AsignarMemoria(pilaTamanos, topePila, MAX_CAPACIDAD, 2048)
    
FinAlgoritmo

// ==========================================
// SUBPROCESO 1: LISTA (Insertar al final)
// ==========================================
SubProceso RegistrarProceso(listaIds Por Referencia, listaNombres Por Referencia, cantActual Por Referencia, max, id, nombre)
    Si cantActual >= max Entonces
        Escribir "Error: Tabla de procesos llena."
    Sino
        cantActual <- cantActual + 1
        listaIds[cantActual] <- id
        listaNombres[cantActual] <- nombre
        Escribir "Exito: Proceso agregado a la lista en el indice ", cantActual
    FinSi
FinSubProceso

// ==========================================
// SUBPROCESO 2: COLA DE PRIORIDAD (Insertar ordenado)
// ==========================================
SubProceso PlanificarProceso(colaIds Por Referencia, colaPrioridad Por Referencia, cantCola Por Referencia, max, id, prioridad)
    Definir pos, i Como Entero
    Si cantCola >= max Entonces
        Escribir "Error: Cola de CPU llena."
    Sino
        pos <- 1
        Mientras (pos <= cantCola) Y (colaPrioridad[pos] <= prioridad) Hacer
            pos <- pos + 1
        FinMientras
        
        Para i <- cantCola Hasta pos Con Paso -1 Hacer
            colaIds[i+1] <- colaIds[i]
            colaPrioridad[i+1] <- colaPrioridad[i]
        FinPara
        
        colaIds[pos] <- id
        colaPrioridad[pos] <- prioridad
        cantCola <- cantCola + 1
        Escribir "Exito: Proceso ID ", id, " encolado con prioridad ", prioridad
    FinSi
FinSubProceso

// ==========================================
// SUBPROCESO 3: PILA (Push - Insertar al tope)
// ==========================================
SubProceso AsignarMemoria(pilaTamanos Por Referencia, tope Por Referencia, max, tamanoBloque)
    Si tope >= max Entonces
        Escribir "Error: Desbordamiento de pila de memoria."
    Sino
        tope <- tope + 1
        pilaTamanos[tope] <- tamanoBloque
        Escribir "Exito: Memoria de ", tamanoBloque, " MB asignada en el bloque ", tope
    FinSi
FinSubProceso