# Side-by-Side extensibility - cloud foundry for S/4HANA
##   Generate project
```bash
mvn archetype:generate "-DarchetypeGroupId=com.sap.cloud.sdk.archetypes" "-DarchetypeArtifactId=scp-cf-tomee" "-DarchetypeVersion=RELEASE"
```
```
groupId: com.sap.cloud.sdk.tutorial
artifactId: firstApp
version: 1.0-SNAPSHOT
package: com.sap.cloud.sdk.tutorial 
```

##   Package
```bash
mvn clean package
```

##   Deploy to Cloud Foundry
```yaml
---
applications:

- name: firstapp
  memory: 1024M
  timeout: 300
  random-route: true
  path: application/target/firstapp-application.war
  buildpacks:
    - sap_java_buildpack
  env:
    TARGET_RUNTIME: tomee7
    SET_LOGGING_LEVEL: '{ROOT: INFO, com.sap.cloud.sdk: INFO}'
    JBP_CONFIG_SAPJVM_MEMORY_SIZES: 'metaspace:128m..'
```
```cf push```

##   Run in local

```mvn tomee:run -pl application```

## New JAVA Class

```BusinessPartnerServlet.java```

```java
package com.sap.cloud.sdk.tutorial;

import com.google.gson.Gson;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import com.sap.cloud.sdk.cloudplatform.connectivity.DestinationAccessor;
import com.sap.cloud.sdk.datamodel.odata.helper.Order;
import com.sap.cloud.sdk.odatav2.connectivity.ODataException;

import com.sap.cloud.sdk.s4hana.connectivity.DefaultErpHttpDestination;
import com.sap.cloud.sdk.s4hana.connectivity.ErpHttpDestination;
import com.sap.cloud.sdk.s4hana.datamodel.odata.namespaces.businesspartner.BusinessPartner;
import com.sap.cloud.sdk.s4hana.datamodel.odata.services.DefaultBusinessPartnerService;

@WebServlet("/businesspartners")
public class BusinessPartnerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(BusinessPartnerServlet.class);

    private static final String CATEGORY_PERSON = "1";
    private final ErpHttpDestination destination = DestinationAccessor.getDestination("SD5").asHttp().decorate(DefaultErpHttpDestination::new);

    @Override
    protected void doGet(final HttpServletRequest request, final HttpServletResponse response)
            throws ServletException, IOException {
        try {
            //destination
            System.out.print(destination);
            final List<BusinessPartner> businessPartners =
                    new DefaultBusinessPartnerService()
                            .getAllBusinessPartner()
                            .select(BusinessPartner.BUSINESS_PARTNER,
                                    BusinessPartner.LAST_NAME,
                                    BusinessPartner.FIRST_NAME,
                                    BusinessPartner.IS_MALE,
                                    BusinessPartner.IS_FEMALE,
                                    BusinessPartner.CREATION_DATE)
                            .filter(BusinessPartner.BUSINESS_PARTNER_CATEGORY.eq(CATEGORY_PERSON))
                            .orderBy(BusinessPartner.LAST_NAME, Order.ASC)
                            .top(200)
                            .execute(destination);

            response.setContentType("application/json");
            response.getWriter().write(new Gson().toJson(businessPartners));
        } catch (final ODataException e) {
            logger.error(e.getMessage(), e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(e.getMessage());
        }
    }
}
```

## Build and deploy to cloud foundry
```bash
mvn clean install
cf api # Check if the api endpoint is correct
cf push

cf a # check application and open in browser
```
 
##  Build a simple UI5 App

### index, controller and view

```index.html```
```html
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>Business Partner from SD5</title>
	<script id="sap-ui-bootstrap"
		src="https://ui5.sap.com/resources/sap-ui-core.js"
		data-sap-ui-theme="sap_fiori_3"
		data-sap-ui-libs="sap.m"
		data-sap-ui-resourceroots='{"Quickstart": "./"}'
		data-sap-ui-onInit="module:Quickstart/index"
		data-sap-ui-compatVersion="edge"
		data-sap-ui-async="true">
	</script>
</head>
<body class="sapUiBody" id="content"></body>
</html>
```
```index.js```
```javascript
sap.ui.define([
	"sap/ui/core/mvc/XMLView"
], function (XMLView) {
	"use strict";

	XMLView.create({
		viewName: "Quickstart.view.App"
	}).then(function (oView) {
		oView.placeAt("content");
	});

});
```

```view/App.view.xml```

```xml
<mvc:View xmlns="sap.m" 
	xmlns:core="sap.ui.core"
	xmlns:mvc="sap.ui.core.mvc" controllerName="Quickstart.controller.App">

	<Table id="idBusinessPartnerTable" inset="false" items="{
			path: '/'
		}">
		<headerToolbar>
			<OverflowToolbar>
				<content>
					<Title text="Business Partner" level="H2"/>
					<ToolbarSpacer />
					<ComboBox id="idPopinLayout" placeholder="Popin layout options" change="onPopinLayoutChanged">
						<items>
							<core:Item text="Block" key="Block"/>
							<core:Item text="Grid Large" key="GridLarge"/>
							<core:Item text="Grid Small" key="GridSmall"/>
						</items>
					</ComboBox>
					<Label text="Sticky options:" />
					<CheckBox text="ColumnHeaders" select="onSelect"/>
					<CheckBox text="HeaderToolbar" select="onSelect"/>
					<CheckBox text="InfoToolbar" select="onSelect"/>
					<ToggleButton id="toggleInfoToolbar" text="Hide/Show InfoToolbar" press="onToggleInfoToolbar" />
				</content>
			</OverflowToolbar>
		</headerToolbar>
		<infoToolbar>
			<OverflowToolbar>
				<Label text="Business Partners"/>
			</OverflowToolbar>
		</infoToolbar>
		<columns>
			<Column width="12em">
				<Text text="Business Partner" />
			</Column>
			<Column minScreenWidth="Tablet" demandPopin="true">
				<Text text="Creation Date" />
			</Column>
			<Column minScreenWidth="Desktop" demandPopin="true" hAlign="End">
				<Text text="Is Female" />
			</Column>
			<Column minScreenWidth="Desktop" demandPopin="true" hAlign="Center">
				<Text text="Name" />
			</Column>
			<Column hAlign="End">
				<Text text="Last Name" />
			</Column>
		</columns>
		<items>
			<ColumnListItem>
				<cells>
					<ObjectIdentifier title="{FirstName}" text="{BusinessPartner}"/>
					<DatePicker dateValue="{path:'CreationDate',formatter:'.formatDate'}" />
					<Text text="{IsFemale}" />
					<Text text="{FirstName}" />
					<Text text="{LastName}" />
				</cells>
			</ColumnListItem>
		</items>
	</Table>
</mvc:View>
```


### Test Locally

Change the binding from ./businesspartners to ./businesspartners-list.json

```bash
mvn clean install $$ mvn tomee:run -pl application
```

### Deploy to Cloud Platform to see the real SD5 data

```bash
mvn clean install
cf push
```


Reference: <https://developers.sap.com/tutorials/s4sdk-odata-service-cloud-foundry.html#55c67141-12a4-4f12-aa57-0301d515476e>
