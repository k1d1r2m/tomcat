FROM  tomcat:latest   
# set env variables
ENV CATALINA_HOME /usr/local/tomcat
ENV APP_NAME onlinebookstore
#copy the war file to webappsdirectory
COPY target/${APP_NAME}.war   ${CATALINA_HOME}/webapps/
#Expose port
EXPOSE 8080
#start tomcat
CMD [ "catalina.sh" , "run" ]

