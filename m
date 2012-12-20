From: =?GB2312?B?1cUgwNo=?= <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NILFS: bad btree node
Date: Thu, 20 Dec 2012 18:16:08 +0800
Message-ID: <14BA4286-BF21-4BD3-8E41-2F8F9512D801@gmail.com>
References: <86B5C141-ACFA-4541-999F-E17E09F22476@gmail.com> <1355983713.2056.3.camel@slavad-ubuntu> <3455B0CD-EF89-4227-90E1-FC6B20F5F8EB@gmail.com> <1355996310.2056.28.camel@slavad-ubuntu>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:content-type:mime-version:subject:from:in-reply-to:date
         :cc:content-transfer-encoding:message-id:references:to:x-mailer;
        bh=PkLNxxcUiijqfF52kA0qzRyxZVm3wdtWfxvNi8Pa63c=;
        b=D19kJfmPc8g5WQwHZIr+3ejZfcZ/1FhKjk9TrFtS4hS70lHl/AwnaHC88fc3OltSZE
         aGUFB5MWuCO0N5m1lJXtNHU0jfvxdsSwU8RHgoeYb1P7lL4Dhz4q+Bd9So68aCd40ifM
         XOQ7R1K8ACi0zBX+q0qvUWax1zLnrOmOo0+F2oDA/Wf/hvdFNFARIcRUO9hiQ/uSJsA+
         zGdN+F/MCwWpFF/6rNp6A5EdRmez1E/zrnNQ+Q/D/qnFGJ/lk1v+GIINLW650Zyhfprl
         PqN+4dXrc3cP2uxzR9/E7SPBd8YJAruq7MT1aCJ+OZpeVXRNmHICXpCGKRYBsGnvRTOe
         mFXA==
In-Reply-To: <1355996310.2056.28.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="gb2312"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

1. Linux kernel version: 2.6.32-220.13.1.el6.x86_64=20
2. nilfs-utils version: nilfs-utils-2.1.4
3. "mount" output:
/dev/sdb2 on /data0 type nilfs2 (rw,noatime,gcpid=3D22909)=20

4. "df -h" output:
/dev/sdb2 9.6T 5.9T 3.2T 66% /data0=20

5. "lscp" output:
                 CNO        DATE     TIME  MODE  FLG     NBLKINC       =
ICNT
                   2  2012-12-03 14:03:01   ss    -           14       =
   3
              580481  2012-12-20 16:11:25   cp    -          293     69=
7667
              580482  2012-12-20 16:11:25   cp    -          130     69=
7666
              580483  2012-12-20 16:11:25   cp    -          225     69=
7664
              580484  2012-12-20 16:11:25   cp    -          143     69=
7663
              580485  2012-12-20 16:11:26   cp    -          311     69=
7659
              580486  2012-12-20 16:11:27   cp    -          328     69=
7657
              580487  2012-12-20 16:11:27   cp    -          263     69=
7655
              580488  2012-12-20 16:11:27   cp    -          118     69=
7653
              580489  2012-12-20 16:11:28   cp    -          230     69=
7651
              580490  2012-12-20 16:11:28   cp    -          272     69=
7649
              580491  2012-12-20 16:11:28   cp    -          148     69=
7648
              580492  2012-12-20 16:11:29   cp    -          139     69=
7647
              580493  2012-12-20 16:11:29   cp    -          273     69=
7645
              580494  2012-12-20 16:11:29   cp    -          147     69=
7644
              580495  2012-12-20 16:11:30   cp    -          271     69=
7641
              580496  2012-12-20 16:11:31   cp    -          526     69=
7636
              580497  2012-12-20 16:11:34   cp    -         1684     69=
7625
              580498  2012-12-20 16:11:37   cp    -          983     69=
7609
              580499  2012-12-20 16:11:38   cp    -          421     69=
7605
              580500  2012-12-20 16:11:40   cp    -         1019     69=
