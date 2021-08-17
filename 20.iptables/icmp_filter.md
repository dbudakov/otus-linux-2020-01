### Рекомендации по фильтрации ICMP трафика
### IPv4
|**IPv4**| |  
|:---|:---| 
|**Action** |**Types**|  
|ALLOW |3, 0, 8, 11|  
|DROP |4, 6, 13-18, 30-37|  
|DROP when not needed  |other types |  


Action |Types (Codes)
|:---|:---|
ALLOW |1, 2, 3 (0), 4 (1,2), 128, 129
Consider allowing | 3 (1), 4 (0), 144-147
Policy dependent | 15, 5-99, 102-126 154-199, 202-254
Consider dropping | 100, 101, 127 138-140, 200, 201, 255
DROP addressed to example network | 5-99, 102-126, 144-147 150, 154-199, 202-254 & consider dropping 

### IPv6  
IPv6 приходящий на файрвалл||
|:---|:---|
**Action** |**Types (Codes)**
ALLOW | 1, 2, 3 (0), 4 (1,2), 128, 129 130-136, 141-143, 148, 149 151-153
Consider allowing | 3 (1), 4 (0), 144-147, 150
Policy dependent | 4-99, 102-126, 137, 139, 140
Consider dropping | 100, 101, 127 154-199, 200-255
DROP in example | 144-147, 150 policy dependent & consider dropping 
