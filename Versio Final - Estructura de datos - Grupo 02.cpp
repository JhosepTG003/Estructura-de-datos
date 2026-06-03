#include <iostream>
#include <string>

using namespace std;

// ==========================================
// 1. ESTRUCTURAS DE DATOS BASE
// ==========================================

// Estructura fundamental que simula un PCB (Process Control Block) básico.
// Contiene los datos puros y duros de lo que es un proceso en el sistema operativo.
struct Proceso {
    int id;            // Identificador único del proceso (Ej: 101, 102). No puede repetirse ni ser negativo.
    string nombre;     // Nombre descriptivo del programa (Ej: "Navegador", "Antivirus").
    int prioridad;     // Nivel de urgencia: 1 = Alta, 2 = Media, 3 = Baja.
    int rafaga;        // Tiempo simulado en milisegundos que el proceso ocupará el procesador (Ej: 500ms).
};

// --- Definición de los Nodos para las Estructuras Dinámicas ---
// Recuerda: Un nodo es una "caja" que envuelve los datos y le añade un "gancho" (puntero) para conectarse con otros.

// Nodo diseñado para la Lista Enlazada Simple (Funciona como el Gestor General de Procesos)
struct NodoLista {
    Proceso p;         // La información del proceso que se va a guardar.
    NodoLista* sig;    // Puntero de tipo NodoLista que almacena la dirección de memoria del SIGUIENTE nodo.
};

// Nodo diseñado para la Cola de Prioridad (Funciona como el Planificador de la CPU)
struct NodoCola {
    Proceso p;         // El proceso que está en la fila esperando a que la CPU se libere.
    NodoCola* sig;     // Puntero que enlaza con el siguiente proceso que tiene menor o igual prioridad en la fila.
};

// Nodo diseñado para la Pila (Funciona como el Gestor de Memoria RAM - LIFO)
struct NodoPila {
    int bloqueMemoria; // Dirección de memoria ficticia asignada (Ej: 1000, 1100, 1200).
    int idProceso;     // El ID del proceso que se está adueñando de este bloque de memoria en particular.
    NodoPila* sig;     // Puntero que apunta al bloque de memoria que quedó ABAJO en la pila.
};

// ==========================================
// 2. GESTOR DE PROCESOS (LISTA ENLAZADA SIMPLE)
// ==========================================
class GestorProcesos {
private:
    NodoLista* cabeza; // Puntero "ancla" que siempre apunta al primer nodo de la lista. Si es NULL, la lista está vacía.
public:
    // Constructor de la clase: Se ejecuta automáticamente al crear el objeto. Inicializa la lista vacía.
    GestorProcesos() { 
        cabeza = NULL; 
    }

    // Método para insertar un proceso siempre al final de la lista (Como una fila normal de inserción)
    void agregarProceso(Proceso nuevoProceso) {
        // Paso 1: Crear el nodo de forma dinámica en la memoria usando 'new'
        NodoLista* nuevo = new NodoLista;
        nuevo->p = nuevoProceso; // Guardamos los datos del proceso dentro del nodo.
        nuevo->sig = NULL;       // Como va a ser el último nodo, su puntero 'siguiente' debe mirar a la nada (NULL).

        // Paso 2: Si la lista está vacía, este nuevo nodo se convierte automáticamente en el primero (cabeza).
        if (!cabeza) {
            cabeza = nuevo; 
        } else {
            // Paso 3: Si ya hay nodos, creamos un puntero auxiliar para recorrer la lista sin perder el inicio (cabeza).
            NodoLista* aux = cabeza;
            // El ciclo se detiene exactamente cuando 'aux' esté parado en el ÚLTIMO nodo de la lista.
            while (aux->sig != NULL) {
                aux = aux->sig; // Avanzamos al siguiente nodo de la cadena.
            }
            // Paso 4: Conectamos el último nodo existente con nuestro nuevo nodo.
            aux->sig = nuevo;
        }
        cout << "[+] Proceso " << nuevoProceso.nombre << " registrado en el sistema.\n";
    }

