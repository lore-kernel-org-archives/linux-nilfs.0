From: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Subject: Broken nilfs2 filesystem
Date: Wed, 22 May 2013 22:33:26 +0200
Message-ID: <519D2B96.9000106@antoneliasson.se>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050203010306040108050707"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org

This is a multi-part message in MIME format.
--------------050203010306040108050707
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: quoted-printable

Greetings!
It pains me to report that my /home filesystem broke down today. My=20
system is running Arch Linux 64-bit. The filesystem resides on a Crucial=20
M4 256 GB SSD, on top of a LVM2 volume. The drive and filesystem are=20
both around six months old. Partition table and error log excerpts are=20
at the bottom of this e-mail. Full logs are available upon request.

I am providing this information as a bug report. I have no reason to=20
suspect the hardware but I cannot exclude it either. If you (the=20
developers) are interested in troubleshooting this for prosperity, I can=20
be your hands and run whatever tools are required. If not, I'll reformat=20
the filesystem, restore the data from backup and forget that this happened.

In case the formatting gets mangled, this e-mail is also available at=20
What happened today, in chronological order:

~18:00
=3D=3D=3D=3D=3D=3D
I am troubleshooting some issues that turn out to be caused by a wrongly=20
configured system clock. The RTC (hardware clock) is set to local time=20
(UTC+2) but the OS is configured to treat the RTC as UTC. This is=20
because it was set to UTC previously, but then I reinstalled Windows=20
which promptly reset it to local time.

This set the mtime of some files in both / and /home to dates in the=20
future. When I discovered this, I `touch`ed all affected files (`touch=20
now; sudo find / /home -xdev -newer now -exec touch {} \;`) to reset=20
their mtime and rebooted the system. I do not know if this is relevant;=20
if not, it makes reading the log files more fun.

I then launch my command line backup program "bup", Firefox and some=20
other apps.

~18:50-19:00
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Firefox freezes. The system keeps running but I can't launch new=20
programs. It looked like all I/O broke down. However, bup kept running.=20
I left the computer alone for perhaps 30-60 min.

~20:00
=3D=3D=3D=3D=3D=3D
When I came back, bup hade frozen (/var/log/messages at 18:53:31).[1] I=20
restart X by pressing Alt+SysRq+K (/var/log/messages at 20:06:33) and=20
return to the login screen. The system freezes during login though,=20
probably because /home had probably been mounted read only). So I reboot=20
using Alt+SysRq+REISUB (/var/log/messages at 20:07:05). I noticed some=20
I/O errors during shutdown.

After the reboot there are no immediate signs of disaster. I launch bup=20
again. Some time later, /home remounts as read only. I notice that bup=20
has reported I/O errors while reading some files in /home.[2] dmesg and=20
/var/log/kern.log contains errors mentioning "bad btree node" and=20
"nilfs_bmap_lookup_contig: broken bmap".[3]

I proceed to examine one of the files that bup reported I/O errors for:

     [2/5.0.2]{1}anton@riven:~/Bilder/20130321-28 Jakobs bilder fr=E5n=20
Nederl=E4nderna> LANG=3DC stat 179.JPG
       File: '179.JPG'
       Size: 3774546   	Blocks: 7416       IO Block: 4096   regular file
     Device: fe03h/65027d	Inode: 136492      Links: 1
     Access: (0644/-rw-r--r--)  Uid: ( 1000/   anton)   Gid: ( 1000/=20
anton)
     Access: 2013-03-28 22:04:48.000000000 +0100
     Modify: 2013-03-28 22:04:48.000000000 +0100
     Change: 2013-04-30 16:40:34.053914840 +0200
      Birth: -
     [2/5.0.2]anton@riven:~/Bilder/20130321-28 Jakobs bilder fr=E5n=20
Nederl=E4nderna> LANG=3D cat 179.JPG > /dev/null
     cat: 179.JPG: Input/output error
     [2/5.0.2]{1}anton@riven:~/Bilder/20130321-28 Jakobs bilder fr=E5n=20
Nederl=E4nderna> LANG=3DC cat 179.JPG > /dev/null
     cat: 179.JPG: Input/output error
     [2/5.0.2]{1}anton@riven:~/Bilder/20130321-28 Jakobs bilder fr=E5n=20
Nederl=E4nderna> dmesg | tail

     [ 3762.363260] NILFS: bad btree node (blocknr=3D14351789): level =3D 0=
,=20
flags =3D 0x0, nchildren =3D 0
     [ 3762.363269] NILFS error (device dm-3): nilfs_bmap_lookup_contig:=20
broken bmap (inode number=3D136492)

     [ 3855.881972] NILFS: bad btree node (blocknr=3D14351789): level =3D 0=
,=20
flags =3D 0x0, nchildren =3D 0
     [ 3855.881980] NILFS error (device dm-3): nilfs_bmap_lookup_contig:=20
broken bmap (inode number=3D136492)

     [ 3857.977754] NILFS: bad btree node (blocknr=3D14351789): level =3D 0=
,=20
flags =3D 0x0, nchildren =3D 0
     [ 3857.977763] NILFS error (device dm-3): nilfs_bmap_lookup_contig:=20
broken bmap (inode number=3D136492)

     [2/5.0.2]anton@riven:~/Bilder/20130321-28 Jakobs bilder fr=E5n=20
Nederl=E4nderna> sudo journalctl -xn
     [sudo] password for anton:
     -- Logs begin at fre 2012-10-19 17:29:01 CEST, end at ons=20
2013-05-22 21:12:17 CEST. --
     maj 22 21:09:45 riven sudo[1545]: pam_unix(sudo:session): session=20
closed for user root
     maj 22 21:10:42 riven kernel: NILFS: bad btree node=20
(blocknr=3D14351789): level =3D 0, flags =3D 0x0, nchildren =3D 0
     maj 22 21:10:42 riven kernel: [87B blob data]
     maj 22 21:11:12 riven sudo[1563]: anton : TTY=3Dpts/3 ;=20
PWD=3D/Athena/Dump/nilfs-fels=F6kning-2013-05-22 ; USER=3Droot ; COMM
     maj 22 21:11:12 riven sudo[1563]: pam_unix(sudo:session): session=20
opened for user root by anton(uid=3D0)
     maj 22 21:11:18 riven sudo[1563]: pam_unix(sudo:session): session=20
closed for user root
     maj 22 21:12:15 riven kernel: NILFS: bad btree node=20
(blocknr=3D14351789): level =3D 0, flags =3D 0x0, nchildren =3D 0
     maj 22 21:12:15 riven kernel: [87B blob data]
     maj 22 21:12:17 riven kernel: NILFS: bad btree node=20
(blocknr=3D14351789): level =3D 0, flags =3D 0x0, nchildren =3D 0
     maj 22 21:12:17 riven kernel: [87B blob data]
     [2/5.0.2]anton@riven:~/Bilder/20130321-28 Jakobs bilder fr=E5n=20
Nederl=E4nderna> LANG=3DC rm 179.JPG
     rm: cannot remove '179.JPG': Read-only file system

System configuration
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Summary
-------
/ is on the logical volume riven/arch. /home is on the logical volume=20
riven/home. The volume group riven is on the physical volume sda2. The=20
physical volume sda2 is on the Crucial M4 SSD.

There is also a volume group riven-proto on a 1 TB hard disk drive=20
containing an old unused Arch Linux installation and a filesystem=20
"supplement" which is still used.

There is one NTFS partition on the SSD sda and one on the HDD sdb. sdb3=20
is an old unused ext4 partition.

/etc/fstab
----------
     tmpfs		/tmp	tmpfs	nodev,nosuid	0	0
     /dev/mapper/riven-arch	/         	nilfs2    	rw,noatime,discard 0 0
     /dev/mapper/riven-home	/home     	nilfs2    	rw,noatime,discard 0 0
     /dev/mapper/riven-swap  none            swap            defaults=20
         0 0
     /dev/riven-proto/supplement /Supplement ext4 defaults,noatime 0 0
