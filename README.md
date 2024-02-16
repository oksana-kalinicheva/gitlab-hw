# Домашнее задание к занятию «Система мониторинга Zabbix» - Калиничева Оксана

### Задание 1 

Установите Zabbix Server с веб-интерфейсом.

#### Процесс выполнения
1. Выполняя ДЗ, сверяйтесь с процессом отражённым в записи лекции.
2. Установите PostgreSQL. Для установки достаточна та версия, что есть в системном репозитороии Debian 11.
3. Пользуясь конфигуратором команд с официального сайта, составьте набор команд для установки последней версии Zabbix с поддержкой PostgreSQL и Apache.
4. Выполните все необходимые команды для установки Zabbix Server и Zabbix Web Server.

#### Требования к результаты 
1. Прикрепите в файл README.md скриншот авторизации в админке.
2. Приложите в файл README.md текст использованных команд в GitHub.

### Решение 1

![Скриншот-1](https://github.com/oksana-kalinicheva/gitlab-hw/blob/hw-02-zabbix-01/img/zabbix-1.jpg)

1. sudo su
2. apt update
3. apt install postgresql
4. wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-4+debian11_all.deb
5. dpkg -i zabbix-release_6.0-4+debian11_all.deb
6. apt update
7. apt install zabbix-server-pgsql zabbix-frontend-php php7.4-pgsql zabbix-apache-conf zabbix-sql-scripts
8. sudo -u postgres createuser --pwprompt zabbix
9. sudo -u postgres createdb -O zabbix zabbix
10. zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix
11. vim /etc/zabbix/zabbix_server.conf
12. systemctl restart zabbix-server apache2
13. systemctl enable zabbix-server apache2
14. systemctl status zabbix-server.service

---
### Задание 2 

Установите Zabbix Agent на два хоста.

#### Процесс выполнения
1. Выполняя ДЗ, сверяйтесь с процессом отражённым в записи лекции.
2. Установите Zabbix Agent на 2 вирт.машины, одной из них может быть ваш Zabbix Server.
3. Добавьте Zabbix Server в список разрешенных серверов ваших Zabbix Agentов.
4. Добавьте Zabbix Agentов в раздел Configuration > Hosts вашего Zabbix Servera.
5. Проверьте, что в разделе Latest Data начали появляться данные с добавленных агентов.

#### Требования к результаты 
1. Приложите в файл README.md скриншот раздела Configuration > Hosts, где видно, что агенты подключены к серверу
2. Приложите в файл README.md скриншот лога zabbix agent, где видно, что он работает с сервером
3. Приложите в файл README.md скриншот раздела Monitoring > Latest data для обоих хостов, где видны поступающие от агентов данные.
4. Приложите в файл README.md текст использованных команд в GitHub

### Решение 2

![Скриншот-2](https://github.com/oksana-kalinicheva/gitlab-hw/blob/hw-02-zabbix-01/img/zabbix-2.jpg)

![Скриншот-3](https://github.com/oksana-kalinicheva/gitlab-hw/blob/hw-02-zabbix-01/img/zabbix-3.jpg)

![Скриншот-4](https://github.com/oksana-kalinicheva/gitlab-hw/blob/hw-02-zabbix-01/img/zabbix-4.jpg)

![Скриншот-5](https://github.com/oksana-kalinicheva/gitlab-hw/blob/hw-02-zabbix-01/img/zabbix-5.jpg)

![Скриншот-6](https://github.com/oksana-kalinicheva/gitlab-hw/blob/hw-02-zabbix-01/img/zabbix-6.jpg)

1. sudo su
2. wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-4+debian11_all.deb
3. dpkg -i zabbix-release_6.0-4+debian11_all.deb
4. apt install zabbix-agent
5. systemctl restart zabbix-agent
6. systemctl enable zabbix-agent
7. vim /etc/zabbix/zabbix_agentd.conf
8. systemctl restart zabbix-agent.service
9. tail -n 20 /var/log/zabbix/zabbix_agentd.log

---
## Задание 3 со звёздочкой*
Установите Zabbix Agent на Windows (компьютер) и подключите его к серверу Zabbix.

#### Требования к результаты 
1. Приложите в файл README.md скриншот раздела Latest Data, где видно свободное место на диске C:
--- 

## Критерии оценки

1. Выполнено минимум 2 обязательных задания
2. Прикреплены требуемые скриншоты и тексты 
3. Задание оформлено в шаблоне с решением и опубликовано на GitHub