7594
              580501  2012-12-20 16:11:40   cp    -          143     69=
7593
              580502  2012-12-20 16:11:41   cp    -         1536     69=
7592
              580503  2012-12-20 16:11:41   cp    -          373     69=
7590
              580504  2012-12-20 16:11:42   cp    -          312     69=
7587
              580505  2012-12-20 16:11:42   cp    -          102     69=
7586
              580506  2012-12-20 16:11:43   cp    -          274     69=
7584
              580507  2012-12-20 16:11:43   cp    -          270     69=
7582
              580508  2012-12-20 16:11:43   cp    -          118     69=
7581
              580509  2012-12-20 16:11:43   cp    -          133     69=
7580
              580510  2012-12-20 16:11:44   cp    -          321     69=
7578
              580511  2012-12-20 16:11:44   cp    -          245     69=
7576
              580512  2012-12-20 16:11:45   cp    -          394     69=
7573
              580513  2012-12-20 16:11:45   cp    -          121     69=
7572
              580514  2012-12-20 16:11:45   cp    -          245     69=
7569
              580515  2012-12-20 16:11:52   cp    -         2705     69=
7543
              580516  2012-12-20 16:11:55   cp    -         2590     69=
7504
              580517  2012-12-20 16:11:59   cp    -         2418     69=
7453
              580518  2012-12-20 16:12:00   cp    -          866     69=
7436
              580519  2012-12-20 16:12:01   cp    -          864     69=
7420
              580520  2012-12-20 16:12:05   cp    -         1765     69=
7357
              580521  2012-12-20 16:12:05   cp    -          120     69=
7356
              580522  2012-12-20 16:12:06   cp    -          820     69=
7332
              580523  2012-12-20 16:12:09   cp    -         1642     69=
7174
              580524  2012-12-20 16:12:09   cp    -           89     69=
7173
              580525  2012-12-20 16:12:10   cp    -           56     69=
7173
              580526  2012-12-20 16:12:42   cp    -          763     69=
7173

6. "lssu" output:
	it's too large, please download it: http://d.pr/f/vnoR

7. "nilfs-tune -l" output (superblock content):

nilfs-tune 2.1.4
=46ilesystem volume name:	  (none)
=46ilesystem UUID:	  dcfb7152-a342-48d0-a712-212a3062395e
=46ilesystem magic number:  0x3434
=46ilesystem revision #:	  2.0
=46ilesystem features:      (none)
=46ilesystem state:	  invalid or mounted,error
=46ilesystem OS type:	  Linux
Block size:		  4096
=46ilesystem created:	  Mon Dec  3 13:56:51 2012
Last mount time:	  Thu Dec 20 17:44:03 2012
Last write time:	  Thu Dec 20 17:44:03 2012
Mount count:		  13
Maximum mount count:	  50
Reserve blocks uid:	  0 (user root)
Reserve blocks gid:	  0 (group root)
=46irst inode:		  11
Inode size:		  128
DAT entry size:		  32
Checkpoint size:	  192
Segment usage size:	  16
Number of segments:	  1246464
Device size:		  10456104173568
=46irst data block:	  1
# of blocks per segment:  2048
Reserved segments %:	  5
Last checkpoint #:	  580526
Last block address:	  1040286376
Last sequence #:	  1753809
=46ree blocks count:	  973875200
Commit interval:	  60
# of blks to create seg:  0
CRC seed:		  0x3adfb6c3
CRC check sum:		  0x8468fbbf
CRC check data size:	  0x00000118


I found this in /var/log/messages, perhaps it is related to the bad bre=
e node:

