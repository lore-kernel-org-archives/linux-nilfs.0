From: =?GB2312?B?1cUgwNo=?= <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NILFS: bad btree node
Date: Thu, 20 Dec 2012 19:02:09 +0800
Message-ID: <44056E9A-3487-4E8A-A56A-5B9228FC7895@gmail.com>
References: <86B5C141-ACFA-4541-999F-E17E09F22476@gmail.com> <1355983713.2056.3.camel@slavad-ubuntu> <3455B0CD-EF89-4227-90E1-FC6B20F5F8EB@gmail.com> <1355996310.2056.28.camel@slavad-ubuntu> <14BA4286-BF21-4BD3-8E41-2F8F9512D801@gmail.com> <1356000112.2056.33.camel@slavad-ubuntu>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:content-type:mime-version:subject:from:in-reply-to:date
         :cc:content-transfer-encoding:message-id:references:to:x-mailer;
        bh=A+g8weNOQiINn7VZ92/WH9y0Ux3/lg29Y2ByYfMk9Wo=;
        b=c2gZCXORKRCqQXF7k1zdpSji1ugAH/6MvfO1oQytpmeTA/qqldtAmXNNRY928/pUaX
         DzsQhskcrtVrlqGbBIfFuiB2iqeiDNPSmRJKii+kZR9OqHB7aCoGHMTPtjRArr9SA3Zu
         wLHbG4jYLFDoxpKtp4jKk3r+Cp56BFzLRG9ycbdL1NeIuavd2g+IrCKiV79Ta+5Xqqun
         poBYMfSqXx0AHQjnXREoA/crK49i+6dHQOiOzy1dS5cRfadlgltRqkeVrjLuOG4KXmNb
         bqylKAw5d82OHX+uf8jKaW24gmfF04kSgexbFF/CfmT22W25IGuZ++YDc3ihj43mNj2H
         Ef3g==
In-Reply-To: <1356000112.2056.33.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Yes, I mounted NILFS2 as read-write. It's remounted as read-only by ker=
nel when filesystem found the bad btree node.

That's the full backtrace. I will keep on testing, and report more info=
mation once I found.

=D4=DA 2012-12-20=A3=AC18:41=A3=ACVyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org=
> =D0=B4=B5=C0=A3=BA

