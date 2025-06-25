# Usa una imagen base oficial de Node.js con soporte LTS
FROM node:18-alpine

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia primero los archivos de dependencias para aprovechar la caché de Docker
COPY package*.json ./

# Instala solo las dependencias de producción si estás en un entorno de despliegue
RUN npm install --production

# Copia el resto del código fuente
COPY . .

# Expone el puerto en el que se ejecuta la aplicación
EXPOSE 3000

# Comando por defecto para iniciar la aplicación
CMD ["npm", "start"]
