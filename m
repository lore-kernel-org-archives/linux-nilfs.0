From: Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NILFS: bad btree node
Date: Tue, 25 Dec 2012 15:10:41 +0800
Message-ID: <4B471B7E-4E68-453E-B6B1-EF9344DAA694@gmail.com>
References: <86B5C141-ACFA-4541-999F-E17E09F22476@gmail.com> <1355983713.2056.3.camel@slavad-ubuntu> <3455B0CD-EF89-4227-90E1-FC6B20F5F8EB@gmail.com> <1355996310.2056.28.camel@slavad-ubuntu> <14BA4286-BF21-4BD3-8E41-2F8F9512D801@gmail.com> <1356000112.2056.33.camel@slavad-ubuntu> <44056E9A-3487-4E8A-A56A-5B9228FC7895@gmail.com> <1356415326.2052.9.camel@slavad-ubuntu>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:content-type:mime-version:subject:from:in-reply-to:date
         :cc:content-transfer-encoding:message-id:references:to:x-mailer;
        bh=PhMEYUv69PD68FMtifTaBjHgBeAu1VRvtDhU712ZtCA=;
        b=IFOeiDu3hKjXhBY/p2i8HcvpCh8czZZfKJX6iBw9yNePxDVN3PV69cVGPNAlazb+0i
         f9Z6Gld9d/+Rwzt7XKnG3GaOR6xWiZi6zc+P/TJSvlNjT6IH78/kGjuAcZXExVD84ygG
         gIaIx3dY9H0YgeJHAqfgePHiLbMwxqQvKvOafPY0BEdUbLarYu6VvusGzq2b1UCdq921
         OfrwRpShZXoouLFCr9CTycC9NCxbKQ+6vk5AEKpB1d7lv+dW0OVzIgMxauHwMWEZtpL3
         UuXJgbIf6oEaYXv6ijApB6ZFk8RPSa3P85JdJS1oJ9wHV3EX/wXaaxXPA5/9mP9kK0YP
         dBww==
In-Reply-To: <1356415326.2052.9.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I am trying to use NILFS2 to make MySQL cold backup. I run many MySQL s=
lave servers on the machine, and store the data on NILFS2 filesystem. M=
ost of the engine of the table is MyISAM, few InnoDB.=20

When the issue occurred, some MySQL is running, and I am copying data t=
o MySQL data dir with rsync. The util of the NILFS2 partition is almost=
 100%.

In addition to this problem, I also encountered some other problems. So=
me MyISAM tables suddenly be crashed, then sql_thread of slave stopped.=
 But I do not need to repair the table, just wait a bit, and then resta=
rt the sql_thread, can continue. So I guess that may be a problem with =
the file system. Below is the error log of mysql about this:

121225 14:38:03 [ERROR] Slave SQL: Error 'Table 'consume_log_2a' is mar=
ked as crashed and should be repaired' on query. Default database: 'app=
_wsgrr'. Query: 'DELETE FROM consume_log_2a WHERE log_time<=3D135375052=
6 AND coin_type !=3D2 AND coin_type!=3D12 AND coin_type !=3D13', Error_=
code: 1194				# table crashed
121225 14:38:03 [Warning] Slave: Table 'consume_log_2a' is marked as cr=
ashed and should be repaired Error_code: 1194
121225 14:38:03 [ERROR] Error running query, slave SQL thread aborted. =
=46ix the problem, and restart the slave SQL thread with "SLAVE START".=
 We stopped at log 'yf75-bin.000296' position 680291890
121225 14:58:54 [Note] Slave I/O thread exiting, read up to log 'yf75-b=
in.000298', position 802588261			# restart the sql_thread without repai=
ring table
121225 14:58:55 [Note] Slave I/O thread: connected to master 'replica@1=
0.75.7.75:6011',replication started in log 'yf75-bin.000298' at positio=
n 802588261

Version of MySQL Server: Percona Server 5.5.23


