# web-server

Веб сервер для прошивок NodeMCU для ESP8266
Вернее это базовая заготовка для ваших проектов с веб интерфейсом.

[English](https://github.com/bondrogeen/web-server/doc/en/README.md)

## Особенности

* GET, POST запросы
* Запуск скриптов
* Вставка Lua кода в html страницу (<?lua return(node.chipid()) ?>)
* Поддержка сжатых файлов .gz
* Forms authentication
* Разбор форм (application/x-www-form-urlencoded и application/json)

## Установка

1. Необходимые модули ("crypto", "file", "gpio", "net", "node", "sjson", "tmr", "uart", "wifi") далее на ваше усмотрение. [Собрать прошивку](https://nodemcu-build.com/)
2. Загрузить все [файлы](https://github.com/bondrogeen/web-server/tree/master/files) в модуль.
3. Подключиться к точке доступа **Web server** и перейти по адресу **192.168.4.1**.
			
![Logo](doc/web_server_login.jpg)
			
4. Вводим логин (admin) и пароль (0000).
			
![Logo](doc/web_server_index_page.jpg)
			
5. Переходим в **Настройки**.
			
![Logo](doc/web_server_settings_page.jpg)

6. Подключаемся к вашей wi-fi сети 

## Как работать со скриптами lua

Пример файл "test.lua"
   
...lua
   
return function (args)   
 local str=""   
 for k, v in pairs(args) do   
  str=str..k.." : "..v.."<br>"    
 end    
 return str    
end   
   
... 
   

Параметры от форм (если они есть) будут переданны в таблицу **args**.

http://IP/test.lua?key=value&name=Roman

![test.lua](doc/test_lua_args.jpg)