> On Thu, 2012-12-20 at 18:16 +0800, =D5=C5 =C0=DA wrote:
>=20
> Thank you for info.
>=20
> [snip]
>> 3. "mount" output:
>> /dev/sdb2 on /data0 type nilfs2 (rw,noatime,gcpid=3D22909)=20
>>=20
>=20
> As I can see, you have NILFS2 volume mounted as read-write. Am I
> correct?
>=20
> [snip]
>=20
>>=20
>> I found this in /var/log/messages, perhaps it is related to the bad =
bree node:
>>=20
>> Dec 18 15:55:02 localhost kernel: rsync: page allocation failure. or=
der:1, mode:0x20
>> Dec 18 15:55:02 localhost kernel: Pid: 13678, comm: rsync Not tainte=
d 2.6.32-220.13.1.el6.x86_64 #1
>> Dec 18 15:55:02 localhost kernel: Call Trace:
>> Dec 18 15:55:02 localhost kernel: <IRQ>  [<ffffffff8112405f>] ? __al=
loc_pages_nodemask+0x77f/0x940
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8115e002>] ? kmem_getpag=
es+0x62/0x170
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8115ec1a>] ? fallback_al=
loc+0x1ba/0x270
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8115e66f>] ? cache_grow+=
0x2cf/0x320
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8115e999>] ? ____cache_a=
lloc_node+0x99/0x160
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8115f77b>] ? kmem_cache_=
alloc+0x11b/0x190
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8141f998>] ? sk_prot_all=
oc+0x48/0x1c0
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8141fc22>] ? sk_clone+0x=
22/0x2e0
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8146cee6>] ? inet_csk_cl=
one+0x16/0xd0
>> Dec 18 15:55:02 localhost kernel: [<ffffffff81485dd3>] ? tcp_create_=
openreq_child+0x23/0x450
>> Dec 18 15:55:02 localhost kernel: [<ffffffff814837bd>] ? tcp_v4_syn_=
recv_sock+0x4d/0x2a0
>> Dec 18 15:55:02 localhost kernel: [<ffffffff81485b91>] ? tcp_check_r=
eq+0x201/0x420
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8147b646>] ? tcp_rcv_sta=
te_process+0x116/0xa30
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8126a859>] ? cpumask_nex=
t_and+0x29/0x50
>> Dec 18 15:55:02 localhost kernel: [<ffffffff814831db>] ? tcp_v4_do_r=
cv+0x35b/0x430
>> Dec 18 15:55:02 localhost kernel: [<ffffffffa00dea69>] ? bnx2_start_=
xmit+0x239/0x7d0 [bnx2]
>> Dec 18 15:55:02 localhost kernel: [<ffffffff81484951>] ? tcp_v4_rcv+=
0x4e1/0x860
>> Dec 18 15:55:02 localhost kernel: [<ffffffff814626bd>] ? ip_local_de=
liver_finish+0xdd/0x2d0
>> Dec 18 15:55:02 localhost kernel: [<ffffffff81462948>] ? ip_local_de=
liver+0x98/0xa0
>> Dec 18 15:55:02 localhost kernel: [<ffffffff81461e0d>] ? ip_rcv_fini=
sh+0x12d/0x440
>> Dec 18 15:55:02 localhost kernel: [<ffffffff81462395>] ? ip_rcv+0x27=
5/0x350
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8104d74e>] ? update_grou=
p_power+0xae/0x110
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8142c34b>] ? __netif_rec=
eive_skb+0x49b/0x6f0
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8142e408>] ? netif_recei=
ve_skb+0x58/0x60
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8142e510>] ? napi_skb_fi=
nish+0x50/0x70
>> Dec 18 15:55:02 localhost kernel: [<ffffffff81430b99>] ? napi_gro_re=
ceive+0x39/0x50
>> Dec 18 15:55:02 localhost kernel: [<ffffffffa00dfd4f>] ? bnx2_poll_w=
ork+0xd4f/0x1270 [bnx2]
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8105ea43>] ? rebalance_d=
omains+0xa3/0x5b0
>> Dec 18 15:55:02 localhost kernel: [<ffffffffa00e02ad>] ? bnx2_poll_m=
six+0x3d/0xc0 [bnx2]
>> Dec 18 15:55:02 localhost kernel: [<ffffffff81430cb3>] ? net_rx_acti=
on+0x103/0x2f0
>> Dec 18 15:55:02 localhost kernel: [<ffffffff81072191>] ? __do_softir=
q+0xc1/0x1d0
>> Dec 18 15:55:02 localhost kernel: [<ffffffff810d9640>] ? handle_IRQ_=
event+0x60/0x170
>> Dec 18 15:55:02 localhost kernel: [<ffffffff810721ea>] ? __do_softir=
q+0x11a/0x1d0
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8100c24c>] ? call_softir=
q+0x1c/0x30
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8100de85>] ? do_softirq+=
0x65/0xa0
>> Dec 18 15:55:02 localhost kernel: [<ffffffff81071f75>] ? irq_exit+0x=
85/0x90
>> Dec 18 15:55:02 localhost kernel: [<ffffffff814f5215>] ? do_IRQ+0x75=
/0xf0
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8100ba53>] ? ret_from_in=
tr+0x0/0x11
>> Dec 18 15:55:02 localhost kernel: <EOI>  [<ffffffffa02105d7>] ? nilf=
s_mark_inode_dirty+0x37/0xa0 [nilfs2]
>> Dec 18 15:55:02 localhost kernel: [<ffffffffa02105d7>] ? nilfs_mark_=
inode_dirty+0x37/0xa0 [nilfs2]
>> Dec 18 15:55:02 localhost kernel: [<ffffffffa02106aa>] ? nilfs_dirty=
_inode+0x6a/0xa0 [nilfs2]
>> Dec 18 15:55:02 localhost kernel: [<ffffffff811a00bb>] ? __mark_inod=
e_dirty+0x3b/0x160
>> Dec 18 15:55:02 localhost kernel: [<ffffffff811ab185>] ? generic_wri=
te_end+0x65/0xa0
>> Dec 18 15:55:02 localhost kernel: [<ffffffffa0210940>] ? nilfs_get_b=
lock+0x0/0x1d0 [nilfs2]
>> Dec 18 15:55:02 localhost kernel: [<ffffffffa020f860>] ? nilfs_write=
_end+0x70/0xb0 [nilfs2]
>> Dec 18 15:55:02 localhost kernel: [<ffffffffa020f230>] ? nilfs_write=
_begin+0x80/0xb0 [nilfs2]
>> Dec 18 15:55:02 localhost kernel: [<ffffffff811115c4>] ? generic_fil=
e_buffered_write+0x174/0x2a0
>> Dec 18 15:55:02 localhost kernel: [<ffffffff810707c7>] ? current_fs_=
time+0x27/0x30
>> Dec 18 15:55:02 localhost kernel: [<ffffffff81112eb0>] ? __generic_f=
ile_aio_write+0x250/0x480
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8111314f>] ? generic_fil=
e_aio_write+0x6f/0xe0
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8117651a>] ? do_sync_wri=
te+0xfa/0x140
>> Dec 18 15:55:02 localhost kernel: [<ffffffff81090c30>] ? autoremove_=
wake_function+0x0/0x40
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8109b849>] ? ktime_get_t=
s+0xa9/0xe0
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8120c546>] ? security_fi=
le_permission+0x16/0x20
>> Dec 18 15:55:02 localhost kernel: [<ffffffff81176818>] ? vfs_write+0=
xb8/0x1a0
>> Dec 18 15:55:02 localhost kernel: [<ffffffff81177221>] ? sys_write+0=
x51/0x90
>> Dec 18 15:55:02 localhost kernel: [<ffffffff8100b0f2>] ? system_call=
_fastpath+0x16/0x1b
>>=20
>=20
> Is it full backtrace? Or do you have any additional info in your sysl=
og?
>=20
> With the best regards,
> Vyacheslav Dubeyko.
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
