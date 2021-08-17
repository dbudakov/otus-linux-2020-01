Виды много задачности : кооперативная и вытесняющая(linux)  
Виды ядер: микроядро, монолит(linux), гибрид  
Регистры: общего назн:AX,BX,CX,DX; селекторов:CS(Code Segment),SS(Stack Segment) 
Указатели состоят из селекторов и смещения CS:IP - адрес исполняемой интрукции; CS:SP - вершина стека  
  Все современные архитектуры не адресуют память
  напрямую. Вместо этого имеется минимум два уровня
  абстракции
  - таблицы дескрипторов GDT и LDT в процессоре,
  преобразующие указатели в логический адрес
  - устройство MMU, преобразующий логический адрес
  в физический адрес
  Каждый процесс имеет свою LDT, и каждый процесс не
  имеет доступа к памяти другого процесса.
Прерывания:Аппаратные,исключения, програмные(INT); IDT - Interrupt Description Table - адреса событий
SYSCALL: "int 80" или "syscall" имеют приоритет "ring 0"
Загрузка ядра: sheduler,memory,proc,sig_querry,drivers,kernel_proc,proc_0
Контекст: состояние регистров(общего назначения,указатель на инструкцию,указатель на стек,флаги)
Переключения происходят через scheduler, оперирует таблицей указателей на вершину стэка
Сигнал указывает sheduler-у начитань с сохраннённой функции в табл.обработчиков сигналов
 Герцовка настроенная для ядра
 zgrep CONFIG_HZ= /boot/config-*
CONFIG_HZ=1000

трассировка: strace [command]; ltrace [command]

версии ядер: mainline[ml]; stable; longterm[lt] (LTS); linux-next
система нумерации: четные это стабильные релизы
Ядра для CentOS в [файле репозиториев](https://github.com/dbudakov/support/blob/master/repo.md)  
Цели сборки ядра: унификация, уменьшение размера
модули: lsmod,modprobe,insmod,rmmod
конфиги модулей: /sys/modules /etc/modprobe.d /etc/modules-load.d
версия дистрибутива: lsb_release -a; cat /etc/redhat/release 

Сборка ядра:
cp /boot/config* .config &&
make oldconfig &&
make &&
make install &&
make modules_install
/etc/redhat/release - версия дистрибутива
lsb_release -a