Dec 18 15:55:02 localhost kernel: rsync: page allocation failure. order=
:1, mode:0x20
Dec 18 15:55:02 localhost kernel: Pid: 13678, comm: rsync Not tainted 2=
=2E6.32-220.13.1.el6.x86_64 #1
Dec 18 15:55:02 localhost kernel: Call Trace:
Dec 18 15:55:02 localhost kernel: <IRQ>  [<ffffffff8112405f>] ? __alloc=
_pages_nodemask+0x77f/0x940
Dec 18 15:55:02 localhost kernel: [<ffffffff8115e002>] ? kmem_getpages+=
0x62/0x170
Dec 18 15:55:02 localhost kernel: [<ffffffff8115ec1a>] ? fallback_alloc=
+0x1ba/0x270
Dec 18 15:55:02 localhost kernel: [<ffffffff8115e66f>] ? cache_grow+0x2=
cf/0x320
Dec 18 15:55:02 localhost kernel: [<ffffffff8115e999>] ? ____cache_allo=
c_node+0x99/0x160
Dec 18 15:55:02 localhost kernel: [<ffffffff8115f77b>] ? kmem_cache_all=
oc+0x11b/0x190
Dec 18 15:55:02 localhost kernel: [<ffffffff8141f998>] ? sk_prot_alloc+=
0x48/0x1c0
Dec 18 15:55:02 localhost kernel: [<ffffffff8141fc22>] ? sk_clone+0x22/=
0x2e0
Dec 18 15:55:02 localhost kernel: [<ffffffff8146cee6>] ? inet_csk_clone=
+0x16/0xd0
Dec 18 15:55:02 localhost kernel: [<ffffffff81485dd3>] ? tcp_create_ope=
nreq_child+0x23/0x450
Dec 18 15:55:02 localhost kernel: [<ffffffff814837bd>] ? tcp_v4_syn_rec=
v_sock+0x4d/0x2a0
Dec 18 15:55:02 localhost kernel: [<ffffffff81485b91>] ? tcp_check_req+=
0x201/0x420
Dec 18 15:55:02 localhost kernel: [<ffffffff8147b646>] ? tcp_rcv_state_=
process+0x116/0xa30
Dec 18 15:55:02 localhost kernel: [<ffffffff8126a859>] ? cpumask_next_a=
nd+0x29/0x50
Dec 18 15:55:02 localhost kernel: [<ffffffff814831db>] ? tcp_v4_do_rcv+=
0x35b/0x430
Dec 18 15:55:02 localhost kernel: [<ffffffffa00dea69>] ? bnx2_start_xmi=
t+0x239/0x7d0 [bnx2]
Dec 18 15:55:02 localhost kernel: [<ffffffff81484951>] ? tcp_v4_rcv+0x4=
e1/0x860
Dec 18 15:55:02 localhost kernel: [<ffffffff814626bd>] ? ip_local_deliv=
er_finish+0xdd/0x2d0
Dec 18 15:55:02 localhost kernel: [<ffffffff81462948>] ? ip_local_deliv=
er+0x98/0xa0
Dec 18 15:55:02 localhost kernel: [<ffffffff81461e0d>] ? ip_rcv_finish+=
0x12d/0x440
Dec 18 15:55:02 localhost kernel: [<ffffffff81462395>] ? ip_rcv+0x275/0=
x350
Dec 18 15:55:02 localhost kernel: [<ffffffff8104d74e>] ? update_group_p=
ower+0xae/0x110
Dec 18 15:55:02 localhost kernel: [<ffffffff8142c34b>] ? __netif_receiv=
e_skb+0x49b/0x6f0
Dec 18 15:55:02 localhost kernel: [<ffffffff8142e408>] ? netif_receive_=
skb+0x58/0x60
Dec 18 15:55:02 localhost kernel: [<ffffffff8142e510>] ? napi_skb_finis=
h+0x50/0x70
Dec 18 15:55:02 localhost kernel: [<ffffffff81430b99>] ? napi_gro_recei=
ve+0x39/0x50
Dec 18 15:55:02 localhost kernel: [<ffffffffa00dfd4f>] ? bnx2_poll_work=
+0xd4f/0x1270 [bnx2]
Dec 18 15:55:02 localhost kernel: [<ffffffff8105ea43>] ? rebalance_doma=
ins+0xa3/0x5b0
Dec 18 15:55:02 localhost kernel: [<ffffffffa00e02ad>] ? bnx2_poll_msix=
+0x3d/0xc0 [bnx2]
Dec 18 15:55:02 localhost kernel: [<ffffffff81430cb3>] ? net_rx_action+=
0x103/0x2f0
Dec 18 15:55:02 localhost kernel: [<ffffffff81072191>] ? __do_softirq+0=
xc1/0x1d0
Dec 18 15:55:02 localhost kernel: [<ffffffff810d9640>] ? handle_IRQ_eve=
nt+0x60/0x170
Dec 18 15:55:02 localhost kernel: [<ffffffff810721ea>] ? __do_softirq+0=
x11a/0x1d0
Dec 18 15:55:02 localhost kernel: [<ffffffff8100c24c>] ? call_softirq+0=
x1c/0x30
Dec 18 15:55:02 localhost kernel: [<ffffffff8100de85>] ? do_softirq+0x6=
5/0xa0
Dec 18 15:55:02 localhost kernel: [<ffffffff81071f75>] ? irq_exit+0x85/=
0x90
Dec 18 15:55:02 localhost kernel: [<ffffffff814f5215>] ? do_IRQ+0x75/0x=
f0
Dec 18 15:55:02 localhost kernel: [<ffffffff8100ba53>] ? ret_from_intr+=
0x0/0x11
Dec 18 15:55:02 localhost kernel: <EOI>  [<ffffffffa02105d7>] ? nilfs_m=
ark_inode_dirty+0x37/0xa0 [nilfs2]
Dec 18 15:55:02 localhost kernel: [<ffffffffa02105d7>] ? nilfs_mark_ino=
de_dirty+0x37/0xa0 [nilfs2]
Dec 18 15:55:02 localhost kernel: [<ffffffffa02106aa>] ? nilfs_dirty_in=
ode+0x6a/0xa0 [nilfs2]
Dec 18 15:55:02 localhost kernel: [<ffffffff811a00bb>] ? __mark_inode_d=
irty+0x3b/0x160
Dec 18 15:55:02 localhost kernel: [<ffffffff811ab185>] ? generic_write_=
end+0x65/0xa0
Dec 18 15:55:02 localhost kernel: [<ffffffffa0210940>] ? nilfs_get_bloc=
k+0x0/0x1d0 [nilfs2]
Dec 18 15:55:02 localhost kernel: [<ffffffffa020f860>] ? nilfs_write_en=
d+0x70/0xb0 [nilfs2]
Dec 18 15:55:02 localhost kernel: [<ffffffffa020f230>] ? nilfs_write_be=
gin+0x80/0xb0 [nilfs2]
Dec 18 15:55:02 localhost kernel: [<ffffffff811115c4>] ? generic_file_b=
uffered_write+0x174/0x2a0
Dec 18 15:55:02 localhost kernel: [<ffffffff810707c7>] ? current_fs_tim=
e+0x27/0x30
Dec 18 15:55:02 localhost kernel: [<ffffffff81112eb0>] ? __generic_file=
_aio_write+0x250/0x480
Dec 18 15:55:02 localhost kernel: [<ffffffff8111314f>] ? generic_file_a=
io_write+0x6f/0xe0
Dec 18 15:55:02 localhost kernel: [<ffffffff8117651a>] ? do_sync_write+=
0xfa/0x140
Dec 18 15:55:02 localhost kernel: [<ffffffff81090c30>] ? autoremove_wak=
e_function+0x0/0x40
Dec 18 15:55:02 localhost kernel: [<ffffffff8109b849>] ? ktime_get_ts+0=
xa9/0xe0
Dec 18 15:55:02 localhost kernel: [<ffffffff8120c546>] ? security_file_=
permission+0x16/0x20
Dec 18 15:55:02 localhost kernel: [<ffffffff81176818>] ? vfs_write+0xb8=
/0x1a0
Dec 18 15:55:02 localhost kernel: [<ffffffff81177221>] ? sys_write+0x51=
/0x90
Dec 18 15:55:02 localhost kernel: [<ffffffff8100b0f2>] ? system_call_fa=
stpath+0x16/0x1b



