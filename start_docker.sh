#!/bin/bash

echo "Limpiando contenedores anteriores..."
docker-compose down

echo "Construyendo e iniciando el servidor ERP..."
docker-compose up --build -d

echo "Servidor corriendo exitosamente en el puerto 3000."
