# Almacenando assets en Microsoft Azure

En la clase anterior ya viste lo sencillo que era desplegar nuestro Tour Of Heroes en Microsoft Azure, usando SQL Azure, para la base de datos, App Service, para la API en .NET, y Azure Static Web Apps, para el frontal en Angular. En esta clase vamos a ver cómo almacenar los assets de nuestra aplicación en el servicio Azure Storage.

## ¿Qué es un asset?

Un asset es cualquier recurso que necesite ser almacenado y servido a través de la web. Puede ser una imagen, un archivo de audio, un video, un archivo de texto, un archivo de configuración, etc.

En Microsoft Azure tenemos justamente lo que necesitamos y se llama Azure Storage. Azure Storage es un servicio de almacenamiento en la nube que es seguro, escalable, duradero y altamente disponible. Puedes almacenar cualquier tipo de archivo y acceder a él desde cualquier lugar del mundo.

**El objetivo de la clase de hoy será que nuestra aplicación Angular se modernice un poco para que nuestro héroes tengan cara y capa, además de poder ver su identidad secreta**. Para ello, vamos a almacenar las imágenes de nuestros héroes en Azure Storage. Pero antes, vamos a probar la aplicación en local con los cambios:

En primer lugar asegurate que la base de datos, que teníamos ejecutándose en Docker, sigue en marcha. Si no es así, ejecuta el siguiente comando:

```bash
docker start sqlserver
```

Ejecuta los siguientes comandos para cargar la API:

```bash
cd 01-stack-relacional/03-cloud/azure/02-almacenando-assets/back-end
dotnet run
```

entra en el directorio `front-end` de esta clase y ejecuta los siguientes comando para cargar la interfaz:

```bash
cd 01-stack-relacional/03-cloud/azure/02-almacenando-assets/front-end
npm install
npm start
```

Como puedes ver, ahora los héroes tienen una imagen de perfil. 

<img src="docs-img/Tour of heroes con imágenes.png">

Si haces clic en el nombre del héroe, podrás ver su identidad secreta. Ahora vamos a subir estas imágenes a Azure Storage.

<img src="docs-img/Identidad secreta en tour of heroes.png">

Estas imágenes a día de hoy forman parte del código de la aplicación, pero lo ideal es que estuvieran en un lugar independiente, como Azure Storage, para que puedan ser actualizadas sin necesidad de desplegar la aplicación, además de que hará que mejorar el rendimiento de la aplicación.

## Creando una cuenta de Azure Storage

Antes de crear la cuenta de Azure Storage vamos a recuperar la variable que creamos en la clase anterior con el grupo de recursos. Abre una terminal y ejecuta el siguiente comando:

```bash
RESOURCE_GROUP="tour-of-heroes"
```

También vamos a cargar una variable con el nombre de la cuenta de Azure Storage que vamos a crear y la localización:

```bash
STORAGE_ACCOUNT="heroespics"
LOCATION="westeurope"
```

Ahora vamos a crear la cuenta de Azure Storage. Abre una terminal y ejecuta el siguiente comando:

```bash
az storage account create \
--resource-group $RESOURCE_GROUP \
--name $STORAGE_ACCOUNT \
--location $LOCATION \
--sku Standard_LRS \
--allow-blob-public-access
```

>Nota: a día de hoy hay que utilizar la opción `--allow-blob-public-access` para que nos permita tener contenedores con acceso público, porque de lo contrario no nos dejará crearlos.

Una vez que tenemos la cuenta creada el siguiente paso es crear dos contendores, uno para las imágenes de los héroes y otro para las imágenes de las identidades secretas o alter egos. Estos contenedores nos permiten organizar los archivos que almacenamos en Azure Storage, además de gestionar los permisos de acceso a los mismos.

```bash
az storage container create \
--name heroes \
--account-name $STORAGE_ACCOUNT \
--public-access blob
```

Como puedes ver, este contenedor se llama `heroes` y tiene acceso público. Esto significa que cualquier persona que conozca la URL de una imagen podrá acceder a ella. En el caso de las imágenes de los héroes, esto es lo que queremos, ya que queremos que todos sepan cómo son nuestros héroes.

