From: =?UTF-8?Q?=C5=81ukasz_W=C3=B3jcicki?= <lwojcicki-V+nj596LuoKHKKo6LODCOg@public.gmane.org>
Subject: problem with nilfs_cleanerd
Date: Tue, 06 Jul 2010 11:02:41 +0200
Message-ID: <1278406961.8438.6.camel@Stanowisko-25>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I'am using kernel 2.6.20 with nilf_utils-2-0-18 and nilfs kernel module
2-0-20 .

<1>Unable to handle kernel NULL pointer dereference at virtual address
00000000
<1>pgd =3D c4eb0000
<1>[00000000] *pgd=3Dc4e2d031, *pte=3D00000000, *ppte=3D00000000
<4>Internal error: Oops: 17 [#1]
<4>Modules linked in:
<4>CPU: 0
<4>PC is at nilfs_btree_lookup_dirty_buffers+0x10c/0x1ec
<4>LR is at 0xc4c99b24
<4>pc : [<c012743c>]    lr : [<c4c99b24>]    Not tainted
<4>sp : c4c99b08  ip : c46e42dc  fp : c4c99c04
<4>r10: c4c99b94  r9 : c4c99b94  r8 : 00000000
<4>r7 : c4c99b24  r6 : c46e42dc  r5 : 00000000  r4 : 4c259cb9
<4>r3 : c472b008  r2 : 00000000  r1 : 00000000  r0 : c4726864
<4>Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  Segment user
<4>Control: C000717F
<4>Table: C4EB0000  DAC: 00000015
<4>Process nilfs_cleanerd (pid: 1367, stack limit =3D 0xc4c98258)
<4>Stack: (0xc4c99b08 to 0xc4c9a000)
<4>9b00:                   0000000e 00004000 00000000 c4c99b94 c4c99c74
c47268ac=20
<4>9b20: c4c99b50 c4726864 c4c99b4c c4c99b2c c4c99b2c c4c99b34 c4c99b34
c4c99b3c=20
<4>9b40: c4c99b3c c4c99b44 c4c99b44 c4c99b4c c4c99b4c c4c99b54 c4c99b54
c4c99b5c=20
<4>9b60: c4c99b5c c4c99b64 c4c99b64 c4c99b6c c4c99b6c c4c99b74 c4c99b74
c4c99b7c=20
<4>9b80: c4c99b7c c4c99b84 c4c99b84 c4c99b8c c4c99b8c 00000001 00000000
c040f560=20
<4>9ba0: c4c99bcc c4c99bb0 c0125168 c00a7858 c4c99c84 c4726904 c05c99e0
00000000=20
<4>9bc0: c4c99be4 c4c99bd0 c0133f48 c0125134 c4c99c50 00007145 c4c99c14
00000000=20
<4>9be0: c4c99c74 00000000 c05c99e0 c033ede8 c033ede8 c4726904 c4c99c14
c4c99c08=20
<4>9c00: c0124e94 c0127340 c4c99cb4 c4c99c18 c012f73c c0124e80 0000000e
00000000=20
<4>9c20: ffffffff 7fffffff c033ede8 c472681c c0102e70 00000000 00000000
c040f560=20
<4>9c40: 00000010 4c344f2d c4e67738 00000000 c05b8ae0 c4c98000 c4c99c7c
c4c99c68=20
<4>9c60: c012e494 c0102e60 c4c99c84 c4e67738 c4c99c9c c4c99c74 c4c99c74
c4c99c7c=20
<4>9c80: c4c99c7c 00007145 c4e67738 c472681c c5e77800 c05c99f4 c05b8ae0
00000000=20
<4>9ca0: c05b8ae0 c4c98000 c4c99dac c4c99cb8 c01321f0 c012f5ac 00000287
c5e77800=20
<4>9cc0: c4e376ec c5876cf4 c4c99d60 c4c99d50 c0123d20 c0102144 c05c9a34
c05c9a20=20
<4>9ce0: c05c99ec c4c98000 00000001 c05c99e0 0000001d c05b8ae0 c5e77800
c687c000=20
<4>9d00: 00000001 c5876c1c c5876c54 00000000 c05c99f4 c05b8ae0 c05b8ae0
c4c98000=20
<4>9d20: c4c99d3c c4c99d30 c00a7858 c0190f98 c4c99d5c c4c99d40 c012504c
c00a7858=20
<4>9d40: c687c460 c5876cf4 c5e77800 c05b8ae0 00000000 00000000 00000000
00000000=20
<4>9d60: c4c99da4 00000001 0000001e 00000000 c012ede4 c0124378 c05c99e0
c05c99e0=20
<4>9d80: c4c99dac c05c99e0 c5e77800 c4c99df8 c05c99f4 c05b8ae0 c05b8ae0
c4c98000=20
<4>9da0: c4c99dd4 c4c99db0 c0132654 c0130844 c4c99ec8 c4c99e50 c05c99e0
c05c99f4=20
<4>9dc0: c5e77800 c4c98000 c4c99e34 c4c99dd8 c0133bb0 c0132584 c05a3200
00000000=20
<4>9de0: c4c99ec8 d9e392fb 00000000 00000014 c4c99df0 c4c99df0 00000001
00000000=20
<4>9e00: 00000000 00000000 c4c99e24 c4c98000 c5876124 0001b1b8 00000000
00000488=20
<4>9e20: c4c99ec8 00000004 c4c99f2c c4c99e38 c0139254 c0133ae8 c4c99e84
c4c99e48=20
<4>9e40: 00000001 c5e77800 c4c99eb0 00000010 40936008 00000000 000004b3
00020040=20
<4>9e60: 4002358c 4001b000 000171b0 00000000 00000001 40020010 00000018
00000000=20
<4>9e80: 00015770 00000000 000001f2 40020008 00000000 be981848 0001b1b8
00000000=20
<4>9ea0: 0000001d 00000028 00000001 00000000 be98e920 00000000 00000001
00010008=20
<4>9ec0: be98e920 0001b1b8 c6864000 c6878000 c687a000 c687c000 c055ab40
0001b1b8=20
<4>9ee0: 00000001 00000001 00000000 00000000 c4c98000 00000001 c036a448
0000000a=20
<4>9f00: c036a200 c51093a0 be9817f8 40786e88 00000036 c006d068 c4c98000
00000000=20
<4>9f20: c4c99f4c c4c99f30 c00ea608 c0138bc8 c036a244 c51093a0 00000006
be9817f8=20
<4>9f40: c4c99f7c c4c99f50 c00ea6dc c00ea5dc c0091a40 c00918d8 c4c98000
c51093a0=20
<4>9f60: fffffff7 40786e88 00000036 c006d068 c4c99fa4 c4c99f80 c00ea9c8
c00ea67c=20
<4>9f80: 40000000 00000000 c4c99fac 00000008 00000028 00015770 00000000
c4c99fa8=20
<4>9fa0: c006cec0 c00ea998 00000008 00000028 00000006 40786e88 be9817f8
000001f2=20
<4>9fc0: 00000008 00000028 00015770 00000036 0001b1b8 00000000 000171b0
000171b0=20
<4>9fe0: 00000000 be9817f0 40024948 400d210c 20000010 00000006 00000000
00000000=20
<4>Backtrace:=20
<4>[<c0127330>] (nilfs_btree_lookup_dirty_buffers+0x0/0x1ec) from
[<c0124e94>] (nilfs_bmap_lookup_dirty_buffers+0x24/0x28)
<4>[<c0124e70>] (nilfs_bmap_lookup_dirty_buffers+0x0/0x28) from
[<c012f73c>] (nilfs_segctor_scan_file+0x1a0/0x258)
<4>[<c012f59c>] (nilfs_segctor_scan_file+0x0/0x258) from [<c01321f0>]
(nilfs_segctor_do_construct+0x19bc/0x1b28)
<4>[<c0130834>] (nilfs_segctor_do_construct+0x0/0x1b28) from
[<c0132654>] (nilfs_segctor_construct+0xe0/0x104)
<4>[<c0132574>] (nilfs_segctor_construct+0x0/0x104) from [<c0133bb0>]
(nilfs_clean_segments+0xd8/0x1fc)
<4>[<c0133ad8>] (nilfs_clean_segments+0x0/0x1fc) from [<c0139254>]
(nilfs_ioctl+0x69c/0x828)
<4>[<c0138bb8>] (nilfs_ioctl+0x0/0x828) from [<c00ea608>] (do_ioctl
+0x3c/0xa0)
<4>[<c00ea5cc>] (do_ioctl+0x0/0xa0) from [<c00ea6dc>] (vfs_ioctl
+0x70/0x31c)
<4> r6 =3D BE9817F8  r5 =3D 00000006  r4 =3D C51093A0=20
<4>[<c00ea66c>] (vfs_ioctl+0x0/0x31c) from [<c00ea9c8>] (sys_ioctl
+0x40/0x68)
<4> r8 =3D C006D068  r7 =3D 00000036  r6 =3D 40786E88  r5 =3D FFFFFFF7
<4> r4 =3D C51093A0=20
<4>[<c00ea988>] (sys_ioctl+0x0/0x68) from [<c006cec0>] (ret_fast_syscal=
l
+0x0/0x2c)
<4> r6 =3D 00015770  r5 =3D 00000028  r4 =3D 00000008=20
<4>Code: e2834008 e8940030 0a00000d e5101010 (e5d12000)=20
<4>=20


=C5=81ukasz W=C3=B3jcicki=20


 =20



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
