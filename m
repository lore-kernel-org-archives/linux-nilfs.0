From: Gergely =?UTF-8?B?R8OhYm9y?= <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Deadlocks! help, please!
Date: Thu, 17 Jan 2008 20:10:46 +0100
Message-ID: <20080117201046.046f5a55@vosztok>
References: <20080116222500.60e78090@vosztok>
	<1200556717.3085.94.camel@localhost.localdomain>
	<1200561294.3085.131.camel@localhost.localdomain>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0075233366=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:date:from:to:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
	bh=wmNlHvePVWhKQsfwSmdjWq7TgydFMIq+IUsDXB71wD4=;
	b=V1CmtfuMwKDnB3u1Vacja/834Z6rAAV2LYjnhlgl/u2dc+AZ6OefjFVwSp3AMvwoXx0+HAwPkQXe0bEfV65wVVYYuy3C766fJ6FL1RjLYpDmfoIk7TGGGoHcjmR3jpCIDJiVkBxe91R2gzY0yLqXjdwP7hFgiDHbxQqgD8OkCLQ=
In-Reply-To: <1200561294.3085.131.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

--===============0075233366==
Content-Type: multipart/signed; boundary="Sig_/.0q5G/=kZThIJL+bzpyrMvi";
	protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_/.0q5G/=kZThIJL+bzpyrMvi
Content-Type: multipart/mixed; boundary="MP_/+=O.r0VQ+xJ8MPnHGom_eMy"

--MP_/+=O.r0VQ+xJ8MPnHGom_eMy
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thu, 17 Jan 2008 18:14:54 +0900
Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:

one more log, as some new lockups happenned
--=20
Gergely G=C3=A1bor <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

* random fortune:
Creditor, n.:
	A man who has a better memory than a debtor.

--MP_/+=O.r0VQ+xJ8MPnHGom_eMy
Content-Type: text/x-log; name=kern.log
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=kern.log

Jan 17 16:47:02 vosztok kernel: klogd 1.4.1, log source =3D /proc/kmsg star=
ted.
Jan 17 16:47:02 vosztok kernel: Inspecting /boot/System.map
Jan 17 16:47:02 vosztok kernel: Loaded 28989 symbols from /boot/System.map.
Jan 17 16:47:02 vosztok kernel: Symbols match kernel version 2.6.23.
Jan 17 16:47:37 vosztok kernel: fbcondecor: console 0 using theme 'livecd-2=
006.1'
Jan 17 16:47:37 vosztok kernel: fbcondecor: switched decor state to 'on' on=
 console 0
Jan 17 18:00:14 vosztok kernel: fbcondecor: console 0 using theme 'livecd-2=
006.1'
Jan 17 18:00:14 vosztok kernel: fbcondecor: switched decor state to 'on' on=
 console 0
Jan 17 18:09:01 vosztok kernel: gs+0x13b/0x15c [nilfs2]
Jan 17 18:09:01 vosztok kernel:  [__do_page_cache_readahead+391/578] __do_p=
age_cache_readahead+0x187/0x242
Jan 17 18:09:01 vosztok kernel:  [<c0141196>] __do_page_cache_readahead+0x1=
87/0x242
Jan 17 18:09:01 vosztok kernel:  [<e091c658>] nilfs_get_block+0x0/0x1de [ni=
lfs2]
Jan 17 18:09:01 vosztok kernel:  [n_tty_receive_buf+3376/3451] n_tty_receiv=
e_buf+0xd30/0xd7b
Jan 17 18:09:01 vosztok kernel:  [<c02507f5>] n_tty_receive_buf+0xd30/0xd7b
Jan 17 18:09:01 vosztok kernel:  [filldir64+0/197] filldir64+0x0/0xc5
Jan 17 18:09:01 vosztok kernel:  [<c0161e60>] filldir64+0x0/0xc5
Jan 17 18:09:01 vosztok kernel:  [do_page_cache_readahead+73/83] do_page_ca=
che_readahead+0x49/0x53
Jan 17 18:09:01 vosztok kernel:  [<c0141556>] do_page_cache_readahead+0x49/=
0x53
Jan 17 18:09:01 vosztok kernel:  [filemap_fault+435/969] filemap_fault+0x1b=
3/0x3c9
Jan 17 18:09:01 vosztok kernel:  [<c013d873>] filemap_fault+0x1b3/0x3c9
Jan 17 18:09:01 vosztok kernel:  [__do_fault+80/773] __do_fault+0x50/0x305
Jan 17 18:09:01 vosztok kernel:  [<c0145089>] __do_fault+0x50/0x305
Jan 17 18:09:01 vosztok kernel:  [update_curr_load+110/131] update_curr_loa=
d+0x6e/0x83
Jan 17 18:09:01 vosztok kernel:  [<c011395f>] update_curr_load+0x6e/0x83
Jan 17 18:09:01 vosztok kernel:  [handle_mm_fault+731/1528] handle_mm_fault=
+0x2db/0x5f8
Jan 17 18:09:01 vosztok kernel:  [<c014683a>] handle_mm_fault+0x2db/0x5f8
Jan 17 18:09:01 vosztok kernel:  [do_page_fault+530/1439] do_page_fault+0x2=
12/0x59f
Jan 17 18:09:01 vosztok kernel:  [<c01125f3>] do_page_fault+0x212/0x59f
Jan 17 18:09:01 vosztok kernel:  [sys_recv+55/59] sys_recv+0x37/0x3b
Jan 17 18:09:01 vosztok kernel:  [<c02efd64>] sys_recv+0x37/0x3b
Jan 17 18:09:01 vosztok kernel:  [do_page_fault+0/1439] do_page_fault+0x0/0=
x59f
Jan 17 18:09:01 vosztok kernel:  [<c01123e1>] do_page_fault+0x0/0x59f
Jan 17 18:09:01 vosztok kernel:  [error_code+106/112] error_code+0x6a/0x70
Jan 17 18:09:01 vosztok kernel:  [<c036d93a>] error_code+0x6a/0x70
Jan 17 18:09:01 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:01 vosztok kernel: dhcpcd        S 00000000     0 10822      1
Jan 17 18:09:01 vosztok kernel:        cc5b1b60 00000086 cc57e144 00000000 =
ccb9ee00 00000286 008e2c59 cc5b1b70=20
Jan 17 18:09:01 vosztok kernel:        00000006 00000020 c036c924 c0127a58 =
cd19e000 c0489488 c0489488 008e2c59=20
Jan 17 18:09:01 vosztok kernel:        c011efb9 cc57e000 c04888c0 00000000 =
cc5b1f9c c0162a11 cc5b1f9c cc5b1f48=20
Jan 17 18:09:01 vosztok kernel: Call Trace:
Jan 17 18:09:01 vosztok kernel:  [schedule_timeout+120/149] schedule_timeou=
t+0x78/0x95
Jan 17 18:09:01 vosztok kernel:  [<c036c924>] schedule_timeout+0x78/0x95
Jan 17 18:09:01 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 18:09:01 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 18:09:01 vosztok kernel:  [process_timeout+0/5] process_timeout+0x0/=
0x5
Jan 17 18:09:01 vosztok kernel:  [<c011efb9>] process_timeout+0x0/0x5
Jan 17 18:09:01 vosztok kernel:  [do_select+916/993] do_select+0x394/0x3e1
Jan 17 18:09:01 vosztok kernel:  [<c0162a11>] do_select+0x394/0x3e1
Jan 17 18:09:01 vosztok kernel:  [__pollwait+0/169] __pollwait+0x0/0xa9
Jan 17 18:09:01 vosztok kernel:  [<c0162f31>] __pollwait+0x0/0xa9
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [_xfs_buf_lookup_pages+571/611] _xfs_buf_l=
ookup_pages+0x23b/0x263
Jan 17 18:09:01 vosztok kernel:  [<c021ede2>] _xfs_buf_lookup_pages+0x23b/0=
x263
Jan 17 18:09:01 vosztok kernel:  [xfs_da_brelse+107/143] xfs_da_brelse+0x6b=
/0x8f
Jan 17 18:09:01 vosztok kernel:  [<c01e8c5c>] xfs_da_brelse+0x6b/0x8f
Jan 17 18:09:01 vosztok kernel:  [xfs_dir2_leaf_lookup_int+513/533] xfs_dir=
2_leaf_lookup_int+0x201/0x215
Jan 17 18:09:01 vosztok kernel:  [<c01eee35>] xfs_dir2_leaf_lookup_int+0x20=
1/0x215
Jan 17 18:09:01 vosztok kernel:  [xfs_dir2_leaf_lookup+30/146] xfs_dir2_lea=
f_lookup+0x1e/0x92
Jan 17 18:09:01 vosztok kernel:  [<c01eefec>] xfs_dir2_leaf_lookup+0x1e/0x92
Jan 17 18:09:01 vosztok kernel:  [xfs_dir_lookup+191/235] xfs_dir_lookup+0x=
bf/0xeb
Jan 17 18:09:01 vosztok kernel:  [<c01ec31e>] xfs_dir_lookup+0xbf/0xeb
Jan 17 18:09:01 vosztok kernel:  [xfs_inode_item_unlock+32/127] xfs_inode_i=
tem_unlock+0x20/0x7f
Jan 17 18:09:01 vosztok kernel:  [<c02005e2>] xfs_inode_item_unlock+0x20/0x=
7f
Jan 17 18:09:01 vosztok kernel:  [xfs_dir_lookup_int+44/212] xfs_dir_lookup=
_int+0x2c/0xd4
Jan 17 18:09:01 vosztok kernel:  [<c0212d20>] xfs_dir_lookup_int+0x2c/0xd4
Jan 17 18:09:01 vosztok kernel:  [xfs_trans_tail_ail+48/74] xfs_trans_tail_=
ail+0x30/0x4a
Jan 17 18:09:01 vosztok kernel:  [<c02116cf>] xfs_trans_tail_ail+0x30/0x4a
Jan 17 18:09:01 vosztok kernel:  [xfs_iunlock+81/109] xfs_iunlock+0x51/0x6d
Jan 17 18:09:01 vosztok kernel:  [<c01fa6b2>] xfs_iunlock+0x51/0x6d
Jan 17 18:09:01 vosztok kernel:  [xfs_lookup+110/120] xfs_lookup+0x6e/0x78
Jan 17 18:09:01 vosztok kernel:  [<c0215b1d>] xfs_lookup+0x6e/0x78
Jan 17 18:09:01 vosztok kernel:  [__d_lookup+288/317] __d_lookup+0x120/0x13d
Jan 17 18:09:01 vosztok kernel:  [<c01668d3>] __d_lookup+0x120/0x13d
Jan 17 18:09:01 vosztok kernel:  [d_rehash+69/91] d_rehash+0x45/0x5b
Jan 17 18:09:01 vosztok kernel:  [<c0165ca1>] d_rehash+0x45/0x5b
Jan 17 18:09:01 vosztok kernel:  [xfs_vn_lookup+88/112] xfs_vn_lookup+0x58/=
0x70
Jan 17 18:09:01 vosztok kernel:  [<c022227f>] xfs_vn_lookup+0x58/0x70
Jan 17 18:09:01 vosztok kernel:  [do_lookup+79/320] do_lookup+0x4f/0x140
Jan 17 18:09:01 vosztok kernel:  [<c015df2a>] do_lookup+0x4f/0x140
Jan 17 18:09:01 vosztok kernel:  [_atomic_dec_and_lock+37/64] _atomic_dec_a=
nd_lock+0x25/0x40
Jan 17 18:09:01 vosztok kernel:  [<c02390e9>] _atomic_dec_and_lock+0x25/0x40
Jan 17 18:09:01 vosztok kernel:  [mntput_no_expire+17/133] mntput_no_expire=
+0x11/0x85
Jan 17 18:09:01 vosztok kernel:  [<c016a3e5>] mntput_no_expire+0x11/0x85
Jan 17 18:09:01 vosztok kernel:  [__link_path_walk+3042/3072] __link_path_w=
alk+0xbe2/0xc00
Jan 17 18:09:01 vosztok kernel:  [<c015fbe7>] __link_path_walk+0xbe2/0xc00
Jan 17 18:09:01 vosztok kernel:  [core_sys_select+682/711] core_sys_select+=
0x2aa/0x2c7
Jan 17 18:09:01 vosztok kernel:  [<c0162d08>] core_sys_select+0x2aa/0x2c7
Jan 17 18:09:01 vosztok kernel:  [link_path_walk+165/175] link_path_walk+0x=
a5/0xaf
Jan 17 18:09:01 vosztok kernel:  [<c015fcaa>] link_path_walk+0xa5/0xaf
Jan 17 18:09:01 vosztok kernel:  [quicklist_trim+189/222] quicklist_trim+0x=
bd/0xde
Jan 17 18:09:01 vosztok kernel:  [<c0155dff>] quicklist_trim+0xbd/0xde
Jan 17 18:09:01 vosztok kernel:  [pgd_dtor+0/86] pgd_dtor+0x0/0x56
Jan 17 18:09:01 vosztok kernel:  [<c0111d75>] pgd_dtor+0x0/0x56
Jan 17 18:09:01 vosztok kernel:  [check_pgt_cache+27/29] check_pgt_cache+0x=
1b/0x1d
Jan 17 18:09:01 vosztok kernel:  [<c0111c24>] check_pgt_cache+0x1b/0x1d
Jan 17 18:09:01 vosztok kernel:  [__user_walk_fd+61/69] __user_walk_fd+0x3d=
/0x45
Jan 17 18:09:01 vosztok kernel:  [<c0160784>] __user_walk_fd+0x3d/0x45
Jan 17 18:09:01 vosztok kernel:  [vfs_stat_fd+25/64] vfs_stat_fd+0x19/0x40
Jan 17 18:09:01 vosztok kernel:  [<c015a5ec>] vfs_stat_fd+0x19/0x40
Jan 17 18:09:01 vosztok kernel:  [quicklist_trim+189/222] quicklist_trim+0x=
bd/0xde
Jan 17 18:09:01 vosztok kernel:  [<c0155dff>] quicklist_trim+0xbd/0xde
Jan 17 18:09:01 vosztok kernel:  [pgd_dtor+0/86] pgd_dtor+0x0/0x56
Jan 17 18:09:01 vosztok kernel:  [<c0111d75>] pgd_dtor+0x0/0x56
Jan 17 18:09:01 vosztok kernel:  [getnstimeofday+43/172] getnstimeofday+0x2=
b/0xac
Jan 17 18:09:01 vosztok kernel:  [<c012b8f3>] getnstimeofday+0x2b/0xac
Jan 17 18:09:01 vosztok kernel:  [si_swapinfo+87/113] si_swapinfo+0x57/0x71
Jan 17 18:09:01 vosztok kernel:  [<c014f1d3>] si_swapinfo+0x57/0x71
Jan 17 18:09:01 vosztok kernel:  [sys_select+160/391] sys_select+0xa0/0x187
Jan 17 18:09:01 vosztok kernel:  [<c016307a>] sys_select+0xa0/0x187
Jan 17 18:09:01 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:01 vosztok kernel: sshd          S 00001000     0 10889   9743
Jan 17 18:09:01 vosztok kernel:        cc373dd8 00000082 ce4fcbc4 00001000 =
d4fadc40 00000400 00000000 7fffffff=20
Jan 17 18:09:01 vosztok kernel:        cc373e4c cdb14600 c036c8bf 000042f8 =
cc373e08 c01136df 0000cc1c 00000001=20
Jan 17 18:09:01 vosztok kernel:        c01279b8 00000000 00000000 00000000 =
00000000 c0342e74 cc373e3e cc373eff=20
Jan 17 18:09:01 vosztok kernel: Call Trace:
Jan 17 18:09:01 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 18:09:01 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 18:09:01 vosztok kernel:  [update_stats_wait_end+155/190] update_sta=
ts_wait_end+0x9b/0xbe
Jan 17 18:09:01 vosztok kernel:  [<c01136df>] update_stats_wait_end+0x9b/0x=
be
Jan 17 18:09:01 vosztok kernel:  [prepare_to_wait+74/102] prepare_to_wait+0=
x4a/0x66
Jan 17 18:09:01 vosztok kernel:  [<c01279b8>] prepare_to_wait+0x4a/0x66
Jan 17 18:09:01 vosztok kernel:  [unix_stream_recvmsg+521/1218] unix_stream=
_recvmsg+0x209/0x4c2
Jan 17 18:09:01 vosztok kernel:  [<c0342e74>] unix_stream_recvmsg+0x209/0x4=
c2
Jan 17 18:09:01 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 18:09:01 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 18:09:01 vosztok kernel:  [sock_aio_read+193/205] sock_aio_read+0xc1=
/0xcd
Jan 17 18:09:01 vosztok kernel:  [<c02ee670>] sock_aio_read+0xc1/0xcd
Jan 17 18:09:01 vosztok kernel:  [do_sync_read+198/265] do_sync_read+0xc6/0=
x109
Jan 17 18:09:01 vosztok kernel:  [<c01576e6>] do_sync_read+0xc6/0x109
Jan 17 18:09:01 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 18:09:01 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 18:09:01 vosztok kernel:  [do_page_fault+616/1439] do_page_fault+0x2=
68/0x59f
Jan 17 18:09:01 vosztok kernel:  [<c0112649>] do_page_fault+0x268/0x59f
Jan 17 18:09:01 vosztok kernel:  [vfs_read+156/266] vfs_read+0x9c/0x10a
Jan 17 18:09:01 vosztok kernel:  [<c0157e73>] vfs_read+0x9c/0x10a
Jan 17 18:09:01 vosztok kernel:  [sys_read+65/103] sys_read+0x41/0x67
Jan 17 18:09:01 vosztok kernel:  [<c01581c6>] sys_read+0x41/0x67
Jan 17 18:09:01 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 18:09:01 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 18:09:01 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:01 vosztok kernel: sshd          S c01540ab     0 10891  10889
Jan 17 18:09:01 vosztok kernel:        cbc0fb60 00000086 ce4fdb84 c01540ab =
d4fade00 ce4fcfc0 00000000 7fffffff=20
Jan 17 18:09:01 vosztok kernel:        00000009 00000100 c036c8bf c0127a58 =
cdb14900 cbc0fbe0 00000008 c03417ae=20
Jan 17 18:09:01 vosztok kernel:        0015c927 c0390720 d18dab80 00000000 =
cbc0ff9c c0162a11 cbc0ff9c cbc0ff48=20
Jan 17 18:09:01 vosztok kernel: Call Trace:
Jan 17 18:09:01 vosztok kernel:  [__slab_free+92/670] __slab_free+0x5c/0x29e
Jan 17 18:09:01 vosztok kernel:  [<c01540ab>] __slab_free+0x5c/0x29e
Jan 17 18:09:01 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 18:09:01 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 18:09:01 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 18:09:01 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 18:09:01 vosztok kernel:  [unix_poll+23/139] unix_poll+0x17/0x8b
Jan 17 18:09:01 vosztok kernel:  [<c03417ae>] unix_poll+0x17/0x8b
Jan 17 18:09:01 vosztok kernel:  [do_select+916/993] do_select+0x394/0x3e1
Jan 17 18:09:01 vosztok kernel:  [<c0162a11>] do_select+0x394/0x3e1
Jan 17 18:09:01 vosztok kernel:  [__pollwait+0/169] __pollwait+0x0/0xa9
Jan 17 18:09:01 vosztok kernel:  [<c0162f31>] __pollwait+0x0/0xa9
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [net_rx_action+82/213] net_rx_action+0x52/=
0xd5
Jan 17 18:09:01 vosztok kernel: > [<c02f9da8>] net_rx_action+0x52/0xd5
Jan 17 18:09:01 vosztok kernel:  [__do_softirq+89/133] __do_softirq+0x59/0x=
85
Jan 17 18:09:01 vosztok kernel:  [<c011bede>] __do_softirq+0x59/0x85
Jan 17 18:09:01 vosztok kernel:  [local_bh_enable+125/151] local_bh_enable+=
0x7d/0x97
Jan 17 18:09:01 vosztok kernel:  [<c011c2ae>] local_bh_enable+0x7d/0x97
Jan 17 18:09:01 vosztok kernel:  [dev_queue_xmit+609/641] dev_queue_xmit+0x=
261/0x281
Jan 17 18:09:01 vosztok kernel:  [<c02fa7d8>] dev_queue_xmit+0x261/0x281
Jan 17 18:09:01 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 18:09:01 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 18:09:01 vosztok kernel:  [ip_output+571/630] ip_output+0x23b/0x276
Jan 17 18:09:01 vosztok kernel:  [<c031191d>] ip_output+0x23b/0x276
Jan 17 18:09:01 vosztok kernel:  [kfree_skbmem+8/97] kfree_skbmem+0x8/0x61
Jan 17 18:09:01 vosztok kernel:  [<c02f3c10>] kfree_skbmem+0x8/0x61
Jan 17 18:09:01 vosztok kernel:  [add_partial+49/73] add_partial+0x31/0x49
Jan 17 18:09:01 vosztok kernel:  [<c01532e8>] add_partial+0x31/0x49
Jan 17 18:09:01 vosztok kernel:  [ip_queue_xmit+792/849] ip_queue_xmit+0x31=
8/0x351
Jan 17 18:09:01 vosztok kernel:  [<c0311089>] ip_queue_xmit+0x318/0x351
Jan 17 18:09:01 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 18:09:01 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 18:09:01 vosztok kernel:  [enqueue_entity+466/499] enqueue_entity+0x=
1d2/0x1f3
Jan 17 18:09:01 vosztok kernel:  [<c0113e13>] enqueue_entity+0x1d2/0x1f3
Jan 17 18:09:01 vosztok kernel:  [tcp_v4_send_check+128/182] tcp_v4_send_ch=
eck+0x80/0xb6
Jan 17 18:09:01 vosztok kernel:  [<c03237fb>] tcp_v4_send_check+0x80/0xb6
Jan 17 18:09:01 vosztok kernel:  [tcp_transmit_skb+1611/1662] tcp_transmit_=
skb+0x64b/0x67e
Jan 17 18:09:01 vosztok kernel:  [<c031edee>] tcp_transmit_skb+0x64b/0x67e
Jan 17 18:09:01 vosztok kernel:  [check_preempt_curr_fair+82/86] check_pree=
mpt_curr_fair+0x52/0x56
Jan 17 18:09:01 vosztok kernel:  [<c0114f36>] check_preempt_curr_fair+0x52/=
0x56
Jan 17 18:09:01 vosztok kernel:  [lock_timer_base+33/82] lock_timer_base+0x=
21/0x52
Jan 17 18:09:01 vosztok kernel:  [<c011ecf6>] lock_timer_base+0x21/0x52
Jan 17 18:09:01 vosztok kernel:  [__mod_timer+154/181] __mod_timer+0x9a/0xb5
Jan 17 18:09:01 vosztok kernel:  [<c011ee1d>] __mod_timer+0x9a/0xb5
Jan 17 18:09:01 vosztok kernel:  [sk_reset_timer+12/21] sk_reset_timer+0xc/=
0x15
Jan 17 18:09:01 vosztok kernel:  [<c02f0c35>] sk_reset_timer+0xc/0x15
Jan 17 18:09:01 vosztok kernel:  [__tcp_push_pending_frames+1811/1976] __tc=
p_push_pending_frames+0x713/0x7b8
Jan 17 18:09:01 vosztok kernel:  [<c032073b>] __tcp_push_pending_frames+0x7=
13/0x7b8
Jan 17 18:09:01 vosztok kernel:  [tcp_sendmsg+363/2571] tcp_sendmsg+0x16b/0=
xa0b
Jan 17 18:09:01 vosztok kernel:  [<c03168d4>] tcp_sendmsg+0x16b/0xa0b
Jan 17 18:09:01 vosztok kernel:  [local_bh_enable+125/151] local_bh_enable+=
0x7d/0x97
Jan 17 18:09:01 vosztok kernel:  [<c011c2ae>] local_bh_enable+0x7d/0x97
Jan 17 18:09:01 vosztok kernel:  [tcp_sendmsg+2333/2571] tcp_sendmsg+0x91d/=
0xa0b
Jan 17 18:09:01 vosztok kernel:  [<c0317086>] tcp_sendmsg+0x91d/0xa0b
Jan 17 18:09:01 vosztok kernel:  [core_sys_select+682/711] core_sys_select+=
0x2aa/0x2c7
Jan 17 18:09:01 vosztok kernel:  [<c0162d08>] core_sys_select+0x2aa/0x2c7
Jan 17 18:09:01 vosztok kernel:  [sock_aio_write+188/200] sock_aio_write+0x=
bc/0xc8
Jan 17 18:09:01 vosztok kernel:  [<c02ee5a3>] sock_aio_write+0xbc/0xc8
Jan 17 18:09:01 vosztok kernel:  [do_sync_write+198/265] do_sync_write+0xc6=
/0x109
Jan 17 18:09:01 vosztok kernel:  [<c01575dd>] do_sync_write+0xc6/0x109
Jan 17 18:09:01 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 18:09:01 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 18:09:01 vosztok kernel:  [sys_select+213/391] sys_select+0xd5/0x187
Jan 17 18:09:01 vosztok kernel:  [<c01630af>] sys_select+0xd5/0x187
Jan 17 18:09:01 vosztok kernel:  [vfs_write+252/268] vfs_write+0xfc/0x10c
Jan 17 18:09:01 vosztok kernel:  [<c0157dc7>] vfs_write+0xfc/0x10c
Jan 17 18:09:01 vosztok kernel:  [sys_write+65/103] sys_write+0x41/0x67
Jan 17 18:09:01 vosztok kernel:  [<c015822d>] sys_write+0x41/0x67
Jan 17 18:09:01 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:01 vosztok kernel: sftp-server   S e0920dba     0 10892  10891
Jan 17 18:09:01 vosztok kernel:        dc3afb60 00200082 ce4fd104 e0920dba =
ccb9ea80 ce4fda40 00000000 7fffffff=20
Jan 17 18:09:01 vosztok kernel:        00000004 00000008 c036c8bf c0127a58 =
cdb14180 dc3afbe0 00000003 c03417ae=20
Jan 17 18:09:01 vosztok kernel:        001622f2 c0390720 d18da080 00000000 =
dc3aff9c c0162a11 dc3aff9c dc3aff48=20
Jan 17 18:09:01 vosztok kernel: Call Trace:
Jan 17 18:09:01 vosztok kernel:  [<e0920dba>] nilfs_mdt_mark_buffer_dirty+0=
x207/0x210 [nilfs2]
Jan 17 18:09:01 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 18:09:01 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 18:09:01 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 18:09:01 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 18:09:01 vosztok kernel:  [unix_poll+23/139] unix_poll+0x17/0x8b
Jan 17 18:09:01 vosztok kernel:  [<c03417ae>] unix_poll+0x17/0x8b
Jan 17 18:09:01 vosztok kernel:  [do_select+916/993] do_select+0x394/0x3e1
Jan 17 18:09:01 vosztok kernel:  [<c0162a11>] do_select+0x394/0x3e1
Jan 17 18:09:01 vosztok kernel:  [__pollwait+0/169] __pollwait+0x0/0xa9
Jan 17 18:09:01 vosztok kernel:  [<c0162f31>] __pollwait+0x0/0xa9
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [__make_request+945/1211] __make_request+0=
x3b1/0x4bb
Jan 17 18:09:01 vosztok kernel:  [<c0233d37>] __make_request+0x3b1/0x4bb
Jan 17 18:09:01 vosztok kernel:  [generic_make_request+390/435] generic_mak=
e_request+0x186/0x1b3
Jan 17 18:09:01 vosztok kernel:  [<c0231d62>] generic_make_request+0x186/0x=
1b3
Jan 17 18:09:01 vosztok kernel:  [bio_add_page+49/55] bio_add_page+0x31/0x37
Jan 17 18:09:01 vosztok kernel:  [<c01768b6>] bio_add_page+0x31/0x37
Jan 17 18:09:01 vosztok kernel:  [do_mpage_readpage+960/1128] do_mpage_read=
page+0x3c0/0x468
Jan 17 18:09:01 vosztok kernel:  [<c0179ee7>] do_mpage_readpage+0x3c0/0x468
Jan 17 18:09:01 vosztok kernel:  [submit_bio+217/224] submit_bio+0xd9/0xe0
Jan 17 18:09:01 vosztok kernel:  [<c0233786>] submit_bio+0xd9/0xe0
Jan 17 18:09:01 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 18:09:01 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 18:09:01 vosztok kernel:  [enqueue_entity+466/499] enqueue_entity+0x=
1d2/0x1f3
Jan 17 18:09:01 vosztok kernel:  [<c0113e13>] enqueue_entity+0x1d2/0x1f3
Jan 17 18:09:01 vosztok kernel:  [__check_preempt_curr_fair+81/126] __check=
_preempt_curr_fair+0x51/0x7e
Jan 17 18:09:01 vosztok kernel:  [<c01137d0>] __check_preempt_curr_fair+0x5=
1/0x7e
Jan 17 18:09:01 vosztok kernel:  [check_preempt_curr_fair+82/86] check_pree=
mpt_curr_fair+0x52/0x56
Jan 17 18:09:01 vosztok kernel:  [<c0114f36>] check_preempt_curr_fair+0x52/=
0x56
Jan 17 18:09:01 vosztok kernel:  [try_to_wake_up+134/164] try_to_wake_up+0x=
86/0xa4
Jan 17 18:09:01 vosztok kernel:  [<c0114c02>] try_to_wake_up+0x86/0xa4
Jan 17 18:09:01 vosztok kernel:  [__wake_up_common+49/79] __wake_up_common+=
0x31/0x4f
Jan 17 18:09:01 vosztok kernel:  [<c01133ed>] __wake_up_common+0x31/0x4f
Jan 17 18:09:01 vosztok kernel:  [task_rq_lock+18/25] task_rq_lock+0x12/0x19
Jan 17 18:09:01 vosztok kernel:  [<c01149ce>] task_rq_lock+0x12/0x19
Jan 17 18:09:01 vosztok kernel:  [try_to_wake_up+134/164] try_to_wake_up+0x=
86/0xa4
Jan 17 18:09:01 vosztok kernel:  [<c0114c02>] try_to_wake_up+0x86/0xa4
Jan 17 18:09:01 vosztok kernel:  [__wake_up_common+49/79] __wake_up_common+=
0x31/0x4f
Jan 17 18:09:01 vosztok kernel:  [<c01133ed>] __wake_up_common+0x31/0x4f
Jan 17 18:09:01 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 18:09:01 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 18:09:01 vosztok kernel:  [sock_def_readable+90/114] sock_def_readab=
le+0x5a/0x72
Jan 17 18:09:01 vosztok kernel:  [<c02f2404>] sock_def_readable+0x5a/0x72
Jan 17 18:09:01 vosztok kernel:  [core_sys_select+682/711] core_sys_select+=
0x2aa/0x2c7
Jan 17 18:09:01 vosztok kernel:  [<c0162d08>] core_sys_select+0x2aa/0x2c7
Jan 17 18:09:01 vosztok kernel:  [sock_aio_write+188/200] sock_aio_write+0x=
bc/0xc8
Jan 17 18:09:01 vosztok kernel:  [<c02ee5a3>] sock_aio_write+0xbc/0xc8
Jan 17 18:09:01 vosztok kernel:  [generic_file_aio_read+364/411] generic_fi=
le_aio_read+0x16c/0x19b
Jan 17 18:09:01 vosztok kernel:  [<c013d691>] generic_file_aio_read+0x16c/0=
x19b
Jan 17 18:09:01 vosztok kernel:  [do_sync_write+198/265] do_sync_write+0xc6=
/0x109
Jan 17 18:09:01 vosztok kernel:  [<c01575dd>] do_sync_write+0xc6/0x109
Jan 17 18:09:01 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 18:09:01 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 18:09:01 vosztok kernel:  [sys_select+213/391] sys_select+0xd5/0x187
Jan 17 18:09:01 vosztok kernel:  [<c01630af>] sys_select+0xd5/0x187
Jan 17 18:09:01 vosztok kernel:  [vfs_write+252/268] vfs_write+0xfc/0x10c
Jan 17 18:09:01 vosztok kernel:  [<c0157dc7>] vfs_write+0xfc/0x10c
Jan 17 18:09:01 vosztok kernel:  [sys_write+65/103] sys_write+0x41/0x67
Jan 17 18:09:01 vosztok kernel:  [<c015822d>] sys_write+0x41/0x67
Jan 17 18:09:01 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:01 vosztok kernel: bash          S d09753fc     0 10907  10294
Jan 17 18:09:01 vosztok kernel:        cba1df34 00000082 cc57e684 d09753fc =
cbe2e540 00000000 ffffffff 00000001=20
Jan 17 18:09:01 vosztok kernel:        cc57fa40 00000000 c011a464 000003fc =
de8d9080 46be5160 d0486c08 0000000e=20
Jan 17 18:09:01 vosztok kernel:        ffffffff cc57e540 00000001 00000001 =
00000000 cc57e624 bf860b84 df1c2940=20
Jan 17 18:09:01 vosztok kernel: Call Trace:
Jan 17 18:09:01 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 18:09:01 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 18:09:01 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 18:09:01 vosztok kernel:  [sys_waitpid+39/43] sys_waitpid+0x27/0x2b
Jan 17 18:09:01 vosztok kernel:  [<c011a59e>] sys_waitpid+0x27/0x2b
Jan 17 18:09:01 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:01 vosztok kernel: ssh           S 00000000     0 10911  10907
Jan 17 18:09:01 vosztok kernel:        d0b99b60 00200086 cc57fb84 00000000 =
cbe2e700 c04248f0 00000000 7fffffff=20
Jan 17 18:09:01 vosztok kernel:        00000005 00000010 c036c8bf 00000000 =
dc3efc00 c024f9a3 c024c6b0 00000000=20
Jan 17 18:09:01 vosztok kernel:        00000104 00000104 d0493a80 00000000 =
d0b99f9c c0162a11 d0b99f9c d0b99f48=20
Jan 17 18:09:01 vosztok kernel: Call Trace:
Jan 17 18:09:01 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 18:09:01 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 18:09:01 vosztok kernel:  [normal_poll+0/290] normal_poll+0x0/0x122
Jan 17 18:09:01 vosztok kernel:  [<c024f9a3>] normal_poll+0x0/0x122
Jan 17 18:09:01 vosztok kernel:  [tty_poll+83/96] tty_poll+0x53/0x60
Jan 17 18:09:01 vosztok kernel:  [<c024c6b0>] tty_poll+0x53/0x60
Jan 17 18:09:01 vosztok kernel:  [do_select+916/993] do_select+0x394/0x3e1
Jan 17 18:09:01 vosztok kernel:  [<c0162a11>] do_select+0x394/0x3e1
Jan 17 18:09:01 vosztok kernel:  [__pollwait+0/169] __pollwait+0x0/0xa9
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [neigh_resolve_output+454/504] neigh_resol=
ve_output+0x1c6/0x1f8
Jan 17 18:09:01 vosztok kernel:  [<c02fdc65>] neigh_resolve_output+0x1c6/0x=
1f8
Jan 17 18:09:01 vosztok kernel:  [__qdisc_run+177/366] __qdisc_run+0xb1/0x1=
6e
Jan 17 18:09:01 vosztok kernel:  [<c030390f>] __qdisc_run+0xb1/0x16e
Jan 17 18:09:01 vosztok kernel:  [ip_output+571/630] ip_output+0x23b/0x276
Jan 17 18:09:01 vosztok kernel:  [<c031191d>] ip_output+0x23b/0x276
Jan 17 18:09:01 vosztok kernel:  [dev_queue_xmit+609/641] dev_queue_xmit+0x=
261/0x281
Jan 17 18:09:01 vosztok kernel:  [<c02fa7d8>] dev_queue_xmit+0x261/0x281
Jan 17 18:09:01 vosztok kernel:  [local_bh_enable+125/151] local_bh_enable+=
0x7d/0x97
Jan 17 18:09:01 vosztok kernel:  [<c011c2ae>] local_bh_enable+0x7d/0x97
Jan 17 18:09:01 vosztok kernel:  [ip_queue_xmit+792/849] ip_queue_xmit+0x31=
8/0x351
Jan 17 18:09:01 vosztok kernel:  [<c0311089>] ip_queue_xmit+0x318/0x351
Jan 17 18:09:01 vosztok kernel:  [enqueue_entity+466/499] enqueue_entity+0x=
1d2/0x1f3
Jan 17 18:09:01 vosztok kernel:  [<c0113e13>] enqueue_entity+0x1d2/0x1f3
Jan 17 18:09:01 vosztok kernel:  [ip_output+571/630] ip_output+0x23b/0x276
Jan 17 18:09:01 vosztok kernel:  [<c031191d>] ip_output+0x23b/0x276
Jan 17 18:09:01 vosztok kernel:  [__check_preempt_curr_fair+81/126] __check=
_preempt_curr_fair+0x51/0x7e
Jan 17 18:09:01 vosztok kernel:  [<c01137d0>] __check_preempt_curr_fair+0x5=
1/0x7e
Jan 17 18:09:01 vosztok kernel:  [tcp_v4_send_check+128/182] tcp_v4_send_ch=
eck+0x80/0xb6
Jan 17 18:09:01 vosztok kernel:  [<c03237fb>] tcp_v4_send_check+0x80/0xb6
Jan 17 18:09:01 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 18:09:01 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 18:09:01 vosztok kernel:  [enqueue_entity+466/499] enqueue_entity+0x=
1d2/0x1f3
Jan 17 18:09:01 vosztok kernel:  [<c0113e13>] enqueue_entity+0x1d2/0x1f3
Jan 17 18:09:01 vosztok kernel:  [__check_preempt_curr_fair+81/126] __check=
_preempt_curr_fair+0x51/0x7e
Jan 17 18:09:01 vosztok kernel:  [<c01137d0>] __check_preempt_curr_fair+0x5=
1/0x7e
Jan 17 18:09:01 vosztok kernel:  [check_preempt_curr_fair+82/86] check_pree=
mpt_curr_fair+0x52/0x56
Jan 17 18:09:01 vosztok kernel:  [<c0114f36>] check_preempt_curr_fair+0x52/=
0x56
Jan 17 18:09:01 vosztok kernel:  [try_to_wake_up+134/164] try_to_wake_up+0x=
86/0xa4
Jan 17 18:09:01 vosztok kernel:  [<c0114c02>] try_to_wake_up+0x86/0xa4
Jan 17 18:09:01 vosztok kernel:  [__wake_up_common+49/79] __wake_up_common+=
0x31/0x4f
Jan 17 18:09:01 vosztok kernel:  [<c01133ed>] __wake_up_common+0x31/0x4f
Jan 17 18:09:01 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 18:09:01 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 18:09:01 vosztok kernel:  [core_sys_select+682/711] core_sys_select+=
0x2aa/0x2c7
Jan 17 18:09:01 vosztok kernel:  [<c0162d08>] core_sys_select+0x2aa/0x2c7
Jan 17 18:09:01 vosztok kernel:  [n_tty_receive_buf+3376/3451] n_tty_receiv=
e_buf+0xd30/0xd7b
Jan 17 18:09:01 vosztok kernel:  [<c02507f5>] n_tty_receive_buf+0xd30/0xd7b
Jan 17 18:09:01 vosztok kernel:  [sock_aio_read+193/205] sock_aio_read+0xc1=
/0xcd
Jan 17 18:09:01 vosztok kernel:  [<c02ee670>] sock_aio_read+0xc1/0xcd
Jan 17 18:09:01 vosztok kernel:  [do_sync_read+198/265] do_sync_read+0xc6/0=
x109
Jan 17 18:09:01 vosztok kernel:  [<c01576e6>] do_sync_read+0xc6/0x109
Jan 17 18:09:01 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 18:09:01 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 18:09:01 vosztok kernel:  [tty_ldisc_deref+98/124] tty_ldisc_deref+0=
x62/0x7c
Jan 17 18:09:01 vosztok kernel:  [<c024bacf>] tty_ldisc_deref+0x62/0x7c
Jan 17 18:09:01 vosztok kernel:  [sys_select+213/391] sys_select+0xd5/0x187
Jan 17 18:09:01 vosztok kernel:  [<c01630af>] sys_select+0xd5/0x187
Jan 17 18:09:01 vosztok kernel:  [vfs_write+252/268] vfs_write+0xfc/0x10c
Jan 17 18:09:01 vosztok kernel:  [<c0157dc7>] vfs_write+0xfc/0x10c
Jan 17 18:09:01 vosztok kernel:  [sys_write+65/103] sys_write+0x41/0x67
Jan 17 18:09:01 vosztok kernel:  [<c015822d>] sys_write+0x41/0x67
Jan 17 18:09:01 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:01 vosztok kernel: bash          S c8a593fc     0 15550  10294
Jan 17 18:09:01 vosztok kernel:        cc0abf34 00000082 d4806684 c8a593fc =
db94ec40 00000000 ffffffff 00000001=20
Jan 17 18:09:01 vosztok kernel:        d4807500 00000000 c011a464 000003fc =
de43d080 00000020 c8a55268 0000000e=20
Jan 17 18:09:01 vosztok kernel:        ffffffff d4806540 00000001 00000001 =
00000000 d4806624 bfd848a4 d2afdb90=20
Jan 17 18:09:01 vosztok kernel: Call Trace:
Jan 17 18:09:01 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 18:09:01 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 18:09:01 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 18:09:01 vosztok kernel:  [sys_waitpid+39/43] sys_waitpid+0x27/0x2b
Jan 17 18:09:01 vosztok kernel:  [<c011a59e>] sys_waitpid+0x27/0x2b
Jan 17 18:09:01 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 18:09:01 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 18:09:01 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:01 vosztok kernel: su            S d75b7f98     0 15554  15550
Jan 17 18:09:01 vosztok kernel:        cc369f34 00000082 d4807644 d75b7f98 =
cbe2ea80 00000000 ffffffff 00000001=20
Jan 17 18:09:01 vosztok kernel:        cc57ea80 00000000 c011a464 00000f98 =
de8be468 00000001 ce234478 00000006=20
Jan 17 18:09:01 vosztok kernel:        ffffffff d4807500 00000001 00000001 =
00000000 d48075e4 c01173a2 00000000=20
Jan 17 18:09:01 vosztok kernel: Call Trace:
Jan 17 18:09:01 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 18:09:01 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 18:09:01 vosztok kernel:  [do_fork+252/443] do_fork+0xfc/0x1bb
Jan 17 18:09:01 vosztok kernel:  [<c01173a2>] do_fork+0xfc/0x1bb
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 18:09:01 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 18:09:01 vosztok kernel:  [sys_waitpid+39/43] sys_waitpid+0x27/0x2b
Jan 17 18:09:01 vosztok kernel:  [<c011a59e>] sys_waitpid+0x27/0x2b
Jan 17 18:09:01 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 18:09:01 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 18:09:01 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:01 vosztok kernel: bash          S 00000000     0 15557  15554
Jan 17 18:09:01 vosztok kernel:        d71bff34 00000086 cc57ebc4 00000000 =
cbe2e1c0 00000000 ffffffff 00000001=20
Jan 17 18:09:01 vosztok kernel:        dd7c8540 00000000 c011a464 00000001 =
d2c0e200 00000000 00000000 0000000e=20
Jan 17 18:09:01 vosztok kernel:        ffffffff cc57ea80 00000001 00000001 =
00000000 cc57eb64 bfe1a684 d2afdb90=20
Jan 17 18:09:01 vosztok kernel: Call Trace:
Jan 17 18:09:01 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 18:09:01 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 18:09:01 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 18:09:01 vosztok kernel:  [sys_waitpid+39/43] sys_waitpid+0x27/0x2b
Jan 17 18:09:01 vosztok kernel:  [<c011a59e>] sys_waitpid+0x27/0x2b
Jan 17 18:09:01 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 18:09:01 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 18:09:01 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:01 vosztok kernel: syslogd       S cdd0f8a0     0 24955      1
Jan 17 18:09:01 vosztok kernel:        c873fb60 00000086 d567bb84 cdd0f8a0 =
dcfb71c0 c0412280 00000000 7fffffff=20
Jan 17 18:09:01 vosztok kernel:        00000001 00000001 c036c8bf 00000001 =
c0127a58 df270300 c873fbe0 00000000=20
Jan 17 18:09:01 vosztok kernel:        c02f5e19 c0390780 d08eff80 00000000 =
c873ff9c c0162a11 c873ff9c c873ff48=20
Jan 17 18:09:01 vosztok kernel: Call Trace:
Jan 17 18:09:01 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 18:09:01 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 18:09:01 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 18:09:01 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 18:09:01 vosztok kernel:  [datagram_poll+20/176] datagram_poll+0x14/=
0xb0
Jan 17 18:09:01 vosztok kernel:  [<c02f5e19>] datagram_poll+0x14/0xb0
Jan 17 18:09:01 vosztok kernel:  [do_select+916/993] do_select+0x394/0x3e1
Jan 17 18:09:01 vosztok kernel:  [<c0162a11>] do_select+0x394/0x3e1
Jan 17 18:09:01 vosztok kernel:  [__pollwait+0/169] __pollwait+0x0/0xa9
Jan 17 18:09:01 vosztok kernel:  [<c0162f31>] __pollwait+0x0/0xa9
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [schedule+572/755] schedule+0x23c/0x2f3
Jan 17 18:09:01 vosztok kernel:  [<c036bfe2>] schedule+0x23c/0x2f3
Jan 17 18:09:01 vosztok kernel:  [schedule+729/755] schedule+0x2d9/0x2f3
Jan 17 18:09:01 vosztok kernel:  [<c036c07f>] schedule+0x2d9/0x2f3
Jan 17 18:09:01 vosztok kernel:  [io_schedule+14/22] io_schedule+0xe/0x16
Jan 17 18:09:01 vosztok kernel:  [<c036c20c>] io_schedule+0xe/0x16
Jan 17 18:09:01 vosztok kernel:  [__wait_on_bit+80/88] __wait_on_bit+0x50/0=
x58
Jan 17 18:09:01 vosztok kernel:  [<c036ca6e>] __wait_on_bit+0x50/0x58
Jan 17 18:09:01 vosztok kernel:  [sync_buffer+0/46] sync_buffer+0x0/0x2e
Jan 17 18:09:01 vosztok kernel:  [<c01741a9>] sync_buffer+0x0/0x2e
Jan 17 18:09:01 vosztok kernel:  [sync_buffer+0/46] sync_buffer+0x0/0x2e
Jan 17 18:09:01 vosztok kernel:  [<c01741a9>] sync_buffer+0x0/0x2e
Jan 17 18:09:01 vosztok kernel:  [out_of_line_wait_on_bit+98/106] out_of_li=
ne_wait_on_bit+0x62/0x6a
Jan 17 18:09:01 vosztok kernel:  [<c036cad8>] out_of_line_wait_on_bit+0x62/=
0x6a
Jan 17 18:09:01 vosztok kernel:  [wake_bit_function+0/60] wake_bit_function=
+0x0/0x3c
Jan 17 18:09:01 vosztok kernel: 68>] wake_bit_function+0x0/0x3c
Jan 17 18:09:01 vosztok kernel:  [__mark_inode_dirty+326/360] __mark_inode_=
dirty+0x146/0x168
Jan 17 18:09:01 vosztok kernel:  [<c01706fd>] __mark_inode_dirty+0x146/0x168
Jan 17 18:09:01 vosztok kernel:  [__wait_on_buffer+36/39] __wait_on_buffer+=
0x24/0x27
Jan 17 18:09:01 vosztok kernel:  [<c0174175>] __wait_on_buffer+0x24/0x27
Jan 17 18:09:01 vosztok kernel:  [__block_prepare_write+794/1098] __block_p=
repare_write+0x31a/0x44a
Jan 17 18:09:01 vosztok kernel:  [<c0174691>] __block_prepare_write+0x31a/0=
x44a
Jan 17 18:09:01 vosztok kernel:  [balance_dirty_pages_ratelimited_nr+397/42=
4] balance_dirty_pages_ratelimited_nr+0x18d/0x1a8
Jan 17 18:09:01 vosztok kernel:  [<c0140843>] balance_dirty_pages_ratelimit=
ed_nr+0x18d/0x1a8
Jan 17 18:09:01 vosztok kernel:  [__block_commit_write+94/136] __block_comm=
it_write+0x5e/0x88
Jan 17 18:09:01 vosztok kernel:  [<c0173f4b>] __block_commit_write+0x5e/0x88
Jan 17 18:09:01 vosztok kernel:  [__pagevec_lru_add+182/193] __pagevec_lru_=
add+0xb6/0xc1
Jan 17 18:09:01 vosztok kernel:  [<c014196b>] __pagevec_lru_add+0xb6/0xc1
Jan 17 18:09:01 vosztok kernel:  [generic_file_buffered_write+1487/1570] ge=
neric_file_buffered_write+0x5cf/0x622
Jan 17 18:09:01 vosztok kernel:  [<c013cd17>] generic_file_buffered_write+0=
x5cf/0x622
Jan 17 18:09:01 vosztok kernel:  [unix_dgram_recvmsg+511/531] unix_dgram_re=
cvmsg+0x1ff/0x213
Jan 17 18:09:01 vosztok kernel:  [<c0343685>] unix_dgram_recvmsg+0x1ff/0x213
Jan 17 18:09:01 vosztok kernel:  [__mark_inode_dirty+326/360] __mark_inode_=
dirty+0x146/0x168
Jan 17 18:09:01 vosztok kernel:  [<c01706fd>] __mark_inode_dirty+0x146/0x168
Jan 17 18:09:01 vosztok kernel:  [xfs_ilock+71/103] xfs_ilock+0x47/0x67
Jan 17 18:09:01 vosztok kernel:  [<c01fa71a>] xfs_ilock+0x47/0x67
Jan 17 18:09:01 vosztok kernel:  [xfs_iunlock+35/109] xfs_iunlock+0x23/0x6d
Jan 17 18:09:01 vosztok kernel:  [<c01fa684>] xfs_iunlock+0x23/0x6d
Jan 17 18:09:01 vosztok kernel:  [xfs_write+2604/2651] xfs_write+0xa2c/0xa5b
Jan 17 18:09:01 vosztok kernel:  [<c0223dd6>] xfs_write+0xa2c/0xa5b
Jan 17 18:09:01 vosztok kernel:  [memmove+14/34] memmove+0xe/0x22
Jan 17 18:09:01 vosztok kernel:  [<c023d576>] memmove+0xe/0x22
Jan 17 18:09:01 vosztok kernel:  [scrup+156/204] scrup+0x9c/0xcc
Jan 17 18:09:01 vosztok kernel:  [<c0256fa9>] scrup+0x9c/0xcc
Jan 17 18:09:01 vosztok kernel:  [release_console_sem+404/447] release_cons=
ole_sem+0x194/0x1bf
Jan 17 18:09:01 vosztok kernel:  [<c011831f>] release_console_sem+0x194/0x1=
bf
Jan 17 18:09:01 vosztok kernel:  [do_con_write+5900/5986] do_con_write+0x17=
0c/0x1762
Jan 17 18:09:01 vosztok kernel:  [<c025a0c1>] do_con_write+0x170c/0x1762
Jan 17 18:09:01 vosztok kernel:  [core_sys_select+682/711] core_sys_select+=
0x2aa/0x2c7
Jan 17 18:09:01 vosztok kernel:  [<c0162d08>] core_sys_select+0x2aa/0x2c7
Jan 17 18:09:01 vosztok kernel:  [setup_sigcontext+260/391] setup_sigcontex=
t+0x104/0x187
Jan 17 18:09:01 vosztok kernel:  [<c0103138>] setup_sigcontext+0x104/0x187
Jan 17 18:09:01 vosztok kernel:  [do_notify_resume+1273/1502] do_notify_res=
ume+0x4f9/0x5de
Jan 17 18:09:01 vosztok kernel:  [<c01039ff>] do_notify_resume+0x4f9/0x5de
Jan 17 18:09:01 vosztok kernel:  [do_loop_readv_writev+41/76] do_loop_readv=
_writev+0x29/0x4c
Jan 17 18:09:01 vosztok kernel:  [<c0157321>] do_loop_readv_writev+0x29/0x4c
Jan 17 18:09:01 vosztok kernel:  [getnstimeofday+43/172] getnstimeofday+0x2=
b/0xac
Jan 17 18:09:01 vosztok kernel:  [<c012b8f3>] getnstimeofday+0x2b/0xac
Jan 17 18:09:01 vosztok kernel:  [enqueue_hrtimer+215/226] enqueue_hrtimer+=
0xd7/0xe2
Jan 17 18:09:01 vosztok kernel:  [<c0129ead>] enqueue_hrtimer+0xd7/0xe2
Jan 17 18:09:01 vosztok kernel:  [sys_select+213/391] sys_select+0xd5/0x187
Jan 17 18:09:01 vosztok kernel:  [<c01630af>] sys_select+0xd5/0x187
Jan 17 18:09:01 vosztok kernel:  [alarm_setitimer+54/94] alarm_setitimer+0x=
36/0x5e
Jan 17 18:09:01 vosztok kernel:  [<c011b568>] alarm_setitimer+0x36/0x5e
Jan 17 18:09:01 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:01 vosztok kernel: klogd         R running      0 24967      1
Jan 17 18:09:01 vosztok kernel: epiphany      D 99810623     0 27041      1
Jan 17 18:09:01 vosztok kernel:        cf1a7e3c 00200082 d567abc4 99810623 =
c3dabc40 cd3ec020 fffeffff df14cc94=20
Jan 17 18:09:01 vosztok kernel:        00000000 d567aa80 c023bd30 cf1a7e60 =
00000000 df14cc94 df14cc00 00000000=20
Jan 17 18:09:01 vosztok kernel:        dec6e1e0 c036d592 df14cc98 df47be74 =
d567aa80 00000001 df14cc94 c036d5d3=20
Jan 17 18:09:01 vosztok kernel: Call Trace:
Jan 17 18:09:01 vosztok kernel:  [rwsem_down_failed_common+328/353] rwsem_d=
own_failed_common+0x148/0x161
Jan 17 18:09:01 vosztok kernel:  [<c023bd30>] rwsem_down_failed_common+0x14=
8/0x161
Jan 17 18:09:01 vosztok kernel:  [rwsem_down_read_failed+26/36] rwsem_down_=
read_failed+0x1a/0x24
Jan 17 18:09:01 vosztok kernel:  [<c036d592>] rwsem_down_read_failed+0x1a/0=
x24
Jan 17 18:09:01 vosztok kernel:  [call_rwsem_down_read_failed+7/12] call_rw=
sem_down_read_failed+0x7/0xc
Jan 17 18:09:01 vosztok kernel:  [<c036d5d3>] call_rwsem_down_read_failed+0=
x7/0xc
Jan 17 18:09:01 vosztok kernel:  [down_read+9/10] down_read+0x9/0xa
Jan 17 18:09:01 vosztok kernel:  [<c012a885>] down_read+0x9/0xa
Jan 17 18:09:01 vosztok kernel:  [<e092df2c>] nilfs_transaction_begin+0xd4/=
0x150 [nilfs2]
Jan 17 18:09:01 vosztok kernel:  [<e091f98d>] nilfs_load_super_block+0x695/=
0x924 [nilfs2]
Jan 17 18:09:01 vosztok kernel:  [<e091f96e>] nilfs_load_super_block+0x676/=
0x924 [nilfs2]
Jan 17 18:09:01 vosztok kernel:  [vfs_create+104/174] vfs_create+0x68/0xae
Jan 17 18:09:01 vosztok kernel:  [<c015e5cc>] vfs_create+0x68/0xae
Jan 17 18:09:01 vosztok kernel:  [open_namei+363/1347] open_namei+0x16b/0x5=
43
Jan 17 18:09:01 vosztok kernel:  [<c0160bab>] open_namei+0x16b/0x543
Jan 17 18:09:01 vosztok kernel:  [can_share_swap_page+82/115] can_share_swa=
p_page+0x52/0x73
Jan 17 18:09:01 vosztok kernel:  [<c014da53>] can_share_swap_page+0x52/0x73
Jan 17 18:09:01 vosztok kernel:  [do_filp_open+37/57] do_filp_open+0x25/0x39
Jan 17 18:09:01 vosztok kernel:  [<c0156421>] do_filp_open+0x25/0x39
Jan 17 18:09:01 vosztok kernel:  [get_unused_fd_flags+186/215] get_unused_f=
d_flags+0xba/0xd7
Jan 17 18:09:01 vosztok kernel:  [<c01561a6>] get_unused_fd_flags+0xba/0xd7
Jan 17 18:09:01 vosztok kernel:  [do_sys_open+68/197] do_sys_open+0x44/0xc5
Jan 17 18:09:01 vosztok kernel:  [<c0156479>] do_sys_open+0x44/0xc5
Jan 17 18:09:01 vosztok kernel:  [sys_open+28/30] sys_open+0x1c/0x1e
Jan 17 18:09:01 vosztok kernel:  [<c0156533>] sys_open+0x1c/0x1e
Jan 17 18:09:01 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 18:09:01 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 18:09:01 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:01 vosztok kernel: epiphany      S 00000000     0 27042      1
Jan 17 18:09:01 vosztok kernel:        c0f51bfc 00000082 d567b104 00000000 =
c3dabc40 d567aa80 00000000 7fffffff=20
Jan 17 18:09:01 vosztok kernel:        ffffffff 00000000 c036c8bf c0f51e94 =
c0127a58 c0f51c54 dc9f1600 d08efd80=20
Jan 17 18:09:01 vosztok kernel:        c015c927 00000001 c0f51e9c 00000000 =
00000000 c0162579 c0f51fac b6d6a0c8=20
Jan 17 18:09:01 vosztok kernel: Call Trace:
Jan 17 18:09:01 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 18:09:01 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 18:09:01 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 18:09:01 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 18:09:01 vosztok kernel:  [pipe_poll+36/122] pipe_poll+0x24/0x7a
Jan 17 18:09:01 vosztok kernel:  [<c015c927>] pipe_poll+0x24/0x7a
Jan 17 18:09:01 vosztok kernel:  [do_sys_poll+595/800] do_sys_poll+0x253/0x=
320
Jan 17 18:09:01 vosztok kernel:  [<c0162579>] do_sys_poll+0x253/0x320
Jan 17 18:09:01 vosztok kernel:  [__pollwait+0/169] __pollwait+0x0/0xa9
Jan 17 18:09:01 vosztok kernel:  [<c0162f31>] __pollwait+0x0/0xa9
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [dev_hard_start_xmit+424/519] dev_hard_sta=
rt_xmit+0x1a8/0x207
Jan 17 18:09:01 vosztok kernel:  [<c02f87e3>] dev_hard_start_xmit+0x1a8/0x2=
07
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [__qdisc_run+177/366] __qdisc_run+0xb1/0x1=
6e
Jan 17 18:09:01 vosztok kernel:  [<c030390f>] __qdisc_run+0xb1/0x16e
Jan 17 18:09:01 vosztok kernel:  [local_bh_enable+125/151] local_bh_enable+=
0x7d/0x97
Jan 17 18:09:01 vosztok kernel:  [<c011c2ae>] local_bh_enable+0x7d/0x97
Jan 17 18:09:01 vosztok kernel:  [dev_queue_xmit+609/641] dev_queue_xmit+0x=
261/0x281
Jan 17 18:09:01 vosztok kernel:  [<c02fa7d8>] dev_queue_xmit+0x261/0x281
Jan 17 18:09:01 vosztok kernel:  [kfree_skbmem+8/97] kfree_skbmem+0x8/0x61
Jan 17 18:09:01 vosztok kernel:  [<c02f3c10>] kfree_skbmem+0x8/0x61
Jan 17 18:09:01 vosztok kernel:  [add_partial+49/73] add_partial+0x31/0x49
Jan 17 18:09:01 vosztok kernel:  [<c01532e8>] add_partial+0x31/0x49
Jan 17 18:09:01 vosztok kernel:  [kfree_skbmem+8/97] kfree_skbmem+0x8/0x61
Jan 17 18:09:01 vosztok kernel:  [<c02f3c10>] kfree_skbmem+0x8/0x61
Jan 17 18:09:01 vosztok kernel:  [__slab_free+92/670] __slab_free+0x5c/0x29e
Jan 17 18:09:01 vosztok kernel:  [<c01540ab>] __slab_free+0x5c/0x29e
Jan 17 18:09:01 vosztok kernel:  [tcp_recvmsg+1324/1811] tcp_recvmsg+0x52c/=
0x713
Jan 17 18:09:01 vosztok kernel:  [<c031780b>] tcp_recvmsg+0x52c/0x713
Jan 17 18:09:01 vosztok kernel:  [__slab_free+92/670] __slab_free+0x5c/0x29e
Jan 17 18:09:01 vosztok kernel:  [<c01540ab>] __slab_free+0x5c/0x29e
Jan 17 18:09:01 vosztok kernel:  [local_bh_enable+125/151] local_bh_enable+=
0x7d/0x97
Jan 17 18:09:01 vosztok kernel:  [<c011c2ae>] local_bh_enable+0x7d/0x97
Jan 17 18:09:01 vosztok kernel:  [lock_sock_nested+176/183] lock_sock_neste=
d+0xb0/0xb7
Jan 17 18:09:01 vosztok kernel:  [<c02f0c0a>] lock_sock_nested+0xb0/0xb7
Jan 17 18:09:01 vosztok kernel:  [e100_exec_cmd+147/174] e100_exec_cmd+0x93=
/0xae
Jan 17 18:09:01 vosztok kernel:  [<c02ab3f4>] e100_exec_cmd+0x93/0xae
Jan 17 18:09:01 vosztok kernel:  [e100_exec_cb+239/269] e100_exec_cb+0xef/0=
x10d
Jan 17 18:09:01 vosztok kernel:  [<c02ab9df>] e100_exec_cb+0xef/0x10d
Jan 17 18:09:01 vosztok kernel:  [e100_xmit_prepare+0/152] e100_xmit_prepar=
e+0x0/0x98
Jan 17 18:09:01 vosztok kernel:  [<c02aadbb>] e100_xmit_prepare+0x0/0x98
Jan 17 18:09:01 vosztok kernel:  [e100_xmit_frame+96/211] e100_xmit_frame+0=
x60/0xd3
Jan 17 18:09:01 vosztok kernel:  [<c02aba5d>] e100_xmit_frame+0x60/0xd3
Jan 17 18:09:01 vosztok kernel:  [dev_hard_start_xmit+424/519] dev_hard_sta=
rt_xmit+0x1a8/0x207
Jan 17 18:09:01 vosztok kernel:  [<c02f87e3>] dev_hard_start_xmit+0x1a8/0x2=
07
Jan 17 18:09:01 vosztok kernel:  [__qdisc_run+177/366] __qdisc_run+0xb1/0x1=
6e
Jan 17 18:09:01 vosztok kernel:  [<c030390f>] __qdisc_run+0xb1/0x16e
Jan 17 18:09:01 vosztok kernel:  [local_bh_enable+125/151] local_bh_enable+=
0x7d/0x97
Jan 17 18:09:01 vosztok kernel:  [<c011c2ae>] local_bh_enable+0x7d/0x97
Jan 17 18:09:01 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 18:09:01 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 18:09:01 vosztok kernel:  [update_stats_wait_end+155/190] update_sta=
ts_wait_end+0x9b/0xbe
Jan 17 18:09:01 vosztok kernel:  [<c01136df>] update_stats_wait_end+0x9b/0x=
be
Jan 17 18:09:01 vosztok kernel:  [update_curr_load+110/131] update_curr_loa=
d+0x6e/0x83
Jan 17 18:09:01 vosztok kernel:  [<c011395f>] update_curr_load+0x6e/0x83
Jan 17 18:09:01 vosztok kernel:  [__switch_to+25/276] __switch_to+0x19/0x114
Jan 17 18:09:01 vosztok kernel:  [<c0102f39>] __switch_to+0x19/0x114
Jan 17 18:09:01 vosztok kernel:  [schedule+572/755] schedule+0x23c/0x2f3
Jan 17 18:09:01 vosztok kernel:  [<c036bfe2>] schedule+0x23c/0x2f3
Jan 17 18:09:01 vosztok kernel:  [schedule+729/755] schedule+0x2d9/0x2f3
Jan 17 18:09:01 vosztok kernel:  [<c036c07f>] schedule+0x2d9/0x2f3
Jan 17 18:09:01 vosztok kernel:  [unqueue_me+186/194] unqueue_me+0xba/0xc2
Jan 17 18:09:01 vosztok kernel:  [<c012f3c7>] unqueue_me+0xba/0xc2
Jan 17 18:09:01 vosztok kernel:  [futex_wait+581/750] futex_wait+0x245/0x2ee
Jan 17 18:09:01 vosztok kernel:  [find_extend_vma+18/73] find_extend_vma+0x=
12/0x49
Jan 17 18:09:01 vosztok kernel:  [<c01489a2>] find_extend_vma+0x12/0x49
Jan 17 18:09:01 vosztok kernel:  [get_futex_key+109/288] get_futex_key+0x6d=
/0x120
Jan 17 18:09:01 vosztok kernel:  [<c012f452>] get_futex_key+0x6d/0x120
Jan 17 18:09:01 vosztok kernel:  [futex_wake+191/201] futex_wake+0xbf/0xc9
Jan 17 18:09:01 vosztok kernel:  [<c01304cb>] futex_wake+0xbf/0xc9
Jan 17 18:09:01 vosztok kernel:  [do_futex+120/2660] do_futex+0x78/0xa64
Jan 17 18:09:01 vosztok kernel:  [<c013054d>] do_futex+0x78/0xa64
Jan 17 18:09:01 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 18:09:01 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 18:09:01 vosztok kernel:  [d_kill+55/70] d_kill+0x37/0x46
Jan 17 18:09:01 vosztok kernel:  [<c0165e28>] d_kill+0x37/0x46
Jan 17 18:09:01 vosztok kernel:  [d_kill+55/70] d_kill+0x37/0x46
Jan 17 18:09:01 vosztok kernel:  [<c0165e28>] d_kill+0x37/0x46
Jan 17 18:09:01 vosztok kernel:  [_atomic_dec_and_lock+37/64] _atomic_dec_a=
nd_lock+0x25/0x40
Jan 17 18:09:01 vosztok kernel:  [<c02390e9>] _atomic_dec_and_lock+0x25/0x40
Jan 17 18:09:01 vosztok kernel:  [do_gettimeofday+44/196] do_gettimeofday+0=
x2c/0xc4
Jan 17 18:09:01 vosztok kernel:  [<c012b095>] do_gettimeofday+0x2c/0xc4
Jan 17 18:09:01 vosztok kernel:  [sys_poll+52/55] sys_poll+0x34/0x37
Jan 17 18:09:01 vosztok kernel:  [<c016267a>] sys_poll+0x34/0x37
Jan 17 18:09:01 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:01 vosztok kernel: epiphany      S c012f3c7     0 27043      1
Jan 17 18:09:01 vosztok kernel:        d3b07e64 00000082 d567b644 c012f3c7 =
c3dabc40 00000000 c3dabc74 084aeb88=20
Jan 17 18:09:01 vosztok kernel:        d3b07e84 00000000 c0130066 00000000 =
0003939f 0003939f 00000064 c048ae90=20
Jan 17 18:09:01 vosztok kernel:        c048ae90 c048ae98 c048ae98 d3b07ef0 =
d3b07ef0 c048ae90 084ae000 c3dabc40=20
Jan 17 18:09:01 vosztok kernel: Call Trace:
Jan 17 18:09:01 vosztok kernel:  [unqueue_me+186/194] unqueue_me+0xba/0xc2
Jan 17 18:09:01 vosztok kernel:  [<c012f3c7>] unqueue_me+0xba/0xc2
Jan 17 18:09:01 vosztok kernel:  [futex_wait+462/750] futex_wait+0x1ce/0x2ee
Jan 17 18:09:01 vosztok kernel:  [<c0130066>] futex_wait+0x1ce/0x2ee
Jan 17 18:09:01 vosztok kernel:  [get_futex_key+109/288] get_futex_key+0x6d=
/0x120
Jan 17 18:09:01 vosztok kernel:  [<c012f452>] get_futex_key+0x6d/0x120
Jan 17 18:09:01 vosztok kernel:  [hrtimer_wakeup+0/24] hrtimer_wakeup+0x0/0=
x18
Jan 17 18:09:01 vosztok kernel:  [<c012a19b>] hrtimer_wakeup+0x0/0x18
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [do_futex+101/2660] do_futex+0x65/0xa64
Jan 17 18:09:01 vosztok kernel:  [<c013053a>] do_futex+0x65/0xa64
Jan 17 18:09:01 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 18:09:01 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 18:09:01 vosztok kernel:  [do_IRQ+88/109] do_IRQ+0x58/0x6d
Jan 17 18:09:01 vosztok kernel:  [<c01062b7>] do_IRQ+0x58/0x6d
Jan 17 18:09:01 vosztok kernel:  [getnstimeofday+43/172] getnstimeofday+0x2=
b/0xac
Jan 17 18:09:01 vosztok kernel:  [<c012b8f3>] getnstimeofday+0x2b/0xac
Jan 17 18:09:01 vosztok kernel:  [ktime_get_ts+17/58] ktime_get_ts+0x11/0x3a
Jan 17 18:09:01 vosztok kernel:  [<c012a4c2>] ktime_get_ts+0x11/0x3a
Jan 17 18:09:01 vosztok kernel:  [sys_futex+194/212] sys_futex+0xc2/0xd4
Jan 17 18:09:01 vosztok kernel:  [<c0130ffb>] sys_futex+0xc2/0xd4
Jan 17 18:09:01 vosztok kernel:  [sys_gettimeofday+39/83] sys_gettimeofday+=
0x27/0x53
Jan 17 18:09:01 vosztok kernel:  [<c011bcd2>] sys_gettimeofday+0x27/0x53
Jan 17 18:09:01 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:01 vosztok kernel: epiphany      S 00000001     0  2797      1
Jan 17 18:09:01 vosztok kernel:        c0a03e64 00000082 ce4fc684 00000001 =
c3dabc40 00000000 c3dabc74 092f3fa0=20
Jan 17 18:09:01 vosztok kernel:        c0a03e84 00000000 c0130066 00000000 =
00000015 00000015 00000064 c048a600=20
Jan 17 18:09:01 vosztok kernel:        c048a600 c048a608 c048a608 c0a03ef0 =
c0a03ef0 c048a600 092f3000 c3dabc40=20
Jan 17 18:09:01 vosztok kernel: Call Trace:
Jan 17 18:09:01 vosztok kernel:  [futex_wait+462/750] futex_wait+0x1ce/0x2ee
Jan 17 18:09:01 vosztok kernel:  [<c0130066>] futex_wait+0x1ce/0x2ee
Jan 17 18:09:01 vosztok kernel:  [get_futex_key+109/288] get_futex_key+0x6d=
/0x120
Jan 17 18:09:01 vosztok kernel:  [<c012f452>] get_futex_key+0x6d/0x120
Jan 17 18:09:01 vosztok kernel:  [do_sync_write+198/265] do_sync_write+0xc6=
/0x109
Jan 17 18:09:01 vosztok kernel:  [<c01575dd>] do_sync_write+0xc6/0x109
Jan 17 18:09:01 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:01 vosztok kernel:  [do_futex+101/2660] do_futex+0x65/0xa64
Jan 17 18:09:01 vosztok kernel:  [<c013053a>] do_futex+0x65/0xa64
Jan 17 18:09:01 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 18:09:01 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 18:09:01 vosztok kernel:  [sys_recv+55/59] sys_recv+0x37/0x3b
Jan 17 18:09:01 vosztok kernel:  [<c02efd64>] sys_recv+0x37/0x3b
Jan 17 18:09:01 vosztok kernel:  [sys_futex+194/212] sys_futex+0xc2/0xd4
Jan 17 18:09:01 vosztok kernel:  [<c0130ffb>] sys_futex+0xc2/0xd4
Jan 17 18:09:01 vosztok kernel:  [sys_write+95/103] sys_write+0x5f/0x67
Jan 17 18:09:01 vosztok kernel:  [<c015824b>] sys_write+0x5f/0x67
Jan 17 18:09:01 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:01 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 18:09:01 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 18:09:01 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:01 vosztok kernel: epiphany      S 00a8a8a8     0  2798      1
Jan 17 18:09:01 vosztok kernel:        c0e0de64 00000082 df4b1104 00a8a8a8 =
c3dabc40 00000000 c3dabc74 08845ec8=20
Jan 17 18:09:01 vosztok kernel:        c0e0de84 00000000 c0130066 00a8a8a8 =
00000001 00000001 00000064 c048a520=20
Jan 17 18:09:01 vosztok kernel:        c048a520 c048a528 c048a528 c0e0def0 =
c0e0def0 c048a520 08845000 c3dabc40=20
Jan 17 18:09:02 vosztok kernel: Call Trace:
Jan 17 18:09:02 vosztok kernel:  [futex_wait+462/750] futex_wait+0x1ce/0x2ee
Jan 17 18:09:02 vosztok kernel:  [<c0130066>] futex_wait+0x1ce/0x2ee
Jan 17 18:09:02 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [do_futex+101/2660] do_futex+0x65/0xa64
Jan 17 18:09:02 vosztok kernel:  [<c013053a>] do_futex+0x65/0xa64
Jan 17 18:09:02 vosztok kernel:  [sys_futex+194/212] sys_futex+0xc2/0xd4
Jan 17 18:09:02 vosztok kernel:  [<c0130ffb>] sys_futex+0xc2/0xd4
Jan 17 18:09:02 vosztok kernel:  [schedule_tail+38/131] schedule_tail+0x26/=
0x83
Jan 17 18:09:02 vosztok kernel:  [<c0115971>] schedule_tail+0x26/0x83
Jan 17 18:09:02 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:02 vosztok kernel: gnome-vfs-dae S 00000000     0  6916      1
Jan 17 18:09:02 vosztok kernel:        cf975bfc 00200086 d567a684 00000000 =
cfa4b700 db97e000 00000000 7fffffff=20
Jan 17 18:09:02 vosztok kernel:        ffffffff 00000000 c036c8bf c0127a58 =
cf975e94 c0127a58 cf975c54 cf975ecc=20
Jan 17 18:09:02 vosztok kernel:        de200e00 c017b27c 00000000 00000000 =
00000000 c0162579 cf975fac 080700c0=20
Jan 17 18:09:02 vosztok kernel: Call Trace:
Jan 17 18:09:02 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 18:09:02 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 18:09:02 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 18:09:02 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 18:09:02 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 18:09:02 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 18:09:02 vosztok kernel:  [inotify_poll+58/64] inotify_poll+0x3a/0x40
Jan 17 18:09:02 vosztok kernel:  [<c017b27c>] inotify_poll+0x3a/0x40
Jan 17 18:09:02 vosztok kernel:  [do_sys_poll+595/800] do_sys_poll+0x253/0x=
320
Jan 17 18:09:02 vosztok kernel:  [<c0162579>] do_sys_poll+0x253/0x320
Jan 17 18:09:02 vosztok kernel:  [__pollwait+0/169] __pollwait+0x0/0xa9
Jan 17 18:09:02 vosztok kernel:  [<c0162f31>] __pollwait+0x0/0xa9
Jan 17 18:09:02 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [mpage_end_io_read+0/97] mpage_end_io_read=
+0x0/0x61
Jan 17 18:09:02 vosztok kernel:  [<c0179fe4>] mpage_end_io_read+0x0/0x61
Jan 17 18:09:02 vosztok kernel:  [mpage_bio_submit+25/29] mpage_bio_submit+=
0x19/0x1d
Jan 17 18:09:02 vosztok kernel:  [<c01795dc>] mpage_bio_submit+0x19/0x1d
Jan 17 18:09:02 vosztok kernel:  [mpage_readpages+262/276] mpage_readpages+=
0x106/0x114
Jan 17 18:09:02 vosztok kernel:  [<c017a1ae>] mpage_readpages+0x106/0x114
Jan 17 18:09:02 vosztok kernel:  [xfs_get_blocks+0/37] xfs_get_blocks+0x0/0=
x25
Jan 17 18:09:02 vosztok kernel:  [<c021cee8>] xfs_get_blocks+0x0/0x25
Jan 17 18:09:02 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 18:09:02 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 18:09:02 vosztok kernel:  [update_curr_load+110/131] update_curr_loa=
d+0x6e/0x83
Jan 17 18:09:02 vosztok kernel:  [<c011395f>] update_curr_load+0x6e/0x83
Jan 17 18:09:02 vosztok kernel:  [__switch_to+25/276] __switch_to+0x19/0x114
Jan 17 18:09:02 vosztok kernel:  [<c0102f39>] __switch_to+0x19/0x114
Jan 17 18:09:02 vosztok kernel:  [schedule+572/755] schedule+0x23c/0x2f3
Jan 17 18:09:02 vosztok kernel:  [<c036bfe2>] schedule+0x23c/0x2f3
Jan 17 18:09:02 vosztok kernel:  [schedule+729/755] schedule+0x2d9/0x2f3
Jan 17 18:09:02 vosztok kernel:  [<c036c07f>] schedule+0x2d9/0x2f3
Jan 17 18:09:02 vosztok kernel:  [generic_unplug_device+32/54] generic_unpl=
ug_device+0x20/0x36
Jan 17 18:09:02 vosztok kernel:  [<c02337ad>] generic_unplug_device+0x20/0x=
36
Jan 17 18:09:02 vosztok kernel:  [io_schedule+14/22] io_schedule+0xe/0x16
Jan 17 18:09:02 vosztok kernel:  [__wait_on_bit_lock+74/81] __wait_on_bit_l=
ock+0x4a/0x51
Jan 17 18:09:02 vosztok kernel:  [<c036c9ad>] __wait_on_bit_lock+0x4a/0x51
Jan 17 18:09:02 vosztok kernel:  [__lock_page+87/93] __lock_page+0x57/0x5d
Jan 17 18:09:02 vosztok kernel:  [<c013b85d>] __lock_page+0x57/0x5d
Jan 17 18:09:02 vosztok kernel:  [psmouse_handle_byte+12/202] psmouse_handl=
e_byte+0xc/0xca
Jan 17 18:09:02 vosztok kernel:  [<c02d96b5>] psmouse_handle_byte+0xc/0xca
Jan 17 18:09:02 vosztok kernel:  [scheduler_tick+403/437] scheduler_tick+0x=
193/0x1b5
Jan 17 18:09:02 vosztok kernel:  [<c0115280>] scheduler_tick+0x193/0x1b5
Jan 17 18:09:02 vosztok kernel:  [getnstimeofday+43/172] getnstimeofday+0x2=
b/0xac
Jan 17 18:09:02 vosztok kernel:  [<c012b8f3>] getnstimeofday+0x2b/0xac
Jan 17 18:09:02 vosztok kernel:  [psmouse_interrupt+494/506] psmouse_interr=
upt+0x1ee/0x1fa
Jan 17 18:09:02 vosztok kernel:  [<c02d9f11>] psmouse_interrupt+0x1ee/0x1fa
Jan 17 18:09:02 vosztok kernel:  [clockevents_program_event+156/163] clocke=
vents_program_event+0x9c/0xa3
Jan 17 18:09:02 vosztok kernel:  [<c012d96e>] clockevents_program_event+0x9=
c/0xa3
Jan 17 18:09:02 vosztok kernel:  [serio_interrupt+92/119] serio_interrupt+0=
x5c/0x77
Jan 17 18:09:02 vosztok kernel:  [<c02d15b7>] serio_interrupt+0x5c/0x77
Jan 17 18:09:02 vosztok kernel:  [i8042_interrupt+551/571] i8042_interrupt+=
0x227/0x23b
Jan 17 18:09:02 vosztok kernel:  [<c02d20e0>] i8042_interrupt+0x227/0x23b
Jan 17 18:09:02 vosztok kernel:  [prepare_to_wait+74/102] prepare_to_wait+0=
x4a/0x66
Jan 17 18:09:02 vosztok kernel:  [<c01279b8>] prepare_to_wait+0x4a/0x66
Jan 17 18:09:02 vosztok kernel:  [finish_wait+75/99] finish_wait+0x4b/0x63
Jan 17 18:09:02 vosztok kernel:  [<c01278ef>] finish_wait+0x4b/0x63
Jan 17 18:09:02 vosztok kernel:  [inotify_read+323/333] inotify_read+0x143/=
0x14d
Jan 17 18:09:02 vosztok kernel:  [<c017b3c5>] inotify_read+0x143/0x14d
Jan 17 18:09:02 vosztok kernel:  [handle_IRQ_event+26/63] handle_IRQ_event+=
0x1a/0x3f
Jan 17 18:09:02 vosztok kernel:  [<c01394ba>] handle_IRQ_event+0x1a/0x3f
Jan 17 18:09:02 vosztok kernel:  [do_gettimeofday+44/196] do_gettimeofday+0=
x2c/0xc4
Jan 17 18:09:02 vosztok kernel:  [<c012b095>] do_gettimeofday+0x2c/0xc4
Jan 17 18:09:02 vosztok kernel:  [sys_poll+52/55] sys_poll+0x34/0x37
Jan 17 18:09:02 vosztok kernel:  [<c016267a>] sys_poll+0x34/0x37
Jan 17 18:09:02 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 18:09:02 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 18:09:02 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:02 vosztok kernel: dhcpcd        S 00000000     0 10009      1
Jan 17 18:09:02 vosztok kernel:        d2f0fb60 00000086 dd7c8144 00000000 =
c3dab8c0 00000286 0096dd33 d2f0fb70=20
Jan 17 18:09:02 vosztok kernel:        00000006 00000020 c036c924 c0127a58 =
deb60600 c0489510 c0489510 0096dd33=20
Jan 17 18:09:02 vosztok kernel:        c011efb9 dd7c8000 c04888c0 00000000 =
d2f0ff9c c0162a11 d2f0ff9c d2f0ff48=20
Jan 17 18:09:02 vosztok kernel: Call Trace:
Jan 17 18:09:02 vosztok kernel:  [schedule_timeout+120/149] schedule_timeou=
t+0x78/0x95
Jan 17 18:09:02 vosztok kernel:  [<c036c924>] schedule_timeout+0x78/0x95
Jan 17 18:09:02 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 18:09:02 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 18:09:02 vosztok kernel:  [process_timeout+0/5] process_timeout+0x0/=
0x5
Jan 17 18:09:02 vosztok kernel:  [<c011efb9>] process_timeout+0x0/0x5
Jan 17 18:09:02 vosztok kernel:  [do_select+916/993] do_select+0x394/0x3e1
Jan 17 18:09:02 vosztok kernel:  [<c0162a11>] do_select+0x394/0x3e1
Jan 17 18:09:02 vosztok kernel:  [__pollwait+0/169] __pollwait+0x0/0xa9
Jan 17 18:09:02 vosztok kernel:  [<c0162f31>] __pollwait+0x0/0xa9
Jan 17 18:09:02 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [xfs_bmap+0/12] xfs_bmap+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0222a69>] xfs_bmap+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [__xfs_get_blocks+112/543] __xfs_get_block=
s+0x70/0x21f
Jan 17 18:09:02 vosztok kernel:  [<c021cd14>] __xfs_get_blocks+0x70/0x21f
Jan 17 18:09:02 vosztok kernel:  [xlog_write+1191/1318] xlog_write+0x4a7/0x=
526
Jan 17 18:09:02 vosztok kernel:  [<c0206310>] xlog_write+0x4a7/0x526
Jan 17 18:09:02 vosztok kernel:  [find_get_page+68/92] find_get_page+0x44/0=
x5c
Jan 17 18:09:02 vosztok kernel:  [<c013b791>] find_get_page+0x44/0x5c
Jan 17 18:09:02 vosztok kernel:  [__find_get_block_slow+35/260] __find_get_=
block_slow+0x23/0x104
Jan 17 18:09:02 vosztok kernel:  [<c01737af>] __find_get_block_slow+0x23/0x=
104
Jan 17 18:09:02 vosztok kernel:  [__mark_inode_dirty+326/360] __mark_inode_=
dirty+0x146/0x168
Jan 17 18:09:02 vosztok kernel:  [<c01706fd>] __mark_inode_dirty+0x146/0x168
Jan 17 18:09:02 vosztok kernel:  [unmap_underlying_metadata+6/49] unmap_und=
erlying_metadata+0x6/0x31
Jan 17 18:09:02 vosztok kernel:  [<c017417e>] unmap_underlying_metadata+0x6=
/0x31
Jan 17 18:09:02 vosztok kernel:  [__block_prepare_write+588/1098] __block_p=
repare_write+0x24c/0x44a
Jan 17 18:09:02 vosztok kernel:  [<c01745c3>] __block_prepare_write+0x24c/0=
x44a
Jan 17 18:09:02 vosztok kernel:  [balance_dirty_pages_ratelimited_nr+397/42=
4] balance_dirty_pages_ratelimited_nr+0x18d/0x1a8
Jan 17 18:09:02 vosztok kernel:  [<c0140843>] balance_dirty_pages_ratelimit=
ed_nr+0x18d/0x1a8
Jan 17 18:09:02 vosztok kernel:  [__block_commit_write+94/136] __block_comm=
it_write+0x5e/0x88
Jan 17 18:09:02 vosztok kernel:  [<c0173f4b>] __block_commit_write+0x5e/0x88
Jan 17 18:09:02 vosztok kernel:  [__pagevec_lru_add+182/193] __pagevec_lru_=
add+0xb6/0xc1
Jan 17 18:09:02 vosztok kernel:  [<c014196b>] __pagevec_lru_add+0xb6/0xc1
Jan 17 18:09:02 vosztok kernel:  [generic_file_buffered_write+1487/1570] ge=
neric_file_buffered_write+0x5cf/0x622
Jan 17 18:09:02 vosztok kernel:  [<c013cd17>] generic_file_buffered_write+0=
x5cf/0x622
Jan 17 18:09:02 vosztok kernel:  [do_lookup+79/320] do_lookup+0x4f/0x140
Jan 17 18:09:02 vosztok kernel:  [<c015df2a>] do_lookup+0x4f/0x140
Jan 17 18:09:02 vosztok kernel:  [_atomic_dec_and_lock+37/64] _atomic_dec_a=
nd_lock+0x25/0x40
Jan 17 18:09:02 vosztok kernel:  [<c02390e9>] _atomic_dec_and_lock+0x25/0x40
Jan 17 18:09:02 vosztok kernel:  [xfs_ilock+71/103] xfs_ilock+0x47/0x67
Jan 17 18:09:02 vosztok kernel:  [<c01fa71a>] xfs_ilock+0x47/0x67
Jan 17 18:09:02 vosztok kernel:  [xfs_iunlock+35/109] xfs_iunlock+0x23/0x6d
Jan 17 18:09:02 vosztok kernel:  [<c01fa684>] xfs_iunlock+0x23/0x6d
Jan 17 18:09:02 vosztok kernel:  [xfs_write+2604/2651] xfs_write+0xa2c/0xa5b
Jan 17 18:09:02 vosztok kernel:  [<c0223dd6>] xfs_write+0xa2c/0xa5b
Jan 17 18:09:02 vosztok kernel:  [core_sys_select+682/711] core_sys_select+=
0x2aa/0x2c7
Jan 17 18:09:02 vosztok kernel:  [<c0162d08>] core_sys_select+0x2aa/0x2c7
Jan 17 18:09:02 vosztok kernel:  [get_page_from_freelist+463/820] get_page_=
from_freelist+0x1cf/0x334
Jan 17 18:09:02 vosztok kernel:  [<c013f545>] get_page_from_freelist+0x1cf/=
0x334
Jan 17 18:09:02 vosztok kernel:  [find_lock_page+151/176] find_lock_page+0x=
97/0xb0
Jan 17 18:09:02 vosztok kernel:  [<c013b965>] find_lock_page+0x97/0xb0
Jan 17 18:09:02 vosztok kernel:  [filemap_fault+586/969] filemap_fault+0x24=
a/0x3c9
Jan 17 18:09:02 vosztok kernel:  [<c013d90a>] filemap_fault+0x24a/0x3c9
Jan 17 18:09:02 vosztok kernel:  [__do_fault+729/773] __do_fault+0x2d9/0x305
Jan 17 18:09:02 vosztok kernel:  [<c0145312>] __do_fault+0x2d9/0x305
Jan 17 18:09:02 vosztok kernel:  [handle_mm_fault+731/1528] handle_mm_fault=
+0x2db/0x5f8
Jan 17 18:09:02 vosztok kernel:  [<c014683a>] handle_mm_fault+0x2db/0x5f8
Jan 17 18:09:02 vosztok kernel:  [sys_select+160/391] sys_select+0xa0/0x187
Jan 17 18:09:02 vosztok kernel:  [<c016307a>] sys_select+0xa0/0x187
Jan 17 18:09:02 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:02 vosztok kernel: bash          S cdeab3fc     0 10071  10294
Jan 17 18:09:02 vosztok kernel:        d7b3bf34 00000082 dd7c9644 cdeab3fc =
cfa4b380 00000000 ffffffff 00000001=20
Jan 17 18:09:02 vosztok kernel:        dd7c8a80 00000000 c011a464 000003fc =
de8cf080 46be5160 c09b3aa8 0000000e=20
Jan 17 18:09:02 vosztok kernel:        ffffffff dd7c9500 00000001 00000001 =
00000000 dd7c95e4 bfc27a54 df0df250=20
Jan 17 18:09:02 vosztok kernel: Call Trace:
Jan 17 18:09:02 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 18:09:02 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 18:09:02 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 18:09:02 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 18:09:02 vosztok kernel:  [sys_waitpid+39/43] sys_waitpid+0x27/0x2b
Jan 17 18:09:02 vosztok kernel:  [<c011a59e>] sys_waitpid+0x27/0x2b
Jan 17 18:09:02 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:02 vosztok kernel: ssh           S 00000000     0 10075  10071
Jan 17 18:09:02 vosztok kernel:        d2b15b60 00200086 dd7c8bc4 00000000 =
cfa4be00 c04248f0 00000000 7fffffff=20
Jan 17 18:09:02 vosztok kernel:        00000005 00000010 c036c8bf 00000000 =
d0ad8c00 c024f9a3 c024c6b0 00000000=20
Jan 17 18:09:02 vosztok kernel:        00000104 00000104 cfb7e080 00000000 =
d2b15f9c c0162a11 d2b15f9c d2b15f48=20
Jan 17 18:09:02 vosztok kernel: Call Trace:
Jan 17 18:09:02 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 18:09:02 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 18:09:02 vosztok kernel:  [normal_poll+0/290] normal_poll+0x0/0x122
Jan 17 18:09:02 vosztok kernel:  [<c024f9a3>] normal_poll+0x0/0x122
Jan 17 18:09:02 vosztok kernel:  [tty_poll+83/96] tty_poll+0x53/0x60
Jan 17 18:09:02 vosztok kernel:  [<c024c6b0>] tty_poll+0x53/0x60
Jan 17 18:09:02 vosztok kernel:  [do_select+916/993] do_select+0x394/0x3e1
Jan 17 18:09:02 vosztok kernel:  [<c0162a11>] do_select+0x394/0x3e1
Jan 17 18:09:02 vosztok kernel:  [__pollwait+0/169] __pollwait+0x0/0xa9
Jan 17 18:09:02 vosztok kernel:  [<c0162f31>] __pollwait+0x0/0xa9
Jan 17 18:09:02 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [__qdisc_run+177/366] __qdisc_run+0xb1/0x1=
6e
Jan 17 18:09:02 vosztok kernel:  [<c030390f>] __qdisc_run+0xb1/0x16e
Jan 17 18:09:02 vosztok kernel:  [local_bh_enable+125/151] local_bh_enable+=
0x7d/0x97
Jan 17 18:09:02 vosztok kernel:  [<c011c2ae>] local_bh_enable+0x7d/0x97
Jan 17 18:09:02 vosztok kernel:  [dev_queue_xmit+609/641] dev_queue_xmit+0x=
261/0x281
Jan 17 18:09:02 vosztok kernel:  [<c02fa7d8>] dev_queue_xmit+0x261/0x281
Jan 17 18:09:02 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 18:09:02 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 18:09:02 vosztok kernel:  [ip_output+571/630] ip_output+0x23b/0x276
Jan 17 18:09:02 vosztok kernel:  [<c031191d>] ip_output+0x23b/0x276
Jan 17 18:09:02 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 18:09:02 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 18:09:02 vosztok kernel:  [enqueue_entity+466/499] enqueue_entity+0x=
1d2/0x1f3
Jan 17 18:09:02 vosztok kernel:  [<c0113e13>] enqueue_entity+0x1d2/0x1f3
Jan 17 18:09:02 vosztok kernel:  [__check_preempt_curr_fair+81/126] __check=
_preempt_curr_fair+0x51/0x7e
Jan 17 18:09:02 vosztok kernel:  [<e08a7a8b>] ipw_rx_notification+0x1286/0x=
1315 [ipw2200]
Jan 17 18:09:02 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 18:09:02 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 18:09:02 vosztok kernel:  [enqueue_entity+466/499] enqueue_entity+0x=
1d2/0x1f3
Jan 17 18:09:02 vosztok kernel:  [<c0113e13>] enqueue_entity+0x1d2/0x1f3
Jan 17 18:09:02 vosztok kernel:  [__check_preempt_curr_fair+81/126] __check=
_preempt_curr_fair+0x51/0x7e
Jan 17 18:09:02 vosztok kernel:  [<c01137d0>] __check_preempt_curr_fair+0x5=
1/0x7e
Jan 17 18:09:02 vosztok kernel:  [check_preempt_curr_fair+82/86] check_pree=
mpt_curr_fair+0x52/0x56
Jan 17 18:09:02 vosztok kernel:  [<c0114f36>] check_preempt_curr_fair+0x52/=
0x56
Jan 17 18:09:02 vosztok kernel:  [try_to_wake_up+134/164] try_to_wake_up+0x=
86/0xa4
Jan 17 18:09:02 vosztok kernel:  [<c0114c02>] try_to_wake_up+0x86/0xa4
Jan 17 18:09:02 vosztok kernel:  [__wake_up_common+49/79] __wake_up_common+=
0x31/0x4f
Jan 17 18:09:02 vosztok kernel:  [<c01133ed>] __wake_up_common+0x31/0x4f
Jan 17 18:09:02 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 18:09:02 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 18:09:02 vosztok kernel:  [core_sys_select+682/711] core_sys_select+=
0x2aa/0x2c7
Jan 17 18:09:02 vosztok kernel:  [<c0162d08>] core_sys_select+0x2aa/0x2c7
Jan 17 18:09:02 vosztok kernel:  [n_tty_receive_buf+3376/3451] n_tty_receiv=
e_buf+0xd30/0xd7b
Jan 17 18:09:02 vosztok kernel:  [<c02507f5>] n_tty_receive_buf+0xd30/0xd7b
Jan 17 18:09:02 vosztok kernel:  [sock_aio_read+193/205] sock_aio_read+0xc1=
/0xcd
Jan 17 18:09:02 vosztok kernel:  [<c02ee670>] sock_aio_read+0xc1/0xcd
Jan 17 18:09:02 vosztok kernel:  [do_sync_read+198/265] do_sync_read+0xc6/0=
x109
Jan 17 18:09:02 vosztok kernel:  [<c01576e6>] do_sync_read+0xc6/0x109
Jan 17 18:09:02 vosztok kernel:  [enqueue_entity+466/499] enqueue_entity+0x=
1d2/0x1f3
Jan 17 18:09:02 vosztok kernel:  [<c0113e13>] enqueue_entity+0x1d2/0x1f3
Jan 17 18:09:02 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 18:09:02 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 18:09:02 vosztok kernel:  [tty_ldisc_deref+98/124] tty_ldisc_deref+0=
x62/0x7c
Jan 17 18:09:02 vosztok kernel:  [<c024bacf>] tty_ldisc_deref+0x62/0x7c
Jan 17 18:09:02 vosztok kernel:  [sys_select+213/391] sys_select+0xd5/0x187
Jan 17 18:09:02 vosztok kernel:  [<c01630af>] sys_select+0xd5/0x187
Jan 17 18:09:02 vosztok kernel:  [vfs_write+252/268] vfs_write+0xfc/0x10c
Jan 17 18:09:02 vosztok kernel:  [<c0157dc7>] vfs_write+0xfc/0x10c
Jan 17 18:09:02 vosztok kernel:  [sys_write+65/103] sys_write+0x41/0x67
Jan 17 18:09:02 vosztok kernel:  [<c015822d>] sys_write+0x41/0x67
Jan 17 18:09:02 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:02 vosztok kernel: emerge        S 0000035f     0 10079  15557
Jan 17 18:09:02 vosztok kernel:        c2b7fe58 00200082 dd7c8684 0000035f =
c3dab380 c01279b8 d2580200 df073000=20
Jan 17 18:09:02 vosztok kernel:        c2b7fe74 d2580200 c015d010 00000000 =
dd7c8540 c0127833 d2580200 d2580200=20
Jan 17 18:09:02 vosztok kernel:        00000400 c2b7fedc c015d740 c013f545 =
c2b7ff64 00000000 dcc1c600 df073000=20
Jan 17 18:09:02 vosztok kernel: Call Trace:
Jan 17 18:09:02 vosztok kernel:  [prepare_to_wait+74/102] prepare_to_wait+0=
x4a/0x66
Jan 17 18:09:02 vosztok kernel:  [<c01279b8>] prepare_to_wait+0x4a/0x66
Jan 17 18:09:02 vosztok kernel:  [pipe_wait+80/110] pipe_wait+0x50/0x6e
Jan 17 18:09:02 vosztok kernel:  [<c015d010>] pipe_wait+0x50/0x6e
Jan 17 18:09:02 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 18:09:02 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 18:09:02 vosztok kernel:  [pipe_read+684/796] pipe_read+0x2ac/0x31c
Jan 17 18:09:02 vosztok kernel:  [<c015d740>] pipe_read+0x2ac/0x31c
Jan 17 18:09:02 vosztok kernel:  [get_page_from_freelist+463/820] get_page_=
from_freelist+0x1cf/0x334
Jan 17 18:09:02 vosztok kernel:  [<c013f545>] get_page_from_freelist+0x1cf/=
0x334
Jan 17 18:09:02 vosztok kernel:  [vma_adjust+821/962] vma_adjust+0x335/0x3c2
Jan 17 18:09:02 vosztok kernel:  [<c0148e92>] vma_adjust+0x335/0x3c2
Jan 17 18:09:02 vosztok kernel:  [do_sync_read+198/265] do_sync_read+0xc6/0=
x109
Jan 17 18:09:02 vosztok kernel:  [<c01576e6>] do_sync_read+0xc6/0x109
Jan 17 18:09:02 vosztok kernel:  [mmap_region+786/974] mmap_region+0x312/0x=
3ce
Jan 17 18:09:02 vosztok kernel:  [<c0149b48>] mmap_region+0x312/0x3ce
Jan 17 18:09:02 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 18:09:02 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 18:09:02 vosztok kernel:  [do_sync_read+0/265] do_sync_read+0x0/0x109
Jan 17 18:09:02 vosztok kernel:  [<c0157620>] do_sync_read+0x0/0x109
Jan 17 18:09:02 vosztok kernel:  [vfs_read+136/266] vfs_read+0x88/0x10a
Jan 17 18:09:02 vosztok kernel:  [<c0157e5f>] vfs_read+0x88/0x10a
Jan 17 18:09:02 vosztok kernel:  [sys_read+65/103] sys_read+0x41/0x67
Jan 17 18:09:02 vosztok kernel:  [<c01581c6>] sys_read+0x41/0x67
Jan 17 18:09:02 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 18:09:02 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 18:09:02 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:02 vosztok kernel: bash          S 00000306     0 10091  10294
Jan 17 18:09:02 vosztok kernel:        c7a7dee0 00000086 cc57f104 00000306 =
c3dabe00 c01136df d1df2800 7fffffff=20
Jan 17 18:09:02 vosztok kernel:        c7a7df44 bfdeca33 c036c8bf c0102f39 =
d6a9cfc0 cc57efc0 c3dabe00 d609fb60=20
Jan 17 18:09:02 vosztok kernel:        bfdeca33 c0127a58 d1df2800 d1df2800 =
d1df2800 c0250b30 00000082 dcc1c880=20
Jan 17 18:09:02 vosztok kernel: Call Trace:
Jan 17 18:09:02 vosztok kernel:  [update_stats_wait_end+155/190] update_sta=
ts_wait_end+0x9b/0xbe
Jan 17 18:09:02 vosztok kernel:  [<c01136df>] update_stats_wait_end+0x9b/0x=
be
Jan 17 18:09:02 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 18:09:02 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 18:09:02 vosztok kernel:  [__switch_to+25/276] __switch_to+0x19/0x114
Jan 17 18:09:02 vosztok kernel:  [<c0102f39>] __switch_to+0x19/0x114
Jan 17 18:09:02 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 18:09:02 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 18:09:02 vosztok kernel:  [read_chan+752/1324] read_chan+0x2f0/0x52c
Jan 17 18:09:02 vosztok kernel:  [<c0250b30>] read_chan+0x2f0/0x52c
Jan 17 18:09:02 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [read_chan+0/1324] read_chan+0x0/0x52c
Jan 17 18:09:02 vosztok kernel:  [<c0250840>] read_chan+0x0/0x52c
Jan 17 18:09:02 vosztok kernel:  [tty_read+100/172] tty_read+0x64/0xac
Jan 17 18:09:02 vosztok kernel:  [<c024dc05>] tty_read+0x64/0xac
Jan 17 18:09:02 vosztok kernel:  [tty_read+0/172] tty_read+0x0/0xac
Jan 17 18:09:02 vosztok kernel:  [<c024dba1>] tty_read+0x0/0xac
Jan 17 18:09:02 vosztok kernel:  [vfs_read+136/266] vfs_read+0x88/0x10a
Jan 17 18:09:02 vosztok kernel:  [<c0157e5f>] vfs_read+0x88/0x10a
Jan 17 18:09:02 vosztok kernel:  [sys_read+65/103] sys_read+0x41/0x67
Jan 17 18:09:02 vosztok kernel:  [<c01581c6>] sys_read+0x41/0x67
Jan 17 18:09:02 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:02 vosztok kernel: wpa_cli.sh    S db58f39c     0 10260   7902
Jan 17 18:09:02 vosztok kernel:        ccebbf34 00000082 ce4fc144 db58f39c =
cfa4bc40 00000000 ffffffff 00000001=20
Jan 17 18:09:02 vosztok kernel:        dd7c9a40 00000000 c011a464 0000039c =
df265080 080f60e0 ce2349a0 00000004=20
Jan 17 18:09:02 vosztok kernel:        ffffffff ce4fc000 00000001 00000001 =
00000000 ce4fc0e4 c01173a2 00000000=20
Jan 17 18:09:02 vosztok kernel: Call Trace:
Jan 17 18:09:02 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 18:09:02 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 18:09:02 vosztok kernel:  [do_fork+252/443] do_fork+0xfc/0x1bb
Jan 17 18:09:02 vosztok kernel:  [<c01173a2>] do_fork+0xfc/0x1bb
Jan 17 18:09:02 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 18:09:02 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 18:09:02 vosztok kernel:  [sys_waitpid+39/43] sys_waitpid+0x27/0x2b
Jan 17 18:09:02 vosztok kernel:  [<c011a59e>] sys_waitpid+0x27/0x2b
Jan 17 18:09:02 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 18:09:02 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 18:09:02 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:02 vosztok kernel: runscript.sh  S d069c3dc     0 10262  10260
Jan 17 18:09:02 vosztok kernel:        de591f34 00000082 dd7c9b84 d069c3dc =
ccb9e540 00000000 ffffffff 00000001=20
Jan 17 18:09:02 vosztok kernel:        df402540 00000000 c011a464 000003dc =
de8cc080 080f1590 c4b977e8 00000004=20
Jan 17 18:09:02 vosztok kernel:        ffffffff dd7c9a40 00000001 00000001 =
00000000 dd7c9b24 c01173a2 00000000=20
Jan 17 18:09:02 vosztok kernel: Call Trace:
Jan 17 18:09:02 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 18:09:02 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 18:09:02 vosztok kernel:  [do_fork+252/443] do_fork+0xfc/0x1bb
Jan 17 18:09:02 vosztok kernel:  [<c01173a2>] do_fork+0xfc/0x1bb
Jan 17 18:09:02 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 18:09:02 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 18:09:02 vosztok kernel:  [sys_waitpid+39/43] sys_waitpid+0x27/0x2b
Jan 17 18:09:02 vosztok kernel:  [<c011a59e>] sys_waitpid+0x27/0x2b
Jan 17 18:09:02 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 18:09:02 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 18:09:02 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:02 vosztok kernel: sh            S de8c8080     0 10292  10079
Jan 17 18:09:02 vosztok kernel:        dc48bf34 00200086 d616f644 de8c8080 =
cbe2e8c0 00000000 ffffffff 00000001=20
Jan 17 18:09:02 vosztok kernel:        ce4fd500 00000000 c011a464 000001e4 =
de8c8080 ffffffff d60e0210 00000004=20
Jan 17 18:09:02 vosztok kernel:        ffffffff d616f500 00000001 00000001 =
00000000 d616f5e4 c01173a2 00000000=20
Jan 17 18:09:02 vosztok kernel: Call Trace:
Jan 17 18:09:02 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 18:09:02 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 18:09:02 vosztok kernel:  [do_fork+252/443] do_fork+0xfc/0x1bb
Jan 17 18:09:02 vosztok kernel:  [<c01173a2>] do_fork+0xfc/0x1bb
Jan 17 18:09:02 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 18:09:02 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 18:09:02 vosztok kernel:  [sys_waitpid+39/43] sys_waitpid+0x27/0x2b
Jan 17 18:09:02 vosztok kernel:  [<c011a59e>] sys_waitpid+0x27/0x2b
Jan 17 18:09:02 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:02 vosztok kernel: find          D d5dd3cd8     0 10293  10292
Jan 17 18:09:02 vosztok kernel:        d5dd3cdc 00200086 ce4fd644 d5dd3cd8 =
ccb9e1c0 c01279b8 d5dd3cec c14487b8=20
Jan 17 18:09:02 vosztok kernel:        c13f0978 c14487b8 c0167e39 d5abb9e4 =
00000003 00000000 ce4fd500 c0127868=20
Jan 17 18:09:02 vosztok kernel:        c13f0978 c13f0978 035ee925 df679400 =
c0167e75 035ee925 c14487b8 df679400=20
Jan 17 18:09:02 vosztok kernel: Call Trace:
Jan 17 18:09:02 vosztok kernel:  [prepare_to_wait+74/102] prepare_to_wait+0=
x4a/0x66
Jan 17 18:09:02 vosztok kernel:  [<c01279b8>] prepare_to_wait+0x4a/0x66
Jan 17 18:09:02 vosztok kernel:  [__wait_on_freeing_inode+130/155] __wait_o=
n_freeing_inode+0x82/0x9b
Jan 17 18:09:02 vosztok kernel:  [<c0167e39>] __wait_on_freeing_inode+0x82/=
0x9b
Jan 17 18:09:02 vosztok kernel:  [wake_bit_function+0/60] wake_bit_function=
+0x0/0x3c
Jan 17 18:09:02 vosztok kernel:  [<c0127868>] wake_bit_function+0x0/0x3c
Jan 17 18:09:02 vosztok kernel:  [find_inode_fast+35/66] find_inode_fast+0x=
23/0x42
Jan 17 18:09:02 vosztok kernel:  [<c0167e75>] find_inode_fast+0x23/0x42
Jan 17 18:09:02 vosztok kernel:  [ifind_fast+33/151] ifind_fast+0x21/0x97
Jan 17 18:09:02 vosztok kernel:  [<c0167f0b>] ifind_fast+0x21/0x97
Jan 17 18:09:02 vosztok kernel:  [iget_locked+44/312] iget_locked+0x2c/0x138
Jan 17 18:09:02 vosztok kernel:  [<c0168224>] iget_locked+0x2c/0x138
Jan 17 18:09:02 vosztok kernel:  [xfs_iget+38/253] xfs_iget+0x26/0xfd
Jan 17 18:09:02 vosztok kernel:  [<c01fb449>] xfs_iget+0x26/0xfd
Jan 17 18:09:02 vosztok kernel:  [xfs_dir_lookup_int+125/212] xfs_dir_looku=
p_int+0x7d/0xd4
Jan 17 18:09:02 vosztok kernel:  [<c0212d71>] xfs_dir_lookup_int+0x7d/0xd4
Jan 17 18:09:02 vosztok kernel:  [xfs_lookup+82/120] xfs_lookup+0x52/0x78
Jan 17 18:09:02 vosztok kernel:  [<c0215b01>] xfs_lookup+0x52/0x78
Jan 17 18:09:02 vosztok kernel:  [xfs_vn_lookup+59/112] xfs_vn_lookup+0x3b/=
0x70
Jan 17 18:09:02 vosztok kernel:  [<c0222262>] xfs_vn_lookup+0x3b/0x70
Jan 17 18:09:02 vosztok kernel:  [do_lookup+163/320] do_lookup+0xa3/0x140
Jan 17 18:09:02 vosztok kernel:  [<c015df7e>] do_lookup+0xa3/0x140
Jan 17 18:09:02 vosztok kernel:  [__link_path_walk+2025/3072] __link_path_w=
alk+0x7e9/0xc00
Jan 17 18:09:02 vosztok kernel:  [<c015f7ee>] __link_path_walk+0x7e9/0xc00
Jan 17 18:09:02 vosztok kernel:  [link_path_walk+165/175] link_path_walk+0x=
a5/0xaf
Jan 17 18:09:02 vosztok kernel:  [<c015fcaa>] link_path_walk+0xa5/0xaf
Jan 17 18:09:02 vosztok kernel:  [_atomic_dec_and_lock+37/64] _atomic_dec_a=
nd_lock+0x25/0x40
Jan 17 18:09:02 vosztok kernel:  [<c02390e9>] _atomic_dec_and_lock+0x25/0x40
Jan 17 18:09:02 vosztok kernel:  [link_path_walk+66/175] link_path_walk+0x4=
2/0xaf
Jan 17 18:09:02 vosztok kernel:  [<c015fc47>] link_path_walk+0x42/0xaf
Jan 17 18:09:02 vosztok kernel:  [do_path_lookup+411/438] do_path_lookup+0x=
19b/0x1b6
Jan 17 18:09:02 vosztok kernel:  [<c015ffbf>] do_path_lookup+0x19b/0x1b6
Jan 17 18:09:02 vosztok kernel:  [getname+89/143] getname+0x59/0x8f
Jan 17 18:09:02 vosztok kernel:  [<c015ece1>] getname+0x59/0x8f
Jan 17 18:09:02 vosztok kernel:  [__user_walk_fd+47/69] __user_walk_fd+0x2f=
/0x45
Jan 17 18:09:02 vosztok kernel:  [<c0160776>] __user_walk_fd+0x2f/0x45
Jan 17 18:09:02 vosztok kernel:  [vfs_lstat_fd+22/61] vfs_lstat_fd+0x16/0x3d
Jan 17 18:09:02 vosztok kernel:  [<c015a553>] vfs_lstat_fd+0x16/0x3d
Jan 17 18:09:02 vosztok kernel:  [sys_fstatat64+40/72] sys_fstatat64+0x28/0=
x48
Jan 17 18:09:02 vosztok kernel:  [<c015a63b>] sys_fstatat64+0x28/0x48
Jan 17 18:09:02 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:02 vosztok kernel: runscript.sh  S c5b86800     0 10321  10262
Jan 17 18:09:02 vosztok kernel:        db979e58 00000082 df402684 c5b86800 =
db94ea80 c01279b8 c5b86800 de655128=20
Jan 17 18:09:02 vosztok kernel:        db979e74 c5b86800 c015d010 00000000 =
df402540 c0127833 c5b86800 c5b86800=20
Jan 17 18:09:02 vosztok kernel:        00000080 db979edc c015d740 00000000 =
db979f64 00000000 cece7280 de655128=20
Jan 17 18:09:02 vosztok kernel: Call Trace:
Jan 17 18:09:02 vosztok kernel:  [prepare_to_wait+74/102] prepare_to_wait+0=
x4a/0x66
Jan 17 18:09:02 vosztok kernel:  [<c01279b8>] prepare_to_wait+0x4a/0x66
Jan 17 18:09:02 vosztok kernel:  [pipe_wait+80/110] pipe_wait+0x50/0x6e
Jan 17 18:09:02 vosztok kernel:  [<c015d010>] pipe_wait+0x50/0x6e
Jan 17 18:09:02 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 18:09:02 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 18:09:02 vosztok kernel:  [pipe_read+684/796] pipe_read+0x2ac/0x31c
Jan 17 18:09:02 vosztok kernel:  [<c015d740>] pipe_read+0x2ac/0x31c
Jan 17 18:09:02 vosztok kernel:  [do_sync_read+198/265] do_sync_read+0xc6/0=
x109
Jan 17 18:09:02 vosztok kernel:  [<c01576e6>] do_sync_read+0xc6/0x109
Jan 17 18:09:02 vosztok kernel:  [copy_page_range+681/740] copy_page_range+=
0x2a9/0x2e4
Jan 17 18:09:02 vosztok kernel:  [<c014748e>] copy_page_range+0x2a9/0x2e4
Jan 17 18:09:02 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 18:09:02 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 18:09:02 vosztok kernel:  [do_sync_read+0/265] do_sync_read+0x0/0x109
Jan 17 18:09:02 vosztok kernel:  [<c0157620>] do_sync_read+0x0/0x109
Jan 17 18:09:02 vosztok kernel:  [vfs_read+136/266] vfs_read+0x88/0x10a
Jan 17 18:09:02 vosztok kernel:  [<c0157e5f>] vfs_read+0x88/0x10a
Jan 17 18:09:02 vosztok kernel:  [sys_read+65/103] sys_read+0x41/0x67
Jan 17 18:09:02 vosztok kernel:  [<c01581c6>] sys_read+0x41/0x67
Jan 17 18:09:02 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 18:09:02 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 18:09:02 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:02 vosztok kernel: runscript.sh  S ddfca080     0 10686  10321
Jan 17 18:09:02 vosztok kernel:        d8211f34 00000086 c16a1104 ddfca080 =
d24f61c0 00000000 ffffffff 00000001=20
Jan 17 18:09:02 vosztok kernel:        db97ea80 00000000 c011a464 000001e4 =
ddfca080 ffffffff cf1ff7e8 00000004=20
Jan 17 18:09:02 vosztok kernel:        ffffffff c16a0fc0 00000001 00000001 =
00000000 c16a10a4 c01173a2 00000000=20
Jan 17 18:09:02 vosztok kernel: Call Trace:
Jan 17 18:09:02 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 18:09:02 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 18:09:02 vosztok kernel:  [do_fork+252/443] do_fork+0xfc/0x1bb
Jan 17 18:09:02 vosztok kernel:  [<c01173a2>] do_fork+0xfc/0x1bb
Jan 17 18:09:02 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 18:09:02 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 18:09:02 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 18:09:02 vosztok kernel:  [sys_waitpid+39/43] sys_waitpid+0x27/0x2b
Jan 17 18:09:02 vosztok kernel:  [<c011a59e>] sys_waitpid+0x27/0x2b
Jan 17 18:09:02 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:02 vosztok kernel: ip            D d8375dc4     0 10687  10686
Jan 17 18:09:02 vosztok kernel:        d8375da8 00000086 db97ebc4 d8375dc4 =
cfa4b000 00002f48 c16d21c0 db97ea80=20
Jan 17 18:09:02 vosztok kernel:        c16d2158 c16d21c0 c036ccbe dbe7ded0 =
c16d21c4 db97ea80 df1ea280 00000000=20
Jan 17 18:09:02 vosztok kernel:        c036cae9 c015df44 d8375e1c d8375e10 =
d8375f30 de70f200 237ddf4f d8375f30=20
Jan 17 18:09:02 vosztok kernel: Call Trace:
Jan 17 18:09:02 vosztok kernel:  [__mutex_lock_slowpath+101/174] __mutex_lo=
ck_slowpath+0x65/0xae
Jan 17 18:09:02 vosztok kernel:  [<c036ccbe>] __mutex_lock_slowpath+0x65/0x=
ae
Jan 17 18:09:02 vosztok kernel:  [mutex_lock+9/10] mutex_lock+0x9/0xa
Jan 17 18:09:02 vosztok kernel:  [<c036cae9>] mutex_lock+0x9/0xa
Jan 17 18:09:02 vosztok kernel:  [do_lookup+105/320] do_lookup+0x69/0x140
Jan 17 18:09:02 vosztok kernel:  [<c015df44>] do_lookup+0x69/0x140
Jan 17 18:09:02 vosztok kernel:  [__link_path_walk+805/3072] __link_path_wa=
lk+0x325/0xc00
Jan 17 18:09:02 vosztok kernel:  [<c015f32a>] __link_path_walk+0x325/0xc00
Jan 17 18:09:02 vosztok kernel:  [link_path_walk+66/175] link_path_walk+0x4=
2/0xaf
Jan 17 18:09:02 vosztok kernel:  [<c015fc47>] link_path_walk+0x42/0xaf
Jan 17 18:09:02 vosztok kernel:  [get_unused_fd_flags+186/215] get_unused_f=
d_flags+0xba/0xd7
Jan 17 18:09:02 vosztok kernel:  [<c01561a6>] get_unused_fd_flags+0xba/0xd7
Jan 17 18:09:02 vosztok kernel:  [do_path_lookup+411/438] do_path_lookup+0x=
19b/0x1b6
Jan 17 18:09:02 vosztok kernel:  [<c015ffbf>] do_path_lookup+0x19b/0x1b6
Jan 17 18:09:02 vosztok kernel:  [get_empty_filp+131/252] get_empty_filp+0x=
83/0xfc
Jan 17 18:09:02 vosztok kernel:  [<c0158903>] get_empty_filp+0x83/0xfc
Jan 17 18:09:02 vosztok kernel:  [__path_lookup_intent_open+69/117] __path_=
lookup_intent_open+0x45/0x75
Jan 17 18:09:02 vosztok kernel:  [<c0160914>] __path_lookup_intent_open+0x4=
5/0x75
Jan 17 18:09:02 vosztok kernel:  [path_lookup_open+32/37] path_lookup_open+=
0x20/0x25
Jan 17 18:09:02 vosztok kernel:  [<c01609b8>] path_lookup_open+0x20/0x25
Jan 17 18:09:02 vosztok kernel:  [open_namei+110/1347] open_namei+0x6e/0x543
Jan 17 18:09:02 vosztok kernel:  [<c0160aae>] open_namei+0x6e/0x543
Jan 17 18:09:02 vosztok kernel:  [do_filp_open+37/57] do_filp_open+0x25/0x39
Jan 17 18:09:02 vosztok kernel:  [<c0156421>] do_filp_open+0x25/0x39
Jan 17 18:09:02 vosztok kernel:  [get_unused_fd_flags+186/215] get_unused_f=
d_flags+0xba/0xd7
Jan 17 18:09:02 vosztok kernel:  [<c01561a6>] get_unused_fd_flags+0xba/0xd7
Jan 17 18:09:02 vosztok kernel:  [do_sys_open+68/197] do_sys_open+0x44/0xc5
Jan 17 18:09:02 vosztok kernel:  [<c0156479>] do_sys_open+0x44/0xc5
Jan 17 18:09:02 vosztok kernel:  [sys_open+28/30] sys_open+0x1c/0x1e
Jan 17 18:09:02 vosztok kernel:  [<c0156533>] sys_open+0x1c/0x1e
Jan 17 18:09:02 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 18:09:02 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 18:09:02 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 18:09:02 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 18:09:15 vosztok kernel: SysRq : Emergency Sync
Jan 17 18:09:21 vosztok kernel: SysRq : Emergency Remount R/O
Jan 17 18:11:01 vosztok kernel: klogd 1.4.1, log source =3D /proc/kmsg star=
ted.
Jan 17 18:11:01 vosztok kernel: Inspecting /boot/System.map
Jan 17 18:11:01 vosztok kernel: Loaded 28989 symbols from /boot/System.map.
Jan 17 18:11:01 vosztok kernel: Symbols match kernel version 2.6.23.
Jan 17 18:11:01 vosztok kernel: Linux version 2.6.23-gentoo-r5 (root@voszto=
k) (gcc version 4.1.2 (Gentoo 4.1.2)) #1 PREEMPT Thu Jan 17 14:05:39 CET 20=
08
Jan 17 18:11:01 vosztok kernel: BIOS-provided physical RAM map:
Jan 17 18:11:01 vosztok kernel:  BIOS-e820: 0000000000000000 - 000000000009=
f000 (usable)
Jan 17 18:11:01 vosztok kernel:  BIOS-e820: 000000000009f000 - 00000000000a=
0000 (reserved)
Jan 17 18:11:01 vosztok kernel:  BIOS-e820: 00000000000dc000 - 000000000010=
0000 (reserved)
Jan 17 18:11:01 vosztok kernel:  BIOS-e820: 0000000000100000 - 000000001f6e=
0000 (usable)
Jan 17 18:11:01 vosztok kernel:  BIOS-e820: 000000001f6e0000 - 000000001f6f=
7000 (ACPI data)
Jan 17 18:11:01 vosztok kernel:  BIOS-e820: 000000001f6f7000 - 000000001f6f=
9000 (ACPI NVS)
Jan 17 18:11:01 vosztok kernel:  BIOS-e820: 000000001f700000 - 000000002000=
0000 (reserved)
Jan 17 18:11:01 vosztok kernel:  BIOS-e820: 00000000ff800000 - 000000010000=
0000 (reserved)
Jan 17 18:11:01 vosztok kernel: 502MB LOWMEM available.
Jan 17 18:11:01 vosztok kernel: Entering add_active_range(0, 0, 128736) 0 e=
ntries of 256 used
Jan 17 18:11:01 vosztok kernel: Zone PFN ranges:
Jan 17 18:11:01 vosztok kernel:   DMA             0 ->     4096
Jan 17 18:11:01 vosztok kernel:   Normal       4096 ->   128736
Jan 17 18:11:01 vosztok kernel: Movable zone start PFN for each node
Jan 17 18:11:01 vosztok kernel: early_node_map[1] active PFN ranges
Jan 17 18:11:01 vosztok kernel:     0:        0 ->   128736
Jan 17 18:11:01 vosztok kernel: On node 0 totalpages: 128736
Jan 17 18:11:01 vosztok kernel:   DMA zone: 32 pages used for memmap
Jan 17 18:11:01 vosztok kernel:   DMA zone: 0 pages reserved
Jan 17 18:11:01 vosztok kernel:   DMA zone: 4064 pages, LIFO batch:0
Jan 17 18:11:01 vosztok kernel:   Normal zone: 973 pages used for memmap
Jan 17 18:11:01 vosztok kernel:   Normal zone: 123667 pages, LIFO batch:31
Jan 17 18:11:01 vosztok kernel:   Movable zone: 0 pages used for memmap
Jan 17 18:11:01 vosztok kernel: DMI present.
Jan 17 18:11:01 vosztok kernel: ACPI: RSDP 000F6E40, 0024 (r2 IBM   )
Jan 17 18:11:01 vosztok kernel: ACPI: XSDT 1F6EF33D, 004C (r1 IBM    TP-1W =
       2050  LTP        0)
Jan 17 18:11:01 vosztok kernel: ACPI: FACP 1F6EF400, 00F4 (r3 IBM    TP-1W =
       2050 IBM         1)
Jan 17 18:11:01 vosztok kernel: ACPI Warning (tbfadt-0442): Optional field =
"Gpe1Block" has zero address or length: 000000000000102C/0 [20070126]
Jan 17 18:11:01 vosztok kernel: ACPI: DSDT 1F6EF5E7, 7865 (r1 IBM    TP-1W =
       2050 MSFT  100000E)
Jan 17 18:11:01 vosztok kernel: ACPI: FACS 1F6F8000, 0040
Jan 17 18:11:01 vosztok kernel: ACPI: SSDT 1F6EF5B4, 0033 (r1 IBM    TP-1W =
       2050 MSFT  100000E)
Jan 17 18:11:01 vosztok kernel: ACPI: ECDT 1F6F6E4C, 0052 (r1 IBM    TP-1W =
       2050 IBM         1)
Jan 17 18:11:01 vosztok kernel: ACPI: TCPA 1F6F6E9E, 0032 (r1 IBM    TP-1W =
       2050 PTL         1)
Jan 17 18:11:01 vosztok kernel: ACPI: BOOT 1F6F6FD8, 0028 (r1 IBM    TP-1W =
       2050  LTP        1)
Jan 17 18:11:01 vosztok kernel: ACPI: PM-Timer IO Port: 0x1008
Jan 17 18:11:01 vosztok kernel: Allocating PCI resources starting at 300000=
00 (gap: 20000000:df800000)
Jan 17 18:11:01 vosztok kernel: swsusp: Registered nosave memory region: 00=
0000000009f000 - 00000000000a0000
Jan 17 18:11:01 vosztok kernel: swsusp: Registered nosave memory region: 00=
000000000a0000 - 00000000000dc000
Jan 17 18:11:01 vosztok kernel: swsusp: Registered nosave memory region: 00=
000000000dc000 - 0000000000100000
Jan 17 18:11:01 vosztok kernel: Built 1 zonelists in Zone order.  Total pag=
es: 127731
Jan 17 18:11:01 vosztok kernel: Kernel command line: dolvm real_root=3DLABE=
L=3Dvosztok-root vga=3D792 nolapic CONSOLE=3D/dev/tty1 splash=3Dsilent,fade=
in,theme:livecd-2006.1,tty:12 quiet=20
Jan 17 18:11:01 vosztok kernel: mapped APIC to ffffb000 (013f3000)
Jan 17 18:11:01 vosztok kernel: Enabling fast FPU save and restore... done.
Jan 17 18:11:01 vosztok kernel: Enabling unmasked SIMD FPU exception suppor=
t... done.
Jan 17 18:11:01 vosztok kernel: Initializing CPU#0
Jan 17 18:11:01 vosztok kernel: PID hash table entries: 2048 (order: 11, 81=
92 bytes)
Jan 17 18:11:01 vosztok kernel: Detected 1598.704 MHz processor.
Jan 17 18:11:01 vosztok kernel: Console: colour dummy device 80x25
Jan 17 18:11:01 vosztok kernel: console [tty0] enabled
Jan 17 18:11:01 vosztok kernel: Dentry cache hash table entries: 65536 (ord=
er: 6, 262144 bytes)
Jan 17 18:11:01 vosztok kernel: Inode-cache hash table entries: 32768 (orde=
r: 5, 131072 bytes)
Jan 17 18:11:01 vosztok kernel: Memory: 504308k/514944k available (2489k ke=
rnel code, 10096k reserved, 836k data, 192k init, 0k highmem)
Jan 17 18:11:01 vosztok kernel: virtual kernel memory layout:
Jan 17 18:11:01 vosztok kernel:     fixmap  : 0xfffb5000 - 0xfffff000   ( 2=
96 kB)
Jan 17 18:11:01 vosztok kernel:     vmalloc : 0xe0000000 - 0xfffb3000   ( 5=
11 MB)
Jan 17 18:11:01 vosztok kernel:     lowmem  : 0xc0000000 - 0xdf6e0000   ( 5=
02 MB)
Jan 17 18:11:01 vosztok kernel:       .init : 0xc0442000 - 0xc0472000   ( 1=
92 kB)
Jan 17 18:11:01 vosztok kernel:       .data : 0xc036e6c1 - 0xc043f854   ( 8=
36 kB)
Jan 17 18:11:01 vosztok kernel:       .text : 0xc0100000 - 0xc036e6c1   (24=
89 kB)
Jan 17 18:11:01 vosztok kernel: Checking if this processor honours the WP b=
it even in supervisor mode... Ok.
Jan 17 18:11:01 vosztok kernel: SLUB: Genslabs=3D22, HWalign=3D64, Order=3D=
0-1, MinObjects=3D4, CPUs=3D1, Nodes=3D1
Jan 17 18:11:01 vosztok kernel: Calibrating delay using timer specific rout=
ine.. 3198.28 BogoMIPS (lpj=3D1599143)
Jan 17 18:11:01 vosztok kernel: Mount-cache hash table entries: 512
Jan 17 18:11:01 vosztok kernel: CPU: After generic identify, caps: afe9f9bf=
 00000000 00000000 00000000 00000180 00000000 00000000 00000000
Jan 17 18:11:01 vosztok kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Jan 17 18:11:01 vosztok kernel: CPU: L2 cache: 2048K
Jan 17 18:11:01 vosztok kernel: CPU: After all inits, caps: afe9f9bf 000000=
00 00000000 00002040 00000180 00000000 00000000 00000000
Jan 17 18:11:01 vosztok kernel: Compat vDSO mapped to ffffe000.
Jan 17 18:11:01 vosztok kernel: CPU: Intel(R) Pentium(R) M processor 1.60GH=
z stepping 06
Jan 17 18:11:01 vosztok kernel: Checking 'hlt' instruction... OK.
Jan 17 18:11:01 vosztok kernel: ACPI: Core revision 20070126
Jan 17 18:11:01 vosztok kernel: ACPI: setting ELCR to 0200 (from 0820)
Jan 17 18:11:01 vosztok kernel: NET: Registered protocol family 16
Jan 17 18:11:01 vosztok kernel: ACPI: bus type pci registered
Jan 17 18:11:01 vosztok kernel: PCI: PCI BIOS revision 2.10 entry at 0xfd8c=
6, last bus=3D5
Jan 17 18:11:01 vosztok kernel: PCI: Using configuration type 1
Jan 17 18:11:01 vosztok kernel: Setting up standard PCI resources
Jan 17 18:11:01 vosztok kernel: ACPI: EC: EC description table is found, co=
nfiguring boot EC
Jan 17 18:11:01 vosztok kernel:=20
Jan 17 18:11:01 vosztok kernel: ACPI: Interpreter enabled
Jan 17 18:11:01 vosztok kernel: ACPI: (supports S0 S3 S4 S5)
Jan 17 18:11:01 vosztok kernel: ACPI: Using PIC for interrupt routing
Jan 17 18:11:01 vosztok kernel: ACPI: EC: GPE =3D 0x1c, I/O: command/status=
 =3D 0x66, data =3D 0x62
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Root Bridge [PCI0] (0000:00)
Jan 17 18:11:01 vosztok kernel: PCI quirk: region 1000-107f claimed by ICH4=
 ACPI/GPIO/TCO
Jan 17 18:11:01 vosztok kernel: PCI quirk: region 1180-11bf claimed by ICH4=
 GPIO
Jan 17 18:11:01 vosztok kernel: PCI: Transparent bridge - 0000:00:1e.0
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PC=
I0._PRT]
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PC=
I0.PCI1._PRT]
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5=
 6 7 9 10 *11)
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *=
5 6 7 9 10 11)
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5=
 6 7 9 10 *11)
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5=
 6 7 9 10 *11)
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5=
 6 7 9 10 *11)
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5=
 6 7 9 10 *11)
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5=
 6 7 9 10 11) *0, disabled.
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5=
 6 7 9 10 *11)
Jan 17 18:11:01 vosztok kernel: ACPI: Power Resource [PUBS] (on)
Jan 17 18:11:01 vosztok kernel: Linux Plug and Play Support v0.97 (c) Adam =
Belay
Jan 17 18:11:01 vosztok kernel: pnp: PnP ACPI init
Jan 17 18:11:01 vosztok kernel: ACPI: bus type pnp registered
Jan 17 18:11:01 vosztok kernel: pnp: PnP ACPI: found 10 devices
Jan 17 18:11:01 vosztok kernel: ACPI: ACPI bus type pnp unregistered
Jan 17 18:11:01 vosztok kernel: SCSI subsystem initialized
Jan 17 18:11:01 vosztok kernel: libata version 2.21 loaded.
Jan 17 18:11:01 vosztok kernel: PCI: Using ACPI for IRQ routing
Jan 17 18:11:01 vosztok kernel: PCI: If a device doesn't work, try "pci=3Dr=
outeirq".  If it helps, post a report
Jan 17 18:11:01 vosztok kernel: ACPI: RTC can wake from S4
Jan 17 18:11:01 vosztok kernel: Time: tsc clocksource has been installed.
Jan 17 18:11:01 vosztok kernel: pnp: 00:00: iomem range 0x0-0x9ffff could n=
ot be reserved
Jan 17 18:11:01 vosztok kernel: pnp: 00:00: iomem range 0xc0000-0xc3fff cou=
ld not be reserved
Jan 17 18:11:01 vosztok kernel: pnp: 00:00: iomem range 0xc4000-0xc7fff cou=
ld not be reserved
Jan 17 18:11:01 vosztok kernel: pnp: 00:00: iomem range 0xc8000-0xcbfff has=
 been reserved
Jan 17 18:11:01 vosztok kernel: PCI: Bus 3, cardbus bridge: 0000:02:00.0
Jan 17 18:11:01 vosztok kernel:   IO window: 00003000-000030ff
Jan 17 18:11:01 vosztok kernel:   IO window: 00003400-000034ff
Jan 17 18:11:01 vosztok kernel:   PREFETCH window: f0000000-f3ffffff
Jan 17 18:11:01 vosztok kernel:   MEM window: d4000000-d7ffffff
Jan 17 18:11:01 vosztok kernel: PCI: Bridge: 0000:00:1e.0
Jan 17 18:11:01 vosztok kernel:   IO window: 3000-7fff
Jan 17 18:11:01 vosztok kernel:   MEM window: d0200000-dfffffff
Jan 17 18:11:01 vosztok kernel:   PREFETCH window: f0000000-f7ffffff
Jan 17 18:11:01 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1e.0 to 64
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt Link [LNKA] enabled at =
IRQ 11
Jan 17 18:11:01 vosztok kernel: PCI: setting IRQ 11 as level-triggered
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt 0000:02:00.0[A] -> Link=
 [LNKA] -> GSI 11 (level, low) -> IRQ 11
Jan 17 18:11:01 vosztok kernel: NET: Registered protocol family 2
Jan 17 18:11:01 vosztok kernel: IP route cache hash table entries: 4096 (or=
der: 2, 16384 bytes)
Jan 17 18:11:01 vosztok kernel: TCP established hash table entries: 16384 (=
order: 5, 131072 bytes)
Jan 17 18:11:01 vosztok kernel: TCP bind hash table entries: 16384 (order: =
4, 65536 bytes)
Jan 17 18:11:01 vosztok kernel: TCP: Hash tables configured (established 16=
384 bind 16384)
Jan 17 18:11:01 vosztok kernel: TCP reno registered
Jan 17 18:11:01 vosztok kernel: checking if image is initramfs... it is
Jan 17 18:11:01 vosztok kernel: Freeing initrd memory: 1925k freed
Jan 17 18:11:01 vosztok kernel: Simple Boot Flag at 0x35 set to 0x1
Jan 17 18:11:01 vosztok kernel: SGI XFS with ACLs, security attributes, rea=
ltime, no debug enabled
Jan 17 18:11:01 vosztok kernel: SGI XFS Quota Management subsystem
Jan 17 18:11:01 vosztok kernel: io scheduler noop registered
Jan 17 18:11:01 vosztok kernel: io scheduler cfq registered (default)
Jan 17 18:11:01 vosztok kernel: Boot video device is 0000:00:02.0
Jan 17 18:11:01 vosztok kernel: PCI: Firmware left 0000:02:08.0 e100 interr=
upts enabled, disabling
Jan 17 18:11:01 vosztok kernel: Non-volatile memory driver v1.2
Jan 17 18:11:01 vosztok kernel: Linux agpgart interface v0.102
Jan 17 18:11:01 vosztok kernel: agpgart: Detected an Intel 855GM Chipset.
Jan 17 18:11:01 vosztok kernel: agpgart: Detected 8060K stolen memory.
Jan 17 18:11:01 vosztok kernel: agpgart: AGP aperture is 128M @ 0xe0000000
Jan 17 18:11:01 vosztok kernel: vesafb: framebuffer at 0xe0000000, mapped t=
o 0xe0180000, using 6144k, total 8000k
Jan 17 18:11:01 vosztok kernel: vesafb: mode is 1024x768x32, linelength=3D4=
096, pages=3D1
Jan 17 18:11:01 vosztok kernel: vesafb: scrolling: redraw
Jan 17 18:11:01 vosztok kernel: vesafb: Truecolor: size=3D8:8:8:8, shift=3D=
24:16:8:0
Jan 17 18:11:01 vosztok kernel: Console: switching to colour frame buffer d=
evice 128x48
Jan 17 18:11:01 vosztok kernel: fbcondecor: console 0 using theme 'livecd-2=
006.1'
Jan 17 18:11:01 vosztok kernel: fbcondecor: switched decor state to 'on' on=
 console 0
Jan 17 18:11:01 vosztok kernel: fb0: VESA VGA frame buffer device
Jan 17 18:11:01 vosztok kernel: ACPI: AC Adapter [AC] (on-line)
Jan 17 18:11:01 vosztok kernel: ACPI: Battery Slot [BAT0] (battery absent)
Jan 17 18:11:01 vosztok kernel: input: Power Button (FF) as /devices/virtua=
l/input/input0
Jan 17 18:11:01 vosztok kernel: ACPI: Power Button (FF) [PWRF]
Jan 17 18:11:01 vosztok kernel: input: Lid Switch as /devices/virtual/input=
/input1
Jan 17 18:11:01 vosztok kernel: ACPI: Lid Switch [LID]
Jan 17 18:11:01 vosztok kernel: input: Sleep Button (CM) as /devices/virtua=
l/input/input2
Jan 17 18:11:01 vosztok kernel: ACPI: Sleep Button (CM) [SLPB]
Jan 17 18:11:01 vosztok kernel: ACPI: CPU0 (power states: C1[C1] C2[C2] C3[=
C3])
Jan 17 18:11:01 vosztok kernel: ACPI: Processor [CPU] (supports 8 throttlin=
g states)
Jan 17 18:11:01 vosztok kernel: ACPI: Thermal Zone [THM0] (51 C)
Jan 17 18:11:01 vosztok kernel: intelfb: intelfb_init
Jan 17 18:11:01 vosztok kernel: intelfb: Framebuffer driver for Intel(R) 83=
0M/845G/852GM/855GM/865G/915G/915GM/945G/945GM chipsets
Jan 17 18:11:01 vosztok kernel: intelfb: Version 0.9.4
Jan 17 18:11:01 vosztok kernel: intelfb: intelfb_setup
Jan 17 18:11:01 vosztok kernel: intelfb: no options
Jan 17 18:11:01 vosztok kernel: intelfb: intelfb_pci_register
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt 0000:00:02.0[A] -> Link=
 [LNKA] -> GSI 11 (level, low) -> IRQ 11
Jan 17 18:11:01 vosztok kernel: intelfb: fb aperture: 0xe0000000/0x8000000,=
 MMIO region: 0xd0000000/0x80000
Jan 17 18:11:01 vosztok kernel: intelfb: Cannot reserve FB region.
Jan 17 18:11:01 vosztok kernel: intelfb: cleanup
Jan 17 18:11:01 vosztok kernel: RAMDISK driver initialized: 16 RAM disks of=
 8192K size 1024 blocksize
Jan 17 18:11:01 vosztok kernel: loop: module loaded
Jan 17 18:11:01 vosztok kernel: thinkpad_acpi: ThinkPad ACPI Extras v0.16
Jan 17 18:11:01 vosztok kernel: thinkpad_acpi: http://ibm-acpi.sf.net/
Jan 17 18:11:01 vosztok kernel: thinkpad_acpi: ThinkPad BIOS 1WET85WW (2.05=
 ), EC 1VHT28WW-1.04
Jan 17 18:11:01 vosztok kernel: thinkpad_acpi: IBM ThinkPad R50e
Jan 17 18:11:01 vosztok kernel: Switched to high resolution mode on CPU 0
Jan 17 18:11:01 vosztok kernel: input: ThinkPad Extra Buttons as /devices/v=
irtual/input/input3
Jan 17 18:11:01 vosztok kernel: e100: Intel(R) PRO/100 Network Driver, 3.5.=
23-k4-NAPI
Jan 17 18:11:01 vosztok kernel: e100: Copyright(c) 1999-2006 Intel Corporat=
ion
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt Link [LNKE] enabled at =
IRQ 11
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt 0000:02:08.0[A] -> Link=
 [LNKE] -> GSI 11 (level, low) -> IRQ 11
Jan 17 18:11:01 vosztok kernel: e100: eth0: e100_probe: addr 0xd0201000, ir=
q 11, MAC addr 00:0A:E4:34:7E:7F
Jan 17 18:11:01 vosztok kernel: ata_piix 0000:00:1f.1: version 2.12
Jan 17 18:11:01 vosztok kernel: PCI: Enabling device 0000:00:1f.1 (0005 -> =
0007)
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt Link [LNKC] enabled at =
IRQ 11
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link=
 [LNKC] -> GSI 11 (level, low) -> IRQ 11
Jan 17 18:11:01 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1f.1 to 64
Jan 17 18:11:01 vosztok kernel: scsi0 : ata_piix
Jan 17 18:11:01 vosztok kernel: scsi1 : ata_piix
Jan 17 18:11:01 vosztok kernel: ata1: PATA max UDMA/100 cmd 0x000101f0 ctl =
0x000103f6 bmdma 0x00011810 irq 14
Jan 17 18:11:01 vosztok kernel: ata2: PATA max UDMA/100 cmd 0x00010170 ctl =
0x00010376 bmdma 0x00011818 irq 15
Jan 17 18:11:01 vosztok kernel: ata1.00: ATA-6: HTS424040M9AT00, MA2IA75A, =
max UDMA/100
Jan 17 18:11:01 vosztok kernel: ata1.00: 78140160 sectors, multi 16: LBA=20
Jan 17 18:11:01 vosztok kernel: ata1.00: configured for UDMA/100
Jan 17 18:11:01 vosztok kernel: ata2.00: ATAPI: MATSHITADVD-RAM UJ-830Sx, 1=
.00, max UDMA/33
Jan 17 18:11:01 vosztok kernel: ata2.00: configured for UDMA/33
Jan 17 18:11:01 vosztok kernel: scsi 0:0:0:0: Direct-Access     ATA      HT=
S424040M9AT00  MA2I PQ: 0 ANSI: 5
Jan 17 18:11:01 vosztok kernel: sd 0:0:0:0: [sda] 78140160 512-byte hardwar=
e sectors (40008 MB)
Jan 17 18:11:01 vosztok kernel: sd 0:0:0:0: [sda] Write Protect is off
Jan 17 18:11:01 vosztok kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jan 17 18:11:01 vosztok kernel: sd 0:0:0:0: [sda] Write cache: enabled, rea=
d cache: enabled, doesn't support DPO or FUA
Jan 17 18:11:01 vosztok kernel: sd 0:0:0:0: [sda] 78140160 512-byte hardwar=
e sectors (40008 MB)
Jan 17 18:11:01 vosztok kernel: sd 0:0:0:0: [sda] Write Protect is off
Jan 17 18:11:01 vosztok kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jan 17 18:11:01 vosztok kernel: sd 0:0:0:0: [sda] Write cache: enabled, rea=
d cache: enabled, doesn't support DPO or FUA
Jan 17 18:11:01 vosztok kernel:  sda: sda1 sda2
Jan 17 18:11:01 vosztok kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Jan 17 18:11:01 vosztok kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Jan 17 18:11:01 vosztok kernel: scsi 1:0:0:0: CD-ROM            MATSHITA DV=
D-RAM UJ-830Sx 1.00 PQ: 0 ANSI: 5
Jan 17 18:11:01 vosztok kernel: sr0: scsi3-mmc drive: 24x/24x writer dvd-ra=
m cd/rw xa/form2 cdda tray
Jan 17 18:11:01 vosztok kernel: Uniform CD-ROM driver Revision: 3.20
Jan 17 18:11:01 vosztok kernel: sr 1:0:0:0: Attached scsi CD-ROM sr0
Jan 17 18:11:01 vosztok kernel: sr 1:0:0:0: Attached scsi generic sg1 type 5
Jan 17 18:11:01 vosztok kernel: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:M=
OU] at 0x60,0x64 irq 1,12
Jan 17 18:11:01 vosztok kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Jan 17 18:11:01 vosztok kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Jan 17 18:11:01 vosztok kernel: mice: PS/2 mouse device common for all mice
Jan 17 18:11:01 vosztok kernel: input: AT Translated Set 2 keyboard as /dev=
ices/platform/i8042/serio0/input/input4
Jan 17 18:11:01 vosztok kernel: device-mapper: ioctl: 4.11.0-ioctl (2006-10=
-12) initialised: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Jan 17 18:11:01 vosztok kernel: TCP cubic registered
Jan 17 18:11:01 vosztok kernel: NET: Registered protocol family 1
Jan 17 18:11:01 vosztok kernel: NET: Registered protocol family 10
Jan 17 18:11:01 vosztok kernel: lo: Disabled Privacy Extensions
Jan 17 18:11:01 vosztok kernel: Mobile IPv6
Jan 17 18:11:01 vosztok kernel: NET: Registered protocol family 17
Jan 17 18:11:01 vosztok kernel: Using IPI Shortcut mode
Jan 17 18:11:01 vosztok kernel: Freeing unused kernel memory: 192k freed
Jan 17 18:11:01 vosztok kernel: IBM TrackPoint firmware: 0x0e, buttons: 3/3
Jan 17 18:11:01 vosztok kernel: input: TPPS/2 IBM TrackPoint as /devices/pl=
atform/i8042/serio1/input/input5
Jan 17 18:11:01 vosztok kernel: ata1: soft resetting port
Jan 17 18:11:01 vosztok kernel: ata1.00: configured for UDMA/100
Jan 17 18:11:01 vosztok kernel: ata1: EH complete
Jan 17 18:11:01 vosztok kernel: sd 0:0:0:0: [sda] 78140160 512-byte hardwar=
e sectors (40008 MB)
Jan 17 18:11:01 vosztok kernel: sd 0:0:0:0: [sda] Write Protect is off
Jan 17 18:11:01 vosztok kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jan 17 18:11:01 vosztok kernel: sd 0:0:0:0: [sda] Write cache: enabled, rea=
d cache: enabled, doesn't support DPO or FUA
Jan 17 18:11:01 vosztok kernel: usbcore: registered new interface driver us=
bfs
Jan 17 18:11:01 vosztok kernel: usbcore: registered new interface driver hub
Jan 17 18:11:01 vosztok kernel: usbcore: registered new device driver usb
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt Link [LNKH] enabled at =
IRQ 11
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link=
 [LNKH] -> GSI 11 (level, low) -> IRQ 11
Jan 17 18:11:01 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1d.7 to 64
Jan 17 18:11:01 vosztok kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller
Jan 17 18:11:01 vosztok kernel: ehci_hcd 0000:00:1d.7: new USB bus register=
ed, assigned bus number 1
Jan 17 18:11:01 vosztok kernel: ehci_hcd 0000:00:1d.7: debug port 1
Jan 17 18:11:01 vosztok kernel: PCI: cache line size of 32 is not supported=
 by device 0000:00:1d.7
Jan 17 18:11:01 vosztok kernel: ehci_hcd 0000:00:1d.7: irq 11, io mem 0xd01=
00000
Jan 17 18:11:01 vosztok kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHC=
I 1.00, driver 10 Dec 2004
Jan 17 18:11:01 vosztok kernel: usb usb1: configuration #1 chosen from 1 ch=
oice
Jan 17 18:11:01 vosztok kernel: hub 1-0:1.0: USB hub found
Jan 17 18:11:01 vosztok kernel: hub 1-0:1.0: 6 ports detected
Jan 17 18:11:01 vosztok kernel: Initializing USB Mass Storage driver...
Jan 17 18:11:01 vosztok kernel: usbcore: registered new interface driver us=
b-storage
Jan 17 18:11:01 vosztok kernel: USB Mass Storage support registered.
Jan 17 18:11:01 vosztok kernel: USB Universal Host Controller Interface dri=
ver v3.0
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link=
 [LNKA] -> GSI 11 (level, low) -> IRQ 11
Jan 17 18:11:01 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1d.0 to 64
Jan 17 18:11:01 vosztok kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller
Jan 17 18:11:01 vosztok kernel: uhci_hcd 0000:00:1d.0: new USB bus register=
ed, assigned bus number 2
Jan 17 18:11:01 vosztok kernel: uhci_hcd 0000:00:1d.0: irq 11, io base 0x00=
001820
Jan 17 18:11:01 vosztok kernel: usb usb2: configuration #1 chosen from 1 ch=
oice
Jan 17 18:11:01 vosztok kernel: hub 2-0:1.0: USB hub found
Jan 17 18:11:01 vosztok kernel: hub 2-0:1.0: 2 ports detected
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt Link [LNKD] enabled at =
IRQ 11
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link=
 [LNKD] -> GSI 11 (level, low) -> IRQ 11
Jan 17 18:11:01 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1d.1 to 64
Jan 17 18:11:01 vosztok kernel: uhci_hcd 0000:00:1d.1: UHCI Host Controller
Jan 17 18:11:01 vosztok kernel: uhci_hcd 0000:00:1d.1: new USB bus register=
ed, assigned bus number 3
Jan 17 18:11:01 vosztok kernel: uhci_hcd 0000:00:1d.1: irq 11, io base 0x00=
001840
Jan 17 18:11:01 vosztok kernel: usb usb3: configuration #1 chosen from 1 ch=
oice
Jan 17 18:11:01 vosztok kernel: hub 3-0:1.0: USB hub found
Jan 17 18:11:01 vosztok kernel: hub 3-0:1.0: 2 ports detected
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link=
 [LNKC] -> GSI 11 (level, low) -> IRQ 11
Jan 17 18:11:01 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1d.2 to 64
Jan 17 18:11:01 vosztok kernel: uhci_hcd 0000:00:1d.2: UHCI Host Controller
Jan 17 18:11:01 vosztok kernel: uhci_hcd 0000:00:1d.2: new USB bus register=
ed, assigned bus number 4
Jan 17 18:11:01 vosztok kernel: uhci_hcd 0000:00:1d.2: irq 11, io base 0x00=
001860
Jan 17 18:11:01 vosztok kernel: usb usb4: configuration #1 chosen from 1 ch=
oice
Jan 17 18:11:01 vosztok kernel: hub 4-0:1.0: USB hub found
Jan 17 18:11:01 vosztok kernel: hub 4-0:1.0: 2 ports detected
Jan 17 18:11:01 vosztok kernel: usb 3-1: new low speed USB device using uhc=
i_hcd and address 2
Jan 17 18:11:01 vosztok kernel: usb 3-1: configuration #1 chosen from 1 cho=
ice
Jan 17 18:11:01 vosztok kernel: usbcore: registered new interface driver hi=
ddev
Jan 17 18:11:01 vosztok kernel: input: HID 062a:0000 as /devices/pci0000:00=
/0000:00:1d.1/usb3/3-1/3-1:1.0/input/input6
Jan 17 18:11:01 vosztok kernel: input: USB HID v1.10 Mouse [HID 062a:0000] =
on usb-0000:00:1d.1-1
Jan 17 18:11:01 vosztok kernel: usbcore: registered new interface driver us=
bhid
Jan 17 18:11:01 vosztok kernel: drivers/hid/usbhid/hid-core.c: v2.6:USB HID=
 core driver
Jan 17 18:11:01 vosztok kernel: Marking TSC unstable due to: possible TSC h=
alt in C2.
Jan 17 18:11:01 vosztok kernel: Time: acpi_pm clocksource has been installe=
d.
Jan 17 18:11:01 vosztok kernel: UDF-fs: No VRS found
Jan 17 18:11:01 vosztok kernel: Filesystem "dm-0": Disabling barriers, not =
supported by the underlying device
Jan 17 18:11:01 vosztok kernel: XFS mounting filesystem dm-0
Jan 17 18:11:01 vosztok kernel: fbcondecor: console 0 using theme 'livecd-2=
006.1'
Jan 17 18:11:01 vosztok kernel: fbcondecor: switched decor state to 'on' on=
 console 0
Jan 17 18:11:01 vosztok kernel: Ending clean XFS mount for filesystem: dm-0
Jan 17 18:11:01 vosztok kernel: Real Time Clock Driver v1.12ac
Jan 17 18:11:01 vosztok kernel: parport_pc 00:09: reported by Plug and Play=
 ACPI
Jan 17 18:11:01 vosztok kernel: parport0: PC-style at 0x3bc, irq 7 [PCSPP,T=
RISTATE]
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt Link [LNKB] enabled at =
IRQ 5
Jan 17 18:11:01 vosztok kernel: PCI: setting IRQ 5 as level-triggered
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link=
 [LNKB] -> GSI 5 (level, low) -> IRQ 5
Jan 17 18:11:01 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1f.5 to 64
Jan 17 18:11:01 vosztok kernel: ieee80211_crypt: registered algorithm 'NULL'
Jan 17 18:11:01 vosztok kernel: ieee80211: 802.11 data/management/control s=
tack, git-1.1.13
Jan 17 18:11:01 vosztok kernel: ieee80211: Copyright (C) 2004-2005 Intel Co=
rporation <jketreno-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Jan 17 18:11:01 vosztok kernel: ipw2200: Intel(R) PRO/Wireless 2200/2915 Ne=
twork Driver, 1.2.2kmprq
Jan 17 18:11:01 vosztok kernel: ipw2200: Copyright(c) 2003-2006 Intel Corpo=
ration
Jan 17 18:11:01 vosztok kernel: intel8x0_measure_ac97_clock: measured 50529=
 usecs
Jan 17 18:11:01 vosztok kernel: intel8x0: clocking to 48000
Jan 17 18:11:01 vosztok kernel: Yenta: CardBus bridge found at 0000:02:00.0=
 [1014:0512]
Jan 17 18:11:01 vosztok kernel: Yenta: Using INTVAL to route CSC interrupts=
 to PCI
Jan 17 18:11:01 vosztok kernel: Yenta: Routing CardBus interrupts to PCI
Jan 17 18:11:01 vosztok kernel: Yenta TI: socket 0000:02:00.0, mfunc 0x01d2=
1022, devctl 0x64
Jan 17 18:11:01 vosztok kernel: Yenta: ISA IRQ mask 0x0458, PCI irq 11
Jan 17 18:11:01 vosztok kernel: Socket status: 30000007
Jan 17 18:11:01 vosztok kernel: pcmcia: parent PCI bridge I/O window: 0x300=
0 - 0x7fff
Jan 17 18:11:01 vosztok kernel: pcmcia: parent PCI bridge Memory window: 0x=
d0200000 - 0xdfffffff
Jan 17 18:11:01 vosztok kernel: pcmcia: parent PCI bridge Memory window: 0x=
f0000000 - 0xf7ffffff
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt Link [LNKF] enabled at =
IRQ 11
Jan 17 18:11:01 vosztok kernel: ACPI: PCI Interrupt 0000:02:02.0[A] -> Link=
 [LNKF] -> GSI 11 (level, low) -> IRQ 11
Jan 17 18:11:01 vosztok kernel: ipw2200: Detected Intel PRO/Wireless 2200BG=
 Network Connection
Jan 17 18:11:01 vosztok kernel: ipw2200: Detected geography ZZR (14 802.11b=
g channels, 0 802.11a channels)
Jan 17 18:11:01 vosztok kernel: Filesystem "dm-0": Disabling barriers, not =
supported by the underlying device
Jan 17 18:11:01 vosztok kernel: fuse init (API version 7.8)
Jan 17 18:11:01 vosztok kernel: segctord starting. Construction interval =
=3D 5 seconds, CP frequency < 30 seconds
Jan 17 18:11:01 vosztok kernel: NILFS warning (device dm-1): nilfs_sync_sup=
er: barrier-based sync failed. disabling barriers
Jan 17 18:11:01 vosztok kernel:=20
Jan 17 18:11:01 vosztok kernel: Adding 1048568k swap on /dev/dm-2.  Priorit=
y:-1 extents:1 across:1048568k
Jan 17 18:11:01 vosztok kernel: fbcondecor: console 0 using theme 'livecd-2=
006.1'
Jan 17 18:11:01 vosztok kernel: fbcondecor: switched decor state to 'on' on=
 console 0
Jan 17 18:11:04 vosztok kernel: e100: eth0: e100_watchdog: link up, 100Mbps=
, full-duplex
Jan 17 18:11:04 vosztok kernel: Bridge firewalling registered
Jan 17 18:11:07 vosztok kernel: ieee80211_crypt: registered algorithm 'CCMP'
Jan 17 18:11:07 vosztok kernel: ieee80211_crypt: registered algorithm 'TKIP'
Jan 17 18:11:08 vosztok kernel: Clocksource tsc unstable (delta =3D -893550=
55 ns)
Jan 17 18:11:15 vosztok kernel: eth0: no IPv6 routers present
Jan 17 18:11:16 vosztok kernel: eth1: no IPv6 routers present
Jan 17 18:11:43 vosztok kernel: [drm] Initialized drm 1.1.0 20060810
Jan 17 18:11:43 vosztok kernel: [drm] Initialized i915 1.6.0 20060119 on mi=
nor 0
Jan 17 18:11:43 vosztok kernel: [drm] Initialized i915 1.6.0 20060119 on mi=
nor 1
Jan 17 18:12:00 vosztok kernel: fbcondecor: console 0 using theme 'livecd-2=
006.1'
Jan 17 18:12:00 vosztok kernel: fbcondecor: switched decor state to 'on' on=
 console 0
Jan 17 18:14:00 vosztok kernel: fbcondecor: console 0 using theme 'livecd-2=
006.1'
Jan 17 18:14:00 vosztok kernel: fbcondecor: switched decor state to 'on' on=
 console 0
Jan 17 18:15:59 vosztok kernel: fbcondecor: console 0 using theme 'livecd-2=
006.1'
Jan 17 18:15:59 vosztok kernel: fbcondecor: switched decor state to 'on' on=
 console 0
Jan 17 18:17:27 vosztok kernel: fbcondecor: console 0 using theme 'livecd-2=
006.1'
Jan 17 18:17:27 vosztok kernel: fbcondecor: switched decor state to 'on' on=
 console 0
Jan 17 18:21:16 vosztok kernel: fbcondecor: console 0 using theme 'livecd-2=
006.1'
Jan 17 18:21:16 vosztok kernel: fbcondecor: switched decor state to 'on' on=
 console 0
Jan 17 18:33:36 vosztok kernel: wmaker[10201]: segfault at 00000004 eip 080=
511bf esp bfe483c0 error 4
Jan 17 19:04:38 vosztok kernel: fbcondecor: console 0 using theme 'livecd-2=
006.1'
Jan 17 19:04:38 vosztok kernel: fbcondecor: switched decor state to 'on' on=
 console 0
Jan 17 19:04:58 vosztok kernel: fbcondecor: console 0 using theme 'livecd-2=
006.1'
Jan 17 19:04:58 vosztok kernel: fbcondecor: switched decor state to 'on' on=
 console 0
Jan 17 19:05:07 vosztok kernel: mmon+0x31/0x4f
Jan 17 19:05:07 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [core_sys_select+682/711] core_sys_select+=
0x2aa/0x2c7
Jan 17 19:05:07 vosztok kernel:  [<c0162d08>] core_sys_select+0x2aa/0x2c7
Jan 17 19:05:07 vosztok kernel:  [n_tty_receive_buf+3376/3451] n_tty_receiv=
e_buf+0xd30/0xd7b
Jan 17 19:05:07 vosztok kernel:  [<c02507f5>] n_tty_receive_buf+0xd30/0xd7b
Jan 17 19:05:07 vosztok kernel:  [check_preempt_curr_fair+82/86] check_pree=
mpt_curr_fair+0x52/0x56
Jan 17 19:05:07 vosztok kernel:  [<c0114f36>] check_preempt_curr_fair+0x52/=
0x56
Jan 17 19:05:07 vosztok kernel:  [try_to_wake_up+134/164] try_to_wake_up+0x=
86/0xa4
Jan 17 19:05:07 vosztok kernel:  [<c0114c02>] try_to_wake_up+0x86/0xa4
Jan 17 19:05:07 vosztok kernel:  [__wake_up_common+49/79] __wake_up_common+=
0x31/0x4f
Jan 17 19:05:07 vosztok kernel:  [<c01133ed>] __wake_up_common+0x31/0x4f
Jan 17 19:05:07 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [tty_wakeup+76/80] tty_wakeup+0x4c/0x50
Jan 17 19:05:07 vosztok kernel:  [<c024bb35>] tty_wakeup+0x4c/0x50
Jan 17 19:05:07 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [tty_ldisc_deref+98/124] tty_ldisc_deref+0=
x62/0x7c
Jan 17 19:05:07 vosztok kernel:  [<c024bacf>] tty_ldisc_deref+0x62/0x7c
Jan 17 19:05:07 vosztok kernel:  [sys_select+213/391] sys_select+0xd5/0x187
Jan 17 19:05:07 vosztok kernel:  [<c01630af>] sys_select+0xd5/0x187
Jan 17 19:05:07 vosztok kernel:  [vfs_write+252/268] vfs_write+0xfc/0x10c
Jan 17 19:05:07 vosztok kernel:  [<c0157dc7>] vfs_write+0xfc/0x10c
Jan 17 19:05:07 vosztok kernel:  [sys_write+65/103] sys_write+0x41/0x67
Jan 17 19:05:07 vosztok kernel:  [<c015822d>] sys_write+0x41/0x67
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: weechat-curse D 00000099     0 10229  10228
Jan 17 19:05:07 vosztok kernel:        dc075d5c 00200082 dc066144 00000099 =
d4dafa80 00000099 fffeffff df3b8c94=20
Jan 17 19:05:07 vosztok kernel:        00000000 dc066000 c023bd30 dc075d80 =
00000020 df3b8c94 df3b8c00 00000000=20
Jan 17 19:05:07 vosztok kernel:        de9db2a0 c036d592 df477e74 ced45d80 =
dc066000 00000001 df3b8c94 c036d5d3=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [rwsem_down_failed_common+328/353] rwsem_d=
own_failed_common+0x148/0x161
Jan 17 19:05:07 vosztok kernel:  [<c023bd30>] rwsem_down_failed_common+0x14=
8/0x161
Jan 17 19:05:07 vosztok kernel:  [rwsem_down_read_failed+26/36] rwsem_down_=
read_failed+0x1a/0x24
Jan 17 19:05:07 vosztok kernel:  [<c036d592>] rwsem_down_read_failed+0x1a/0=
x24
Jan 17 19:05:07 vosztok kernel:  [call_rwsem_down_read_failed+7/12] call_rw=
sem_down_read_failed+0x7/0xc
Jan 17 19:05:07 vosztok kernel:  [<c036d5d3>] call_rwsem_down_read_failed+0=
x7/0xc
Jan 17 19:05:07 vosztok kernel:  [down_read+9/10] down_read+0x9/0xa
Jan 17 19:05:07 vosztok kernel:  [<c012a885>] down_read+0x9/0xa
Jan 17 19:05:07 vosztok kernel:  [<e08caf2c>] nilfs_transaction_begin+0xd4/=
0x150 [nilfs2]
Jan 17 19:05:07 vosztok kernel:  [__rcu_process_callbacks+288/382] __rcu_pr=
ocess_callbacks+0x120/0x17e
Jan 17 19:05:07 vosztok kernel:  [<c01259e5>] __rcu_process_callbacks+0x120=
/0x17e
Jan 17 19:05:07 vosztok kernel:  [<e08cafc6>] nilfs_dirty_inode+0x1e/0x40 [=
nilfs2]
Jan 17 19:05:07 vosztok kernel:  [__rcu_process_callbacks+288/382] __rcu_pr=
ocess_callbacks+0x120/0x17e
Jan 17 19:05:07 vosztok kernel:  [<c01259e5>] __rcu_process_callbacks+0x120=
/0x17e
Jan 17 19:05:07 vosztok kernel:  [__mark_inode_dirty+36/360] __mark_inode_d=
irty+0x24/0x168
Jan 17 19:05:07 vosztok kernel:  [<c01705db>] __mark_inode_dirty+0x24/0x168
Jan 17 19:05:07 vosztok kernel:  [current_fs_time+19/21] current_fs_time+0x=
13/0x15
Jan 17 19:05:07 vosztok kernel:  [<c011bae5>] current_fs_time+0x13/0x15
Jan 17 19:05:07 vosztok kernel:  [__generic_file_aio_write_nolock+864/1288]=
 __generic_file_aio_write_nolock+0x360/0x508
Jan 17 19:05:07 vosztok kernel:  [<c013d0ca>] __generic_file_aio_write_nolo=
ck+0x360/0x508
Jan 17 19:05:07 vosztok kernel:  [do_IRQ+88/109] do_IRQ+0x58/0x6d
Jan 17 19:05:07 vosztok kernel:  [<c01062b7>] do_IRQ+0x58/0x6d
Jan 17 19:05:07 vosztok kernel:  [xfs_file_open+99/102] xfs_file_open+0x63/=
0x66
Jan 17 19:05:07 vosztok kernel:  [<c0220000>] xfs_file_open+0x63/0x66
Jan 17 19:05:07 vosztok kernel:  [generic_file_aio_write+82/176] generic_fi=
le_aio_write+0x52/0xb0
Jan 17 19:05:07 vosztok kernel:  [<c013d2c4>] generic_file_aio_write+0x52/0=
xb0
Jan 17 19:05:07 vosztok kernel:  [<e08b9ed2>] nilfs_read_inode+0x2df/0x341 =
[nilfs2]
Jan 17 19:05:07 vosztok kernel:  [do_sync_write+198/265] do_sync_write+0xc6=
/0x109
Jan 17 19:05:07 vosztok kernel:  [<c01575dd>] do_sync_write+0xc6/0x109
Jan 17 19:05:07 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 19:05:07 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 19:05:07 vosztok kernel:  [sys_stat64+30/35] sys_stat64+0x1e/0x23
Jan 17 19:05:07 vosztok kernel:  [<c015a6af>] sys_stat64+0x1e/0x23
Jan 17 19:05:07 vosztok kernel:  [do_sync_write+0/265] do_sync_write+0x0/0x=
109
Jan 17 19:05:07 vosztok kernel:  [<c0157517>] do_sync_write+0x0/0x109
Jan 17 19:05:07 vosztok kernel:  [vfs_write+138/268] vfs_write+0x8a/0x10c
Jan 17 19:05:07 vosztok kernel:  [<c0157d55>] vfs_write+0x8a/0x10c
Jan 17 19:05:07 vosztok kernel:  [sys_write+65/103] sys_write+0x41/0x67
Jan 17 19:05:07 vosztok kernel:  [<c015822d>] sys_write+0x41/0x67
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: notification- S ffffffff     0 10237      1
Jan 17 19:05:07 vosztok kernel:        cbb15bfc 00000082 dc067644 ffffffff =
cfe57380 d594c000 00000000 7fffffff=20
Jan 17 19:05:07 vosztok kernel:        ffffffff 00000000 c036c8bf c0127a58 =
cac8c000 cbb15c54 cbbf5680 c03417ae=20
Jan 17 19:05:07 vosztok kernel:        0015c927 c0390720 cbb15ecc 00000000 =
00000000 c0162579 cbb15fac 08079208=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 19:05:07 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 19:05:07 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 19:05:07 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 19:05:07 vosztok kernel:  [unix_poll+23/139] unix_poll+0x17/0x8b
Jan 17 19:05:07 vosztok kernel:  [<c03417ae>] unix_poll+0x17/0x8b
Jan 17 19:05:07 vosztok kernel:  [do_sys_poll+595/800] do_sys_poll+0x253/0x=
320
Jan 17 19:05:07 vosztok kernel:  [<c0162579>] do_sys_poll+0x253/0x320
Jan 17 19:05:07 vosztok kernel:  [__pollwait+0/169] __pollwait+0x0/0xa9
Jan 17 19:05:07 vosztok kernel:  [<c0162f31>] __pollwait+0x0/0xa9
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [dequeue_entity+94/121] dequeue_entity+0x5=
e/0x79
Jan 17 19:05:07 vosztok kernel:  [<c0113ff0>] dequeue_entity+0x5e/0x79
Jan 17 19:05:07 vosztok kernel:  [task_rq_lock+18/25] task_rq_lock+0x12/0x19
Jan 17 19:05:07 vosztok kernel:  [<c01149ce>] task_rq_lock+0x12/0x19
Jan 17 19:05:07 vosztok kernel:  [try_to_wake_up+134/164] try_to_wake_up+0x=
86/0xa4
Jan 17 19:05:07 vosztok kernel:  [<c0114c02>] try_to_wake_up+0x86/0xa4
Jan 17 19:05:07 vosztok kernel:  [__wake_up_common+49/79] __wake_up_common+=
0x31/0x4f
Jan 17 19:05:07 vosztok kernel:  [<c01133ed>] __wake_up_common+0x31/0x4f
Jan 17 19:05:07 vosztok kernel:  [kfree_skbmem+8/97] kfree_skbmem+0x8/0x61
Jan 17 19:05:07 vosztok kernel:  [<c02f3c10>] kfree_skbmem+0x8/0x61
Jan 17 19:05:07 vosztok kernel:  [add_partial+49/73] add_partial+0x31/0x49
Jan 17 19:05:07 vosztok kernel:  [<c01532e8>] add_partial+0x31/0x49
Jan 17 19:05:07 vosztok kernel:  [kfree_skbmem+8/97] kfree_skbmem+0x8/0x61
Jan 17 19:05:07 vosztok kernel:  [<c02f3c10>] kfree_skbmem+0x8/0x61
Jan 17 19:05:07 vosztok kernel:  [__slab_free+92/670] __slab_free+0x5c/0x29e
Jan 17 19:05:07 vosztok kernel:  [<c01540ab>] __slab_free+0x5c/0x29e
Jan 17 19:05:07 vosztok kernel:  [kfree_skbmem+8/97] kfree_skbmem+0x8/0x61
Jan 17 19:05:07 vosztok kernel:  [<c02f3c10>] kfree_skbmem+0x8/0x61
Jan 17 19:05:07 vosztok kernel:  [unix_stream_recvmsg+1042/1218] unix_strea=
m_recvmsg+0x412/0x4c2
Jan 17 19:05:07 vosztok kernel:  [<c034307d>] unix_stream_recvmsg+0x412/0x4=
c2
Jan 17 19:05:07 vosztok kernel:  [sock_aio_read+193/205] sock_aio_read+0xc1=
/0xcd
Jan 17 19:05:07 vosztok kernel:  [<c02ee670>] sock_aio_read+0xc1/0xcd
Jan 17 19:05:07 vosztok kernel:  [<e083db5e>] ipw_rx_queue_restock+0x90/0xd=
1 [ipw2200]
Jan 17 19:05:07 vosztok kernel:  [kfree_skbmem+8/97] kfree_skbmem+0x8/0x61
Jan 17 19:05:07 vosztok kernel:  [<c02f3c10>] kfree_skbmem+0x8/0x61
Jan 17 19:05:07 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 19:05:07 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 19:05:07 vosztok kernel:  [unix_ioctl+169/177] unix_ioctl+0xa9/0xb1
Jan 17 19:05:07 vosztok kernel:  [<c03431d6>] unix_ioctl+0xa9/0xb1
Jan 17 19:05:07 vosztok kernel:  [sock_ioctl+415/446] sock_ioctl+0x19f/0x1be
Jan 17 19:05:07 vosztok kernel:  [<c02ee942>] sock_ioctl+0x19f/0x1be
Jan 17 19:05:07 vosztok kernel:  [sock_ioctl+0/446] sock_ioctl+0x0/0x1be
Jan 17 19:05:07 vosztok kernel:  [<c02ee7a3>] sock_ioctl+0x0/0x1be
Jan 17 19:05:07 vosztok kernel:  [do_ioctl+31/98] do_ioctl+0x1f/0x62
Jan 17 19:05:07 vosztok kernel:  [<c0161b83>] do_ioctl+0x1f/0x62
Jan 17 19:05:07 vosztok kernel:  [vfs_ioctl+570/589] vfs_ioctl+0x23a/0x24d
Jan 17 19:05:07 vosztok kernel:  [<c0161e00>] vfs_ioctl+0x23a/0x24d
Jan 17 19:05:07 vosztok kernel:  [sys_poll+52/55] sys_poll+0x34/0x37
Jan 17 19:05:07 vosztok kernel:  [<c016267a>] sys_poll+0x34/0x37
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: gconfd-2      S 00000000     0 10244      1
Jan 17 19:05:07 vosztok kernel:        cb175bfc 00000086 dc067b84 00000000 =
cfe578c0 00000286 002de007 cb175c0c=20
Jan 17 19:05:07 vosztok kernel:        00007530 00000000 c036c924 c0127a58 =
d3302000 de1dbf9c e0166ff0 002de007=20
Jan 17 19:05:07 vosztok kernel:        c011efb9 dc067a40 c04888c0 00000000 =
00000000 c0162579 cb175fac 0814aa80=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [schedule_timeout+120/149] schedule_timeou=
t+0x78/0x95
Jan 17 19:05:07 vosztok kernel:  [<c036c924>] schedule_timeout+0x78/0x95
Jan 17 19:05:07 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 19:05:07 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 19:05:07 vosztok kernel:  [process_timeout+0/5] process_timeout+0x0/=
0x5
Jan 17 19:05:07 vosztok kernel:  [<c011efb9>] process_timeout+0x0/0x5
Jan 17 19:05:07 vosztok kernel:  [do_sys_poll+595/800] do_sys_poll+0x253/0x=
320
Jan 17 19:05:07 vosztok kernel:  [<c0162579>] do_sys_poll+0x253/0x320
Jan 17 19:05:07 vosztok kernel:  [__pollwait+0/169] __pollwait+0x0/0xa9
Jan 17 19:05:07 vosztok kernel:  [<c0162f31>] __pollwait+0x0/0xa9
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [find_lock_page+151/176] find_lock_page+0x=
97/0xb0
Jan 17 19:05:07 vosztok kernel:  [<c013b965>] find_lock_page+0x97/0xb0
Jan 17 19:05:07 vosztok kernel:  [find_or_create_page+28/140] find_or_creat=
e_page+0x1c/0x8c
Jan 17 19:05:07 vosztok kernel:  [<c013d4b5>] find_or_create_page+0x1c/0x8c
Jan 17 19:05:07 vosztok kernel:  [<e08bd210>] nilfs_get_page_block+0x97/0xb=
1 [nilfs2]
Jan 17 19:05:07 vosztok kernel:  [<e08bdc27>] nilfs_mdt_mark_buffer_dirty+0=
x74/0x210 [nilfs2]
Jan 17 19:05:07 vosztok kernel:  [__alloc_skb+77/249] __alloc_skb+0x4d/0xf9
Jan 17 19:05:07 vosztok kernel:  [<c02f438e>] __alloc_skb+0x4d/0xf9
Jan 17 19:05:07 vosztok kernel:  [sock_alloc_send_skb+110/398] sock_alloc_s=
end_skb+0x6e/0x18e
Jan 17 19:05:07 vosztok kernel:  [<c02f0d9a>] sock_alloc_send_skb+0x6e/0x18e
Jan 17 19:05:07 vosztok kernel:  [sock_def_readable+90/114] sock_def_readab=
le+0x5a/0x72
Jan 17 19:05:07 vosztok kernel:  [<c02f2404>] sock_def_readable+0x5a/0x72
Jan 17 19:05:07 vosztok kernel:  [unix_stream_sendmsg+565/779] unix_stream_=
sendmsg+0x235/0x30b
Jan 17 19:05:07 vosztok kernel:  [<c0343906>] unix_stream_sendmsg+0x235/0x3=
0b
Jan 17 19:05:07 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [<e07a1356>] snd_timer_user_tinterrupt+0x1=
5d/0x165 [snd_timer]
Jan 17 19:05:07 vosztok kernel:  [<e07a11f9>] snd_timer_user_tinterrupt+0x0=
/0x165 [snd_timer]
Jan 17 19:05:07 vosztok kernel:  [<e079fc6c>] snd_timer_interrupt+0x243/0x2=
84 [snd_timer]
Jan 17 19:05:07 vosztok kernel:  [psmouse_handle_byte+12/202] psmouse_handl=
e_byte+0xc/0xca
Jan 17 19:05:07 vosztok kernel:  [<c02d96b5>] psmouse_handle_byte+0xc/0xca
Jan 17 19:05:07 vosztok kernel:  [psmouse_interrupt+494/506] psmouse_interr=
upt+0x1ee/0x1fa
Jan 17 19:05:07 vosztok kernel:  [<c02d9f11>] psmouse_interrupt+0x1ee/0x1fa
Jan 17 19:05:07 vosztok kernel:  [handle_IRQ_event+26/63] handle_IRQ_event+=
0x1a/0x3f
Jan 17 19:05:07 vosztok kernel:  [<c01394ba>] handle_IRQ_event+0x1a/0x3f
Jan 17 19:05:07 vosztok kernel:  [enable_8259A_irq+69/93] enable_8259A_irq+=
0x45/0x5d
Jan 17 19:05:07 vosztok kernel:  [<c0107913>] enable_8259A_irq+0x45/0x5d
Jan 17 19:05:07 vosztok kernel:  [serio_interrupt+92/119] serio_interrupt+0=
x5c/0x77
Jan 17 19:05:07 vosztok kernel:  [<c02d15b7>] serio_interrupt+0x5c/0x77
Jan 17 19:05:07 vosztok kernel:  [i8042_interrupt+551/571] i8042_interrupt+=
0x227/0x23b
Jan 17 19:05:07 vosztok kernel:  [<c02d20e0>] i8042_interrupt+0x227/0x23b
Jan 17 19:05:07 vosztok kernel:  [<e0984c73>] i915_driver_irq_handler+0x13b=
/0x18d [i915]
Jan 17 19:05:07 vosztok kernel:  [e100_intr+26/158] e100_intr+0x1a/0x9e
Jan 17 19:05:07 vosztok kernel:  [<c02ac38d>] e100_intr+0x1a/0x9e
Jan 17 19:05:07 vosztok kernel:  [handle_IRQ_event+26/63] handle_IRQ_event+=
0x1a/0x3f
Jan 17 19:05:07 vosztok kernel:  [<c01394ba>] handle_IRQ_event+0x1a/0x3f
Jan 17 19:05:07 vosztok kernel:  [do_gettimeofday+44/196] do_gettimeofday+0=
x2c/0xc4
Jan 17 19:05:07 vosztok kernel:  [<c012b095>] do_gettimeofday+0x2c/0xc4
Jan 17 19:05:07 vosztok kernel:  [sys_poll+52/55] sys_poll+0x34/0x37
Jan 17 19:05:07 vosztok kernel:  [<c016267a>] sys_poll+0x34/0x37
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: screen        S 00000000     0 11309  10212
Jan 17 19:05:07 vosztok kernel:        c56b7fac 00000082 cac4c144 00000000 =
cac7fc40 00000000 0806c310 00000000=20
Jan 17 19:05:07 vosztok kernel:        00000000 c56b6000 c012113e c0103d96 =
0806c310 00000000 0806c310 00000000=20
Jan 17 19:05:07 vosztok kernel:        00000000 bfc78d34 0000001d 0000007b =
0000007b 00000000 0000001d b7fb7410=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [sys_pause+16/22] sys_pause+0x10/0x16
Jan 17 19:05:07 vosztok kernel:  [<c012113e>] sys_pause+0x10/0x16
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: screen        S 00000000     0 11310  11309
Jan 17 19:05:07 vosztok kernel:        c0967b60 00000086 cac4d104 00000000 =
cac7f000 c04248f0 00000000 7fffffff=20
Jan 17 19:05:07 vosztok kernel:        00000007 00000040 c036c8bf 00000000 =
d4df8c00 c024f9a3 c024c6b0 00000000=20
Jan 17 19:05:07 vosztok kernel:        00000104 00000000 cfd4f380 00000000 =
c0967f9c c0162a11 c0967f9c c0967f48=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 19:05:07 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 19:05:07 vosztok kernel:  [normal_poll+0/290] normal_poll+0x0/0x122
Jan 17 19:05:07 vosztok kernel:  [<c024f9a3>] normal_poll+0x0/0x122
Jan 17 19:05:07 vosztok kernel:  [tty_poll+83/96] tty_poll+0x53/0x60
Jan 17 19:05:07 vosztok kernel:  [<c024c6b0>] tty_poll+0x53/0x60
Jan 17 19:05:07 vosztok kernel:  [do_select+916/993] do_select+0x394/0x3e1
Jan 17 19:05:07 vosztok kernel:  [<c0162a11>] do_select+0x394/0x3e1
Jan 17 19:05:07 vosztok kernel:  [__pollwait+0/169] __pollwait+0x0/0xa9
Jan 17 19:05:07 vosztok kernel:  [<c0162f31>] __pollwait+0x0/0xa9
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [e100_xmit_frame+96/211] e100_xmit_frame+0=
x60/0xd3
Jan 17 19:05:07 vosztok kernel:  [<c02aba5d>] e100_xmit_frame+0x60/0xd3
Jan 17 19:05:07 vosztok kernel:  [dev_hard_start_xmit+424/519] dev_hard_sta=
rt_xmit+0x1a8/0x207
Jan 17 19:05:07 vosztok kernel:  [<c02f87e3>] dev_hard_start_xmit+0x1a8/0x2=
07
Jan 17 19:05:07 vosztok kernel:  [dev_hard_start_xmit+424/519] dev_hard_sta=
rt_xmit+0x1a8/0x207
Jan 17 19:05:07 vosztok kernel:  [<c02f87e3>] dev_hard_start_xmit+0x1a8/0x2=
07
Jan 17 19:05:07 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 19:05:07 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 19:05:07 vosztok kernel:  [rb_insert_color+140/173] rb_insert_color+=
0x8c/0xad
Jan 17 19:05:07 vosztok kernel:  [<c023b8b0>] rb_insert_color+0x8c/0xad
Jan 17 19:05:07 vosztok kernel:  [enqueue_entity+466/499] enqueue_entity+0x=
1d2/0x1f3
Jan 17 19:05:07 vosztok kernel:  [<c0113e13>] enqueue_entity+0x1d2/0x1f3
Jan 17 19:05:07 vosztok kernel:  [__check_preempt_curr_fair+81/126] __check=
_preempt_curr_fair+0x51/0x7e
Jan 17 19:05:07 vosztok kernel:  [<c01137d0>] __check_preempt_curr_fair+0x5=
1/0x7e
Jan 17 19:05:07 vosztok kernel:  [check_preempt_curr_fair+82/86] check_pree=
mpt_curr_fair+0x52/0x56
Jan 17 19:05:07 vosztok kernel:  [<c0114f36>] check_preempt_curr_fair+0x52/=
0x56
Jan 17 19:05:07 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 19:05:07 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 19:05:07 vosztok kernel:  [enqueue_entity+466/499] enqueue_entity+0x=
1d2/0x1f3
Jan 17 19:05:07 vosztok kernel:  [<c0113e13>] enqueue_entity+0x1d2/0x1f3
Jan 17 19:05:07 vosztok kernel:  [__check_preempt_curr_fair+81/126] __check=
_preempt_curr_fair+0x51/0x7e
Jan 17 19:05:07 vosztok kernel:  [<c01137d0>] __check_preempt_curr_fair+0x5=
1/0x7e
Jan 17 19:05:07 vosztok kernel:  [check_preempt_curr_fair+82/86] check_pree=
mpt_curr_fair+0x52/0x56
Jan 17 19:05:07 vosztok kernel:  [<c0114f36>] check_preempt_curr_fair+0x52/=
0x56
Jan 17 19:05:07 vosztok kernel:  [try_to_wake_up+134/164] try_to_wake_up+0x=
86/0xa4
Jan 17 19:05:07 vosztok kernel:  [<c0114c02>] try_to_wake_up+0x86/0xa4
Jan 17 19:05:07 vosztok kernel:  [__wake_up_common+49/79] __wake_up_common+=
0x31/0x4f
Jan 17 19:05:07 vosztok kernel:  [<c01133ed>] __wake_up_common+0x31/0x4f
Jan 17 19:05:07 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [core_sys_select+682/711] core_sys_select+=
0x2aa/0x2c7
Jan 17 19:05:07 vosztok kernel:  [<c0162d08>] core_sys_select+0x2aa/0x2c7
Jan 17 19:05:07 vosztok kernel:  [n_tty_receive_buf+3376/3451] n_tty_receiv=
e_buf+0xd30/0xd7b
Jan 17 19:05:07 vosztok kernel:  [<c02507f5>] n_tty_receive_buf+0xd30/0xd7b
Jan 17 19:05:07 vosztok kernel:  [check_preempt_curr_fair+82/86] check_pree=
mpt_curr_fair+0x52/0x56
Jan 17 19:05:07 vosztok kernel:  [<c0114f36>] check_preempt_curr_fair+0x52/=
0x56
Jan 17 19:05:07 vosztok kernel:  [try_to_wake_up+134/164] try_to_wake_up+0x=
86/0xa4
Jan 17 19:05:07 vosztok kernel:  [<c0114c02>] try_to_wake_up+0x86/0xa4
Jan 17 19:05:07 vosztok kernel:  [__wake_up_common+49/79] __wake_up_common+=
0x31/0x4f
Jan 17 19:05:07 vosztok kernel:  [<c01133ed>] __wake_up_common+0x31/0x4f
Jan 17 19:05:07 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [tty_wakeup+76/80] tty_wakeup+0x4c/0x50
Jan 17 19:05:07 vosztok kernel:  [<c024bb35>] tty_wakeup+0x4c/0x50
Jan 17 19:05:07 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [tty_ldisc_deref+98/124] tty_ldisc_deref+0=
x62/0x7c
Jan 17 19:05:07 vosztok kernel:  [<c024bacf>] tty_ldisc_deref+0x62/0x7c
Jan 17 19:05:07 vosztok kernel:  [sys_select+213/391] sys_select+0xd5/0x187
Jan 17 19:05:07 vosztok kernel:  [<c01630af>] sys_select+0xd5/0x187
Jan 17 19:05:07 vosztok kernel:  [vfs_write+252/268] vfs_write+0xfc/0x10c
Jan 17 19:05:07 vosztok kernel:  [<c0157dc7>] vfs_write+0xfc/0x10c
Jan 17 19:05:07 vosztok kernel:  [sys_write+65/103] sys_write+0x41/0x67
Jan 17 19:05:07 vosztok kernel:  [<c015822d>] sys_write+0x41/0x67
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: cmus          S 00000000     0 11311  11310
Jan 17 19:05:07 vosztok kernel:        dcccbb60 00000082 cac4cbc4 00000000 =
cfe57a80 00000286 002d7eb0 dcccbb70=20
Jan 17 19:05:07 vosztok kernel:        00000004 00000008 c036c924 c0127a58 =
de428780 c0488e48 c0488e48 002d7eb0=20
Jan 17 19:05:07 vosztok kernel:        c011efb9 cac4ca80 c04888c0 00000000 =
dcccbf9c c0162a11 dcccbf9c dcccbf48=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [schedule_timeout+120/149] schedule_timeou=
t+0x78/0x95
Jan 17 19:05:07 vosztok kernel:  [<c036c924>] schedule_timeout+0x78/0x95
Jan 17 19:05:07 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 19:05:07 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 19:05:07 vosztok kernel:  [process_timeout+0/5] process_timeout+0x0/=
0x5
Jan 17 19:05:07 vosztok kernel:  [<c011efb9>] process_timeout+0x0/0x5
Jan 17 19:05:07 vosztok kernel:  [do_select+916/993] do_select+0x394/0x3e1
Jan 17 19:05:07 vosztok kernel:  [<c0162a11>] do_select+0x394/0x3e1
Jan 17 19:05:07 vosztok kernel:  [__pollwait+0/169] __pollwait+0x0/0xa9
Jan 17 19:05:07 vosztok kernel:  [<c0162f31>] __pollwait+0x0/0xa9
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [__pollwait+0/169] __pollwait+0x0/0xa9
Jan 17 19:05:07 vosztok kernel:  [<c0162f31>] __pollwait+0x0/0xa9
Jan 17 19:05:07 vosztok kernel:  [e100_exec_cb+239/269] e100_exec_cb+0xef/0=
x10d
Jan 17 19:05:07 vosztok kernel:  [<c02ab9df>] e100_exec_cb+0xef/0x10d
Jan 17 19:05:07 vosztok kernel:  [e100_xmit_prepare+0/152] e100_xmit_prepar=
e+0x0/0x98
Jan 17 19:05:07 vosztok kernel:  [<c02aadbb>] e100_xmit_prepare+0x0/0x98
Jan 17 19:05:07 vosztok kernel:  [e100_xmit_frame+96/211] e100_xmit_frame+0=
x60/0xd3
Jan 17 19:05:07 vosztok kernel:  [<c02aba5d>] e100_xmit_frame+0x60/0xd3
Jan 17 19:05:07 vosztok kernel:  [rb_insert_color+76/173] rb_insert_color+0=
x4c/0xad
Jan 17 19:05:07 vosztok kernel:  [<c023b870>] rb_insert_color+0x4c/0xad
Jan 17 19:05:07 vosztok kernel:  [dev_hard_start_xmit+424/519] dev_hard_sta=
rt_xmit+0x1a8/0x207
Jan 17 19:05:07 vosztok kernel:  [<c02f87e3>] dev_hard_start_xmit+0x1a8/0x2=
07
Jan 17 19:05:07 vosztok kernel:  [enqueue_entity+466/499] enqueue_entity+0x=
1d2/0x1f3
Jan 17 19:05:07 vosztok kernel:  [<c0113e13>] enqueue_entity+0x1d2/0x1f3
Jan 17 19:05:07 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 19:05:07 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 19:05:07 vosztok kernel:  [enqueue_entity+466/499] enqueue_entity+0x=
1d2/0x1f3
Jan 17 19:05:07 vosztok kernel:  [<c0113e13>] enqueue_entity+0x1d2/0x1f3
Jan 17 19:05:07 vosztok kernel:  [__check_preempt_curr_fair+81/126] __check=
_preempt_curr_fair+0x51/0x7e
Jan 17 19:05:07 vosztok kernel:  [<c01137d0>] __check_preempt_curr_fair+0x5=
1/0x7e
Jan 17 19:05:07 vosztok kernel:  [check_preempt_curr_fair+82/86] check_pree=
mpt_curr_fair+0x52/0x56
Jan 17 19:05:07 vosztok kernel:  [<c0114f36>] check_preempt_curr_fair+0x52/=
0x56
Jan 17 19:05:07 vosztok kernel:  [try_to_wake_up+134/164] try_to_wake_up+0x=
86/0xa4
Jan 17 19:05:07 vosztok kernel:  [<c0114c02>] try_to_wake_up+0x86/0xa4
Jan 17 19:05:07 vosztok kernel:  [autoremove_wake_function+21/53] autoremov=
e_wake_function+0x15/0x35
Jan 17 19:05:07 vosztok kernel:  [<c0127848>] autoremove_wake_function+0x15=
/0x35
Jan 17 19:05:07 vosztok kernel:  [__wake_up_common+49/79] __wake_up_common+=
0x31/0x4f
Jan 17 19:05:07 vosztok kernel:  [<c01133ed>] __wake_up_common+0x31/0x4f
Jan 17 19:05:07 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [__group_send_sig_info+28/105] __group_sen=
d_sig_info+0x1c/0x69
Jan 17 19:05:07 vosztok kernel:  [<c0120584>] __group_send_sig_info+0x1c/0x=
69
Jan 17 19:05:07 vosztok kernel:  [lock_task_sighand+32/81] lock_task_sighan=
d+0x20/0x51
Jan 17 19:05:07 vosztok kernel:  [<c011f6e0>] lock_task_sighand+0x20/0x51
Jan 17 19:05:07 vosztok kernel:  [group_send_sig_info+74/101] group_send_si=
g_info+0x4a/0x65
Jan 17 19:05:07 vosztok kernel:  [<c0120b9b>] group_send_sig_info+0x4a/0x65
Jan 17 19:05:07 vosztok kernel:  [send_sigio+293/323] send_sigio+0x125/0x143
Jan 17 19:05:07 vosztok kernel:  [<c0161272>] send_sigio+0x125/0x143
Jan 17 19:05:07 vosztok kernel:  [group_send_sig_info+74/101] group_send_si=
g_info+0x4a/0x65
Jan 17 19:05:07 vosztok kernel:  [<c0120b9b>] group_send_sig_info+0x4a/0x65
Jan 17 19:05:07 vosztok kernel:  [send_sigio+293/323] send_sigio+0x125/0x143
Jan 17 19:05:07 vosztok kernel:  [<c0161272>] send_sigio+0x125/0x143
Jan 17 19:05:07 vosztok kernel:  [core_sys_select+682/711] core_sys_select+=
0x2aa/0x2c7
Jan 17 19:05:07 vosztok kernel:  [<c0162d08>] core_sys_select+0x2aa/0x2c7
Jan 17 19:05:07 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [<e07a11f9>] snd_timer_user_tinterrupt+0x0=
/0x165 [snd_timer]
Jan 17 19:05:07 vosztok kernel:  [<e079fc6c>] snd_timer_interrupt+0x243/0x2=
84 [snd_timer]
Jan 17 19:05:07 vosztok kernel:  [<e07d0ded>] snd_pcm_period_elapsed+0x1ec/=
0x23f [snd_pcm]
Jan 17 19:05:07 vosztok kernel:  [<e07c1178>] snd_intel8x0_interrupt+0x1dd/=
0x1ea [snd_intel8x0]
Jan 17 19:05:07 vosztok kernel:  [handle_IRQ_event+26/63] handle_IRQ_event+=
0x1a/0x3f
Jan 17 19:05:07 vosztok kernel:  [<c01394ba>] handle_IRQ_event+0x1a/0x3f
Jan 17 19:05:07 vosztok kernel:  [enable_8259A_irq+69/93] enable_8259A_irq+=
0x45/0x5d
Jan 17 19:05:07 vosztok kernel:  [<c0107913>] enable_8259A_irq+0x45/0x5d
Jan 17 19:05:07 vosztok kernel:  [sys_select+160/391] sys_select+0xa0/0x187
Jan 17 19:05:07 vosztok kernel:  [<c016307a>] sys_select+0xa0/0x187
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: cmus          S 80834d34     0 11312  11310
Jan 17 19:05:07 vosztok kernel:        d141bf40 00000082 cac4db84 80834d34 =
cfe57a80 00000000 d141bf58 00000001=20
Jan 17 19:05:07 vosztok kernel:        00000001 00000000 c036cd4c 00000001 =
00000000 b7d663a0 c012a09f d556bf59=20
Jan 17 19:05:07 vosztok kernel:        c9d57f58 d5569f58 08017c06 000002fc =
c012a19b c041a6b4 00000001 00000002=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [do_nanosleep+69/111] do_nanosleep+0x45/0x=
6f
Jan 17 19:05:07 vosztok kernel:  [<c036cd4c>] do_nanosleep+0x45/0x6f
Jan 17 19:05:07 vosztok kernel:  [hrtimer_nanosleep+57/220] hrtimer_nanosle=
ep+0x39/0xdc
Jan 17 19:05:07 vosztok kernel:  [<c012a09f>] hrtimer_nanosleep+0x39/0xdc
Jan 17 19:05:07 vosztok kernel:  [hrtimer_wakeup+0/24] hrtimer_wakeup+0x0/0=
x18
Jan 17 19:05:07 vosztok kernel:  [<c012a19b>] hrtimer_wakeup+0x0/0x18
Jan 17 19:05:07 vosztok kernel:  [sys_nanosleep+73/89] sys_nanosleep+0x49/0=
x59
Jan 17 19:05:07 vosztok kernel:  [<c012a18b>] sys_nanosleep+0x49/0x59
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: cmus          S 80834d34     0 11313  11310
Jan 17 19:05:07 vosztok kernel:        c9d57f40 00000082 cac4d644 80834d34 =
cfe57a80 00000000 c9d57f58 00000001=20
Jan 17 19:05:07 vosztok kernel:        00000001 00000000 c036cd4c 00000001 =
00000000 00000000 c012a09f d141bf59=20
Jan 17 19:05:07 vosztok kernel:        00000000 00000000 08019980 000002fc =
c012a19b c041a6b4 00000001 00000002=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [do_nanosleep+69/111] do_nanosleep+0x45/0x=
6f
Jan 17 19:05:07 vosztok kernel:  [<c036cd4c>] do_nanosleep+0x45/0x6f
Jan 17 19:05:07 vosztok kernel:  [hrtimer_nanosleep+57/220] hrtimer_nanosle=
ep+0x39/0xdc
Jan 17 19:05:07 vosztok kernel:  [<c012a09f>] hrtimer_nanosleep+0x39/0xdc
Jan 17 19:05:07 vosztok kernel:  [hrtimer_wakeup+0/24] hrtimer_wakeup+0x0/0=
x18
Jan 17 19:05:07 vosztok kernel:  [<c012a19b>] hrtimer_wakeup+0x0/0x18
Jan 17 19:05:07 vosztok kernel:  [sys_nanosleep+73/89] sys_nanosleep+0x49/0=
x59
Jan 17 19:05:07 vosztok kernel:  [<c012a18b>] sys_nanosleep+0x49/0x59
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: cmus          S 00000001     0 11314  11310
Jan 17 19:05:07 vosztok kernel:        cc4a9f40 00000082 df41bb84 00000001 =
cfe57a80 00000000 cc4a9f58 00000001=20
Jan 17 19:05:07 vosztok kernel:        00000001 00000000 c036cd4c 00000001 =
00000000 00000000 c012a09f d59cbf58=20
Jan 17 19:05:07 vosztok kernel:        d6147f58 d6eeff58 0b3d35f5 000002fc =
c012a19b c041a6b4 00000001 00000002=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [do_nanosleep+69/111] do_nanosleep+0x45/0x=
6f
Jan 17 19:05:07 vosztok kernel:  [<c036cd4c>] do_nanosleep+0x45/0x6f
Jan 17 19:05:07 vosztok kernel:  [hrtimer_nanosleep+57/220] hrtimer_nanosle=
ep+0x39/0xdc
Jan 17 19:05:07 vosztok kernel:  [<c012a09f>] hrtimer_nanosleep+0x39/0xdc
Jan 17 19:05:07 vosztok kernel:  [hrtimer_wakeup+0/24] hrtimer_wakeup+0x0/0=
x18
Jan 17 19:05:07 vosztok kernel:  [<c012a19b>] hrtimer_wakeup+0x0/0x18
Jan 17 19:05:07 vosztok kernel:  [sys_nanosleep+73/89] sys_nanosleep+0x49/0=
x59
Jan 17 19:05:07 vosztok kernel:  [<c012a18b>] sys_nanosleep+0x49/0x59
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: claws-mail    S 00000000     0 11326      1
Jan 17 19:05:07 vosztok kernel:        cc21bbfc 00200086 c7cec144 00000000 =
cfe571c0 00200286 002d8c5c cc21bc0c=20
Jan 17 19:05:07 vosztok kernel:        00001388 00000000 c036c924 cc21be94 =
c0127a58 c0489128 c0489128 002d8c5c=20
Jan 17 19:05:07 vosztok kernel:        c011efb9 c7cec000 c04888c0 00000000 =
00000000 c0162579 cc21bfac 08a955b0=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [schedule_timeout+120/149] schedule_timeou=
t+0x78/0x95
Jan 17 19:05:07 vosztok kernel:  [<c036c924>] schedule_timeout+0x78/0x95
Jan 17 19:05:07 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 19:05:07 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 19:05:07 vosztok kernel:  [process_timeout+0/5] process_timeout+0x0/=
0x5
Jan 17 19:05:07 vosztok kernel:  [<c011efb9>] process_timeout+0x0/0x5
Jan 17 19:05:07 vosztok kernel:  [do_sys_poll+595/800] do_sys_poll+0x253/0x=
320
Jan 17 19:05:07 vosztok kernel:  [<c0162579>] do_sys_poll+0x253/0x320
Jan 17 19:05:07 vosztok kernel:  [__pollwait+0/169] __pollwait+0x0/0xa9
Jan 17 19:05:07 vosztok kernel:  [<c0162f31>] __pollwait+0x0/0xa9
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [enqueue_entity+466/499] enqueue_entity+0x=
1d2/0x1f3
Jan 17 19:05:07 vosztok kernel:  [<c0113e13>] enqueue_entity+0x1d2/0x1f3
Jan 17 19:05:07 vosztok kernel:  [__check_preempt_curr_fair+81/126] __check=
_preempt_curr_fair+0x51/0x7e
Jan 17 19:05:07 vosztok kernel:  [<c01137d0>] __check_preempt_curr_fair+0x5=
1/0x7e
Jan 17 19:05:07 vosztok kernel:  [check_preempt_curr_fair+82/86] check_pree=
mpt_curr_fair+0x52/0x56
Jan 17 19:05:07 vosztok kernel:  [<c0114f36>] check_preempt_curr_fair+0x52/=
0x56
Jan 17 19:05:07 vosztok kernel:  [try_to_wake_up+134/164] try_to_wake_up+0x=
86/0xa4
Jan 17 19:05:07 vosztok kernel:  [<c0114c02>] try_to_wake_up+0x86/0xa4
Jan 17 19:05:07 vosztok kernel:  [__wake_up_common+49/79] __wake_up_common+=
0x31/0x4f
Jan 17 19:05:07 vosztok kernel:  [<c01133ed>] __wake_up_common+0x31/0x4f
Jan 17 19:05:07 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [__d_lookup+288/317] __d_lookup+0x120/0x13d
Jan 17 19:05:07 vosztok kernel:  [<c01668d3>] __d_lookup+0x120/0x13d
Jan 17 19:05:07 vosztok kernel:  [do_lookup+79/320] do_lookup+0x4f/0x140
Jan 17 19:05:07 vosztok kernel:  [<c015df2a>] do_lookup+0x4f/0x140
Jan 17 19:05:07 vosztok kernel:  [_atomic_dec_and_lock+37/64] _atomic_dec_a=
nd_lock+0x25/0x40
Jan 17 19:05:07 vosztok kernel:  [<c02390e9>] _atomic_dec_and_lock+0x25/0x40
Jan 17 19:05:07 vosztok kernel:  [dput+21/314] dput+0x15/0x13a
Jan 17 19:05:07 vosztok kernel:  [<c0165e4c>] dput+0x15/0x13a
Jan 17 19:05:07 vosztok kernel:  [__link_path_walk+2781/3072] __link_path_w=
alk+0xadd/0xc00
Jan 17 19:05:07 vosztok kernel:  [<c015fae2>] __link_path_walk+0xadd/0xc00
Jan 17 19:05:07 vosztok kernel:  [unix_stream_sendmsg+565/779] unix_stream_=
sendmsg+0x235/0x30b
Jan 17 19:05:07 vosztok kernel:  [<c0343906>] unix_stream_sendmsg+0x235/0x3=
0b
Jan 17 19:05:07 vosztok kernel:  [_atomic_dec_and_lock+37/64] _atomic_dec_a=
nd_lock+0x25/0x40
Jan 17 19:05:07 vosztok kernel:  [<c02390e9>] _atomic_dec_and_lock+0x25/0x40
Jan 17 19:05:07 vosztok kernel:  [mntput_no_expire+17/133] mntput_no_expire=
+0x11/0x85
Jan 17 19:05:07 vosztok kernel:  [<c016a3e5>] mntput_no_expire+0x11/0x85
Jan 17 19:05:07 vosztok kernel:  [link_path_walk+165/175] link_path_walk+0x=
a5/0xaf
Jan 17 19:05:07 vosztok kernel:  [<c015fcaa>] link_path_walk+0xa5/0xaf
Jan 17 19:05:07 vosztok kernel:  [generic_fillattr+126/182] generic_fillatt=
r+0x7e/0xb6
Jan 17 19:05:07 vosztok kernel:  [<c015a176>] generic_fillattr+0x7e/0xb6
Jan 17 19:05:07 vosztok kernel:  [cp_new_stat64+252/270] cp_new_stat64+0xfc=
/0x10e
Jan 17 19:05:07 vosztok kernel:  [<c015a322>] cp_new_stat64+0xfc/0x10e
Jan 17 19:05:07 vosztok kernel:  [unix_ioctl+169/177] unix_ioctl+0xa9/0xb1
Jan 17 19:05:07 vosztok kernel:  [<c03431d6>] unix_ioctl+0xa9/0xb1
Jan 17 19:05:07 vosztok kernel:  [sock_ioctl+415/446] sock_ioctl+0x19f/0x1be
Jan 17 19:05:07 vosztok kernel:  [<c02ee942>] sock_ioctl+0x19f/0x1be
Jan 17 19:05:07 vosztok kernel:  [sock_ioctl+0/446] sock_ioctl+0x0/0x1be
Jan 17 19:05:07 vosztok kernel:  [<c02ee7a3>] sock_ioctl+0x0/0x1be
Jan 17 19:05:07 vosztok kernel:  [do_ioctl+31/98] do_ioctl+0x1f/0x62
Jan 17 19:05:07 vosztok kernel:  [<c0161b83>] do_ioctl+0x1f/0x62
Jan 17 19:05:07 vosztok kernel:  [do_gettimeofday+44/196] do_gettimeofday+0=
x2c/0xc4
Jan 17 19:05:07 vosztok kernel:  [<c012b095>] do_gettimeofday+0x2c/0xc4
Jan 17 19:05:07 vosztok kernel:  [sys_poll+52/55] sys_poll+0x34/0x37
Jan 17 19:05:07 vosztok kernel:  [<c016267a>] sys_poll+0x34/0x37
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: claws-mail    S 00000001     0 11333      1
Jan 17 19:05:07 vosztok kernel:        c3ba7e64 00000086 c7cedb84 00000001 =
cfe571c0 00000000 cfe571f4 08309ecc=20
Jan 17 19:05:07 vosztok kernel:        c3ba7e84 00000000 c0130066 00000000 =
00000327 00000327 00000064 c048a9b0=20
Jan 17 19:05:07 vosztok kernel:        c048a9b0 c048a9b8 c048a9b8 c3ba7ef0 =
c3ba7ef0 c048a9b0 08309000 cfe571c0=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [futex_wait+462/750] futex_wait+0x1ce/0x2ee
Jan 17 19:05:07 vosztok kernel:  [<c0130066>] futex_wait+0x1ce/0x2ee
Jan 17 19:05:07 vosztok kernel:  [do_sync_write+198/265] do_sync_write+0xc6=
/0x109
Jan 17 19:05:07 vosztok kernel:  [<c01575dd>] do_sync_write+0xc6/0x109
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [do_futex+101/2660] do_futex+0x65/0xa64
Jan 17 19:05:07 vosztok kernel:  [<c013053a>] do_futex+0x65/0xa64
Jan 17 19:05:07 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 19:05:07 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 19:05:07 vosztok kernel:  [sys_stat64+30/35] sys_stat64+0x1e/0x23
Jan 17 19:05:07 vosztok kernel:  [<c015a6af>] sys_stat64+0x1e/0x23
Jan 17 19:05:07 vosztok kernel:  [sys_futex+194/212] sys_futex+0xc2/0xd4
Jan 17 19:05:07 vosztok kernel:  [<c0130ffb>] sys_futex+0xc2/0xd4
Jan 17 19:05:07 vosztok kernel:  [sys_write+95/103] sys_write+0x5f/0x67
Jan 17 19:05:07 vosztok kernel:  [<c015824b>] sys_write+0x5f/0x67
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: wmaker        D 00000008     0 14412  10200
Jan 17 19:05:07 vosztok kernel:        d5fd5c30 00000086 d50e1104 00000008 =
d6dde700 00000000 d5fd5c5c d5fd5c5c=20
Jan 17 19:05:07 vosztok kernel:        c13f0f20 d5fd5c38 c036c20c c013b86b =
c013b8a9 c036c98d d5fd5c5c 00000000=20
Jan 17 19:05:07 vosztok kernel:        d5fd5c78 00000000 c013b85d 00000002 =
c11e8fe0 00000000 00000001 d50e0fc0=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [io_schedule+14/22] io_schedule+0xe/0x16
Jan 17 19:05:07 vosztok kernel:  [<c036c20c>] io_schedule+0xe/0x16
Jan 17 19:05:07 vosztok kernel:  [sync_page+0/65] sync_page+0x0/0x41
Jan 17 19:05:07 vosztok kernel:  [<c013b86b>] sync_page+0x0/0x41
Jan 17 19:05:07 vosztok kernel:  [sync_page+62/65] sync_page+0x3e/0x41
Jan 17 19:05:07 vosztok kernel:  [<c013b8a9>] sync_page+0x3e/0x41
Jan 17 19:05:07 vosztok kernel:  [__wait_on_bit_lock+42/81] __wait_on_bit_l=
ock+0x2a/0x51
Jan 17 19:05:07 vosztok kernel:  [<c036c98d>] __wait_on_bit_lock+0x2a/0x51
Jan 17 19:05:07 vosztok kernel:  [__lock_page+87/93] __lock_page+0x57/0x5d
Jan 17 19:05:07 vosztok kernel:  [<c013b85d>] __lock_page+0x57/0x5d
Jan 17 19:05:07 vosztok kernel:  [wake_bit_function+0/60] wake_bit_function=
+0x0/0x3c
Jan 17 19:05:07 vosztok kernel:  [<c0127868>] wake_bit_function+0x0/0x3c
Jan 17 19:05:07 vosztok kernel:  [<e08be7aa>] __nilfs_btnode_get+0x70/0x1bc=
 [nilfs2]
Jan 17 19:05:07 vosztok kernel:  [<e08bf7b6>] nilfs_bmap_get_block+0x25/0x2=
a [nilfs2]
Jan 17 19:05:07 vosztok kernel:  [<e08c059d>] nilfs_btree_init_gc+0x72a/0x1=
050 [nilfs2]
Jan 17 19:05:07 vosztok kernel:  [<e08c1817>] nilfs_btree_path_cache_destro=
y+0x66b/0x1e39 [nilfs2]
Jan 17 19:05:07 vosztok kernel:  [alloc_page_buffers+110/180] alloc_page_bu=
ffers+0x6e/0xb4
Jan 17 19:05:07 vosztok kernel:  [<c017393f>] alloc_page_buffers+0x6e/0xb4
Jan 17 19:05:07 vosztok kernel:  [<e08bf6c6>] nilfs_bmap_lookup_at_level+0x=
33/0x81 [nilfs2]
Jan 17 19:05:07 vosztok kernel:  [<e08bf737>] nilfs_bmap_lookup+0x23/0x37 [=
nilfs2]
Jan 17 19:05:07 vosztok kernel:  [<e08bdd5d>] nilfs_mdt_mark_buffer_dirty+0=
x1aa/0x210 [nilfs2]
Jan 17 19:05:07 vosztok kernel:  [<e08bdde0>] nilfs_mdt_read_block+0x1d/0xb=
b [nilfs2]
Jan 17 19:05:07 vosztok kernel:  [<e08cfade>] nilfs_ifile_get_inode_block+0=
xea/0x13d [nilfs2]
Jan 17 19:05:07 vosztok kernel:  [<e08ba343>] nilfs_find_entry+0xd9/0x196 [=
nilfs2]
Jan 17 19:05:07 vosztok kernel:  [<e08b9c6b>] nilfs_read_inode+0x78/0x341 [=
nilfs2]
Jan 17 19:05:07 vosztok kernel:  [<e08bb0ff>] nilfs_alloc_inode+0xf/0x76 [n=
ilfs2]
Jan 17 19:05:07 vosztok kernel:  [iget_locked+199/312] iget_locked+0xc7/0x1=
38
Jan 17 19:05:07 vosztok kernel:  [<c01682bf>] iget_locked+0xc7/0x138
Jan 17 19:05:07 vosztok kernel:  [<e08bc493>] nilfs_load_super_block+0x19b/=
0x924 [nilfs2]
Jan 17 19:05:07 vosztok kernel:  [do_lookup+163/320] do_lookup+0xa3/0x140
Jan 17 19:05:07 vosztok kernel:  [<c015df7e>] do_lookup+0xa3/0x140
Jan 17 19:05:07 vosztok kernel:  [__link_path_walk+805/3072] __link_path_wa=
lk+0x325/0xc00
Jan 17 19:05:07 vosztok kernel:  [<c015f32a>] __link_path_walk+0x325/0xc00
Jan 17 19:05:07 vosztok kernel:  [sock_aio_read+193/205] sock_aio_read+0xc1=
/0xcd
Jan 17 19:05:07 vosztok kernel:  [<c02ee670>] sock_aio_read+0xc1/0xcd
Jan 17 19:05:07 vosztok kernel:  [link_path_walk+66/175] link_path_walk+0x4=
2/0xaf
Jan 17 19:05:07 vosztok kernel:  [<c015fc47>] link_path_walk+0x42/0xaf
Jan 17 19:05:07 vosztok kernel:  [run_timer_softirq+361/388] run_timer_soft=
irq+0x169/0x184
Jan 17 19:05:07 vosztok kernel:  [<c011ecba>] run_timer_softirq+0x169/0x184
Jan 17 19:05:07 vosztok kernel:  [vfs_read+250/266] vfs_read+0xfa/0x10a
Jan 17 19:05:07 vosztok kernel:  [<c0157ed1>] vfs_read+0xfa/0x10a
Jan 17 19:05:07 vosztok kernel:  [do_path_lookup+411/438] do_path_lookup+0x=
19b/0x1b6
Jan 17 19:05:07 vosztok kernel:  [<c015ffbf>] do_path_lookup+0x19b/0x1b6
Jan 17 19:05:07 vosztok kernel:  [getname+89/143] getname+0x59/0x8f
Jan 17 19:05:07 vosztok kernel:  [__user_walk_fd+47/69] __user_walk_fd+0x2f=
/0x45
Jan 17 19:05:07 vosztok kernel:  [<c0160776>] __user_walk_fd+0x2f/0x45
Jan 17 19:05:07 vosztok kernel:  [sys_faccessat+153/301] sys_faccessat+0x99=
/0x12d
Jan 17 19:05:07 vosztok kernel:  [<c0156a47>] sys_faccessat+0x99/0x12d
Jan 17 19:05:07 vosztok kernel:  [run_timer_softirq+361/388] run_timer_soft=
irq+0x169/0x184
Jan 17 19:05:07 vosztok kernel:  [<c011ecba>] run_timer_softirq+0x169/0x184
Jan 17 19:05:07 vosztok kernel:  [vfs_read+250/266] vfs_read+0xfa/0x10a
Jan 17 19:05:07 vosztok kernel:  [<c0157ed1>] vfs_read+0xfa/0x10a
Jan 17 19:05:07 vosztok kernel:  [sys_access+31/35] sys_access+0x1f/0x23
Jan 17 19:05:07 vosztok kernel:  [<c0156afa>] sys_access+0x1f/0x23
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: wmsetbg       S c3316300     0 14413  14412
Jan 17 19:05:07 vosztok kernel:        cb6c7e58 00000082 d50e0144 c3316300 =
d4dafc40 c01279b8 cb636800 df6d8940=20
Jan 17 19:05:07 vosztok kernel:        cb6c7e74 cb636800 c015d010 00000000 =
d50e0000 c0127833 cb636800 cb636800=20
Jan 17 19:05:07 vosztok kernel:        00000004 cb6c7edc c015d740 c01574da =
cb6c7f64 00000000 dc114500 df6d8940=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [prepare_to_wait+74/102] prepare_to_wait+0=
x4a/0x66
Jan 17 19:05:07 vosztok kernel:  [<c01279b8>] prepare_to_wait+0x4a/0x66
Jan 17 19:05:07 vosztok kernel:  [pipe_wait+80/110] pipe_wait+0x50/0x6e
Jan 17 19:05:07 vosztok kernel:  [<c015d010>] pipe_wait+0x50/0x6e
Jan 17 19:05:07 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 19:05:07 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 19:05:07 vosztok kernel:  [pipe_read+684/796] pipe_read+0x2ac/0x31c
Jan 17 19:05:07 vosztok kernel:  [<c015d740>] pipe_read+0x2ac/0x31c
Jan 17 19:05:07 vosztok kernel:  [do_sync_readv_writev+192/253] do_sync_rea=
dv_writev+0xc0/0xfd
Jan 17 19:05:07 vosztok kernel:  [<c01574da>] do_sync_readv_writev+0xc0/0xfd
Jan 17 19:05:07 vosztok kernel:  [do_sync_read+198/265] do_sync_read+0xc6/0=
x109
Jan 17 19:05:07 vosztok kernel:  [<c01576e6>] do_sync_read+0xc6/0x109
Jan 17 19:05:07 vosztok kernel:  [add_partial+49/73] add_partial+0x31/0x49
Jan 17 19:05:07 vosztok kernel:  [<c01532e8>] add_partial+0x31/0x49
Jan 17 19:05:07 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 19:05:07 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 19:05:07 vosztok kernel:  [d_kill+55/70] d_kill+0x37/0x46
Jan 17 19:05:07 vosztok kernel:  [<c0165e28>] d_kill+0x37/0x46
Jan 17 19:05:07 vosztok kernel:  [d_kill+55/70] d_kill+0x37/0x46
Jan 17 19:05:07 vosztok kernel:  [<c0165e28>] d_kill+0x37/0x46
Jan 17 19:05:07 vosztok kernel:  [_atomic_dec_and_lock+37/64] _atomic_dec_a=
nd_lock+0x25/0x40
Jan 17 19:05:07 vosztok kernel:  [<c02390e9>] _atomic_dec_and_lock+0x25/0x40
Jan 17 19:05:07 vosztok kernel:  [do_sync_read+0/265] do_sync_read+0x0/0x109
Jan 17 19:05:07 vosztok kernel:  [<c0157620>] do_sync_read+0x0/0x109
Jan 17 19:05:07 vosztok kernel:  [vfs_read+136/266] vfs_read+0x88/0x10a
Jan 17 19:05:07 vosztok kernel:  [<c0157e5f>] vfs_read+0x88/0x10a
Jan 17 19:05:07 vosztok kernel:  [sys_read+65/103] sys_read+0x41/0x67
Jan 17 19:05:07 vosztok kernel:  [<c01581c6>] sys_read+0x41/0x67
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: urxvtd        S 00000000     0 14417      1
Jan 17 19:05:07 vosztok kernel:        c9515b60 00000086 d50e0684 00000000 =
d6149e00 c04248f0 00000000 7fffffff=20
Jan 17 19:05:07 vosztok kernel:        0000000a 00000200 c036c8bf 00000000 =
c36df000 c024f9a3 c024c6b0 c9515be0=20
Jan 17 19:05:07 vosztok kernel:        00000104 00000104 d25b8f00 00000000 =
c9515f9c c0162a11 c9515f9c c9515f48=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 19:05:07 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 19:05:07 vosztok kernel:  [normal_poll+0/290] normal_poll+0x0/0x122
Jan 17 19:05:07 vosztok kernel:  [<c024f9a3>] normal_poll+0x0/0x122
Jan 17 19:05:07 vosztok kernel:  [tty_poll+83/96] tty_poll+0x53/0x60
Jan 17 19:05:07 vosztok kernel:  [<c024c6b0>] tty_poll+0x53/0x60
Jan 17 19:05:07 vosztok kernel:  [do_select+916/993] do_select+0x394/0x3e1
Jan 17 19:05:07 vosztok kernel:  [<c0162a11>] do_select+0x394/0x3e1
Jan 17 19:05:07 vosztok kernel:  [__pollwait+0/169] __pollwait+0x0/0xa9
Jan 17 19:05:07 vosztok kernel:  [<c0162f31>] __pollwait+0x0/0xa9
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 19:05:07 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 19:05:07 vosztok kernel:  [enqueue_entity+466/499] enqueue_entity+0x=
1d2/0x1f3
Jan 17 19:05:07 vosztok kernel:  [<c0113e13>] enqueue_entity+0x1d2/0x1f3
Jan 17 19:05:07 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 19:05:07 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 19:05:07 vosztok kernel:  [task_rq_lock+18/25] task_rq_lock+0x12/0x19
Jan 17 19:05:07 vosztok kernel:  [<c01149ce>] task_rq_lock+0x12/0x19
Jan 17 19:05:07 vosztok kernel:  [try_to_wake_up+134/164] try_to_wake_up+0x=
86/0xa4
Jan 17 19:05:07 vosztok kernel:  [<c0114c02>] try_to_wake_up+0x86/0xa4
Jan 17 19:05:07 vosztok kernel:  [__wake_up_common+49/79] __wake_up_common+=
0x31/0x4f
Jan 17 19:05:07 vosztok kernel:  [<c01133ed>] __wake_up_common+0x31/0x4f
Jan 17 19:05:07 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [__group_send_sig_info+28/105] __group_sen=
d_sig_info+0x1c/0x69
Jan 17 19:05:07 vosztok kernel:  [<c0120584>] __group_send_sig_info+0x1c/0x=
69
Jan 17 19:05:07 vosztok kernel:  [lock_task_sighand+32/81] lock_task_sighan=
d+0x20/0x51
Jan 17 19:05:07 vosztok kernel:  [<c011f6e0>] lock_task_sighand+0x20/0x51
Jan 17 19:05:07 vosztok kernel:  [group_send_sig_info+74/101] group_send_si=
g_info+0x4a/0x65
Jan 17 19:05:07 vosztok kernel:  [<c0120b9b>] group_send_sig_info+0x4a/0x65
Jan 17 19:05:07 vosztok kernel:  [send_sigio+293/323] send_sigio+0x125/0x143
Jan 17 19:05:07 vosztok kernel:  [<c0161272>] send_sigio+0x125/0x143
Jan 17 19:05:07 vosztok kernel:  [core_sys_select+682/711] core_sys_select+=
0x2aa/0x2c7
Jan 17 19:05:07 vosztok kernel:  [<c0162d08>] core_sys_select+0x2aa/0x2c7
Jan 17 19:05:07 vosztok kernel:  [sock_aio_read+193/205] sock_aio_read+0xc1=
/0xcd
Jan 17 19:05:07 vosztok kernel:  [<c02ee670>] sock_aio_read+0xc1/0xcd
Jan 17 19:05:07 vosztok kernel:  [__wake_up_common+49/79] __wake_up_common+=
0x31/0x4f
Jan 17 19:05:07 vosztok kernel:  [<c01133ed>] __wake_up_common+0x31/0x4f
Jan 17 19:05:07 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [tty_wakeup+76/80] tty_wakeup+0x4c/0x50
Jan 17 19:05:07 vosztok kernel:  [<c024bb35>] tty_wakeup+0x4c/0x50
Jan 17 19:05:07 vosztok kernel:  [remove_wait_queue+57/81] remove_wait_queu=
e+0x39/0x51
Jan 17 19:05:07 vosztok kernel:  [<c0127a0d>] remove_wait_queue+0x39/0x51
Jan 17 19:05:07 vosztok kernel:  [read_chan+1239/1324] read_chan+0x4d7/0x52c
Jan 17 19:05:07 vosztok kernel:  [<c0250d17>] read_chan+0x4d7/0x52c
Jan 17 19:05:07 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 19:05:07 vosztok kernel:  [read_chan+0/1324] read_chan+0x0/0x52c
Jan 17 19:05:07 vosztok kernel:  [<c0250840>] read_chan+0x0/0x52c
Jan 17 19:05:07 vosztok kernel:  [sys_select+213/391] sys_select+0xd5/0x187
Jan 17 19:05:07 vosztok kernel:  [<c01630af>] sys_select+0xd5/0x187
Jan 17 19:05:07 vosztok kernel:  [sigprocmask+157/182] sigprocmask+0x9d/0xb6
Jan 17 19:05:07 vosztok kernel:  [<c011f828>] sigprocmask+0x9d/0xb6
Jan 17 19:05:07 vosztok kernel:  [sys_rt_sigprocmask+71/186] sys_rt_sigproc=
mask+0x47/0xba
Jan 17 19:05:07 vosztok kernel:  [<c0121c94>] sys_rt_sigprocmask+0x47/0xba
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: epiphany      D c38dd300     0 14478  14412
Jan 17 19:05:07 vosztok kernel:        ced45d5c 00200086 c7ced104 c38dd300 =
cd3628c0 c7cecfc0 fffeffff df3b8c94=20
Jan 17 19:05:07 vosztok kernel:        00000000 c7cecfc0 c023bd30 ced45d80 =
c7cecfc0 df3b8c94 df3b8c00 00000000=20
Jan 17 19:05:07 vosztok kernel:        de9db2a0 c036d592 dc075d80 df3b8c98 =
c7cecfc0 00000001 df3b8c94 c036d5d3=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [rwsem_down_failed_common+328/353] rwsem_d=
own_failed_common+0x148/0x161
Jan 17 19:05:07 vosztok kernel:  [<c023bd30>] rwsem_down_failed_common+0x14=
8/0x161
Jan 17 19:05:07 vosztok kernel:  [rwsem_down_read_failed+26/36] rwsem_down_=
read_failed+0x1a/0x24
Jan 17 19:05:07 vosztok kernel:  [<c036d592>] rwsem_down_read_failed+0x1a/0=
x24
Jan 17 19:05:07 vosztok kernel:  [call_rwsem_down_read_failed+7/12] call_rw=
sem_down_read_failed+0x7/0xc
Jan 17 19:05:07 vosztok kernel:  [<c036d5d3>] call_rwsem_down_read_failed+0=
x7/0xc
Jan 17 19:05:07 vosztok kernel:  [down_read+9/10] down_read+0x9/0xa
Jan 17 19:05:07 vosztok kernel:  [<c012a885>] down_read+0x9/0xa
Jan 17 19:05:07 vosztok kernel:  [<e08caf2c>] nilfs_transaction_begin+0xd4/=
0x150 [nilfs2]
Jan 17 19:05:07 vosztok kernel:  [<e08cafc6>] nilfs_dirty_inode+0x1e/0x40 [=
nilfs2]
Jan 17 19:05:07 vosztok kernel:  [__mark_inode_dirty+36/360] __mark_inode_d=
irty+0x24/0x168
Jan 17 19:05:07 vosztok kernel:  [<c01705db>] __mark_inode_dirty+0x24/0x168
Jan 17 19:05:07 vosztok kernel:  [current_fs_time+19/21] current_fs_time+0x=
13/0x15
Jan 17 19:05:07 vosztok kernel:  [<c011bae5>] current_fs_time+0x13/0x15
Jan 17 19:05:07 vosztok kernel:  [__generic_file_aio_write_nolock+864/1288]=
 __generic_file_aio_write_nolock+0x360/0x508
Jan 17 19:05:07 vosztok kernel:  [<c013d0ca>] __generic_file_aio_write_nolo=
ck+0x360/0x508
Jan 17 19:05:07 vosztok kernel:  [preempt_schedule+69/87] preempt_schedule+=
0x45/0x57
Jan 17 19:05:07 vosztok kernel:  [<c036c133>] preempt_schedule+0x45/0x57
Jan 17 19:05:07 vosztok kernel:  [generic_file_aio_write+82/176] generic_fi=
le_aio_write+0x52/0xb0
Jan 17 19:05:07 vosztok kernel:  [<c013d2c4>] generic_file_aio_write+0x52/0=
xb0
Jan 17 19:05:07 vosztok kernel:  [<e08b9ed2>] nilfs_read_inode+0x2df/0x341 =
[nilfs2]
Jan 17 19:05:07 vosztok kernel:  [do_sync_write+198/265] do_sync_write+0xc6=
/0x109
Jan 17 19:05:07 vosztok kernel:  [<c01575dd>] do_sync_write+0xc6/0x109
Jan 17 19:05:07 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 19:05:07 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 19:05:07 vosztok kernel:  [unix_ioctl+169/177] unix_ioctl+0xa9/0xb1
Jan 17 19:05:07 vosztok kernel:  [<c03431d6>] unix_ioctl+0xa9/0xb1
Jan 17 19:05:07 vosztok kernel:  [sock_ioctl+415/446] sock_ioctl+0x19f/0x1be
Jan 17 19:05:07 vosztok kernel:  [<c02ee942>] sock_ioctl+0x19f/0x1be
Jan 17 19:05:07 vosztok kernel:  [sock_ioctl+0/446] sock_ioctl+0x0/0x1be
Jan 17 19:05:07 vosztok kernel:  [<c02ee7a3>] sock_ioctl+0x0/0x1be
Jan 17 19:05:07 vosztok kernel:  [do_sync_write+0/265] do_sync_write+0x0/0x=
109
Jan 17 19:05:07 vosztok kernel:  [<c0157517>] do_sync_write+0x0/0x109
Jan 17 19:05:07 vosztok kernel:  [vfs_write+138/268] vfs_write+0x8a/0x10c
Jan 17 19:05:07 vosztok kernel:  [<c0157d55>] vfs_write+0x8a/0x10c
Jan 17 19:05:07 vosztok kernel:  [sys_write+65/103] sys_write+0x41/0x67
Jan 17 19:05:07 vosztok kernel:  [<c015822d>] sys_write+0x41/0x67
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: bash          S c06143c8     0 19613  14417
Jan 17 19:05:07 vosztok kernel:        c0c6df34 00000086 d12df104 c06143c8 =
c7eb51c0 00000000 ffffffff 00000001=20
Jan 17 19:05:07 vosztok kernel:        d12dfa40 00000000 c011a464 000003c8 =
ddfda080 97c5cda1 cac861b8 0000000e=20
Jan 17 19:05:07 vosztok kernel:        ffffffff d12defc0 00000001 00000001 =
00000000 d12df0a4 bfbe2704 df071a68=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 19:05:07 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 19:05:07 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 19:05:07 vosztok kernel:  [sys_waitpid+39/43] sys_waitpid+0x27/0x2b
Jan 17 19:05:07 vosztok kernel:  [<c011a59e>] sys_waitpid+0x27/0x2b
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: su            S d1ff7f98     0 19617  19613
Jan 17 19:05:07 vosztok kernel:        c69a3f34 00000082 d12dfb84 d1ff7f98 =
c7eb5a80 00000000 ffffffff 00000001=20
Jan 17 19:05:07 vosztok kernel:        d12dea80 00000000 c011a464 00000f98 =
deaa2468 00000001 c2438f78 00000006=20
Jan 17 19:05:07 vosztok kernel:        ffffffff d12dfa40 00000001 00000001 =
00000000 d12dfb24 c01173a2 00000000=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 19:05:07 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 19:05:07 vosztok kernel:  [do_fork+252/443] do_fork+0xfc/0x1bb
Jan 17 19:05:07 vosztok kernel:  [<c01173a2>] do_fork+0xfc/0x1bb
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 19:05:07 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 19:05:07 vosztok kernel:  [sys_waitpid+39/43] sys_waitpid+0x27/0x2b
Jan 17 19:05:07 vosztok kernel:  [<c011a59e>] sys_waitpid+0x27/0x2b
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: bash          S 00000000     0 19620  19617
Jan 17 19:05:07 vosztok kernel:        c687ff34 00000086 d12debc4 00000000 =
c7eb5000 00000000 ffffffff 00000001=20
Jan 17 19:05:07 vosztok kernel:        cac4c540 00000000 c011a464 00000001 =
da9a2200 00000000 00000000 0000000e=20
Jan 17 19:05:07 vosztok kernel:        ffffffff d12dea80 00000001 00000001 =
00000000 d12deb64 bf9429b4 df071a68=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 19:05:07 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 19:05:07 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 19:05:07 vosztok kernel:  [sys_waitpid+39/43] sys_waitpid+0x27/0x2b
Jan 17 19:05:07 vosztok kernel:  [<c011a59e>] sys_waitpid+0x27/0x2b
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: emerge        S 00000000     0 19625  19620
Jan 17 19:05:07 vosztok kernel:        c7831b60 00200082 cac4c684 00000000 =
cd362540 c04248f0 00000000 7fffffff=20
Jan 17 19:05:07 vosztok kernel:        00000004 00000008 c036c8bf 00000000 =
caa10400 c024f9a3 c024c6b0 c7831be0=20
Jan 17 19:05:07 vosztok kernel:        00000104 00000000 cc0a4600 00000000 =
c7831f9c c0162a11 c7831f9c c7831f48=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 19:05:07 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 19:05:07 vosztok kernel:  [normal_poll+0/290] normal_poll+0x0/0x122
Jan 17 19:05:07 vosztok kernel:  [<c024f9a3>] normal_poll+0x0/0x122
Jan 17 19:05:07 vosztok kernel:  [tty_poll+83/96] tty_poll+0x53/0x60
Jan 17 19:05:07 vosztok kernel:  [<c024c6b0>] tty_poll+0x53/0x60
Jan 17 19:05:07 vosztok kernel:  [do_select+916/993] do_select+0x394/0x3e1
Jan 17 19:05:07 vosztok kernel:  [<c0162a11>] do_select+0x394/0x3e1
Jan 17 19:05:07 vosztok kernel:  [__pollwait+0/169] __pollwait+0x0/0xa9
Jan 17 19:05:07 vosztok kernel:  [<c0162f31>] __pollwait+0x0/0xa9
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [xfs_bmap+0/12] xfs_bmap+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0222a69>] xfs_bmap+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [__xfs_get_blocks+301/543] __xfs_get_block=
s+0x12d/0x21f
Jan 17 19:05:07 vosztok kernel:  [<c021cdd1>] __xfs_get_blocks+0x12d/0x21f
Jan 17 19:05:07 vosztok kernel:  [find_get_page+68/92] find_get_page+0x44/0=
x5c
Jan 17 19:05:07 vosztok kernel:  [<c013b791>] find_get_page+0x44/0x5c
Jan 17 19:05:07 vosztok kernel:  [__find_get_block_slow+35/260] __find_get_=
block_slow+0x23/0x104
Jan 17 19:05:07 vosztok kernel:  [<c01737af>] __find_get_block_slow+0x23/0x=
104
Jan 17 19:05:07 vosztok kernel:  [unmap_underlying_metadata+6/49] unmap_und=
erlying_metadata+0x6/0x31
Jan 17 19:05:07 vosztok kernel:  [<c017417e>] unmap_underlying_metadata+0x6=
/0x31
Jan 17 19:05:07 vosztok kernel:  [__block_prepare_write+588/1098] __block_p=
repare_write+0x24c/0x44a
Jan 17 19:05:07 vosztok kernel:  [<c01745c3>] __block_prepare_write+0x24c/0=
x44a
Jan 17 19:05:07 vosztok kernel:  [balance_dirty_pages_ratelimited_nr+397/42=
4] balance_dirty_pages_ratelimited_nr+0x18d/0x1a8
Jan 17 19:05:07 vosztok kernel:  [<c0140843>] balance_dirty_pages_ratelimit=
ed_nr+0x18d/0x1a8
Jan 17 19:05:07 vosztok kernel:  [__block_commit_write+94/136] __block_comm=
it_write+0x5e/0x88
Jan 17 19:05:07 vosztok kernel:  [<c0173f4b>] __block_commit_write+0x5e/0x88
Jan 17 19:05:07 vosztok kernel:  [generic_commit_write+141/151] generic_com=
mit_write+0x8d/0x97
Jan 17 19:05:07 vosztok kernel:  [<c0174002>] generic_commit_write+0x8d/0x97
Jan 17 19:05:07 vosztok kernel:  [generic_file_buffered_write+1296/1570] ge=
neric_file_buffered_write+0x510/0x622
Jan 17 19:05:07 vosztok kernel:  [<c013cc58>] generic_file_buffered_write+0=
x510/0x622
Jan 17 19:05:07 vosztok kernel:  [__wake_up_common+49/79] __wake_up_common+=
0x31/0x4f
Jan 17 19:05:07 vosztok kernel:  [<c01133ed>] __wake_up_common+0x31/0x4f
Jan 17 19:05:07 vosztok kernel:  [xfs_ilock+71/103] xfs_ilock+0x47/0x67
Jan 17 19:05:07 vosztok kernel:  [<c01fa71a>] xfs_ilock+0x47/0x67
Jan 17 19:05:07 vosztok kernel:  [xfs_iunlock+35/109] xfs_iunlock+0x23/0x6d
Jan 17 19:05:07 vosztok kernel:  [<c01fa684>] xfs_iunlock+0x23/0x6d
Jan 17 19:05:07 vosztok kernel:  [xfs_write+2604/2651] xfs_write+0xa2c/0xa5b
Jan 17 19:05:07 vosztok kernel:  [<c0223dd6>] xfs_write+0xa2c/0xa5b
Jan 17 19:05:07 vosztok kernel:  [core_sys_select+682/711] core_sys_select+=
0x2aa/0x2c7
Jan 17 19:05:07 vosztok kernel:  [<c0162d08>] core_sys_select+0x2aa/0x2c7
Jan 17 19:05:07 vosztok kernel:  [<e07a11f9>] snd_timer_user_tinterrupt+0x0=
/0x165 [snd_timer]
Jan 17 19:05:07 vosztok kernel:  [<e079fc6c>] snd_timer_interrupt+0x243/0x2=
84 [snd_timer]
Jan 17 19:05:07 vosztok kernel:  [xfs_file_aio_write+101/109] xfs_file_aio_=
write+0x65/0x6d
Jan 17 19:05:07 vosztok kernel:  [<c02202ed>] xfs_file_aio_write+0x65/0x6d
Jan 17 19:05:07 vosztok kernel:  [do_sync_write+198/265] do_sync_write+0xc6=
/0x109
Jan 17 19:05:07 vosztok kernel:  [<c01575dd>] do_sync_write+0xc6/0x109
Jan 17 19:05:07 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 19:05:07 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 19:05:07 vosztok kernel:  [sys_select+213/391] sys_select+0xd5/0x187
Jan 17 19:05:07 vosztok kernel:  [<c01630af>] sys_select+0xd5/0x187
Jan 17 19:05:07 vosztok kernel:  [vfs_write+252/268] vfs_write+0xfc/0x10c
Jan 17 19:05:07 vosztok kernel:  [<c0157dc7>] vfs_write+0xfc/0x10c
Jan 17 19:05:07 vosztok kernel:  [sys_write+65/103] sys_write+0x41/0x67
Jan 17 19:05:07 vosztok kernel:  [<c015822d>] sys_write+0x41/0x67
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: emerge        ? 00000287     0 20648  19625
Jan 17 19:05:07 vosztok kernel:        d6dd3f74 00000046 dabf7b84 00000287 =
cd362540 c043ccfc d6dd3f90 dabf7a40=20
Jan 17 19:05:07 vosztok kernel:        00000010 dabf7b24 c011ad2c 00000007 =
d6dd3fb8 cd362a80 00000001 d6dd3fb0=20
Jan 17 19:05:07 vosztok kernel:        d6dd3f90 d6dd3f90 cd362700 00000000 =
46be2268 d6dd2000 c011ada9 00000000=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [do_exit+1833/1837] do_exit+0x729/0x72d
Jan 17 19:05:07 vosztok kernel:  [<c011ad2c>] do_exit+0x729/0x72d
Jan 17 19:05:07 vosztok kernel:  [sys_exit_group+0/13] sys_exit_group+0x0/0=
xd
Jan 17 19:05:07 vosztok kernel:  [<c011ada9>] sys_exit_group+0x0/0xd
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: bash          S 00000000     0 30029  14417
Jan 17 19:05:07 vosztok kernel:        d3ff1ee0 00000086 c7ced644 00000000 =
d4daf8c0 00000000 d5f41800 7fffffff=20
Jan 17 19:05:07 vosztok kernel:        d3ff1f44 bfc910d3 c036c8bf bfc9165c =
c1104ca0 00000000 c1104ca0 c0145a13=20
Jan 17 19:05:07 vosztok kernel:        bfc910d3 c0127a58 d5f41800 d5f41800 =
d5f41800 c0250b30 00000082 d25b8a80=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 19:05:07 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 19:05:07 vosztok kernel:  [do_wp_page+995/1086] do_wp_page+0x3e3/0x4=
3e
Jan 17 19:05:07 vosztok kernel:  [<c0145a13>] do_wp_page+0x3e3/0x43e
Jan 17 19:05:07 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 19:05:07 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 19:05:07 vosztok kernel:  [read_chan+752/1324] read_chan+0x2f0/0x52c
Jan 17 19:05:07 vosztok kernel:  [<c0250b30>] read_chan+0x2f0/0x52c
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [read_chan+0/1324] read_chan+0x0/0x52c
Jan 17 19:05:07 vosztok kernel:  [<c0250840>] read_chan+0x0/0x52c
Jan 17 19:05:07 vosztok kernel:  [tty_read+100/172] tty_read+0x64/0xac
Jan 17 19:05:07 vosztok kernel:  [<c024dc05>] tty_read+0x64/0xac
Jan 17 19:05:07 vosztok kernel:  [tty_read+0/172] tty_read+0x0/0xac
Jan 17 19:05:07 vosztok kernel:  [<c024dba1>] tty_read+0x0/0xac
Jan 17 19:05:07 vosztok kernel:  [vfs_read+136/266] vfs_read+0x88/0x10a
Jan 17 19:05:07 vosztok kernel:  [<c0157e5f>] vfs_read+0x88/0x10a
Jan 17 19:05:07 vosztok kernel:  [sys_read+65/103] sys_read+0x41/0x67
Jan 17 19:05:07 vosztok kernel:  [<c01581c6>] sys_read+0x41/0x67
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: sandbox       S c3f83f98     0   791  19625
Jan 17 19:05:07 vosztok kernel:        c1d6ff34 00200086 c2f36bc4 c3f83f98 =
c3be2e00 00000000 00000318 00000001=20
Jan 17 19:05:07 vosztok kernel:        c2f36000 00000000 c011a464 00000f98 =
de190468 00000001 d402c688 00000004=20
Jan 17 19:05:07 vosztok kernel:        00000318 c2f36a80 00000001 00000001 =
00000000 c2f36b64 c01173a2 00000000=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 19:05:07 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 19:05:07 vosztok kernel:  [do_fork+252/443] do_fork+0xfc/0x1bb
Jan 17 19:05:07 vosztok kernel:  [<c01173a2>] do_fork+0xfc/0x1bb
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 19:05:07 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 19:05:07 vosztok kernel:  [sys_waitpid+39/43] sys_waitpid+0x27/0x2b
Jan 17 19:05:07 vosztok kernel:  [<c011a59e>] sys_waitpid+0x27/0x2b
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: ebuild.sh     S de4ee940     0   792    791
Jan 17 19:05:07 vosztok kernel:        c3657f34 00200086 c2f36144 de4ee940 =
c3be2700 00000000 ffffffff 00000001=20
Jan 17 19:05:07 vosztok kernel:        d07ff500 00000000 c011a464 00000940 =
de362080 082897a8 d402c738 00000004=20
Jan 17 19:05:07 vosztok kernel:        ffffffff c2f36000 00000001 00000001 =
00000000 c2f360e4 c01173a2 00000000=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 19:05:07 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 19:05:07 vosztok kernel:  [do_fork+252/443] do_fork+0xfc/0x1bb
Jan 17 19:05:07 vosztok kernel:  [<c01173a2>] do_fork+0xfc/0x1bb
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 19:05:07 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 19:05:07 vosztok kernel:  [sys_waitpid+39/43] sys_waitpid+0x27/0x2b
Jan 17 19:05:07 vosztok kernel:  [<c011a59e>] sys_waitpid+0x27/0x2b
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: dhcpcd        S 00000000     0   793      1
Jan 17 19:05:07 vosztok kernel:        de8e1b60 00000082 c2f37b84 00000000 =
c3be2c40 00000286 00471281 de8e1b70=20
Jan 17 19:05:07 vosztok kernel:        00000006 00000020 c036c924 c0127a58 =
c8711c00 c04894e8 c04894e8 00471281=20
Jan 17 19:05:07 vosztok kernel:        c011efb9 c2f37a40 c04888c0 00000000 =
de8e1f9c c0162a11 de8e1f9c de8e1f48=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [schedule_timeout+120/149] schedule_timeou=
t+0x78/0x95
Jan 17 19:05:07 vosztok kernel:  [<c036c924>] schedule_timeout+0x78/0x95
Jan 17 19:05:07 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 19:05:07 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 19:05:07 vosztok kernel:  [process_timeout+0/5] process_timeout+0x0/=
0x5
Jan 17 19:05:07 vosztok kernel:  [<c011efb9>] process_timeout+0x0/0x5
Jan 17 19:05:07 vosztok kernel:  [do_select+916/993] do_select+0x394/0x3e1
Jan 17 19:05:07 vosztok kernel:  [<c0162a11>] do_select+0x394/0x3e1
Jan 17 19:05:07 vosztok kernel:  [__pollwait+0/169] __pollwait+0x0/0xa9
Jan 17 19:05:07 vosztok kernel:  [<c0162f31>] __pollwait+0x0/0xa9
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [xfs_bmap+0/12] xfs_bmap+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0222a69>] xfs_bmap+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [__xfs_get_blocks+112/543] __xfs_get_block=
s+0x70/0x21f
Jan 17 19:05:07 vosztok kernel:  [<c021cd14>] __xfs_get_blocks+0x70/0x21f
Jan 17 19:05:07 vosztok kernel:  [find_get_page+68/92] find_get_page+0x44/0=
x5c
Jan 17 19:05:07 vosztok kernel:  [<c013b791>] find_get_page+0x44/0x5c
Jan 17 19:05:07 vosztok kernel:  [__find_get_block_slow+35/260] __find_get_=
block_slow+0x23/0x104
Jan 17 19:05:07 vosztok kernel:  [<c01737af>] __find_get_block_slow+0x23/0x=
104
Jan 17 19:05:07 vosztok kernel:  [__mark_inode_dirty+326/360] __mark_inode_=
dirty+0x146/0x168
Jan 17 19:05:07 vosztok kernel:  [<c01706fd>] __mark_inode_dirty+0x146/0x168
Jan 17 19:05:07 vosztok kernel:  [unmap_underlying_metadata+6/49] unmap_und=
erlying_metadata+0x6/0x31
Jan 17 19:05:07 vosztok kernel:  [<c017417e>] unmap_underlying_metadata+0x6=
/0x31
Jan 17 19:05:07 vosztok kernel:  [__block_prepare_write+588/1098] __block_p=
repare_write+0x24c/0x44a
Jan 17 19:05:07 vosztok kernel:  [<c01745c3>] __block_prepare_write+0x24c/0=
x44a
Jan 17 19:05:07 vosztok kernel:  [balance_dirty_pages_ratelimited_nr+397/42=
4] balance_dirty_pages_ratelimited_nr+0x18d/0x1a8
Jan 17 19:05:07 vosztok kernel:  [<c0140843>] balance_dirty_pages_ratelimit=
ed_nr+0x18d/0x1a8
Jan 17 19:05:07 vosztok kernel:  [__block_commit_write+94/136] __block_comm=
it_write+0x5e/0x88
Jan 17 19:05:07 vosztok kernel:  [<c0173f4b>] __block_commit_write+0x5e/0x88
Jan 17 19:05:07 vosztok kernel:  [__pagevec_lru_add+182/193] __pagevec_lru_=
add+0xb6/0xc1
Jan 17 19:05:07 vosztok kernel:  [<c014196b>] __pagevec_lru_add+0xb6/0xc1
Jan 17 19:05:07 vosztok kernel:  [generic_file_buffered_write+1487/1570] ge=
neric_file_buffered_write+0x5cf/0x622
Jan 17 19:05:07 vosztok kernel:  [<c013cd17>] generic_file_buffered_write+0=
x5cf/0x622
Jan 17 19:05:07 vosztok kernel:  [do_lookup+79/320] do_lookup+0x4f/0x140
Jan 17 19:05:07 vosztok kernel:  [<c015df2a>] do_lookup+0x4f/0x140
Jan 17 19:05:07 vosztok kernel:  [_atomic_dec_and_lock+37/64] _atomic_dec_a=
nd_lock+0x25/0x40
Jan 17 19:05:07 vosztok kernel:  [<c02390e9>] _atomic_dec_and_lock+0x25/0x40
Jan 17 19:05:07 vosztok kernel:  [xfs_ilock+71/103] xfs_ilock+0x47/0x67
Jan 17 19:05:07 vosztok kernel:  [<c01fa71a>] xfs_ilock+0x47/0x67
Jan 17 19:05:07 vosztok kernel:  [xfs_iunlock+35/109] xfs_iunlock+0x23/0x6d
Jan 17 19:05:07 vosztok kernel:  [<c01fa684>] xfs_iunlock+0x23/0x6d
Jan 17 19:05:07 vosztok kernel:  [xfs_write+2604/2651] xfs_write+0xa2c/0xa5b
Jan 17 19:05:07 vosztok kernel:  [<c0223dd6>] xfs_write+0xa2c/0xa5b
Jan 17 19:05:07 vosztok kernel:  [core_sys_select+682/711] core_sys_select+=
0x2aa/0x2c7
Jan 17 19:05:07 vosztok kernel:  [<c0162d08>] core_sys_select+0x2aa/0x2c7
Jan 17 19:05:07 vosztok kernel:  [get_page_from_freelist+463/820] get_page_=
from_freelist+0x1cf/0x334
Jan 17 19:05:07 vosztok kernel:  [<c013f545>] get_page_from_freelist+0x1cf/=
0x334
Jan 17 19:05:07 vosztok kernel:  [find_lock_page+151/176] find_lock_page+0x=
97/0xb0
Jan 17 19:05:07 vosztok kernel:  [<c013b965>] find_lock_page+0x97/0xb0
Jan 17 19:05:07 vosztok kernel:  [filemap_fault+586/969] filemap_fault+0x24=
a/0x3c9
Jan 17 19:05:07 vosztok kernel:  [<c013d90a>] filemap_fault+0x24a/0x3c9
Jan 17 19:05:07 vosztok kernel:  [__do_fault+729/773] __do_fault+0x2d9/0x305
Jan 17 19:05:07 vosztok kernel:  [<c0145312>] __do_fault+0x2d9/0x305
Jan 17 19:05:07 vosztok kernel:  [handle_mm_fault+731/1528] handle_mm_fault=
+0x2db/0x5f8
Jan 17 19:05:07 vosztok kernel:  [<c014683a>] handle_mm_fault+0x2db/0x5f8
Jan 17 19:05:07 vosztok kernel:  [sys_select+160/391] sys_select+0xa0/0x187
Jan 17 19:05:07 vosztok kernel:  [<c016307a>] sys_select+0xa0/0x187
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: make          S c3be2000     0  4609    792
Jan 17 19:05:07 vosztok kernel:        c6873f48 00200086 d07ff644 c3be2000 =
c3be2000 00000000 ffffffff 00000001=20
Jan 17 19:05:07 vosztok kernel:        d07ffa40 00000000 c011a464 d07ff500 =
c0114c20 00100100 00200200 00000004=20
Jan 17 19:05:07 vosztok kernel:        ffffffff d07ff500 00000001 00000001 =
00000000 d07ff5e4 c6873f9c 00000002=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 19:05:07 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 19:05:07 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: libtool       S c29bf114     0 10108   4609
Jan 17 19:05:07 vosztok kernel:        d180df34 00200082 d07ffb84 c29bf114 =
df0c5a80 00000000 ffffffff 00000001=20
Jan 17 19:05:07 vosztok kernel:        d07fe000 00000000 c011a464 00000114 =
de63bbf8 bf8461c8 ce0b9f78 00000004=20
Jan 17 19:05:07 vosztok kernel:        ffffffff d07ffa40 00000001 00000001 =
00000000 d07ffb24 c01173a2 00000000=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 19:05:07 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 19:05:07 vosztok kernel:  [do_fork+252/443] do_fork+0xfc/0x1bb
Jan 17 19:05:07 vosztok kernel:  [<c01173a2>] do_fork+0xfc/0x1bb
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 19:05:07 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 19:05:07 vosztok kernel:  [sys_waitpid+39/43] sys_waitpid+0x27/0x2b
Jan 17 19:05:07 vosztok kernel:  [<c011a59e>] sys_waitpid+0x27/0x2b
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: i686-pc-linux S c036bfe2     0 10268  10108
Jan 17 19:05:07 vosztok kernel:        cc48bf34 00200086 d07fe144 c036bfe2 =
df0c58c0 00000000 0000281d 00000001=20
Jan 17 19:05:07 vosztok kernel:        d07fea80 00000000 c011a464 00004111 =
cc48bf60 cc48bf68 c036c355 00000004=20
Jan 17 19:05:07 vosztok kernel:        0000281d d07fe000 00000001 00000001 =
00000000 d07fe0e4 00004000 c01173f0=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [schedule+572/755] schedule+0x23c/0x2f3
Jan 17 19:05:07 vosztok kernel:  [<c036bfe2>] schedule+0x23c/0x2f3
Jan 17 19:05:07 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 19:05:07 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 19:05:07 vosztok kernel:  [wait_for_completion+179/205] wait_for_com=
pletion+0xb3/0xcd
Jan 17 19:05:07 vosztok kernel:  [<c036c355>] wait_for_completion+0xb3/0xcd
Jan 17 19:05:07 vosztok kernel:  [do_fork+330/443] do_fork+0x14a/0x1bb
Jan 17 19:05:07 vosztok kernel:  [<c01173f0>] do_fork+0x14a/0x1bb
Jan 17 19:05:07 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:05:07 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 19:05:07 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 19:05:07 vosztok kernel:  [sys_waitpid+39/43] sys_waitpid+0x27/0x2b
Jan 17 19:05:07 vosztok kernel:  [<c011a59e>] sys_waitpid+0x27/0x2b
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: cc1           D dbe29cd4     0 10269  10268
Jan 17 19:05:07 vosztok kernel:        dbe29cd8 00200086 d07fe684 dbe29cd4 =
df0c5e00 c01279b8 dbe29ce8 c143bd38=20
Jan 17 19:05:07 vosztok kernel:        c13f0e70 c143bd38 c0167e39 c527cee4 =
00000003 00000000 d07fe540 c0127868=20
Jan 17 19:05:07 vosztok kernel:        c13f0e70 c13f0e70 019143eb de6d4a00 =
c0167e75 019143eb c143bd38 de6d4a00=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [prepare_to_wait+74/102] prepare_to_wait+0=
x4a/0x66
Jan 17 19:05:07 vosztok kernel:  [<c01279b8>] prepare_to_wait+0x4a/0x66
Jan 17 19:05:07 vosztok kernel:  [__wait_on_freeing_inode+130/155] __wait_o=
n_freeing_inode+0x82/0x9b
Jan 17 19:05:07 vosztok kernel:  [<c0167e39>] __wait_on_freeing_inode+0x82/=
0x9b
Jan 17 19:05:07 vosztok kernel:  [wake_bit_function+0/60] wake_bit_function=
+0x0/0x3c
Jan 17 19:05:07 vosztok kernel:  [<c0127868>] wake_bit_function+0x0/0x3c
Jan 17 19:05:07 vosztok kernel:  [find_inode_fast+35/66] find_inode_fast+0x=
23/0x42
Jan 17 19:05:07 vosztok kernel:  [<c0167e75>] find_inode_fast+0x23/0x42
Jan 17 19:05:07 vosztok kernel:  [ifind_fast+33/151] ifind_fast+0x21/0x97
Jan 17 19:05:07 vosztok kernel:  [<c0167f0b>] ifind_fast+0x21/0x97
Jan 17 19:05:07 vosztok kernel:  [iget_locked+44/312] iget_locked+0x2c/0x138
Jan 17 19:05:07 vosztok kernel:  [<c0168224>] iget_locked+0x2c/0x138
Jan 17 19:05:07 vosztok kernel:  [xfs_iget+38/253] xfs_iget+0x26/0xfd
Jan 17 19:05:07 vosztok kernel:  [<c01fb449>] xfs_iget+0x26/0xfd
Jan 17 19:05:07 vosztok kernel:  [enqueue_entity+466/499] enqueue_entity+0x=
1d2/0x1f3
Jan 17 19:05:07 vosztok kernel:  [<c0113e13>] enqueue_entity+0x1d2/0x1f3
Jan 17 19:05:07 vosztok kernel:  [xfs_dir_lookup_int+125/212] xfs_dir_looku=
p_int+0x7d/0xd4
Jan 17 19:05:07 vosztok kernel:  [<c0212d71>] xfs_dir_lookup_int+0x7d/0xd4
Jan 17 19:05:07 vosztok kernel:  [xfs_lookup+82/120] xfs_lookup+0x52/0x78
Jan 17 19:05:07 vosztok kernel:  [<c0215b01>] xfs_lookup+0x52/0x78
Jan 17 19:05:07 vosztok kernel:  [xfs_vn_lookup+59/112] xfs_vn_lookup+0x3b/=
0x70
Jan 17 19:05:07 vosztok kernel:  [<c0222262>] xfs_vn_lookup+0x3b/0x70
Jan 17 19:05:07 vosztok kernel:  [do_lookup+163/320] do_lookup+0xa3/0x140
Jan 17 19:05:07 vosztok kernel:  [<c015df7e>] do_lookup+0xa3/0x140
Jan 17 19:05:07 vosztok kernel:  [__link_path_walk+2025/3072] __link_path_w=
alk+0x7e9/0xc00
Jan 17 19:05:07 vosztok kernel:  [<c015f7ee>] __link_path_walk+0x7e9/0xc00
Jan 17 19:05:07 vosztok kernel:  [__do_softirq+89/133] __do_softirq+0x59/0x=
85
Jan 17 19:05:07 vosztok kernel:  [<c011bede>] __do_softirq+0x59/0x85
Jan 17 19:05:07 vosztok kernel:  [link_path_walk+66/175] link_path_walk+0x4=
2/0xaf
Jan 17 19:05:07 vosztok kernel:  [<c015fc47>] link_path_walk+0x42/0xaf
Jan 17 19:05:07 vosztok kernel:  [lru_cache_add_active+78/100] lru_cache_ad=
d_active+0x4e/0x64
Jan 17 19:05:07 vosztok kernel:  [<c0141c09>] lru_cache_add_active+0x4e/0x64
Jan 17 19:05:07 vosztok kernel:  [do_path_lookup+411/438] do_path_lookup+0x=
19b/0x1b6
Jan 17 19:05:07 vosztok kernel:  [<c015ffbf>] do_path_lookup+0x19b/0x1b6
Jan 17 19:05:07 vosztok kernel:  [getname+89/143] getname+0x59/0x8f
Jan 17 19:05:07 vosztok kernel:  [<c015ece1>] getname+0x59/0x8f
Jan 17 19:05:07 vosztok kernel:  [__user_walk_fd+47/69] __user_walk_fd+0x2f=
/0x45
Jan 17 19:05:07 vosztok kernel:  [<c0160776>] __user_walk_fd+0x2f/0x45
Jan 17 19:05:07 vosztok kernel:  [vfs_stat_fd+25/64] vfs_stat_fd+0x19/0x40
Jan 17 19:05:07 vosztok kernel:  [<c015a5ec>] vfs_stat_fd+0x19/0x40
Jan 17 19:05:07 vosztok kernel:  [lru_cache_add_active+78/100] lru_cache_ad=
d_active+0x4e/0x64
Jan 17 19:05:07 vosztok kernel:  [<c0141c09>] lru_cache_add_active+0x4e/0x64
Jan 17 19:05:07 vosztok kernel:  [sys_stat64+15/35] sys_stat64+0xf/0x23
Jan 17 19:05:07 vosztok kernel:  [<c015a6a0>] sys_stat64+0xf/0x23
Jan 17 19:05:07 vosztok kernel:  [dput+204/314] dput+0xcc/0x13a
Jan 17 19:05:07 vosztok kernel:  [<c0165f03>] dput+0xcc/0x13a
Jan 17 19:05:07 vosztok kernel:  [__fput+308/350] __fput+0x134/0x15e
Jan 17 19:05:07 vosztok kernel:  [<c0158622>] __fput+0x134/0x15e
Jan 17 19:05:07 vosztok kernel:  [do_page_fault+0/1439] do_page_fault+0x0/0=
x59f
Jan 17 19:05:07 vosztok kernel:  [<c01123e1>] do_page_fault+0x0/0x59f
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:07 vosztok kernel: as            S 00000000     0 10270  10268
Jan 17 19:05:07 vosztok kernel:        c7ce1e58 00200082 d07febc4 00000000 =
df0c5c40 c01279b8 d21ec400 de859b90=20
Jan 17 19:05:07 vosztok kernel:        c7ce1e74 d21ec400 c015d010 00000000 =
d07fea80 c0127833 d21ec400 d21ec400=20
Jan 17 19:05:07 vosztok kernel:        00000400 c7ce1edc c015d740 00200046 =
c7ce1f64 00000000 dee38800 de859b90=20
Jan 17 19:05:07 vosztok kernel: Call Trace:
Jan 17 19:05:07 vosztok kernel:  [prepare_to_wait+74/102] prepare_to_wait+0=
x4a/0x66
Jan 17 19:05:07 vosztok kernel:  [<c01279b8>] prepare_to_wait+0x4a/0x66
Jan 17 19:05:07 vosztok kernel:  [pipe_wait+80/110] pipe_wait+0x50/0x6e
Jan 17 19:05:07 vosztok kernel:  [<c015d010>] pipe_wait+0x50/0x6e
Jan 17 19:05:07 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 19:05:07 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 19:05:07 vosztok kernel:  [pipe_read+684/796] pipe_read+0x2ac/0x31c
Jan 17 19:05:07 vosztok kernel:  [<c015d740>] pipe_read+0x2ac/0x31c
Jan 17 19:05:07 vosztok kernel:  [vma_adjust+821/962] vma_adjust+0x335/0x3c2
Jan 17 19:05:07 vosztok kernel:  [<c0148e92>] vma_adjust+0x335/0x3c2
Jan 17 19:05:07 vosztok kernel:  [do_sync_read+198/265] do_sync_read+0xc6/0=
x109
Jan 17 19:05:07 vosztok kernel:  [<c01576e6>] do_sync_read+0xc6/0x109
Jan 17 19:05:07 vosztok kernel:  [mmap_region+786/974] mmap_region+0x312/0x=
3ce
Jan 17 19:05:07 vosztok kernel:  [<c0149b48>] mmap_region+0x312/0x3ce
Jan 17 19:05:07 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 19:05:07 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 19:05:07 vosztok kernel:  [do_sync_read+0/265] do_sync_read+0x0/0x109
Jan 17 19:05:07 vosztok kernel:  [<c0157620>] do_sync_read+0x0/0x109
Jan 17 19:05:07 vosztok kernel:  [vfs_read+136/266] vfs_read+0x88/0x10a
Jan 17 19:05:07 vosztok kernel:  [<c0157e5f>] vfs_read+0x88/0x10a
Jan 17 19:05:07 vosztok kernel:  [sys_read+65/103] sys_read+0x41/0x67
Jan 17 19:05:07 vosztok kernel:  [<c01581c6>] sys_read+0x41/0x67
Jan 17 19:05:07 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:05:07 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:05:07 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:05:20 vosztok kernel: SysRq : HELP : loglevel0-8 reBoot tErm Full=
 kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showTa=
sks Unmount shoW-blocked-tasks=20
Jan 17 19:07:17 vosztok kernel: klogd 1.4.1, log source =3D /proc/kmsg star=
ted.
Jan 17 19:07:17 vosztok kernel: Inspecting /boot/System.map
Jan 17 19:07:18 vosztok kernel: Loaded 28989 symbols from /boot/System.map.
Jan 17 19:07:18 vosztok kernel: Symbols match kernel version 2.6.23.
Jan 17 19:07:18 vosztok kernel: 27833>] autoremove_wake_function+0x0/0x35
Jan 17 19:07:18 vosztok kernel:  [<e0053c31>] hub_thread+0x0/0xa25 [usbcore]
Jan 17 19:07:18 vosztok kernel:  [kthread+54/92] kthread+0x36/0x5c
Jan 17 19:07:18 vosztok kernel:  [<c012777a>] kthread+0x36/0x5c
Jan 17 19:07:18 vosztok kernel:  [kthread+0/92] kthread+0x0/0x5c
Jan 17 19:07:18 vosztok kernel:  [<c0127744>] kthread+0x0/0x5c
Jan 17 19:07:18 vosztok kernel:  [kernel_thread_helper+7/16] kernel_thread_=
helper+0x7/0x10
Jan 17 19:07:18 vosztok kernel:  [<c0104917>] kernel_thread_helper+0x7/0x10
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: ksnapd        S c149efc0     0  1874      2
Jan 17 19:07:18 vosztok kernel:        ddcc9fb4 00000046 df409104 c149efc0 =
de191540 c01279b8 de15d500 c01250e0=20
Jan 17 19:07:18 vosztok kernel:        ddcc9fd0 00000000 c0125161 00000000 =
df408fc0 c0127833 de15d508 de15d508=20
Jan 17 19:07:18 vosztok kernel:        de15d500 00000000 c012777a c0127744 =
00000000 c0104917 de6cde78 00000000=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [prepare_to_wait+74/102] prepare_to_wait+0=
x4a/0x66
Jan 17 19:07:18 vosztok kernel:  [<c01279b8>] prepare_to_wait+0x4a/0x66
Jan 17 19:07:18 vosztok kernel:  [worker_thread+0/188] worker_thread+0x0/0x=
bc
Jan 17 19:07:18 vosztok kernel:  [<c01250e0>] worker_thread+0x0/0xbc
Jan 17 19:07:18 vosztok kernel:  [worker_thread+129/188] worker_thread+0x81=
/0xbc
Jan 17 19:07:18 vosztok kernel:  [<c0125161>] worker_thread+0x81/0xbc
Jan 17 19:07:18 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 19:07:18 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 19:07:18 vosztok kernel:  [kthread+54/92] kthread+0x36/0x5c
Jan 17 19:07:18 vosztok kernel:  [<c012777a>] kthread+0x36/0x5c
Jan 17 19:07:18 vosztok kernel:  [kthread+0/92] kthread+0x0/0x5c
Jan 17 19:07:18 vosztok kernel:  [<c0127744>] kthread+0x0/0x5c
Jan 17 19:07:18 vosztok kernel:  [kernel_thread_helper+7/16] kernel_thread_=
helper+0x7/0x10
Jan 17 19:07:18 vosztok kernel:  [<c0104917>] kernel_thread_helper+0x7/0x10
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: dm-bbr/0      S df41b500     0  1973      2
Jan 17 19:07:18 vosztok kernel:        ddfe9fb4 00000046 c1483b84 df41b500 =
de191540 c01279b8 de15d580 c01250e0=20
Jan 17 19:07:18 vosztok kernel:        ddfe9fd0 00000000 c0125161 00000000 =
c1483a40 c0127833 de15d588 de15d588=20
Jan 17 19:07:18 vosztok kernel:        de15d580 00000000 c012777a c0127744 =
00000000 c0104917 de6c1e7c 00000000=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [prepare_to_wait+74/102] prepare_to_wait+0=
x4a/0x66
Jan 17 19:07:18 vosztok kernel:  [<c01279b8>] prepare_to_wait+0x4a/0x66
Jan 17 19:07:18 vosztok kernel:  [worker_thread+0/188] worker_thread+0x0/0x=
bc
Jan 17 19:07:18 vosztok kernel:  [<c01250e0>] worker_thread+0x0/0xbc
Jan 17 19:07:18 vosztok kernel:  [worker_thread+129/188] worker_thread+0x81=
/0xbc
Jan 17 19:07:18 vosztok kernel:  [<c0125161>] worker_thread+0x81/0xbc
Jan 17 19:07:18 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 19:07:18 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 19:07:18 vosztok kernel:  [kthread+54/92] kthread+0x36/0x5c
Jan 17 19:07:18 vosztok kernel:  [<c012777a>] kthread+0x36/0x5c
Jan 17 19:07:18 vosztok kernel:  [kthread+0/92] kthread+0x0/0x5c
Jan 17 19:07:18 vosztok kernel:  [<c0127744>] kthread+0x0/0x5c
Jan 17 19:07:18 vosztok kernel:  [kernel_thread_helper+7/16] kernel_thread_=
helper+0x7/0x10
Jan 17 19:07:18 vosztok kernel:  [<c0104917>] kernel_thread_helper+0x7/0x10
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: rpciod/0      S de1d5a40     0  2181      2
Jan 17 19:07:18 vosztok kernel:        de1d9fb4 00000046 de1d4bc4 de1d5a40 =
de1918c0 c01279b8 de15d640 c01250e0=20
Jan 17 19:07:18 vosztok kernel:        de1d9fd0 00000000 c0125161 00000000 =
de1d4a80 c0127833 de15d648 de15d648=20
Jan 17 19:07:18 vosztok kernel:        de15d640 00000000 c012777a c0127744 =
00000000 c0104917 de6dde78 00000000=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [prepare_to_wait+74/102] prepare_to_wait+0=
x4a/0x66
Jan 17 19:07:18 vosztok kernel:  [<c01279b8>] prepare_to_wait+0x4a/0x66
Jan 17 19:07:18 vosztok kernel:  [worker_thread+0/188] worker_thread+0x0/0x=
bc
Jan 17 19:07:18 vosztok kernel:  [<c01250e0>] worker_thread+0x0/0xbc
Jan 17 19:07:18 vosztok kernel:  [worker_thread+129/188] worker_thread+0x81=
/0xbc
Jan 17 19:07:18 vosztok kernel:  [<c0125161>] worker_thread+0x81/0xbc
Jan 17 19:07:18 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 19:07:18 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 19:07:18 vosztok kernel:  [kthread+54/92] kthread+0x36/0x5c
Jan 17 19:07:18 vosztok kernel:  [<c012777a>] kthread+0x36/0x5c
Jan 17 19:07:18 vosztok kernel:  [kthread+0/92] kthread+0x0/0x5c
Jan 17 19:07:18 vosztok kernel:  [<c0127744>] kthread+0x0/0x5c
Jan 17 19:07:18 vosztok kernel:  [kernel_thread_helper+7/16] kernel_thread_=
helper+0x7/0x10
Jan 17 19:07:18 vosztok kernel:  [<c0104917>] kernel_thread_helper+0x7/0x10
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: xfsbufd       S 00000000     0  2582      2
Jan 17 19:07:18 vosztok kernel:        dec77f90 00000046 df41abc4 00000000 =
dbca1a80 00000286 002f479a dec77fa0=20
Jan 17 19:07:18 vosztok kernel:        00000000 00000000 c036c924 c02329bb =
00000000 c0489100 c0489100 002f479a=20
Jan 17 19:07:18 vosztok kernel:        c011efb9 df41aa80 c04888c0 000003e8 =
dec30980 c021fa8f dec77fc4 dec77fc4=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [schedule_timeout+120/149] schedule_timeou=
t+0x78/0x95
Jan 17 19:07:18 vosztok kernel:  [<c036c924>] schedule_timeout+0x78/0x95
Jan 17 19:07:18 vosztok kernel:  [__generic_unplug_device+29/31] __generic_=
unplug_device+0x1d/0x1f
Jan 17 19:07:18 vosztok kernel:  [<c02329bb>] __generic_unplug_device+0x1d/=
0x1f
Jan 17 19:07:18 vosztok kernel:  [process_timeout+0/5] process_timeout+0x0/=
0x5
Jan 17 19:07:18 vosztok kernel:  [<c011efb9>] process_timeout+0x0/0x5
Jan 17 19:07:18 vosztok kernel:  [xfsbufd+95/240] xfsbufd+0x5f/0xf0
Jan 17 19:07:18 vosztok kernel:  [<c021fa8f>] xfsbufd+0x5f/0xf0
Jan 17 19:07:18 vosztok kernel:  [xfsbufd+0/240] xfsbufd+0x0/0xf0
Jan 17 19:07:18 vosztok kernel:  [<c021fa30>] xfsbufd+0x0/0xf0
Jan 17 19:07:18 vosztok kernel:  [kthread+54/92] kthread+0x36/0x5c
Jan 17 19:07:18 vosztok kernel:  [<c012777a>] kthread+0x36/0x5c
Jan 17 19:07:18 vosztok kernel:  [kthread+0/92] kthread+0x0/0x5c
Jan 17 19:07:18 vosztok kernel:  [<c0127744>] kthread+0x0/0x5c
Jan 17 19:07:18 vosztok kernel:  [kernel_thread_helper+7/16] kernel_thread_=
helper+0x7/0x10
Jan 17 19:07:18 vosztok kernel:  [<c0104917>] kernel_thread_helper+0x7/0x10
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: xfssyncd      S 00000000     0  2583      2
Jan 17 19:07:18 vosztok kernel:        de1dbf8c 00000046 df41b644 00000000 =
dbca1a80 00000286 002f4d90 de1dbf9c=20
Jan 17 19:07:18 vosztok kernel:        de1dbfc0 00007530 c036c924 00000000 =
00000003 c0489130 c0489130 002f4d90=20
Jan 17 19:07:18 vosztok kernel:        c011efb9 df41b500 c04888c0 de1dbfc0 =
de159d80 c02245cf de1dbfc0 de1dbfc0=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [schedule_timeout+120/149] schedule_timeou=
t+0x78/0x95
Jan 17 19:07:18 vosztok kernel:  [<c036c924>] schedule_timeout+0x78/0x95
Jan 17 19:07:18 vosztok kernel:  [process_timeout+0/5] process_timeout+0x0/=
0x5
Jan 17 19:07:18 vosztok kernel:  [<c011efb9>] process_timeout+0x0/0x5
Jan 17 19:07:18 vosztok kernel:  [xfssyncd+54/316] xfssyncd+0x36/0x13c
Jan 17 19:07:18 vosztok kernel:  [<c02245cf>] xfssyncd+0x36/0x13c
Jan 17 19:07:18 vosztok kernel:  [xfssyncd+0/316] xfssyncd+0x0/0x13c
Jan 17 19:07:18 vosztok kernel:  [<c0224599>] xfssyncd+0x0/0x13c
Jan 17 19:07:18 vosztok kernel:  [kthread+54/92] kthread+0x36/0x5c
Jan 17 19:07:18 vosztok kernel:  [<c012777a>] kthread+0x36/0x5c
Jan 17 19:07:18 vosztok kernel:  [kthread+0/92] kthread+0x0/0x5c
Jan 17 19:07:18 vosztok kernel:  [<c0127744>] kthread+0x0/0x5c
Jan 17 19:07:18 vosztok kernel:  [kernel_thread_helper+7/16] kernel_thread_=
helper+0x7/0x10
Jan 17 19:07:18 vosztok kernel:  [<c0104917>] kernel_thread_helper+0x7/0x10
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: pccardd       S fffb9dc4     0  3737      2
Jan 17 19:07:18 vosztok kernel:        de227fa4 00000046 dd8de144 fffb9dc4 =
df2e8700 de227fc8 00000202 ddf9f428=20
Jan 17 19:07:18 vosztok kernel:        00000000 00000000 e07b4c8f e07b4ad3 =
de227fd4 00000000 dd8de000 c0114c20=20
Jan 17 19:07:18 vosztok kernel:        ddf9f55c ddf9f55c 00004000 ddf9f428 =
e07b4ad3 00000000 c012777a c0127744=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [<e07b4c8f>] pccardd+0x1bc/0x20a [pcmcia_c=
ore]
Jan 17 19:07:18 vosztok kernel:  [<e07b4ad3>] pccardd+0x0/0x20a [pcmcia_cor=
e]
Jan 17 19:07:18 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:07:18 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:07:18 vosztok kernel:  [<e07b4ad3>] pccardd+0x0/0x20a [pcmcia_cor=
e]
Jan 17 19:07:18 vosztok kernel:  [kthread+54/92] kthread+0x36/0x5c
Jan 17 19:07:18 vosztok kernel:  [<c012777a>] kthread+0x36/0x5c
Jan 17 19:07:18 vosztok kernel:  [kthread+0/92] kthread+0x0/0x5c
Jan 17 19:07:18 vosztok kernel:  [<c0127744>] kthread+0x0/0x5c
Jan 17 19:07:18 vosztok kernel:  [kernel_thread_helper+7/16] kernel_thread_=
helper+0x7/0x10
Jan 17 19:07:18 vosztok kernel:  [<c0104917>] kernel_thread_helper+0x7/0x10
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: ipw2200/0     S de021688     0  3742      2
Jan 17 19:07:18 vosztok kernel:        df2c9fb4 00000046 dd8df644 de021688 =
dbca1a80 c01279b8 de021680 c01250e0=20
Jan 17 19:07:18 vosztok kernel:        df2c9fd0 00000000 c0125161 00000000 =
dd8df500 c0127833 de021688 de021688=20
Jan 17 19:07:18 vosztok kernel:        de021680 00000000 c012777a c0127744 =
00000000 c0104917 df385db0 00000000=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [prepare_to_wait+74/102] prepare_to_wait+0=
x4a/0x66
Jan 17 19:07:18 vosztok kernel:  [<c01279b8>] prepare_to_wait+0x4a/0x66
Jan 17 19:07:18 vosztok kernel:  [worker_thread+0/188] worker_thread+0x0/0x=
bc
Jan 17 19:07:18 vosztok kernel:  [<c01250e0>] worker_thread+0x0/0xbc
Jan 17 19:07:18 vosztok kernel:  [worker_thread+129/188] worker_thread+0x81=
/0xbc
Jan 17 19:07:18 vosztok kernel:  [<c0125161>] worker_thread+0x81/0xbc
Jan 17 19:07:18 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 19:07:18 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 19:07:18 vosztok kernel:  [kthread+54/92] kthread+0x36/0x5c
Jan 17 19:07:18 vosztok kernel:  [<c012777a>] kthread+0x36/0x5c
Jan 17 19:07:18 vosztok kernel:  [kthread+0/92] kthread+0x0/0x5c
Jan 17 19:07:18 vosztok kernel:  [<c0127744>] kthread+0x0/0x5c
Jan 17 19:07:18 vosztok kernel:  [kernel_thread_helper+7/16] kernel_thread_=
helper+0x7/0x10
Jan 17 19:07:18 vosztok kernel:  [<c0104917>] kernel_thread_helper+0x7/0x10
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: fbsplashd.sta ? df492540     0  3878      1
Jan 17 19:07:18 vosztok kernel:        dd799e84 00000046 df492684 df492540 =
df2e8a80 dd799f10 dd799ea0 df492540=20
Jan 17 19:07:18 vosztok kernel:        00000010 df492624 c011ad2c c0114c02 =
00000000 00000001 00000086 df475500=20
Jan 17 19:07:18 vosztok kernel:        dd799ea0 dd799ea0 df6a4e00 0000000f =
0000000f dd799f10 c011ada9 df0e30ec=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [do_exit+1833/1837] do_exit+0x729/0x72d
Jan 17 19:07:18 vosztok kernel:  [<c011ad2c>] do_exit+0x729/0x72d
Jan 17 19:07:18 vosztok kernel:  [try_to_wake_up+134/164] try_to_wake_up+0x=
86/0xa4
Jan 17 19:07:18 vosztok kernel:  [<c0114c02>] try_to_wake_up+0x86/0xa4
Jan 17 19:07:18 vosztok kernel:  [sys_exit_group+0/13] sys_exit_group+0x0/0=
xd
Jan 17 19:07:18 vosztok kernel:  [<c011ada9>] sys_exit_group+0x0/0xd
Jan 17 19:07:18 vosztok kernel:  [get_signal_to_deliver+1009/1054] get_sign=
al_to_deliver+0x3f1/0x41e
Jan 17 19:07:18 vosztok kernel:  [<c0121c20>] get_signal_to_deliver+0x3f1/0=
x41e
Jan 17 19:07:18 vosztok kernel:  [do_sync_read+198/265] do_sync_read+0xc6/0=
x109
Jan 17 19:07:18 vosztok kernel:  [<c01576e6>] do_sync_read+0xc6/0x109
Jan 17 19:07:18 vosztok kernel:  [do_notify_resume+129/1502] do_notify_resu=
me+0x81/0x5de
Jan 17 19:07:18 vosztok kernel:  [<c0103587>] do_notify_resume+0x81/0x5de
Jan 17 19:07:18 vosztok kernel:  [xfs_iflush_done+0/131] xfs_iflush_done+0x=
0/0x83
Jan 17 19:07:18 vosztok kernel:  [<c02004ab>] xfs_iflush_done+0x0/0x83
Jan 17 19:07:18 vosztok kernel:  [hrtimer_interrupt+433/473] hrtimer_interr=
upt+0x1b1/0x1d9
Jan 17 19:07:18 vosztok kernel:  [<c012a787>] hrtimer_interrupt+0x1b1/0x1d9
Jan 17 19:07:18 vosztok kernel:  [do_sync_read+0/265] do_sync_read+0x0/0x109
Jan 17 19:07:18 vosztok kernel:  [<c0157620>] do_sync_read+0x0/0x109
Jan 17 19:07:18 vosztok kernel:  [vfs_read+136/266] vfs_read+0x88/0x10a
Jan 17 19:07:18 vosztok kernel:  [<c0157e5f>] vfs_read+0x88/0x10a
Jan 17 19:07:18 vosztok kernel:  [sys_read+95/103] sys_read+0x5f/0x67
Jan 17 19:07:18 vosztok kernel:  [<c01581e4>] sys_read+0x5f/0x67
Jan 17 19:07:18 vosztok kernel:  [work_notifysig+19/25] work_notifysig+0x13=
/0x19
Jan 17 19:07:18 vosztok kernel:  [<c0103e9a>] work_notifysig+0x13/0x19
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: fbsplashd.sta D 002e134a     0  3879      1
Jan 17 19:07:18 vosztok kernel:        dd7b9de0 00000046 df493644 002e134a =
db6571c0 df5fc000 c041edd8 df493500=20
Jan 17 19:07:18 vosztok kernel:        df2e8a80 dd7b9f10 c036ccbe c041eddc =
c041eddc df493500 df5fc000 c03778e0=20
Jan 17 19:07:18 vosztok kernel:        c036cae9 c0168c05 7fffffff 00000000 =
dd7b9e0c dd7b9e0c df5fc000 c03778e0=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [__mutex_lock_slowpath+101/174] __mutex_lo=
ck_slowpath+0x65/0xae
Jan 17 19:07:18 vosztok kernel:  [<c036ccbe>] __mutex_lock_slowpath+0x65/0x=
ae
Jan 17 19:07:18 vosztok kernel:  [mutex_lock+9/10] mutex_lock+0x9/0xa
Jan 17 19:07:18 vosztok kernel:  [<c036cae9>] mutex_lock+0x9/0xa
Jan 17 19:07:18 vosztok kernel:  [invalidate_inodes+31/222] invalidate_inod=
es+0x1f/0xde
Jan 17 19:07:18 vosztok kernel:  [<c0168c05>] invalidate_inodes+0x1f/0xde
Jan 17 19:07:18 vosztok kernel:  [generic_shutdown_super+49/230] generic_sh=
utdown_super+0x31/0xe6
Jan 17 19:07:18 vosztok kernel:  [<c015906b>] generic_shutdown_super+0x31/0=
xe6
Jan 17 19:07:18 vosztok kernel:  [d_genocide+83/107] d_genocide+0x53/0x6b
Jan 17 19:07:18 vosztok kernel:  [<c0166d2b>] d_genocide+0x53/0x6b
Jan 17 19:07:18 vosztok kernel:  [kill_anon_super+9/69] kill_anon_super+0x9=
/0x45
Jan 17 19:07:18 vosztok kernel:  [<c0159144>] kill_anon_super+0x9/0x45
Jan 17 19:07:18 vosztok kernel:  [deactivate_super+73/92] deactivate_super+=
0x49/0x5c
Jan 17 19:07:18 vosztok kernel:  [<c01591e0>] deactivate_super+0x49/0x5c
Jan 17 19:07:18 vosztok kernel:  [remove_vma+37/54] remove_vma+0x25/0x36
Jan 17 19:07:18 vosztok kernel:  [<c0148774>] remove_vma+0x25/0x36
Jan 17 19:07:18 vosztok kernel:  [exit_mmap+216/239] exit_mmap+0xd8/0xef
Jan 17 19:07:18 vosztok kernel:  [<c014885d>] exit_mmap+0xd8/0xef
Jan 17 19:07:18 vosztok kernel:  [mmput+31/137] mmput+0x1f/0x89
Jan 17 19:07:18 vosztok kernel:  [<c01160a3>] mmput+0x1f/0x89
Jan 17 19:07:18 vosztok kernel:  [do_exit+470/1837] do_exit+0x1d6/0x72d
Jan 17 19:07:18 vosztok kernel:  [<c011a7d9>] do_exit+0x1d6/0x72d
Jan 17 19:07:18 vosztok kernel:  [update_curr_load+110/131] update_curr_loa=
d+0x6e/0x83
Jan 17 19:07:18 vosztok kernel:  [<c011395f>] update_curr_load+0x6e/0x83
Jan 17 19:07:18 vosztok kernel:  [recalc_sigpending+10/27] recalc_sigpendin=
g+0xa/0x1b
Jan 17 19:07:18 vosztok kernel:  [<c011f77a>] recalc_sigpending+0xa/0x1b
Jan 17 19:07:18 vosztok kernel:  [dequeue_signal+255/284] dequeue_signal+0x=
ff/0x11c
Jan 17 19:07:18 vosztok kernel:  [<c0120ea9>] dequeue_signal+0xff/0x11c
Jan 17 19:07:18 vosztok kernel:  [sys_exit_group+0/13] sys_exit_group+0x0/0=
xd
Jan 17 19:07:18 vosztok kernel:  [<c011ada9>] sys_exit_group+0x0/0xd
Jan 17 19:07:18 vosztok kernel:  [get_signal_to_deliver+1009/1054] get_sign=
al_to_deliver+0x3f1/0x41e
Jan 17 19:07:18 vosztok kernel:  [<c0121c20>] get_signal_to_deliver+0x3f1/0=
x41e
Jan 17 19:07:18 vosztok kernel:  [__dequeue_signal+16/282] __dequeue_signal=
+0x10/0x11a
Jan 17 19:07:18 vosztok kernel:  [<c011fa3b>] __dequeue_signal+0x10/0x11a
Jan 17 19:07:18 vosztok kernel:  [do_notify_resume+129/1502] do_notify_resu=
me+0x81/0x5de
Jan 17 19:07:18 vosztok kernel:  [<c0103587>] do_notify_resume+0x81/0x5de
Jan 17 19:07:18 vosztok kernel:  [remove_vma+49/54] remove_vma+0x31/0x36
Jan 17 19:07:18 vosztok kernel:  [<c0148780>] remove_vma+0x31/0x36
Jan 17 19:07:18 vosztok kernel:  [__slab_free+92/670] __slab_free+0x5c/0x29e
Jan 17 19:07:18 vosztok kernel:  [<c01540ab>] __slab_free+0x5c/0x29e
Jan 17 19:07:18 vosztok kernel:  [quicklist_trim+189/222] quicklist_trim+0x=
bd/0xde
Jan 17 19:07:18 vosztok kernel:  [<c0155dff>] quicklist_trim+0xbd/0xde
Jan 17 19:07:18 vosztok kernel:  [pgd_dtor+0/86] pgd_dtor+0x0/0x56
Jan 17 19:07:18 vosztok kernel:  [<c0111d75>] pgd_dtor+0x0/0x56
Jan 17 19:07:18 vosztok kernel:  [remove_vma+49/54] remove_vma+0x31/0x36
Jan 17 19:07:18 vosztok kernel:  [<c0148780>] remove_vma+0x31/0x36
Jan 17 19:07:18 vosztok kernel:  [remove_vma+49/54] remove_vma+0x31/0x36
Jan 17 19:07:18 vosztok kernel:  [<c0148780>] remove_vma+0x31/0x36
Jan 17 19:07:18 vosztok kernel:  [sys_futex+194/212] sys_futex+0xc2/0xd4
Jan 17 19:07:18 vosztok kernel:  [<c0130ffb>] sys_futex+0xc2/0xd4
Jan 17 19:07:18 vosztok kernel:  [work_notifysig+19/25] work_notifysig+0x13=
/0x19
Jan 17 19:07:18 vosztok kernel:  [<c0103e9a>] work_notifysig+0x13/0x19
Jan 17 19:07:18 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: segctord      D df6d5100     0  4265      2
Jan 17 19:07:18 vosztok kernel:        dcedfe08 00000046 df475b84 df6d5100 =
cd3628c0 c013dd7f dcedff28 c1977700=20
Jan 17 19:07:18 vosztok kernel:        dcedfe24 dcedfe2c c036c31f 00000001 =
df475a40 c0114c20 dcedff2c dcedff2c=20
Jan 17 19:07:18 vosztok kernel:        dcedff04 00000001 c78be2d8 e08c711a =
c78be2d8 dcedff04 d70c3070 e08c7268=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [mempool_alloc+28/228] mempool_alloc+0x1c/=
0xe4
Jan 17 19:07:18 vosztok kernel:  [<c013dd7f>] mempool_alloc+0x1c/0xe4
Jan 17 19:07:18 vosztok kernel:  [wait_for_completion+125/205] wait_for_com=
pletion+0x7d/0xcd
Jan 17 19:07:18 vosztok kernel:  [<c036c31f>] wait_for_completion+0x7d/0xcd
Jan 17 19:07:18 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:07:18 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:07:18 vosztok kernel:  [<e08c711a>] nilfs_segbuf_wait+0x79/0x1d7 =
[nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08c7268>] nilfs_segbuf_wait+0x1c7/0x1d7=
 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08c75de>] nilfs_segbuf_write+0x48/0x83 =
[nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08ca035>] nilfs_segctor_add_dirty+0x1ca=
3/0x259f [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 19:07:18 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 19:07:18 vosztok kernel:  [<e08ca8e0>] nilfs_segctor_add_dirty+0x254=
e/0x259f [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08cbd47>] nilfs_clean_segments+0x3e0/0x=
9ac [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08cab33>] nilfs_segctor_add_segments_to=
_be_freed+0x202/0x33b [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08cbbcc>] nilfs_clean_segments+0x265/0x=
9ac [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [kernel_thread_helper+7/16] kernel_thread_=
helper+0x7/0x10
Jan 17 19:07:18 vosztok kernel:  [<c0104917>] kernel_thread_helper+0x7/0x10
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: gpg-agent     D c015fb49     0 10190      1
Jan 17 19:07:18 vosztok kernel:        d7087e98 00000082 dbce4bc4 c015fb49 =
d6ddec40 c440c016 fffeffff df3b8c94=20
Jan 17 19:07:18 vosztok kernel:        00000000 dbce4a80 c023bd30 d7087ebc =
c348d78b df3b8c94 df3b8c00 00000000=20
Jan 17 19:07:18 vosztok kernel:        de9db2a0 c036d592 d572dd5c df477e74 =
dbce4a80 00000001 df3b8c94 c036d5d3=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [__link_path_walk+2884/3072] __link_path_w=
alk+0xb44/0xc00
Jan 17 19:07:18 vosztok kernel:  [<c015fb49>] __link_path_walk+0xb44/0xc00
Jan 17 19:07:18 vosztok kernel:  [rwsem_down_failed_common+328/353] rwsem_d=
own_failed_common+0x148/0x161
Jan 17 19:07:18 vosztok kernel:  [<c023bd30>] rwsem_down_failed_common+0x14=
8/0x161
Jan 17 19:07:18 vosztok kernel:  [rwsem_down_read_failed+26/36] rwsem_down_=
read_failed+0x1a/0x24
Jan 17 19:07:18 vosztok kernel:  [<c036d592>] rwsem_down_read_failed+0x1a/0=
x24
Jan 17 19:07:18 vosztok kernel:  [call_rwsem_down_read_failed+7/12] call_rw=
sem_down_read_failed+0x7/0xc
Jan 17 19:07:18 vosztok kernel:  [<c036d5d3>] call_rwsem_down_read_failed+0=
x7/0xc
Jan 17 19:07:18 vosztok kernel:  [down_read+9/10] down_read+0x9/0xa
Jan 17 19:07:18 vosztok kernel:  [<c012a885>] down_read+0x9/0xa
Jan 17 19:07:18 vosztok kernel:  [<e08caf2c>] nilfs_transaction_begin+0xd4/=
0x150 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bc377>] nilfs_load_super_block+0x7f/0=
x924 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [vfs_unlink+66/125] vfs_unlink+0x42/0x7d
Jan 17 19:07:18 vosztok kernel:  [<c015e654>] vfs_unlink+0x42/0x7d
Jan 17 19:07:18 vosztok kernel:  [do_unlinkat+146/293] do_unlinkat+0x92/0x1=
25
Jan 17 19:07:18 vosztok kernel:  [<c0160335>] do_unlinkat+0x92/0x125
Jan 17 19:07:18 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: urxvtd        D 00000000     0 10212      1
Jan 17 19:07:18 vosztok kernel:        d572dd38 00000046 d594c144 00000000 =
de5f5a80 00153995 fffeffff df3b8c94=20
Jan 17 19:07:18 vosztok kernel:        00000000 d594c000 c023bd30 d572dd5c =
00000007 df3b8c94 df3b8c00 00000000=20
Jan 17 19:07:18 vosztok kernel:        de9db2a0 c036d592 df3b8c98 d7087ebc =
d594c000 00000001 df3b8c94 c036d5d3=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [rwsem_down_failed_common+328/353] rwsem_d=
own_failed_common+0x148/0x161
Jan 17 19:07:18 vosztok kernel:  [<c023bd30>] rwsem_down_failed_common+0x14=
8/0x161
Jan 17 19:07:18 vosztok kernel:  [rwsem_down_read_failed+26/36] rwsem_down_=
read_failed+0x1a/0x24
Jan 17 19:07:18 vosztok kernel:  [<c036d592>] rwsem_down_read_failed+0x1a/0=
x24
Jan 17 19:07:18 vosztok kernel:  [call_rwsem_down_read_failed+7/12] call_rw=
sem_down_read_failed+0x7/0xc
Jan 17 19:07:18 vosztok kernel:  [<c036d5d3>] call_rwsem_down_read_failed+0=
x7/0xc
Jan 17 19:07:18 vosztok kernel:  [down_read+9/10] down_read+0x9/0xa
Jan 17 19:07:18 vosztok kernel:  [<c012a885>] down_read+0x9/0xa
Jan 17 19:07:18 vosztok kernel:  [<e08caf2c>] nilfs_transaction_begin+0xd4/=
0x150 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [sk_free+162/183] sk_free+0xa2/0xb7
Jan 17 19:07:18 vosztok kernel:  [<c02f110d>] sk_free+0xa2/0xb7
Jan 17 19:07:18 vosztok kernel:  [<e08b958a>] nilfs_delete_inode+0x47/0x115=
 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [sk_free+162/183] sk_free+0xa2/0xb7
Jan 17 19:07:18 vosztok kernel:  [<c02f110d>] sk_free+0xa2/0xb7
Jan 17 19:07:18 vosztok kernel:  [__slab_free+206/670] __slab_free+0xce/0x2=
9e
Jan 17 19:07:18 vosztok kernel:  [<c015411d>] __slab_free+0xce/0x29e
Jan 17 19:07:18 vosztok kernel:  [<e08b9543>] nilfs_delete_inode+0x0/0x115 =
[nilfs2]
Jan 17 19:07:18 vosztok kernel:  [generic_delete_inode+113/236] generic_del=
ete_inode+0x71/0xec
Jan 17 19:07:18 vosztok kernel:  [<c01685db>] generic_delete_inode+0x71/0xec
Jan 17 19:07:18 vosztok kernel:  [iput+96/98] iput+0x60/0x62
Jan 17 19:07:18 vosztok kernel:  [<c0167db5>] iput+0x60/0x62
Jan 17 19:07:18 vosztok kernel:  [d_kill+45/70] d_kill+0x2d/0x46
Jan 17 19:07:18 vosztok kernel:  [<c0165e1e>] d_kill+0x2d/0x46
Jan 17 19:07:18 vosztok kernel:  [dput+307/314] dput+0x133/0x13a
Jan 17 19:07:18 vosztok kernel:  [<c0165f6a>] dput+0x133/0x13a
Jan 17 19:07:18 vosztok kernel:  [unix_release_sock+486/545] unix_release_s=
ock+0x1e6/0x221
Jan 17 19:07:18 vosztok kernel:  [<c0342733>] unix_release_sock+0x1e6/0x221
Jan 17 19:07:18 vosztok kernel:  [sock_release+20/125] sock_release+0x14/0x=
7d
Jan 17 19:07:18 vosztok kernel:  [<c02ef4be>] sock_release+0x14/0x7d
Jan 17 19:07:18 vosztok kernel:  [sock_close+42/47] sock_close+0x2a/0x2f
Jan 17 19:07:18 vosztok kernel:  [<c02ef925>] sock_close+0x2a/0x2f
Jan 17 19:07:18 vosztok kernel:  [__fput+150/350] __fput+0x96/0x15e
Jan 17 19:07:18 vosztok kernel:  [<c0158584>] __fput+0x96/0x15e
Jan 17 19:07:18 vosztok kernel:  [filp_close+81/88] filp_close+0x51/0x58
Jan 17 19:07:18 vosztok kernel:  [<c01560e5>] filp_close+0x51/0x58
Jan 17 19:07:18 vosztok kernel:  [put_files_struct+94/166] put_files_struct=
+0x5e/0xa6
Jan 17 19:07:18 vosztok kernel:  [<c0119678>] put_files_struct+0x5e/0xa6
Jan 17 19:07:18 vosztok kernel:  [do_exit+552/1837] do_exit+0x228/0x72d
Jan 17 19:07:18 vosztok kernel:  [<c011a82b>] do_exit+0x228/0x72d
Jan 17 19:07:18 vosztok kernel:  [recalc_sigpending+10/27] recalc_sigpendin=
g+0xa/0x1b
Jan 17 19:07:18 vosztok kernel:  [<c011f77a>] recalc_sigpending+0xa/0x1b
Jan 17 19:07:18 vosztok kernel:  [dequeue_signal+145/284] dequeue_signal+0x=
91/0x11c
Jan 17 19:07:18 vosztok kernel:  [<c0120e3b>] dequeue_signal+0x91/0x11c
Jan 17 19:07:18 vosztok kernel:  [sys_exit_group+0/13] sys_exit_group+0x0/0=
xd
Jan 17 19:07:18 vosztok kernel:  [<c011ada9>] sys_exit_group+0x0/0xd
Jan 17 19:07:18 vosztok kernel:  [get_signal_to_deliver+1009/1054] get_sign=
al_to_deliver+0x3f1/0x41e
Jan 17 19:07:18 vosztok kernel:  [<c0121c20>] get_signal_to_deliver+0x3f1/0=
x41e
Jan 17 19:07:18 vosztok kernel:  [do_notify_resume+129/1502] do_notify_resu=
me+0x81/0x5de
Jan 17 19:07:18 vosztok kernel:  [<c0103587>] do_notify_resume+0x81/0x5de
Jan 17 19:07:18 vosztok kernel:  [_atomic_dec_and_lock+37/64] _atomic_dec_a=
nd_lock+0x25/0x40
Jan 17 19:07:18 vosztok kernel:  [<c02390e9>] _atomic_dec_and_lock+0x25/0x40
Jan 17 19:07:18 vosztok kernel:  [do_page_fault+616/1439] do_page_fault+0x2=
68/0x59f
Jan 17 19:07:18 vosztok kernel:  [<c0112649>] do_page_fault+0x268/0x59f
Jan 17 19:07:18 vosztok kernel:  [tasklet_action+50/87] tasklet_action+0x32=
/0x57
Jan 17 19:07:18 vosztok kernel:  [<c011bf67>] tasklet_action+0x32/0x57
Jan 17 19:07:18 vosztok kernel:  [sigprocmask+157/182] sigprocmask+0x9d/0xb6
Jan 17 19:07:18 vosztok kernel:  [<c011f828>] sigprocmask+0x9d/0xb6
Jan 17 19:07:18 vosztok kernel:  [sys_rt_sigprocmask+71/186] sys_rt_sigproc=
mask+0x47/0xba
Jan 17 19:07:18 vosztok kernel:  [<c0121c94>] sys_rt_sigprocmask+0x47/0xba
Jan 17 19:07:18 vosztok kernel:  [work_notifysig+19/25] work_notifysig+0x13=
/0x19
Jan 17 19:07:18 vosztok kernel:  [<c0103e9a>] work_notifysig+0x13/0x19
Jan 17 19:07:18 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: rtorrent      D c013d4b5     0 10225      1
Jan 17 19:07:18 vosztok kernel:        d5077890 00000082 d594d644 c013d4b5 =
d5959a80 e08bd210 d50778bc d50778bc=20
Jan 17 19:07:18 vosztok kernel:        c13f0960 d5077898 c036c20c c013b86b =
c013b8a9 c036c98d d50778bc 00000000=20
Jan 17 19:07:18 vosztok kernel:        d50778d8 00000000 c013b85d 00000002 =
c120fcc0 00000000 00000001 d594d500=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [find_or_create_page+28/140] find_or_creat=
e_page+0x1c/0x8c
Jan 17 19:07:18 vosztok kernel:  [<c013d4b5>] find_or_create_page+0x1c/0x8c
Jan 17 19:07:18 vosztok kernel:  [<e08bd210>] nilfs_get_page_block+0x97/0xb=
1 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [io_schedule+14/22] io_schedule+0xe/0x16
Jan 17 19:07:18 vosztok kernel:  [<c036c20c>] io_schedule+0xe/0x16
Jan 17 19:07:18 vosztok kernel:  [sync_page+0/65] sync_page+0x0/0x41
Jan 17 19:07:18 vosztok kernel:  [<c013b86b>] sync_page+0x0/0x41
Jan 17 19:07:18 vosztok kernel:  [sync_page+62/65] sync_page+0x3e/0x41
Jan 17 19:07:18 vosztok kernel:  [<c013b8a9>] sync_page+0x3e/0x41
Jan 17 19:07:18 vosztok kernel:  [__wait_on_bit_lock+42/81] __wait_on_bit_l=
ock+0x2a/0x51
Jan 17 19:07:18 vosztok kernel:  [<c036c98d>] __wait_on_bit_lock+0x2a/0x51
Jan 17 19:07:18 vosztok kernel:  [__lock_page+87/93] __lock_page+0x57/0x5d
Jan 17 19:07:18 vosztok kernel:  [<c013b85d>] __lock_page+0x57/0x5d
Jan 17 19:07:18 vosztok kernel:  [wake_bit_function+0/60] wake_bit_function=
+0x0/0x3c
Jan 17 19:07:18 vosztok kernel:  [<c0127868>] wake_bit_function+0x0/0x3c
Jan 17 19:07:18 vosztok kernel:  [<e08be7aa>] __nilfs_btnode_get+0x70/0x1bc=
 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bf7b6>] nilfs_bmap_get_block+0x25/0x2=
a [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08c059d>] nilfs_btree_init_gc+0x72a/0x1=
050 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08c1817>] nilfs_btree_path_cache_destro=
y+0x66b/0x1e39 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [autoremove_wake_function+21/53] autoremov=
e_wake_function+0x15/0x35
Jan 17 19:07:18 vosztok kernel:  [<c0127848>] autoremove_wake_function+0x15=
/0x35
Jan 17 19:07:18 vosztok kernel:  [<e08bf6c6>] nilfs_bmap_lookup_at_level+0x=
33/0x81 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bf737>] nilfs_bmap_lookup+0x23/0x37 [=
nilfs2]
Jan 17 19:07:18 vosztok kernel:  [__alloc_pages+76/642] __alloc_pages+0x4c/=
0x282
Jan 17 19:07:18 vosztok kernel:  [<c013f870>] __alloc_pages+0x4c/0x282
Jan 17 19:07:18 vosztok kernel:  [<e08b96e3>] nilfs_get_block+0x8b/0x1de [n=
ilfs2]
Jan 17 19:07:18 vosztok kernel:  [delay_tsc+37/59] delay_tsc+0x25/0x3b
Jan 17 19:07:18 vosztok kernel:  [<c023d4aa>] delay_tsc+0x25/0x3b
Jan 17 19:07:18 vosztok kernel:  [__delay+6/7] __delay+0x6/0x7
Jan 17 19:07:18 vosztok kernel:  [<c023d46d>] __delay+0x6/0x7
Jan 17 19:07:18 vosztok kernel:  [ata_bmdma_start+11/25] ata_bmdma_start+0x=
b/0x19
Jan 17 19:07:18 vosztok kernel:  [<c02c803a>] ata_bmdma_start+0xb/0x19
Jan 17 19:07:18 vosztok kernel:  [ata_qc_issue_prot+232/542] ata_qc_issue_p=
rot+0xe8/0x21e
Jan 17 19:07:18 vosztok kernel:  [<c02c499b>] ata_qc_issue_prot+0xe8/0x21e
Jan 17 19:07:18 vosztok kernel:  [__alloc_pages+76/642] __alloc_pages+0x4c/=
0x282
Jan 17 19:07:18 vosztok kernel:  [<c013f870>] __alloc_pages+0x4c/0x282
Jan 17 19:07:18 vosztok kernel:  [do_mpage_readpage+386/1128] do_mpage_read=
page+0x182/0x468
Jan 17 19:07:18 vosztok kernel:  [<c0179ca9>] do_mpage_readpage+0x182/0x468
Jan 17 19:07:18 vosztok kernel:  [<e08b9658>] nilfs_get_block+0x0/0x1de [ni=
lfs2]
Jan 17 19:07:18 vosztok kernel:  [add_to_page_cache+159/185] add_to_page_ca=
che+0x9f/0xb9
Jan 17 19:07:18 vosztok kernel:  [<c013babd>] add_to_page_cache+0x9f/0xb9
Jan 17 19:07:18 vosztok kernel:  [mpage_readpages+178/276] mpage_readpages+=
0xb2/0x114
Jan 17 19:07:18 vosztok kernel:  [<c017a15a>] mpage_readpages+0xb2/0x114
Jan 17 19:07:18 vosztok kernel:  [<e08b9658>] nilfs_get_block+0x0/0x1de [ni=
lfs2]
Jan 17 19:07:18 vosztok kernel:  [get_page_from_freelist+463/820] get_page_=
from_freelist+0x1cf/0x334
Jan 17 19:07:18 vosztok kernel:  [scsi_io_completion+252/792] scsi_io_compl=
etion+0xfc/0x318
Jan 17 19:07:18 vosztok kernel:  [<c02b224e>] scsi_io_completion+0xfc/0x318
Jan 17 19:07:18 vosztok kernel:  [<e08b913e>] nilfs_set_inode_flags+0x13b/0=
x15c [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [__do_page_cache_readahead+391/578] __do_p=
age_cache_readahead+0x187/0x242
Jan 17 19:07:18 vosztok kernel:  [<c0141196>] __do_page_cache_readahead+0x1=
87/0x242
Jan 17 19:07:18 vosztok kernel:  [<e08b9658>] nilfs_get_block+0x0/0x1de [ni=
lfs2]
Jan 17 19:07:18 vosztok kernel:  [scsi_softirq_done+32/199] scsi_softirq_do=
ne+0x20/0xc7
Jan 17 19:07:18 vosztok kernel:  [<c02b2936>] scsi_softirq_done+0x20/0xc7
Jan 17 19:07:18 vosztok kernel:  [scsi_finish_command+60/64] scsi_finish_co=
mmand+0x3c/0x40
Jan 17 19:07:18 vosztok kernel:  [<c02ae84f>] scsi_finish_command+0x3c/0x40
Jan 17 19:07:18 vosztok kernel:  [blk_done_softirq+74/85] blk_done_softirq+=
0x4a/0x55
Jan 17 19:07:18 vosztok kernel:  [<c02332f0>] blk_done_softirq+0x4a/0x55
Jan 17 19:07:18 vosztok kernel:  [do_page_cache_readahead+73/83] do_page_ca=
che_readahead+0x49/0x53
Jan 17 19:07:18 vosztok kernel:  [<c0141556>] do_page_cache_readahead+0x49/=
0x53
Jan 17 19:07:18 vosztok kernel:  [filemap_fault+435/969] filemap_fault+0x1b=
3/0x3c9
Jan 17 19:07:18 vosztok kernel:  [<c013d873>] filemap_fault+0x1b3/0x3c9
Jan 17 19:07:18 vosztok kernel:  [balance_dirty_pages_ratelimited_nr+397/42=
4] balance_dirty_pages_ratelimited_nr+0x18d/0x1a8
Jan 17 19:07:18 vosztok kernel:  [<c0140843>] balance_dirty_pages_ratelimit=
ed_nr+0x18d/0x1a8
Jan 17 19:07:18 vosztok kernel:  [__do_fault+80/773] __do_fault+0x50/0x305
Jan 17 19:07:18 vosztok kernel:  [<c0145089>] __do_fault+0x50/0x305
Jan 17 19:07:18 vosztok kernel:  [handle_mm_fault+731/1528] handle_mm_fault=
+0x2db/0x5f8
Jan 17 19:07:18 vosztok kernel:  [<c014683a>] handle_mm_fault+0x2db/0x5f8
Jan 17 19:07:18 vosztok kernel:  [do_page_fault+530/1439] do_page_fault+0x2=
12/0x59f
Jan 17 19:07:18 vosztok kernel:  [<c01125f3>] do_page_fault+0x212/0x59f
Jan 17 19:07:18 vosztok kernel:  [handle_IRQ_event+26/63] handle_IRQ_event+=
0x1a/0x3f
Jan 17 19:07:18 vosztok kernel:  [<c01394ba>] handle_IRQ_event+0x1a/0x3f
Jan 17 19:07:18 vosztok kernel:  [enable_8259A_irq+69/93] enable_8259A_irq+=
0x45/0x5d
Jan 17 19:07:18 vosztok kernel:  [<c0107913>] enable_8259A_irq+0x45/0x5d
Jan 17 19:07:18 vosztok kernel:  [do_page_fault+0/1439] do_page_fault+0x0/0=
x59f
Jan 17 19:07:18 vosztok kernel:  [<c01123e1>] do_page_fault+0x0/0x59f
Jan 17 19:07:18 vosztok kernel:  [error_code+106/112] error_code+0x6a/0x70
Jan 17 19:07:18 vosztok kernel:  [<c036d93a>] error_code+0x6a/0x70
Jan 17 19:07:18 vosztok kernel:  [ioapic_resume+70/172] ioapic_resume+0x46/=
0xac
Jan 17 19:07:18 vosztok kernel:  [<c011007b>] ioapic_resume+0x46/0xac
Jan 17 19:07:18 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  [__copy_to_user_ll+69/204] __copy_to_user_=
ll+0x45/0xcc
Jan 17 19:07:18 vosztok kernel:  [<c023d7fc>] __copy_to_user_ll+0x45/0xcc
Jan 17 19:07:18 vosztok kernel:  [memcpy_toiovec+39/74] memcpy_toiovec+0x27=
/0x4a
Jan 17 19:07:18 vosztok kernel:  [<c02f56d9>] memcpy_toiovec+0x27/0x4a
Jan 17 19:07:18 vosztok kernel:  [skb_copy_datagram_iovec+63/432] skb_copy_=
datagram_iovec+0x3f/0x1b0
Jan 17 19:07:18 vosztok kernel:  [<c02f5b5f>] skb_copy_datagram_iovec+0x3f/=
0x1b0
Jan 17 19:07:18 vosztok kernel:  [tcp_recvmsg+1324/1811] tcp_recvmsg+0x52c/=
0x713
Jan 17 19:07:18 vosztok kernel:  [<c031780b>] tcp_recvmsg+0x52c/0x713
Jan 17 19:07:18 vosztok kernel:  [tcp_recvmsg+1324/1811] tcp_recvmsg+0x52c/=
0x713
Jan 17 19:07:18 vosztok kernel:  [<c031780b>] tcp_recvmsg+0x52c/0x713
Jan 17 19:07:18 vosztok kernel:  [tcp_recvmsg+1109/1811] tcp_recvmsg+0x455/=
0x713
Jan 17 19:07:18 vosztok kernel:  [<c0317734>] tcp_recvmsg+0x455/0x713
Jan 17 19:07:18 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 19:07:18 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 19:07:18 vosztok kernel:  [sock_common_recvmsg+62/84] sock_common_re=
cvmsg+0x3e/0x54
Jan 17 19:07:18 vosztok kernel:  [<c02f05bd>] sock_common_recvmsg+0x3e/0x54
Jan 17 19:07:18 vosztok kernel:  [sock_recvmsg+206/231] sock_recvmsg+0xce/0=
xe7
Jan 17 19:07:18 vosztok kernel:  [<c02eefae>] sock_recvmsg+0xce/0xe7
Jan 17 19:07:18 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 19:07:18 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 19:07:18 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 19:07:18 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 19:07:18 vosztok kernel:  [n_tty_receive_buf+3376/3451] n_tty_receiv=
e_buf+0xd30/0xd7b
Jan 17 19:07:18 vosztok kernel:  [<c02507f5>] n_tty_receive_buf+0xd30/0xd7b
Jan 17 19:07:18 vosztok kernel:  [enqueue_entity+466/499] enqueue_entity+0x=
1d2/0x1f3
Jan 17 19:07:18 vosztok kernel:  [<c0113e13>] enqueue_entity+0x1d2/0x1f3
Jan 17 19:07:18 vosztok kernel:  [<e099840e>] drm_vbl_send_signals+0xc2/0xe=
4 [drm]
Jan 17 19:07:18 vosztok kernel:  [sys_recvfrom+215/299] sys_recvfrom+0xd7/0=
x12b
Jan 17 19:07:18 vosztok kernel:  [<c02efcd9>] sys_recvfrom+0xd7/0x12b
Jan 17 19:07:18 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 19:07:18 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 19:07:18 vosztok kernel:  [update_stats_wait_end+155/190] update_sta=
ts_wait_end+0x9b/0xbe
Jan 17 19:07:18 vosztok kernel:  [<c01136df>] update_stats_wait_end+0x9b/0x=
be
Jan 17 19:07:18 vosztok kernel:  [update_curr_load+110/131] update_curr_loa=
d+0x6e/0x83
Jan 17 19:07:18 vosztok kernel:  [<c011395f>] update_curr_load+0x6e/0x83
Jan 17 19:07:18 vosztok kernel:  [__switch_to+25/276] __switch_to+0x19/0x114
Jan 17 19:07:18 vosztok kernel:  [<c0102f39>] __switch_to+0x19/0x114
Jan 17 19:07:18 vosztok kernel:  [schedule+572/755] schedule+0x23c/0x2f3
Jan 17 19:07:18 vosztok kernel:  [<c036bfe2>] schedule+0x23c/0x2f3
Jan 17 19:07:18 vosztok kernel:  [schedule+729/755] schedule+0x2d9/0x2f3
Jan 17 19:07:18 vosztok kernel:  [<c036c07f>] schedule+0x2d9/0x2f3
Jan 17 19:07:18 vosztok kernel:  [schedule_timeout+129/149] schedule_timeou=
t+0x81/0x95
Jan 17 19:07:18 vosztok kernel:  [<c036c92d>] schedule_timeout+0x81/0x95
Jan 17 19:07:18 vosztok kernel:  [sys_recv+55/59] sys_recv+0x37/0x3b
Jan 17 19:07:18 vosztok kernel:  [<c02efd64>] sys_recv+0x37/0x3b
Jan 17 19:07:18 vosztok kernel:  [sys_socketcall+383/578] sys_socketcall+0x=
17f/0x242
Jan 17 19:07:18 vosztok kernel:  [<c02f0201>] sys_socketcall+0x17f/0x242
Jan 17 19:07:18 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: weechat-curse D 00000099     0 10229      1
Jan 17 19:07:18 vosztok kernel:        dc075d5c 00200082 dc066144 00000099 =
d4dafa80 00000099 fffeffff df3b8c94=20
Jan 17 19:07:18 vosztok kernel:        00000000 dc066000 c023bd30 dc075d80 =
00000020 df3b8c94 df3b8c00 00000000=20
Jan 17 19:07:18 vosztok kernel:        de9db2a0 c036d592 df477e74 ced45d80 =
dc066000 00000001 df3b8c94 c036d5d3=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [rwsem_down_failed_common+328/353] rwsem_d=
own_failed_common+0x148/0x161
Jan 17 19:07:18 vosztok kernel:  [<c023bd30>] rwsem_down_failed_common+0x14=
8/0x161
Jan 17 19:07:18 vosztok kernel:  [rwsem_down_read_failed+26/36] rwsem_down_=
read_failed+0x1a/0x24
Jan 17 19:07:18 vosztok kernel:  [<c036d592>] rwsem_down_read_failed+0x1a/0=
x24
Jan 17 19:07:18 vosztok kernel:  [call_rwsem_down_read_failed+7/12] call_rw=
sem_down_read_failed+0x7/0xc
Jan 17 19:07:18 vosztok kernel:  [<c036d5d3>] call_rwsem_down_read_failed+0=
x7/0xc
Jan 17 19:07:18 vosztok kernel:  [down_read+9/10] down_read+0x9/0xa
Jan 17 19:07:18 vosztok kernel:  [<c012a885>] down_read+0x9/0xa
Jan 17 19:07:18 vosztok kernel:  [<e08caf2c>] nilfs_transaction_begin+0xd4/=
0x150 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [__rcu_process_callbacks+288/382] __rcu_pr=
ocess_callbacks+0x120/0x17e
Jan 17 19:07:18 vosztok kernel:  [<c01259e5>] __rcu_process_callbacks+0x120=
/0x17e
Jan 17 19:07:18 vosztok kernel:  [<e08cafc6>] nilfs_dirty_inode+0x1e/0x40 [=
nilfs2]
Jan 17 19:07:18 vosztok kernel:  [__rcu_process_callbacks+288/382] __rcu_pr=
ocess_callbacks+0x120/0x17e
Jan 17 19:07:18 vosztok kernel:  [<c01259e5>] __rcu_process_callbacks+0x120=
/0x17e
Jan 17 19:07:18 vosztok kernel:  [__mark_inode_dirty+36/360] __mark_inode_d=
irty+0x24/0x168
Jan 17 19:07:18 vosztok kernel:  [<c01705db>] __mark_inode_dirty+0x24/0x168
Jan 17 19:07:18 vosztok kernel:  [current_fs_time+19/21] current_fs_time+0x=
13/0x15
Jan 17 19:07:18 vosztok kernel:  [<c011bae5>] current_fs_time+0x13/0x15
Jan 17 19:07:18 vosztok kernel:  [__generic_file_aio_write_nolock+864/1288]=
 __generic_file_aio_write_nolock+0x360/0x508
Jan 17 19:07:18 vosztok kernel:  [<c013d0ca>] __generic_file_aio_write_nolo=
ck+0x360/0x508
Jan 17 19:07:18 vosztok kernel:  [do_IRQ+88/109] do_IRQ+0x58/0x6d
Jan 17 19:07:18 vosztok kernel:  [<c01062b7>] do_IRQ+0x58/0x6d
Jan 17 19:07:18 vosztok kernel:  [xfs_file_open+99/102] xfs_file_open+0x63/=
0x66
Jan 17 19:07:18 vosztok kernel:  [<c0220000>] xfs_file_open+0x63/0x66
Jan 17 19:07:18 vosztok kernel:  [generic_file_aio_write+82/176] generic_fi=
le_aio_write+0x52/0xb0
Jan 17 19:07:18 vosztok kernel:  [<c013d2c4>] generic_file_aio_write+0x52/0=
xb0
Jan 17 19:07:18 vosztok kernel:  [<e08b9ed2>] nilfs_read_inode+0x2df/0x341 =
[nilfs2]
Jan 17 19:07:18 vosztok kernel:  [do_sync_write+198/265] do_sync_write+0xc6=
/0x109
Jan 17 19:07:18 vosztok kernel:  [<c01575dd>] do_sync_write+0xc6/0x109
Jan 17 19:07:18 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 19:07:18 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 19:07:18 vosztok kernel:  [sys_stat64+30/35] sys_stat64+0x1e/0x23
Jan 17 19:07:18 vosztok kernel:  [<c015a6af>] sys_stat64+0x1e/0x23
Jan 17 19:07:18 vosztok kernel:  [do_sync_write+0/265] do_sync_write+0x0/0x=
109
Jan 17 19:07:18 vosztok kernel:  [<c0157517>] do_sync_write+0x0/0x109
Jan 17 19:07:18 vosztok kernel:  [vfs_write+138/268] vfs_write+0x8a/0x10c
Jan 17 19:07:18 vosztok kernel:  [<c0157d55>] vfs_write+0x8a/0x10c
Jan 17 19:07:18 vosztok kernel:  [sys_write+65/103] sys_write+0x41/0x67
Jan 17 19:07:18 vosztok kernel:  [<c015822d>] sys_write+0x41/0x67
Jan 17 19:07:18 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: gconfd-2      D 00000000     0 10244      1
Jan 17 19:07:18 vosztok kernel:        cb175a98 00000086 dc067b84 00000000 =
cfe578c0 00000000 cb175ac4 cb175ac4=20
Jan 17 19:07:18 vosztok kernel:        c13f1018 cb175aa0 c036c20c c013b86b =
c013b8a9 c036c98d cb175ac4 00000000=20
Jan 17 19:07:18 vosztok kernel:        cb175ae0 00000000 c013b85d 00000002 =
c1044b80 00000000 00000001 dc067a40=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [io_schedule+14/22] io_schedule+0xe/0x16
Jan 17 19:07:18 vosztok kernel:  [<c036c20c>] io_schedule+0xe/0x16
Jan 17 19:07:18 vosztok kernel:  [sync_page+0/65] sync_page+0x0/0x41
Jan 17 19:07:18 vosztok kernel:  [<c013b86b>] sync_page+0x0/0x41
Jan 17 19:07:18 vosztok kernel:  [sync_page+62/65] sync_page+0x3e/0x41
Jan 17 19:07:18 vosztok kernel:  [<c013b8a9>] sync_page+0x3e/0x41
Jan 17 19:07:18 vosztok kernel:  [__wait_on_bit_lock+42/81] __wait_on_bit_l=
ock+0x2a/0x51
Jan 17 19:07:18 vosztok kernel:  [<c036c98d>] __wait_on_bit_lock+0x2a/0x51
Jan 17 19:07:18 vosztok kernel:  [__lock_page+87/93] __lock_page+0x57/0x5d
Jan 17 19:07:18 vosztok kernel:  [<c013b85d>] __lock_page+0x57/0x5d
Jan 17 19:07:18 vosztok kernel:  [wake_bit_function+0/60] wake_bit_function=
+0x0/0x3c
Jan 17 19:07:18 vosztok kernel:  [<c0127868>] wake_bit_function+0x0/0x3c
Jan 17 19:07:18 vosztok kernel:  [<e08be7aa>] __nilfs_btnode_get+0x70/0x1bc=
 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bf7b6>] nilfs_bmap_get_block+0x25/0x2=
a [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08c059d>] nilfs_btree_init_gc+0x72a/0x1=
050 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08c1817>] nilfs_btree_path_cache_destro=
y+0x66b/0x1e39 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [alloc_page_buffers+110/180] alloc_page_bu=
ffers+0x6e/0xb4
Jan 17 19:07:18 vosztok kernel:  [<c017393f>] alloc_page_buffers+0x6e/0xb4
Jan 17 19:07:18 vosztok kernel:  [<e08bf6c6>] nilfs_bmap_lookup_at_level+0x=
33/0x81 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bf737>] nilfs_bmap_lookup+0x23/0x37 [=
nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bdd5d>] nilfs_mdt_mark_buffer_dirty+0=
x1aa/0x210 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bdde0>] nilfs_mdt_read_block+0x1d/0xb=
b [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08be0a1>] nilfs_mdt_get_block+0x1c/0x42=
 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08c4fe7>] nilfs_dat_translate+0xd5/0x50=
b [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08c440a>] nilfs_dat_alloc+0x41/0x96 [ni=
lfs2]
Jan 17 19:07:18 vosztok kernel:  [get_page_from_freelist+647/820] get_page_=
from_freelist+0x287/0x334
Jan 17 19:07:18 vosztok kernel:  [<c013f5fd>] get_page_from_freelist+0x287/=
0x334
Jan 17 19:07:18 vosztok kernel:  [<e08bf3b2>] nilfs_bmap_clear+0x79/0x9a [n=
ilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bf35e>] nilfs_bmap_clear+0x25/0x9a [n=
ilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bf6ea>] nilfs_bmap_lookup_at_level+0x=
57/0x81 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bf737>] nilfs_bmap_lookup+0x23/0x37 [=
nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08b96e3>] nilfs_get_block+0x8b/0x1de [n=
ilfs2]
Jan 17 19:07:18 vosztok kernel:  [__slab_alloc+922/1060] __slab_alloc+0x39a=
/0x424
Jan 17 19:07:18 vosztok kernel:  [<c0154927>] __slab_alloc+0x39a/0x424
Jan 17 19:07:18 vosztok kernel:  [sock_alloc_send_skb+110/398] sock_alloc_s=
end_skb+0x6e/0x18e
Jan 17 19:07:18 vosztok kernel:  [<c02f0d9a>] sock_alloc_send_skb+0x6e/0x18e
Jan 17 19:07:18 vosztok kernel:  [do_mpage_readpage+386/1128] do_mpage_read=
page+0x182/0x468
Jan 17 19:07:18 vosztok kernel:  [<c0179ca9>] do_mpage_readpage+0x182/0x468
Jan 17 19:07:18 vosztok kernel:  [<e08b9658>] nilfs_get_block+0x0/0x1de [ni=
lfs2]
Jan 17 19:07:18 vosztok kernel:  [get_page_from_freelist+463/820] get_page_=
from_freelist+0x1cf/0x334
Jan 17 19:07:18 vosztok kernel:  [<c013f545>] get_page_from_freelist+0x1cf/=
0x334
Jan 17 19:07:18 vosztok kernel:  [mpage_readpage+66/85] mpage_readpage+0x42=
/0x55
Jan 17 19:07:18 vosztok kernel:  [<c0179fd1>] mpage_readpage+0x42/0x55
Jan 17 19:07:18 vosztok kernel:  [<e08b9658>] nilfs_get_block+0x0/0x1de [ni=
lfs2]
Jan 17 19:07:18 vosztok kernel:  [add_to_page_cache+159/185] add_to_page_ca=
che+0x9f/0xb9
Jan 17 19:07:18 vosztok kernel:  [<c013babd>] add_to_page_cache+0x9f/0xb9
Jan 17 19:07:18 vosztok kernel:  [lru_cache_add+78/102] lru_cache_add+0x4e/=
0x66
Jan 17 19:07:18 vosztok kernel:  [<c0141d20>] lru_cache_add+0x4e/0x66
Jan 17 19:07:18 vosztok kernel:  [add_to_page_cache_lru+34/40] add_to_page_=
cache_lru+0x22/0x28
Jan 17 19:07:18 vosztok kernel:  [<c013baf9>] add_to_page_cache_lru+0x22/0x=
28
Jan 17 19:07:18 vosztok kernel:  [read_cache_page_async+141/300] read_cache=
_page_async+0x8d/0x12c
Jan 17 19:07:18 vosztok kernel:  [<c013bb8c>] read_cache_page_async+0x8d/0x=
12c
Jan 17 19:07:18 vosztok kernel:  [<e08b9153>] nilfs_set_inode_flags+0x150/0=
x15c [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [read_cache_page+16/63] read_cache_page+0x=
10/0x3f
Jan 17 19:07:18 vosztok kernel:  [<c013d428>] read_cache_page+0x10/0x3f
Jan 17 19:07:18 vosztok kernel:  [<e08b9fe2>] nilfs_sync_file+0xae/0x336 [n=
ilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bd210>] nilfs_get_page_block+0x97/0xb=
1 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [_atomic_dec_and_lock+37/64] _atomic_dec_a=
nd_lock+0x25/0x40
Jan 17 19:07:18 vosztok kernel:  [<c02390e9>] _atomic_dec_and_lock+0x25/0x40
Jan 17 19:07:18 vosztok kernel:  [mntput_no_expire+17/133] mntput_no_expire=
+0x11/0x85
Jan 17 19:07:18 vosztok kernel:  [<c016a3e5>] mntput_no_expire+0x11/0x85
Jan 17 19:07:18 vosztok kernel:  [link_path_walk+165/175] link_path_walk+0x=
a5/0xaf
Jan 17 19:07:18 vosztok kernel:  [<c015fcaa>] link_path_walk+0xa5/0xaf
Jan 17 19:07:18 vosztok kernel:  [<e08ba2e5>] nilfs_find_entry+0x7b/0x196 [=
nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08ba40d>] nilfs_inode_by_name+0xd/0x20 =
[nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bc464>] nilfs_load_super_block+0x16c/=
0x924 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [lookup_hash+122/145] lookup_hash+0x7a/0x91
Jan 17 19:07:18 vosztok kernel:  [<c015e0fb>] lookup_hash+0x7a/0x91
Jan 17 19:07:18 vosztok kernel:  [open_namei+229/1347] open_namei+0xe5/0x543
Jan 17 19:07:18 vosztok kernel:  [<c0160b25>] open_namei+0xe5/0x543
Jan 17 19:07:18 vosztok kernel:  [d_rehash+69/91] d_rehash+0x45/0x5b
Jan 17 19:07:18 vosztok kernel:  [<c0165ca1>] d_rehash+0x45/0x5b
Jan 17 19:07:18 vosztok kernel:  [d_splice_alias+202/228] d_splice_alias+0x=
ca/0xe4
Jan 17 19:07:18 vosztok kernel:  [<c0167a1e>] d_splice_alias+0xca/0xe4
Jan 17 19:07:18 vosztok kernel:  [do_filp_open+37/57] do_filp_open+0x25/0x39
Jan 17 19:07:18 vosztok kernel:  [<c0156421>] do_filp_open+0x25/0x39
Jan 17 19:07:18 vosztok kernel:  [get_unused_fd_flags+186/215] get_unused_f=
d_flags+0xba/0xd7
Jan 17 19:07:18 vosztok kernel:  [<c01561a6>] get_unused_fd_flags+0xba/0xd7
Jan 17 19:07:18 vosztok kernel:  [do_sys_open+68/197] do_sys_open+0x44/0xc5
Jan 17 19:07:18 vosztok kernel:  [<c0156479>] do_sys_open+0x44/0xc5
Jan 17 19:07:18 vosztok kernel:  [sys_open+28/30] sys_open+0x1c/0x1e
Jan 17 19:07:18 vosztok kernel:  [<c0156533>] sys_open+0x1c/0x1e
Jan 17 19:07:18 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: wmaker        D 00000008     0 14412      1
Jan 17 19:07:18 vosztok kernel:        d5fd5c30 00000086 d50e1104 00000008 =
d6dde700 00000000 d5fd5c5c d5fd5c5c=20
Jan 17 19:07:18 vosztok kernel:        c13f0f20 d5fd5c38 c036c20c c013b86b =
c013b8a9 c036c98d d5fd5c5c 00000000=20
Jan 17 19:07:18 vosztok kernel:        d5fd5c78 00000000 c013b85d 00000002 =
c11e8fe0 00000000 00000001 d50e0fc0=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [io_schedule+14/22] io_schedule+0xe/0x16
Jan 17 19:07:18 vosztok kernel:  [<c036c20c>] io_schedule+0xe/0x16
Jan 17 19:07:18 vosztok kernel:  [sync_page+0/65] sync_page+0x0/0x41
Jan 17 19:07:18 vosztok kernel:  [<c013b86b>] sync_page+0x0/0x41
Jan 17 19:07:18 vosztok kernel:  [sync_page+62/65] sync_page+0x3e/0x41
Jan 17 19:07:18 vosztok kernel:  [<c013b8a9>] sync_page+0x3e/0x41
Jan 17 19:07:18 vosztok kernel:  [__wait_on_bit_lock+42/81] __wait_on_bit_l=
ock+0x2a/0x51
Jan 17 19:07:18 vosztok kernel:  [<c036c98d>] __wait_on_bit_lock+0x2a/0x51
Jan 17 19:07:18 vosztok kernel:  [__lock_page+87/93] __lock_page+0x57/0x5d
Jan 17 19:07:18 vosztok kernel:  [<c013b85d>] __lock_page+0x57/0x5d
Jan 17 19:07:18 vosztok kernel:  [wake_bit_function+0/60] wake_bit_function=
+0x0/0x3c
Jan 17 19:07:18 vosztok kernel:  [<c0127868>] wake_bit_function+0x0/0x3c
Jan 17 19:07:18 vosztok kernel:  [<e08be7aa>] __nilfs_btnode_get+0x70/0x1bc=
 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bf7b6>] nilfs_bmap_get_block+0x25/0x2=
a [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08c059d>] nilfs_btree_init_gc+0x72a/0x1=
050 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08c1817>] nilfs_btree_path_cache_destro=
y+0x66b/0x1e39 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [alloc_page_buffers+110/180] alloc_page_bu=
ffers+0x6e/0xb4
Jan 17 19:07:18 vosztok kernel:  [<c017393f>] alloc_page_buffers+0x6e/0xb4
Jan 17 19:07:18 vosztok kernel:  [<e08bf6c6>] nilfs_bmap_lookup_at_level+0x=
33/0x81 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bf737>] nilfs_bmap_lookup+0x23/0x37 [=
nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bdd5d>] nilfs_mdt_mark_buffer_dirty+0=
x1aa/0x210 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bdde0>] nilfs_mdt_read_block+0x1d/0xb=
b [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08cfade>] nilfs_ifile_get_inode_block+0=
xea/0x13d [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08ba343>] nilfs_find_entry+0xd9/0x196 [=
nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08b9c6b>] nilfs_read_inode+0x78/0x341 [=
nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bb0ff>] nilfs_alloc_inode+0xf/0x76 [n=
ilfs2]
Jan 17 19:07:18 vosztok kernel:  [iget_locked+199/312] iget_locked+0xc7/0x1=
38
Jan 17 19:07:18 vosztok kernel:  [<c01682bf>] iget_locked+0xc7/0x138
Jan 17 19:07:18 vosztok kernel:  [<e08bc493>] nilfs_load_super_block+0x19b/=
0x924 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [do_lookup+163/320] do_lookup+0xa3/0x140
Jan 17 19:07:18 vosztok kernel:  [<c015df7e>] do_lookup+0xa3/0x140
Jan 17 19:07:18 vosztok kernel:  [__link_path_walk+805/3072] __link_path_wa=
lk+0x325/0xc00
Jan 17 19:07:18 vosztok kernel:  [<c015f32a>] __link_path_walk+0x325/0xc00
Jan 17 19:07:18 vosztok kernel:  [sock_aio_read+193/205] sock_aio_read+0xc1=
/0xcd
Jan 17 19:07:18 vosztok kernel:  [<c02ee670>] sock_aio_read+0xc1/0xcd
Jan 17 19:07:18 vosztok kernel:  [link_path_walk+66/175] link_path_walk+0x4=
2/0xaf
Jan 17 19:07:18 vosztok kernel:  [<c015fc47>] link_path_walk+0x42/0xaf
Jan 17 19:07:18 vosztok kernel:  [run_timer_softirq+361/388] run_timer_soft=
irq+0x169/0x184
Jan 17 19:07:18 vosztok kernel:  [<c011ecba>] run_timer_softirq+0x169/0x184
Jan 17 19:07:18 vosztok kernel:  [vfs_read+250/266] vfs_read+0xfa/0x10a
Jan 17 19:07:18 vosztok kernel:  [<c0157ed1>] vfs_read+0xfa/0x10a
Jan 17 19:07:18 vosztok kernel:  [do_path_lookup+411/438] do_path_lookup+0x=
19b/0x1b6
Jan 17 19:07:18 vosztok kernel:  [<c015ffbf>] do_path_lookup+0x19b/0x1b6
Jan 17 19:07:18 vosztok kernel:  [getname+89/143] getname+0x59/0x8f
Jan 17 19:07:18 vosztok kernel:  [<c015ece1>] getname+0x59/0x8f
Jan 17 19:07:18 vosztok kernel:  [__user_walk_fd+47/69] __user_walk_fd+0x2f=
/0x45
Jan 17 19:07:18 vosztok kernel: 0776>] __user_walk_fd+0x2f/0x45
Jan 17 19:07:18 vosztok kernel:  [sys_faccessat+153/301] sys_faccessat+0x99=
/0x12d
Jan 17 19:07:18 vosztok kernel:  [<c0156a47>] sys_faccessat+0x99/0x12d
Jan 17 19:07:18 vosztok kernel:  [run_timer_softirq+361/388] run_timer_soft=
irq+0x169/0x184
Jan 17 19:07:18 vosztok kernel:  [<c011ecba>] run_timer_softirq+0x169/0x184
Jan 17 19:07:18 vosztok kernel:  [vfs_read+250/266] vfs_read+0xfa/0x10a
Jan 17 19:07:18 vosztok kernel:  [<c0157ed1>] vfs_read+0xfa/0x10a
Jan 17 19:07:18 vosztok kernel:  [sys_access+31/35] sys_access+0x1f/0x23
Jan 17 19:07:18 vosztok kernel:  [<c0156afa>] sys_access+0x1f/0x23
Jan 17 19:07:18 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: wmsetbg       ? 00000287     0 14413  14412
Jan 17 19:07:18 vosztok kernel:        cb6c7e84 00000046 d50e0144 00000287 =
d4dafc40 c043ccfc cb6c7ea0 d50e0000=20
Jan 17 19:07:18 vosztok kernel:        00000010 d50e00e4 c011ad2c 0000000e =
00000000 d50e0494 bff50ddc 0000000f=20
Jan 17 19:07:18 vosztok kernel:        cb6c7ea0 cb6c7ea0 cfe57e00 0000000f =
0000000f cb6c7f10 c011ada9 ce80362c=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [do_exit+1833/1837] do_exit+0x729/0x72d
Jan 17 19:07:18 vosztok kernel:  [<c011ad2c>] do_exit+0x729/0x72d
Jan 17 19:07:18 vosztok kernel:  [sys_exit_group+0/13] sys_exit_group+0x0/0=
xd
Jan 17 19:07:18 vosztok kernel:  [<c011ada9>] sys_exit_group+0x0/0xd
Jan 17 19:07:18 vosztok kernel:  [get_signal_to_deliver+1009/1054] get_sign=
al_to_deliver+0x3f1/0x41e
Jan 17 19:07:18 vosztok kernel:  [<c0121c20>] get_signal_to_deliver+0x3f1/0=
x41e
Jan 17 19:07:18 vosztok kernel:  [do_sync_read+198/265] do_sync_read+0xc6/0=
x109
Jan 17 19:07:18 vosztok kernel:  [<c01576e6>] do_sync_read+0xc6/0x109
Jan 17 19:07:18 vosztok kernel:  [do_notify_resume+129/1502] do_notify_resu=
me+0x81/0x5de
Jan 17 19:07:18 vosztok kernel:  [<c0103587>] do_notify_resume+0x81/0x5de
Jan 17 19:07:18 vosztok kernel:  [xfs_iflush_done+0/131] xfs_iflush_done+0x=
0/0x83
Jan 17 19:07:18 vosztok kernel:  [<c02004ab>] xfs_iflush_done+0x0/0x83
Jan 17 19:07:18 vosztok kernel:  [d_kill+55/70] d_kill+0x37/0x46
Jan 17 19:07:18 vosztok kernel:  [<c0165e28>] d_kill+0x37/0x46
Jan 17 19:07:18 vosztok kernel:  [d_kill+55/70] d_kill+0x37/0x46
Jan 17 19:07:18 vosztok kernel:  [<c0165e28>] d_kill+0x37/0x46
Jan 17 19:07:18 vosztok kernel:  [_atomic_dec_and_lock+37/64] _atomic_dec_a=
nd_lock+0x25/0x40
Jan 17 19:07:18 vosztok kernel:  [<c02390e9>] _atomic_dec_and_lock+0x25/0x40
Jan 17 19:07:18 vosztok kernel:  [do_sync_read+0/265] do_sync_read+0x0/0x109
Jan 17 19:07:18 vosztok kernel:  [<c0157620>] do_sync_read+0x0/0x109
Jan 17 19:07:18 vosztok kernel:  [vfs_read+136/266] vfs_read+0x88/0x10a
Jan 17 19:07:18 vosztok kernel:  [<c0157e5f>] vfs_read+0x88/0x10a
Jan 17 19:07:18 vosztok kernel:  [sys_read+65/103] sys_read+0x41/0x67
Jan 17 19:07:18 vosztok kernel:  [<c01581c6>] sys_read+0x41/0x67
Jan 17 19:07:18 vosztok kernel:  [work_notifysig+19/25] work_notifysig+0x13=
/0x19
Jan 17 19:07:18 vosztok kernel:  [<c0103e9a>] work_notifysig+0x13/0x19
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: epiphany      D c38dd300     0 14478  14412
Jan 17 19:07:18 vosztok kernel:        ced45d5c 00200086 c7ced104 c38dd300 =
cd3628c0 c7cecfc0 fffeffff df3b8c94=20
Jan 17 19:07:18 vosztok kernel:        00000000 c7cecfc0 c023bd30 ced45d80 =
c7cecfc0 df3b8c94 df3b8c00 00000000=20
Jan 17 19:07:18 vosztok kernel:        de9db2a0 c036d592 dc075d80 df3b8c98 =
c7cecfc0 00000001 df3b8c94 c036d5d3=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [rwsem_down_failed_common+328/353] rwsem_d=
own_failed_common+0x148/0x161
Jan 17 19:07:18 vosztok kernel:  [<c023bd30>] rwsem_down_failed_common+0x14=
8/0x161
Jan 17 19:07:18 vosztok kernel:  [rwsem_down_read_failed+26/36] rwsem_down_=
read_failed+0x1a/0x24
Jan 17 19:07:18 vosztok kernel:  [<c036d592>] rwsem_down_read_failed+0x1a/0=
x24
Jan 17 19:07:18 vosztok kernel:  [call_rwsem_down_read_failed+7/12] call_rw=
sem_down_read_failed+0x7/0xc
Jan 17 19:07:18 vosztok kernel:  [<c036d5d3>] call_rwsem_down_read_failed+0=
x7/0xc
Jan 17 19:07:18 vosztok kernel:  [down_read+9/10] down_read+0x9/0xa
Jan 17 19:07:18 vosztok kernel:  [<c012a885>] down_read+0x9/0xa
Jan 17 19:07:18 vosztok kernel:  [<e08caf2c>] nilfs_transaction_begin+0xd4/=
0x150 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08cafc6>] nilfs_dirty_inode+0x1e/0x40 [=
nilfs2]
Jan 17 19:07:18 vosztok kernel:  [__mark_inode_dirty+36/360] __mark_inode_d=
irty+0x24/0x168
Jan 17 19:07:18 vosztok kernel:  [<c01705db>] __mark_inode_dirty+0x24/0x168
Jan 17 19:07:18 vosztok kernel:  [current_fs_time+19/21] current_fs_time+0x=
13/0x15
Jan 17 19:07:18 vosztok kernel:  [<c011bae5>] current_fs_time+0x13/0x15
Jan 17 19:07:18 vosztok kernel:  [__generic_file_aio_write_nolock+864/1288]=
 __generic_file_aio_write_nolock+0x360/0x508
Jan 17 19:07:18 vosztok kernel:  [<c013d0ca>] __generic_file_aio_write_nolo=
ck+0x360/0x508
Jan 17 19:07:18 vosztok kernel:  [preempt_schedule+69/87] preempt_schedule+=
0x45/0x57
Jan 17 19:07:18 vosztok kernel:  [<c036c133>] preempt_schedule+0x45/0x57
Jan 17 19:07:18 vosztok kernel:  [generic_file_aio_write+82/176] generic_fi=
le_aio_write+0x52/0xb0
Jan 17 19:07:18 vosztok kernel:  [<c013d2c4>] generic_file_aio_write+0x52/0=
xb0
Jan 17 19:07:18 vosztok kernel:  [<e08b9ed2>] nilfs_read_inode+0x2df/0x341 =
[nilfs2]
Jan 17 19:07:18 vosztok kernel:  [do_sync_write+198/265] do_sync_write+0xc6=
/0x109
Jan 17 19:07:18 vosztok kernel:  [<c01575dd>] do_sync_write+0xc6/0x109
Jan 17 19:07:18 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 19:07:18 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 19:07:18 vosztok kernel:  [unix_ioctl+169/177] unix_ioctl+0xa9/0xb1
Jan 17 19:07:18 vosztok kernel:  [<c03431d6>] unix_ioctl+0xa9/0xb1
Jan 17 19:07:18 vosztok kernel:  [sock_ioctl+415/446] sock_ioctl+0x19f/0x1be
Jan 17 19:07:18 vosztok kernel:  [<c02ee942>] sock_ioctl+0x19f/0x1be
Jan 17 19:07:18 vosztok kernel:  [sock_ioctl+0/446] sock_ioctl+0x0/0x1be
Jan 17 19:07:18 vosztok kernel:  [<c02ee7a3>] sock_ioctl+0x0/0x1be
Jan 17 19:07:18 vosztok kernel:  [do_sync_write+0/265] do_sync_write+0x0/0x=
109
Jan 17 19:07:18 vosztok kernel:  [<c0157517>] do_sync_write+0x0/0x109
Jan 17 19:07:18 vosztok kernel:  [vfs_write+138/268] vfs_write+0x8a/0x10c
Jan 17 19:07:18 vosztok kernel:  [<c0157d55>] vfs_write+0x8a/0x10c
Jan 17 19:07:18 vosztok kernel:  [sys_write+65/103] sys_write+0x41/0x67
Jan 17 19:07:18 vosztok kernel:  [<c015822d>] sys_write+0x41/0x67
Jan 17 19:07:18 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: cc1           D dbe29cd4     0 10269      1
Jan 17 19:07:18 vosztok kernel:        dbe29cd8 00200086 d07fe684 dbe29cd4 =
df0c5e00 c01279b8 dbe29ce8 c143bd38=20
Jan 17 19:07:18 vosztok kernel:        c13f0e70 c143bd38 c0167e39 c527cee4 =
00000003 00000000 d07fe540 c0127868=20
Jan 17 19:07:18 vosztok kernel:        c13f0e70 c13f0e70 019143eb de6d4a00 =
c0167e75 019143eb c143bd38 de6d4a00=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [prepare_to_wait+74/102] prepare_to_wait+0=
x4a/0x66
Jan 17 19:07:18 vosztok kernel:  [<c01279b8>] prepare_to_wait+0x4a/0x66
Jan 17 19:07:18 vosztok kernel:  [__wait_on_freeing_inode+130/155] __wait_o=
n_freeing_inode+0x82/0x9b
Jan 17 19:07:18 vosztok kernel:  [<c0167e39>] __wait_on_freeing_inode+0x82/=
0x9b
Jan 17 19:07:18 vosztok kernel:  [wake_bit_function+0/60] wake_bit_function=
+0x0/0x3c
Jan 17 19:07:18 vosztok kernel:  [<c0127868>] wake_bit_function+0x0/0x3c
Jan 17 19:07:18 vosztok kernel:  [find_inode_fast+35/66] find_inode_fast+0x=
23/0x42
Jan 17 19:07:18 vosztok kernel:  [<c0167e75>] find_inode_fast+0x23/0x42
Jan 17 19:07:18 vosztok kernel:  [ifind_fast+33/151] ifind_fast+0x21/0x97
Jan 17 19:07:18 vosztok kernel:  [<c0167f0b>] ifind_fast+0x21/0x97
Jan 17 19:07:18 vosztok kernel:  [iget_locked+44/312] iget_locked+0x2c/0x138
Jan 17 19:07:18 vosztok kernel:  [<c0168224>] iget_locked+0x2c/0x138
Jan 17 19:07:18 vosztok kernel:  [xfs_iget+38/253] xfs_iget+0x26/0xfd
Jan 17 19:07:18 vosztok kernel:  [<c01fb449>] xfs_iget+0x26/0xfd
Jan 17 19:07:18 vosztok kernel:  [enqueue_entity+466/499] enqueue_entity+0x=
1d2/0x1f3
Jan 17 19:07:18 vosztok kernel:  [<c0113e13>] enqueue_entity+0x1d2/0x1f3
Jan 17 19:07:18 vosztok kernel:  [xfs_dir_lookup_int+125/212] xfs_dir_looku=
p_int+0x7d/0xd4
Jan 17 19:07:18 vosztok kernel:  [<c0212d71>] xfs_dir_lookup_int+0x7d/0xd4
Jan 17 19:07:18 vosztok kernel:  [xfs_lookup+82/120] xfs_lookup+0x52/0x78
Jan 17 19:07:18 vosztok kernel:  [<c0215b01>] xfs_lookup+0x52/0x78
Jan 17 19:07:18 vosztok kernel:  [xfs_vn_lookup+59/112] xfs_vn_lookup+0x3b/=
0x70
Jan 17 19:07:18 vosztok kernel:  [<c0222262>] xfs_vn_lookup+0x3b/0x70
Jan 17 19:07:18 vosztok kernel:  [do_lookup+163/320] do_lookup+0xa3/0x140
Jan 17 19:07:18 vosztok kernel:  [<c015df7e>] do_lookup+0xa3/0x140
Jan 17 19:07:18 vosztok kernel:  [__link_path_walk+2025/3072] __link_path_w=
alk+0x7e9/0xc00
Jan 17 19:07:18 vosztok kernel:  [<c015f7ee>] __link_path_walk+0x7e9/0xc00
Jan 17 19:07:18 vosztok kernel:  [__do_softirq+89/133] __do_softirq+0x59/0x=
85
Jan 17 19:07:18 vosztok kernel:  [<c011bede>] __do_softirq+0x59/0x85
Jan 17 19:07:18 vosztok kernel:  [link_path_walk+66/175] link_path_walk+0x4=
2/0xaf
Jan 17 19:07:18 vosztok kernel:  [<c015fc47>] link_path_walk+0x42/0xaf
Jan 17 19:07:18 vosztok kernel:  [lru_cache_add_active+78/100] lru_cache_ad=
d_active+0x4e/0x64
Jan 17 19:07:18 vosztok kernel:  [<c0141c09>] lru_cache_add_active+0x4e/0x64
Jan 17 19:07:18 vosztok kernel:  [do_path_lookup+411/438] do_path_lookup+0x=
19b/0x1b6
Jan 17 19:07:18 vosztok kernel:  [<c015ffbf>] do_path_lookup+0x19b/0x1b6
Jan 17 19:07:18 vosztok kernel:  [getname+89/143] getname+0x59/0x8f
Jan 17 19:07:18 vosztok kernel:  [<c015ece1>] getname+0x59/0x8f
Jan 17 19:07:18 vosztok kernel:  [__user_walk_fd+47/69] __user_walk_fd+0x2f=
/0x45
Jan 17 19:07:18 vosztok kernel:  [<c0160776>] __user_walk_fd+0x2f/0x45
Jan 17 19:07:18 vosztok kernel:  [vfs_stat_fd+25/64] vfs_stat_fd+0x19/0x40
Jan 17 19:07:18 vosztok kernel:  [<c015a5ec>] vfs_stat_fd+0x19/0x40
Jan 17 19:07:18 vosztok kernel:  [lru_cache_add_active+78/100] lru_cache_ad=
d_active+0x4e/0x64
Jan 17 19:07:18 vosztok kernel:  [<c0141c09>] lru_cache_add_active+0x4e/0x64
Jan 17 19:07:18 vosztok kernel:  [sys_stat64+15/35] sys_stat64+0xf/0x23
Jan 17 19:07:18 vosztok kernel:  [<c015a6a0>] sys_stat64+0xf/0x23
Jan 17 19:07:18 vosztok kernel:  [dput+204/314] dput+0xcc/0x13a
Jan 17 19:07:18 vosztok kernel:  [<c0165f03>] dput+0xcc/0x13a
Jan 17 19:07:18 vosztok kernel:  [__fput+308/350] __fput+0x134/0x15e
Jan 17 19:07:18 vosztok kernel:  [<c0158622>] __fput+0x134/0x15e
Jan 17 19:07:18 vosztok kernel:  [do_page_fault+0/1439] do_page_fault+0x0/0=
x59f
Jan 17 19:07:18 vosztok kernel:  [<c01123e1>] do_page_fault+0x0/0x59f
Jan 17 19:07:18 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: agetty        S 000001ff     0 10278      1
Jan 17 19:07:18 vosztok kernel:        dbdabee0 00000086 c2f36bc4 000001ff =
cd3621c0 00000000 d4df8c00 7fffffff=20
Jan 17 19:07:18 vosztok kernel:        dbdabf44 bfe65b6b c036c8bf c013f79f =
cd3621c4 00000246 c011831f ffffffb2=20
Jan 17 19:07:18 vosztok kernel:        bfe65b6b c0127a58 d4df8c00 d4df8c00 =
d4df8c00 c0250b30 00000082 df0fc600=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 19:07:18 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 19:07:18 vosztok kernel:  [free_hot_cold_page+245/277] free_hot_cold=
_page+0xf5/0x115
Jan 17 19:07:18 vosztok kernel:  [<c013f79f>] free_hot_cold_page+0xf5/0x115
Jan 17 19:07:18 vosztok kernel:  [release_console_sem+404/447] release_cons=
ole_sem+0x194/0x1bf
Jan 17 19:07:18 vosztok kernel:  [<c011831f>] release_console_sem+0x194/0x1=
bf
Jan 17 19:07:18 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 19:07:18 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 19:07:18 vosztok kernel:  [read_chan+752/1324] read_chan+0x2f0/0x52c
Jan 17 19:07:18 vosztok kernel:  [<c0250b30>] read_chan+0x2f0/0x52c
Jan 17 19:07:18 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:07:18 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:07:18 vosztok kernel:  [read_chan+0/1324] read_chan+0x0/0x52c
Jan 17 19:07:18 vosztok kernel:  [<c0250840>] read_chan+0x0/0x52c
Jan 17 19:07:18 vosztok kernel:  [tty_read+100/172] tty_read+0x64/0xac
Jan 17 19:07:18 vosztok kernel:  [<c024dc05>] tty_read+0x64/0xac
Jan 17 19:07:18 vosztok kernel:  [tty_read+0/172] tty_read+0x0/0xac
Jan 17 19:07:18 vosztok kernel:  [<c024dba1>] tty_read+0x0/0xac
Jan 17 19:07:18 vosztok kernel:  [vfs_read+136/266] vfs_read+0x88/0x10a
Jan 17 19:07:18 vosztok kernel:  [<c0157e5f>] vfs_read+0x88/0x10a
Jan 17 19:07:18 vosztok kernel:  [sys_read+65/103] sys_read+0x41/0x67
Jan 17 19:07:18 vosztok kernel:  [<c01581c6>] sys_read+0x41/0x67
Jan 17 19:07:18 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: login         S 46be6018     0 10280      1
Jan 17 19:07:18 vosztok kernel:        db96bf48 00000082 c2f36684 46be6018 =
dbca1c40 00000000 ffffffff 00000001=20
Jan 17 19:07:18 vosztok kernel:        df41afc0 00000000 c011a464 46be6018 =
c2f36540 c0112649 00000001 00000004=20
Jan 17 19:07:18 vosztok kernel:        ffffffff c2f36540 00000001 00000001 =
00000000 c2f36624 00000007 db96bfb8=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 19:07:18 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 19:07:18 vosztok kernel:  [do_page_fault+616/1439] do_page_fault+0x2=
68/0x59f
Jan 17 19:07:18 vosztok kernel:  [<c0112649>] do_page_fault+0x268/0x59f
Jan 17 19:07:18 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:07:18 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:07:18 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 19:07:18 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 19:07:18 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: login         S 46be6018     0 10281      1
Jan 17 19:07:18 vosztok kernel:        dc483f48 00000082 dd8debc4 46be6018 =
cd362540 00000000 ffffffff 00000001=20
Jan 17 19:07:18 vosztok kernel:        dd8dfa40 00000000 c011a464 46be6018 =
dd8dea80 c0112649 00000001 00000004=20
Jan 17 19:07:18 vosztok kernel:        ffffffff dd8dea80 00000001 00000001 =
00000000 dd8deb64 00000007 dc483fb8=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 19:07:18 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 19:07:18 vosztok kernel:  [do_page_fault+616/1439] do_page_fault+0x2=
68/0x59f
Jan 17 19:07:18 vosztok kernel:  [<c0112649>] do_page_fault+0x268/0x59f
Jan 17 19:07:18 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:07:18 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:07:18 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 19:07:18 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 19:07:18 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: agetty        S 000001ff     0 10282      1
Jan 17 19:07:18 vosztok kernel:        d6dd3ee0 00000086 dd8df104 000001ff =
de12c700 00000000 dc36e400 7fffffff=20
Jan 17 19:07:18 vosztok kernel:        d6dd3f44 bfe40c0b c036c8bf c013f79f =
de12c704 00000246 c011831f ffffffb2=20
Jan 17 19:07:18 vosztok kernel:        bfe40c0b c0127a58 dc36e400 dc36e400 =
dc36e400 c0250b30 00000082 de655b00=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 19:07:18 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 19:07:18 vosztok kernel:  [free_hot_cold_page+245/277] free_hot_cold=
_page+0xf5/0x115
Jan 17 19:07:18 vosztok kernel:  [<c013f79f>] free_hot_cold_page+0xf5/0x115
Jan 17 19:07:18 vosztok kernel:  [release_console_sem+404/447] release_cons=
ole_sem+0x194/0x1bf
Jan 17 19:07:18 vosztok kernel:  [<c011831f>] release_console_sem+0x194/0x1=
bf
Jan 17 19:07:18 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 19:07:18 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 19:07:18 vosztok kernel:  [read_chan+752/1324] read_chan+0x2f0/0x52c
Jan 17 19:07:18 vosztok kernel:  [<c0250b30>] read_chan+0x2f0/0x52c
Jan 17 19:07:18 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:07:18 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:07:18 vosztok kernel:  [read_chan+0/1324] read_chan+0x0/0x52c
Jan 17 19:07:18 vosztok kernel:  [<c0250840>] read_chan+0x0/0x52c
Jan 17 19:07:18 vosztok kernel:  [tty_read+100/172] tty_read+0x64/0xac
Jan 17 19:07:18 vosztok kernel:  [<c024dc05>] tty_read+0x64/0xac
Jan 17 19:07:18 vosztok kernel:  [tty_read+0/172] tty_read+0x0/0xac
Jan 17 19:07:18 vosztok kernel:  [<c024dba1>] tty_read+0x0/0xac
Jan 17 19:07:18 vosztok kernel:  [vfs_read+136/266] vfs_read+0x88/0x10a
Jan 17 19:07:18 vosztok kernel:  [<c0157e5f>] vfs_read+0x88/0x10a
Jan 17 19:07:18 vosztok kernel:  [sys_read+65/103] sys_read+0x41/0x67
Jan 17 19:07:18 vosztok kernel:  [<c01581c6>] sys_read+0x41/0x67
Jan 17 19:07:18 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: login         S 46be6018     0 10283      1
Jan 17 19:07:18 vosztok kernel:        de8e1f48 00000086 c2f37b84 46be6018 =
de1ade00 00000000 ffffffff 00000001=20
Jan 17 19:07:18 vosztok kernel:        de1d5a40 00000000 c011a464 46be6018 =
c2f37a40 c0112649 00000001 00000004=20
Jan 17 19:07:18 vosztok kernel:        ffffffff c2f37a40 00000001 00000001 =
00000000 c2f37b24 00000007 de8e1fb8=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 19:07:18 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 19:07:18 vosztok kernel:  [do_page_fault+616/1439] do_page_fault+0x2=
68/0x59f
Jan 17 19:07:18 vosztok kernel:  [<c0112649>] do_page_fault+0x268/0x59f
Jan 17 19:07:18 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:07:18 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:07:18 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 19:07:18 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 19:07:18 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: agetty        S 000001ff     0 10284      1
Jan 17 19:07:18 vosztok kernel:        cdccdee0 00000086 c1482144 000001ff =
de12ce00 00000000 d5f41800 7fffffff=20
Jan 17 19:07:18 vosztok kernel:        cdccdf44 bfbb2aab c036c8bf c013f79f =
de12ce04 00000246 c011831f ffffffb2=20
Jan 17 19:07:18 vosztok kernel:        bfbb2aab c0127a58 d5f41800 d5f41800 =
d5f41800 c0250b30 00000082 de655c00=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 19:07:18 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 19:07:18 vosztok kernel:  [free_hot_cold_page+245/277] free_hot_cold=
_page+0xf5/0x115
Jan 17 19:07:18 vosztok kernel:  [<c013f79f>] free_hot_cold_page+0xf5/0x115
Jan 17 19:07:18 vosztok kernel:  [release_console_sem+404/447] release_cons=
ole_sem+0x194/0x1bf
Jan 17 19:07:18 vosztok kernel:  [<c011831f>] release_console_sem+0x194/0x1=
bf
Jan 17 19:07:18 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 19:07:18 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 19:07:18 vosztok kernel:  [read_chan+752/1324] read_chan+0x2f0/0x52c
Jan 17 19:07:18 vosztok kernel:  [<c0250b30>] read_chan+0x2f0/0x52c
Jan 17 19:07:18 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:07:18 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:07:18 vosztok kernel:  [read_chan+0/1324] read_chan+0x0/0x52c
Jan 17 19:07:18 vosztok kernel:  [<c0250840>] read_chan+0x0/0x52c
Jan 17 19:07:18 vosztok kernel:  [tty_read+100/172] tty_read+0x64/0xac
Jan 17 19:07:18 vosztok kernel:  [<c024dc05>] tty_read+0x64/0xac
Jan 17 19:07:18 vosztok kernel:  [tty_read+0/172] tty_read+0x0/0xac
Jan 17 19:07:18 vosztok kernel:  [<c024dba1>] tty_read+0x0/0xac
Jan 17 19:07:18 vosztok kernel:  [vfs_read+136/266] vfs_read+0x88/0x10a
Jan 17 19:07:18 vosztok kernel: 7e5f>] vfs_read+0x88/0x10a
Jan 17 19:07:18 vosztok kernel:  [sys_read+65/103] sys_read+0x41/0x67
Jan 17 19:07:18 vosztok kernel:  [<c01581c6>] sys_read+0x41/0x67
Jan 17 19:07:18 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: qingy         S bfa6f6b0     0 10841      1
Jan 17 19:07:18 vosztok kernel:        dba03f40 00000082 df41a684 bfa6f6b0 =
dbca1a80 00000000 dba03f58 00000001=20
Jan 17 19:07:18 vosztok kernel:        00000001 00000000 c036cd4c 00000001 =
00000000 bfa6f7b4 c012a09f 00000001=20
Jan 17 19:07:18 vosztok kernel:        00000000 c0489e40 289f600a 00000317 =
c012a19b c041a6b4 00000001 00000002=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [do_nanosleep+69/111] do_nanosleep+0x45/0x=
6f
Jan 17 19:07:18 vosztok kernel:  [<c036cd4c>] do_nanosleep+0x45/0x6f
Jan 17 19:07:18 vosztok kernel:  [hrtimer_nanosleep+57/220] hrtimer_nanosle=
ep+0x39/0xdc
Jan 17 19:07:18 vosztok kernel:  [<c012a09f>] hrtimer_nanosleep+0x39/0xdc
Jan 17 19:07:18 vosztok kernel:  [hrtimer_wakeup+0/24] hrtimer_wakeup+0x0/0=
x18
Jan 17 19:07:18 vosztok kernel:  [<c012a19b>] hrtimer_wakeup+0x0/0x18
Jan 17 19:07:18 vosztok kernel:  [sys_nanosleep+73/89] sys_nanosleep+0x49/0=
x59
Jan 17 19:07:18 vosztok kernel:  [<c012a18b>] sys_nanosleep+0x49/0x59
Jan 17 19:07:18 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: bash          S 00000000     0 10842  10280
Jan 17 19:07:18 vosztok kernel:        dc6efee0 00000082 df41b104 00000000 =
dbca1380 c0269176 dec90400 7fffffff=20
Jan 17 19:07:18 vosztok kernel:        dc6eff44 bfc7e633 c036c8bf 00000000 =
00000000 df40b808 df40b8a8 00000e20=20
Jan 17 19:07:18 vosztok kernel:        bfc7e633 c0127a58 dec90400 dec90400 =
dec90400 c0250b30 00000082 d5652980=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [fbcon_cursor+585/618] fbcon_cursor+0x249/=
0x26a
Jan 17 19:07:18 vosztok kernel:  [<c0269176>] fbcon_cursor+0x249/0x26a
Jan 17 19:07:18 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 19:07:18 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 19:07:18 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 19:07:18 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 19:07:18 vosztok kernel:  [read_chan+752/1324] read_chan+0x2f0/0x52c
Jan 17 19:07:18 vosztok kernel:  [<c0250b30>] read_chan+0x2f0/0x52c
Jan 17 19:07:18 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:07:18 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:07:18 vosztok kernel:  [read_chan+0/1324] read_chan+0x0/0x52c
Jan 17 19:07:18 vosztok kernel:  [<c0250840>] read_chan+0x0/0x52c
Jan 17 19:07:18 vosztok kernel:  [tty_read+100/172] tty_read+0x64/0xac
Jan 17 19:07:18 vosztok kernel:  [<c024dc05>] tty_read+0x64/0xac
Jan 17 19:07:18 vosztok kernel:  [tty_read+0/172] tty_read+0x0/0xac
Jan 17 19:07:18 vosztok kernel:  [<c024dba1>] tty_read+0x0/0xac
Jan 17 19:07:18 vosztok kernel:  [vfs_read+136/266] vfs_read+0x88/0x10a
Jan 17 19:07:18 vosztok kernel:  [<c0157e5f>] vfs_read+0x88/0x10a
Jan 17 19:07:18 vosztok kernel:  [sys_read+65/103] sys_read+0x41/0x67
Jan 17 19:07:18 vosztok kernel:  [<c01581c6>] sys_read+0x41/0x67
Jan 17 19:07:18 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: bash          D c02aed9d     0 10849  10281
Jan 17 19:07:18 vosztok kernel:        df56bbf8 00000082 dd8dfb84 c02aed9d =
dbca1540 00000000 df56bc24 df56bc24=20
Jan 17 19:07:18 vosztok kernel:        c13f0f20 df56bc00 c036c20c c013b86b =
c013b8a9 c036c98d df56bc24 00000000=20
Jan 17 19:07:18 vosztok kernel:        df56bc40 00000000 c013b85d 00000002 =
c11e8fe0 00000000 00000001 dd8dfa40=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [scsi_dispatch_cmd+390/462] scsi_dispatch_=
cmd+0x186/0x1ce
Jan 17 19:07:18 vosztok kernel:  [<c02aed9d>] scsi_dispatch_cmd+0x186/0x1ce
Jan 17 19:07:18 vosztok kernel:  [io_schedule+14/22] io_schedule+0xe/0x16
Jan 17 19:07:18 vosztok kernel:  [<c036c20c>] io_schedule+0xe/0x16
Jan 17 19:07:18 vosztok kernel:  [sync_page+0/65] sync_page+0x0/0x41
Jan 17 19:07:18 vosztok kernel:  [<c013b86b>] sync_page+0x0/0x41
Jan 17 19:07:18 vosztok kernel:  [sync_page+62/65] sync_page+0x3e/0x41
Jan 17 19:07:18 vosztok kernel:  [<c013b8a9>] sync_page+0x3e/0x41
Jan 17 19:07:18 vosztok kernel:  [__wait_on_bit_lock+42/81] __wait_on_bit_l=
ock+0x2a/0x51
Jan 17 19:07:18 vosztok kernel:  [<c036c98d>] __wait_on_bit_lock+0x2a/0x51
Jan 17 19:07:18 vosztok kernel:  [__lock_page+87/93] __lock_page+0x57/0x5d
Jan 17 19:07:18 vosztok kernel:  [<c013b85d>] __lock_page+0x57/0x5d
Jan 17 19:07:18 vosztok kernel:  [wake_bit_function+0/60] wake_bit_function=
+0x0/0x3c
Jan 17 19:07:18 vosztok kernel:  [<c0127868>] wake_bit_function+0x0/0x3c
Jan 17 19:07:18 vosztok kernel:  [<e08be7aa>] __nilfs_btnode_get+0x70/0x1bc=
 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bf7b6>] nilfs_bmap_get_block+0x25/0x2=
a [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08c059d>] nilfs_btree_init_gc+0x72a/0x1=
050 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08c1817>] nilfs_btree_path_cache_destro=
y+0x66b/0x1e39 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [alloc_page_buffers+110/180] alloc_page_bu=
ffers+0x6e/0xb4
Jan 17 19:07:18 vosztok kernel:  [<c017393f>] alloc_page_buffers+0x6e/0xb4
Jan 17 19:07:18 vosztok kernel:  [<e08bf6c6>] nilfs_bmap_lookup_at_level+0x=
33/0x81 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bf737>] nilfs_bmap_lookup+0x23/0x37 [=
nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bdd5d>] nilfs_mdt_mark_buffer_dirty+0=
x1aa/0x210 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bdde0>] nilfs_mdt_read_block+0x1d/0xb=
b [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [xfs_buf_iowait+50/59] xfs_buf_iowait+0x32=
/0x3b
Jan 17 19:07:18 vosztok kernel:  [<c021dfa7>] xfs_buf_iowait+0x32/0x3b
Jan 17 19:07:18 vosztok kernel:  [<e08cfade>] nilfs_ifile_get_inode_block+0=
xea/0x13d [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [__slab_alloc+922/1060] __slab_alloc+0x39a=
/0x424
Jan 17 19:07:18 vosztok kernel:  [<c0154927>] __slab_alloc+0x39a/0x424
Jan 17 19:07:18 vosztok kernel:  [<e08b9c6b>] nilfs_read_inode+0x78/0x341 [=
nilfs2]
Jan 17 19:07:18 vosztok kernel:  [<e08bb0ff>] nilfs_alloc_inode+0xf/0x76 [n=
ilfs2]
Jan 17 19:07:18 vosztok kernel:  [iget_locked+199/312] iget_locked+0xc7/0x1=
38
Jan 17 19:07:18 vosztok kernel:  [<c01682bf>] iget_locked+0xc7/0x138
Jan 17 19:07:18 vosztok kernel:  [<e08bc493>] nilfs_load_super_block+0x19b/=
0x924 [nilfs2]
Jan 17 19:07:18 vosztok kernel:  [do_lookup+163/320] do_lookup+0xa3/0x140
Jan 17 19:07:18 vosztok kernel:  [<c015df7e>] do_lookup+0xa3/0x140
Jan 17 19:07:18 vosztok kernel:  [__link_path_walk+2025/3072] __link_path_w=
alk+0x7e9/0xc00
Jan 17 19:07:18 vosztok kernel:  [<c015f7ee>] __link_path_walk+0x7e9/0xc00
Jan 17 19:07:18 vosztok kernel:  [xfs_da_brelse+107/143] xfs_da_brelse+0x6b=
/0x8f
Jan 17 19:07:18 vosztok kernel:  [<c01e8c5c>] xfs_da_brelse+0x6b/0x8f
Jan 17 19:07:18 vosztok kernel:  [link_path_walk+66/175] link_path_walk+0x4=
2/0xaf
Jan 17 19:07:18 vosztok kernel:  [<c015fc47>] link_path_walk+0x42/0xaf
Jan 17 19:07:18 vosztok kernel:  [do_path_lookup+411/438] do_path_lookup+0x=
19b/0x1b6
Jan 17 19:07:18 vosztok kernel:  [<c015ffbf>] do_path_lookup+0x19b/0x1b6
Jan 17 19:07:18 vosztok kernel:  [getname+89/143] getname+0x59/0x8f
Jan 17 19:07:18 vosztok kernel:  [<c015ece1>] getname+0x59/0x8f
Jan 17 19:07:18 vosztok kernel:  [__user_walk_fd+47/69] __user_walk_fd+0x2f=
/0x45
Jan 17 19:07:18 vosztok kernel:  [<c0160776>] __user_walk_fd+0x2f/0x45
Jan 17 19:07:18 vosztok kernel:  [vfs_stat_fd+25/64] vfs_stat_fd+0x19/0x40
Jan 17 19:07:18 vosztok kernel:  [<c015a5ec>] vfs_stat_fd+0x19/0x40
Jan 17 19:07:18 vosztok kernel:  [sys_stat64+15/35] sys_stat64+0xf/0x23
Jan 17 19:07:18 vosztok kernel:  [<c015a6a0>] sys_stat64+0xf/0x23
Jan 17 19:07:18 vosztok kernel:  [__slab_free+414/670] __slab_free+0x19e/0x=
29e
Jan 17 19:07:18 vosztok kernel:  [<c01541ed>] __slab_free+0x19e/0x29e
Jan 17 19:07:18 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:18 vosztok kernel: bash          D 1a877801     0 10854  10283
Jan 17 19:07:18 vosztok kernel:        dbd3ff54 00000086 de1d5b84 1a877801 =
de1ad000 1a877801 dc66811c de1d5a40=20
Jan 17 19:07:18 vosztok kernel:        fffffffe dc66811c c036ccbe dc668120 =
dc668120 de1d5a40 dc6680b4 cfe01200=20
Jan 17 19:07:18 vosztok kernel:        c036cae9 c0162010 dbd3ff94 c0161e60 =
fffffff7 080fa284 00000000 cfe01200=20
Jan 17 19:07:18 vosztok kernel: Call Trace:
Jan 17 19:07:18 vosztok kernel:  [__mutex_lock_slowpath+101/174] __mutex_lo=
ck_slowpath+0x65/0xae
Jan 17 19:07:18 vosztok kernel:  [<c036ccbe>] __mutex_lock_slowpath+0x65/0x=
ae
Jan 17 19:07:18 vosztok kernel:  [mutex_lock+9/10] mutex_lock+0x9/0xa
Jan 17 19:07:18 vosztok kernel:  [<c036cae9>] mutex_lock+0x9/0xa
Jan 17 19:07:18 vosztok kernel:  [vfs_readdir+50/116] vfs_readdir+0x32/0x74
Jan 17 19:07:18 vosztok kernel:  [<c0162010>] vfs_readdir+0x32/0x74
Jan 17 19:07:18 vosztok kernel:  [filldir64+0/197] filldir64+0x0/0xc5
Jan 17 19:07:18 vosztok kernel:  [<c0161e60>] filldir64+0x0/0xc5
Jan 17 19:07:18 vosztok kernel:  [sys_getdents64+99/165] sys_getdents64+0x6=
3/0xa5
Jan 17 19:07:18 vosztok kernel:  [<c01620b5>] sys_getdents64+0x63/0xa5
Jan 17 19:07:18 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:18 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:18 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:21 vosztok kernel: 3f0 002f8d48=20
Jan 17 19:07:21 vosztok kernel:        c011efb9 df41aa80 c04888c0 000003e8 =
dec30980 c021fa8f dec77fc4 dec77fc4=20
Jan 17 19:07:21 vosztok kernel: Call Trace:
Jan 17 19:07:21 vosztok kernel:  [schedule_timeout+120/149] schedule_timeou=
t+0x78/0x95
Jan 17 19:07:21 vosztok kernel:  [<c036c924>] schedule_timeout+0x78/0x95
Jan 17 19:07:21 vosztok kernel:  [__generic_unplug_device+29/31] __generic_=
unplug_device+0x1d/0x1f
Jan 17 19:07:21 vosztok kernel:  [<c02329bb>] __generic_unplug_device+0x1d/=
0x1f
Jan 17 19:07:21 vosztok kernel:  [process_timeout+0/5] process_timeout+0x0/=
0x5
Jan 17 19:07:21 vosztok kernel:  [<c011efb9>] process_timeout+0x0/0x5
Jan 17 19:07:21 vosztok kernel:  [xfsbufd+95/240] xfsbufd+0x5f/0xf0
Jan 17 19:07:21 vosztok kernel:  [<c021fa8f>] xfsbufd+0x5f/0xf0
Jan 17 19:07:21 vosztok kernel:  [xfsbufd+0/240] xfsbufd+0x0/0xf0
Jan 17 19:07:21 vosztok kernel:  [<c021fa30>] xfsbufd+0x0/0xf0
Jan 17 19:07:21 vosztok kernel:  [kthread+54/92] kthread+0x36/0x5c
Jan 17 19:07:21 vosztok kernel:  [<c012777a>] kthread+0x36/0x5c
Jan 17 19:07:21 vosztok kernel:  [kthread+0/92] kthread+0x0/0x5c
Jan 17 19:07:21 vosztok kernel:  [<c0127744>] kthread+0x0/0x5c
Jan 17 19:07:21 vosztok kernel:  [kernel_thread_helper+7/16] kernel_thread_=
helper+0x7/0x10
Jan 17 19:07:21 vosztok kernel:  [<c0104917>] kernel_thread_helper+0x7/0x10
Jan 17 19:07:21 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:21 vosztok kernel: xfssyncd      S 00000000     0  2583      2
Jan 17 19:07:21 vosztok kernel:        de1dbf8c 00000046 df41b644 00000000 =
dbca1a80 00000286 002fc7e0 de1dbf9c=20
Jan 17 19:07:21 vosztok kernel:        de1dbfc0 00007530 c036c924 00000000 =
00000003 c04320dc c04894c0 002fc7e0=20
Jan 17 19:07:21 vosztok kernel:        c011efb9 df41b500 c04888c0 de1dbfc0 =
de159d80 c02245cf de1dbfc0 de1dbfc0=20
Jan 17 19:07:21 vosztok kernel: Call Trace:
Jan 17 19:07:21 vosztok kernel:  [schedule_timeout+120/149] schedule_timeou=
t+0x78/0x95
Jan 17 19:07:21 vosztok kernel:  [<c036c924>] schedule_timeout+0x78/0x95
Jan 17 19:07:21 vosztok kernel:  [process_timeout+0/5] process_timeout+0x0/=
0x5
Jan 17 19:07:21 vosztok kernel:  [<c011efb9>] process_timeout+0x0/0x5
Jan 17 19:07:21 vosztok kernel:  [xfssyncd+54/316] xfssyncd+0x36/0x13c
Jan 17 19:07:21 vosztok kernel:  [<c02245cf>] xfssyncd+0x36/0x13c
Jan 17 19:07:21 vosztok kernel:  [xfssyncd+0/316] xfssyncd+0x0/0x13c
Jan 17 19:07:21 vosztok kernel:  [<c0224599>] xfssyncd+0x0/0x13c
Jan 17 19:07:21 vosztok kernel:  [kthread+54/92] kthread+0x36/0x5c
Jan 17 19:07:21 vosztok kernel:  [<c012777a>] kthread+0x36/0x5c
Jan 17 19:07:21 vosztok kernel:  [kthread+0/92] kthread+0x0/0x5c
Jan 17 19:07:21 vosztok kernel:  [<c0127744>] kthread+0x0/0x5c
Jan 17 19:07:21 vosztok kernel:  [kernel_thread_helper+7/16] kernel_thread_=
helper+0x7/0x10
Jan 17 19:07:21 vosztok kernel:  [<c0104917>] kernel_thread_helper+0x7/0x10
Jan 17 19:07:21 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:21 vosztok kernel: pccardd       S fffb9dc4     0  3737      2
Jan 17 19:07:21 vosztok kernel:        de227fa4 00000046 dd8de144 fffb9dc4 =
df2e8700 de227fc8 00000202 ddf9f428=20
Jan 17 19:07:21 vosztok kernel:        00000000 00000000 e07b4c8f e07b4ad3 =
de227fd4 00000000 dd8de000 c0114c20=20
Jan 17 19:07:21 vosztok kernel:        ddf9f55c ddf9f55c 00004000 ddf9f428 =
e07b4ad3 00000000 c012777a c0127744=20
Jan 17 19:07:21 vosztok kernel: Call Trace:
Jan 17 19:07:21 vosztok kernel:  [<e07b4c8f>] pccardd+0x1bc/0x20a [pcmcia_c=
ore]
Jan 17 19:07:21 vosztok kernel:  [<e07b4ad3>] pccardd+0x0/0x20a [pcmcia_cor=
e]
Jan 17 19:07:21 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:07:21 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:07:21 vosztok kernel:  [<e07b4ad3>] pccardd+0x0/0x20a [pcmcia_cor=
e]
Jan 17 19:07:21 vosztok kernel:  [kthread+54/92] kthread+0x36/0x5c
Jan 17 19:07:21 vosztok kernel:  [<c012777a>] kthread+0x36/0x5c
Jan 17 19:07:21 vosztok kernel:  [kthread+0/92] kthread+0x0/0x5c
Jan 17 19:07:21 vosztok kernel:  [<c0127744>] kthread+0x0/0x5c
Jan 17 19:07:21 vosztok kernel:  [kernel_thread_helper+7/16] kernel_thread_=
helper+0x7/0x10
Jan 17 19:07:21 vosztok kernel:  [<c0104917>] kernel_thread_helper+0x7/0x10
Jan 17 19:07:21 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:21 vosztok kernel: ipw2200/0     S de021688     0  3742      2
Jan 17 19:07:21 vosztok kernel:        df2c9fb4 00000046 dd8df644 de021688 =
dbca1a80 c01279b8 de021680 c01250e0=20
Jan 17 19:07:21 vosztok kernel:        df2c9fd0 00000000 c0125161 00000000 =
dd8df500 c0127833 de021688 de021688=20
Jan 17 19:07:21 vosztok kernel:        de021680 00000000 c012777a c0127744 =
00000000 c0104917 df385db0 00000000=20
Jan 17 19:07:21 vosztok kernel: Call Trace:
Jan 17 19:07:21 vosztok kernel:  [prepare_to_wait+74/102] prepare_to_wait+0=
x4a/0x66
Jan 17 19:07:21 vosztok kernel:  [<c01279b8>] prepare_to_wait+0x4a/0x66
Jan 17 19:07:21 vosztok kernel:  [worker_thread+0/188] worker_thread+0x0/0x=
bc
Jan 17 19:07:21 vosztok kernel:  [<c01250e0>] worker_thread+0x0/0xbc
Jan 17 19:07:21 vosztok kernel:  [worker_thread+129/188] worker_thread+0x81=
/0xbc
Jan 17 19:07:21 vosztok kernel:  [<c0125161>] worker_thread+0x81/0xbc
Jan 17 19:07:21 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 19:07:21 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 19:07:21 vosztok kernel:  [kthread+54/92] kthread+0x36/0x5c
Jan 17 19:07:21 vosztok kernel:  [<c012777a>] kthread+0x36/0x5c
Jan 17 19:07:21 vosztok kernel:  [kthread+0/92] kthread+0x0/0x5c
Jan 17 19:07:21 vosztok kernel:  [<c0127744>] kthread+0x0/0x5c
Jan 17 19:07:21 vosztok kernel:  [kernel_thread_helper+7/16] kernel_thread_=
helper+0x7/0x10
Jan 17 19:07:21 vosztok kernel:  [<c0104917>] kernel_thread_helper+0x7/0x10
Jan 17 19:07:21 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:21 vosztok kernel: fbsplashd.sta ? df492540     0  3878      1
Jan 17 19:07:21 vosztok kernel:        dd799e84 00000046 df492684 df492540 =
df2e8a80 dd799f10 dd799ea0 df492540=20
Jan 17 19:07:21 vosztok kernel:        00000010 df492624 c011ad2c c0114c02 =
00000000 00000001 00000086 df475500=20
Jan 17 19:07:21 vosztok kernel:        dd799ea0 dd799ea0 df6a4e00 0000000f =
0000000f dd799f10 c011ada9 df0e30ec=20
Jan 17 19:07:21 vosztok kernel: Call Trace:
Jan 17 19:07:21 vosztok kernel:  [do_exit+1833/1837] do_exit+0x729/0x72d
Jan 17 19:07:21 vosztok kernel:  [<c011ad2c>] do_exit+0x729/0x72d
Jan 17 19:07:21 vosztok kernel:  [try_to_wake_up+134/164] try_to_wake_up+0x=
86/0xa4
Jan 17 19:07:21 vosztok kernel:  [<c0114c02>] try_to_wake_up+0x86/0xa4
Jan 17 19:07:21 vosztok kernel:  [sys_exit_group+0/13] sys_exit_group+0x0/0=
xd
Jan 17 19:07:21 vosztok kernel:  [<c011ada9>] sys_exit_group+0x0/0xd
Jan 17 19:07:21 vosztok kernel:  [get_signal_to_deliver+1009/1054] get_sign=
al_to_deliver+0x3f1/0x41e
Jan 17 19:07:21 vosztok kernel:  [<c0121c20>] get_signal_to_deliver+0x3f1/0=
x41e
Jan 17 19:07:21 vosztok kernel:  [do_sync_read+198/265] do_sync_read+0xc6/0=
x109
Jan 17 19:07:21 vosztok kernel:  [<c01576e6>] do_sync_read+0xc6/0x109
Jan 17 19:07:21 vosztok kernel:  [do_notify_resume+129/1502] do_notify_resu=
me+0x81/0x5de
Jan 17 19:07:21 vosztok kernel:  [<c0103587>] do_notify_resume+0x81/0x5de
Jan 17 19:07:21 vosztok kernel:  [xfs_iflush_done+0/131] xfs_iflush_done+0x=
0/0x83
Jan 17 19:07:21 vosztok kernel:  [<c02004ab>] xfs_iflush_done+0x0/0x83
Jan 17 19:07:21 vosztok kernel:  [hrtimer_interrupt+433/473] hrtimer_interr=
upt+0x1b1/0x1d9
Jan 17 19:07:21 vosztok kernel:  [<c012a787>] hrtimer_interrupt+0x1b1/0x1d9
Jan 17 19:07:21 vosztok kernel:  [do_sync_read+0/265] do_sync_read+0x0/0x109
Jan 17 19:07:21 vosztok kernel:  [<c0157620>] do_sync_read+0x0/0x109
Jan 17 19:07:21 vosztok kernel:  [vfs_read+136/266] vfs_read+0x88/0x10a
Jan 17 19:07:21 vosztok kernel:  [<c0157e5f>] vfs_read+0x88/0x10a
Jan 17 19:07:21 vosztok kernel:  [sys_read+95/103] sys_read+0x5f/0x67
Jan 17 19:07:21 vosztok kernel:  [<c01581e4>] sys_read+0x5f/0x67
Jan 17 19:07:21 vosztok kernel:  [work_notifysig+19/25] work_notifysig+0x13=
/0x19
Jan 17 19:07:21 vosztok kernel:  [<c0103e9a>] work_notifysig+0x13/0x19
Jan 17 19:07:21 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:21 vosztok kernel: fbsplashd.sta D 002e134a     0  3879      1
Jan 17 19:07:21 vosztok kernel:        dd7b9de0 00000046 df493644 002e134a =
db6571c0 df5fc000 c041edd8 df493500=20
Jan 17 19:07:21 vosztok kernel:        df2e8a80 dd7b9f10 c036ccbe c041eddc =
c041eddc df493500 df5fc000 c03778e0=20
Jan 17 19:07:21 vosztok kernel:        c036cae9 c0168c05 7fffffff 00000000 =
dd7b9e0c dd7b9e0c df5fc000 c03778e0=20
Jan 17 19:07:21 vosztok kernel: Call Trace:
Jan 17 19:07:21 vosztok kernel:  [__mutex_lock_slowpath+101/174] __mutex_lo=
ck_slowpath+0x65/0xae
Jan 17 19:07:21 vosztok kernel:  [<c036ccbe>] __mutex_lock_slowpath+0x65/0x=
ae
Jan 17 19:07:21 vosztok kernel:  [mutex_lock+9/10] mutex_lock+0x9/0xa
Jan 17 19:07:21 vosztok kernel:  [<c036cae9>] mutex_lock+0x9/0xa
Jan 17 19:07:21 vosztok kernel:  [invalidate_inodes+31/222] invalidate_inod=
es+0x1f/0xde
Jan 17 19:07:21 vosztok kernel:  [<c0168c05>] invalidate_inodes+0x1f/0xde
Jan 17 19:07:21 vosztok kernel:  [generic_shutdown_super+49/230] generic_sh=
utdown_super+0x31/0xe6
Jan 17 19:07:21 vosztok kernel:  [<c015906b>] generic_shutdown_super+0x31/0=
xe6
Jan 17 19:07:21 vosztok kernel:  [d_genocide+83/107] d_genocide+0x53/0x6b
Jan 17 19:07:21 vosztok kernel:  [<c0166d2b>] d_genocide+0x53/0x6b
Jan 17 19:07:21 vosztok kernel:  [kill_anon_super+9/69] kill_anon_super+0x9=
/0x45
Jan 17 19:07:21 vosztok kernel:  [<c0159144>] kill_anon_super+0x9/0x45
Jan 17 19:07:21 vosztok kernel:  [deactivate_super+73/92] deactivate_super+=
0x49/0x5c
Jan 17 19:07:21 vosztok kernel:  [<c01591e0>] deactivate_super+0x49/0x5c
Jan 17 19:07:21 vosztok kernel:  [remove_vma+37/54] remove_vma+0x25/0x36
Jan 17 19:07:21 vosztok kernel:  [<c0148774>] remove_vma+0x25/0x36
Jan 17 19:07:21 vosztok kernel:  [exit_mmap+216/239] exit_mmap+0xd8/0xef
Jan 17 19:07:21 vosztok kernel:  [<c014885d>] exit_mmap+0xd8/0xef
Jan 17 19:07:21 vosztok kernel:  [mmput+31/137] mmput+0x1f/0x89
Jan 17 19:07:21 vosztok kernel:  [<c01160a3>] mmput+0x1f/0x89
Jan 17 19:07:21 vosztok kernel:  [do_exit+470/1837] do_exit+0x1d6/0x72d
Jan 17 19:07:21 vosztok kernel:  [<c011a7d9>] do_exit+0x1d6/0x72d
Jan 17 19:07:21 vosztok kernel:  [update_curr_load+110/131] update_curr_loa=
d+0x6e/0x83
Jan 17 19:07:21 vosztok kernel:  [<c011395f>] update_curr_load+0x6e/0x83
Jan 17 19:07:21 vosztok kernel:  [recalc_sigpending+10/27] recalc_sigpendin=
g+0xa/0x1b
Jan 17 19:07:21 vosztok kernel:  [<c011f77a>] recalc_sigpending+0xa/0x1b
Jan 17 19:07:21 vosztok kernel:  [dequeue_signal+255/284] dequeue_signal+0x=
ff/0x11c
Jan 17 19:07:21 vosztok kernel:  [<c0120ea9>] dequeue_signal+0xff/0x11c
Jan 17 19:07:21 vosztok kernel:  [sys_exit_group+0/13] sys_exit_group+0x0/0=
xd
Jan 17 19:07:21 vosztok kernel: ada9>] sys_exit_group+0x0/0xd
Jan 17 19:07:21 vosztok kernel:  [get_signal_to_deliver+1009/1054] get_sign=
al_to_deliver+0x3f1/0x41e
Jan 17 19:07:21 vosztok kernel:  [<c0121c20>] get_signal_to_deliver+0x3f1/0=
x41e
Jan 17 19:07:21 vosztok kernel:  [__dequeue_signal+16/282] __dequeue_signal=
+0x10/0x11a
Jan 17 19:07:21 vosztok kernel:  [<c011fa3b>] __dequeue_signal+0x10/0x11a
Jan 17 19:07:21 vosztok kernel:  [do_notify_resume+129/1502] do_notify_resu=
me+0x81/0x5de
Jan 17 19:07:21 vosztok kernel:  [<c0103587>] do_notify_resume+0x81/0x5de
Jan 17 19:07:21 vosztok kernel:  [remove_vma+49/54] remove_vma+0x31/0x36
Jan 17 19:07:21 vosztok kernel:  [<c0148780>] remove_vma+0x31/0x36
Jan 17 19:07:21 vosztok kernel:  [__slab_free+92/670] __slab_free+0x5c/0x29e
Jan 17 19:07:21 vosztok kernel:  [<c01540ab>] __slab_free+0x5c/0x29e
Jan 17 19:07:21 vosztok kernel:  [quicklist_trim+189/222] quicklist_trim+0x=
bd/0xde
Jan 17 19:07:21 vosztok kernel:  [<c0155dff>] quicklist_trim+0xbd/0xde
Jan 17 19:07:21 vosztok kernel:  [pgd_dtor+0/86] pgd_dtor+0x0/0x56
Jan 17 19:07:21 vosztok kernel:  [<c0111d75>] pgd_dtor+0x0/0x56
Jan 17 19:07:21 vosztok kernel:  [remove_vma+49/54] remove_vma+0x31/0x36
Jan 17 19:07:21 vosztok kernel:  [<c0148780>] remove_vma+0x31/0x36
Jan 17 19:07:21 vosztok kernel:  [remove_vma+49/54] remove_vma+0x31/0x36
Jan 17 19:07:21 vosztok kernel:  [<c0148780>] remove_vma+0x31/0x36
Jan 17 19:07:21 vosztok kernel:  [sys_futex+194/212] sys_futex+0xc2/0xd4
Jan 17 19:07:21 vosztok kernel:  [<c0130ffb>] sys_futex+0xc2/0xd4
Jan 17 19:07:21 vosztok kernel:  [work_notifysig+19/25] work_notifysig+0x13=
/0x19
Jan 17 19:07:21 vosztok kernel:  [<c0103e9a>] work_notifysig+0x13/0x19
Jan 17 19:07:21 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:21 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:21 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:21 vosztok kernel: segctord      D df6d5100     0  4265      2
Jan 17 19:07:21 vosztok kernel:        dcedfe08 00000046 df475b84 df6d5100 =
cd3628c0 c013dd7f dcedff28 c1977700=20
Jan 17 19:07:21 vosztok kernel:        dcedfe24 dcedfe2c c036c31f 00000001 =
df475a40 c0114c20 dcedff2c dcedff2c=20
Jan 17 19:07:21 vosztok kernel:        dcedff04 00000001 c78be2d8 e08c711a =
c78be2d8 dcedff04 d70c3070 e08c7268=20
Jan 17 19:07:21 vosztok kernel: Call Trace:
Jan 17 19:07:21 vosztok kernel:  [mempool_alloc+28/228] mempool_alloc+0x1c/=
0xe4
Jan 17 19:07:21 vosztok kernel:  [<c013dd7f>] mempool_alloc+0x1c/0xe4
Jan 17 19:07:21 vosztok kernel:  [wait_for_completion+125/205] wait_for_com=
pletion+0x7d/0xcd
Jan 17 19:07:21 vosztok kernel:  [<c036c31f>] wait_for_completion+0x7d/0xcd
Jan 17 19:07:21 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:07:21 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:07:21 vosztok kernel:  [<e08c711a>] nilfs_segbuf_wait+0x79/0x1d7 =
[nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08c7268>] nilfs_segbuf_wait+0x1c7/0x1d7=
 [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08c75de>] nilfs_segbuf_write+0x48/0x83 =
[nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08ca035>] nilfs_segctor_add_dirty+0x1ca=
3/0x259f [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 19:07:21 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 19:07:21 vosztok kernel:  [<e08ca8e0>] nilfs_segctor_add_dirty+0x254=
e/0x259f [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08cbd47>] nilfs_clean_segments+0x3e0/0x=
9ac [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08cab33>] nilfs_segctor_add_segments_to=
_be_freed+0x202/0x33b [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08cbbcc>] nilfs_clean_segments+0x265/0x=
9ac [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [kernel_thread_helper+7/16] kernel_thread_=
helper+0x7/0x10
Jan 17 19:07:21 vosztok kernel:  [<c0104917>] kernel_thread_helper+0x7/0x10
Jan 17 19:07:21 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:21 vosztok kernel: gpg-agent     D c015fb49     0 10190      1
Jan 17 19:07:21 vosztok kernel:        d7087e98 00000082 dbce4bc4 c015fb49 =
d6ddec40 c440c016 fffeffff df3b8c94=20
Jan 17 19:07:21 vosztok kernel:        00000000 dbce4a80 c023bd30 d7087ebc =
c348d78b df3b8c94 df3b8c00 00000000=20
Jan 17 19:07:21 vosztok kernel:        de9db2a0 c036d592 d572dd5c df477e74 =
dbce4a80 00000001 df3b8c94 c036d5d3=20
Jan 17 19:07:21 vosztok kernel: Call Trace:
Jan 17 19:07:21 vosztok kernel:  [__link_path_walk+2884/3072] __link_path_w=
alk+0xb44/0xc00
Jan 17 19:07:21 vosztok kernel:  [<c015fb49>] __link_path_walk+0xb44/0xc00
Jan 17 19:07:21 vosztok kernel:  [rwsem_down_failed_common+328/353] rwsem_d=
own_failed_common+0x148/0x161
Jan 17 19:07:21 vosztok kernel:  [<c023bd30>] rwsem_down_failed_common+0x14=
8/0x161
Jan 17 19:07:21 vosztok kernel:  [rwsem_down_read_failed+26/36] rwsem_down_=
read_failed+0x1a/0x24
Jan 17 19:07:21 vosztok kernel:  [<c036d592>] rwsem_down_read_failed+0x1a/0=
x24
Jan 17 19:07:21 vosztok kernel:  [call_rwsem_down_read_failed+7/12] call_rw=
sem_down_read_failed+0x7/0xc
Jan 17 19:07:21 vosztok kernel:  [<c036d5d3>] call_rwsem_down_read_failed+0=
x7/0xc
Jan 17 19:07:21 vosztok kernel:  [down_read+9/10] down_read+0x9/0xa
Jan 17 19:07:21 vosztok kernel:  [<c012a885>] down_read+0x9/0xa
Jan 17 19:07:21 vosztok kernel:  [<e08caf2c>] nilfs_transaction_begin+0xd4/=
0x150 [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08bc377>] nilfs_load_super_block+0x7f/0=
x924 [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [vfs_unlink+66/125] vfs_unlink+0x42/0x7d
Jan 17 19:07:21 vosztok kernel:  [<c015e654>] vfs_unlink+0x42/0x7d
Jan 17 19:07:21 vosztok kernel:  [do_unlinkat+146/293] do_unlinkat+0x92/0x1=
25
Jan 17 19:07:21 vosztok kernel:  [<c0160335>] do_unlinkat+0x92/0x125
Jan 17 19:07:21 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:21 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:21 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:21 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:21 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:21 vosztok kernel: urxvtd        D 00000000     0 10212      1
Jan 17 19:07:21 vosztok kernel:        d572dd38 00000046 d594c144 00000000 =
de5f5a80 00153995 fffeffff df3b8c94=20
Jan 17 19:07:21 vosztok kernel:        00000000 d594c000 c023bd30 d572dd5c =
00000007 df3b8c94 df3b8c00 00000000=20
Jan 17 19:07:21 vosztok kernel:        de9db2a0 c036d592 df3b8c98 d7087ebc =
d594c000 00000001 df3b8c94 c036d5d3=20
Jan 17 19:07:21 vosztok kernel: Call Trace:
Jan 17 19:07:21 vosztok kernel:  [rwsem_down_failed_common+328/353] rwsem_d=
own_failed_common+0x148/0x161
Jan 17 19:07:21 vosztok kernel:  [<c023bd30>] rwsem_down_failed_common+0x14=
8/0x161
Jan 17 19:07:21 vosztok kernel:  [rwsem_down_read_failed+26/36] rwsem_down_=
read_failed+0x1a/0x24
Jan 17 19:07:21 vosztok kernel:  [<c036d592>] rwsem_down_read_failed+0x1a/0=
x24
Jan 17 19:07:21 vosztok kernel:  [call_rwsem_down_read_failed+7/12] call_rw=
sem_down_read_failed+0x7/0xc
Jan 17 19:07:21 vosztok kernel:  [<c036d5d3>] call_rwsem_down_read_failed+0=
x7/0xc
Jan 17 19:07:21 vosztok kernel:  [down_read+9/10] down_read+0x9/0xa
Jan 17 19:07:21 vosztok kernel:  [<c012a885>] down_read+0x9/0xa
Jan 17 19:07:21 vosztok kernel:  [<e08caf2c>] nilfs_transaction_begin+0xd4/=
0x150 [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [sk_free+162/183] sk_free+0xa2/0xb7
Jan 17 19:07:21 vosztok kernel:  [<c02f110d>] sk_free+0xa2/0xb7
Jan 17 19:07:21 vosztok kernel:  [<e08b958a>] nilfs_delete_inode+0x47/0x115=
 [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [sk_free+162/183] sk_free+0xa2/0xb7
Jan 17 19:07:21 vosztok kernel:  [<c02f110d>] sk_free+0xa2/0xb7
Jan 17 19:07:21 vosztok kernel:  [__slab_free+206/670] __slab_free+0xce/0x2=
9e
Jan 17 19:07:21 vosztok kernel:  [<c015411d>] __slab_free+0xce/0x29e
Jan 17 19:07:21 vosztok kernel:  [<e08b9543>] nilfs_delete_inode+0x0/0x115 =
[nilfs2]
Jan 17 19:07:21 vosztok kernel:  [generic_delete_inode+113/236] generic_del=
ete_inode+0x71/0xec
Jan 17 19:07:21 vosztok kernel:  [<c01685db>] generic_delete_inode+0x71/0xec
Jan 17 19:07:21 vosztok kernel:  [iput+96/98] iput+0x60/0x62
Jan 17 19:07:21 vosztok kernel:  [<c0167db5>] iput+0x60/0x62
Jan 17 19:07:21 vosztok kernel:  [d_kill+45/70] d_kill+0x2d/0x46
Jan 17 19:07:21 vosztok kernel:  [<c0165e1e>] d_kill+0x2d/0x46
Jan 17 19:07:21 vosztok kernel:  [dput+307/314] dput+0x133/0x13a
Jan 17 19:07:21 vosztok kernel:  [<c0165f6a>] dput+0x133/0x13a
Jan 17 19:07:21 vosztok kernel:  [unix_release_sock+486/545] unix_release_s=
ock+0x1e6/0x221
Jan 17 19:07:21 vosztok kernel:  [<c0342733>] unix_release_sock+0x1e6/0x221
Jan 17 19:07:21 vosztok kernel:  [sock_release+20/125] sock_release+0x14/0x=
7d
Jan 17 19:07:21 vosztok kernel:  [<c02ef4be>] sock_release+0x14/0x7d
Jan 17 19:07:21 vosztok kernel:  [sock_close+42/47] sock_close+0x2a/0x2f
Jan 17 19:07:21 vosztok kernel:  [<c02ef925>] sock_close+0x2a/0x2f
Jan 17 19:07:21 vosztok kernel:  [__fput+150/350] __fput+0x96/0x15e
Jan 17 19:07:21 vosztok kernel:  [<c0158584>] __fput+0x96/0x15e
Jan 17 19:07:21 vosztok kernel:  [filp_close+81/88] filp_close+0x51/0x58
Jan 17 19:07:21 vosztok kernel:  [<c01560e5>] filp_close+0x51/0x58
Jan 17 19:07:21 vosztok kernel:  [put_files_struct+94/166] put_files_struct=
+0x5e/0xa6
Jan 17 19:07:21 vosztok kernel:  [<c0119678>] put_files_struct+0x5e/0xa6
Jan 17 19:07:21 vosztok kernel:  [do_exit+552/1837] do_exit+0x228/0x72d
Jan 17 19:07:21 vosztok kernel:  [<c011a82b>] do_exit+0x228/0x72d
Jan 17 19:07:21 vosztok kernel:  [recalc_sigpending+10/27] recalc_sigpendin=
g+0xa/0x1b
Jan 17 19:07:21 vosztok kernel:  [<c011f77a>] recalc_sigpending+0xa/0x1b
Jan 17 19:07:21 vosztok kernel:  [dequeue_signal+145/284] dequeue_signal+0x=
91/0x11c
Jan 17 19:07:21 vosztok kernel:  [<c0120e3b>] dequeue_signal+0x91/0x11c
Jan 17 19:07:21 vosztok kernel:  [sys_exit_group+0/13] sys_exit_group+0x0/0=
xd
Jan 17 19:07:21 vosztok kernel:  [<c011ada9>] sys_exit_group+0x0/0xd
Jan 17 19:07:21 vosztok kernel:  [get_signal_to_deliver+1009/1054] get_sign=
al_to_deliver+0x3f1/0x41e
Jan 17 19:07:21 vosztok kernel:  [<c0121c20>] get_signal_to_deliver+0x3f1/0=
x41e
Jan 17 19:07:21 vosztok kernel:  [do_notify_resume+129/1502] do_notify_resu=
me+0x81/0x5de
Jan 17 19:07:21 vosztok kernel:  [<c0103587>] do_notify_resume+0x81/0x5de
Jan 17 19:07:21 vosztok kernel:  [_atomic_dec_and_lock+37/64] _atomic_dec_a=
nd_lock+0x25/0x40
Jan 17 19:07:21 vosztok kernel:  [<c02390e9>] _atomic_dec_and_lock+0x25/0x40
Jan 17 19:07:21 vosztok kernel:  [do_page_fault+616/1439] do_page_fault+0x2=
68/0x59f
Jan 17 19:07:21 vosztok kernel:  [<c0112649>] do_page_fault+0x268/0x59f
Jan 17 19:07:21 vosztok kernel:  [tasklet_action+50/87] tasklet_action+0x32=
/0x57
Jan 17 19:07:21 vosztok kernel:  [<c011bf67>] tasklet_action+0x32/0x57
Jan 17 19:07:21 vosztok kernel:  [sigprocmask+157/182] sigprocmask+0x9d/0xb6
Jan 17 19:07:21 vosztok kernel:  [<c011f828>] sigprocmask+0x9d/0xb6
Jan 17 19:07:21 vosztok kernel:  [sys_rt_sigprocmask+71/186] sys_rt_sigproc=
mask+0x47/0xba
Jan 17 19:07:21 vosztok kernel:  [work_notifysig+19/25] work_notifysig+0x13=
/0x19
Jan 17 19:07:21 vosztok kernel:  [<c0103e9a>] work_notifysig+0x13/0x19
Jan 17 19:07:21 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:21 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:21 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:21 vosztok kernel: rtorrent      D c013d4b5     0 10225      1
Jan 17 19:07:21 vosztok kernel:        d5077890 00000082 d594d644 c013d4b5 =
d5959a80 e08bd210 d50778bc d50778bc=20
Jan 17 19:07:21 vosztok kernel:        c13f0960 d5077898 c036c20c c013b86b =
c013b8a9 c036c98d d50778bc 00000000=20
Jan 17 19:07:21 vosztok kernel:        d50778d8 00000000 c013b85d 00000002 =
c120fcc0 00000000 00000001 d594d500=20
Jan 17 19:07:21 vosztok kernel: Call Trace:
Jan 17 19:07:21 vosztok kernel:  [find_or_create_page+28/140] find_or_creat=
e_page+0x1c/0x8c
Jan 17 19:07:21 vosztok kernel:  [<c013d4b5>] find_or_create_page+0x1c/0x8c
Jan 17 19:07:21 vosztok kernel:  [<e08bd210>] nilfs_get_page_block+0x97/0xb=
1 [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [io_schedule+14/22] io_schedule+0xe/0x16
Jan 17 19:07:21 vosztok kernel:  [<c036c20c>] io_schedule+0xe/0x16
Jan 17 19:07:21 vosztok kernel:  [sync_page+0/65] sync_page+0x0/0x41
Jan 17 19:07:21 vosztok kernel:  [<c013b86b>] sync_page+0x0/0x41
Jan 17 19:07:21 vosztok kernel:  [sync_page+62/65] sync_page+0x3e/0x41
Jan 17 19:07:21 vosztok kernel:  [<c013b8a9>] sync_page+0x3e/0x41
Jan 17 19:07:21 vosztok kernel:  [__wait_on_bit_lock+42/81] __wait_on_bit_l=
ock+0x2a/0x51
Jan 17 19:07:21 vosztok kernel:  [<c036c98d>] __wait_on_bit_lock+0x2a/0x51
Jan 17 19:07:21 vosztok kernel:  [__lock_page+87/93] __lock_page+0x57/0x5d
Jan 17 19:07:21 vosztok kernel:  [<c013b85d>] __lock_page+0x57/0x5d
Jan 17 19:07:21 vosztok kernel:  [wake_bit_function+0/60] wake_bit_function=
+0x0/0x3c
Jan 17 19:07:21 vosztok kernel:  [<c0127868>] wake_bit_function+0x0/0x3c
Jan 17 19:07:21 vosztok kernel:  [<e08be7aa>] __nilfs_btnode_get+0x70/0x1bc=
 [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08bf7b6>] nilfs_bmap_get_block+0x25/0x2=
a [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08c059d>] nilfs_btree_init_gc+0x72a/0x1=
050 [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08c1817>] nilfs_btree_path_cache_destro=
y+0x66b/0x1e39 [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [autoremove_wake_function+21/53] autoremov=
e_wake_function+0x15/0x35
Jan 17 19:07:21 vosztok kernel:  [<c0127848>] autoremove_wake_function+0x15=
/0x35
Jan 17 19:07:21 vosztok kernel:  [<e08bf6c6>] nilfs_bmap_lookup_at_level+0x=
33/0x81 [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08bf737>] nilfs_bmap_lookup+0x23/0x37 [=
nilfs2]
Jan 17 19:07:21 vosztok kernel:  [__alloc_pages+76/642] __alloc_pages+0x4c/=
0x282
Jan 17 19:07:21 vosztok kernel:  [<c013f870>] __alloc_pages+0x4c/0x282
Jan 17 19:07:21 vosztok kernel:  [<e08b96e3>] nilfs_get_block+0x8b/0x1de [n=
ilfs2]
Jan 17 19:07:21 vosztok kernel:  [delay_tsc+37/59] delay_tsc+0x25/0x3b
Jan 17 19:07:21 vosztok kernel:  [<c023d4aa>] delay_tsc+0x25/0x3b
Jan 17 19:07:21 vosztok kernel:  [__delay+6/7] __delay+0x6/0x7
Jan 17 19:07:21 vosztok kernel:  [<c023d46d>] __delay+0x6/0x7
Jan 17 19:07:21 vosztok kernel:  [ata_bmdma_start+11/25] ata_bmdma_start+0x=
b/0x19
Jan 17 19:07:21 vosztok kernel:  [<c02c803a>] ata_bmdma_start+0xb/0x19
Jan 17 19:07:21 vosztok kernel:  [ata_qc_issue_prot+232/542] ata_qc_issue_p=
rot+0xe8/0x21e
Jan 17 19:07:21 vosztok kernel:  [<c02c499b>] ata_qc_issue_prot+0xe8/0x21e
Jan 17 19:07:21 vosztok kernel:  [__alloc_pages+76/642] __alloc_pages+0x4c/=
0x282
Jan 17 19:07:21 vosztok kernel:  [<c013f870>] __alloc_pages+0x4c/0x282
Jan 17 19:07:21 vosztok kernel:  [do_mpage_readpage+386/1128] do_mpage_read=
page+0x182/0x468
Jan 17 19:07:21 vosztok kernel:  [<c0179ca9>] do_mpage_readpage+0x182/0x468
Jan 17 19:07:21 vosztok kernel:  [<e08b9658>] nilfs_get_block+0x0/0x1de [ni=
lfs2]
Jan 17 19:07:21 vosztok kernel:  [add_to_page_cache+159/185] add_to_page_ca=
che+0x9f/0xb9
Jan 17 19:07:21 vosztok kernel:  [<c013babd>] add_to_page_cache+0x9f/0xb9
Jan 17 19:07:21 vosztok kernel:  [mpage_readpages+178/276] mpage_readpages+=
0xb2/0x114
Jan 17 19:07:21 vosztok kernel:  [<c017a15a>] mpage_readpages+0xb2/0x114
Jan 17 19:07:21 vosztok kernel:  [<e08b9658>] nilfs_get_block+0x0/0x1de [ni=
lfs2]
Jan 17 19:07:21 vosztok kernel:  [get_page_from_freelist+463/820] get_page_=
from_freelist+0x1cf/0x334
Jan 17 19:07:21 vosztok kernel:  [<c013f545>] get_page_from_freelist+0x1cf/=
0x334
Jan 17 19:07:21 vosztok kernel:  [scsi_io_completion+252/792] scsi_io_compl=
etion+0xfc/0x318
Jan 17 19:07:21 vosztok kernel:  [<c02b224e>] scsi_io_completion+0xfc/0x318
Jan 17 19:07:21 vosztok kernel:  [<e08b913e>] nilfs_set_inode_flags+0x13b/0=
x15c [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [__do_page_cache_readahead+391/578] __do_p=
age_cache_readahead+0x187/0x242
Jan 17 19:07:21 vosztok kernel:  [<c0141196>] __do_page_cache_readahead+0x1=
87/0x242
Jan 17 19:07:21 vosztok kernel:  [<e08b9658>] nilfs_get_block+0x0/0x1de [ni=
lfs2]
Jan 17 19:07:21 vosztok kernel:  [scsi_softirq_done+32/199] scsi_softirq_do=
ne+0x20/0xc7
Jan 17 19:07:21 vosztok kernel:  [<c02b2936>] scsi_softirq_done+0x20/0xc7
Jan 17 19:07:21 vosztok kernel:  [scsi_finish_command+60/64] scsi_finish_co=
mmand+0x3c/0x40
Jan 17 19:07:21 vosztok kernel:  [<c02ae84f>] scsi_finish_command+0x3c/0x40
Jan 17 19:07:21 vosztok kernel:  [blk_done_softirq+74/85] blk_done_softirq+=
0x4a/0x55
Jan 17 19:07:21 vosztok kernel:  [<c02332f0>] blk_done_softirq+0x4a/0x55
Jan 17 19:07:21 vosztok kernel:  [do_page_cache_readahead+73/83] do_page_ca=
che_readahead+0x49/0x53
Jan 17 19:07:21 vosztok kernel:  [<c0141556>] do_page_cache_readahead+0x49/=
0x53
Jan 17 19:07:21 vosztok kernel:  [filemap_fault+435/969] filemap_fault+0x1b=
3/0x3c9
Jan 17 19:07:21 vosztok kernel:  [<c013d873>] filemap_fault+0x1b3/0x3c9
Jan 17 19:07:21 vosztok kernel:  [balance_dirty_pages_ratelimited_nr+397/42=
4] balance_dirty_pages_ratelimited_nr+0x18d/0x1a8
Jan 17 19:07:21 vosztok kernel:  [<c0140843>] balance_dirty_pages_ratelimit=
ed_nr+0x18d/0x1a8
Jan 17 19:07:21 vosztok kernel:  [__do_fault+80/773] __do_fault+0x50/0x305
Jan 17 19:07:21 vosztok kernel:  [<c0145089>] __do_fault+0x50/0x305
Jan 17 19:07:21 vosztok kernel:  [handle_mm_fault+731/1528] handle_mm_fault=
+0x2db/0x5f8
Jan 17 19:07:21 vosztok kernel:  [<c014683a>] handle_mm_fault+0x2db/0x5f8
Jan 17 19:07:21 vosztok kernel:  [do_page_fault+530/1439] do_page_fault+0x2=
12/0x59f
Jan 17 19:07:21 vosztok kernel:  [<c01125f3>] do_page_fault+0x212/0x59f
Jan 17 19:07:21 vosztok kernel:  [handle_IRQ_event+26/63] handle_IRQ_event+=
0x1a/0x3f
Jan 17 19:07:21 vosztok kernel:  [<c01394ba>] handle_IRQ_event+0x1a/0x3f
Jan 17 19:07:21 vosztok kernel:  [enable_8259A_irq+69/93] enable_8259A_irq+=
0x45/0x5d
Jan 17 19:07:21 vosztok kernel:  [<c0107913>] enable_8259A_irq+0x45/0x5d
Jan 17 19:07:21 vosztok kernel:  [do_page_fault+0/1439] do_page_fault+0x0/0=
x59f
Jan 17 19:07:21 vosztok kernel:  [<c01123e1>] do_page_fault+0x0/0x59f
Jan 17 19:07:21 vosztok kernel:  [error_code+106/112] error_code+0x6a/0x70
Jan 17 19:07:21 vosztok kernel:  [<c036d93a>] error_code+0x6a/0x70
Jan 17 19:07:21 vosztok kernel:  [ioapic_resume+70/172] ioapic_resume+0x46/=
0xac
Jan 17 19:07:21 vosztok kernel:  [<c011007b>] ioapic_resume+0x46/0xac
Jan 17 19:07:21 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:21 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:21 vosztok kernel:  [__copy_to_user_ll+69/204] __copy_to_user_=
ll+0x45/0xcc
Jan 17 19:07:21 vosztok kernel:  [<c023d7fc>] __copy_to_user_ll+0x45/0xcc
Jan 17 19:07:21 vosztok kernel:  [memcpy_toiovec+39/74] memcpy_toiovec+0x27=
/0x4a
Jan 17 19:07:21 vosztok kernel:  [<c02f56d9>] memcpy_toiovec+0x27/0x4a
Jan 17 19:07:21 vosztok kernel:  [skb_copy_datagram_iovec+63/432] skb_copy_=
datagram_iovec+0x3f/0x1b0
Jan 17 19:07:21 vosztok kernel:  [<c02f5b5f>] skb_copy_datagram_iovec+0x3f/=
0x1b0
Jan 17 19:07:21 vosztok kernel:  [tcp_recvmsg+1324/1811] tcp_recvmsg+0x52c/=
0x713
Jan 17 19:07:21 vosztok kernel:  [<c031780b>] tcp_recvmsg+0x52c/0x713
Jan 17 19:07:21 vosztok kernel:  [tcp_recvmsg+1324/1811] tcp_recvmsg+0x52c/=
0x713
Jan 17 19:07:21 vosztok kernel:  [<c031780b>] tcp_recvmsg+0x52c/0x713
Jan 17 19:07:21 vosztok kernel:  [tcp_recvmsg+1109/1811] tcp_recvmsg+0x455/=
0x713
Jan 17 19:07:21 vosztok kernel:  [<c0317734>] tcp_recvmsg+0x455/0x713
Jan 17 19:07:21 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 19:07:21 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 19:07:21 vosztok kernel:  [sock_common_recvmsg+62/84] sock_common_re=
cvmsg+0x3e/0x54
Jan 17 19:07:21 vosztok kernel:  [<c02f05bd>] sock_common_recvmsg+0x3e/0x54
Jan 17 19:07:21 vosztok kernel:  [sock_recvmsg+206/231] sock_recvmsg+0xce/0=
xe7
Jan 17 19:07:21 vosztok kernel:  [<c02eefae>] sock_recvmsg+0xce/0xe7
Jan 17 19:07:21 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 19:07:21 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 19:07:21 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 19:07:21 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 19:07:21 vosztok kernel:  [n_tty_receive_buf+3376/3451] n_tty_receiv=
e_buf+0xd30/0xd7b
Jan 17 19:07:21 vosztok kernel:  [<c02507f5>] n_tty_receive_buf+0xd30/0xd7b
Jan 17 19:07:21 vosztok kernel:  [enqueue_entity+466/499] enqueue_entity+0x=
1d2/0x1f3
Jan 17 19:07:21 vosztok kernel:  [<c0113e13>] enqueue_entity+0x1d2/0x1f3
Jan 17 19:07:21 vosztok kernel:  [<e099840e>] drm_vbl_send_signals+0xc2/0xe=
4 [drm]
Jan 17 19:07:21 vosztok kernel:  [sys_recvfrom+215/299] sys_recvfrom+0xd7/0=
x12b
Jan 17 19:07:21 vosztok kernel:  [<c02efcd9>] sys_recvfrom+0xd7/0x12b
Jan 17 19:07:21 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 19:07:21 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 19:07:21 vosztok kernel:  [update_stats_wait_end+155/190] update_sta=
ts_wait_end+0x9b/0xbe
Jan 17 19:07:21 vosztok kernel:  [<c01136df>] update_stats_wait_end+0x9b/0x=
be
Jan 17 19:07:21 vosztok kernel:  [update_curr_load+110/131] update_curr_loa=
d+0x6e/0x83
Jan 17 19:07:21 vosztok kernel:  [<c011395f>] update_curr_load+0x6e/0x83
Jan 17 19:07:21 vosztok kernel:  [__switch_to+25/276] __switch_to+0x19/0x114
Jan 17 19:07:21 vosztok kernel:  [<c0102f39>] __switch_to+0x19/0x114
Jan 17 19:07:21 vosztok kernel:  [schedule+572/755] schedule+0x23c/0x2f3
Jan 17 19:07:21 vosztok kernel:  [<c036bfe2>] schedule+0x23c/0x2f3
Jan 17 19:07:21 vosztok kernel:  [schedule+729/755] schedule+0x2d9/0x2f3
Jan 17 19:07:21 vosztok kernel:  [<c036c07f>] schedule+0x2d9/0x2f3
Jan 17 19:07:21 vosztok kernel:  [schedule_timeout+129/149] schedule_timeou=
t+0x81/0x95
Jan 17 19:07:21 vosztok kernel:  [<c036c92d>] schedule_timeout+0x81/0x95
Jan 17 19:07:21 vosztok kernel:  [sys_recv+55/59] sys_recv+0x37/0x3b
Jan 17 19:07:21 vosztok kernel:  [<c02efd64>] sys_recv+0x37/0x3b
Jan 17 19:07:21 vosztok kernel:  [sys_socketcall+383/578] sys_socketcall+0x=
17f/0x242
Jan 17 19:07:21 vosztok kernel:  [<c02f0201>] sys_socketcall+0x17f/0x242
Jan 17 19:07:21 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:21 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:21 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:21 vosztok kernel: weechat-curse D 00000099     0 10229      1
Jan 17 19:07:21 vosztok kernel:        dc075d5c 00200082 dc066144 00000099 =
d4dafa80 00000099 fffeffff df3b8c94=20
Jan 17 19:07:21 vosztok kernel:        00000000 dc066000 c023bd30 dc075d80 =
00000020 df3b8c94 df3b8c00 00000000=20
Jan 17 19:07:21 vosztok kernel:        de9db2a0 c036d592 df477e74 ced45d80 =
dc066000 00000001 df3b8c94 c036d5d3=20
Jan 17 19:07:21 vosztok kernel: Call Trace:
Jan 17 19:07:21 vosztok kernel:  [rwsem_down_failed_common+328/353] rwsem_d=
own_failed_common+0x148/0x161
Jan 17 19:07:21 vosztok kernel:  [<c023bd30>] rwsem_down_failed_common+0x14=
8/0x161
Jan 17 19:07:21 vosztok kernel:  [rwsem_down_read_failed+26/36] rwsem_down_=
read_failed+0x1a/0x24
Jan 17 19:07:21 vosztok kernel:  [<c036d592>] rwsem_down_read_failed+0x1a/0=
x24
Jan 17 19:07:21 vosztok kernel:  [call_rwsem_down_read_failed+7/12] call_rw=
sem_down_read_failed+0x7/0xc
Jan 17 19:07:21 vosztok kernel:  [<c036d5d3>] call_rwsem_down_read_failed+0=
x7/0xc
Jan 17 19:07:21 vosztok kernel:  [down_read+9/10] down_read+0x9/0xa
Jan 17 19:07:21 vosztok kernel:  [<c012a885>] down_read+0x9/0xa
Jan 17 19:07:21 vosztok kernel:  [<e08caf2c>] nilfs_transaction_begin+0xd4/=
0x150 [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [__rcu_process_callbacks+288/382] __rcu_pr=
ocess_callbacks+0x120/0x17e
Jan 17 19:07:21 vosztok kernel:  [<c01259e5>] __rcu_process_callbacks+0x120=
/0x17e
Jan 17 19:07:21 vosztok kernel:  [<e08cafc6>] nilfs_dirty_inode+0x1e/0x40 [=
nilfs2]
Jan 17 19:07:21 vosztok kernel:  [__rcu_process_callbacks+288/382] __rcu_pr=
ocess_callbacks+0x120/0x17e
Jan 17 19:07:21 vosztok kernel:  [<c01259e5>] __rcu_process_callbacks+0x120=
/0x17e
Jan 17 19:07:21 vosztok kernel:  [__mark_inode_dirty+36/360] __mark_inode_d=
irty+0x24/0x168
Jan 17 19:07:21 vosztok kernel:  [<c01705db>] __mark_inode_dirty+0x24/0x168
Jan 17 19:07:21 vosztok kernel:  [current_fs_time+19/21] current_fs_time+0x=
13/0x15
Jan 17 19:07:21 vosztok kernel:  [<c011bae5>] current_fs_time+0x13/0x15
Jan 17 19:07:21 vosztok kernel:  [__generic_file_aio_write_nolock+864/1288]=
 __generic_file_aio_write_nolock+0x360/0x508
Jan 17 19:07:21 vosztok kernel:  [<c013d0ca>] __generic_file_aio_write_nolo=
ck+0x360/0x508
Jan 17 19:07:21 vosztok kernel:  [do_IRQ+88/109] do_IRQ+0x58/0x6d
Jan 17 19:07:21 vosztok kernel:  [<c01062b7>] do_IRQ+0x58/0x6d
Jan 17 19:07:21 vosztok kernel:  [xfs_file_open+99/102] xfs_file_open+0x63/=
0x66
Jan 17 19:07:21 vosztok kernel:  [<c0220000>] xfs_file_open+0x63/0x66
Jan 17 19:07:21 vosztok kernel:  [generic_file_aio_write+82/176] generic_fi=
le_aio_write+0x52/0xb0
Jan 17 19:07:21 vosztok kernel:  [<c013d2c4>] generic_file_aio_write+0x52/0=
xb0
Jan 17 19:07:21 vosztok kernel:  [<e08b9ed2>] nilfs_read_inode+0x2df/0x341 =
[nilfs2]
Jan 17 19:07:21 vosztok kernel:  [do_sync_write+198/265] do_sync_write+0xc6=
/0x109
Jan 17 19:07:21 vosztok kernel:  [<c01575dd>] do_sync_write+0xc6/0x109
Jan 17 19:07:21 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 19:07:21 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 19:07:21 vosztok kernel:  [sys_stat64+30/35] sys_stat64+0x1e/0x23
Jan 17 19:07:21 vosztok kernel:  [<c015a6af>] sys_stat64+0x1e/0x23
Jan 17 19:07:21 vosztok kernel:  [do_sync_write+0/265] do_sync_write+0x0/0x=
109
Jan 17 19:07:21 vosztok kernel:  [<c0157517>] do_sync_write+0x0/0x109
Jan 17 19:07:21 vosztok kernel:  [vfs_write+138/268] vfs_write+0x8a/0x10c
Jan 17 19:07:21 vosztok kernel:  [<c0157d55>] vfs_write+0x8a/0x10c
Jan 17 19:07:21 vosztok kernel:  [sys_write+65/103] sys_write+0x41/0x67
Jan 17 19:07:21 vosztok kernel:  [<c015822d>] sys_write+0x41/0x67
Jan 17 19:07:21 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:21 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:21 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:21 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:21 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:21 vosztok kernel: gconfd-2      D 00000000     0 10244      1
Jan 17 19:07:21 vosztok kernel:        cb175a98 00000086 dc067b84 00000000 =
cfe578c0 00000000 cb175ac4 cb175ac4=20
Jan 17 19:07:21 vosztok kernel:        c13f1018 cb175aa0 c036c20c c013b86b =
c013b8a9 c036c98d cb175ac4 00000000=20
Jan 17 19:07:21 vosztok kernel:        cb175ae0 00000000 c013b85d 00000002 =
c1044b80 00000000 00000001 dc067a40=20
Jan 17 19:07:21 vosztok kernel: Call Trace:
Jan 17 19:07:21 vosztok kernel:  [io_schedule+14/22] io_schedule+0xe/0x16
Jan 17 19:07:21 vosztok kernel:  [<c036c20c>] io_schedule+0xe/0x16
Jan 17 19:07:21 vosztok kernel:  [sync_page+0/65] sync_page+0x0/0x41
Jan 17 19:07:21 vosztok kernel:  [<c013b86b>] sync_page+0x0/0x41
Jan 17 19:07:21 vosztok kernel:  [sync_page+62/65] sync_page+0x3e/0x41
Jan 17 19:07:21 vosztok kernel:  [<c013b8a9>] sync_page+0x3e/0x41
Jan 17 19:07:21 vosztok kernel:  [__wait_on_bit_lock+42/81] __wait_on_bit_l=
ock+0x2a/0x51
Jan 17 19:07:21 vosztok kernel:  [<c036c98d>] __wait_on_bit_lock+0x2a/0x51
Jan 17 19:07:21 vosztok kernel:  [__lock_page+87/93] __lock_page+0x57/0x5d
Jan 17 19:07:21 vosztok kernel:  [<c013b85d>] __lock_page+0x57/0x5d
Jan 17 19:07:21 vosztok kernel:  [wake_bit_function+0/60] wake_bit_function=
+0x0/0x3c
Jan 17 19:07:21 vosztok kernel:  [<c0127868>] wake_bit_function+0x0/0x3c
Jan 17 19:07:21 vosztok kernel:  [<e08be7aa>] __nilfs_btnode_get+0x70/0x1bc=
 [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08bf7b6>] nilfs_bmap_get_block+0x25/0x2=
a [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08c059d>] nilfs_btree_init_gc+0x72a/0x1=
050 [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08c1817>] nilfs_btree_path_cache_destro=
y+0x66b/0x1e39 [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [alloc_page_buffers+110/180] alloc_page_bu=
ffers+0x6e/0xb4
Jan 17 19:07:21 vosztok kernel:  [<c017393f>] alloc_page_buffers+0x6e/0xb4
Jan 17 19:07:21 vosztok kernel:  [<e08bf6c6>] nilfs_bmap_lookup_at_level+0x=
33/0x81 [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08bf737>] nilfs_bmap_lookup+0x23/0x37 [=
nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08bdd5d>] nilfs_mdt_mark_buffer_dirty+0=
x1aa/0x210 [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08bdde0>] nilfs_mdt_read_block+0x1d/0xb=
b [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08be0a1>] nilfs_mdt_get_block+0x1c/0x42=
 [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08c4fe7>] nilfs_dat_translate+0xd5/0x50=
b [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08c440a>] nilfs_dat_alloc+0x41/0x96 [ni=
lfs2]
Jan 17 19:07:21 vosztok kernel:  [get_page_from_freelist+647/820] get_page_=
from_freelist+0x287/0x334
Jan 17 19:07:21 vosztok kernel:  [<c013f5fd>] get_page_from_freelist+0x287/=
0x334
Jan 17 19:07:21 vosztok kernel:  [<e08bf3b2>] nilfs_bmap_clear+0x79/0x9a [n=
ilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08bf35e>] nilfs_bmap_clear+0x25/0x9a [n=
ilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08bf6ea>] nilfs_bmap_lookup_at_level+0x=
57/0x81 [nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08bf737>] nilfs_bmap_lookup+0x23/0x37 [=
nilfs2]
Jan 17 19:07:21 vosztok kernel:  [<e08b96e3>] nilfs_get_block+0x8b/0x1de [n=
ilfs2]
Jan 17 19:07:21 vosztok kernel:  [__slab_alloc+922/1060] __slab_alloc+0x39a=
/0x424
Jan 17 19:07:21 vosztok kernel:  [<c0154927>] __slab_alloc+0x39a/0x424
Jan 17 19:07:21 vosztok kernel:  [sock_alloc_send_skb+110/398] sock_alloc_s=
end_skb+0x6e/0x18e
Jan 17 19:07:21 vosztok kernel:  [<c02f0d9a>] sock_alloc_send_skb+0x6e/0x18e
Jan 17 19:07:21 vosztok kernel:  [do_mpage_readpage+386/1128] do_mpage_read=
page+0x182/0x468
Jan 17 19:07:21 vosztok kernel:  [<c0179ca9>] do_mpage_readpage+0x182/0x468
Jan 17 19:07:21 vosztok kernel:  [<e08b9658>] nilfs_get_block+0x0/0x1de [ni=
lfs2]
Jan 17 19:07:21 vosztok kernel:  [get_page_from_freelist+463/820] get_page_=
from_freelist+0x1cf/0x334
Jan 17 19:07:21 vosztok kernel:  [<c013f545>] get_page_from_freelist+0x1cf/=
0x334
Jan 17 19:07:21 vosztok kernel:  [mpage_readpage+66/85] mpage_readpage+0x42=
/0x55
Jan 17 19:07:21 vosztok kernel:  [<c0179fd1>] mpage_readpage+0x42/0x55
Jan 17 19:07:21 vosztok kernel:  [<e08b9658>] nilfs_get_block+0x0/0x1de [ni=
lfs2]
Jan 17 19:07:22 vosztok kernel:  [add_to_page_cache+159/185] add_to_page_ca=
che+0x9f/0xb9
Jan 17 19:07:22 vosztok kernel:  [<c013babd>] add_to_page_cache+0x9f/0xb9
Jan 17 19:07:22 vosztok kernel:  [lru_cache_add+78/102] lru_cache_add+0x4e/=
0x66
Jan 17 19:07:22 vosztok kernel:  [<c0141d20>] lru_cache_add+0x4e/0x66
Jan 17 19:07:22 vosztok kernel:  [add_to_page_cache_lru+34/40] add_to_page_=
cache_lru+0x22/0x28
Jan 17 19:07:22 vosztok kernel:  [<c013baf9>] add_to_page_cache_lru+0x22/0x=
28
Jan 17 19:07:22 vosztok kernel:  [read_cache_page_async+141/300] read_cache=
_page_async+0x8d/0x12c
Jan 17 19:07:22 vosztok kernel:  [<c013bb8c>] read_cache_page_async+0x8d/0x=
12c
Jan 17 19:07:22 vosztok kernel:  [<e08b9153>] nilfs_set_inode_flags+0x150/0=
x15c [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [read_cache_page+16/63] read_cache_page+0x=
10/0x3f
Jan 17 19:07:22 vosztok kernel:  [<c013d428>] read_cache_page+0x10/0x3f
Jan 17 19:07:22 vosztok kernel:  [<e08b9fe2>] nilfs_sync_file+0xae/0x336 [n=
ilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08bd210>] nilfs_get_page_block+0x97/0xb=
1 [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [_atomic_dec_and_lock+37/64] _atomic_dec_a=
nd_lock+0x25/0x40
Jan 17 19:07:22 vosztok kernel:  [<c02390e9>] _atomic_dec_and_lock+0x25/0x40
Jan 17 19:07:22 vosztok kernel:  [mntput_no_expire+17/133] mntput_no_expire=
+0x11/0x85
Jan 17 19:07:22 vosztok kernel:  [<c016a3e5>] mntput_no_expire+0x11/0x85
Jan 17 19:07:22 vosztok kernel:  [link_path_walk+165/175] link_path_walk+0x=
a5/0xaf
Jan 17 19:07:22 vosztok kernel:  [<c015fcaa>] link_path_walk+0xa5/0xaf
Jan 17 19:07:22 vosztok kernel:  [<e08ba2e5>] nilfs_find_entry+0x7b/0x196 [=
nilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08ba40d>] nilfs_inode_by_name+0xd/0x20 =
[nilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08bc464>] nilfs_load_super_block+0x16c/=
0x924 [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [lookup_hash+122/145] lookup_hash+0x7a/0x91
Jan 17 19:07:22 vosztok kernel:  [<c015e0fb>] lookup_hash+0x7a/0x91
Jan 17 19:07:22 vosztok kernel:  [open_namei+229/1347] open_namei+0xe5/0x543
Jan 17 19:07:22 vosztok kernel:  [<c0160b25>] open_namei+0xe5/0x543
Jan 17 19:07:22 vosztok kernel:  [d_rehash+69/91] d_rehash+0x45/0x5b
Jan 17 19:07:22 vosztok kernel:  [<c0165ca1>] d_rehash+0x45/0x5b
Jan 17 19:07:22 vosztok kernel:  [d_splice_alias+202/228] d_splice_alias+0x=
ca/0xe4
Jan 17 19:07:22 vosztok kernel:  [<c0167a1e>] d_splice_alias+0xca/0xe4
Jan 17 19:07:22 vosztok kernel:  [do_filp_open+37/57] do_filp_open+0x25/0x39
Jan 17 19:07:22 vosztok kernel:  [<c0156421>] do_filp_open+0x25/0x39
Jan 17 19:07:22 vosztok kernel:  [get_unused_fd_flags+186/215] get_unused_f=
d_flags+0xba/0xd7
Jan 17 19:07:22 vosztok kernel:  [<c01561a6>] get_unused_fd_flags+0xba/0xd7
Jan 17 19:07:22 vosztok kernel:  [do_sys_open+68/197] do_sys_open+0x44/0xc5
Jan 17 19:07:22 vosztok kernel:  [<c0156479>] do_sys_open+0x44/0xc5
Jan 17 19:07:22 vosztok kernel:  [sys_open+28/30] sys_open+0x1c/0x1e
Jan 17 19:07:22 vosztok kernel:  [<c0156533>] sys_open+0x1c/0x1e
Jan 17 19:07:22 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:22 vosztok kernel: wmaker        D 00000008     0 14412      1
Jan 17 19:07:22 vosztok kernel:        d5fd5c30 00000086 d50e1104 00000008 =
d6dde700 00000000 d5fd5c5c d5fd5c5c=20
Jan 17 19:07:22 vosztok kernel:        c13f0f20 d5fd5c38 c036c20c c013b86b =
c013b8a9 c036c98d d5fd5c5c 00000000=20
Jan 17 19:07:22 vosztok kernel:        d5fd5c78 00000000 c013b85d 00000002 =
c11e8fe0 00000000 00000001 d50e0fc0=20
Jan 17 19:07:22 vosztok kernel: Call Trace:
Jan 17 19:07:22 vosztok kernel:  [io_schedule+14/22] io_schedule+0xe/0x16
Jan 17 19:07:22 vosztok kernel:  [<c036c20c>] io_schedule+0xe/0x16
Jan 17 19:07:22 vosztok kernel:  [sync_page+0/65] sync_page+0x0/0x41
Jan 17 19:07:22 vosztok kernel:  [<c013b86b>] sync_page+0x0/0x41
Jan 17 19:07:22 vosztok kernel:  [sync_page+62/65] sync_page+0x3e/0x41
Jan 17 19:07:22 vosztok kernel:  [<c013b8a9>] sync_page+0x3e/0x41
Jan 17 19:07:22 vosztok kernel:  [__wait_on_bit_lock+42/81] __wait_on_bit_l=
ock+0x2a/0x51
Jan 17 19:07:22 vosztok kernel:  [<c036c98d>] __wait_on_bit_lock+0x2a/0x51
Jan 17 19:07:22 vosztok kernel:  [__lock_page+87/93] __lock_page+0x57/0x5d
Jan 17 19:07:22 vosztok kernel:  [<c013b85d>] __lock_page+0x57/0x5d
Jan 17 19:07:22 vosztok kernel:  [wake_bit_function+0/60] wake_bit_function=
+0x0/0x3c
Jan 17 19:07:22 vosztok kernel:  [<c0127868>] wake_bit_function+0x0/0x3c
Jan 17 19:07:22 vosztok kernel:  [<e08be7aa>] __nilfs_btnode_get+0x70/0x1bc=
 [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08bf7b6>] nilfs_bmap_get_block+0x25/0x2=
a [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08c059d>] nilfs_btree_init_gc+0x72a/0x1=
050 [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08c1817>] nilfs_btree_path_cache_destro=
y+0x66b/0x1e39 [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [alloc_page_buffers+110/180] alloc_page_bu=
ffers+0x6e/0xb4
Jan 17 19:07:22 vosztok kernel:  [<c017393f>] alloc_page_buffers+0x6e/0xb4
Jan 17 19:07:22 vosztok kernel:  [<e08bf6c6>] nilfs_bmap_lookup_at_level+0x=
33/0x81 [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08bf737>] nilfs_bmap_lookup+0x23/0x37 [=
nilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08bdd5d>] nilfs_mdt_mark_buffer_dirty+0=
x1aa/0x210 [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08bdde0>] nilfs_mdt_read_block+0x1d/0xb=
b [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08cfade>] nilfs_ifile_get_inode_block+0=
xea/0x13d [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08ba343>] nilfs_find_entry+0xd9/0x196 [=
nilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08b9c6b>] nilfs_read_inode+0x78/0x341 [=
nilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08bb0ff>] nilfs_alloc_inode+0xf/0x76 [n=
ilfs2]
Jan 17 19:07:22 vosztok kernel:  [iget_locked+199/312] iget_locked+0xc7/0x1=
38
Jan 17 19:07:22 vosztok kernel:  [<c01682bf>] iget_locked+0xc7/0x138
Jan 17 19:07:22 vosztok kernel:  [<e08bc493>] nilfs_load_super_block+0x19b/=
0x924 [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [do_lookup+163/320] do_lookup+0xa3/0x140
Jan 17 19:07:22 vosztok kernel:  [<c015df7e>] do_lookup+0xa3/0x140
Jan 17 19:07:22 vosztok kernel:  [__link_path_walk+805/3072] __link_path_wa=
lk+0x325/0xc00
Jan 17 19:07:22 vosztok kernel:  [<c015f32a>] __link_path_walk+0x325/0xc00
Jan 17 19:07:22 vosztok kernel:  [sock_aio_read+193/205] sock_aio_read+0xc1=
/0xcd
Jan 17 19:07:22 vosztok kernel:  [<c02ee670>] sock_aio_read+0xc1/0xcd
Jan 17 19:07:22 vosztok kernel:  [link_path_walk+66/175] link_path_walk+0x4=
2/0xaf
Jan 17 19:07:22 vosztok kernel:  [<c015fc47>] link_path_walk+0x42/0xaf
Jan 17 19:07:22 vosztok kernel:  [run_timer_softirq+361/388] run_timer_soft=
irq+0x169/0x184
Jan 17 19:07:22 vosztok kernel:  [<c011ecba>] run_timer_softirq+0x169/0x184
Jan 17 19:07:22 vosztok kernel:  [vfs_read+250/266] vfs_read+0xfa/0x10a
Jan 17 19:07:22 vosztok kernel:  [<c0157ed1>] vfs_read+0xfa/0x10a
Jan 17 19:07:22 vosztok kernel:  [do_path_lookup+411/438] do_path_lookup+0x=
19b/0x1b6
Jan 17 19:07:22 vosztok kernel:  [<c015ffbf>] do_path_lookup+0x19b/0x1b6
Jan 17 19:07:22 vosztok kernel:  [getname+89/143] getname+0x59/0x8f
Jan 17 19:07:22 vosztok kernel:  [<c015ece1>] getname+0x59/0x8f
Jan 17 19:07:22 vosztok kernel:  [__user_walk_fd+47/69] __user_walk_fd+0x2f=
/0x45
Jan 17 19:07:22 vosztok kernel:  [<c0160776>] __user_walk_fd+0x2f/0x45
Jan 17 19:07:22 vosztok kernel:  [sys_faccessat+153/301] sys_faccessat+0x99=
/0x12d
Jan 17 19:07:22 vosztok kernel:  [<c0156a47>] sys_faccessat+0x99/0x12d
Jan 17 19:07:22 vosztok kernel:  [run_timer_softirq+361/388] run_timer_soft=
irq+0x169/0x184
Jan 17 19:07:22 vosztok kernel:  [<c011ecba>] run_timer_softirq+0x169/0x184
Jan 17 19:07:22 vosztok kernel:  [vfs_read+250/266] vfs_read+0xfa/0x10a
Jan 17 19:07:22 vosztok kernel:  [<c0157ed1>] vfs_read+0xfa/0x10a
Jan 17 19:07:22 vosztok kernel:  [sys_access+31/35] sys_access+0x1f/0x23
Jan 17 19:07:22 vosztok kernel:  [<c0156afa>] sys_access+0x1f/0x23
Jan 17 19:07:22 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:22 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:22 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:22 vosztok kernel: wmsetbg       ? 00000287     0 14413  14412
Jan 17 19:07:22 vosztok kernel:        cb6c7e84 00000046 d50e0144 00000287 =
d4dafc40 c043ccfc cb6c7ea0 d50e0000=20
Jan 17 19:07:22 vosztok kernel:        00000010 d50e00e4 c011ad2c 0000000e =
00000000 d50e0494 bff50ddc 0000000f=20
Jan 17 19:07:22 vosztok kernel:        cb6c7ea0 cb6c7ea0 cfe57e00 0000000f =
0000000f cb6c7f10 c011ada9 ce80362c=20
Jan 17 19:07:22 vosztok kernel: Call Trace:
Jan 17 19:07:22 vosztok kernel:  [do_exit+1833/1837] do_exit+0x729/0x72d
Jan 17 19:07:22 vosztok kernel:  [<c011ad2c>] do_exit+0x729/0x72d
Jan 17 19:07:22 vosztok kernel:  [sys_exit_group+0/13] sys_exit_group+0x0/0=
xd
Jan 17 19:07:22 vosztok kernel:  [<c011ada9>] sys_exit_group+0x0/0xd
Jan 17 19:07:22 vosztok kernel:  [get_signal_to_deliver+1009/1054] get_sign=
al_to_deliver+0x3f1/0x41e
Jan 17 19:07:22 vosztok kernel:  [<c0121c20>] get_signal_to_deliver+0x3f1/0=
x41e
Jan 17 19:07:22 vosztok kernel:  [do_sync_read+198/265] do_sync_read+0xc6/0=
x109
Jan 17 19:07:22 vosztok kernel:  [<c01576e6>] do_sync_read+0xc6/0x109
Jan 17 19:07:22 vosztok kernel:  [do_notify_resume+129/1502] do_notify_resu=
me+0x81/0x5de
Jan 17 19:07:22 vosztok kernel:  [<c0103587>] do_notify_resume+0x81/0x5de
Jan 17 19:07:22 vosztok kernel:  [xfs_iflush_done+0/131] xfs_iflush_done+0x=
0/0x83
Jan 17 19:07:22 vosztok kernel:  [<c02004ab>] xfs_iflush_done+0x0/0x83
Jan 17 19:07:22 vosztok kernel:  [d_kill+55/70] d_kill+0x37/0x46
Jan 17 19:07:22 vosztok kernel:  [<c0165e28>] d_kill+0x37/0x46
Jan 17 19:07:22 vosztok kernel:  [d_kill+55/70] d_kill+0x37/0x46
Jan 17 19:07:22 vosztok kernel:  [<c0165e28>] d_kill+0x37/0x46
Jan 17 19:07:22 vosztok kernel:  [_atomic_dec_and_lock+37/64] _atomic_dec_a=
nd_lock+0x25/0x40
Jan 17 19:07:22 vosztok kernel:  [<c02390e9>] _atomic_dec_and_lock+0x25/0x40
Jan 17 19:07:22 vosztok kernel:  [do_sync_read+0/265] do_sync_read+0x0/0x109
Jan 17 19:07:22 vosztok kernel:  [<c0157620>] do_sync_read+0x0/0x109
Jan 17 19:07:22 vosztok kernel:  [vfs_read+136/266] vfs_read+0x88/0x10a
Jan 17 19:07:22 vosztok kernel:  [<c0157e5f>] vfs_read+0x88/0x10a
Jan 17 19:07:22 vosztok kernel:  [sys_read+65/103] sys_read+0x41/0x67
Jan 17 19:07:22 vosztok kernel:  [<c01581c6>] sys_read+0x41/0x67
Jan 17 19:07:22 vosztok kernel:  [work_notifysig+19/25] work_notifysig+0x13=
/0x19
Jan 17 19:07:22 vosztok kernel:  [<c0103e9a>] work_notifysig+0x13/0x19
Jan 17 19:07:22 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:22 vosztok kernel: epiphany      D c38dd300     0 14478  14412
Jan 17 19:07:22 vosztok kernel:        ced45d5c 00200086 c7ced104 c38dd300 =
cd3628c0 c7cecfc0 fffeffff df3b8c94=20
Jan 17 19:07:22 vosztok kernel:        00000000 c7cecfc0 c023bd30 ced45d80 =
c7cecfc0 df3b8c94 df3b8c00 00000000=20
Jan 17 19:07:22 vosztok kernel:        de9db2a0 c036d592 dc075d80 df3b8c98 =
c7cecfc0 00000001 df3b8c94 c036d5d3=20
Jan 17 19:07:22 vosztok kernel: Call Trace:
Jan 17 19:07:22 vosztok kernel:  [rwsem_down_failed_common+328/353] rwsem_d=
own_failed_common+0x148/0x161
Jan 17 19:07:22 vosztok kernel:  [<c023bd30>] rwsem_down_failed_common+0x14=
8/0x161
Jan 17 19:07:22 vosztok kernel:  [rwsem_down_read_failed+26/36] rwsem_down_=
read_failed+0x1a/0x24
Jan 17 19:07:22 vosztok kernel:  [<c036d592>] rwsem_down_read_failed+0x1a/0=
x24
Jan 17 19:07:22 vosztok kernel:  [call_rwsem_down_read_failed+7/12] call_rw=
sem_down_read_failed+0x7/0xc
Jan 17 19:07:22 vosztok kernel:  [<c036d5d3>] call_rwsem_down_read_failed+0=
x7/0xc
Jan 17 19:07:22 vosztok kernel:  [down_read+9/10] down_read+0x9/0xa
Jan 17 19:07:22 vosztok kernel:  [<c012a885>] down_read+0x9/0xa
Jan 17 19:07:22 vosztok kernel:  [<e08caf2c>] nilfs_transaction_begin+0xd4/=
0x150 [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08cafc6>] nilfs_dirty_inode+0x1e/0x40 [=
nilfs2]
Jan 17 19:07:22 vosztok kernel:  [__mark_inode_dirty+36/360] __mark_inode_d=
irty+0x24/0x168
Jan 17 19:07:22 vosztok kernel:  [<c01705db>] __mark_inode_dirty+0x24/0x168
Jan 17 19:07:22 vosztok kernel:  [current_fs_time+19/21] current_fs_time+0x=
13/0x15
Jan 17 19:07:22 vosztok kernel:  [<c011bae5>] current_fs_time+0x13/0x15
Jan 17 19:07:22 vosztok kernel:  [__generic_file_aio_write_nolock+864/1288]=
 __generic_file_aio_write_nolock+0x360/0x508
Jan 17 19:07:22 vosztok kernel:  [<c013d0ca>] __generic_file_aio_write_nolo=
ck+0x360/0x508
Jan 17 19:07:22 vosztok kernel:  [preempt_schedule+69/87] preempt_schedule+=
0x45/0x57
Jan 17 19:07:22 vosztok kernel:  [<c036c133>] preempt_schedule+0x45/0x57
Jan 17 19:07:22 vosztok kernel:  [generic_file_aio_write+82/176] generic_fi=
le_aio_write+0x52/0xb0
Jan 17 19:07:22 vosztok kernel:  [<c013d2c4>] generic_file_aio_write+0x52/0=
xb0
Jan 17 19:07:22 vosztok kernel:  [<e08b9ed2>] nilfs_read_inode+0x2df/0x341 =
[nilfs2]
Jan 17 19:07:22 vosztok kernel:  [do_sync_write+198/265] do_sync_write+0xc6=
/0x109
Jan 17 19:07:22 vosztok kernel:  [<c01575dd>] do_sync_write+0xc6/0x109
Jan 17 19:07:22 vosztok kernel:  [autoremove_wake_function+0/53] autoremove=
_wake_function+0x0/0x35
Jan 17 19:07:22 vosztok kernel:  [<c0127833>] autoremove_wake_function+0x0/=
0x35
Jan 17 19:07:22 vosztok kernel:  [unix_ioctl+169/177] unix_ioctl+0xa9/0xb1
Jan 17 19:07:22 vosztok kernel:  [<c03431d6>] unix_ioctl+0xa9/0xb1
Jan 17 19:07:22 vosztok kernel:  [sock_ioctl+415/446] sock_ioctl+0x19f/0x1be
Jan 17 19:07:22 vosztok kernel:  [<c02ee942>] sock_ioctl+0x19f/0x1be
Jan 17 19:07:22 vosztok kernel:  [sock_ioctl+0/446] sock_ioctl+0x0/0x1be
Jan 17 19:07:22 vosztok kernel:  [<c02ee7a3>] sock_ioctl+0x0/0x1be
Jan 17 19:07:22 vosztok kernel:  [do_sync_write+0/265] do_sync_write+0x0/0x=
109
Jan 17 19:07:22 vosztok kernel:  [vfs_write+138/268] vfs_write+0x8a/0x10c
Jan 17 19:07:22 vosztok kernel:  [<c0157d55>] vfs_write+0x8a/0x10c
Jan 17 19:07:22 vosztok kernel:  [sys_write+65/103] sys_write+0x41/0x67
Jan 17 19:07:22 vosztok kernel:  [<c015822d>] sys_write+0x41/0x67
Jan 17 19:07:22 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:22 vosztok kernel: cc1           D dbe29cd4     0 10269      1
Jan 17 19:07:22 vosztok kernel:        dbe29cd8 00200086 d07fe684 dbe29cd4 =
df0c5e00 c01279b8 dbe29ce8 c143bd38=20
Jan 17 19:07:22 vosztok kernel:        c13f0e70 c143bd38 c0167e39 c527cee4 =
00000003 00000000 d07fe540 c0127868=20
Jan 17 19:07:22 vosztok kernel:        c13f0e70 c13f0e70 019143eb de6d4a00 =
c0167e75 019143eb c143bd38 de6d4a00=20
Jan 17 19:07:22 vosztok kernel: Call Trace:
Jan 17 19:07:22 vosztok kernel:  [prepare_to_wait+74/102] prepare_to_wait+0=
x4a/0x66
Jan 17 19:07:22 vosztok kernel:  [<c01279b8>] prepare_to_wait+0x4a/0x66
Jan 17 19:07:22 vosztok kernel:  [__wait_on_freeing_inode+130/155] __wait_o=
n_freeing_inode+0x82/0x9b
Jan 17 19:07:22 vosztok kernel:  [<c0167e39>] __wait_on_freeing_inode+0x82/=
0x9b
Jan 17 19:07:22 vosztok kernel:  [wake_bit_function+0/60] wake_bit_function=
+0x0/0x3c
Jan 17 19:07:22 vosztok kernel:  [<c0127868>] wake_bit_function+0x0/0x3c
Jan 17 19:07:22 vosztok kernel:  [find_inode_fast+35/66] find_inode_fast+0x=
23/0x42
Jan 17 19:07:22 vosztok kernel:  [<c0167e75>] find_inode_fast+0x23/0x42
Jan 17 19:07:22 vosztok kernel:  [ifind_fast+33/151] ifind_fast+0x21/0x97
Jan 17 19:07:22 vosztok kernel:  [<c0167f0b>] ifind_fast+0x21/0x97
Jan 17 19:07:22 vosztok kernel:  [iget_locked+44/312] iget_locked+0x2c/0x138
Jan 17 19:07:22 vosztok kernel:  [<c0168224>] iget_locked+0x2c/0x138
Jan 17 19:07:22 vosztok kernel:  [xfs_iget+38/253] xfs_iget+0x26/0xfd
Jan 17 19:07:22 vosztok kernel:  [<c01fb449>] xfs_iget+0x26/0xfd
Jan 17 19:07:22 vosztok kernel:  [enqueue_entity+466/499] enqueue_entity+0x=
1d2/0x1f3
Jan 17 19:07:22 vosztok kernel:  [<c0113e13>] enqueue_entity+0x1d2/0x1f3
Jan 17 19:07:22 vosztok kernel:  [xfs_dir_lookup_int+125/212] xfs_dir_looku=
p_int+0x7d/0xd4
Jan 17 19:07:22 vosztok kernel:  [<c0212d71>] xfs_dir_lookup_int+0x7d/0xd4
Jan 17 19:07:22 vosztok kernel:  [xfs_lookup+82/120] xfs_lookup+0x52/0x78
Jan 17 19:07:22 vosztok kernel:  [<c0215b01>] xfs_lookup+0x52/0x78
Jan 17 19:07:22 vosztok kernel:  [xfs_vn_lookup+59/112] xfs_vn_lookup+0x3b/=
0x70
Jan 17 19:07:22 vosztok kernel:  [<c0222262>] xfs_vn_lookup+0x3b/0x70
Jan 17 19:07:22 vosztok kernel:  [do_lookup+163/320] do_lookup+0xa3/0x140
Jan 17 19:07:22 vosztok kernel:  [<c015df7e>] do_lookup+0xa3/0x140
Jan 17 19:07:22 vosztok kernel:  [__link_path_walk+2025/3072] __link_path_w=
alk+0x7e9/0xc00
Jan 17 19:07:22 vosztok kernel:  [<c015f7ee>] __link_path_walk+0x7e9/0xc00
Jan 17 19:07:22 vosztok kernel:  [__do_softirq+89/133] __do_softirq+0x59/0x=
85
Jan 17 19:07:22 vosztok kernel:  [<c011bede>] __do_softirq+0x59/0x85
Jan 17 19:07:22 vosztok kernel:  [link_path_walk+66/175] link_path_walk+0x4=
2/0xaf
Jan 17 19:07:22 vosztok kernel:  [<c015fc47>] link_path_walk+0x42/0xaf
Jan 17 19:07:22 vosztok kernel:  [lru_cache_add_active+78/100] lru_cache_ad=
d_active+0x4e/0x64
Jan 17 19:07:22 vosztok kernel:  [<c0141c09>] lru_cache_add_active+0x4e/0x64
Jan 17 19:07:22 vosztok kernel:  [do_path_lookup+411/438] do_path_lookup+0x=
19b/0x1b6
Jan 17 19:07:22 vosztok kernel:  [<c015ffbf>] do_path_lookup+0x19b/0x1b6
Jan 17 19:07:22 vosztok kernel:  [getname+89/143] getname+0x59/0x8f
Jan 17 19:07:22 vosztok kernel:  [<c015ece1>] getname+0x59/0x8f
Jan 17 19:07:22 vosztok kernel:  [__user_walk_fd+47/69] __user_walk_fd+0x2f=
/0x45
Jan 17 19:07:22 vosztok kernel:  [<c0160776>] __user_walk_fd+0x2f/0x45
Jan 17 19:07:22 vosztok kernel:  [vfs_stat_fd+25/64] vfs_stat_fd+0x19/0x40
Jan 17 19:07:22 vosztok kernel:  [<c015a5ec>] vfs_stat_fd+0x19/0x40
Jan 17 19:07:22 vosztok kernel:  [lru_cache_add_active+78/100] lru_cache_ad=
d_active+0x4e/0x64
Jan 17 19:07:22 vosztok kernel:  [<c0141c09>] lru_cache_add_active+0x4e/0x64
Jan 17 19:07:22 vosztok kernel:  [sys_stat64+15/35] sys_stat64+0xf/0x23
Jan 17 19:07:22 vosztok kernel:  [<c015a6a0>] sys_stat64+0xf/0x23
Jan 17 19:07:22 vosztok kernel:  [dput+204/314] dput+0xcc/0x13a
Jan 17 19:07:22 vosztok kernel:  [<c0165f03>] dput+0xcc/0x13a
Jan 17 19:07:22 vosztok kernel:  [__fput+308/350] __fput+0x134/0x15e
Jan 17 19:07:22 vosztok kernel:  [<c0158622>] __fput+0x134/0x15e
Jan 17 19:07:22 vosztok kernel:  [do_page_fault+0/1439] do_page_fault+0x0/0=
x59f
Jan 17 19:07:22 vosztok kernel:  [<c01123e1>] do_page_fault+0x0/0x59f
Jan 17 19:07:22 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:22 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:22 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:22 vosztok kernel: agetty        S 000001ff     0 10278      1
Jan 17 19:07:22 vosztok kernel:        dbdabee0 00000086 c2f36bc4 000001ff =
cd3621c0 00000000 d4df8c00 7fffffff=20
Jan 17 19:07:22 vosztok kernel:        dbdabf44 bfe65b6b c036c8bf c013f79f =
cd3621c4 00000246 c011831f ffffffb2=20
Jan 17 19:07:22 vosztok kernel:        bfe65b6b c0127a58 d4df8c00 d4df8c00 =
d4df8c00 c0250b30 00000082 df0fc600=20
Jan 17 19:07:22 vosztok kernel: Call Trace:
Jan 17 19:07:22 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 19:07:22 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 19:07:22 vosztok kernel:  [free_hot_cold_page+245/277] free_hot_cold=
_page+0xf5/0x115
Jan 17 19:07:22 vosztok kernel:  [<c013f79f>] free_hot_cold_page+0xf5/0x115
Jan 17 19:07:22 vosztok kernel:  [release_console_sem+404/447] release_cons=
ole_sem+0x194/0x1bf
Jan 17 19:07:22 vosztok kernel:  [<c011831f>] release_console_sem+0x194/0x1=
bf
Jan 17 19:07:22 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 19:07:22 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 19:07:22 vosztok kernel:  [read_chan+752/1324] read_chan+0x2f0/0x52c
Jan 17 19:07:22 vosztok kernel:  [<c0250b30>] read_chan+0x2f0/0x52c
Jan 17 19:07:22 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:07:22 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:07:22 vosztok kernel:  [read_chan+0/1324] read_chan+0x0/0x52c
Jan 17 19:07:22 vosztok kernel:  [<c0250840>] read_chan+0x0/0x52c
Jan 17 19:07:22 vosztok kernel:  [tty_read+100/172] tty_read+0x64/0xac
Jan 17 19:07:22 vosztok kernel:  [<c024dc05>] tty_read+0x64/0xac
Jan 17 19:07:22 vosztok kernel:  [tty_read+0/172] tty_read+0x0/0xac
Jan 17 19:07:22 vosztok kernel:  [<c024dba1>] tty_read+0x0/0xac
Jan 17 19:07:22 vosztok kernel:  [vfs_read+136/266] vfs_read+0x88/0x10a
Jan 17 19:07:22 vosztok kernel:  [<c0157e5f>] vfs_read+0x88/0x10a
Jan 17 19:07:22 vosztok kernel:  [sys_read+65/103] sys_read+0x41/0x67
Jan 17 19:07:22 vosztok kernel:  [<c01581c6>] sys_read+0x41/0x67
Jan 17 19:07:22 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:22 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:22 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:22 vosztok kernel: login         S 46be6018     0 10280      1
Jan 17 19:07:22 vosztok kernel:        db96bf48 00000082 c2f36684 46be6018 =
dbca1c40 00000000 ffffffff 00000001=20
Jan 17 19:07:22 vosztok kernel:        df41afc0 00000000 c011a464 46be6018 =
c2f36540 c0112649 00000001 00000004=20
Jan 17 19:07:22 vosztok kernel:        ffffffff c2f36540 00000001 00000001 =
00000000 c2f36624 00000007 db96bfb8=20
Jan 17 19:07:22 vosztok kernel: Call Trace:
Jan 17 19:07:22 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 19:07:22 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 19:07:22 vosztok kernel:  [do_page_fault+616/1439] do_page_fault+0x2=
68/0x59f
Jan 17 19:07:22 vosztok kernel:  [<c0112649>] do_page_fault+0x268/0x59f
Jan 17 19:07:22 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:07:22 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:07:22 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 19:07:22 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 19:07:22 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:22 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:22 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:22 vosztok kernel: login         S 46be6018     0 10281      1
Jan 17 19:07:22 vosztok kernel:        dc483f48 00000082 dd8debc4 46be6018 =
cd362540 00000000 ffffffff 00000001=20
Jan 17 19:07:22 vosztok kernel:        dd8dfa40 00000000 c011a464 46be6018 =
dd8dea80 c0112649 00000001 00000004=20
Jan 17 19:07:22 vosztok kernel:        ffffffff dd8dea80 00000001 00000001 =
00000000 dd8deb64 00000007 dc483fb8=20
Jan 17 19:07:22 vosztok kernel: Call Trace:
Jan 17 19:07:22 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 19:07:22 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 19:07:22 vosztok kernel:  [do_page_fault+616/1439] do_page_fault+0x2=
68/0x59f
Jan 17 19:07:22 vosztok kernel:  [<c0112649>] do_page_fault+0x268/0x59f
Jan 17 19:07:22 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:07:22 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:07:22 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 19:07:22 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 19:07:22 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:22 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:22 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:22 vosztok kernel: agetty        S 000001ff     0 10282      1
Jan 17 19:07:22 vosztok kernel:        d6dd3ee0 00000086 dd8df104 000001ff =
de12c700 00000000 dc36e400 7fffffff=20
Jan 17 19:07:22 vosztok kernel:        d6dd3f44 bfe40c0b c036c8bf c013f79f =
de12c704 00000246 c011831f ffffffb2=20
Jan 17 19:07:22 vosztok kernel:        bfe40c0b c0127a58 dc36e400 dc36e400 =
dc36e400 c0250b30 00000082 de655b00=20
Jan 17 19:07:22 vosztok kernel: Call Trace:
Jan 17 19:07:22 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 19:07:22 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 19:07:22 vosztok kernel:  [free_hot_cold_page+245/277] free_hot_cold=
_page+0xf5/0x115
Jan 17 19:07:22 vosztok kernel:  [release_console_sem+404/447] release_cons=
ole_sem+0x194/0x1bf
Jan 17 19:07:22 vosztok kernel:  [<c011831f>] release_console_sem+0x194/0x1=
bf
Jan 17 19:07:22 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 19:07:22 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 19:07:22 vosztok kernel:  [read_chan+752/1324] read_chan+0x2f0/0x52c
Jan 17 19:07:22 vosztok kernel:  [<c0250b30>] read_chan+0x2f0/0x52c
Jan 17 19:07:22 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:07:22 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:07:22 vosztok kernel:  [read_chan+0/1324] read_chan+0x0/0x52c
Jan 17 19:07:22 vosztok kernel:  [<c0250840>] read_chan+0x0/0x52c
Jan 17 19:07:22 vosztok kernel:  [tty_read+100/172] tty_read+0x64/0xac
Jan 17 19:07:22 vosztok kernel:  [<c024dc05>] tty_read+0x64/0xac
Jan 17 19:07:22 vosztok kernel:  [tty_read+0/172] tty_read+0x0/0xac
Jan 17 19:07:22 vosztok kernel:  [<c024dba1>] tty_read+0x0/0xac
Jan 17 19:07:22 vosztok kernel:  [vfs_read+136/266] vfs_read+0x88/0x10a
Jan 17 19:07:22 vosztok kernel:  [<c0157e5f>] vfs_read+0x88/0x10a
Jan 17 19:07:22 vosztok kernel:  [sys_read+65/103] sys_read+0x41/0x67
Jan 17 19:07:22 vosztok kernel:  [<c01581c6>] sys_read+0x41/0x67
Jan 17 19:07:22 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:22 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:22 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:22 vosztok kernel: login         S 46be6018     0 10283      1
Jan 17 19:07:22 vosztok kernel:        de8e1f48 00000086 c2f37b84 46be6018 =
de1ade00 00000000 ffffffff 00000001=20
Jan 17 19:07:22 vosztok kernel:        de1d5a40 00000000 c011a464 46be6018 =
c2f37a40 c0112649 00000001 00000004=20
Jan 17 19:07:22 vosztok kernel:        ffffffff c2f37a40 00000001 00000001 =
00000000 c2f37b24 00000007 de8e1fb8=20
Jan 17 19:07:22 vosztok kernel: Call Trace:
Jan 17 19:07:22 vosztok kernel:  [do_wait+2467/2690] do_wait+0x9a3/0xa82
Jan 17 19:07:22 vosztok kernel:  [<c011a464>] do_wait+0x9a3/0xa82
Jan 17 19:07:22 vosztok kernel:  [do_page_fault+616/1439] do_page_fault+0x2=
68/0x59f
Jan 17 19:07:22 vosztok kernel:  [<c0112649>] do_page_fault+0x268/0x59f
Jan 17 19:07:22 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:07:22 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:07:22 vosztok kernel:  [sys_wait4+49/52] sys_wait4+0x31/0x34
Jan 17 19:07:22 vosztok kernel:  [<c011a574>] sys_wait4+0x31/0x34
Jan 17 19:07:22 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:22 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:22 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:22 vosztok kernel: agetty        S 000001ff     0 10284      1
Jan 17 19:07:22 vosztok kernel:        cdccdee0 00000086 c1482144 000001ff =
de12ce00 00000000 d5f41800 7fffffff=20
Jan 17 19:07:22 vosztok kernel:        cdccdf44 bfbb2aab c036c8bf c013f79f =
de12ce04 00000246 c011831f ffffffb2=20
Jan 17 19:07:22 vosztok kernel:        bfbb2aab c0127a58 d5f41800 d5f41800 =
d5f41800 c0250b30 00000082 de655c00=20
Jan 17 19:07:22 vosztok kernel: Call Trace:
Jan 17 19:07:22 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 19:07:22 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 19:07:22 vosztok kernel:  [free_hot_cold_page+245/277] free_hot_cold=
_page+0xf5/0x115
Jan 17 19:07:22 vosztok kernel:  [<c013f79f>] free_hot_cold_page+0xf5/0x115
Jan 17 19:07:22 vosztok kernel:  [release_console_sem+404/447] release_cons=
ole_sem+0x194/0x1bf
Jan 17 19:07:22 vosztok kernel:  [<c011831f>] release_console_sem+0x194/0x1=
bf
Jan 17 19:07:22 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 19:07:22 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 19:07:22 vosztok kernel:  [read_chan+752/1324] read_chan+0x2f0/0x52c
Jan 17 19:07:22 vosztok kernel:  [<c0250b30>] read_chan+0x2f0/0x52c
Jan 17 19:07:22 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:07:22 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:07:22 vosztok kernel:  [read_chan+0/1324] read_chan+0x0/0x52c
Jan 17 19:07:22 vosztok kernel:  [<c0250840>] read_chan+0x0/0x52c
Jan 17 19:07:22 vosztok kernel:  [tty_read+100/172] tty_read+0x64/0xac
Jan 17 19:07:22 vosztok kernel:  [<c024dc05>] tty_read+0x64/0xac
Jan 17 19:07:22 vosztok kernel:  [tty_read+0/172] tty_read+0x0/0xac
Jan 17 19:07:22 vosztok kernel:  [<c024dba1>] tty_read+0x0/0xac
Jan 17 19:07:22 vosztok kernel:  [vfs_read+136/266] vfs_read+0x88/0x10a
Jan 17 19:07:22 vosztok kernel:  [<c0157e5f>] vfs_read+0x88/0x10a
Jan 17 19:07:22 vosztok kernel:  [sys_read+65/103] sys_read+0x41/0x67
Jan 17 19:07:22 vosztok kernel:  [<c01581c6>] sys_read+0x41/0x67
Jan 17 19:07:22 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:22 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:22 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:22 vosztok kernel: qingy         S bfa6f6b0     0 10841      1
Jan 17 19:07:22 vosztok kernel:        dba03f40 00000082 df41a684 bfa6f6b0 =
dbca1a80 00000000 dba03f58 00000001=20
Jan 17 19:07:22 vosztok kernel:        00000001 00000000 c036cd4c 00000001 =
00000000 bfa6f7b4 c012a09f de5f5901=20
Jan 17 19:07:22 vosztok kernel:        00000000 c0489e40 51faf0f7 0000031b =
c012a19b c041a6b4 00000001 00000002=20
Jan 17 19:07:22 vosztok kernel: Call Trace:
Jan 17 19:07:22 vosztok kernel:  [do_nanosleep+69/111] do_nanosleep+0x45/0x=
6f
Jan 17 19:07:22 vosztok kernel:  [<c036cd4c>] do_nanosleep+0x45/0x6f
Jan 17 19:07:22 vosztok kernel:  [hrtimer_nanosleep+57/220] hrtimer_nanosle=
ep+0x39/0xdc
Jan 17 19:07:22 vosztok kernel:  [<c012a09f>] hrtimer_nanosleep+0x39/0xdc
Jan 17 19:07:22 vosztok kernel:  [hrtimer_wakeup+0/24] hrtimer_wakeup+0x0/0=
x18
Jan 17 19:07:22 vosztok kernel:  [<c012a19b>] hrtimer_wakeup+0x0/0x18
Jan 17 19:07:22 vosztok kernel:  [sys_nanosleep+73/89] sys_nanosleep+0x49/0=
x59
Jan 17 19:07:22 vosztok kernel:  [<c012a18b>] sys_nanosleep+0x49/0x59
Jan 17 19:07:22 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:22 vosztok kernel: bash          S 00000000     0 10842  10280
Jan 17 19:07:22 vosztok kernel:        dc6efee0 00000082 df41b104 00000000 =
dbca1380 c0269176 dec90400 7fffffff=20
Jan 17 19:07:22 vosztok kernel:        dc6eff44 bfc7e633 c036c8bf 00000000 =
00000000 df40b808 df40b8a8 00000e20=20
Jan 17 19:07:22 vosztok kernel:        bfc7e633 c0127a58 dec90400 dec90400 =
dec90400 c0250b30 00000001 d5652980=20
Jan 17 19:07:22 vosztok kernel: Call Trace:
Jan 17 19:07:22 vosztok kernel:  [fbcon_cursor+585/618] fbcon_cursor+0x249/=
0x26a
Jan 17 19:07:22 vosztok kernel:  [<c0269176>] fbcon_cursor+0x249/0x26a
Jan 17 19:07:22 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 19:07:22 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 19:07:22 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 19:07:22 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 19:07:22 vosztok kernel:  [read_chan+752/1324] read_chan+0x2f0/0x52c
Jan 17 19:07:22 vosztok kernel:  [<c0250b30>] read_chan+0x2f0/0x52c
Jan 17 19:07:22 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:07:22 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:07:22 vosztok kernel:  [read_chan+0/1324] read_chan+0x0/0x52c
Jan 17 19:07:22 vosztok kernel:  [<c0250840>] read_chan+0x0/0x52c
Jan 17 19:07:22 vosztok kernel:  [tty_read+100/172] tty_read+0x64/0xac
Jan 17 19:07:22 vosztok kernel:  [<c024dc05>] tty_read+0x64/0xac
Jan 17 19:07:22 vosztok kernel:  [tty_read+0/172] tty_read+0x0/0xac
Jan 17 19:07:22 vosztok kernel:  [<c024dba1>] tty_read+0x0/0xac
Jan 17 19:07:22 vosztok kernel:  [vfs_read+136/266] vfs_read+0x88/0x10a
Jan 17 19:07:22 vosztok kernel:  [<c0157e5f>] vfs_read+0x88/0x10a
Jan 17 19:07:22 vosztok kernel:  [sys_read+65/103] sys_read+0x41/0x67
Jan 17 19:07:22 vosztok kernel:  [<c01581c6>] sys_read+0x41/0x67
Jan 17 19:07:22 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:22 vosztok kernel: bash          D c02aed9d     0 10849  10281
Jan 17 19:07:22 vosztok kernel:        df56bbf8 00000082 dd8dfb84 c02aed9d =
dbca1540 00000000 df56bc24 df56bc24=20
Jan 17 19:07:22 vosztok kernel:        c13f0f20 df56bc00 c036c20c c013b86b =
c013b8a9 c036c98d df56bc24 00000000=20
Jan 17 19:07:22 vosztok kernel:        df56bc40 00000000 c013b85d 00000002 =
c11e8fe0 00000000 00000001 dd8dfa40=20
Jan 17 19:07:22 vosztok kernel: Call Trace:
Jan 17 19:07:22 vosztok kernel:  [scsi_dispatch_cmd+390/462] scsi_dispatch_=
cmd+0x186/0x1ce
Jan 17 19:07:22 vosztok kernel:  [<c02aed9d>] scsi_dispatch_cmd+0x186/0x1ce
Jan 17 19:07:22 vosztok kernel:  [io_schedule+14/22] io_schedule+0xe/0x16
Jan 17 19:07:22 vosztok kernel:  [<c036c20c>] io_schedule+0xe/0x16
Jan 17 19:07:22 vosztok kernel:  [sync_page+0/65] sync_page+0x0/0x41
Jan 17 19:07:22 vosztok kernel:  [<c013b86b>] sync_page+0x0/0x41
Jan 17 19:07:22 vosztok kernel:  [sync_page+62/65] sync_page+0x3e/0x41
Jan 17 19:07:22 vosztok kernel:  [<c013b8a9>] sync_page+0x3e/0x41
Jan 17 19:07:22 vosztok kernel:  [__wait_on_bit_lock+42/81] __wait_on_bit_l=
ock+0x2a/0x51
Jan 17 19:07:22 vosztok kernel:  [<c036c98d>] __wait_on_bit_lock+0x2a/0x51
Jan 17 19:07:22 vosztok kernel:  [__lock_page+87/93] __lock_page+0x57/0x5d
Jan 17 19:07:22 vosztok kernel:  [<c013b85d>] __lock_page+0x57/0x5d
Jan 17 19:07:22 vosztok kernel:  [wake_bit_function+0/60] wake_bit_function=
+0x0/0x3c
Jan 17 19:07:22 vosztok kernel:  [<c0127868>] wake_bit_function+0x0/0x3c
Jan 17 19:07:22 vosztok kernel:  [<e08be7aa>] __nilfs_btnode_get+0x70/0x1bc=
 [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08bf7b6>] nilfs_bmap_get_block+0x25/0x2=
a [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08c059d>] nilfs_btree_init_gc+0x72a/0x1=
050 [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08c1817>] nilfs_btree_path_cache_destro=
y+0x66b/0x1e39 [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [alloc_page_buffers+110/180] alloc_page_bu=
ffers+0x6e/0xb4
Jan 17 19:07:22 vosztok kernel:  [<c017393f>] alloc_page_buffers+0x6e/0xb4
Jan 17 19:07:22 vosztok kernel:  [<e08bf6c6>] nilfs_bmap_lookup_at_level+0x=
33/0x81 [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08bf737>] nilfs_bmap_lookup+0x23/0x37 [=
nilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08bdd5d>] nilfs_mdt_mark_buffer_dirty+0=
x1aa/0x210 [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08bdde0>] nilfs_mdt_read_block+0x1d/0xb=
b [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [xfs_buf_iowait+50/59] xfs_buf_iowait+0x32=
/0x3b
Jan 17 19:07:22 vosztok kernel:  [<c021dfa7>] xfs_buf_iowait+0x32/0x3b
Jan 17 19:07:22 vosztok kernel:  [<e08cfade>] nilfs_ifile_get_inode_block+0=
xea/0x13d [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [__slab_alloc+922/1060] __slab_alloc+0x39a=
/0x424
Jan 17 19:07:22 vosztok kernel:  [<c0154927>] __slab_alloc+0x39a/0x424
Jan 17 19:07:22 vosztok kernel:  [<e08b9c6b>] nilfs_read_inode+0x78/0x341 [=
nilfs2]
Jan 17 19:07:22 vosztok kernel:  [<e08bb0ff>] nilfs_alloc_inode+0xf/0x76 [n=
ilfs2]
Jan 17 19:07:22 vosztok kernel:  [iget_locked+199/312] iget_locked+0xc7/0x1=
38
Jan 17 19:07:22 vosztok kernel:  [<c01682bf>] iget_locked+0xc7/0x138
Jan 17 19:07:22 vosztok kernel:  [<e08bc493>] nilfs_load_super_block+0x19b/=
0x924 [nilfs2]
Jan 17 19:07:22 vosztok kernel:  [do_lookup+163/320] do_lookup+0xa3/0x140
Jan 17 19:07:22 vosztok kernel:  [<c015df7e>] do_lookup+0xa3/0x140
Jan 17 19:07:22 vosztok kernel:  [__link_path_walk+2025/3072] __link_path_w=
alk+0x7e9/0xc00
Jan 17 19:07:22 vosztok kernel:  [<c015f7ee>] __link_path_walk+0x7e9/0xc00
Jan 17 19:07:22 vosztok kernel:  [xfs_da_brelse+107/143] xfs_da_brelse+0x6b=
/0x8f
Jan 17 19:07:22 vosztok kernel:  [<c01e8c5c>] xfs_da_brelse+0x6b/0x8f
Jan 17 19:07:22 vosztok kernel:  [link_path_walk+66/175] link_path_walk+0x4=
2/0xaf
Jan 17 19:07:22 vosztok kernel:  [<c015fc47>] link_path_walk+0x42/0xaf
Jan 17 19:07:22 vosztok kernel:  [do_path_lookup+411/438] do_path_lookup+0x=
19b/0x1b6
Jan 17 19:07:22 vosztok kernel:  [<c015ffbf>] do_path_lookup+0x19b/0x1b6
Jan 17 19:07:22 vosztok kernel:  [getname+89/143] getname+0x59/0x8f
Jan 17 19:07:22 vosztok kernel:  [<c015ece1>] getname+0x59/0x8f
Jan 17 19:07:22 vosztok kernel:  [__user_walk_fd+47/69] __user_walk_fd+0x2f=
/0x45
Jan 17 19:07:22 vosztok kernel:  [<c0160776>] __user_walk_fd+0x2f/0x45
Jan 17 19:07:22 vosztok kernel:  [vfs_stat_fd+25/64] vfs_stat_fd+0x19/0x40
Jan 17 19:07:22 vosztok kernel:  [<c015a5ec>] vfs_stat_fd+0x19/0x40
Jan 17 19:07:22 vosztok kernel:  [sys_stat64+15/35] sys_stat64+0xf/0x23
Jan 17 19:07:22 vosztok kernel:  [<c015a6a0>] sys_stat64+0xf/0x23
Jan 17 19:07:22 vosztok kernel:  [__slab_free+414/670] __slab_free+0x19e/0x=
29e
Jan 17 19:07:22 vosztok kernel:  [<c01541ed>] __slab_free+0x19e/0x29e
Jan 17 19:07:22 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:22 vosztok kernel: bash          D 1a877801     0 10854  10283
Jan 17 19:07:22 vosztok kernel:        dbd3ff54 00000086 de1d5b84 1a877801 =
de1ad000 1a877801 dc66811c de1d5a40=20
Jan 17 19:07:22 vosztok kernel:        fffffffe dc66811c c036ccbe dc668120 =
dc668120 de1d5a40 dc6680b4 cfe01200=20
Jan 17 19:07:22 vosztok kernel:        c036cae9 c0162010 dbd3ff94 c0161e60 =
fffffff7 080fa284 00000000 cfe01200=20
Jan 17 19:07:22 vosztok kernel: Call Trace:
Jan 17 19:07:22 vosztok kernel:  [__mutex_lock_slowpath+101/174] __mutex_lo=
ck_slowpath+0x65/0xae
Jan 17 19:07:22 vosztok kernel:  [<c036ccbe>] __mutex_lock_slowpath+0x65/0x=
ae
Jan 17 19:07:22 vosztok kernel:  [mutex_lock+9/10] mutex_lock+0x9/0xa
Jan 17 19:07:22 vosztok kernel:  [<c036cae9>] mutex_lock+0x9/0xa
Jan 17 19:07:22 vosztok kernel:  [vfs_readdir+50/116] vfs_readdir+0x32/0x74
Jan 17 19:07:22 vosztok kernel:  [<c0162010>] vfs_readdir+0x32/0x74
Jan 17 19:07:22 vosztok kernel:  [filldir64+0/197] filldir64+0x0/0xc5
Jan 17 19:07:22 vosztok kernel:  [<c0161e60>] filldir64+0x0/0xc5
Jan 17 19:07:22 vosztok kernel:  [sys_getdents64+99/165] sys_getdents64+0x6=
3/0xa5
Jan 17 19:07:22 vosztok kernel:  [<c01620b5>] sys_getdents64+0x63/0xa5
Jan 17 19:07:22 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [ip6_frag_expire+358/378] ip6_frag_expire+=
0x166/0x17a
Jan 17 19:07:22 vosztok kernel:  [<c0360000>] ip6_frag_expire+0x166/0x17a
Jan 17 19:07:22 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:22 vosztok kernel: syslogd       S 00000001     0 10964      1
Jan 17 19:07:22 vosztok kernel:        de955b60 00000086 de1d4144 00000001 =
de5f51c0 c0390780 00000000 7fffffff=20
Jan 17 19:07:22 vosztok kernel:        00000001 00000001 c036c8bf 00000001 =
c0127a58 deb62d80 de955be0 00000000=20
Jan 17 19:07:22 vosztok kernel:        c02f5e19 c0390780 d25b7380 00000000 =
de955f9c c0162a11 de955f9c de955f48=20
Jan 17 19:07:22 vosztok kernel: Call Trace:
Jan 17 19:07:22 vosztok kernel:  [schedule_timeout+19/149] schedule_timeout=
+0x13/0x95
Jan 17 19:07:22 vosztok kernel:  [<c036c8bf>] schedule_timeout+0x13/0x95
Jan 17 19:07:22 vosztok kernel:  [add_wait_queue+51/77] add_wait_queue+0x33=
/0x4d
Jan 17 19:07:22 vosztok kernel:  [<c0127a58>] add_wait_queue+0x33/0x4d
Jan 17 19:07:22 vosztok kernel:  [datagram_poll+20/176] datagram_poll+0x14/=
0xb0
Jan 17 19:07:22 vosztok kernel:  [<c02f5e19>] datagram_poll+0x14/0xb0
Jan 17 19:07:22 vosztok kernel:  [do_select+916/993] do_select+0x394/0x3e1
Jan 17 19:07:22 vosztok kernel:  [<c0162a11>] do_select+0x394/0x3e1
Jan 17 19:07:22 vosztok kernel:  [__pollwait+0/169] __pollwait+0x0/0xa9
Jan 17 19:07:22 vosztok kernel:  [<c0162f31>] __pollwait+0x0/0xa9
Jan 17 19:07:22 vosztok kernel:  [default_wake_function+0/12] default_wake_=
function+0x0/0xc
Jan 17 19:07:22 vosztok kernel:  [<c0114c20>] default_wake_function+0x0/0xc
Jan 17 19:07:22 vosztok kernel:  [__check_preempt_curr_fair+81/126] __check=
_preempt_curr_fair+0x51/0x7e
Jan 17 19:07:22 vosztok kernel:  [<c01137d0>] __check_preempt_curr_fair+0x5=
1/0x7e
Jan 17 19:07:22 vosztok kernel:  [pit_next_event+62/68] pit_next_event+0x3e=
/0x44
Jan 17 19:07:22 vosztok kernel:  [<c0108e42>] pit_next_event+0x3e/0x44
Jan 17 19:07:22 vosztok kernel:  [clockevents_program_event+156/163] clocke=
vents_program_event+0x9c/0xa3
Jan 17 19:07:22 vosztok kernel:  [<c012d96e>] clockevents_program_event+0x9=
c/0xa3
Jan 17 19:07:22 vosztok kernel:  [update_curr+267/309] update_curr+0x10b/0x=
135
Jan 17 19:07:22 vosztok kernel:  [<c0113b07>] update_curr+0x10b/0x135
Jan 17 19:07:22 vosztok kernel:  [balance_dirty_pages_ratelimited_nr+338/42=
4] balance_dirty_pages_ratelimited_nr+0x152/0x1a8
Jan 17 19:07:22 vosztok kernel:  [<c0140808>] balance_dirty_pages_ratelimit=
ed_nr+0x152/0x1a8
Jan 17 19:07:22 vosztok kernel:  [generic_file_buffered_write+1296/1570] ge=
neric_file_buffered_write+0x510/0x622
Jan 17 19:07:22 vosztok kernel:  [<c013cc58>] generic_file_buffered_write+0=
x510/0x622
Jan 17 19:07:22 vosztok kernel:  [unix_dgram_recvmsg+511/531] unix_dgram_re=
cvmsg+0x1ff/0x213
Jan 17 19:07:22 vosztok kernel:  [<c0343685>] unix_dgram_recvmsg+0x1ff/0x213
Jan 17 19:07:22 vosztok kernel:  [xfs_ilock+71/103] xfs_ilock+0x47/0x67
Jan 17 19:07:22 vosztok kernel:  [<c01fa71a>] xfs_ilock+0x47/0x67
Jan 17 19:07:22 vosztok kernel:  [xfs_iunlock+35/109] xfs_iunlock+0x23/0x6d
Jan 17 19:07:22 vosztok kernel:  [<c01fa684>] xfs_iunlock+0x23/0x6d
Jan 17 19:07:22 vosztok kernel:  [xfs_write+2604/2651] xfs_write+0xa2c/0xa5b
Jan 17 19:07:22 vosztok kernel:  [<c0223dd6>] xfs_write+0xa2c/0xa5b
Jan 17 19:07:22 vosztok kernel:  [memmove+14/34] memmove+0xe/0x22
Jan 17 19:07:22 vosztok kernel:  [<c023d576>] memmove+0xe/0x22
Jan 17 19:07:22 vosztok kernel:  [scrup+156/204] scrup+0x9c/0xcc
Jan 17 19:07:22 vosztok kernel:  [<c0256fa9>] scrup+0x9c/0xcc
Jan 17 19:07:22 vosztok kernel:  [release_console_sem+404/447] release_cons=
ole_sem+0x194/0x1bf
Jan 17 19:07:22 vosztok kernel:  [<c011831f>] release_console_sem+0x194/0x1=
bf
Jan 17 19:07:22 vosztok kernel:  [do_con_write+5900/5986] do_con_write+0x17=
0c/0x1762
Jan 17 19:07:22 vosztok kernel:  [<c025a0c1>] do_con_write+0x170c/0x1762
Jan 17 19:07:22 vosztok kernel:  [core_sys_select+682/711] core_sys_select+=
0x2aa/0x2c7
Jan 17 19:07:22 vosztok kernel:  [<c0162d08>] core_sys_select+0x2aa/0x2c7
Jan 17 19:07:22 vosztok kernel:  [__wake_up+69/103] __wake_up+0x45/0x67
Jan 17 19:07:22 vosztok kernel:  [<c01152e7>] __wake_up+0x45/0x67
Jan 17 19:07:22 vosztok kernel:  [tty_ldisc_deref+98/124] tty_ldisc_deref+0=
x62/0x7c
Jan 17 19:07:22 vosztok kernel:  [<c024bacf>] tty_ldisc_deref+0x62/0x7c
Jan 17 19:07:22 vosztok kernel:  [tty_write+429/446] tty_write+0x1ad/0x1be
Jan 17 19:07:22 vosztok kernel:  [<c024d528>] tty_write+0x1ad/0x1be
Jan 17 19:07:22 vosztok kernel:  [write_chan+0/649] write_chan+0x0/0x289
Jan 17 19:07:22 vosztok kernel:  [<c024f71a>] write_chan+0x0/0x289
Jan 17 19:07:22 vosztok kernel:  [do_loop_readv_writev+41/76] do_loop_readv=
_writev+0x29/0x4c
Jan 17 19:07:22 vosztok kernel:  [<c0157321>] do_loop_readv_writev+0x29/0x4c
Jan 17 19:07:22 vosztok kernel:  [do_readv_writev+346/356] do_readv_writev+=
0x15a/0x164
Jan 17 19:07:22 vosztok kernel:  [<c0157c34>] do_readv_writev+0x15a/0x164
Jan 17 19:07:22 vosztok kernel:  [sys_select+213/391] sys_select+0xd5/0x187
Jan 17 19:07:22 vosztok kernel:  [<c01630af>] sys_select+0xd5/0x187
Jan 17 19:07:22 vosztok kernel:  [sigprocmask+157/182] sigprocmask+0x9d/0xb6
Jan 17 19:07:22 vosztok kernel:  [<c011f828>] sigprocmask+0x9d/0xb6
Jan 17 19:07:22 vosztok kernel:  [sys_rt_sigprocmask+71/186] sys_rt_sigproc=
mask+0x47/0xba
Jan 17 19:07:22 vosztok kernel:  [<c0121c94>] sys_rt_sigprocmask+0x47/0xba
Jan 17 19:07:22 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:22 vosztok kernel: klogd         R running      0 10974      1
Jan 17 19:07:22 vosztok kernel: atd           S 00000000     0 11027      1
Jan 17 19:07:22 vosztok kernel:        dbcdff40 00000086 df41bb84 00000000 =
de12c8c0 00000000 dbcdff58 00000001=20
Jan 17 19:07:22 vosztok kernel:        00000001 bf97fbc4 c036cd4c 00000001 =
00000000 bf97fbc4 c012a09f de5f5901=20
Jan 17 19:07:22 vosztok kernel:        00000000 00000000 aaa3923e 00000660 =
c012a19b c041a6b4 00000001 00000002=20
Jan 17 19:07:22 vosztok kernel: Call Trace:
Jan 17 19:07:22 vosztok kernel:  [do_nanosleep+69/111] do_nanosleep+0x45/0x=
6f
Jan 17 19:07:22 vosztok kernel:  [<c036cd4c>] do_nanosleep+0x45/0x6f
Jan 17 19:07:22 vosztok kernel:  [hrtimer_nanosleep+57/220] hrtimer_nanosle=
ep+0x39/0xdc
Jan 17 19:07:22 vosztok kernel:  [<c012a09f>] hrtimer_nanosleep+0x39/0xdc
Jan 17 19:07:22 vosztok kernel:  [hrtimer_wakeup+0/24] hrtimer_wakeup+0x0/0=
x18
Jan 17 19:07:22 vosztok kernel:  [<c012a19b>] hrtimer_wakeup+0x0/0x18
Jan 17 19:07:22 vosztok kernel:  [sigprocmask+157/182] sigprocmask+0x9d/0xb6
Jan 17 19:07:22 vosztok kernel:  [<c011f828>] sigprocmask+0x9d/0xb6
Jan 17 19:07:22 vosztok kernel:  [sys_nanosleep+73/89] sys_nanosleep+0x49/0=
x59
Jan 17 19:07:22 vosztok kernel:  [<c012a18b>] sys_nanosleep+0x49/0x59
Jan 17 19:07:22 vosztok kernel:  [sysenter_past_esp+95/133] sysenter_past_e=
sp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  [<c0103d96>] sysenter_past_esp+0x5f/0x85
Jan 17 19:07:22 vosztok kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jan 17 19:07:33 vosztok kernel: SysRq : Emergency Sync
Jan 17 19:42:04 vosztok kernel: klogd 1.4.1, log source =3D /proc/kmsg star=
ted.
Jan 17 19:42:04 vosztok kernel: Inspecting /boot/System.map
Jan 17 19:42:04 vosztok kernel: Loaded 28989 symbols from /boot/System.map.
Jan 17 19:42:04 vosztok kernel: Symbols match kernel version 2.6.23.
Jan 17 19:42:04 vosztok kernel: Linux version 2.6.23-gentoo-r5 (root@voszto=
k) (gcc version 4.1.2 (Gentoo 4.1.2)) #1 PREEMPT Thu Jan 17 14:05:39 CET 20=
08
Jan 17 19:42:04 vosztok kernel: BIOS-provided physical RAM map:
Jan 17 19:42:04 vosztok kernel:  BIOS-e820: 0000000000000000 - 000000000009=
f000 (usable)
Jan 17 19:42:04 vosztok kernel:  BIOS-e820: 000000000009f000 - 00000000000a=
0000 (reserved)
Jan 17 19:42:04 vosztok kernel:  BIOS-e820: 00000000000dc000 - 000000000010=
0000 (reserved)
Jan 17 19:42:04 vosztok kernel:  BIOS-e820: 0000000000100000 - 000000001f6e=
0000 (usable)
Jan 17 19:42:04 vosztok kernel:  BIOS-e820: 000000001f6e0000 - 000000001f6f=
7000 (ACPI data)
Jan 17 19:42:04 vosztok kernel:  BIOS-e820: 000000001f6f7000 - 000000001f6f=
9000 (ACPI NVS)
Jan 17 19:42:04 vosztok kernel:  BIOS-e820: 000000001f700000 - 000000002000=
0000 (reserved)
Jan 17 19:42:04 vosztok kernel:  BIOS-e820: 00000000ff800000 - 000000010000=
0000 (reserved)
Jan 17 19:42:04 vosztok kernel: 502MB LOWMEM available.
Jan 17 19:42:04 vosztok kernel: Entering add_active_range(0, 0, 128736) 0 e=
ntries of 256 used
Jan 17 19:42:04 vosztok kernel: Zone PFN ranges:
Jan 17 19:42:04 vosztok kernel:   DMA             0 ->     4096
Jan 17 19:42:04 vosztok kernel:   Normal       4096 ->   128736
Jan 17 19:42:04 vosztok kernel: Movable zone start PFN for each node
Jan 17 19:42:04 vosztok kernel: early_node_map[1] active PFN ranges
Jan 17 19:42:04 vosztok kernel:     0:        0 ->   128736
Jan 17 19:42:04 vosztok kernel: On node 0 totalpages: 128736
Jan 17 19:42:04 vosztok kernel:   DMA zone: 32 pages used for memmap
Jan 17 19:42:04 vosztok kernel:   DMA zone: 0 pages reserved
Jan 17 19:42:04 vosztok kernel:   DMA zone: 4064 pages, LIFO batch:0
Jan 17 19:42:04 vosztok kernel:   Normal zone: 973 pages used for memmap
Jan 17 19:42:04 vosztok kernel:   Normal zone: 123667 pages, LIFO batch:31
Jan 17 19:42:04 vosztok kernel:   Movable zone: 0 pages used for memmap
Jan 17 19:42:04 vosztok kernel: DMI present.
Jan 17 19:42:04 vosztok kernel: ACPI: RSDP 000F6E40, 0024 (r2 IBM   )
Jan 17 19:42:04 vosztok kernel: ACPI: XSDT 1F6EF33D, 004C (r1 IBM    TP-1W =
       2050  LTP        0)
Jan 17 19:42:04 vosztok kernel: ACPI: FACP 1F6EF400, 00F4 (r3 IBM    TP-1W =
       2050 IBM         1)
Jan 17 19:42:04 vosztok kernel: ACPI Warning (tbfadt-0442): Optional field =
"Gpe1Block" has zero address or length: 000000000000102C/0 [20070126]
Jan 17 19:42:04 vosztok kernel: ACPI: DSDT 1F6EF5E7, 7865 (r1 IBM    TP-1W =
       2050 MSFT  100000E)
Jan 17 19:42:04 vosztok kernel: ACPI: FACS 1F6F8000, 0040
Jan 17 19:42:04 vosztok kernel: ACPI: SSDT 1F6EF5B4, 0033 (r1 IBM    TP-1W =
       2050 MSFT  100000E)
Jan 17 19:42:04 vosztok kernel: ACPI: ECDT 1F6F6E4C, 0052 (r1 IBM    TP-1W =
       2050 IBM         1)
Jan 17 19:42:04 vosztok kernel: ACPI: TCPA 1F6F6E9E, 0032 (r1 IBM    TP-1W =
       2050 PTL         1)
Jan 17 19:42:04 vosztok kernel: ACPI: BOOT 1F6F6FD8, 0028 (r1 IBM    TP-1W =
       2050  LTP        1)
Jan 17 19:42:04 vosztok kernel: ACPI: PM-Timer IO Port: 0x1008
Jan 17 19:42:04 vosztok kernel: Allocating PCI resources starting at 300000=
00 (gap: 20000000:df800000)
Jan 17 19:42:04 vosztok kernel: swsusp: Registered nosave memory region: 00=
0000000009f000 - 00000000000a0000
Jan 17 19:42:04 vosztok kernel: swsusp: Registered nosave memory region: 00=
000000000a0000 - 00000000000dc000
Jan 17 19:42:04 vosztok kernel: swsusp: Registered nosave memory region: 00=
000000000dc000 - 0000000000100000
Jan 17 19:42:04 vosztok kernel: Built 1 zonelists in Zone order.  Total pag=
es: 127731
Jan 17 19:42:04 vosztok kernel: Kernel command line: dolvm real_root=3DLABE=
L=3Dvosztok-root vga=3D792 nolapic CONSOLE=3D/dev/tty1 splash=3Dsilent,fade=
in,theme:livecd-2006.1,tty:12 quiet=20
Jan 17 19:42:04 vosztok kernel: mapped APIC to ffffb000 (013f3000)
Jan 17 19:42:04 vosztok kernel: Enabling fast FPU save and restore... done.
Jan 17 19:42:04 vosztok kernel: Enabling unmasked SIMD FPU exception suppor=
t... done.
Jan 17 19:42:04 vosztok kernel: Initializing CPU#0
Jan 17 19:42:04 vosztok kernel: PID hash table entries: 2048 (order: 11, 81=
92 bytes)
Jan 17 19:42:04 vosztok kernel: Detected 1598.701 MHz processor.
Jan 17 19:42:04 vosztok kernel: Console: colour dummy device 80x25
Jan 17 19:42:04 vosztok kernel: console [tty0] enabled
Jan 17 19:42:04 vosztok kernel: Dentry cache hash table entries: 65536 (ord=
er: 6, 262144 bytes)
Jan 17 19:42:04 vosztok kernel: Inode-cache hash table entries: 32768 (orde=
r: 5, 131072 bytes)
Jan 17 19:42:04 vosztok kernel: Memory: 504308k/514944k available (2489k ke=
rnel code, 10096k reserved, 836k data, 192k init, 0k highmem)
Jan 17 19:42:04 vosztok kernel: virtual kernel memory layout:
Jan 17 19:42:04 vosztok kernel:     fixmap  : 0xfffb5000 - 0xfffff000   ( 2=
96 kB)
Jan 17 19:42:04 vosztok kernel:     vmalloc : 0xe0000000 - 0xfffb3000   ( 5=
11 MB)
Jan 17 19:42:04 vosztok kernel:     lowmem  : 0xc0000000 - 0xdf6e0000   ( 5=
02 MB)
Jan 17 19:42:04 vosztok kernel:       .init : 0xc0442000 - 0xc0472000   ( 1=
92 kB)
Jan 17 19:42:04 vosztok kernel:       .data : 0xc036e6c1 - 0xc043f854   ( 8=
36 kB)
Jan 17 19:42:04 vosztok kernel:       .text : 0xc0100000 - 0xc036e6c1   (24=
89 kB)
Jan 17 19:42:04 vosztok kernel: Checking if this processor honours the WP b=
it even in supervisor mode... Ok.
Jan 17 19:42:04 vosztok kernel: SLUB: Genslabs=3D22, HWalign=3D64, Order=3D=
0-1, MinObjects=3D4, CPUs=3D1, Nodes=3D1
Jan 17 19:42:04 vosztok kernel: Calibrating delay using timer specific rout=
ine.. 3198.28 BogoMIPS (lpj=3D1599144)
Jan 17 19:42:04 vosztok kernel: Mount-cache hash table entries: 512
Jan 17 19:42:04 vosztok kernel: CPU: After generic identify, caps: afe9f9bf=
 00000000 00000000 00000000 00000180 00000000 00000000 00000000
Jan 17 19:42:04 vosztok kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Jan 17 19:42:04 vosztok kernel: CPU: L2 cache: 2048K
Jan 17 19:42:04 vosztok kernel: CPU: After all inits, caps: afe9f9bf 000000=
00 00000000 00002040 00000180 00000000 00000000 00000000
Jan 17 19:42:04 vosztok kernel: Compat vDSO mapped to ffffe000.
Jan 17 19:42:04 vosztok kernel: CPU: Intel(R) Pentium(R) M processor 1.60GH=
z stepping 06
Jan 17 19:42:04 vosztok kernel: Checking 'hlt' instruction... OK.
Jan 17 19:42:04 vosztok kernel: ACPI: Core revision 20070126
Jan 17 19:42:04 vosztok kernel: ACPI: setting ELCR to 0200 (from 0820)
Jan 17 19:42:04 vosztok kernel: NET: Registered protocol family 16
Jan 17 19:42:04 vosztok kernel: ACPI: bus type pci registered
Jan 17 19:42:04 vosztok kernel: PCI: PCI BIOS revision 2.10 entry at 0xfd8c=
6, last bus=3D5
Jan 17 19:42:04 vosztok kernel: PCI: Using configuration type 1
Jan 17 19:42:04 vosztok kernel: Setting up standard PCI resources
Jan 17 19:42:04 vosztok kernel: ACPI: EC: EC description table is found, co=
nfiguring boot EC
Jan 17 19:42:04 vosztok kernel:=20
Jan 17 19:42:04 vosztok kernel: ACPI: Interpreter enabled
Jan 17 19:42:04 vosztok kernel: ACPI: (supports S0 S3 S4 S5)
Jan 17 19:42:04 vosztok kernel: ACPI: Using PIC for interrupt routing
Jan 17 19:42:04 vosztok kernel: ACPI: EC: GPE =3D 0x1c, I/O: command/status=
 =3D 0x66, data =3D 0x62
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Root Bridge [PCI0] (0000:00)
Jan 17 19:42:04 vosztok kernel: PCI quirk: region 1000-107f claimed by ICH4=
 ACPI/GPIO/TCO
Jan 17 19:42:04 vosztok kernel: PCI quirk: region 1180-11bf claimed by ICH4=
 GPIO
Jan 17 19:42:04 vosztok kernel: PCI: Transparent bridge - 0000:00:1e.0
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PC=
I0._PRT]
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PC=
I0.PCI1._PRT]
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5=
 6 7 9 10 *11)
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *=
5 6 7 9 10 11)
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5=
 6 7 9 10 *11)
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5=
 6 7 9 10 *11)
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5=
 6 7 9 10 *11)
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5=
 6 7 9 10 *11)
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5=
 6 7 9 10 11) *0, disabled.
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5=
 6 7 9 10 *11)
Jan 17 19:42:04 vosztok kernel: ACPI: Power Resource [PUBS] (on)
Jan 17 19:42:04 vosztok kernel: Linux Plug and Play Support v0.97 (c) Adam =
Belay
Jan 17 19:42:04 vosztok kernel: pnp: PnP ACPI init
Jan 17 19:42:04 vosztok kernel: ACPI: bus type pnp registered
Jan 17 19:42:04 vosztok kernel: pnp: PnP ACPI: found 10 devices
Jan 17 19:42:04 vosztok kernel: ACPI: ACPI bus type pnp unregistered
Jan 17 19:42:04 vosztok kernel: SCSI subsystem initialized
Jan 17 19:42:04 vosztok kernel: libata version 2.21 loaded.
Jan 17 19:42:04 vosztok kernel: PCI: Using ACPI for IRQ routing
Jan 17 19:42:04 vosztok kernel: PCI: If a device doesn't work, try "pci=3Dr=
outeirq".  If it helps, post a report
Jan 17 19:42:04 vosztok kernel: ACPI: RTC can wake from S4
Jan 17 19:42:04 vosztok kernel: Time: tsc clocksource has been installed.
Jan 17 19:42:04 vosztok kernel: pnp: 00:00: iomem range 0x0-0x9ffff could n=
ot be reserved
Jan 17 19:42:04 vosztok kernel: pnp: 00:00: iomem range 0xc0000-0xc3fff cou=
ld not be reserved
Jan 17 19:42:04 vosztok kernel: pnp: 00:00: iomem range 0xc4000-0xc7fff cou=
ld not be reserved
Jan 17 19:42:04 vosztok kernel: pnp: 00:00: iomem range 0xc8000-0xcbfff has=
 been reserved
Jan 17 19:42:04 vosztok kernel: PCI: Bus 3, cardbus bridge: 0000:02:00.0
Jan 17 19:42:04 vosztok kernel:   IO window: 00003000-000030ff
Jan 17 19:42:04 vosztok kernel:   IO window: 00003400-000034ff
Jan 17 19:42:04 vosztok kernel:   PREFETCH window: f0000000-f3ffffff
Jan 17 19:42:04 vosztok kernel:   MEM window: d4000000-d7ffffff
Jan 17 19:42:04 vosztok kernel: PCI: Bridge: 0000:00:1e.0
Jan 17 19:42:04 vosztok kernel:   IO window: 3000-7fff
Jan 17 19:42:04 vosztok kernel:   MEM window: d0200000-dfffffff
Jan 17 19:42:04 vosztok kernel:   PREFETCH window: f0000000-f7ffffff
Jan 17 19:42:04 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1e.0 to 64
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt Link [LNKA] enabled at =
IRQ 11
Jan 17 19:42:04 vosztok kernel: PCI: setting IRQ 11 as level-triggered
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt 0000:02:00.0[A] -> Link=
 [LNKA] -> GSI 11 (level, low) -> IRQ 11
Jan 17 19:42:04 vosztok kernel: NET: Registered protocol family 2
Jan 17 19:42:04 vosztok kernel: IP route cache hash table entries: 4096 (or=
der: 2, 16384 bytes)
Jan 17 19:42:04 vosztok kernel: TCP established hash table entries: 16384 (=
order: 5, 131072 bytes)
Jan 17 19:42:04 vosztok kernel: TCP bind hash table entries: 16384 (order: =
4, 65536 bytes)
Jan 17 19:42:04 vosztok kernel: TCP: Hash tables configured (established 16=
384 bind 16384)
Jan 17 19:42:04 vosztok kernel: TCP reno registered
Jan 17 19:42:04 vosztok kernel: checking if image is initramfs... it is
Jan 17 19:42:04 vosztok kernel: Freeing initrd memory: 1925k freed
Jan 17 19:42:04 vosztok kernel: Simple Boot Flag at 0x35 set to 0x1
Jan 17 19:42:04 vosztok kernel: SGI XFS with ACLs, security attributes, rea=
ltime, no debug enabled
Jan 17 19:42:04 vosztok kernel: SGI XFS Quota Management subsystem
Jan 17 19:42:04 vosztok kernel: io scheduler noop registered
Jan 17 19:42:04 vosztok kernel: io scheduler cfq registered (default)
Jan 17 19:42:04 vosztok kernel: Boot video device is 0000:00:02.0
Jan 17 19:42:04 vosztok kernel: PCI: Firmware left 0000:02:08.0 e100 interr=
upts enabled, disabling
Jan 17 19:42:04 vosztok kernel: Non-volatile memory driver v1.2
Jan 17 19:42:04 vosztok kernel: Linux agpgart interface v0.102
Jan 17 19:42:04 vosztok kernel: agpgart: Detected an Intel 855GM Chipset.
Jan 17 19:42:04 vosztok kernel: agpgart: Detected 8060K stolen memory.
Jan 17 19:42:04 vosztok kernel: agpgart: AGP aperture is 128M @ 0xe0000000
Jan 17 19:42:04 vosztok kernel: vesafb: framebuffer at 0xe0000000, mapped t=
o 0xe0180000, using 6144k, total 8000k
Jan 17 19:42:04 vosztok kernel: vesafb: mode is 1024x768x32, linelength=3D4=
096, pages=3D1
Jan 17 19:42:04 vosztok kernel: vesafb: scrolling: redraw
Jan 17 19:42:04 vosztok kernel: vesafb: Truecolor: size=3D8:8:8:8, shift=3D=
24:16:8:0
Jan 17 19:42:04 vosztok kernel: Console: switching to colour frame buffer d=
evice 128x48
Jan 17 19:42:04 vosztok kernel: fbcondecor: console 0 using theme 'livecd-2=
006.1'
Jan 17 19:42:04 vosztok kernel: fbcondecor: switched decor state to 'on' on=
 console 0
Jan 17 19:42:04 vosztok kernel: fb0: VESA VGA frame buffer device
Jan 17 19:42:04 vosztok kernel: ACPI: AC Adapter [AC] (on-line)
Jan 17 19:42:04 vosztok kernel: ACPI: Battery Slot [BAT0] (battery absent)
Jan 17 19:42:04 vosztok kernel: input: Power Button (FF) as /devices/virtua=
l/input/input0
Jan 17 19:42:04 vosztok kernel: ACPI: Power Button (FF) [PWRF]
Jan 17 19:42:04 vosztok kernel: input: Lid Switch as /devices/virtual/input=
/input1
Jan 17 19:42:04 vosztok kernel: ACPI: Lid Switch [LID]
Jan 17 19:42:04 vosztok kernel: input: Sleep Button (CM) as /devices/virtua=
l/input/input2
Jan 17 19:42:04 vosztok kernel: ACPI: Sleep Button (CM) [SLPB]
Jan 17 19:42:04 vosztok kernel: ACPI: CPU0 (power states: C1[C1] C2[C2] C3[=
C3])
Jan 17 19:42:04 vosztok kernel: ACPI: Processor [CPU] (supports 8 throttlin=
g states)
Jan 17 19:42:04 vosztok kernel: ACPI: Thermal Zone [THM0] (43 C)
Jan 17 19:42:04 vosztok kernel: intelfb: intelfb_init
Jan 17 19:42:04 vosztok kernel: intelfb: Framebuffer driver for Intel(R) 83=
0M/845G/852GM/855GM/865G/915G/915GM/945G/945GM chipsets
Jan 17 19:42:04 vosztok kernel: intelfb: Version 0.9.4
Jan 17 19:42:04 vosztok kernel: intelfb: intelfb_setup
Jan 17 19:42:04 vosztok kernel: intelfb: no options
Jan 17 19:42:04 vosztok kernel: intelfb: intelfb_pci_register
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt 0000:00:02.0[A] -> Link=
 [LNKA] -> GSI 11 (level, low) -> IRQ 11
Jan 17 19:42:04 vosztok kernel: intelfb: fb aperture: 0xe0000000/0x8000000,=
 MMIO region: 0xd0000000/0x80000
Jan 17 19:42:04 vosztok kernel: intelfb: Cannot reserve FB region.
Jan 17 19:42:04 vosztok kernel: intelfb: cleanup
Jan 17 19:42:04 vosztok kernel: RAMDISK driver initialized: 16 RAM disks of=
 8192K size 1024 blocksize
Jan 17 19:42:04 vosztok kernel: loop: module loaded
Jan 17 19:42:04 vosztok kernel: thinkpad_acpi: ThinkPad ACPI Extras v0.16
Jan 17 19:42:04 vosztok kernel: thinkpad_acpi: http://ibm-acpi.sf.net/
Jan 17 19:42:04 vosztok kernel: thinkpad_acpi: ThinkPad BIOS 1WET85WW (2.05=
 ), EC 1VHT28WW-1.04
Jan 17 19:42:04 vosztok kernel: thinkpad_acpi: IBM ThinkPad R50e
Jan 17 19:42:04 vosztok kernel: Switched to high resolution mode on CPU 0
Jan 17 19:42:04 vosztok kernel: input: ThinkPad Extra Buttons as /devices/v=
irtual/input/input3
Jan 17 19:42:04 vosztok kernel: e100: Intel(R) PRO/100 Network Driver, 3.5.=
23-k4-NAPI
Jan 17 19:42:04 vosztok kernel: e100: Copyright(c) 1999-2006 Intel Corporat=
ion
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt Link [LNKE] enabled at =
IRQ 11
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt 0000:02:08.0[A] -> Link=
 [LNKE] -> GSI 11 (level, low) -> IRQ 11
Jan 17 19:42:04 vosztok kernel: e100: eth0: e100_probe: addr 0xd0201000, ir=
q 11, MAC addr 00:0A:E4:34:7E:7F
Jan 17 19:42:04 vosztok kernel: ata_piix 0000:00:1f.1: version 2.12
Jan 17 19:42:04 vosztok kernel: PCI: Enabling device 0000:00:1f.1 (0005 -> =
0007)
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt Link [LNKC] enabled at =
IRQ 11
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link=
 [LNKC] -> GSI 11 (level, low) -> IRQ 11
Jan 17 19:42:04 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1f.1 to 64
Jan 17 19:42:04 vosztok kernel: scsi0 : ata_piix
Jan 17 19:42:04 vosztok kernel: scsi1 : ata_piix
Jan 17 19:42:04 vosztok kernel: ata1: PATA max UDMA/100 cmd 0x000101f0 ctl =
0x000103f6 bmdma 0x00011810 irq 14
Jan 17 19:42:04 vosztok kernel: ata2: PATA max UDMA/100 cmd 0x00010170 ctl =
0x00010376 bmdma 0x00011818 irq 15
Jan 17 19:42:04 vosztok kernel: ata1.00: ATA-6: HTS424040M9AT00, MA2IA75A, =
max UDMA/100
Jan 17 19:42:04 vosztok kernel: ata1.00: 78140160 sectors, multi 16: LBA=20
Jan 17 19:42:04 vosztok kernel: ata1.00: configured for UDMA/100
Jan 17 19:42:04 vosztok kernel: ata2.00: ATAPI: MATSHITADVD-RAM UJ-830Sx, 1=
.00, max UDMA/33
Jan 17 19:42:04 vosztok kernel: ata2.00: configured for UDMA/33
Jan 17 19:42:04 vosztok kernel: scsi 0:0:0:0: Direct-Access     ATA      HT=
S424040M9AT00  MA2I PQ: 0 ANSI: 5
Jan 17 19:42:04 vosztok kernel: sd 0:0:0:0: [sda] 78140160 512-byte hardwar=
e sectors (40008 MB)
Jan 17 19:42:04 vosztok kernel: sd 0:0:0:0: [sda] Write Protect is off
Jan 17 19:42:04 vosztok kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jan 17 19:42:04 vosztok kernel: sd 0:0:0:0: [sda] Write cache: enabled, rea=
d cache: enabled, doesn't support DPO or FUA
Jan 17 19:42:04 vosztok kernel: sd 0:0:0:0: [sda] 78140160 512-byte hardwar=
e sectors (40008 MB)
Jan 17 19:42:04 vosztok kernel: sd 0:0:0:0: [sda] Write Protect is off
Jan 17 19:42:04 vosztok kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jan 17 19:42:04 vosztok kernel: sd 0:0:0:0: [sda] Write cache: enabled, rea=
d cache: enabled, doesn't support DPO or FUA
Jan 17 19:42:04 vosztok kernel:  sda: sda1 sda2
Jan 17 19:42:04 vosztok kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Jan 17 19:42:04 vosztok kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Jan 17 19:42:04 vosztok kernel: scsi 1:0:0:0: CD-ROM            MATSHITA DV=
D-RAM UJ-830Sx 1.00 PQ: 0 ANSI: 5
Jan 17 19:42:04 vosztok kernel: sr0: scsi3-mmc drive: 24x/24x writer dvd-ra=
m cd/rw xa/form2 cdda tray
Jan 17 19:42:04 vosztok kernel: Uniform CD-ROM driver Revision: 3.20
Jan 17 19:42:04 vosztok kernel: sr 1:0:0:0: Attached scsi CD-ROM sr0
Jan 17 19:42:04 vosztok kernel: sr 1:0:0:0: Attached scsi generic sg1 type 5
Jan 17 19:42:04 vosztok kernel: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:M=
OU] at 0x60,0x64 irq 1,12
Jan 17 19:42:04 vosztok kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Jan 17 19:42:04 vosztok kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Jan 17 19:42:04 vosztok kernel: mice: PS/2 mouse device common for all mice
Jan 17 19:42:04 vosztok kernel: input: AT Translated Set 2 keyboard as /dev=
ices/platform/i8042/serio0/input/input4
Jan 17 19:42:04 vosztok kernel: device-mapper: ioctl: 4.11.0-ioctl (2006-10=
-12) initialised: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Jan 17 19:42:04 vosztok kernel: TCP cubic registered
Jan 17 19:42:04 vosztok kernel: NET: Registered protocol family 1
Jan 17 19:42:04 vosztok kernel: NET: Registered protocol family 10
Jan 17 19:42:04 vosztok kernel: lo: Disabled Privacy Extensions
Jan 17 19:42:04 vosztok kernel: Mobile IPv6
Jan 17 19:42:04 vosztok kernel: NET: Registered protocol family 17
Jan 17 19:42:04 vosztok kernel: Using IPI Shortcut mode
Jan 17 19:42:04 vosztok kernel: Freeing unused kernel memory: 192k freed
Jan 17 19:42:04 vosztok kernel: IBM TrackPoint firmware: 0x0e, buttons: 3/3
Jan 17 19:42:04 vosztok kernel: input: TPPS/2 IBM TrackPoint as /devices/pl=
atform/i8042/serio1/input/input5
Jan 17 19:42:04 vosztok kernel: ata1: soft resetting port
Jan 17 19:42:04 vosztok kernel: ata1.00: configured for UDMA/100
Jan 17 19:42:04 vosztok kernel: ata1: EH complete
Jan 17 19:42:04 vosztok kernel: sd 0:0:0:0: [sda] 78140160 512-byte hardwar=
e sectors (40008 MB)
Jan 17 19:42:04 vosztok kernel: sd 0:0:0:0: [sda] Write Protect is off
Jan 17 19:42:04 vosztok kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jan 17 19:42:04 vosztok kernel: sd 0:0:0:0: [sda] Write cache: enabled, rea=
d cache: enabled, doesn't support DPO or FUA
Jan 17 19:42:04 vosztok kernel: usbcore: registered new interface driver us=
bfs
Jan 17 19:42:04 vosztok kernel: usbcore: registered new interface driver hub
Jan 17 19:42:04 vosztok kernel: usbcore: registered new device driver usb
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt Link [LNKH] enabled at =
IRQ 11
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link=
 [LNKH] -> GSI 11 (level, low) -> IRQ 11
Jan 17 19:42:04 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1d.7 to 64
Jan 17 19:42:04 vosztok kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller
Jan 17 19:42:04 vosztok kernel: ehci_hcd 0000:00:1d.7: new USB bus register=
ed, assigned bus number 1
Jan 17 19:42:04 vosztok kernel: ehci_hcd 0000:00:1d.7: debug port 1
Jan 17 19:42:04 vosztok kernel: PCI: cache line size of 32 is not supported=
 by device 0000:00:1d.7
Jan 17 19:42:04 vosztok kernel: ehci_hcd 0000:00:1d.7: irq 11, io mem 0xd01=
00000
Jan 17 19:42:04 vosztok kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHC=
I 1.00, driver 10 Dec 2004
Jan 17 19:42:04 vosztok kernel: usb usb1: configuration #1 chosen from 1 ch=
oice
Jan 17 19:42:04 vosztok kernel: hub 1-0:1.0: USB hub found
Jan 17 19:42:04 vosztok kernel: hub 1-0:1.0: 6 ports detected
Jan 17 19:42:04 vosztok kernel: Initializing USB Mass Storage driver...
Jan 17 19:42:04 vosztok kernel: usbcore: registered new interface driver us=
b-storage
Jan 17 19:42:04 vosztok kernel: USB Mass Storage support registered.
Jan 17 19:42:04 vosztok kernel: USB Universal Host Controller Interface dri=
ver v3.0
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link=
 [LNKA] -> GSI 11 (level, low) -> IRQ 11
Jan 17 19:42:04 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1d.0 to 64
Jan 17 19:42:04 vosztok kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller
Jan 17 19:42:04 vosztok kernel: uhci_hcd 0000:00:1d.0: new USB bus register=
ed, assigned bus number 2
Jan 17 19:42:04 vosztok kernel: uhci_hcd 0000:00:1d.0: irq 11, io base 0x00=
001820
Jan 17 19:42:04 vosztok kernel: usb usb2: configuration #1 chosen from 1 ch=
oice
Jan 17 19:42:04 vosztok kernel: hub 2-0:1.0: USB hub found
Jan 17 19:42:04 vosztok kernel: hub 2-0:1.0: 2 ports detected
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt Link [LNKD] enabled at =
IRQ 11
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link=
 [LNKD] -> GSI 11 (level, low) -> IRQ 11
Jan 17 19:42:04 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1d.1 to 64
Jan 17 19:42:04 vosztok kernel: uhci_hcd 0000:00:1d.1: UHCI Host Controller
Jan 17 19:42:04 vosztok kernel: uhci_hcd 0000:00:1d.1: new USB bus register=
ed, assigned bus number 3
Jan 17 19:42:04 vosztok kernel: uhci_hcd 0000:00:1d.1: irq 11, io base 0x00=
001840
Jan 17 19:42:04 vosztok kernel: usb usb3: configuration #1 chosen from 1 ch=
oice
Jan 17 19:42:04 vosztok kernel: hub 3-0:1.0: USB hub found
Jan 17 19:42:04 vosztok kernel: hub 3-0:1.0: 2 ports detected
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link=
 [LNKC] -> GSI 11 (level, low) -> IRQ 11
Jan 17 19:42:04 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1d.2 to 64
Jan 17 19:42:04 vosztok kernel: uhci_hcd 0000:00:1d.2: UHCI Host Controller
Jan 17 19:42:04 vosztok kernel: uhci_hcd 0000:00:1d.2: new USB bus register=
ed, assigned bus number 4
Jan 17 19:42:04 vosztok kernel: uhci_hcd 0000:00:1d.2: irq 11, io base 0x00=
001860
Jan 17 19:42:04 vosztok kernel: usb usb4: configuration #1 chosen from 1 ch=
oice
Jan 17 19:42:04 vosztok kernel: hub 4-0:1.0: USB hub found
Jan 17 19:42:04 vosztok kernel: hub 4-0:1.0: 2 ports detected
Jan 17 19:42:04 vosztok kernel: usb 3-1: new low speed USB device using uhc=
i_hcd and address 2
Jan 17 19:42:04 vosztok kernel: usb 3-1: configuration #1 chosen from 1 cho=
ice
Jan 17 19:42:04 vosztok kernel: usbcore: registered new interface driver hi=
ddev
Jan 17 19:42:04 vosztok kernel: input: HID 062a:0000 as /devices/pci0000:00=
/0000:00:1d.1/usb3/3-1/3-1:1.0/input/input6
Jan 17 19:42:04 vosztok kernel: input: USB HID v1.10 Mouse [HID 062a:0000] =
on usb-0000:00:1d.1-1
Jan 17 19:42:04 vosztok kernel: usbcore: registered new interface driver us=
bhid
Jan 17 19:42:04 vosztok kernel: drivers/hid/usbhid/hid-core.c: v2.6:USB HID=
 core driver
Jan 17 19:42:04 vosztok kernel: Marking TSC unstable due to: possible TSC h=
alt in C2.
Jan 17 19:42:04 vosztok kernel: Time: acpi_pm clocksource has been installe=
d.
Jan 17 19:42:04 vosztok kernel: UDF-fs: No VRS found
Jan 17 19:42:04 vosztok kernel: Filesystem "dm-0": Disabling barriers, not =
supported by the underlying device
Jan 17 19:42:04 vosztok kernel: XFS mounting filesystem dm-0
Jan 17 19:42:04 vosztok kernel: Starting XFS recovery on filesystem: dm-0 (=
logdev: internal)
Jan 17 19:42:04 vosztok kernel: Ending XFS recovery on filesystem: dm-0 (lo=
gdev: internal)
Jan 17 19:42:04 vosztok kernel: Real Time Clock Driver v1.12ac
Jan 17 19:42:04 vosztok kernel: parport_pc 00:09: reported by Plug and Play=
 ACPI
Jan 17 19:42:04 vosztok kernel: parport0: PC-style at 0x3bc, irq 7 [PCSPP,T=
RISTATE]
Jan 17 19:42:04 vosztok kernel: Yenta: CardBus bridge found at 0000:02:00.0=
 [1014:0512]
Jan 17 19:42:04 vosztok kernel: Yenta: Using INTVAL to route CSC interrupts=
 to PCI
Jan 17 19:42:04 vosztok kernel: Yenta: Routing CardBus interrupts to PCI
Jan 17 19:42:04 vosztok kernel: Yenta TI: socket 0000:02:00.0, mfunc 0x01d2=
1022, devctl 0x64
Jan 17 19:42:04 vosztok kernel: ieee80211_crypt: registered algorithm 'NULL'
Jan 17 19:42:04 vosztok kernel: ieee80211: 802.11 data/management/control s=
tack, git-1.1.13
Jan 17 19:42:04 vosztok kernel: ieee80211: Copyright (C) 2004-2005 Intel Co=
rporation <jketreno-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Jan 17 19:42:04 vosztok kernel: ipw2200: Intel(R) PRO/Wireless 2200/2915 Ne=
twork Driver, 1.2.2kmprq
Jan 17 19:42:04 vosztok kernel: ipw2200: Copyright(c) 2003-2006 Intel Corpo=
ration
Jan 17 19:42:04 vosztok kernel: Yenta: ISA IRQ mask 0x0478, PCI irq 11
Jan 17 19:42:04 vosztok kernel: Socket status: 30000007
Jan 17 19:42:04 vosztok kernel: pcmcia: parent PCI bridge I/O window: 0x300=
0 - 0x7fff
Jan 17 19:42:04 vosztok kernel: pcmcia: parent PCI bridge Memory window: 0x=
d0200000 - 0xdfffffff
Jan 17 19:42:04 vosztok kernel: pcmcia: parent PCI bridge Memory window: 0x=
f0000000 - 0xf7ffffff
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt Link [LNKB] enabled at =
IRQ 5
Jan 17 19:42:04 vosztok kernel: PCI: setting IRQ 5 as level-triggered
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link=
 [LNKB] -> GSI 5 (level, low) -> IRQ 5
Jan 17 19:42:04 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1f.5 to 64
Jan 17 19:42:04 vosztok kernel: intel8x0_measure_ac97_clock: measured 50544=
 usecs
Jan 17 19:42:04 vosztok kernel: intel8x0: clocking to 48000
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt Link [LNKF] enabled at =
IRQ 11
Jan 17 19:42:04 vosztok kernel: ACPI: PCI Interrupt 0000:02:02.0[A] -> Link=
 [LNKF] -> GSI 11 (level, low) -> IRQ 11
Jan 17 19:42:04 vosztok kernel: ipw2200: Detected Intel PRO/Wireless 2200BG=
 Network Connection
Jan 17 19:42:04 vosztok kernel: ipw2200: Detected geography ZZR (14 802.11b=
g channels, 0 802.11a channels)
Jan 17 19:42:04 vosztok kernel: Filesystem "dm-0": Disabling barriers, not =
supported by the underlying device
Jan 17 19:42:04 vosztok kernel: fuse init (API version 7.8)
Jan 17 19:42:04 vosztok kernel: segctord starting. Construction interval =
=3D 5 seconds, CP frequency < 30 seconds
Jan 17 19:42:04 vosztok kernel: NILFS warning (device dm-1): nilfs_sync_sup=
er: barrier-based sync failed. disabling barriers
Jan 17 19:42:04 vosztok kernel:=20
Jan 17 19:42:04 vosztok kernel: Adding 1048568k swap on /dev/dm-2.  Priorit=
y:-1 extents:1 across:1048568k
Jan 17 19:42:07 vosztok kernel: e100: eth0: e100_watchdog: link up, 100Mbps=
, full-duplex
Jan 17 19:42:07 vosztok kernel: Bridge firewalling registered
Jan 17 19:42:10 vosztok kernel: ieee80211_crypt: registered algorithm 'CCMP'
Jan 17 19:42:10 vosztok kernel: ieee80211_crypt: registered algorithm 'TKIP'
Jan 17 19:42:17 vosztok kernel: eth0: no IPv6 routers present
Jan 17 19:42:19 vosztok kernel: eth1: no IPv6 routers present
Jan 17 19:42:22 vosztok kernel: Clocksource tsc unstable (delta =3D -625161=
57 ns)
Jan 17 19:42:34 vosztok kernel: [drm] Initialized drm 1.1.0 20060810
Jan 17 19:42:34 vosztok kernel: [drm] Initialized i915 1.6.0 20060119 on mi=
nor 0
Jan 17 19:42:34 vosztok kernel: [drm] Initialized i915 1.6.0 20060119 on mi=
nor 1
Jan 17 19:53:31 vosztok kernel: klogd 1.4.1, log source =3D /proc/kmsg star=
ted.
Jan 17 19:53:31 vosztok kernel: Inspecting /boot/System.map
Jan 17 19:53:32 vosztok kernel: Loaded 28989 symbols from /boot/System.map.
Jan 17 19:53:32 vosztok kernel: Symbols match kernel version 2.6.23.
Jan 17 19:53:32 vosztok kernel: Linux version 2.6.23-gentoo-r5 (root@voszto=
k) (gcc version 4.1.2 (Gentoo 4.1.2)) #1 PREEMPT Thu Jan 17 14:05:39 CET 20=
08
Jan 17 19:53:32 vosztok kernel: BIOS-provided physical RAM map:
Jan 17 19:53:32 vosztok kernel:  BIOS-e820: 0000000000000000 - 000000000009=
f000 (usable)
Jan 17 19:53:32 vosztok kernel:  BIOS-e820: 000000000009f000 - 00000000000a=
0000 (reserved)
Jan 17 19:53:32 vosztok kernel:  BIOS-e820: 00000000000dc000 - 000000000010=
0000 (reserved)
Jan 17 19:53:32 vosztok kernel:  BIOS-e820: 0000000000100000 - 000000001f6e=
0000 (usable)
Jan 17 19:53:32 vosztok kernel:  BIOS-e820: 000000001f6e0000 - 000000001f6f=
7000 (ACPI data)
Jan 17 19:53:32 vosztok kernel:  BIOS-e820: 000000001f6f7000 - 000000001f6f=
9000 (ACPI NVS)
Jan 17 19:53:32 vosztok kernel:  BIOS-e820: 000000001f700000 - 000000002000=
0000 (reserved)
Jan 17 19:53:32 vosztok kernel:  BIOS-e820: 00000000ff800000 - 000000010000=
0000 (reserved)
Jan 17 19:53:32 vosztok kernel: 502MB LOWMEM available.
Jan 17 19:53:32 vosztok kernel: Entering add_active_range(0, 0, 128736) 0 e=
ntries of 256 used
Jan 17 19:53:32 vosztok kernel: Zone PFN ranges:
Jan 17 19:53:32 vosztok kernel:   DMA             0 ->     4096
Jan 17 19:53:32 vosztok kernel:   Normal       4096 ->   128736
Jan 17 19:53:32 vosztok kernel: Movable zone start PFN for each node
Jan 17 19:53:32 vosztok kernel: early_node_map[1] active PFN ranges
Jan 17 19:53:32 vosztok kernel:     0:        0 ->   128736
Jan 17 19:53:32 vosztok kernel: On node 0 totalpages: 128736
Jan 17 19:53:32 vosztok kernel:   DMA zone: 32 pages used for memmap
Jan 17 19:53:32 vosztok kernel:   DMA zone: 0 pages reserved
Jan 17 19:53:32 vosztok kernel:   DMA zone: 4064 pages, LIFO batch:0
Jan 17 19:53:32 vosztok kernel:   Normal zone: 973 pages used for memmap
Jan 17 19:53:32 vosztok kernel:   Normal zone: 123667 pages, LIFO batch:31
Jan 17 19:53:32 vosztok kernel:   Movable zone: 0 pages used for memmap
Jan 17 19:53:32 vosztok kernel: DMI present.
Jan 17 19:53:32 vosztok kernel: ACPI: RSDP 000F6E40, 0024 (r2 IBM   )
Jan 17 19:53:32 vosztok kernel: ACPI: XSDT 1F6EF33D, 004C (r1 IBM    TP-1W =
       2050  LTP        0)
Jan 17 19:53:32 vosztok kernel: ACPI: FACP 1F6EF400, 00F4 (r3 IBM    TP-1W =
       2050 IBM         1)
Jan 17 19:53:32 vosztok kernel: ACPI Warning (tbfadt-0442): Optional field =
"Gpe1Block" has zero address or length: 000000000000102C/0 [20070126]
Jan 17 19:53:32 vosztok kernel: ACPI: DSDT 1F6EF5E7, 7865 (r1 IBM    TP-1W =
       2050 MSFT  100000E)
Jan 17 19:53:32 vosztok kernel: ACPI: FACS 1F6F8000, 0040
Jan 17 19:53:32 vosztok kernel: ACPI: SSDT 1F6EF5B4, 0033 (r1 IBM    TP-1W =
       2050 MSFT  100000E)
Jan 17 19:53:32 vosztok kernel: ACPI: ECDT 1F6F6E4C, 0052 (r1 IBM    TP-1W =
       2050 IBM         1)
Jan 17 19:53:32 vosztok kernel: ACPI: TCPA 1F6F6E9E, 0032 (r1 IBM    TP-1W =
       2050 PTL         1)
Jan 17 19:53:32 vosztok kernel: ACPI: BOOT 1F6F6FD8, 0028 (r1 IBM    TP-1W =
       2050  LTP        1)
Jan 17 19:53:32 vosztok kernel: ACPI: PM-Timer IO Port: 0x1008
Jan 17 19:53:32 vosztok kernel: Allocating PCI resources starting at 300000=
00 (gap: 20000000:df800000)
Jan 17 19:53:32 vosztok kernel: swsusp: Registered nosave memory region: 00=
0000000009f000 - 00000000000a0000
Jan 17 19:53:32 vosztok kernel: swsusp: Registered nosave memory region: 00=
000000000a0000 - 00000000000dc000
Jan 17 19:53:32 vosztok kernel: swsusp: Registered nosave memory region: 00=
000000000dc000 - 0000000000100000
Jan 17 19:53:32 vosztok kernel: Built 1 zonelists in Zone order.  Total pag=
es: 127731
Jan 17 19:53:32 vosztok kernel: Kernel command line: dolvm real_root=3DLABE=
L=3Dvosztok-root vga=3D792 nolapic CONSOLE=3D/dev/tty1 splash=3Dsilent,fade=
in,theme:livecd-2006.1,tty:12 quiet=20
Jan 17 19:53:32 vosztok kernel: mapped APIC to ffffb000 (013f3000)
Jan 17 19:53:32 vosztok kernel: Enabling fast FPU save and restore... done.
Jan 17 19:53:32 vosztok kernel: Enabling unmasked SIMD FPU exception suppor=
t... done.
Jan 17 19:53:32 vosztok kernel: Initializing CPU#0
Jan 17 19:53:32 vosztok kernel: PID hash table entries: 2048 (order: 11, 81=
92 bytes)
Jan 17 19:53:32 vosztok kernel: Detected 1598.695 MHz processor.
Jan 17 19:53:32 vosztok kernel: Console: colour dummy device 80x25
Jan 17 19:53:32 vosztok kernel: console [tty0] enabled
Jan 17 19:53:32 vosztok kernel: Dentry cache hash table entries: 65536 (ord=
er: 6, 262144 bytes)
Jan 17 19:53:32 vosztok kernel: Inode-cache hash table entries: 32768 (orde=
r: 5, 131072 bytes)
Jan 17 19:53:32 vosztok kernel: Memory: 504308k/514944k available (2489k ke=
rnel code, 10096k reserved, 836k data, 192k init, 0k highmem)
Jan 17 19:53:32 vosztok kernel: virtual kernel memory layout:
Jan 17 19:53:32 vosztok kernel:     fixmap  : 0xfffb5000 - 0xfffff000   ( 2=
96 kB)
Jan 17 19:53:32 vosztok kernel:     vmalloc : 0xe0000000 - 0xfffb3000   ( 5=
11 MB)
Jan 17 19:53:32 vosztok kernel:     lowmem  : 0xc0000000 - 0xdf6e0000   ( 5=
02 MB)
Jan 17 19:53:32 vosztok kernel:       .init : 0xc0442000 - 0xc0472000   ( 1=
92 kB)
Jan 17 19:53:32 vosztok kernel:       .data : 0xc036e6c1 - 0xc043f854   ( 8=
36 kB)
Jan 17 19:53:32 vosztok kernel:       .text : 0xc0100000 - 0xc036e6c1   (24=
89 kB)
Jan 17 19:53:32 vosztok kernel: Checking if this processor honours the WP b=
it even in supervisor mode... Ok.
Jan 17 19:53:32 vosztok kernel: SLUB: Genslabs=3D22, HWalign=3D64, Order=3D=
0-1, MinObjects=3D4, CPUs=3D1, Nodes=3D1
Jan 17 19:53:32 vosztok kernel: Calibrating delay using timer specific rout=
ine.. 3198.28 BogoMIPS (lpj=3D1599144)
Jan 17 19:53:32 vosztok kernel: Mount-cache hash table entries: 512
Jan 17 19:53:32 vosztok kernel: CPU: After generic identify, caps: afe9f9bf=
 00000000 00000000 00000000 00000180 00000000 00000000 00000000
Jan 17 19:53:32 vosztok kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Jan 17 19:53:32 vosztok kernel: CPU: L2 cache: 2048K
Jan 17 19:53:32 vosztok kernel: CPU: After all inits, caps: afe9f9bf 000000=
00 00000000 00002040 00000180 00000000 00000000 00000000
Jan 17 19:53:32 vosztok kernel: Compat vDSO mapped to ffffe000.
Jan 17 19:53:32 vosztok kernel: CPU: Intel(R) Pentium(R) M processor 1.60GH=
z stepping 06
Jan 17 19:53:32 vosztok kernel: Checking 'hlt' instruction... OK.
Jan 17 19:53:32 vosztok kernel: ACPI: Core revision 20070126
Jan 17 19:53:32 vosztok kernel: ACPI: setting ELCR to 0200 (from 0820)
Jan 17 19:53:32 vosztok kernel: NET: Registered protocol family 16
Jan 17 19:53:32 vosztok kernel: ACPI: bus type pci registered
Jan 17 19:53:32 vosztok kernel: PCI: PCI BIOS revision 2.10 entry at 0xfd8c=
6, last bus=3D5
Jan 17 19:53:32 vosztok kernel: PCI: Using configuration type 1
Jan 17 19:53:32 vosztok kernel: Setting up standard PCI resources
Jan 17 19:53:32 vosztok kernel: ACPI: EC: EC description table is found, co=
nfiguring boot EC
Jan 17 19:53:32 vosztok kernel:=20
Jan 17 19:53:32 vosztok kernel: ACPI: Interpreter enabled
Jan 17 19:53:32 vosztok kernel: ACPI: (supports S0 S3 S4 S5)
Jan 17 19:53:32 vosztok kernel: ACPI: Using PIC for interrupt routing
Jan 17 19:53:32 vosztok kernel: ACPI: EC: GPE =3D 0x1c, I/O: command/status=
 =3D 0x66, data =3D 0x62
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Root Bridge [PCI0] (0000:00)
Jan 17 19:53:32 vosztok kernel: PCI quirk: region 1000-107f claimed by ICH4=
 ACPI/GPIO/TCO
Jan 17 19:53:32 vosztok kernel: PCI quirk: region 1180-11bf claimed by ICH4=
 GPIO
Jan 17 19:53:32 vosztok kernel: PCI: Transparent bridge - 0000:00:1e.0
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PC=
I0._PRT]
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PC=
I0.PCI1._PRT]
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5=
 6 7 9 10 *11)
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *=
5 6 7 9 10 11)
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5=
 6 7 9 10 *11)
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5=
 6 7 9 10 *11)
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5=
 6 7 9 10 *11)
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5=
 6 7 9 10 *11)
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5=
 6 7 9 10 11) *0, disabled.
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5=
 6 7 9 10 *11)
Jan 17 19:53:32 vosztok kernel: ACPI: Power Resource [PUBS] (on)
Jan 17 19:53:32 vosztok kernel: Linux Plug and Play Support v0.97 (c) Adam =
Belay
Jan 17 19:53:32 vosztok kernel: pnp: PnP ACPI init
Jan 17 19:53:32 vosztok kernel: ACPI: bus type pnp registered
Jan 17 19:53:32 vosztok kernel: pnp: PnP ACPI: found 10 devices
Jan 17 19:53:32 vosztok kernel: ACPI: ACPI bus type pnp unregistered
Jan 17 19:53:32 vosztok kernel: SCSI subsystem initialized
Jan 17 19:53:32 vosztok kernel: libata version 2.21 loaded.
Jan 17 19:53:32 vosztok kernel: PCI: Using ACPI for IRQ routing
Jan 17 19:53:32 vosztok kernel: PCI: If a device doesn't work, try "pci=3Dr=
outeirq".  If it helps, post a report
Jan 17 19:53:32 vosztok kernel: ACPI: RTC can wake from S4
Jan 17 19:53:32 vosztok kernel: Time: tsc clocksource has been installed.
Jan 17 19:53:32 vosztok kernel: pnp: 00:00: iomem range 0x0-0x9ffff could n=
ot be reserved
Jan 17 19:53:32 vosztok kernel: pnp: 00:00: iomem range 0xc0000-0xc3fff cou=
ld not be reserved
Jan 17 19:53:32 vosztok kernel: pnp: 00:00: iomem range 0xc4000-0xc7fff cou=
ld not be reserved
Jan 17 19:53:32 vosztok kernel: pnp: 00:00: iomem range 0xc8000-0xcbfff has=
 been reserved
Jan 17 19:53:32 vosztok kernel: PCI: Bus 3, cardbus bridge: 0000:02:00.0
Jan 17 19:53:32 vosztok kernel:   IO window: 00003000-000030ff
Jan 17 19:53:32 vosztok kernel:   IO window: 00003400-000034ff
Jan 17 19:53:32 vosztok kernel:   PREFETCH window: f0000000-f3ffffff
Jan 17 19:53:32 vosztok kernel:   MEM window: d4000000-d7ffffff
Jan 17 19:53:32 vosztok kernel: PCI: Bridge: 0000:00:1e.0
Jan 17 19:53:32 vosztok kernel:   IO window: 3000-7fff
Jan 17 19:53:32 vosztok kernel:   MEM window: d0200000-dfffffff
Jan 17 19:53:32 vosztok kernel:   PREFETCH window: f0000000-f7ffffff
Jan 17 19:53:32 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1e.0 to 64
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt Link [LNKA] enabled at =
IRQ 11
Jan 17 19:53:32 vosztok kernel: PCI: setting IRQ 11 as level-triggered
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt 0000:02:00.0[A] -> Link=
 [LNKA] -> GSI 11 (level, low) -> IRQ 11
Jan 17 19:53:32 vosztok kernel: NET: Registered protocol family 2
Jan 17 19:53:32 vosztok kernel: IP route cache hash table entries: 4096 (or=
der: 2, 16384 bytes)
Jan 17 19:53:32 vosztok kernel: TCP established hash table entries: 16384 (=
order: 5, 131072 bytes)
Jan 17 19:53:32 vosztok kernel: TCP bind hash table entries: 16384 (order: =
4, 65536 bytes)
Jan 17 19:53:32 vosztok kernel: TCP: Hash tables configured (established 16=
384 bind 16384)
Jan 17 19:53:32 vosztok kernel: TCP reno registered
Jan 17 19:53:32 vosztok kernel: checking if image is initramfs... it is
Jan 17 19:53:32 vosztok kernel: Freeing initrd memory: 1925k freed
Jan 17 19:53:32 vosztok kernel: Simple Boot Flag at 0x35 set to 0x1
Jan 17 19:53:32 vosztok kernel: SGI XFS with ACLs, security attributes, rea=
ltime, no debug enabled
Jan 17 19:53:32 vosztok kernel: SGI XFS Quota Management subsystem
Jan 17 19:53:32 vosztok kernel: io scheduler noop registered
Jan 17 19:53:32 vosztok kernel: io scheduler cfq registered (default)
Jan 17 19:53:32 vosztok kernel: Boot video device is 0000:00:02.0
Jan 17 19:53:32 vosztok kernel: PCI: Firmware left 0000:02:08.0 e100 interr=
upts enabled, disabling
Jan 17 19:53:32 vosztok kernel: Non-volatile memory driver v1.2
Jan 17 19:53:32 vosztok kernel: Linux agpgart interface v0.102
Jan 17 19:53:32 vosztok kernel: agpgart: Detected an Intel 855GM Chipset.
Jan 17 19:53:32 vosztok kernel: agpgart: Detected 8060K stolen memory.
Jan 17 19:53:32 vosztok kernel: agpgart: AGP aperture is 128M @ 0xe0000000
Jan 17 19:53:32 vosztok kernel: vesafb: framebuffer at 0xe0000000, mapped t=
o 0xe0180000, using 6144k, total 8000k
Jan 17 19:53:32 vosztok kernel: vesafb: mode is 1024x768x32, linelength=3D4=
096, pages=3D1
Jan 17 19:53:32 vosztok kernel: vesafb: scrolling: redraw
Jan 17 19:53:32 vosztok kernel: vesafb: Truecolor: size=3D8:8:8:8, shift=3D=
24:16:8:0
Jan 17 19:53:32 vosztok kernel: Console: switching to colour frame buffer d=
evice 128x48
Jan 17 19:53:32 vosztok kernel: fbcondecor: console 0 using theme 'livecd-2=
006.1'
Jan 17 19:53:32 vosztok kernel: fbcondecor: switched decor state to 'on' on=
 console 0
Jan 17 19:53:32 vosztok kernel: fb0: VESA VGA frame buffer device
Jan 17 19:53:32 vosztok kernel: ACPI: AC Adapter [AC] (on-line)
Jan 17 19:53:32 vosztok kernel: ACPI: Battery Slot [BAT0] (battery absent)
Jan 17 19:53:32 vosztok kernel: input: Power Button (FF) as /devices/virtua=
l/input/input0
Jan 17 19:53:32 vosztok kernel: ACPI: Power Button (FF) [PWRF]
Jan 17 19:53:32 vosztok kernel: input: Lid Switch as /devices/virtual/input=
/input1
Jan 17 19:53:32 vosztok kernel: ACPI: Lid Switch [LID]
Jan 17 19:53:32 vosztok kernel: input: Sleep Button (CM) as /devices/virtua=
l/input/input2
Jan 17 19:53:32 vosztok kernel: ACPI: Sleep Button (CM) [SLPB]
Jan 17 19:53:32 vosztok kernel: ACPI: CPU0 (power states: C1[C1] C2[C2] C3[=
C3])
Jan 17 19:53:32 vosztok kernel: ACPI: Processor [CPU] (supports 8 throttlin=
g states)
Jan 17 19:53:32 vosztok kernel: ACPI: Thermal Zone [THM0] (60 C)
Jan 17 19:53:32 vosztok kernel: intelfb: intelfb_init
Jan 17 19:53:32 vosztok kernel: intelfb: Framebuffer driver for Intel(R) 83=
0M/845G/852GM/855GM/865G/915G/915GM/945G/945GM chipsets
Jan 17 19:53:32 vosztok kernel: intelfb: Version 0.9.4
Jan 17 19:53:32 vosztok kernel: intelfb: intelfb_setup
Jan 17 19:53:32 vosztok kernel: intelfb: no options
Jan 17 19:53:32 vosztok kernel: intelfb: intelfb_pci_register
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt 0000:00:02.0[A] -> Link=
 [LNKA] -> GSI 11 (level, low) -> IRQ 11
Jan 17 19:53:32 vosztok kernel: intelfb: fb aperture: 0xe0000000/0x8000000,=
 MMIO region: 0xd0000000/0x80000
Jan 17 19:53:32 vosztok kernel: intelfb: Cannot reserve FB region.
Jan 17 19:53:32 vosztok kernel: intelfb: cleanup
Jan 17 19:53:32 vosztok kernel: RAMDISK driver initialized: 16 RAM disks of=
 8192K size 1024 blocksize
Jan 17 19:53:32 vosztok kernel: loop: module loaded
Jan 17 19:53:32 vosztok kernel: thinkpad_acpi: ThinkPad ACPI Extras v0.16
Jan 17 19:53:32 vosztok kernel: thinkpad_acpi: http://ibm-acpi.sf.net/
Jan 17 19:53:32 vosztok kernel: thinkpad_acpi: ThinkPad BIOS 1WET85WW (2.05=
 ), EC 1VHT28WW-1.04
Jan 17 19:53:32 vosztok kernel: thinkpad_acpi: IBM ThinkPad R50e
Jan 17 19:53:32 vosztok kernel: Switched to high resolution mode on CPU 0
Jan 17 19:53:32 vosztok kernel: input: ThinkPad Extra Buttons as /devices/v=
irtual/input/input3
Jan 17 19:53:32 vosztok kernel: e100: Intel(R) PRO/100 Network Driver, 3.5.=
23-k4-NAPI
Jan 17 19:53:32 vosztok kernel: e100: Copyright(c) 1999-2006 Intel Corporat=
ion
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt Link [LNKE] enabled at =
IRQ 11
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt 0000:02:08.0[A] -> Link=
 [LNKE] -> GSI 11 (level, low) -> IRQ 11
Jan 17 19:53:32 vosztok kernel: e100: eth0: e100_probe: addr 0xd0201000, ir=
q 11, MAC addr 00:0A:E4:34:7E:7F
Jan 17 19:53:32 vosztok kernel: ata_piix 0000:00:1f.1: version 2.12
Jan 17 19:53:32 vosztok kernel: PCI: Enabling device 0000:00:1f.1 (0005 -> =
0007)
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt Link [LNKC] enabled at =
IRQ 11
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link=
 [LNKC] -> GSI 11 (level, low) -> IRQ 11
Jan 17 19:53:32 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1f.1 to 64
Jan 17 19:53:32 vosztok kernel: scsi0 : ata_piix
Jan 17 19:53:32 vosztok kernel: scsi1 : ata_piix
Jan 17 19:53:32 vosztok kernel: ata1: PATA max UDMA/100 cmd 0x000101f0 ctl =
0x000103f6 bmdma 0x00011810 irq 14
Jan 17 19:53:32 vosztok kernel: ata2: PATA max UDMA/100 cmd 0x00010170 ctl =
0x00010376 bmdma 0x00011818 irq 15
Jan 17 19:53:32 vosztok kernel: ata1.00: ATA-6: HTS424040M9AT00, MA2IA75A, =
max UDMA/100
Jan 17 19:53:32 vosztok kernel: ata1.00: 78140160 sectors, multi 16: LBA=20
Jan 17 19:53:32 vosztok kernel: ata1.00: configured for UDMA/100
Jan 17 19:53:32 vosztok kernel: ata2.00: ATAPI: MATSHITADVD-RAM UJ-830Sx, 1=
.00, max UDMA/33
Jan 17 19:53:32 vosztok kernel: ata2.00: configured for UDMA/33
Jan 17 19:53:32 vosztok kernel: scsi 0:0:0:0: Direct-Access     ATA      HT=
S424040M9AT00  MA2I PQ: 0 ANSI: 5
Jan 17 19:53:32 vosztok kernel: sd 0:0:0:0: [sda] 78140160 512-byte hardwar=
e sectors (40008 MB)
Jan 17 19:53:32 vosztok kernel: sd 0:0:0:0: [sda] Write Protect is off
Jan 17 19:53:32 vosztok kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jan 17 19:53:32 vosztok kernel: sd 0:0:0:0: [sda] Write cache: enabled, rea=
d cache: enabled, doesn't support DPO or FUA
Jan 17 19:53:32 vosztok kernel: sd 0:0:0:0: [sda] 78140160 512-byte hardwar=
e sectors (40008 MB)
Jan 17 19:53:32 vosztok kernel: sd 0:0:0:0: [sda] Write Protect is off
Jan 17 19:53:32 vosztok kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jan 17 19:53:32 vosztok kernel: sd 0:0:0:0: [sda] Write cache: enabled, rea=
d cache: enabled, doesn't support DPO or FUA
Jan 17 19:53:32 vosztok kernel:  sda: sda1 sda2
Jan 17 19:53:32 vosztok kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Jan 17 19:53:32 vosztok kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Jan 17 19:53:32 vosztok kernel: scsi 1:0:0:0: CD-ROM            MATSHITA DV=
D-RAM UJ-830Sx 1.00 PQ: 0 ANSI: 5
Jan 17 19:53:32 vosztok kernel: sr0: scsi3-mmc drive: 24x/24x writer dvd-ra=
m cd/rw xa/form2 cdda tray
Jan 17 19:53:32 vosztok kernel: Uniform CD-ROM driver Revision: 3.20
Jan 17 19:53:32 vosztok kernel: sr 1:0:0:0: Attached scsi CD-ROM sr0
Jan 17 19:53:32 vosztok kernel: sr 1:0:0:0: Attached scsi generic sg1 type 5
Jan 17 19:53:32 vosztok kernel: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:M=
OU] at 0x60,0x64 irq 1,12
Jan 17 19:53:32 vosztok kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Jan 17 19:53:32 vosztok kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Jan 17 19:53:32 vosztok kernel: mice: PS/2 mouse device common for all mice
Jan 17 19:53:32 vosztok kernel: input: AT Translated Set 2 keyboard as /dev=
ices/platform/i8042/serio0/input/input4
Jan 17 19:53:32 vosztok kernel: device-mapper: ioctl: 4.11.0-ioctl (2006-10=
-12) initialised: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Jan 17 19:53:32 vosztok kernel: TCP cubic registered
Jan 17 19:53:32 vosztok kernel: NET: Registered protocol family 1
Jan 17 19:53:32 vosztok kernel: NET: Registered protocol family 10
Jan 17 19:53:32 vosztok kernel: lo: Disabled Privacy Extensions
Jan 17 19:53:32 vosztok kernel: Mobile IPv6
Jan 17 19:53:32 vosztok kernel: NET: Registered protocol family 17
Jan 17 19:53:32 vosztok kernel: Using IPI Shortcut mode
Jan 17 19:53:32 vosztok kernel: Freeing unused kernel memory: 192k freed
Jan 17 19:53:32 vosztok kernel: IBM TrackPoint firmware: 0x0e, buttons: 3/3
Jan 17 19:53:32 vosztok kernel: input: TPPS/2 IBM TrackPoint as /devices/pl=
atform/i8042/serio1/input/input5
Jan 17 19:53:32 vosztok kernel: ata1: soft resetting port
Jan 17 19:53:32 vosztok kernel: ata1.00: configured for UDMA/100
Jan 17 19:53:32 vosztok kernel: ata1: EH complete
Jan 17 19:53:32 vosztok kernel: sd 0:0:0:0: [sda] 78140160 512-byte hardwar=
e sectors (40008 MB)
Jan 17 19:53:32 vosztok kernel: sd 0:0:0:0: [sda] Write Protect is off
Jan 17 19:53:32 vosztok kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jan 17 19:53:32 vosztok kernel: sd 0:0:0:0: [sda] Write cache: enabled, rea=
d cache: enabled, doesn't support DPO or FUA
Jan 17 19:53:32 vosztok kernel: usbcore: registered new interface driver us=
bfs
Jan 17 19:53:32 vosztok kernel: usbcore: registered new interface driver hub
Jan 17 19:53:32 vosztok kernel: usbcore: registered new device driver usb
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt Link [LNKH] enabled at =
IRQ 11
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link=
 [LNKH] -> GSI 11 (level, low) -> IRQ 11
Jan 17 19:53:32 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1d.7 to 64
Jan 17 19:53:32 vosztok kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller
Jan 17 19:53:32 vosztok kernel: ehci_hcd 0000:00:1d.7: new USB bus register=
ed, assigned bus number 1
Jan 17 19:53:32 vosztok kernel: ehci_hcd 0000:00:1d.7: debug port 1
Jan 17 19:53:32 vosztok kernel: PCI: cache line size of 32 is not supported=
 by device 0000:00:1d.7
Jan 17 19:53:32 vosztok kernel: ehci_hcd 0000:00:1d.7: irq 11, io mem 0xd01=
00000
Jan 17 19:53:32 vosztok kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHC=
I 1.00, driver 10 Dec 2004
Jan 17 19:53:32 vosztok kernel: usb usb1: configuration #1 chosen from 1 ch=
oice
Jan 17 19:53:32 vosztok kernel: hub 1-0:1.0: USB hub found
Jan 17 19:53:32 vosztok kernel: hub 1-0:1.0: 6 ports detected
Jan 17 19:53:32 vosztok kernel: Initializing USB Mass Storage driver...
Jan 17 19:53:32 vosztok kernel: usbcore: registered new interface driver us=
b-storage
Jan 17 19:53:32 vosztok kernel: USB Mass Storage support registered.
Jan 17 19:53:32 vosztok kernel: USB Universal Host Controller Interface dri=
ver v3.0
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link=
 [LNKA] -> GSI 11 (level, low) -> IRQ 11
Jan 17 19:53:32 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1d.0 to 64
Jan 17 19:53:32 vosztok kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller
Jan 17 19:53:32 vosztok kernel: uhci_hcd 0000:00:1d.0: new USB bus register=
ed, assigned bus number 2
Jan 17 19:53:32 vosztok kernel: uhci_hcd 0000:00:1d.0: irq 11, io base 0x00=
001820
Jan 17 19:53:32 vosztok kernel: usb usb2: configuration #1 chosen from 1 ch=
oice
Jan 17 19:53:32 vosztok kernel: hub 2-0:1.0: USB hub found
Jan 17 19:53:32 vosztok kernel: hub 2-0:1.0: 2 ports detected
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt Link [LNKD] enabled at =
IRQ 11
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link=
 [LNKD] -> GSI 11 (level, low) -> IRQ 11
Jan 17 19:53:32 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1d.1 to 64
Jan 17 19:53:32 vosztok kernel: uhci_hcd 0000:00:1d.1: UHCI Host Controller
Jan 17 19:53:32 vosztok kernel: uhci_hcd 0000:00:1d.1: new USB bus register=
ed, assigned bus number 3
Jan 17 19:53:32 vosztok kernel: uhci_hcd 0000:00:1d.1: irq 11, io base 0x00=
001840
Jan 17 19:53:32 vosztok kernel: usb usb3: configuration #1 chosen from 1 ch=
oice
Jan 17 19:53:32 vosztok kernel: hub 3-0:1.0: USB hub found
Jan 17 19:53:32 vosztok kernel: hub 3-0:1.0: 2 ports detected
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link=
 [LNKC] -> GSI 11 (level, low) -> IRQ 11
Jan 17 19:53:32 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1d.2 to 64
Jan 17 19:53:32 vosztok kernel: uhci_hcd 0000:00:1d.2: UHCI Host Controller
Jan 17 19:53:32 vosztok kernel: uhci_hcd 0000:00:1d.2: new USB bus register=
ed, assigned bus number 4
Jan 17 19:53:32 vosztok kernel: uhci_hcd 0000:00:1d.2: irq 11, io base 0x00=
001860
Jan 17 19:53:32 vosztok kernel: usb usb4: configuration #1 chosen from 1 ch=
oice
Jan 17 19:53:32 vosztok kernel: hub 4-0:1.0: USB hub found
Jan 17 19:53:32 vosztok kernel: hub 4-0:1.0: 2 ports detected
Jan 17 19:53:32 vosztok kernel: usb 3-1: new low speed USB device using uhc=
i_hcd and address 2
Jan 17 19:53:32 vosztok kernel: usb 3-1: configuration #1 chosen from 1 cho=
ice
Jan 17 19:53:32 vosztok kernel: usbcore: registered new interface driver hi=
ddev
Jan 17 19:53:32 vosztok kernel: input: HID 062a:0000 as /devices/pci0000:00=
/0000:00:1d.1/usb3/3-1/3-1:1.0/input/input6
Jan 17 19:53:32 vosztok kernel: input: USB HID v1.10 Mouse [HID 062a:0000] =
on usb-0000:00:1d.1-1
Jan 17 19:53:32 vosztok kernel: usbcore: registered new interface driver us=
bhid
Jan 17 19:53:32 vosztok kernel: drivers/hid/usbhid/hid-core.c: v2.6:USB HID=
 core driver
Jan 17 19:53:32 vosztok kernel: Marking TSC unstable due to: possible TSC h=
alt in C2.
Jan 17 19:53:32 vosztok kernel: Time: acpi_pm clocksource has been installe=
d.
Jan 17 19:53:32 vosztok kernel: UDF-fs: No VRS found
Jan 17 19:53:32 vosztok kernel: Filesystem "dm-0": Disabling barriers, not =
supported by the underlying device
Jan 17 19:53:32 vosztok kernel: XFS mounting filesystem dm-0
Jan 17 19:53:32 vosztok kernel: Starting XFS recovery on filesystem: dm-0 (=
logdev: internal)
Jan 17 19:53:32 vosztok kernel: Ending XFS recovery on filesystem: dm-0 (lo=
gdev: internal)
Jan 17 19:53:32 vosztok kernel: Real Time Clock Driver v1.12ac
Jan 17 19:53:32 vosztok kernel: parport_pc 00:09: reported by Plug and Play=
 ACPI
Jan 17 19:53:32 vosztok kernel: parport0: PC-style at 0x3bc, irq 7 [PCSPP,T=
RISTATE]
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt Link [LNKB] enabled at =
IRQ 5
Jan 17 19:53:32 vosztok kernel: PCI: setting IRQ 5 as level-triggered
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link=
 [LNKB] -> GSI 5 (level, low) -> IRQ 5
Jan 17 19:53:32 vosztok kernel: PCI: Setting latency timer of device 0000:0=
0:1f.5 to 64
Jan 17 19:53:32 vosztok kernel: ieee80211_crypt: registered algorithm 'NULL'
Jan 17 19:53:32 vosztok kernel: ieee80211: 802.11 data/management/control s=
tack, git-1.1.13
Jan 17 19:53:32 vosztok kernel: ieee80211: Copyright (C) 2004-2005 Intel Co=
rporation <jketreno-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Jan 17 19:53:32 vosztok kernel: ipw2200: Intel(R) PRO/Wireless 2200/2915 Ne=
twork Driver, 1.2.2kmprq
Jan 17 19:53:32 vosztok kernel: ipw2200: Copyright(c) 2003-2006 Intel Corpo=
ration
Jan 17 19:53:32 vosztok kernel: intel8x0_measure_ac97_clock: measured 50547=
 usecs
Jan 17 19:53:32 vosztok kernel: intel8x0: clocking to 48000
Jan 17 19:53:32 vosztok kernel: Yenta: CardBus bridge found at 0000:02:00.0=
 [1014:0512]
Jan 17 19:53:32 vosztok kernel: Yenta: Using INTVAL to route CSC interrupts=
 to PCI
Jan 17 19:53:32 vosztok kernel: Yenta: Routing CardBus interrupts to PCI
Jan 17 19:53:32 vosztok kernel: Yenta TI: socket 0000:02:00.0, mfunc 0x01d2=
1022, devctl 0x64
Jan 17 19:53:32 vosztok kernel: Yenta: ISA IRQ mask 0x0458, PCI irq 11
Jan 17 19:53:32 vosztok kernel: Socket status: 30000007
Jan 17 19:53:32 vosztok kernel: pcmcia: parent PCI bridge I/O window: 0x300=
0 - 0x7fff
Jan 17 19:53:32 vosztok kernel: pcmcia: parent PCI bridge Memory window: 0x=
d0200000 - 0xdfffffff
Jan 17 19:53:32 vosztok kernel: pcmcia: parent PCI bridge Memory window: 0x=
f0000000 - 0xf7ffffff
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt Link [LNKF] enabled at =
IRQ 11
Jan 17 19:53:32 vosztok kernel: ACPI: PCI Interrupt 0000:02:02.0[A] -> Link=
 [LNKF] -> GSI 11 (level, low) -> IRQ 11
Jan 17 19:53:32 vosztok kernel: ipw2200: Detected Intel PRO/Wireless 2200BG=
 Network Connection
Jan 17 19:53:32 vosztok kernel: ipw2200: Detected geography ZZR (14 802.11b=
g channels, 0 802.11a channels)
Jan 17 19:53:32 vosztok kernel: Filesystem "dm-0": Disabling barriers, not =
supported by the underlying device
Jan 17 19:53:32 vosztok kernel: fuse init (API version 7.8)
Jan 17 19:53:32 vosztok kernel: segctord starting. Construction interval =
=3D 5 seconds, CP frequency < 30 seconds
Jan 17 19:53:32 vosztok kernel: NILFS warning (device dm-1): nilfs_sync_sup=
er: barrier-based sync failed. disabling barriers
Jan 17 19:53:32 vosztok kernel:=20
Jan 17 19:53:32 vosztok kernel: Adding 1048568k swap on /dev/dm-2.  Priorit=
y:-1 extents:1 across:1048568k
Jan 17 19:53:34 vosztok kernel: e100: eth0: e100_watchdog: link up, 100Mbps=
, full-duplex
Jan 17 19:53:35 vosztok kernel: Bridge firewalling registered
Jan 17 19:53:38 vosztok kernel: ieee80211_crypt: registered algorithm 'CCMP'
Jan 17 19:53:38 vosztok kernel: ieee80211_crypt: registered algorithm 'TKIP'
Jan 17 19:53:40 vosztok kernel: Clocksource tsc unstable (delta =3D -312507=
451 ns)
Jan 17 19:53:45 vosztok kernel: eth0: no IPv6 routers present
Jan 17 19:53:47 vosztok kernel: eth1: no IPv6 routers present
Jan 17 19:54:02 vosztok kernel: [drm] Initialized drm 1.1.0 20060810
Jan 17 19:54:02 vosztok kernel: [drm] Initialized i915 1.6.0 20060119 on mi=
nor 0
Jan 17 19:54:02 vosztok kernel: [drm] Initialized i915 1.6.0 20060119 on mi=
nor 1
Jan 17 20:02:49 vosztok kernel: fbcondecor: console 0 using theme 'livecd-2=
006.1'
Jan 17 20:02:49 vosztok kernel: fbcondecor: switched decor state to 'on' on=
 console 0

--MP_/+=O.r0VQ+xJ8MPnHGom_eMy--

--Sig_/.0q5G/=kZThIJL+bzpyrMvi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHj6g5lZGsj+xzT3kRAllTAJwPUjkJa7i5hmv4lpqnjtJ+KDnv6wCgqhga
mvIevjVRogUZyGcjxYoiDXU=
=wKLR
-----END PGP SIGNATURE-----

--Sig_/.0q5G/=kZThIJL+bzpyrMvi--

--===============0075233366==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0075233366==--