# some NFS mounts excluded

$ sudo lvdisplay
----------------
   --- Logical volume ---
   LV Path                /dev/riven-proto/arch
   LV Name                arch
   VG Name                riven-proto
   LV UUID                GA0SNf-N1rZ-ErCU-ALG5-0L6D-Ix4j-s3cLe4
   LV Write Access        read/write
   LV Creation host, time archiso, 2012-09-27 22:42:09 +0200
   LV Status              available
   # open                 0
   LV Size                30,00 GiB
   Current LE             7680
   Segments               1
   Allocation             inherit
   Read ahead sectors     auto
   - currently set to     256
   Block device           254:1

   --- Logical volume ---
   LV Path                /dev/riven-proto/supplement
   LV Name                supplement
   VG Name                riven-proto
   LV UUID                jgrYcK-fEm9-tAOq-I6PR-PB4N-Khet-E0qsaU
   LV Write Access        read/write
   LV Creation host, time riven, 2012-10-31 18:31:31 +0100
   LV Status              available
   # open                 1
   LV Size                200,00 GiB
   Current LE             51200
   Segments               1
   Allocation             inherit
   Read ahead sectors     auto
   - currently set to     256
   Block device           254:4

   --- Logical volume ---
   LV Path                /dev/riven/swap
   LV Name                swap
   VG Name                riven
   LV UUID                28r67b-M7hy-2orC-5snN-7CUu-jqGn-x1vxXc
   LV Write Access        read/write
   LV Creation host, time archiso, 2012-10-06 15:47:56 +0200
   LV Status              available
   # open                 2
   LV Size                1,00 GiB
   Current LE             256
   Segments               1
   Allocation             inherit
   Read ahead sectors     auto
   - currently set to     256
   Block device           254:0

   --- Logical volume ---
   LV Path                /dev/riven/arch
   LV Name                arch
   VG Name                riven
   LV UUID                QAjHWq-5eDv-IyQe-ihiq-dpyZ-acIR-Imox4Y
   LV Write Access        read/write
   LV Creation host, time archiso, 2012-10-06 15:48:50 +0200
   LV Status              available
   # open                 2
   LV Size                30,00 GiB
   Current LE             7680
   Segments               1
   Allocation             inherit
   Read ahead sectors     auto
   - currently set to     256
   Block device           254:2

   --- Logical volume ---
   LV Path                /dev/riven/home
   LV Name                home
   VG Name                riven
   LV UUID                YAQgTA-3Cvo-fuzu-6Uaj-0C6m-Tzt9-SyGv2y
   LV Write Access        read/write
   LV Creation host, time archiso, 2012-10-06 15:50:25 +0200
   LV Status              available
   # open                 1
   LV Size                109,68 GiB
   Current LE             28079
   Segments               1
   Allocation             inherit
   Read ahead sectors     auto
   - currently set to     256
   Block device           254:3


$ sudo vgdisplay
----------------------
   --- Volume group ---
   VG Name               riven-proto
   System ID
   Format                lvm2
   Metadata Areas        1
   Metadata Sequence No  11
   VG Access             read/write
   VG Status             resizable
   MAX LV                0
   Cur LV                2
   Open LV               1
   Max PV                0
   Cur PV                1
   Act PV                1
   VG Size               512,41 GiB
   PE Size               4,00 MiB
   Total PE              131178
   Alloc PE / Size       58880 / 230,00 GiB
   Free  PE / Size       72298 / 282,41 GiB
   VG UUID               HGfujG-CdYE-zQuD-xIOf-Lyus-8B3f-4WPPxp

   --- Volume group ---
   VG Name               riven
   System ID
   Format                lvm2
   Metadata Areas        1
   Metadata Sequence No  4
   VG Access             read/write
   VG Status             resizable
   MAX LV                0
   Cur LV                3
   Open LV               3
   Max PV                0
   Cur PV                1
   Act PV                1
   VG Size               140,68 GiB
   PE Size               4,00 MiB
   Total PE              36015
   Alloc PE / Size       36015 / 140,68 GiB
   Free  PE / Size       0 / 0
   VG UUID               EZSXiE-F9Ec-vUX2-Ny0l-Fa2U-IIr6-6sAmIV


$ sudo pvdisplay
--------------------------
   --- Physical volume ---
   PV Name               /dev/sdb2
   VG Name               riven-proto
   PV Size               512,42 GiB / not usable 4,00 MiB
   Allocatable           yes
   PE Size               4,00 MiB
   Total PE              131178
   Free PE               72298
   Allocated PE          58880
   PV UUID               dAN0do-QWac-iBO6-tBxg-fr2z-ciNL-EZyOko

   --- Physical volume ---
   PV Name               /dev/sda2
   VG Name               riven
   PV Size               140,68 GiB / not usable 0
   Allocatable           yes (but full)
   PE Size               4,00 MiB
   Total PE              36015
   Free PE               0
   Allocated PE          36015
   PV UUID               KtuR1D-G2vj-8qb9-Kzyz-xkDP-weI9-NtHFMc


$ LANG=3DC sudo fdisk -l
----------------------

Disk /dev/sda: 256.1 GB, 256060514304 bytes, 500118192 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x000e08ae

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048   205078527   102538240    7  HPFS/NTFS/exFAT
/dev/sda2       205078528   500115455   147518464   83  Linux

Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes, 1953525168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x000b5f5c

    Device Boot      Start         End      Blocks   Id  System
/dev/sdb1              63   615353759   307676848+   7  HPFS/NTFS/exFAT
/dev/sdb2       878905344  1953523711   537309184   83  Linux
/dev/sdb3   *   877930496   878905343      487424   83  Linux

Partition table entries are not in disk order

Disk /dev/mapper/riven-swap: 1073 MB, 1073741824 bytes, 2097152 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/riven--proto-arch: 32.2 GB, 32212254720 bytes, 62914560=20
sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x20ac7dda

This doesn't look like a partition table
Probably you selected the wrong device.

                         Device Boot      Start         End      Blocks=20
   Id  System
/dev/mapper/riven--proto-arch1   ?  3224498923  3657370039   216435558+=20
   7  HPFS/NTFS/exFAT
/dev/mapper/riven--proto-arch2   ?  3272020941  5225480974   976730017=20
  16  Hidden FAT16
/dev/mapper/riven--proto-arch3   ?           0           0           0=20
  6f  Unknown
/dev/mapper/riven--proto-arch4        50200576   974536369   462167897=20
   0  Empty

Partition table entries are not in disk order

Disk /dev/mapper/riven-arch: 32.2 GB, 32212254720 bytes, 62914560 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/riven-home: 117.8 GB, 117771862016 bytes, 230023168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/riven--proto-supplement: 214.7 GB, 214748364800 bytes,=20
419430400 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

$ ls -l /dev/riven/
-------------------
totalt 0
lrwxrwxrwx 1 root root 7 22 maj 20.08 arch -> ../dm-2
lrwxrwxrwx 1 root root 7 22 maj 20.08 home -> ../dm-3
lrwxrwxrwx 1 root root 7 22 maj 20.08 swap -> ../dm-0

/etc/nilfs-cleanerd.conf
------------------------
protection_period	0
min_clean_segments	0
max_clean_segments	100%
clean_check_interval	10
selection_policy	timestamp	# timestamp in ascend order
nsegments_per_clean	2
mc_nsegments_per_clean	4
cleaning_interval	5
mc_cleaning_interval	1
retry_interval		60
use_mmap
log_priority		info


References
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

[1]:
See attached file "messages-excerpt-Anton_Eliasson-20130522"

[2]:
     [2/5.0.2]anton@riven:~> bup.sh
     /home/anton/etc-tomahna-20120615/etc/vmware/: [Errno 13] Permission=20
