# 01 Install

In this example we are going to install MongoDB as Docker container

We will start from `00-boilerplate`.

# Steps to build it

- `npm install` to install previous sample packages:

```bash
npm install

```

First, let's create a MongoDB container using docker-compose:

_./docker-compose.yml_

```yml
version: '3.8'
services:
  book-store-db:
    container_name: book-store-db
    image: mongo:6
    ports:
      - '27017:27017'

```

> [Docker compose versioning](https://docs.docker.com/compose/compose-file/compose-versioning/)
> [Docker versions](https://hub.docker.com/_/mongo?tab=tags&page=1&ordering=last_updated)

Let's create npm commands to run it:

_./package.json_

```diff
...
  "scripts": {
    "prestart": "npm run clean && npm run build:dev",
-   "start": "run-p -l build:watch start:dev",
+   "start": "run-p -l build:watch start:dev start:local-db",
    "start:dev": "node --watch dist/index",
    "prestart:console-runners": "npm run prestart",
    "start:console-runners": "run-p -l build:watch console-runners",
    "console-runners": "node --watch dist/console-runners/index",
+   "start:local-db": "docker-compose up -d",
    "clean": "rimraf dist",
    "build:dev": "tsc --outDir dist",
    "build:watch": "npm run build:dev -- --watch --preserveWatchOutput"
  },
...
```

Run it:

```bash
npm run start:local-db
```

We could connect to this container using Docker o Mongo Compass:

```bash
docker ps
docker exec -it book-store-db sh
mongosh
show dbs
use my-db
show collections
db.clients.insertOne({ name: "Client 1" })
show collections
db.clients.find()
exit
exit
```

> Try Mongo Compass after commands
> Try to stop and running container again
> `docker stop book-store-db` and `npm run start:local-db`

Remove local db:

```bash
docker-compose down

npm run start:local-db

```

Let's add a Docker `volume`:

```bash
docker-compose down

```

_./docker-compose.yml_

```diff
version: '3.8'
services:
  book-store-db:
    container_name: book-store-db
    image: mongo:5.0.9
    ports:
      - '27017:27017'
+     volumes:
+       - type: bind
+         source: ./mongo-data
+         target: /data/db
+ volumes:
+   mongo-data:

```

> If you are using linux, you have to create the `mongo-data` folder previously.
>
> The short hand but could have some issues in linux or mac
>

```
  volumes:
    - './mongo-data:/data/db'
  volumes:
    mongo-data:
```

```bash
npm run start:local-db

```

Create some data using `Mongo Compass`.

```bash
docker-compose down

npm run start:local-db

```

Let's ignore the `volume` folder:

_./.gitignore_

```diff
node_modules
dist
.env
+ mongo-data

```

# ¿Con ganas de aprender Backend?

En Lemoncode impartimos un Bootcamp Backend Online, centrado en stack node y stack .net, en él encontrarás todos los recursos necesarios: clases de los mejores profesionales del sector, tutorías en cuanto las necesites y ejercicios para desarrollar lo aprendido en los distintos módulos. Si quieres saber más puedes pinchar [aquí para más información sobre este Bootcamp Backend](https://lemoncode.net/bootcamp-backend#bootcamp-backend/banner).