=D4=DA 2012-12-20=A3=AC17:38=A3=ACVyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org=
> =D0=B4=B5=C0=A3=BA

> On Thu, 2012-12-20 at 17:08 +0800, =D5=C5 =C0=DA wrote:
>> Hi,
>>=20
>> I remounted the filesystem, and started the MySQLs. The filesytstem =
became readonly again.
>>=20
>> Dec 20 16:03:31 localhost kernel: segctord starting. Construction in=
terval =3D 60 seconds, CP frequency < 30 seconds
>> Dec 20 16:03:31 localhost kernel: NILFS warning: mounting fs with er=
rors
>> Dec 20 16:03:31 localhost nilfs_cleanerd[29120]: start
>> Dec 20 16:03:55 localhost kernel: NILFS: bad btree node (blocknr=3D7=
10153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
>> Dec 20 16:03:55 localhost kernel: NILFS error (device sdb2): nilfs_b=
map_lookup_contig: broken bmap (inode number=3D321775)
>> Dec 20 16:03:55 localhost kernel:
>> Dec 20 16:03:55 localhost kernel: Remounting filesystem read-only
>> Dec 20 16:03:55 localhost kernel: NILFS: bad btree node (blocknr=3D7=
10153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
>> Dec 20 16:03:55 localhost kernel: NILFS error (device sdb2): nilfs_b=
map_lookup_contig: broken bmap (inode number=3D321775)
>> Dec 20 16:03:55 localhost kernel:
>> Dec 20 16:03:57 localhost nilfs_cleanerd[29120]: cannot clean segmen=
ts: Read-only file system
>> Dec 20 16:03:57 localhost nilfs_cleanerd[29120]: shutdown
>>=20
>> I remounted the filesystem again, and tried to delete the bad files,=
 but delete failed.
>>=20
>> Dec 20 16:04:02 localhost kernel: segctord starting. Construction in=
terval =3D 60 seconds, CP frequency < 30 seconds
>> Dec 20 16:04:02 localhost kernel: NILFS warning: mounting fs with er=
rors
>> Dec 20 16:04:02 localhost nilfs_cleanerd[30054]: start
>> Dec 20 16:12:08 localhost kernel: NILFS: bad btree node (blocknr=3D7=
10153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
>> Dec 20 16:12:08 localhost kernel: NILFS error (device sdb2): nilfs_b=
map_last_key: broken bmap (inode number=3D321775)
>> Dec 20 16:12:08 localhost kernel:
>> Dec 20 16:12:08 localhost kernel: Remounting filesystem read-only
>> Dec 20 16:12:08 localhost kernel: NILFS warning (device sdb2): nilfs=
_truncate_bmap: failed to truncate bmap (ino=3D321775, err=3D-5)
>> Dec 20 16:12:08 localhost nilfs_cleanerd[30054]: cannot clean segmen=
ts: Read-only file system
>> Dec 20 16:12:08 localhost nilfs_cleanerd[30054]: shutdown
>>=20
>> I tried a third remount, but failed. The server was down, and restar=
ted.
>>=20
>> Dec 20 16:12:42 localhost kernel: NILFS warning (device sdb2): nilfs=
_detach_log_writer: Hit dirty file after stopped log writer
>> Dec 20 16:12:42 localhost kernel:
>>=20
>=20
> Yes, it is bad. The remount solves the trouble earlier.
>=20
> As a result, do you have NILFS2 volume mounted as read-only?
>=20
> Could you share more details about your environment? It needs for
> understanding situation and trying to reproduce. I need to know:
> 1. Linux kernel version.
> 2. nilfs-utils version.
> 3. "mount" output.
> 4. "df -h" output.
> 5. "lscp" output.
> 6. "lssu" output.
> 7. "nilfs-tune -l" output (superblock content)
>=20
>> I found that fsck.nilfs2 was added into nilfs-utils v4. Can I try it=
? Where can I download nilfs-utils v4?
>>=20
>=20
> Last version of nilfs-utils is 2.1.4. Currently, fsck.nilfs2 is on ea=
rly
> stage of development. The v4 is a fsck.nilfs2 patchset version. You c=
an
> try fsck.nilfs2 after applying this patchset on source code of
> nilfs-utils of 2.1.4 version. But fsck.nilfs2 can check only superblo=
cks
> and segment summary headers and can't recover completely. So, I think
> that it will be useless for you.
>=20
> With the best regards,
> Vyacheslav Dubeyko.
>=20
>> =D4=DA 2012-12-20=A3=AC14:08=A3=ACVyacheslav Dubeyko <slava@dubeyko.=
com> =D0=B4=B5=C0=A3=BA
>>=20
>>> Hi,
>>>=20
>>> On Thu, 2012-12-20 at 10:46 +0800, =D5=C5 =C0=DA wrote:
>>>> Hello.
>>>> 	My nilfs suddenly become read-only. I saw these logs in /var/log/=
messages:
>>>>=20
>>>> Dec 19 11:20:05 localhost kernel: NILFS: bad btree node (blocknr=3D=
710153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
>>>> Dec 19 11:20:05 localhost kernel: NILFS error (device sdb2): nilfs=
_bmap_lookup_contig: broken bmap (inode number=3D321775)
>>>> Dec 19 11:20:05 localhost kernel:
>>>> Dec 19 11:20:05 localhost kernel: Remounting filesystem read-only
>>>> Dec 19 11:20:05 localhost kernel: NILFS: bad btree node (blocknr=3D=
710153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
>>>> Dec 19 11:20:05 localhost kernel: NILFS error (device sdb2): nilfs=
_bmap_lookup_contig: broken bmap (inode number=3D321775)
>>>> Dec 19 11:20:05 localhost kernel:
>>>> Dec 19 11:20:05 localhost kernel: NILFS: bad btree node (blocknr=3D=
710153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
>>>> Dec 19 11:20:05 localhost kernel: NILFS error (device sdb2): nilfs=
_bmap_lookup_contig: broken bmap (inode number=3D321775)
>>>> Dec 19 11:20:05 localhost kernel:
>>>> Dec 19 11:20:05 localhost kernel: NILFS: bad btree node (blocknr=3D=
710153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
>>>> Dec 19 11:20:05 localhost kernel: NILFS error (device sdb2): nilfs=
_bmap_lookup_contig: broken bmap (inode number=3D321775)
>>>> Dec 19 11:20:05 localhost kernel:
>>>> =A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=
=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD
>>>>=20
>>>> 	How can I fix this? There is 6TiB data on my disk, I don't want t=
o format the disk.
>>>> 	I found that a lot of people have encountered the same problem. I=
s this a bug of nilfs? How can I avoid this problem? When it happens, I=
 was running multiple MySQL and rsync, and nilfs_cleanerd was cleaning =
segments.
>>>>=20
>>>=20
>>> Yes, this issue was reported earlier. As I understand, you can simp=
ly
>>> remount your filesystem in read-write mode and to continue using yo=
ur
>>> NILFS2 filesystem.
>>>=20
>>> If you will encounter any troubles with remounting, please, report =
about
>>> it.
>>>=20
>>> With the best regards,
>>> Vyacheslav Dubeyko.
>>>=20
>>>=20
>>>> Elmer Zhang--
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ni=
lfs" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>=20
>>>=20
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-nil=
fs" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
