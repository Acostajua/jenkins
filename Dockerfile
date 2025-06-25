# Usa una imagen base oficial de Node.js
FROM node:18

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos de dependencias
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Copia el resto del código
COPY . .

# Expone el puerto en que corre la app
EXPOSE 3000

# Comando para iniciar la app
CMD ["npm", "start"]
