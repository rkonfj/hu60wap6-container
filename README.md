# hu60wap6 container

### Build
```shell
docker build . -t rkonfj/hu60wap6:edge
```

### Run
```shell
docker compose up -d
echo "create database IF NOT EXISTS hu60;use hu60;\
      $(curl https://raw.githubusercontent.com/hu60t/hu60wap6/master/src/db/mysql.sql)" \
      | docker exec -i mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD"'
```
