From: Kristjan Eerik Kaseniit <kristjan.eerik.kaseniit-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Root file system has filled up, won't boot anymore
Date: Mon, 22 Jun 2009 13:39:38 +0300
Message-ID: <172291b30906220339k628005hc2560a454b89c@mail.gmail.com>
References: <172291b30906210922i2089a389jbc9b664e6b9d7c00@mail.gmail.com>
	<20090622.034847.62046349.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090622.034847.62046349.ryusuke-sG5X7nlA6pw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

2009/6/21 Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
>
> Is there nilfs_cleanerd process? =A0If it does not exist, please invoke
> it by hand:
>
> =A0# nilfs_cleanerd /dev/sdb1
>
> The cleanerd process may not start working until protection_period
> elapses. =A0The protection period is set in /etc/nilfs_cleanerd.conf, so
> you cannot rewrite it under disk full condition. =A0I'm considering to
> add a new option which specifies the protecion period to help recovery
> from this kind of stuck.
>

Thanks for replying!

This far:
vstr ~ # ps aux | grep nilfs_cleanerd
vstr ~ # cat /etc/nilfs_cleanerd.conf | grep protection_period
protection_period    600
vstr ~ # lscp
                 CNO        DATE     TIME  MODE  FLG   NBLKINC       ICNT
               18159  2009-06-19 18:04:28   cp    -      37700     286576
               18160  2009-06-19 18:04:29   cp    -         42     286577
.........................
               19181  2009-06-19 19:32:04   cp    i       6621     291515
               19182  2009-06-19 19:32:09   cp    -       6562     291515
lscp: Input/output error
vstr ~ # nilfs_cleanerd /dev/mmcblk0p1
vstr ~ # ps aux | grep nilfs_cleanerd
vstr ~ # dmesg | tail
[14774.675905] attempt to access beyond end of device
[14774.675911] mmcblk0p1: rw=3D0, want=3D10987108611918676376, limit=3D3209=
7807
[14774.675915] attempt to access beyond end of device
[14774.675918] mmcblk0p1: rw=3D2, want=3D6289936748060867064, limit=3D32097=
807

As you can see, the protection_period has passed a long time ago and
that the cleanerd won't start but produces errors.

>
> Please post the first BUG message if you can get it. =A0It may be
> helpful to analyze the unknown problem.
>

kernel BUG at fs/nilfs/btree.c:496!
invalid opcode: 0000 [#1] SMP
last sysfs file:
CPU 0
Modules linked in:
Pid: 952, comm: rc Not tainted 2.6.30-gentoo-r1 #1 Vostro 1400
RIP: 0010:[<ffffffff81194348>] [<ffffffff81194348>]
nilfs_btree_do_lookup+0xc0/0x192
.......
Call trace:
nilfs_btree_lookup
nilfs_bmap_lookup_at_level
nilfs_bmap_lookup
nilfs_mdt_submit_block
nilfs_mdt_read_block
nilfs_mdt_get_block
selinux_inode_alloc_security
nilfs_palloc_gent_entry_block
__down_read
nilfs_ifile_get_inode_block
nilfs_iget
nilfs_lookup
do_lookup
__link_path_walk
path_walk
do_path_lookup
user_path_at
mntput_no_expire
cp_new_stat
vfs_fstatat
vfs_stat
sys_newstat
system_call_fastpath
Code: ....
RIP [<ffffffff81194348>] nilfs_btree_do_lookup+0xc0/0x192
