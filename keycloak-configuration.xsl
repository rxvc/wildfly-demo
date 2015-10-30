<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ex="urn:jboss:domain:2.2"
                xmlns:se="urn:jboss:domain:security:1.2">

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="//ex:extensions">
      <xsl:copy>
          <xsl:apply-templates select="node()|@*"/>
        <ex:extension module="org.keycloak.keycloak-adapter-subsystem"/>
      </xsl:copy>
    </xsl:template>
    <xsl:template match="//se:security-domains">
      <xsl:copy>
          <xsl:apply-templates select="node()|@*"/>
          <se:security-domain name="keycloak">
              <se:authentication>
                  <se:login-module code="org.keycloak.adapters.jboss.KeycloakLoginModule" flag="required"/>
              </se:authentication>
          </se:security-domain>
      </xsl:copy>
    </xsl:template>
    <xsl:template match="//ex:profile">
      <xsl:copy>
          <xsl:apply-templates select="node()|@*"/>
      <subsystem xmlns="urn:jboss:domain:keycloak:1.1"/>
      </xsl:copy>
    </xsl:template>



    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