    // Método para recorrer la lista desde el inicio hasta el final e imprimir los datos
    void mostrarProcesos() {
        // Si cabeza es NULL, significa que la lista no tiene elementos.
        if (!cabeza) {
            cout << "No hay procesos registrados.\n";
            return; // Cortamos la ejecución del método aquí mismo.
        }
        
        NodoLista* aux = cabeza; // Empezamos a leer desde el primer nodo.
        cout << "\n--- TABLA DE PROCESOS ---\n";
        cout << "ID\tNombre\tPrioridad\tRafaga(ms)\n";
        
        // El bucle continuará imprimiendo mientras 'aux' apunte a un nodo válido (distinto de NULL).
        while (aux != NULL) {
            cout << aux->p.id << "\t" << aux->p.nombre << "\t" << aux->p.prioridad << "\t\t" << aux->p.rafaga << "\n";
            aux = aux->sig; // Saltamos al siguiente nodo.
        }
        cout << "-------------------------\n";
    }

    // Método de acceso (Getter) para que otras clases o el main puedan ver dónde empieza la lista.
    NodoLista* getCabeza() { 
        return cabeza; 
    }
};

// ==========================================
// 3. GESTOR DE MEMORIA (ESTRUCTURA DE PILA / LIFO)
// ==========================================
class GestorMemoria {
private:
    NodoPila* cima;        // Puntero que siempre mira al nodo de ARRIBA de la pila (el último en llegar).
    int contadorBloques;   // Variable numérica para generar direcciones de memoria (1000, 1100, 1200...).
public:
    // Constructor: Inicializa la pila vacía y define que las direcciones de memoria empezarán en la 1000.
    GestorMemoria() { 
        cima = NULL; 
        contadorBloques = 1000; 
    } 

    // Operación PUSH: Apila un bloque de memoria simulando que un proceso está entrando a la RAM.
    void pushMemoria(int idProceso) {
        // Reservamos memoria para el bloque simulado en la RAM.
        NodoPila* nuevo = new NodoPila;       
        nuevo->idProceso = idProceso;         // Guardamos a qué proceso pertenece.
        nuevo->bloqueMemoria = contadorBloques; // Le asignamos la dirección de memoria actual.
        
        // El nuevo nodo se coloca arriba, por lo que su 'siguiente' es la antigua cima que queda abajo de él.
        nuevo->sig = cima;
        cima = nuevo; // Ahora la cima del sistema pasa a ser nuestro nuevo nodo.
        
        contadorBloques += 100; // Incrementamos en 100 para que el siguiente bloque tenga otra dirección (Ej: 1100).
        cout << "[Memoria] Bloque " << nuevo->bloqueMemoria << " asignado al Proceso ID: " << idProceso << "\n";
    }

    // Operación POP: Desapila (libera) el bloque que esté en la cima (El último que entró es el primero en salir).
    void popMemoria() {
        // Verificamos que la pila no esté vacía antes de intentar borrar algo.
        if (cima != NULL) { 
            NodoPila* aux = cima; // Guardamos temporalmente el nodo de la cima para no perder su dirección.
            cima = cima->sig;     // La cima se desplaza hacia el nodo que estaba abajo.
            
            cout << "[Memoria] Bloque " << aux->bloqueMemoria << " liberado (Proceso ID: " << aux->idProceso << ").\n";
            delete aux; // Destruimos físicamente el nodo liberando la memoria dinámica del sistema.
        }
    }
};

// ==========================================
// 4. PLANIFICADOR CPU (COLA DE PRIORIDAD ORDENADA)
// ==========================================
class PlanificadorCPU {
private:
    NodoCola* frente; // Puntero que apunta al primer proceso de la fila (el que tiene más derecho a usar la CPU).
public:
    // Constructor: Inicializa la fila de espera de la CPU completamente vacía.
    PlanificadorCPU() { 
        frente = NULL; 
    }

