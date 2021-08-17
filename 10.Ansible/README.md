## Домашнее задание
Первые шаги с Ansible
Цель: В результате выполнения ДЗ студент подготовит стенд на Vagrant.
Подготовить стенд на Vagrant как минимум с одним сервером. На этом сервере используя Ansible необходимо развернуть nginx со следующими условиями:
- необходимо использовать модуль yum/apt
- конфигурационные файлы должны быть взяты из шаблона jinja2 с перемененными
- после установки nginx должен быть в режиме enabled в systemd
- должен быть использован notify для старта nginx после установки
- сайт должен слушать на нестандартном порту - 8080, для этого использовать переменные в Ansible
\* Сделать все это с использованием Ansible роли

## Решение  
После команды `git clone` перейти в  каталог `./10.Ansible/homework` 
```
cd ./10.Ansible/homework
```
поднять стенд:
```
vagrant up 
vagrant up prod-nginx-01
vagrant up prod-nginx-02
vagrant up staging-nginx-01
```
`playbook` отработает в рамках `Vagrantfile`, проверить работу `nginx` можно будет по следующим адресам:
```
curl 192.168.11.151:8080 # для prod-nginx-01
curl 192.168.11.152:8080 # для prod-nginx-02
curl 192.168.11.200:8080 # для staging-nginx-01
```
с прошлой версии решения остались каталог `inventories/` и файл `scritpt.sh` для ручного запуска `playbook`, а скрипт используется для парсинга портов виртуалок на `localhost` в файлы `inventories/` для подключения к виртуалкам по ssh

```
./script_sh
ansible-playbook -i inventories/ nginx.yml
```


Дополнительная информация:  
pip  
zsh  
id_rsa  
[bashrc](https://pingvinus.ru/note/bash-promt)  
```
asnsible-lint - проверка файла ansible
ansible-vault encrypt_string --vault-password-file pass 'p@ssw0rd' --name 'secret' - шифрование строки
```
Агрегированное инвентори, для vars(https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#using-multiple-inventory-sources)    
[Ansible это вам не bash. Сергей Печенко](https://habr.com/ru/post/494738/)  
