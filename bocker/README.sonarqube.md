## SonarQube build file for Docker

`SonarQube` is an open platform to manage code quality.
See more details at http://www.sonarqube.org/.

This is the `Bocker` source file to generate a `Dockerfile`
to build an image that contains `SonarQube`. It bases on
[the official Dockerfile][1] with some differences.

## Build instruction

### LTS version

Use `bocker` to generate `Dockerfile`, and use `docker build` then.

    $ cd context/
    $ bocker.sh ../bocker/Bockerfile.sonarqube > Dockerfile.sonarqube
    $ docker build -t sonarqube -f Dockerfile.sonarqube .

The `bocker(.sh)` script can be found under the `compiler` submodule.
See [Bocker][2] project for your own installation.

### Latest version

The `Bockerfile.sonarqube` support the latest `LTS` version, it's `4.5.4`.
To build the latest version (it's `5.1` now),
please use the `Bockerfile.sonarqube_latest`.

## Environments

* `SONARQUE_UID`: `uid` of system account to start daemon. Default: `10007`;
* `SONARQUE_GID`: `gid` of system account to start daemon. Default: `10007`;
* `SONARQUBE_JDBC_USERNAME`: Database username. Default: `sonarqube`;
* `SONARQUBE_JDBC_PASSWORD`: Database password. Default: `sonarquebe`;
* `SONARQUBE_JDBC_URL`: Database endpoint. Default: `jdbc:mysql://localhost:3306/sonarqube?useUnicode=true&characterEncoding=utf8`;
* `SONARQUBE_OPTIONS`: Extra options for `sonarque` daeomn. Default: empty;
* `EXIM4_ENABLE`: Enable email daemon;
* `EXIM4_MAILNAME`: Email name. Default: container hostname.

## Expose port

* `9000`: The `sonarqube` console management.

## Sample compsoe file

You can use the following `.yaml` file thanks to `docker-compose` tool.
The `percona` image can be build from `Bockerfile.percona`.

````
db:
  image: "local/percona:5.6"
  restart: "on-failure:4"
  environment:
    MYSQL_ROOT_PASSWD: X6fufO
  volumes:
  - "/sonarqube/mysql/:/mysql/"

web:
  image: "local/sonarqube:latest"
  restart: "on-failure:4"
  ports:
  - "40292:9000"
  environment:
    EXIM4_ENABLE: 1
    EXIM4_MAILNAME: sonar.example.net
    SONARQUBE_JDBC_USERNAME: root
    SONARQUBE_JDBC_PASSWORD: X6fufO
    SONARQUBE_JDBC_URL: jdbc:mysql://db:3306/sonar?useUnicode=true&characterEncoding=utf8
    HOSTNAME: sonar.example.net
  volumes:
  - "/sonarqube/logs/main/:/supervisor/"
  links:
  - db
````

[2]: https://github.com/icy/bocker/
[1]: https://github.com/SonarSource/docker-sonarqube/blob/master/4.5.4/Dockerfile