denied
     Indexing: 117930, done.
     bup: merging indexes (211106/211106), done.
     WARNING: 1 errors encountered.
     Reading index: 211091, done.
     /home/anton/vmware/WXP/WXP-disk1.vmdk: [Errno 5] Input/output error
     /home/anton/Bilder/20130321-28 Jakobs bilder fr=E5n=20
Nederl=E4nderna/179.JPG: [Errno 5] Input/output error
     /home/anton/Bilder/20130321-28 Jakobs bilder fr=E5n=20
Nederl=E4nderna/172.JPG: [Errno 5] Input/output error
     /home/anton/Bilder/20130321-28 Jakobs bilder fr=E5n=20
Nederl=E4nderna/170.JPG: [Errno 5] Input/output error
     /home/anton/Bilder/20130321-28 Jakobs bilder fr=E5n=20
Nederl=E4nderna/165.JPG: [Errno 5] Input/output error
     /home/anton/Bilder/20130321-28 Jakobs bilder fr=E5n=20
Nederl=E4nderna/164.JPG: [Errno 5] Input/output error
     /home/anton/Bilder/20130321-28 Jakobs bilder fr=E5n=20
Nederl=E4nderna/163.JPG: [Errno 5] Input/output error
     /home/anton/Bilder/20130321-28 Jakobs bilder fr=E5n=20
Nederl=E4nderna/160.JPG: [Errno 5] Input/output error
     Saving: 100.00% (52192637/52192637k, 211091/211091 files), done.
     bloom: adding 1 file (59294 objects).
     Traceback (most recent call last):
       File "/usr/lib/bup/cmd/bup-save", line 431, in <module>
         w.close()  # must close before we can update the ref
       File "/usr/lib/bup/bup/client.py", line 316, in close
         id =3D self._end()
       File "/usr/lib/bup/bup/client.py", line 313, in _end
         return self.suggest_packs() # Returns last idx received
       File "/usr/lib/bup/bup/client.py", line 233, in _suggest_packs
         self.sync_index(idx)
       File "/usr/lib/bup/bup/client.py", line 193, in sync_index
         f =3D open(fn + '.tmp', 'w')
     IOError: [Errno 30] Read-only file system:=20
'/home/anton/.bup/index-cache/hermes__Athena_Backup_bup/pack-90022de5619eee=
12a7611a33caf41047fb57a90a.idx.tmp'
     [2/5.0.2]{1}anton@riven:~>

[3]:
     [  233.951973] NILFS: bad btree node (blocknr=3D19549978): level =3D 0=
,=20
flags =3D 0x0, nchildren =3D 0
     [  233.951982] NILFS error (device dm-3): nilfs_bmap_lookup_contig:=20
broken bmap (inode number=3D4301)

     [  233.955999] Remounting filesystem read-only
     [  233.956119] NILFS: bad btree node (blocknr=3D19549978): level =3D 0=
,=20
flags =3D 0x0, nchildren =3D 0
     [  233.956125] NILFS error (device dm-3): nilfs_bmap_lookup_contig:=20
broken bmap (inode number=3D4301)

     [  233.956417] NILFS: bad btree node (blocknr=3D19549978): level =3D 0=
,=20
flags =3D 0x0, nchildren =3D 0
     [  233.956422] NILFS error (device dm-3): nilfs_bmap_lookup_contig:=20
broken bmap (inode number=3D4301)

     [  233.956524] NILFS: bad btree node (blocknr=3D19549978): level =3D 0=
,=20
flags =3D 0x0, nchildren =3D 0
     [  233.956530] NILFS error (device dm-3): nilfs_bmap_lookup_contig:=20
broken bmap (inode number=3D4301)

     ...

     [  819.004092] NILFS: bad btree node (blocknr=3D14351789): level =3D 0=
,=20
flags =3D 0x0, nchildren =3D 0
     [  819.004101] NILFS error (device dm-3): nilfs_bmap_lookup_contig:=20
broken bmap (inode number=3D136492)

     [  819.004177] NILFS: bad btree node (blocknr=3D14351789): level =3D 0=
,=20
flags =3D 0x0, nchildren =3D 0
     [  819.004181] NILFS error (device dm-3): nilfs_bmap_lookup_contig:=20
broken bmap (inode number=3D136492)

     [  819.004257] NILFS: bad btree node (blocknr=3D14351789): level =3D 0=
,=20
flags =3D 0x0, nchildren =3D 0
     [  819.004263] NILFS error (device dm-3): nilfs_bmap_lookup_contig:=20
broken bmap (inode number=3D136492)

     ...

--=20
Best Regards,
Anton Eliasson

--------------050203010306040108050707
Content-Type: text/plain; charset="utf-8"; name="messages-excerpt-Anton_Eliasson-20130522"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="messages-excerpt-Anton_Eliasson-20130522"