sdb2 is the NILFS2 partition. Below is the result of "iostat -xm -p sdb=
 1" in last few seconds.

Linux 2.6.32-220.13.1.el6.x86_64 (yf237) 	12/25/2012 	_x86_64_	(8 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           1.24    0.00    1.91    4.02    0.00   92.83

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq=
-sz avgqu-sz   await  svctm  %util
sdb            3285.75    42.27  259.02  151.13    15.14    18.46   167=
=2E73     5.54   13.52   0.81  33.26
sdb1              0.01    42.26    0.37    1.98     0.04     0.17   183=
=2E98     0.06   26.61   2.38   0.56
sdb2           3285.74     0.00  258.65  148.65    15.10    18.28   167=
=2E85     5.48   13.46   0.82  33.25

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           1.23    0.00    2.22   16.54    0.00   80.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq=
-sz avgqu-sz   await  svctm  %util
sdb             251.00     0.00  736.00   81.00     4.62     8.87    33=
=2E81    19.26   23.74   1.22  99.90
sdb1              0.00     0.00    0.00    0.00     0.00     0.00     0=
=2E00     0.00    0.00   0.00   0.00
sdb2            251.00     0.00  736.00   79.00     4.62     8.87    33=
=2E89    19.27   23.79   1.23  99.90

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           4.80    0.00    1.90   20.99    0.00   72.31

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq=
-sz avgqu-sz   await  svctm  %util
sdb             300.00   450.00  900.00   87.00    10.64     9.50    41=
=2E80    19.50   19.55   1.01  99.90
sdb1              0.00   450.00    1.00   16.00     0.12     1.82   234=
=2E35     0.32   18.88   6.76  11.50
sdb2            300.00     0.00  899.00   69.00    10.52     7.68    38=
=2E50    19.18   19.60   1.03  99.90

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.12    0.00    2.25   21.60    0.00   74.03

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq=
-sz avgqu-sz   await  svctm  %util
sdb             449.00     0.00  625.00   81.00     5.00     9.18    41=
=2E12    15.32   21.36   1.41  99.40
sdb1              0.00     0.00    1.00    0.00     0.12     0.00   256=
=2E00     0.02   19.00  19.00   1.90
sdb2            449.00     0.00  624.00   79.00     4.88     9.18    40=
=2E93    15.30   21.42   1.41  99.40

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.51    0.00    1.52   15.08    0.00   82.89

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq=
-sz avgqu-sz   await  svctm  %util
sdb            9243.00     0.00  720.00   83.00    23.93     8.20    81=
=2E94    19.40   21.53   1.25 100.00
sdb1              0.00     0.00    0.00    0.00     0.00     0.00     0=
=2E00     0.00    0.00   0.00   0.00
sdb2           9341.00     0.00  722.00   79.00    24.18     8.20    82=
=2E79    19.39   21.65   1.25  99.90

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           1.23    0.00    6.67   11.36    0.00   80.74

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq=
-sz avgqu-sz   await  svctm  %util
sdb           10607.00    25.00  687.00  718.00    59.84    86.66   213=
=2E54    26.66   20.83   0.66  92.20
sdb1              0.00    24.00    0.00    9.00     0.00     0.13    29=
=2E33     0.00    0.11   0.11   0.10
sdb2          10509.00     1.00  685.00  705.00    59.59    86.53   215=
=2E29    26.66   21.02   0.66  92.30

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.86    0.00    1.84   16.67    0.00   80.64

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq=
-sz avgqu-sz   await  svctm  %util
sdb             127.00     0.00  458.00  139.00     3.05    13.29    56=
=2E07     9.15   15.29   1.66  99.30
sdb1              0.00     0.00    0.00    0.00     0.00     0.00     0=
=2E00     0.00    0.00   0.00   0.00
sdb2            127.00     0.00  458.00  137.00     3.05    13.29    56=
=2E26     9.15   15.35   1.67  99.20

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.50    0.00    1.38   13.05    0.00   85.07

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq=
-sz avgqu-sz   await  svctm  %util
sdb             111.00   229.00  523.00  151.00     3.28    10.09    40=
=2E61    12.50   18.36   1.47  99.00
sdb1              0.00   229.00    2.00   54.00     0.25     1.11    49=
=2E57     0.33    5.82   1.14   6.40
sdb2            111.00     0.00  521.00   89.00     3.03     8.98    40=
=2E31    12.17   19.75   1.62  99.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.88    0.00    1.26   14.99    0.00   82.87

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq=
-sz avgqu-sz   await  svctm  %util
sdb             171.00     0.00  539.00   86.00     3.29     7.48    35=
=2E28    10.23   16.33   1.58  98.80
sdb1              0.00     0.00    0.00    0.00     0.00     0.00     0=
=2E00     0.00    0.00   0.00   0.00
sdb2            171.00     0.00  540.00   78.00     3.29     7.48    35=
=2E69    10.23   16.55   1.60  98.80

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.76    0.00    1.90   17.62    0.00   79.72

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq=
-sz avgqu-sz   await  svctm  %util
sdb             156.00     0.00  536.00  119.00     3.31    11.17    45=
=2E26    12.63   18.86   1.51  99.20
sdb1              0.00     0.00    0.00    0.00     0.00     0.00     0=
=2E00     0.00    0.00   0.00   0.00
sdb2            156.00     0.00  535.00  114.00     3.30    11.17    45=
=2E67    12.63   19.00   1.53  99.20

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.49    0.00    1.10   14.81    0.00   83.60

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq=
-sz avgqu-sz   await  svctm  %util
sdb             169.00    23.00  552.00   94.00     3.36     9.02    39=
=2E24    15.50   24.51   1.54  99.80
sdb1              0.00    23.00    0.00    6.00     0.00     0.11    38=
=2E67     0.00    0.00   0.00   0.00
sdb2            169.00     0.00  552.00   82.00     3.36     8.90    39=
=2E62    15.50   24.97   1.57  99.80

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.75    0.00    1.25   14.91    0.00   83.08

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq=
-sz avgqu-sz   await  svctm  %util
sdb             140.00     0.00  589.00  104.00     3.61     9.41    38=
=2E50    12.04   17.35   1.43  99.20
sdb1              0.00     0.00    0.00    0.00     0.00     0.00     0=
=2E00     0.00    0.00   0.00   0.00
sdb2            140.00     0.00  589.00  103.00     3.61     9.41    38=
=2E55    12.04   17.38   1.43  99.20

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.63    0.00    1.14   14.68    0.00   83.54

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq=
-sz avgqu-sz   await  svctm  %util
sdb             174.00   323.00  599.00  112.00     3.97    10.52    41=
=2E73    12.44   17.52   1.39  98.60
sdb1              0.00   323.00    0.00   11.00     0.00     1.30   242=
=2E91     0.11    9.82   1.00   1.10
sdb2            174.00     0.00  601.00   93.00     3.98     9.21    38=
=2E93    12.33   17.84   1.42  98.60

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.49    0.00    1.11   15.23    0.00   83.17

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq=
-sz avgqu-sz   await  svctm  %util
sdb              95.00     0.00  750.00   65.00     3.91     6.57    26=
=2E34    20.28   24.46   1.22  99.50
sdb1              0.00     0.00    1.00    0.00     0.12     0.00   256=
=2E00     0.07   71.00  71.00   7.10
sdb2             95.00     0.00  747.00   60.00     3.78     6.57    26=
=2E26    20.20   24.56   1.23  99.50

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.50    0.00    1.37   13.04    0.00   85.09

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq=
-sz avgqu-sz   await  svctm  %util
sdb             159.00     0.00  557.00   96.00     3.23     8.82    37=
=2E81    16.73   26.08   1.52  99.40
sdb1              0.00     0.00    0.00    0.00     0.00     0.00     0=
=2E00     0.00    0.00   0.00   0.00
sdb2            159.00     0.00  557.00   92.00     3.23     8.82    38=
=2E04    16.73   26.24   1.53  99.40

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.51    0.00    1.16   14.51    0.00   83.83

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq=
-sz avgqu-sz   await  svctm  %util
sdb             139.00     0.00  637.00   79.00     3.73     7.44    31=
=2E96    14.28   20.11   1.39  99.80
sdb1              0.00     0.00    2.00    0.00     0.25     0.00   256=
=2E00     0.04   22.00  22.00   4.40
sdb2            139.00     0.00  635.00   67.00     3.48     7.44    31=
=2E86    14.24   20.45   1.42  99.80

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.98    0.00    1.60   15.83    0.00   81.60

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq=
-sz avgqu-sz   await  svctm  %util
sdb             198.00    15.00  566.00  109.00     3.79    10.37    42=
=2E96    14.10   20.60   1.48  99.60
sdb1              0.00    15.00    1.00    6.00     0.12     0.08    60=
=2E57     0.02    2.71   2.71   1.90
sdb2            198.00     0.00  566.00   97.00     3.67    10.29    43=
=2E11    14.08   20.97   1.50  99.60

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           1.11    0.00    1.35   17.32    0.00   80.22

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq=
-sz avgqu-sz   await  svctm  %util
sdb             168.00   257.00  613.00   99.00     3.60     9.41    37=
=2E43    15.08   21.11   1.39  99.10
sdb1              0.00   257.00    0.00   10.00     0.00     1.04   213=
=2E60     0.26   26.00   2.60   2.60
sdb2            168.00     0.00  612.00   86.00     3.59     8.37    35=
=2E11    14.82   21.13   1.42  99.10


Below is a snapshot of iotop:

Total DISK READ:       3.26 M/s | Total DISK WRITE:      66.36 M/s
  TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO>    COMMAND =
                                                                       =
                                                                =20
32291 be/4 my6013   1854.71 K/s   77.93 K/s  0.00 % 84.47 % mysqld --de=
faults-file=3D/data0/mysql6013/my6013.cnf
32038 be/4 my6005    472.77 K/s  233.79 K/s  0.00 % 38.31 % mysqld --de=
faults-file=3D/data0/mysql6005/my6005.cnf
27470 be/4 my6015    316.91 K/s    0.00 B/s  0.00 % 26.11 % mysqld --de=
faults-file=3D/data0/mysql6015/my6015.cnf
14478 be/4 my6010    124.69 K/s  223.40 K/s  0.00 % 19.95 % mysqld --de=
faults-file=3D/data0/mysql6010/my6010.cnf
32131 be/4 my6007    363.67 K/s  264.96 K/s  0.00 % 16.28 % mysqld --de=
faults-file=3D/data0/mysql6007/my6007.cnf
11578 be/4 my6018     31.17 K/s  353.28 K/s  0.00 % 14.17 % mysqld --de=
faults-file=3D/data0/mysql6018/my6018.cnf
27469 be/4 my6015      5.20 K/s   15.59 K/s  0.00 % 12.47 % mysqld --de=
faults-file=3D/data0/mysql6015/my6015.cnf
25104 be/4 my6009     15.59 K/s  161.05 K/s  0.00 %  9.47 % mysqld --de=
faults-file=3D/data0/mysql6009/my6009.cnf
 7144 be/4 root       41.56 K/s    5.82 M/s  0.00 %  8.41 % [segctord]
11498 be/4 my6018     46.76 K/s   67.54 K/s  0.00 %  7.50 % mysqld --de=
faults-file=3D/data0/mysql6018/my6018.cnf
 1307 be/4 my6016      5.20 K/s  140.27 K/s  0.00 %  4.83 % mysqld --de=
faults-file=3D/data0/mysql6016/my6016.cnf
11481 be/4 my6018     20.78 K/s    0.00 B/s  0.00 %  3.89 % mysqld --de=
faults-file=3D/data0/mysql6018/my6018.cnf
13831 be/4 my6003      5.20 K/s  181.83 K/s  0.00 %  0.77 % mysqld --de=
faults-file=3D/data0/mysql6003/my6003.cnf
  973 be/4 root        0.00 B/s   46.76 K/s  0.00 %  0.03 % [kjournald]
  972 be/4 root        0.00 B/s    0.00 B/s  0.00 %  0.02 % [kjournald]
18568 be/4 my6016      0.00 B/s   93.51 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6016/my6016.cnf
18569 be/4 my6016      0.00 B/s  207.81 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6016/my6016.cnf
14477 be/4 my6010      0.00 B/s  109.10 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6010/my6010.cnf
32130 be/4 my6007      0.00 B/s   51.95 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6007/my6007.cnf
12656 be/4 www         0.00 B/s 1449.48 K/s  0.00 %  0.00 % rsync --dae=
mon
25103 be/4 my6009      0.00 B/s   31.17 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6009/my6009.cnf
  962 be/4 my6013      0.00 B/s  353.28 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6013/my6013.cnf
  963 be/4 my6013      0.00 B/s  327.30 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6013/my6013.cnf
  964 be/4 my6013      0.00 B/s  135.08 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6013/my6013.cnf
  965 be/4 my6013      0.00 B/s  290.94 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6013/my6013.cnf
 7145 be/4 root        0.00 B/s  446.79 K/s  0.00 %  0.00 % nilfs_clean=
erd -n /dev/sdb2 /data0/
13830 be/4 my6003      0.00 B/s   62.34 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6003/my6003.cnf
27723 be/4 my6015      0.00 B/s  244.18 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6015/my6015.cnf
27722 be/4 my6015      0.00 B/s  150.66 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6015/my6015.cnf
11577 be/4 my6018      0.00 B/s  124.69 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6018/my6018.cnf
32193 be/4 my6011      0.00 B/s   98.71 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6011/my6011.cnf
32240 be/4 my6012      0.00 B/s   93.51 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6012/my6012.cnf
11803 be/4 my6002      0.00 B/s   15.59 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6002/my6002.cnf
11804 be/4 my6002      0.00 B/s   25.98 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6002/my6002.cnf
32290 be/4 my6013      0.00 B/s  140.27 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6013/my6013.cnf
32352 be/4 my6014      0.00 B/s   25.98 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6014/my6014.cnf
32037 be/4 my6005      0.00 B/s  150.66 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6005/my6005.cnf
  984 be/4 my6013      0.00 B/s 1329.99 K/s  0.00 %  0.00 % mysqld --de=
faults-file=3D/data0/mysql6013/my6013.cnf



=D4=DA 2012-12-25=A3=AC14:02=A3=ACVyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org=
> =D0=B4=B5=C0=A3=BA

> Hi,
>=20
> On Thu, 2012-12-20 at 19:02 +0800, =D5=C5 =C0=DA wrote:
>> Yes, I mounted NILFS2 as read-write. It's remounted as read-only by =
kernel when filesystem found the bad btree node.
>>=20
>> That's the full backtrace. I will keep on testing, and report more i=
nfomation once I found.
>>=20
>=20
> I am trying to reproduce the issue but currently without any success.=
 I
> have a presupposition that it can be a synchronization issue between =
GC
> and main driver logic but I haven't any evidence of it yet. Probably,=
 I
> can't reproduce some environment's peculiarities.
>=20
> So, I think that I need to understand more deeply a workload in that =
the
> issue had occurred. As I remember, you talked about several MySQL
> databases and so on. Could you describe in more details about what
> applications and how to work before issue occurrence?
>=20
> Thanks,
> Vyacheslav Dubeyko.
>=20
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
