FROM rxvallejoc/base-jdk8

ENV WILDFLY_VERSION 8.2.1.Final
ENV KEYCLOAK_VERSION 1.6.1.Final
ENV JBOSS_HOME /opt/jboss/wildfly

RUN cd $HOME \
      && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
      && tar xf wildfly-$WILDFLY_VERSION.tar.gz \
      && mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
      && rm wildfly-$WILDFLY_VERSION.tar.gz

RUN cd $HOME \
      && curl -O https://downloads.jboss.org/keycloak/$KEYCLOAK_VERSION/adapters/keycloak-oidc/keycloak-wf8-adapter-dist-$KEYCLOAK_VERSION.tar.gz \
      && tar xf  keycloak-wf8-adapter-dist-$KEYCLOAK_VERSION.tar.gz \
      && mv $HOME/modules/system/layers/base/org/apache/httpcomponents/4.3 $JBOSS_HOME/modules/system/layers/base/org/apache/httpcomponents/ \
      && mv $HOME/modules/system/layers/base/org/keycloak $JBOSS_HOME/modules/system/layers/base/org/ \
      && rm -rf $HOME/modules \
      && rm keycloak-wf8-adapter-dist-$KEYCLOAK_VERSION.tar.gz

ADD keycloak-configuration.xsl /opt/jboss/wildfly/

RUN java -jar /usr/share/java/saxon.jar -s:/opt/jboss/wildfly/standalone/configuration/standalone.xml -xsl:/opt/jboss/wildfly/keycloak-configuration.xsl -o:/opt/jboss/wildfly/standalone/configuration/standalone.xml

ADD customer-portal.war /opt/jboss/wildfly/standalone/deployments/
ADD customer-portal-js.war /opt/jboss/wildfly/standalone/deployments/
ADD product-portal.war /opt/jboss/wildfly/standalone/deployments/
ADD database.war /opt/jboss/wildfly/standalone/deployments/
ADD angular-product.war /opt/jboss/wildfly/standalone/deployments/

ENV LAUNCH_JBOSS_IN_BACKGROUND true 

EXPOSE 8080

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]

#CMD ["/opt/jboss/wildfly/bin/jboss-cli.sh", "-c", "--file=/opt/jboss/bin/adapter-install.cli"]

#RUN cd $HOME \
#    && rm -rf $HOME/bin
