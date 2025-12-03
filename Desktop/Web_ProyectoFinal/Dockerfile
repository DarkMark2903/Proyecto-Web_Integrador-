# --- ETAPA 1: Construcción (Build) ---
# Usamos una imagen de Maven con Java 17 para compilar el código
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copiamos el archivo de configuración Maven
COPY pom.xml .
# Descargamos las dependencias (para que se guarden en caché y sea más rápido)
RUN mvn dependency:go-offline

# Copiamos todo el código fuente de tu carpeta src
COPY src ./src

# Compilamos el proyecto y creamos el archivo .war
# El flag -DskipTests evita errores si no hay base de datos durante la construcción
RUN mvn clean package -DskipTests

# --- ETAPA 2: Ejecución (Run) ---
# Usamos un servidor Tomcat 10.1 (Compatible con tu Jakarta EE 10)
FROM tomcat:10.1-jdk17

# Borramos las apps por defecto de Tomcat para mantenerlo limpio
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiamos el .war que generamos en la etapa 1 a la carpeta de apps de Tomcat
# Lo renombramos a ROOT.war para que tu app sea la principal
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Exponemos el puerto 8080 (el estándar de Tomcat)
EXPOSE 8080

# Comando para iniciar Tomcat
CMD ["catalina.sh", "run"]
