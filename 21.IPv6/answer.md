### radvd
radvd может отдать дополнительный маршрут директивой в radvd.conf  
```
route 2001:db0:fff::/48
	{
		AdvRoutePreference high;
		AdvRouteLifetime 3600;
    };
```
Во первых, это не везде поддерживается.  
Во вторых, для того, чтобы эти сведения из RA были применены, нужно выставить    
```
net.ipv6.conf.eth1.accept_ra_rt_info_max_plen = 48` #где 48 - максимальная принимаемая длина префикса.  
```

Тогда только на клиенте появится новый маршрут в таблице маршрутизации:  
```
2001:db0:fff::/48 via fe80::a00:27ff:fe55:a0ee dev eth1 proto ra metric 1024 expires 3597sec pref high
```