    // Método para insertar procesos ordenados automáticamente según su prioridad (1 es más urgente que 3)
    void encolarPorPrioridad(Proceso p) {
        // Creamos el nodo que contendrá al proceso en la cola de la CPU.
        NodoCola* nuevo = new NodoCola;
        nuevo->p = p;
        nuevo->sig = NULL;

        // CASO 1: Si la cola está vacía, O si el nuevo proceso tiene una prioridad más alta (número menor, ej: 1)
        // que el que actualmente está al frente de la cola, se inserta directamente en el primer lugar.
        if (!frente || p.prioridad < frente->p.prioridad) {
            nuevo->sig = frente; // El nuevo nodo apunta al que antes era el primero.
            frente = nuevo;      // El frente de la cola ahora es el nuevo proceso.
        } 
        // CASO 2: El proceso debe buscar su lugar correspondiente en medio o al final de la fila.
        else {
            NodoCola* aux = frente;
            // Avanzamos por la fila mientras el siguiente nodo exista y tenga una prioridad mayor o igual (número menor o igual).
            while (aux->sig != NULL && aux->sig->p.prioridad <= p.prioridad) {
                aux = aux->sig; // Nos movemos un lugar hacia atrás en la fila.
            }
            // Encontrada la posición correcta: insertamos el nuevo nodo entre 'aux' y 'aux->sig'.
            nuevo->sig = aux->sig;
            aux->sig = nuevo;
        }
    }

    // Método que simula el procesamiento secuencial y ordenado de los trabajos.
    void ejecutarProcesos(GestorMemoria& memoria) {
        // Si no hay procesos en el frente de la cola, no hay nada que procesar.
        if (!frente) { 
            cout << "\nNo hay procesos encolados para ejecucion.\n";
            return;
        }

        int relojVirtual = 0; // Contador acumulativo que simula el avance del tiempo en milisegundos.
        cout << "\n--- INICIANDO EJECUCION DE CPU ---\n";
        
        // El ciclo corre de forma continua hasta vaciar por completo la cola de procesos (frente sea NULL).
        while (frente != NULL) {
            NodoCola* atendido = frente; // Tomamos el proceso del frente de la fila.
            frente = frente->sig;        // El segundo proceso de la fila pasa a avanzar al primer puesto.

            cout << "\n[CPU] Atendiendo Proceso: " << atendido->p.nombre << " (Prioridad " << atendido->p.prioridad << ")\n";
            
            // Simulación de asignación en RAM: Metemos el ID del proceso a la Pila de memoria.
            memoria.pushMemoria(atendido->p.id);

            // Simulación del procesamiento según su ráfaga de tiempo.
            cout << "      Simulando procesamiento de " << atendido->p.rafaga << "ms...\n";
            relojVirtual += atendido->p.rafaga; // El reloj avanza sumando los milisegundos consumidos.
            cout << "      Terminado. Tiempo total de sistema actual: " << relojVirtual << " ms virtuales.\n";

            // Simulación de liberación de RAM: Sacamos el proceso de la Pila de memoria.
            memoria.popMemoria();
            
            delete atendido; // Eliminamos de la memoria dinámica el nodo que ya fue completamente procesado.
        }
        cout << "\n--- CPU EN ESTADO INACTIVO (IDLE) ---\n";
        cout << "Tiempo total de ejecucion de todos los procesos: " << relojVirtual << " ms virtuales.\n";
    }
};

