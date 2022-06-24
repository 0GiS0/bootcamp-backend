# Hello world

## Objetivo

En este apartado vamos a ver los conceptos básicos de cómo crear nuestra primera aplicación .net usando la herramienta Visual Studio.

## Primeros pasos

Vamos a descargar la última versión _Visual Studio Community_ del siguiente [enlace](https://visualstudio.microsoft.com/es/vs/community/).

Podemos usar la licencia de la versión community si cumplimos las siguiente restricciones:

- Desarrolladores individuales, es decir, los que trabajan por su cuenta y no para una empresa, y los que programan por afición o gusto, pero no por trabajo.
- Los estudiantes, y los alumnos de empresas como campusMVP, que están aprendiendo a desarrollar usando Visual Studio.
- Los investigadores y aquellos que lo usan para ciencia de datos, crear aplicaciones que les ayuden con sus investigaciones, etc... que lo utilizan desde un entorno académico.
- Proyectos Open Source. Si el proyecto que desarrollas es de código abierto, entonces lo puedes utilizar sin problema, aunque seáis muchos colaborando en él.
- Organizaciones no empresariales. Si tu empresa tiene menos de 250 usuarios de PC (sean o no programadores) y factura menos de 1 millón de dólares, según Microsoft no sois "empresa" y podréis usar Visual Studio Community sin problemas hasta un máximo de 5 usuarios al mismo tiempo.

## Tipos de proyectos de Visual Studio

Una vez instalado, vamos a iniciar la herramienta y creamos nuestro primer proyecto.

![Crear un proyecto](./content/new_project.png)

El siguiente paso que nos encontramos es el de elegir que tipo de proyecto vamos a crear. Tenemos un amplio abanico de posibilidades (dependiendo de los complementos que hayamos elegido a la hora de hacer la instalación) pero los más básicos son:

- Aplicaciones de consola.
- Aplicaciones Windows/WPF.
- Aplicaciones Web: ASP.NET, Web api...

![Tipos de proyectos](./content/type_projects.png)

## Crear el proyecto

Vamos a seleccionar como tipo de proyecto "Aplicación de consola" (versión net Framework) para nuestro _hello-word_. Ahora rellenar los datos básicos de nuestra aplicación:

- Nombre del proyecto.
- Ubicación.
- Nombre de la solución.

![Datos básicos del proyecto](./content/basic_data_project.png)

> **Pregunta a los estudiantes** ¿Qué diferencia hay entre _solución_ y _proyecto_?.

Una solución es un conjunto de proyectos. Cada proyecto de una solución dará como resultado un ensamblado.

Sería conveniente dar un nombre diferente a la solución y al proyecto.

El último paso es seleccionar el framework con el que vamos a crear nuestro proyecto.

## Analizando la creación base de nuestra aplicación

Vamos a ver cual es el resultado que obtenemos:

### A nivel de carpeta

Vemos que se ha creado una carpeta con el nombre de la solución donde dentro tenemos los siguientes elementos:

![Carpeta de la solución](./content/solution_folder.png)

- .vs: Carpeta oculta para la gestión del visual studio code.
- carpeta del proyecto.
- fichero de la solución (extensión *.sln)

Dentro de la carpeta del proyecto vemos los ficheros que se han creado de forma automática. Vamos a destacar varios ficheros/carpetas:

![Carpeta del proyecto](./content/project_folder.png)

- bin: Donde se generará el ensamblado de nuestro proyecto.
- obj: Donde se generará los ficheros compilados. (Dos fases: Compile y Link)
- Properties: Propiedades de nuestro proyecto (definiciones de ejecución, información del ensamblado, etc...)
- fichero de definición del proyecto (extensión *.csproj).
- App.config: Fichero de configuración del proyecto.

### A nivel de código

Vamos a ver el código generado:

![Código inicial](./content/initial_code.png)

Antes de meternos a explicar conceptos como clases, métodos, vamos a ver conceptos básicos que se pueden observar en este código inicial:

- El lenguaje C# es case-sensitive. Cuando creamos una variable, clase, método... el identificador que asignamos diferencia entre las mayúsculas y minúsculas.
- Para limitar bloques de código utilizamos { y }.
- Las instrucciones terminan con ;
- Si necesitamos incluir comentarios en nuestro código podemos utilizar // o /* y */.
- Con _namespace_ podemos organizar las clases que vamos a ir creando.
- Si necesitamos una clase que no está en nuestro _namespace_ podemos acceder a ella si hacemos un _using_ de su _namespace_

## Compilar

Vamos a crear una aplicación simple para ver cómo podemos ejecutarla.

```diff
namespace hello_world_project
{
    internal class Program
    {
        static void Main(string[] args)
        {
+            var a = 1;
+            a = a + 1;
+            Console.WriteLine(a);
+            Console.ReaLine();
        }
    }
}
```

Vale, ya podemos ejecutar nuestra aplicación. Lo podemos hacer de varias formas:

- Desde el menu _Debug > Start Debugging_

![Start desde el menu](./content/start_menu.png)

- Pulsando el botón _Start_

![Start desde el botón](./content/start_button.png)

- Pulsando la tecla F5

Pero, ojo nuestro código no funciona! En la ventana de _Output_ vemos como se ha detectado un problema en nuestro código. Hemos escrito mal el nombre del método _Readline_ por tanto la aplicación no se puede ejecutar.

Desde la ventana de _Error List_ podemos movernos de forma rápida a la linea donde se ha detectado el problema. Vamos a solucionarlo:

```diff
namespace hello_world_project
{
    internal class Program
    {
        static void Main(string[] args)
        {
+            var a = 1;
+            a = a + 1;
+            Console.WriteLine(a);
-            Console.ReaLine();
+            Console.ReadLine();
        }
    }
}
```

Ahora si podemos ejecutar la aplicación y ver el resultado por consola.

## Depuración de código

Una herramienta muy importante que tendremos que ir usando a lo largo de todo el desarrollo de nuestra aplicación es la depuración. Visual Studio nos permite depurar (_debug_) de forma muy sencilla. Vamos a verlo en nuestro código.

Tal vez nos interese ver el valor de la variable a antes de hacer el commando _WriteLine_ para ello nos colocaremos en la linea anterior y pulsamos el botón derecho del ratón. En el menu contextual que nos aparece podemos añadir el breakpoint pulsando _Breakpoint > Insert Breakpoint_

![Insertar breakpoint desde el menu](./content/add_breakpoint_menu.png)

Otra forma mas sencilla es simplemente haciendo click en la linea que queramos insertar nuestro breakpoint a la izquierda del numero (sobre la banda gris)

![Insertar breakpoint](./content/add_breakpoint.png)

Ahora ya podemos arrancar otra vez nuestra aplicación pulsando F5.

¿Qué ha pasado? Nuestro código se ha parado en la linea donde teníamos nuestro breakpoint.

![Breakpoint activo](./content/active_breakpoint.png)

En el estado de depuración disponemos de muchas herramientas. Podemos destacar dos grupos:

- Herramienta de diagnostico (Diagnostic Tool): Donde podemos ver datos de uso de memoria, procesador ... etc.

![Herramienta de diagnostico](./content/diagnostic_tool.png)

- Estado de variables (Auto, local, Watch): Donde podemos ver e incluso cambiar el valor de una variable.

![Estado de variables](./content/watch_variable.png)

Vamos a cambiar el valor de la variable i. Para ello hacemos un doble click sobre la columna _value_ y ponemos 10 como nuevo valor y pulsamos enter.

En este punto podemos hacer las siguientes acciones:

- Ejecutar el siguiente paso dentro de la función (F11).
- Ejecutar el siguiente paso sin entrar en la función (F10).
- Saltar al siguiente breakpoint (F5).

Una vez finalizada la ejecución podemos ver como el resultado por pantalla es 11 porque se ha tenido en cuenta la modificación que hemos realizado en el valor de la variable.

Por otro lado, si no necesitamos el modo depuración podemos ejecutar la aplicación sin depuración, pulsando Ctrl + F5 o el icono ![Sin depuración](./content/without_debug.png)

## Otras herramientas

### Intelisense

Visual Studio dispone de una herramienta muy interesante que nos propone sugerencias a la hora de escribir nuestro código.

![Intelisense](./content/intelisense.png)

### Destornillador/bombilla

Otras herramientas muy útiles son las acciones rápidas o refactorización de código. Para realizar dichas acciones Visual Studio nos muestra 3 tipos de iconos:

- ![Destronillador](./content/screwdriver.png): indica que hay acciones disponibles para cambiar el código, pero no es necesario usarlas.
- ![Bombilla](./content/lightbulb.png): indica que hay acciones disponibles que debe llevar a cabo para mejorar el código.
- ![Bombilla con error](./content/lightbulb_error.png): indica que hay una acción disponible que corrige un error del código.

Vamos a modificar nuestro código para ver como se utilizan estas herramientas:

```diff
namespace hello_world_project
{
    internal class Program
    {
        static void Main(string[] args)
        {
             var a = 1;
-             a = a + 1;
+            a = a * Math.PI;
             Console.WriteLine(a);
             Console.ReadLine();
        }
    }
}
```

Aparece un error porque no sabe como convertir un valor double a int (lo veremos mas adelante). Si ponemos el ratón encima del error y esperamos unos segundo aparecerá la bombilla indicando que hay un error y nos propone las soluciones disponibles.

![Solución de problema](./content/fix_cast_problem.png)

Seleccionamos la opción _Add explicit cast_ para hacer el casting de forma automática y el problema queda solventado.

Otra acción que podemos realizar es la refactorizacion de código. Vamos a verlo en el ejemplo.

Seleccionamos **(int)(a * Math.PI)** y esperamos unos segundo a que aparezca el destornillador. Al hacer click sobre le destornillador se nos presentan todas las posible acciones que podemos realizar para mejorar el código.

![Refactorización](./content/refactor.png)

Vamos a seleccionar la opción _Extract method_ y vemos como se crea de forma automática un nuevo método al que podemos renombrar a _MultiploPI_. Y con esto tendremos refactorizado nuestro código.
