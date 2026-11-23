# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

NetisDash SCTC is a Java/Spring MVC web-based network and infrastructure monitoring dashboard. It provides real-time monitoring, visualization, and management of network devices, servers, and infrastructure with D3.js topology visualization.

## Build Commands

Requires JDK 21 and Maven 3.9+.

```powershell
# PowerShell: pin to JDK 21
$env:JAVA_HOME = 'C:\tools\jdk21\jdk-21.0.2'
$env:Path = "$env:JAVA_HOME\bin;$env:Path"

# Build (produces hm-dash/target/hm-dash.war)
mvn clean package
```

### Run via Cargo + external Tomcat 10.1

The tomcat7-maven-plugin was removed (no Jakarta successor exists). Dev server now
runs via Cargo against an externally-installed Tomcat 10.1.x:

```powershell
# One-time: download Apache Tomcat 10.1.x and extract, then export CATALINA_HOME.
$env:CATALINA_HOME = 'C:\opt\apache-tomcat-10.1.x'

# Start (foreground) on http://localhost:8303/
mvn cargo:run

# Or: install Tomcat-side and deploy
mvn cargo:start
mvn cargo:deploy
mvn cargo:stop
```


## Project Structure

```
hm-dash/
├── src/main/java/com/hm/netis/webapp/
│   ├── main/controller/       # Monitoring controllers (nms, sms, oms, env, popup)
│   ├── dash/controller/       # Dashboard controllers
│   ├── common/controller/     # Shared controllers (Code, Combo, Dev, Grp, Line, Svr)
│   └── d3map/controller/      # D3 topology controllers
├── src/main/resources/
│   ├── config/                # Spring, MyBatis, and JDBC configs
│   └── maria/                 # MyBatis mapper XML files (organized by package)
└── src/main/webapp/
    ├── js/dash/               # Dashboard JavaScript (RequireJS AMD)
    ├── js/d3map/              # D3 topology visualization
    ├── js/main/               # Main monitoring pages
    └── WEB-INF/view/          # JSP views
```

## Architecture

### Backend Stack
- **Framework**: Spring MVC 6.1.x (Jakarta EE 9+ APIs — `jakarta.*` packages)
- **ORM**: MyBatis 3.5.x + mybatis-spring 3.0.x
- **Database**: MariaDB (primary, via `mariadb-java-client`), Impala (analytics)
- **Java**: 21 (LTS)
- **Servlet**: Jakarta Servlet 6.0 (Tomcat 10.1+)
- **JSP / JSTL**: JSP 3.1 + JSTL 3.0 (`uri="jakarta.tags.core"`)
- **Security**: none currently wired (HttpSession-only). Spring Security was declared but never configured; removed during the Java 21 migration.
- **Logging**: SLF4J 2.x + Logback 1.5.x. Legacy `org.apache.log4j.Logger` call sites still work via the `log4j-over-slf4j` bridge.

### Apache POI version pin
POI is pinned at **3.15** because `XLSFileStyle` / `XLSFileBuilder` use the
legacy `CellStyle.SOLID_FOREGROUND` / `HSSFCellStyle.BORDER_THIN` style constants
that POI 4.0 removed. A POI 5.x migration is a separate refactor — out of scope
for the Jakarta jump.

### Migration follow-ups (deferred from the Java 21 PR)
- Add JUnit 5 + Spring MockMvc smoke tests (`ApplicationContextSmokeTest`, `DispatcherUrlMappingTest`, `MybatisMapperSmokeTest`).
- Set up an external Tomcat 10.1 install and run a full Playwright UI smoke pass against the deployed WAR.
- Optional: migrate Apache POI to 5.x (BorderStyle / FillPatternType / VerticalAlignment enums).
- Optional: install transformed Hamon `*-jakarta` artifacts to the internal Nexus so CI hosts can resolve them without a local cache (currently the build relies on `~/.m2` cache; the internal Nexus at `http://10.1.3.195:8082` is HTTP and Maven 3.9 blocks HTTP by default).

### Frontend Stack
- **Module System**: RequireJS AMD
- **Visualization**: D3.js 5.5.0, Highcharts 8.0.4
- **Grid**: jqxGrid

### MVC Pattern

**Request Flow**: `*.do` URL → Spring DispatcherServlet → Controller → Service → Mapper → Database

**Package Structure**:
- `*.dto` - Data Transfer Objects
- `*.persistence` - MyBatis Mapper interfaces
- `*.service` - Business logic (interface + impl)
- `*.controller` - Spring @Controller classes

### Frontend Controller Pattern

Controllers in `js/dash/control/` follow AMD pattern:
```javascript
define(function (require) {
    var MyController = function(id) {
        this.id = id;
        this.model = new Model();
    };
    MyController.prototype.init = function() { /* ... */ };
    MyController.prototype.getHTML = function() { return viewTemplate; };
    MyController.prototype.refresh = function() { /* data fetch */ };
    return MyController;
});
```

**Controller Categories**:
- `com/` - Common components (events, headers)
- `nms/` - Network monitoring (topology, traffic, devices)
- `sms/` - System monitoring (servers, filesystems)

## Key Configuration Files

| File | Purpose |
|------|---------|
| `config/applicationContext.xml` | Spring beans, component scanning |
| `config/dataAccessContext.xml` | DataSource, MyBatis, transactions |
| `config/jdbc_maria.properties` | Database connection settings |
| `config/system.properties` | Application settings (db type, logging) |
| `config/mybatis-config.xml` | MyBatis settings (camelCase mapping) |

## Database

- **Primary**: MariaDB via `jdbc_maria.properties`
- **MyBatis Mappers**: `src/main/resources/maria/com/hm/netis/webapp/**/*.xml`
- **CamelCase Mapping**: Enabled (underscore DB columns → camelCase Java fields)
- **NULL Handling**: Uses JDBC type for NULL values

## Skills Library

Reusable development patterns are in `.claude/skills/`:

- **dashboard/** - Dashboard controller templates, MVC patterns, workflow guides
- **database/** - MyBatis query patterns (pagination, aggregation, time-series)
- **library/** - Common JS utilities (HmUtil, HmHighchart, chart configs)

## Adding New Features

### Backend
1. Create DTO in `*.dto` package
2. Create Mapper interface in `*.persistence` with `@Mapper` annotation
3. Create MyBatis XML in `maria/` with matching namespace
4. Create Service interface + impl in `*.service`
5. Create Controller with `@RequestMapping` returning JSON via `@ResponseBody`

### Frontend Dashboard Panel
1. Create Controller.js following AMD pattern
2. Create Model.js for data management
3. Create HTML.jsp for view template
4. Register in main dashboard's `initialize()` and `refreshData()`

## Common Utilities

```javascript
// Server communication
Server.post(url, params, callback);

// Charts
HmHighchart.create('divId', options, CtxMenu.CHART);

// Excel export
HmUtil.exportGrid($grid, 'filename.xlsx', true);

// Popup
HmUtil.showPopup('/popup/page.do', null, 'name', 800, 600);

// Unit conversion
HmUtil.convertUnit1000(value);  // "1.23 G"
```

## Internationalization

- Message files: `message.properties`, `message_ko_KR.properties`, `message_en_US.properties`
- Switch locale via `?lang=en_US` or `?lang=ko_KR` parameter