Ahora vamos a crear un segundo contenedor llamado `alteregos` para las imágenes de las identidades secretas, el cual debe ser privado:

```bash
az storage container create \
--name alteregos \
--account-name $STORAGE_ACCOUNT
```

En este caso el contenedor `alteregos` es privado, lo que significa que solo las personas que tengan una URL firmada podrán acceder a las imágenes. Esto es lo que queremos para las identidades secretas de nuestros héroes.

## Subiendo las imágenes a Azure Storage

Para subir las imágenes a Azure Storage tenemos varias formas: 

- A través del portal de Azure.
- Usando Microsoft Azure Storage Explorer.
- Usando la interfaz de línea de comandos de Azure.
- Usando AzCopy
- Alguna librería de cliente para Azure Storage.
- A través de la API REST de Azure Storage.

Para hacerlo a través de la línea de comandos puedes utilizar el siguiente comando:

```bash
az storage blob upload-batch \
--destination alteregos \
--source 01-stack-relacional/03-cloud/azure/02-almacenando-assets/front-end/src/assets/alteregos/. \
--account-name $STORAGE_ACCOUNT
```

Como ves, con tan solo un comando hemos subido todos los alter egos de nuestros héroes a Azure Storage. Ahora vamos a subir las imágenes de los héroes:

```bash
az storage blob upload-batch \
--destination heroes \
--source 01-stack-relacional/03-cloud/azure/02-almacenando-assets/front-end/src/assets/heroes/. \
--account-name $STORAGE_ACCOUNT
```

Si ahora vas al portal, o a Azure Storage Explorer, podrás comprobar que las imágenes están subidas a tu nueva cuenta en el contenedor correspondiente.

## Actualizando la aplicación para que use las imágenes de Azure Storage

Si bien es cierto que nuestras imágenes están ya en la nube, nuestra aplicación sigue haciendo uso de la copia que tiene en local. Vamos a cambiar esto para que nuestra aplicación use las imágenes de Azure Storage.

Para ello ve al archivo `01-stack-relacional/03-cloud/azure/02-almacenando-assets/front-end/src/app/heroes/heroes.component.html`y modificalo de la siguiente manera:

```html
<h2>My heroes</h2>
<div>
  <label for="new-hero">Hero name: </label>
  <input id="new-hero" #heroName />
  <button class="add-button" (click)="add(heroName.value); heroName.value = ''">
    Add hero
  </button>
</div>

<div id="features-wrapper">
  <div class="container">
    <div class="row">
      <div class="col-4 col-12-medium" *ngFor="let hero of heroes">
        <!-- Box -->
        <section class="box feature">
          <!-- <a routerLink="/detail/{{ hero.id }}" class="image featured"
            ><img
              src="assets/heroes/{{
                hero.name | lowercase | replace: ' ' : '-'
              }}.jpeg"
              alt=""
          /></a> -->
          <a routerLink="/detail/{{hero.id}}" class="image featured">
            <img
              src="https://heroespics.blob.core.windows.net/heroes/{{hero.name | lowercase | replace: ' ':'-'}}.jpeg"
              alt="" />
          </a>
          <div class="inner">
            <header>
              <h2>{{ hero.name }}</h2>
            </header>
            <p>{{ hero.description | slice: 0 : 150 }}...</p>
            <button (click)="delete(hero)">Delete</button>
          </div>
        </section>
      </div>
    </div>
  </div>
</div>
```

Lo único que he hecho ha sido comentar la línea que hace referencia a la imagen local y añadir una nueva línea que hace referencia a la imagen de Azure Storage. ¿Fácil verdad? 😉

Ahora vamos a hacer lo mismo con el archivo `01-stack-relacional/03-cloud/azure/02-almacenando-assets/front-end/src/app/hero-detail/hero-detail.component.html`:

```html
<div id="features-wrapper">
  <div class="container">
    <div class="row" *ngIf="hero">
      <div class="col-5 col-12-medium">
        <!-- Box -->
        <section class="box feature">
          <!-- <a routerLink="/detail/{{ hero.id }}" class="image featured"
            ><img
              src="assets/alteregos/{{
                hero.alterEgo | lowercase | replace: ' ' : '-'
              }}.png"
              alt=""
          /></a> -->
          <a routerLink="/detail/{{hero.id}}" class="image featured">
            <img src="https://heroespic.blob.core.windows.net/alteregos/{{hero.alterEgo | lowercase | replace: ' ':'-'}}.png" alt="" />
          </a>
        </section>
      </div>
      <div class="col-7">
        <form>
          <div class="form-group">
            <label for="hero-name">
              <input
                id="hero-name"
                [(ngModel)]="hero.name"
                [ngModelOptions]="{ standalone: true }"
                placeholder="Name"
              />
              <span>Hero name</span>
            </label>
          </div>
          <div class="form-group">
            <label for="hero-name">
              <input
                id="hero-name"
                [(ngModel)]="hero.alterEgo"
                [ngModelOptions]="{ standalone: true }"
                placeholder="Alter ego"
              />
              <span>Alter ego</span>
            </label>
          </div>
          <div class="form-group">
            <label for="hero-name">
              <textarea
                id="hero-description"
                [(ngModel)]="hero.description"
                [ngModelOptions]="{ standalone: true }"
                placeholder="Description"
              ></textarea>
              <span>Description</span>
            </label>
          </div>
          <div class="buttons">
            <button (click)="save()">Save</button>
            <button (click)="goBack()">Go back</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>
```

Pero... Ops! 🧐 en este caso no funciona ¿Por qué? Si abrimos las **Developer Tools** vemos que tenemos un error.

<img src="docs-img/Error con el contenedor privado.png" />

Pero ¿cómo qué no existe? Si acabamos de subir las imágenes. Pues bien, el problema es que el contenedor `alteregos` es privado, por lo que necesitamos que alguien con permisos las recupere por vosotros. La mejor forma de hacer eso es modificar nuestra API para que nos devuelva estos alter egos.

## Devolviendo los alter egos a través de la API

En nuestra carpeta `back-end` tienes que descomentar el método `GetAlterEgoPic`el cuál se encarga de devolver la URL firmada de la imagen del alter ego. El método debería quedar de la siguiente manera:

```csharp
        // GET: api/hero/alteregopic/5
        [HttpGet("alteregopic/{id}")]
        public async Task<ActionResult<Hero>> GetAlterEgoPic(int id)
        {
            var hero = await _context.Heroes.FirstOrDefaultAsync(h => h.Id == id);

            if (hero == null)
            {
                return NotFound();
            }

            //Get image from Azure Storage
            string connectionString = Environment.GetEnvironmentVariable("AZURE_STORAGE_CONNECTION_STRING");
            
            // Create a BlobServiceClient object which will be used to create a container client
            var blobServiceClient = new BlobServiceClient(connectionString);

            //Get container client
            var containerClient = blobServiceClient.GetBlobContainerClient("alteregos");

            //Get blob client
            var blob = containerClient.GetBlobClient($"{hero.AlterEgo.ToLower().Replace(' ', '-')}.png");

            //Get image from blob
            var image = await blob.DownloadStreamingAsync();

            //return image
            return File(image.Value.Content, "image/png");
        }
```

Este como ves es un método muy sencillo que se encarga de devolver la imagen del alter ego. Para que esto funcione he tenido que agregar el paquete de nuget  `Azure.Storage.Blobs` en el proyecto. 

```bash
dotnet add package Azure.Storage.Blobs 
```

Y añadir el using correspondiente en el archivo `Controllers/HeroController.cs`:

```csharp
using Azure.Storage.Blobs;
```

Ahora vamos a guardar en una variable la cadena de conexión necesaria para que esta pueda comunicarse con Azure Storage. En el terminal de la API lanza lo siguiente:

```bash
STORAGE_ACCOUNT="heroespics"
RESOURCE_GROUP="tour-of-heroes"

CONNECTION_STRING=$(az storage account show-connection-string \
--name $STORAGE_ACCOUNT \
--resource-group $RESOURCE_GROUP \
--query connectionString \
--output tsv)
```

Ahora que ya la tienes vamos a setear la variable de entorno que nuestra API necesita para poder comunicarse con Azure Storage.

```bash
AZURE_STORAGE_CONNECTION_STRING=$CONNECTION_STRING dotnet run
```

