# Usa una imagen base oficial de Node.js
FROM node:18

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia los archivos de dependencias
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Copia el resto del código de la aplicación
COPY . .

# Expone el puerto de la aplicación (opcional si usas docker-compose)
EXPOSE 3000

# Comando por defecto para ejecutar la aplicación
CMD ["npm", "start"]
