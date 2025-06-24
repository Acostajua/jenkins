# Usa una imagen base oficial de Node.js
FROM node:18

# Crea y selecciona el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia los archivos de dependencias primero
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Copia el resto del código
COPY . .

# Expone el puerto (opcional si ya lo haces en docker-compose)
EXPOSE 3000

# Comando para ejecutar la app
CMD ["npm", "start"]
