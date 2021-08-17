1. Подъехала методичка по OSPF. Ссылка есть в ЛК. Продублирую тут: [ссылка](https://github.com/mbfx/otus-linux-adm/tree/master/dynamic_routing_guideline)  
2. поведение при blackhole:  
При делать ping через маршрутизатор, который знает о сети назначения, но хост за ним при этом недоступен, ответ будет: destination host unreaachadle;  
Если на этом маршрутизаторе включить blackhole до хоста назначения, то ответа вообще никакого не будет.  