Y voi lá! Ahora si que si, si vamos a la URL `https://localhost:5001/api/hero/alteregopic/2` deberíamos ver la imagen del alter ego de nuestro héroe.

Ahora solo queda que nuestro frontal en Angular sepa llamar a esta nueva acción de nuestra API. Para ello añade en `01-stack-relacional/03-cloud/azure/02-almacenando-assets/front-end/src/app/hero.service.ts`el siguiente método:

```typescript
  getAlterEgoPic(id: number): Observable<Blob> {
    return this.http.get(`${this.heroesUrl}/alteregopic/${id}`, { responseType: 'blob' });
  }
```

y modifica `01-stack-relacional/03-cloud/azure/02-almacenando-assets/front-end/src/app/hero-detail/hero-detail.component.ts` para que llame a este nuevo método:

```typescript
import { Component, OnInit, Input } from '@angular/core';
import { Hero } from '../hero';
import { ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';
import { HeroService } from '../hero.service';

@Component({
  selector: 'app-hero-detail',
  templateUrl: './hero-detail.component.html',
  styleUrls: ['./hero-detail.component.css']
})
export class HeroDetailComponent implements OnInit {

  @Input() hero?: Hero;
  alterEgoPic?: any;

  constructor(private route: ActivatedRoute, private heroService: HeroService, private location: Location) { }

  ngOnInit(): void {
    this.getHero();
  }

  getHero(): void {
    const id = Number(this.route.snapshot.paramMap.get('id'));
    this.heroService.getHero(id).subscribe(hero => this.hero = hero);
    
    this.heroService.getAlterEgoPic(id).subscribe(alterEgoPic => {
      let reader = new FileReader();
      reader.onload = (e: any) => {
        this.alterEgoPic = e.target.result;
      };
      
      if (alterEgoPic){
        reader.readAsDataURL(alterEgoPic);
      }
      
    });
  }

  goBack(): void {
    this.location.back();
  }

  save(): void {
    if (this.hero) {
      this.heroService.updateHero(this.hero)
        .subscribe(() => this.goBack());
    }
  }

}
```

Y ya por último modifica `01-stack-relacional/03-cloud/azure/02-almacenando-assets/front-end/src/app/hero-detail/hero-detail.component.html` para que muestre la imagen del alter ego:

```html
<div id="features-wrapper">
  <div class="container">
    <div class="row" *ngIf="hero">
      <div class="col-5 col-12-medium">
        <!-- Box -->
        <section class="box feature">
          <!-- <a routerLink="/detail/{{ hero.id }}" class="image featured"
            ><img
              src="assets/alteregos/{{
                hero.alterEgo | lowercase | replace: ' ' : '-'
              }}.png"
              alt=""
          /></a> -->
          <!-- <a routerLink="/detail/{{hero.id}}" class="image featured">
            <img src="https://heroespics.blob.core.windows.net/alteregos/{{hero.alterEgo | lowercase | replace: ' ':'-'}}.png" alt="" />
          </a> -->
          <a routerLink="/detail/{{hero.id}}" class="image featured"><img src="{{alterEgoPic}}" alt="" /></a>
        </section>
      </div>
      <div class="col-7">
        <form>
          <div class="form-group">
            <label for="hero-name">
              <input
                id="hero-name"
                [(ngModel)]="hero.name"
                [ngModelOptions]="{ standalone: true }"
                placeholder="Name"
              />
              <span>Hero name</span>
            </label>
          </div>
          <div class="form-group">
            <label for="hero-name">
              <input
                id="hero-name"
                [(ngModel)]="hero.alterEgo"
                [ngModelOptions]="{ standalone: true }"
                placeholder="Alter ego"
              />
              <span>Alter ego</span>
            </label>
          </div>
          <div class="form-group">
            <label for="hero-name">
              <textarea
                id="hero-description"
                [(ngModel)]="hero.description"
                [ngModelOptions]="{ standalone: true }"
                placeholder="Description"
              ></textarea>
              <span>Description</span>
            </label>
          </div>
          <div class="buttons">
            <button (click)="save()">Save</button>
            <button (click)="goBack()">Go back</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>
```