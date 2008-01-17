From: Gergely =?UTF-8?B?R8OhYm9y?= <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Deadlocks! help, please!
Date: Thu, 17 Jan 2008 18:33:02 +0100
Message-ID: <20080117183302.275d051d@vosztok>
References: <20080116222500.60e78090@vosztok>
	<1200556717.3085.94.camel@localhost.localdomain>
	<1200561294.3085.131.camel@localhost.localdomain>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2024369748=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:date:from:to:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
	bh=/Cn9FaVZP/uuDdMdLOo9tymmrpHFNXxnRI2d/vbOvss=;
	b=MWeVx19hVMQBX+nzTXz41rvKo2jnbX3cSJOYFilj5ryUBwVX38uzht+0BViYtMpSVPTkkFqMX6kwxpAiMnQ0ek5MpADO8dTT0BGAnKkSjWbJAW+LoCQ79ofetQredVbOAf4TWsGcXMqwR/kVC74OxM985IZdkRj/kCNVVS2chgk=
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

--===============2024369748==
Content-Type: multipart/signed; boundary="Sig_/rE9l0bsyBUlH7ybQGKGJh48";
	protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_/rE9l0bsyBUlH7ybQGKGJh48
Content-Type: multipart/mixed; boundary="MP_/yJ/YDOAj_1K7EsTidwTZQWg"

--MP_/yJ/YDOAj_1K7EsTidwTZQWg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thu, 17 Jan 2008 18:14:54 +0900
Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:

> Hi Gergely,

Hello Ryusuke! (i hope i guessed well, actually my firstname is G=C3=A1bor,=
 as we write names in reverse order to english speaker world, yet i don't k=
now the Japaneese customs)
=20
> >=20
> > Sorry for inconvenience.

No problem, I wanted to try nilfs, and i knew it will possibly need some ef=
fort from me as well. I'm happy to help.
>=20
> Oh, I cannot try rtorrent right now because we have a
> restriction on use of P2P softwares :).
>=20
fortunately i can,and rtorrent (or something else) faithfully reproduces th=
e lock. :)

> Could you get information through the following way

I attach the kernel log. Sorry for the long delay, but the machine frooze d=
uring kernel recompilation, as i didn't use sysrq before. It worked. Hope t=
he information will be useful.

Thanks for the help.
--=20
Gergely G=C3=A1bor <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

* random fortune:
"Now I've got the bead on you with MY disintegrating gun.  And when it=20
disintegrates, it disintegrates.  (pulls trigger)  Well, what you do know,=
=20
it disintegrated."
-- Duck Dodgers in the 24th and a half century

--MP_/yJ/YDOAj_1K7EsTidwTZQWg
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

--MP_/yJ/YDOAj_1K7EsTidwTZQWg--

--Sig_/rE9l0bsyBUlH7ybQGKGJh48
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHj5FVlZGsj+xzT3kRAj51AJ0as7ny/fwrZ3YwsOS+hLkS7oGZsgCgtK6X
hMiE4dI3T5rJcl4/NZt0gyI=
=ehXR
-----END PGP SIGNATURE-----

--Sig_/rE9l0bsyBUlH7ybQGKGJh48--

--===============2024369748==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============2024369748==--