// =========
// 5. MAIN 
// =========
int main() {
    // Instanciamos los objetos que controlarán las tres estructuras principales del proyecto.
    GestorProcesos gp; // Lista enlazada.
    GestorMemoria gm;  // Pila.
    PlanificadorCPU cpu; // Cola de prioridad.
    
    int opcion; // Variable que almacenará numéricamente la selección del menú del usuario.

    // Bucle principal del sistema que se mantendrá vivo hasta que el usuario decida salir (opción 5).
    do {
        // Impresión visual de la interfaz del menú de consola.
        cout << "\n===================================\n";
        cout << " SISTEMA DE GESTION DE PROCESOS \n";
        cout << "===================================\n";
        cout << "1. Crear nuevo proceso\n";
        cout << "2. Ver tabla de procesos activos\n";
        cout << "3. Enviar procesos al Planificador de CPU\n";
        cout << "4. Ejecutar procesos en CPU (Simulacion)\n";
        cout << "5. Salir\n";
        
        // La condición obliga a que 'opcion' esté estrictamente entre 1 y 5.
        do {
            cout << "Ingrese opcion: ";
            cin >> opcion; // Captura el número ingresado.
            
            // Si el número está fuera del rango permitido, avisa del error.
            if (opcion < 1 || opcion > 5) {
                cout << "[Error] Opcion invalida. Intente con un numero del 1 al 5.\n";
            }
        } while (opcion < 1 || opcion > 5); // El bucle se repite SIEMPRE que la condición se cumpla (número incorrecto).

        // Estructura Switch-Case para bifurcar el camino del programa según la opción validada.
        switch (opcion) {
            case 1: {
                Proceso p; // Creamos una variable temporal de tipo Proceso para llenarla con datos.
                
                // --- VALIDACION SIMPLE DEL ID ---
                // Obligamos a que el identificador del proceso sea un entero positivo.
                do {
                    cout << "ID del proceso: "; 
                    cin >> p.id;
                    if (p.id <= 0) {
                        cout << "[Error] El ID debe ser un numero positivo mayor a 0.\n";
                    }
                } while (p.id <= 0); // Si ingresa 0 o un negativo, el do-while lo atrapa y vuelve a preguntar.
                
                // Lectura directa de una palabra para el nombre del proceso.
                cout << "Nombre (sin espacios): "; 
                cin >> p.nombre; 
                
                // --- VALIDACION SIMPLE DE LA PRIORIDAD ---
                // Forzamos al usuario a elegir únicamente las opciones lógicas del sistema operativo (1, 2 o 3).
                do {
                    cout << "Prioridad (1-Alta, 2-Media, 3-Baja): "; 
                    cin >> p.prioridad;
                    if (p.prioridad < 1 || p.prioridad > 3) {
                        cout << "[Error] La prioridad tiene que ser exclusivamente 1, 2 o 3.\n";
                    }
                } while (p.prioridad < 1 || p.prioridad > 3); // Si no es 1, 2 ni 3, repite la solicitud.
                
                // --- VALIDACION SIMPLE DE LA RAFAGA ---
                // El tiempo de ejecución en milisegundos obligatoriamente debe ser mayor que cero.
                do {
                    cout << "Rafaga de CPU (en ms, ej. 1500): "; 
                    cin >> p.rafaga;
                    if (p.rafaga <= 0) {
                        cout << "[Error] La rafaga debe ser un numero mayor a 0.\n";
                    }
                } while (p.rafaga <= 0); // Repite si el tiempo ingresado es nulo o negativo.
                
                // Una vez que el objeto 'p' tiene todos sus atributos perfectamente validados, lo registramos.
                gp.agregarProceso(p); 
                break; // Rompe el caso 1 para evitar que se ejecuten los casos de abajo.
            }
            
            case 2:
                gp.mostrarProcesos(); // Llama al recorrido de la lista enlazada para ver los procesos en el sistema.
                break;
                
            case 3: {
                // Recuperamos el puntero inicial de nuestra lista global de procesos.
                NodoLista* aux = gp.getCabeza();
                int cont = 0; // Contador interno para informar cuántos elementos movimos.
                
                // Recorremos toda la lista enlazada original elemento por elemento.
                while(aux != NULL) {
                    // Enviamos una copia de los datos del proceso a la cola ordenada por prioridad del planificador.
                    cpu.encolarPorPrioridad(aux->p);
                    aux = aux->sig; // Pasamos al siguiente eslabón de la lista.
                    cont++; // Sumamos uno al contador de procesos transferidos.
                }
                cout << "[!] " << cont << " procesos encolados exitosamente por prioridad.\n";
                break;
            }
                
            case 4:
                cpu.ejecutarProcesos(gm); // Inicia la descarga automática de la cola simulando el trabajo de la CPU.
                break;
                
            case 5:
                cout << "\nSaliendo del sistema...\n";
                break;
        }

	
    } while (opcion != 5); // Rompe el ciclo maestro de la aplicación únicamente si se seleccionó la opción de salida (5).

    return 0; // Finaliza la ejecución del método principal devolviendo un estado sin errores al sistema operativo.
}