May 22 18:50:14 riven slim[274]: 18:50:14 | ListenerTcp | Pinging tcp://notifications.sparkleshare.org:443/
May 22 18:50:14 riven slim[274]: 18:50:14 | ListenerTcp | Received pong from tcp://notifications.sparkleshare.org:443/
May 22 18:53:31 riven kernel: [ 3821.605591] PGD 19636d067 PUD 19636e067 PMD 0 
May 22 18:53:31 riven kernel: [ 3821.605597] Oops: 0000 [#1] PREEMPT SMP 
May 22 18:53:31 riven kernel: [ 3821.605602] Modules linked in: nfsv3 nfs_acl ppdev parport_pc parport fuse vsock btrfs nvidia(PO) raid6_pq crc32c libcrc32c zlib_deflate iTCO_wdt iTCO_vendor_support gpio_ich ext4 crc16 mbcache xor jbd2 coretemp kvm_intel kvm snd_hda_codec_realtek microcode psmouse pcspkr serio_raw lpc_ich i2c_i801 snd_hda_intel r8169 evdev snd_hda_codec drm mii i2c_core snd_hwdep snd_pcm acpi_cpufreq snd_page_alloc mperf snd_timer snd button soundcore intel_agp intel_gtt processor loop nfs lockd sunrpc fscache nilfs2 dm_mod sd_mod sr_mod cdrom ata_generic pata_acpi hid_generic usbhid hid pata_it8213 ahci libahci firewire_ohci libata firewire_core scsi_mod crc_itu_t ehci_pci uhci_hcd ehci_hcd usbcore usb_common
May 22 18:53:31 riven kernel: [ 3821.605669] CPU 2 
May 22 18:53:31 riven kernel: [ 3821.605674] Pid: 250, comm: nilfs_cleanerd Tainted: P           O 3.9.3-1-ARCH #1 Gigabyte Technology Co., Ltd. EP45-DS4/EP45-DS4
May 22 18:53:31 riven kernel: [ 3821.605677] RIP: 0010:[<ffffffffa027f1a2>]  [<ffffffffa027f1a2>] nilfs_end_page_io+0x12/0xc0 [nilfs2]
May 22 18:53:31 riven kernel: [ 3821.605686] RSP: 0018:ffff8801960f7b30  EFLAGS: 00010202
May 22 18:53:31 riven kernel: [ 3821.605690] RAX: ffff880101b49250 RBX: 00000000000036cd RCX: 0000000000000034
May 22 18:53:31 riven kernel: [ 3821.605692] RDX: 000000000000000d RSI: 0000000000000000 RDI: 00000000000036cd
May 22 18:53:31 riven kernel: [ 3821.605695] RBP: ffff8801960f7b38 R08: 1c00000000000000 R09: a80000c80e000000
May 22 18:53:31 riven kernel: [ 3821.605697] R10: 57ffe937f2320380 R11: 0000000000000019 R12: ffff8801a27ac738
May 22 18:53:31 riven kernel: [ 3821.605700] R13: ffff880101b49208 R14: ffffea00001eab40 R15: ffffea00001dee80
May 22 18:53:31 riven kernel: [ 3821.605703] FS:  00007f44fa5d0740(0000) GS:ffff8801afd00000(0000) knlGS:0000000000000000
May 22 18:53:31 riven kernel: [ 3821.605706] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
May 22 18:53:31 riven kernel: [ 3821.605709] CR2: 00000000000036cd CR3: 000000019636a000 CR4: 00000000000007e0
May 22 18:53:31 riven kernel: [ 3821.605711] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May 22 18:53:31 riven kernel: [ 3821.605714] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
May 22 18:53:31 riven kernel: [ 3821.605717] Process nilfs_cleanerd (pid: 250, threadinfo ffff8801960f6000, task ffff8801a509cb60)
May 22 18:53:31 riven kernel: [ 3821.605719] Stack:
May 22 18:53:31 riven kernel: [ 3821.605721]  ffff8801a27ac690 ffff8801960f7c20 ffffffffa0280ed5 0000000000000002
May 22 18:53:31 riven kernel: [ 3821.605727]  ffff8801a509cb60 ffff8801a509cb60 ffff8801a509cb60 ffff8801a3dc6070
May 22 18:53:31 riven kernel: [ 3821.605731]  ffff8801a5cddd60 ffff8801a5cddc00 00000001001ead00 ffff8801a3dc6060
May 22 18:53:31 riven kernel: [ 3821.605736] Call Trace:
May 22 18:53:31 riven kernel: [ 3821.605747]  [<ffffffffa0280ed5>] nilfs_segctor_do_construct+0xd65/0x1ab0 [nilfs2]
May 22 18:53:31 riven kernel: [ 3821.605756]  [<ffffffffa0281e42>] nilfs_segctor_construct+0x172/0x290 [nilfs2]
May 22 18:53:31 riven kernel: [ 3821.605765]  [<ffffffffa0282ead>] nilfs_clean_segments+0xed/0x270 [nilfs2]
May 22 18:53:31 riven kernel: [ 3821.605771]  [<ffffffff811bc4bc>] ? __set_page_dirty+0x6c/0xc0
May 22 18:53:31 riven kernel: [ 3821.605780]  [<ffffffffa028906f>] nilfs_ioctl_clean_segments.isra.14+0x4bf/0x740 [nilfs2]
May 22 18:53:31 riven kernel: [ 3821.605788]  [<ffffffffa0279a8d>] ? nilfs_btree_lookup+0x4d/0x70 [nilfs2]
May 22 18:53:31 riven kernel: [ 3821.605797]  [<ffffffffa028970c>] nilfs_ioctl+0x21c/0x740 [nilfs2]
May 22 18:53:31 riven kernel: [ 3821.605802]  [<ffffffff814d0b76>] ? __schedule+0x3f6/0x940
May 22 18:53:31 riven kernel: [ 3821.605808]  [<ffffffff8119cf65>] do_vfs_ioctl+0x2e5/0x4d0
May 22 18:53:31 riven kernel: [ 3821.605813]  [<ffffffff81152930>] ? do_munmap+0x2b0/0x3e0
May 22 18:53:31 riven kernel: [ 3821.605818]  [<ffffffff8119d1d1>] sys_ioctl+0x81/0xa0
May 22 18:53:31 riven kernel: [ 3821.605822]  [<ffffffff814d3769>] ? do_device_not_available+0x19/0x20
May 22 18:53:31 riven kernel: [ 3821.605827]  [<ffffffff814d9e9d>] system_call_fastpath+0x1a/0x1f
May 22 18:53:31 riven kernel: [ 3821.605829] Code: ff ff ff 48 81 c4 88 00 00 00 5b 41 5c 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 85 ff 48 89 e5 53 48 89 fb 74 4e <48> 8b 07 f6 c4 08 0f 84 8c 00 00 00 48 8b 47 30 48 8b 00 f6 c4 
May 22 18:53:31 riven kernel: [ 3821.605881]  RSP <ffff8801960f7b30>
May 22 18:53:31 riven kernel: [ 3821.605884] CR2: 00000000000036cd
May 22 18:53:31 riven kernel: [ 3821.605887] ---[ end trace 21dfcc9b8d62edba ]---
May 22 18:55:14 riven slim[274]: 18:55:14 | ListenerTcp | Pinging tcp://notifications.sparkleshare.org:443/
May 22 18:58:33 riven slim[274]: /home/buildbot/buildslave_steam/steam_rel_client_ubuntu12_linux/build/src/clientdll/../common/pipes.cpp (722) : Assertion Failed: Stalled cross-thread pipe
May 22 18:58:33 riven slim[274]: /home/buildbot/buildslave_steam/steam_rel_client_ubuntu12_linux/build/src/clientdll/../common/pipes.cpp (722) : Fatal assert failed: /home/buildbot/buildslave_steam/steam_rel_client_ubuntu12_linux/build/src/clientdll/../common/pipes.cpp, line 722.  Application exiting.
May 22 18:58:33 riven slim[274]: Assert( Fatal assert ):/home/buildbot/buildslave_steam/steam_rel_client_ubuntu12_linux/build/src/clientdll/../common/pipes.cpp:722
May 22 18:58:33 riven slim[274]: Installing breakpad exception handler for appid(steam)/version(1368838102_client)
May 22 20:05:56 riven slim[274]: ESC[31m[16:43:03.489783 Warning]ESC[0m ESC[35m[ZeitgeistPlugin]ESC[0m Zeitgeist search failed: GDBus.Error:org.freedesktop.DBus.Error.UnknownMethod: No such interface `org.gnome.zeitgeist.Index' on object at path /org/gnome/zeitgeist/index/activity
May 22 20:05:56 riven slim[274]: ESC[31m[16:43:03.570057 Warning]ESC[0m ESC[35m[ZeitgeistPlugin]ESC[0m Zeitgeist search failed: GDBus.Error:org.freedesktop.DBus.Error.UnknownMethod: No such interface `org.gnome.zeitgeist.Index' on object at path /org/gnome/zeitgeist/index/activity
May 22 20:05:56 riven slim[274]: ESC[31m[16:43:03.681706 Warning]ESC[0m ESC[35m[ZeitgeistPlugin]ESC[0m Zeitgeist search failed: GDBus.Error:org.freedesktop.DBus.Error.UnknownMethod: No such interface `org.gnome.zeitgeist.Index' on object at path /org/gnome/zeitgeist/index/activity
May 22 20:05:56 riven slim[274]: Got Event! 2, -1
May 22 20:05:56 riven slim[274]: Got KeyPress! keycode: 65, modifiers: 64
May 22 20:05:56 riven slim[274]: Calling handler for '<Super>space'...
May 22 20:06:23 riven slim[274]: ** (zeitgeist-datahub:592): WARNING **: zeitgeist-datahub.vala:209: Error during inserting events: Timeout was reached
May 22 20:06:33 riven kernel: [ 8203.651816] SysRq : SAK
May 22 20:06:33 riven kernel: [ 8203.651872] SAK: killed process 318 (X): task_session(p)==tty->session
May 22 20:06:33 riven kernel: [ 8203.651977] SAK: killed process 318 (X): task_session(p)==tty->session
May 22 20:06:33 riven slim[274]: xfce4-session: Fatal IO error 11 (Resursen tillfälligt otillgänglig) on X server :0.0.
May 22 20:06:33 riven slim[274]: xfwm4: Fatal IO error 11 (Resursen tillfälligt otillgänglig) on X server :0.0.
May 22 20:06:33 riven slim[274]: xfsettingsd: Fatal IO error 11 (Resursen tillfälligt otillgänglig) on X server :0.0.
May 22 20:06:33 riven slim[274]: Thunar: Fatal IO error 11 (Resursen tillfälligt otillgänglig) on X server :0.0.
May 22 20:06:33 riven slim[274]: xfce4-panel: Fatal IO error 11 (Resursen tillfälligt otillgänglig) on X server :0.0.
May 22 20:06:33 riven slim[274]: wrapper: Fatal IO error 11 (Resursen tillfälligt otillgänglig) on X server :0.0.
May 22 20:06:33 riven slim[274]: (pasystray:564): Gdk-WARNING **: pasystray: Fatal IO error 11 (Resursen tillfälligt otillgänglig) on X server :0.0.
May 22 20:06:33 riven slim[274]: xfdesktop: Fatal IO error 11 (Resursen tillfälligt otillgänglig) on X server :0.0.
May 22 20:06:33 riven slim[274]: wrapper: Fatal IO error 11 (Resursen tillfälligt otillgänglig) on X server :0.0.
May 22 20:06:33 riven slim[274]: terminator: Fatal IO error 11 (Resursen tillfälligt otillgänglig) on X server :0.0.
May 22 20:06:33 riven slim[274]: AL lib: pulseaudio.c:353: Received context failure!
May 22 20:06:33 riven slim[274]: AL lib: pulseaudio.c:366: Received stream failure!
May 22 20:06:33 riven slim[274]: /usr/bin/xauth:  file /var/run/slim.auth does not exist
May 22 20:06:33 riven slim[274]: X.Org X Server 1.14.1
May 22 20:06:33 riven slim[274]: Release Date: 2013-04-17
May 22 20:06:33 riven slim[274]: X Protocol Version 11, Revision 0
May 22 20:06:33 riven slim[274]: Build Operating System: Linux 3.8.7-1-ARCH x86_64
May 22 20:06:33 riven slim[274]: Current Operating System: Linux riven 3.9.3-1-ARCH #1 SMP PREEMPT Sun May 19 22:50:29 CEST 2013 x86_64
May 22 20:06:33 riven slim[274]: Kernel command line: BOOT_IMAGE=/boot/vmlinuz-linux root=/dev/mapper/riven-arch ro quiet
May 22 20:06:33 riven slim[274]: Build Date: 17 April 2013  02:37:06PM
May 22 20:06:33 riven slim[274]: Current version of pixman: 0.30.0
May 22 20:06:33 riven slim[274]: Before reporting problems, check http://wiki.x.org
May 22 20:06:33 riven slim[274]: to make sure that you have the latest version.
May 22 20:06:33 riven slim[274]: Markers: (--) probed, (**) from config file, (==) default setting,
May 22 20:06:33 riven slim[274]: (++) from command line, (!!) notice, (II) informational,
May 22 20:06:33 riven slim[274]: (WW) warning, (EE) error, (NI) not implemented, (??) unknown.
May 22 20:06:33 riven slim[274]: (==) Log file: "/var/log/Xorg.0.log", Time: Wed May 22 20:06:33 2013
May 22 20:06:33 riven slim[274]: (==) Using config directory: "/etc/X11/xorg.conf.d"
May 22 20:06:33 riven slim[274]: Initializing built-in extension Generic Event Extension
May 22 20:06:33 riven slim[274]: Initializing built-in extension SHAPE
May 22 20:06:33 riven slim[274]: Initializing built-in extension MIT-SHM
May 22 20:06:33 riven slim[274]: Initializing built-in extension XInputExtension
May 22 20:06:33 riven slim[274]: Initializing built-in extension XTEST
May 22 20:06:33 riven slim[274]: Initializing built-in extension BIG-REQUESTS
May 22 20:06:33 riven slim[274]: Initializing built-in extension SYNC
May 22 20:06:33 riven slim[274]: Initializing built-in extension XKEYBOARD
May 22 20:06:33 riven slim[274]: Initializing built-in extension XC-MISC
May 22 20:06:33 riven slim[274]: Initializing built-in extension SECURITY
May 22 20:06:33 riven slim[274]: Initializing built-in extension XINERAMA
May 22 20:06:33 riven slim[274]: Initializing built-in extension XFIXES
May 22 20:06:33 riven slim[274]: Initializing built-in extension RENDER
May 22 20:06:33 riven slim[274]: Initializing built-in extension RANDR
May 22 20:06:33 riven slim[274]: Initializing built-in extension COMPOSITE
May 22 20:06:33 riven slim[274]: Initializing built-in extension DAMAGE
May 22 20:06:33 riven slim[274]: Initializing built-in extension MIT-SCREEN-SAVER
May 22 20:06:33 riven slim[274]: Initializing built-in extension DOUBLE-BUFFER
May 22 20:06:33 riven slim[274]: Initializing built-in extension RECORD
May 22 20:06:33 riven slim[274]: Initializing built-in extension DPMS
May 22 20:06:33 riven slim[274]: Initializing built-in extension X-Resource
May 22 20:06:33 riven slim[274]: Initializing built-in extension XVideo
May 22 20:06:33 riven slim[274]: Initializing built-in extension XVideo-MotionCompensation
May 22 20:06:33 riven slim[274]: Initializing built-in extension XFree86-VidModeExtension
May 22 20:06:33 riven slim[274]: Initializing built-in extension XFree86-DGA
May 22 20:06:33 riven slim[274]: Initializing built-in extension XFree86-DRI
May 22 20:06:33 riven slim[274]: Initializing built-in extension DRI2
May 22 20:06:33 riven slim[274]: Loading extension GLX
May 22 20:06:33 riven slim[274]: Loading extension NV-GLX
May 22 20:06:33 riven slim[274]: Loading extension NV-CONTROL
May 22 20:06:33 riven slim[274]: Loading extension XINERAMA
May 22 20:06:34 riven slim[274]: The XKEYBOARD keymap compiler (xkbcomp) reports:
May 22 20:06:34 riven slim[274]: > Warning:          Type "ONE_LEVEL" has 1 levels, but <RALT> has 2 symbols
May 22 20:06:34 riven slim[274]: >                   Ignoring extra symbols
May 22 20:06:34 riven slim[274]: Errors from xkbcomp are not fatal to the X server
May 22 20:07:05 riven kernel: [ 8235.987564] SysRq : Keyboard mode set to system default
May 22 20:07:06 riven kernel: [ 8236.819557] SysRq : Terminate All Tasks
May 22 20:07:06 riven [ 8236.827760] systemd-journald[150]: Received SIGTERM
May 22 20:07:06 riven [ 8236.842434] systemd[1]: getty-2yfe/R6NngVTDjBF/Jpztg@public.gmane.org holdoff time over, scheduling restart.
May 22 20:07:06 riven [ 8236.842702] systemd[1]: Cannot add dependency job for unit lvm.service, ignoring: Unit lvm.service failed to load: No such file or directory. See system logs and 'systemctl status lvm.service' for details.
May 22 20:07:06 riven [ 8236.842783] systemd[1]: Stopping Getty on tty1...
May 22 20:07:06 riven [ 8236.842948] systemd[1]: Starting Getty on tty1...
May 22 20:07:06 riven [ 8236.843662] systemd-udevd[4989]: starting version 204
May 22 20:07:06 riven [ 8236.843883] systemd[1]: Started Getty on tty1.
May 22 20:07:06 riven [ 8236.844554] systemd[1]: Started udev Kernel Device Manager.
May 22 20:07:06 riven [ 8236.847758] systemd[1]: systemd-journald.service holdoff time over, scheduling restart.
May 22 20:07:06 riven [ 8236.847820] systemd[1]: Stopping Journal Service...
May 22 20:07:06 riven [ 8236.847915] systemd[1]: Starting Journal Service...
May 22 20:07:06 riven [ 8236.849708] systemd[1]: Started Journal Service.
May 22 20:07:06 riven [ 8236.849770] systemd[1]: Starting Trigger Flushing of Journal to Persistent Storage...
May 22 20:07:06 riven ntpd[441]: ntpd exiting on signal 15
May 22 20:07:06 riven dhcpcd[415]: received SIGTERM, stopping
May 22 20:07:06 riven dhcpcd[415]: eth0: removing interface
May 22 20:07:06 riven nilfs_cleanerd[182]: shutdown
May 22 20:07:06 riven systemd[1]: systemd-udevd.service holdoff time over, scheduling restart.
May 22 20:07:06 riven systemd[1]: Stopping udev Kernel Device Manager...
May 22 20:07:06 riven systemd[1]: Starting udev Kernel Device Manager...
May 22 20:07:06 riven systemd[1]: rpcbind.service: main process exited, code=exited, status=2/INVALIDARGUMENT
May 22 20:07:06 riven systemd[1]: Unit rpcbind.service entered failed state.
May 22 20:07:06 riven systemd[1]: systemd-logind.service holdoff time over, scheduling restart.
May 22 20:07:06 riven systemd[1]: Cannot add dependency job for unit lvm.service, ignoring: Unit lvm.service failed to load: No such file or directory. See system logs and 'systemctl status lvm.service' for details.
May 22 20:07:06 riven systemd[1]: Stopping Login Service...
May 22 20:07:06 riven systemd[1]: Starting Login Service...
May 22 20:07:06 riven systemd[1]: Started Trigger Flushing of Journal to Persistent Storage.
May 22 20:07:06 riven systemd[1]: Cannot add dependency job for unit lvm.service, ignoring: Unit lvm.service failed to load: No such file or directory. See system logs and 'systemctl status lvm.service' for details.
May 22 20:07:06 riven systemd[1]: dhcpcd-ET31U/T6GptTDjBF/Jpztg@public.gmane.org: main process exited, code=exited, status=1/FAILURE
May 22 20:07:06 riven systemd[1]: dhcpcd-ET31U/T6GptTDjBF/Jpztg@public.gmane.org: control process exited, code=exited status=1
May 22 20:07:06 riven systemd[1]: Unit dhcpcd-ET31U/T6GptTDjBF/Jpztg@public.gmane.org entered failed state.
May 22 20:07:06 riven dhcpcd[5022]: dhcpcd[5022]: dhcpcd not running
May 22 20:07:06 riven systemd[1]: Started Login Service.
May 22 20:07:06 riven systemd[1]: sshd.service holdoff time over, scheduling restart.
May 22 20:07:06 riven systemd[1]: Cannot add dependency job for unit lvm.service, ignoring: Unit lvm.service failed to load: No such file or directory. See system logs and 'systemctl status lvm.service' for details.
May 22 20:07:06 riven systemd[1]: Stopping OpenSSH Daemon...
May 22 20:07:06 riven systemd[1]: Started SSH Key Generation.
May 22 20:07:06 riven systemd[1]: Starting OpenSSH Daemon...
May 22 20:07:06 riven systemd[1]: Started OpenSSH Daemon.
May 22 20:07:06 riven systemd[1]: Cannot add dependency job for unit lvm.service, ignoring: Unit lvm.service failed to load: No such file or directory. See system logs and 'systemctl status lvm.service' for details.
May 22 20:07:06 riven systemd[1]: Starting System Logger Daemon...
May 22 20:07:06 riven systemd[1]: Started System Logger Daemon.
May 22 20:07:06 riven systemd[1]: cronie.service holdoff time over, scheduling restart.
May 22 20:07:06 riven systemd[1]: Cannot add dependency job for unit lvm.service, ignoring: Unit lvm.service failed to load: No such file or directory. See system logs and 'systemctl status lvm.service' for details.
May 22 20:07:06 riven systemd[1]: Started NFSv2/3 Network Status Monitor Daemon.
May 22 20:07:09 riven systemd[1]: sshd.service: main process exited, code=killed, status=9/KILL
May 22 20:07:09 riven systemd[1]: Unit sshd.service entered failed state.
May 22 20:07:09 riven systemd[1]: syslog-ng.service: main process exited, code=killed, status=9/KILL
May 22 20:07:09 riven systemd[1]: Unit syslog-ng.service entered failed state.
May 22 20:07:09 riven systemd[1]: systemd-journald.service: main process exited, code=killed, status=9/KILL
May 22 20:07:10 riven kernel: [ 8239.939532] SysRq : Kill All Tasks
May 22 20:07:10 riven [ 8239.942395] systemd[1]: Unit systemd-journald.service entered failed state.
May 22 20:07:10 riven [ 8239.943000] systemd[1]: systemd-udevd.service: main process exited, code=killed, status=9/KILL
May 22 20:07:10 riven [ 8239.943778] systemd[1]: Unit systemd-udevd.service entered failed state.
May 22 20:07:10 riven [ 8239.944266] systemd[1]: dbus.service: main process exited, code=killed, status=9/KILL
May 22 20:07:10 riven [ 8239.944989] systemd[1]: Unit dbus.service entered failed state.
May 22 20:07:10 riven [ 8239.945422] systemd[1]: cronie.service: main process exited, code=killed, status=9/KILL
May 22 20:07:10 riven [ 8239.946121] systemd[1]: Unit cronie.service entered failed state.
May 22 20:07:10 riven [ 8239.946582] systemd[1]: rpcbind.service: main process exited, code=killed, status=9/KILL
May 22 20:07:10 riven [ 8239.947427] systemd[1]: Unit rpcbind.service entered failed state.
May 22 20:07:10 riven rpc.statd[5056]: Version 1.2.8 starting
May 22 20:07:10 riven [ 8239.947857] systemd[1]: rpc-statd.service: main process exited, code=killed, status=9/KILL
May 22 20:07:10 riven [ 8239.948624] systemd[1]: Unit rpc-statd.service entered failed state.
May 22 20:07:10 riven [ 8239.949063] systemd[1]: getty-2yfe/R6NngVTDjBF/Jpztg@public.gmane.org holdoff time over, scheduling restart.
May 22 20:07:10 riven [ 8239.949661] systemd[1]: Cannot add dependency job for unit lvm.service, ignoring: Unit lvm.service failed to load: No such file or directory. See system logs and 'systemctl status lvm.service' for details.
May 22 20:07:10 riven [ 8239.950658] systemd[1]: Stopping Getty on tty1...
May 22 20:07:10 riven [ 8239.951036] systemd[1]: Starting Getty on tty1...
May 22 20:07:10 riven [ 8239.951991] systemd[1]: Started Getty on tty1.
May 22 20:07:10 riven [ 8239.952501] systemd[1]: systemd-journald.service holdoff time over, scheduling restart.
May 22 20:07:10 riven [ 8239.953037] systemd[1]: Stopping Journal Service...
May 22 20:07:10 riven [ 8239.961433] systemd[1]: Starting Journal Service...
May 22 20:07:10 riven [ 8239.970154] systemd[1]: Started Journal Service.
May 22 20:07:10 riven [ 8239.978363] systemd[1]: Starting Trigger Flushing of Journal to Persistent Storage...
May 22 20:07:10 riven [ 8239.994267] systemd[1]: systemd-udevd.service holdoff time over, scheduling restart.
May 22 20:07:10 riven [ 8240.009916] systemd[1]: Stopping udev Kernel Device Manager...
May 22 20:07:10 riven [ 8240.012250] systemd-journald[5047]: File /var/log/journal/5b2137919d6f4039a3b2c2f21333daa6/system.journal corrupted or uncleanly shut down, renaming and replacing.
May 22 20:07:10 riven [ 8240.041143] systemd[1]: Starting udev Kernel Device Manager...
May 22 20:07:10 riven [ 8240.050383] systemd[1]: ntpd.service: main process exited, code=killed, status=9/KILL
May 22 20:07:10 riven [ 8240.053378] systemd-udevd[5049]: starting version 204
May 22 20:07:10 riven [ 8240.074818] systemd[1]: Unit ntpd.service entered failed state.
May 22 20:07:10 riven [ 8240.082734] systemd[1]: sshd.service holdoff time over, scheduling restart.
May 22 20:07:10 riven [ 8240.090582] systemd[1]: Cannot add dependency job for unit lvm.service, ignoring: Unit lvm.service failed to load: No such file or directory. See system logs and 'systemctl status lvm.service' for details.
May 22 20:07:10 riven [ 8240.115806] systemd[1]: Stopping OpenSSH Daemon...
May 22 20:07:10 riven [ 8240.122627] systemd[1]: Started SSH Key Generation.
May 22 20:07:10 riven [ 8240.129163] systemd[1]: Starting OpenSSH Daemon...
May 22 20:07:10 riven [ 8240.136086] systemd[1]: Started OpenSSH Daemon.
May 22 20:07:10 riven [ 8240.142750] systemd[1]: cronie.service holdoff time over, scheduling restart.
May 22 20:07:10 riven [ 8240.149212] systemd[1]: Cannot add dependency job for unit lvm.service, ignoring: Unit lvm.service failed to load: No such file or directory. See system logs and 'systemctl status lvm.service' for details.
May 22 20:07:10 riven [ 8240.169042] systemd[1]: Stopping Periodic Command Scheduler...
May 22 20:07:10 riven [ 8240.175785] systemd[1]: Starting Periodic Command Scheduler...
May 22 20:07:10 riven [ 8240.182815] systemd[1]: Started Periodic Command Scheduler.
May 22 20:07:10 riven [ 8240.189721] systemd[1]: rpcbind.service holdoff time over, scheduling restart.
May 22 20:07:10 riven [ 8240.203185] systemd[1]: Cannot add dependency job for unit lvm.service, ignoring: Unit lvm.service failed to load: No such file or directory. See system logs and 'systemctl status lvm.service' for details.
May 22 20:07:10 riven [ 8240.223731] systemd[1]: Stopping RPC Bind...
May 22 20:07:10 riven [ 8240.230514] systemd[1]: Starting RPC Bind...
May 22 20:07:10 riven [ 8240.237587] systemd[1]: Started udev Kernel Device Manager.
May 22 20:07:10 riven [ 8240.244349] systemd[1]: systemd-logind.service: main process exited, code=killed, status=9/KILL
May 22 20:07:10 riven [ 8240.257182] systemd[1]: Unit systemd-logind.service entered failed state.
May 22 20:07:10 riven [ 8240.263939] systemd[1]: Started RPC Bind.
May 22 20:07:10 riven [ 8240.270314] systemd[1]: Starting NFSv2/3 Network Status Monitor Daemon...
May 22 20:07:10 riven [ 8240.277481] systemd[1]: Cannot add dependency job for unit lvm.service, ignoring: Unit lvm.service failed to load: No such file or directory. See system logs and 'systemctl status lvm.service' for details.
May 22 20:07:10 riven [ 8240.297612] systemd[1]: Starting System Logger Daemon...
May 22 20:07:10 riven [ 8240.304684] systemd[1]: Started System Logger Daemon.
May 22 20:07:10 riven [ 8240.311549] systemd[1]: ntpd.service holdoff time over, scheduling restart.
May 22 20:07:10 riven [ 8240.318164] systemd[1]: Cannot add dependency job for unit lvm.service, ignoring: Unit lvm.service failed to load: No such file or directory. See system logs and 'systemctl status lvm.service' for details.
May 22 20:07:10 riven [ 8240.338387] systemd[1]: Stopping Network Time Service...
May 22 20:07:10 riven [ 8240.345345] systemd[1]: Starting Network Time Service...
May 22 20:07:10 riven ntpd[5059]: ntpd 4.2.6p5@1.2349-o Mon May  6 10:20:10 UTC 2013 (1)
May 22 20:07:10 riven ntpd[5060]: proto: precision = 0.558 usec
May 22 20:07:10 riven ntpd[5060]: Listen and drop on 0 v4wildcard 0.0.0.0 UDP 123
May 22 20:07:10 riven ntpd[5060]: Listen and drop on 1 v6wildcard :: UDP 123
May 22 20:07:10 riven ntpd[5060]: Listen normally on 2 lo 127.0.0.1 UDP 123
May 22 20:07:10 riven ntpd[5060]: Listen normally on 3 lo ::1 UDP 123
May 22 20:07:10 riven ntpd[5060]: Listen normally on 4 eth0 fe80::21f:d0ff:fe26:7491 UDP 123
May 22 20:07:10 riven ntpd[5060]: peers refreshed
May 22 20:07:10 riven ntpd[5060]: Listening on routing socket on fd #21 for interface updates
May 22 20:07:10 riven ntpd[5060]: Deferring DNS for 0.pool.ntp.org 1
May 22 20:07:10 riven [ 8240.352774] systemd[1]: Started NFSv2/3 Network Status Monitor Daemon.
May 22 20:07:10 riven ntpd[5060]: Deferring DNS for 1.pool.ntp.org 1
May 22 20:07:10 riven ntpd[5060]: Deferring DNS for 2.pool.ntp.org 1
May 22 20:07:10 riven [ 8240.360274] systemd[1]: Started Network Time Service.
May 22 20:07:10 riven [ 8240.366831] systemd[1]: systemd-logind.service holdoff time over, scheduling restart.
May 22 20:07:10 riven [ 8240.379809] systemd[1]: Cannot add dependency job for unit lvm.service, ignoring: Unit lvm.service failed to load: No such file or directory. See system logs and 'systemctl status lvm.service' for details.
May 22 20:07:10 riven [ 8240.400281] systemd[1]: Stopping Login Service...
May 22 20:07:10 riven [ 8240.407082] systemd[1]: Starting Login Service...
May 22 20:07:10 riven [ 8240.416399] systemd[1]: Started Trigger Flushing of Journal to Persistent Storage.
May 22 20:07:10 riven [ 8240.430330] systemd[1]: Cannot add dependency job for unit lvm.service, ignoring: Unit lvm.service failed to load: No such file or directory. See system logs and 'systemctl status lvm.service' for details.
May 22 20:07:10 riven [ 8240.451224] systemd[1]: Starting D-Bus System Message Bus...
May 22 20:07:10 riven [ 8240.458934] systemd[1]: Started D-Bus System Message Bus.
May 22 20:07:10 riven systemd[1]: Started Login Service.
May 22 20:07:12 riven kernel: [ 8242.947507] SysRq : Emergency Sync
May 22 20:07:14 riven kernel: [ 8244.899488] SysRq : Emergency Remount R/O
May 22 20:08:06 riven systemd-sysctl[148]: Duplicate assignment of kernel/sysrq in file '/usr/lib/sysctl.d/50-default.conf', ignoring.
May 22 20:08:06 riven systemd[1]: Mounting Arbitrary Executable File Formats File System...
May 22 20:08:06 riven systemd[1]: Mounted Debug File System.
May 22 20:08:06 riven systemd[1]: Mounted POSIX Message Queue File System.
May 22 20:08:06 riven systemd[1]: Mounted Huge Pages File System.
May 22 20:08:06 riven systemd[1]: Started udev Kernel Device Manager.
May 22 20:08:06 riven systemd[1]: Mounted Arbitrary Executable File Formats File System.
May 22 20:08:06 riven systemd[1]: Started Set Up Additional Binary Formats.
May 22 20:08:06 riven systemd-fsck[161]: Ignoring error.
May 22 20:08:07 riven kernel: [    0.000000] Initializing cgroup subsys cpuset
May 22 20:08:07 riven kernel: [    0.000000] Initializing cgroup subsys cpu
May 22 20:08:07 riven kernel: [    0.000000] Linux version 3.9.3-1-ARCH (tobias@T-POWA-LX) (gcc version 4.8.0 20130502 (prerelease) (GCC) ) #1 SMP PREEMPT Sun May 19 22:50:29 CEST 2013
May 22 20:08:07 riven kernel: [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-linux root=/dev/mapper/riven-arch ro quiet
May 22 20:08:07 riven kernel: [    0.000000] e820: BIOS-provided physical RAM map:
May 22 20:08:07 riven kernel: [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009e7ff] usable
May 22 20:08:07 riven kernel: [    0.000000] BIOS-e820: [mem 0x000000000009f800-0x000000000009ffff] reserved
May 22 20:08:07 riven kernel: [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
May 22 20:08:07 riven kernel: [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cfeaffff] usable
May 22 20:08:07 riven kernel: [    0.000000] BIOS-e820: [mem 0x00000000cfeb0000-0x00000000cfee2fff] ACPI NVS
May 22 20:08:06 riven systemd[1]: Started File System Check on Root Device.
May 22 20:08:07 riven systemd[1]: Reached target Sockets.
May 22 20:08:07 riven kernel: [    0.000000] BIOS-e820: [mem 0x00000000cfee3000-0x00000000cfeeffff] ACPI data
May 22 20:08:07 riven kernel: [    0.000000] BIOS-e820: [mem 0x00000000cfef0000-0x00000000cfefffff] reserved
May 22 20:08:07 riven kernel: [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000e3ffffff] reserved
May 22 20:08:07 riven kernel: [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff] reserved
May 22 20:08:07 riven kernel: [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000001afffffff] usable
May 22 20:08:07 riven kernel: [    0.000000] NX (Execute Disable) protection: active
May 22 20:08:07 riven kernel: [    0.000000] SMBIOS 2.4 present.
May 22 20:08:07 riven dhcpcd[274]: eth0: waiting for carrier
May 22 20:08:07 riven kernel: [    0.000000] No AGP bridge found
May 22 20:08:07 riven kernel: [    0.000000] e820: last_pfn = 0x1b0000 max_arch_pfn = 0x400000000
May 22 20:08:07 riven kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
May 22 20:08:07 riven kernel: [    0.000000] e820: last_pfn = 0xcfeb0 max_arch_pfn = 0x400000000
May 22 20:08:07 riven kernel: [    0.000000] found SMP MP-table at [mem 0x000f58e0-0x000f58ef] mapped at [ffff8800000f58e0]
May 22 20:08:07 riven kernel: [    0.000000] Scanning 1 areas for low memory corruption
May 22 20:08:07 riven kernel: [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
May 22 20:08:07 riven kernel: [    0.000000] init_memory_mapping: [mem 0x1afe00000-0x1afffffff]
May 22 20:08:07 riven kernel: [    0.000000] init_memory_mapping: [mem 0x1ac000000-0x1afdfffff]
May 22 20:08:07 riven kernel: [    0.000000] init_memory_mapping: [mem 0x180000000-0x1abffffff]
May 22 20:08:07 riven kernel: [    0.000000] init_memory_mapping: [mem 0x00100000-0xcfeaffff]
May 22 20:08:07 riven kernel: [    0.000000] init_memory_mapping: [mem 0x100000000-0x17fffffff]
May 22 20:08:07 riven kernel: [    0.000000] RAMDISK: [mem 0x37ae4000-0x37d69fff]
May 22 20:08:07 riven kernel: [    0.000000] ACPI: RSDP 00000000000f7710 00014 (v00 GBT   )
May 22 20:08:07 riven kernel: [    0.000000] ACPI: RSDT 00000000cfee3040 00034 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
May 22 20:08:07 riven kernel: [    0.000000] ACPI: FACP 00000000cfee30c0 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
May 22 20:08:07 riven kernel: [    0.000000] ACPI: DSDT 00000000cfee3180 03C78 (v01 GBT    GBTUACPI 00001000 MSFT 0100000C)
May 22 20:08:07 riven kernel: [    0.000000] ACPI: FACS 00000000cfeb0000 00040
May 22 20:08:07 riven kernel: [    0.000000] ACPI: MCFG 00000000cfee6fc0 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
May 22 20:08:07 riven kernel: [    0.000000] ACPI: APIC 00000000cfee6e40 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
May 22 20:08:07 riven kernel: [    0.000000] ACPI: SSDT 00000000cfee79a0 003AB (v01  PmRef    CpuPm 00003000 INTL 20040311)
May 22 20:08:07 riven kernel: [    0.000000] No NUMA configuration found
May 22 20:08:07 riven kernel: [    0.000000] Faking a node at [mem 0x0000000000000000-0x00000001afffffff]
May 22 20:08:07 riven kernel: [    0.000000] Initmem setup node 0 [mem 0x00000000-0x1afffffff]
May 22 20:08:07 riven kernel: [    0.000000]   NODE_DATA [mem 0x1afff6000-0x1afffafff]
May 22 20:08:07 riven kernel: [    0.000000] Zone ranges:
May 22 20:08:07 riven kernel: [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
May 22 20:08:07 riven kernel: [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
May 22 20:08:07 riven kernel: [    0.000000]   Normal   [mem 0x100000000-0x1afffffff]
May 22 20:08:07 riven kernel: [    0.000000] Movable zone start for each node
May 22 20:08:07 riven kernel: [    0.000000] Early memory node ranges
May 22 20:08:07 riven kernel: [    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
May 22 20:08:07 riven kernel: [    0.000000]   node   0: [mem 0x00100000-0xcfeaffff]
May 22 20:08:07 riven kernel: [    0.000000]   node   0: [mem 0x100000000-0x1afffffff]
May 22 20:08:07 riven kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x408
May 22 20:08:07 riven kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
May 22 20:08:07 riven kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x03] enabled)
May 22 20:08:07 riven kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
May 22 20:08:07 riven kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
May 22 20:08:07 riven kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
May 22 20:08:07 riven kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
May 22 20:08:07 riven kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
May 22 20:08:07 riven kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
May 22 20:08:07 riven kernel: [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
May 22 20:08:07 riven kernel: [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
May 22 20:08:07 riven kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
May 22 20:08:07 riven kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
May 22 20:08:07 riven kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
May 22 20:08:07 riven kernel: [    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
May 22 20:08:07 riven kernel: [    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
May 22 20:08:07 riven kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
May 22 20:08:07 riven kernel: [    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
May 22 20:08:07 riven kernel: [    0.000000] PM: Registered nosave memory: 00000000cfeb0000 - 00000000cfee3000
May 22 20:08:07 riven kernel: [    0.000000] PM: Registered nosave memory: 00000000cfee3000 - 00000000cfef0000
May 22 20:08:07 riven kernel: [    0.000000] PM: Registered nosave memory: 00000000cfef0000 - 00000000cff00000
May 22 20:08:07 riven kernel: [    0.000000] PM: Registered nosave memory: 00000000cff00000 - 00000000e0000000
May 22 20:08:07 riven kernel: [    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000e4000000
May 22 20:08:07 riven kernel: [    0.000000] PM: Registered nosave memory: 00000000e4000000 - 00000000fec00000
May 22 20:08:07 riven kernel: [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
May 22 20:08:07 riven kernel: [    0.000000] e820: [mem 0xe4000000-0xfebfffff] available for PCI devices
May 22 20:08:07 riven kernel: [    0.000000] Booting paravirtualized kernel on bare hardware
May 22 20:08:07 riven kernel: [    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
May 22 20:08:07 riven kernel: [    0.000000] PERCPU: Embedded 28 pages/cpu @ffff8801afc00000 s85824 r8192 d20672 u524288
May 22 20:08:07 riven kernel: [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1547837
May 22 20:08:07 riven kernel: [    0.000000] Policy zone: Normal
May 22 20:08:07 riven kernel: [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-linux root=/dev/mapper/riven-arch ro quiet
May 22 20:08:07 riven kernel: [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
May 22 20:08:07 riven kernel: [    0.000000] __ex_table already sorted, skipping sort
May 22 20:08:07 riven kernel: [    0.000000] Checking aperture...
May 22 20:08:07 riven kernel: [    0.000000] No AGP bridge found
May 22 20:08:07 riven kernel: [    0.000000] Memory: 6110480k/7077888k available (4983k kernel code, 788172k absent, 179236k reserved, 3967k data, 1092k init)
May 22 20:08:07 riven kernel: [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
May 22 20:08:07 riven kernel: [    0.000000] Preemptible hierarchical RCU implementation.
May 22 20:08:07 riven kernel: [    0.000000]    RCU dyntick-idle grace-period acceleration is enabled.
May 22 20:08:07 riven kernel: [    0.000000]    Dump stacks of tasks blocking RCU-preempt GP.


--------------050203010306040108050707--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
