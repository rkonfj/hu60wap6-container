FROM alpine:3.17 as builder
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk add git
WORKDIR /build
RUN git clone --recursive https://gitee.com/hu60t/hu60wap6.git;cd hu60wap6;git submodule init;git submodule init;rm .git -rf

FROM alpine:3.17
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk add supervisor nginx php php-fpm php81-pdo_mysql php81-mbstring php81-intl php81-gd php81-phar php81-curl php81-iconv php81-simplexml
ADD supervisord.conf /etc/supervisord.conf
ADD nginx.conf /etc/nginx/http.d/default.conf
WORKDIR /app
COPY --from=builder /build/hu60wap6 hu60wap6
RUN chown nobody:nobody hu60wap6 -R
RUN php hu60wap6/src/script/init.php
RUN sed -i "s/define('DB_NAME', 'hu60')/define('DB_NAME', getenv('MYSQL_DB'))/" hu60wap6/src/config/db.php;\
    sed -i "s/define('DB_USER', 'root')/define('DB_USER', getenv('MYSQL_USER'))/" hu60wap6/src/config/db.php;\
    sed -i "s/define('DB_PASS', 'root')/define('DB_PASS', getenv('MYSQL_PASSWORD'))/" hu60wap6/src/config/db.php;\
    sed -i "s/define('DB_HOST', 'localhost')/define('DB_HOST', getenv('MYSQL_HOST'))/" hu60wap6/src/config/db.php;
RUN sed -i "s/;clear_env = no/clear_env = no/" /etc/php81/php-fpm.d/www.conf

ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf"]

