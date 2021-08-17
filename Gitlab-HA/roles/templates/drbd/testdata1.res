resource testdata1 {
protocol C;
on node1 {
                device /dev/drbd0;
                disk /dev/sdb;
                address 192.168.100.131:7788;
                meta-disk internal;
        }
        on node2 {
                device /dev/drbd0;
                disk /dev/sdb;
                address 192.168.100.132:7788;
                meta-disk internal;
        }
}
