# Introducción a la demo

Para no perder el tiempo con una aplicación creada desde cero, y que además tengamos todas las partes que necesitamos para entender todo lo que te ofrece Microsoft Azure, vamos a utilizar el front-end del tutorial de Angular Tour of Heroes, con unas ligeras modificaciones 😙

![Tour of Heroes](./imagenes/tour-of-heroes.png)

 Si quieres generarlo por tu cuenta desde cero los pasos aquí: [https://angular.io/tutorial/tour-of-heroes](https://angular.io/tutorial/tour-of-heroes), pero no te hará falta para esta clase. El resultado del mismo puedes encontrarlo en [01-stack-relacional/03-cloud/azure/01-depliegue-de-tu-primera-app/front-end](front-end/).

Para comprobar que funciona correctamente lanza los siguientes comandos:

```bash
cd front-end
npm install
npm start
```

Este tutorial termina con una API en memoria como parte de la solución, pero nosotros queremos que sea una API real y que se conecte a una base de datos real. 

Por ello, para el backend, he creado una API en .NET Core, utilizando Entity Framework, y que se apoya en un SQL Server, que devolverá los héroes y nos permitirá manipularlos. Para ello he utilizado este otro tutorial para crear APIs en .NET donde está orientado a una lista de TODOs y yo simplemente lo he cambiado a la lista de héroes que necesitamos: https://docs.microsoft.com/es-es/aspnet/core/tutorials/first-web-api?view=aspnetcore-5.0&tabs=visual-studio-code 

El resultado final lo puedes encontrar en la carpeta back-end de este repositorio.

Para que esta API pueda funcionar necesitarás además de una base de datos SQL Server. Como venimos de una clase de Docker en tres horas 😙 y sabemos que podemos utilizar un contenedor para hospedar la misma vamos a crearlo con el siguiente comando:

```bash
docker run \
--name sqlserver \
-e 'ACCEPT_EULA=1' \
-e 'MSSQL_SA_PASSWORD=Password1!' \
 -v mssqlserver_volume:/var/opt/mssql \
-p 1433:1433 \
-d mcr.microsoft.com/azure-sql-edge
```
Ahora entra en el directorio `back-end` y ejecuta la API:

```bash
cd back-end
dotnet run
```

Si todo ha ido bien, deberías poder acceder a la API en `https://localhost:5001/api/hero` y verás que te devolverá un JSON vacío, ya que todavía no hemos añadido ningún héroe.

Para añadir algunos y que veas que la aplicación funciona puedes utilizar el archivo `client.http` que encontrarás en la carpeta `back-end` y que puedes ejecutar con la extensión de Visual Studio Code `REST Client`.

Ahora que ya tienes todas las piezas necesarias para la demo, vamos a desplegarlas en Azure.

## Instalación de Azure CLI

Para poder desplegar nuestra aplicación en Azure necesitamos instalar Azure CLI. Puedes encontrar las instrucciones para tu sistema operativo en la siguiente URL: [https://docs.microsoft.com/es-es/cli/azure/install-azure-cli](https://docs.microsoft.com/es-es/cli/azure/install-azure-cli)

Una vez lo tengas el siguiente paso es iniciar sesión en Azure con el siguiente comando:

```bash
az login
```

## Configura tus variables de entorno

Para que sea más sencillo modificar el nombre que le des a las cosas, utiliza las siguientes variables de entorno:

```bash
# Generales
RESOURCE_GROUP=tour-of-heroes
LOCATION=westeurope

# Base de datos
SQL_SERVER_NAME=tour-of-heroes-sql
SQL_SERVER_USERNAME=sqladmin
SQL_SERVER_PASSWORD=Password1!

# Front-end
FRONT_END_NAME=tour-of-heroes-web

# Backend
BACK_END_NAME=tour-of-heroes-api
```

## Creación de un grupo de recursos

Todo lo que despleguemos en Azure debe estar dentro de un grupo de recursos. Para crear uno nuevo ejecuta el siguiente comando:

```bash
az group create --name $RESOURCE_GROUP --location $LOCATION
```

Ahora ya tienes un sitio donde desplegar los diferentes componentes.

## Despliegue de la base de datos

Para poder desplegar la base de datos donde se almacenarán los héroes primero necesitas un servidor de SQL Server. En el caso de Azure dispones de un servicio llamado Azure SQL que es el que vamos a utilizar.

Para crear un servidor de SQL Server ejecuta el siguiente comando:

```bash
az sql server create \
--name $SQL_SERVER_NAME \
--resource-group $RESOURCE_GROUP \
--location $LOCATION \
--admin-user $SQL_SERVER_USERNAME \
--admin-password $SQL_SERVER_PASSWORD
```

Para este ejemplo no te hace falta nada más, ya que la base de datos se creará de forma automática dentro de este cuando arranquemos la API con la nueva cadena de conexión.

La misma tendrá esta forma: 

```bash
echo "Server=$SQL_SERVER_NAME.database.windows.net,1433;Initial Catalog=heroes;Persist Security Info=False;User ID=$SQL_SERVER_USERNAME;Password=$SQL_SERVER_PASSWORD;Encrypt=False"
```
Reemplaza la misma en el archivo de configuración `appsettings.Development.json` que encontrarás en la carpeta `back-end` de este repositorio.

Si ahora vuelves a acceder a la API te darás cuenta de que te encuentras con un error parecido al siguiente:

`SqlException: Cannot open server 'tour-of-heroes-sql' requested by the login. Client with IP address 'XX.XXX.XXX.XXX' is not allowed to access the server. To enable access, use the Azure Management Portal or run sp_set_firewall_rule on the master database to create a firewall rule for this IP address or address range. It may take up to five minutes for this change to take effect.`

Esto es debido a que Azure SQL Server tiene un firewall que por defecto no permite el acceso a nadie. Para solucionar esto necesitas añadir una regla de firewall que permita el acceso a tu IP. Puedes hacerlo con el siguiente comando:

```bash
az sql server firewall-rule create \
--resource-group $RESOURCE_GROUP \
--server $SQL_SERVER_NAME \
--name AllowYourIp \
--start-ip-address $(curl ifconfig.me) \
--end-ip-address $(curl ifconfig.me)
```
Si ahora vuelves a acceder a la API verás que ya no te da ningún error y que puedes añadir héroes a la base de datos, de la misma forma que lo hiciste con la que tienes ejecutándose en Docker.

