From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS: bad btree node
Date: Thu, 20 Dec 2012 14:41:52 +0400
Message-ID: <1356000112.2056.33.camel@slavad-ubuntu>
References: <86B5C141-ACFA-4541-999F-E17E09F22476@gmail.com>
	 <1355983713.2056.3.camel@slavad-ubuntu>
	 <3455B0CD-EF89-4227-90E1-FC6B20F5F8EB@gmail.com>
	 <1355996310.2056.28.camel@slavad-ubuntu>
	 <14BA4286-BF21-4BD3-8E41-2F8F9512D801@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=+xpBOoqBkE5In9ARTzqNH95TCMfrdrR2yODCuSQgUjE=;
	b=iVqH3p8QFvtFaSmsDmEld+zG5/xqXU9XqPU9UVNBdTiaIT5IHtmte5FDjAyUd3byuvjKsVwtVDIqOPtCdhHE6qYlOYVyqFR3KWCCiPNjiysQzFDfGETUfnUa7hK62Uqi;
In-Reply-To: <14BA4286-BF21-4BD3-8E41-2F8F9512D801-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?=E5=BC=A0_=E7=A3=8A?= <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 2012-12-20 at 18:16 +0800, =E5=BC=A0 =E7=A3=8A wrote:

Thank you for info.

[snip]
> 3. "mount" output:
> /dev/sdb2 on /data0 type nilfs2 (rw,noatime,gcpid=3D22909)=20
>=20

As I can see, you have NILFS2 volume mounted as read-write. Am I
correct?

[snip]

>=20
> I found this in /var/log/messages, perhaps it is related to the bad b=
ree node:
>=20
> Dec 18 15:55:02 localhost kernel: rsync: page allocation failure. ord=
er:1, mode:0x20
> Dec 18 15:55:02 localhost kernel: Pid: 13678, comm: rsync Not tainted=
 2.6.32-220.13.1.el6.x86_64 #1
> Dec 18 15:55:02 localhost kernel: Call Trace:
> Dec 18 15:55:02 localhost kernel: <IRQ>  [<ffffffff8112405f>] ? __all=
oc_pages_nodemask+0x77f/0x940
> Dec 18 15:55:02 localhost kernel: [<ffffffff8115e002>] ? kmem_getpage=
s+0x62/0x170
> Dec 18 15:55:02 localhost kernel: [<ffffffff8115ec1a>] ? fallback_all=
oc+0x1ba/0x270
> Dec 18 15:55:02 localhost kernel: [<ffffffff8115e66f>] ? cache_grow+0=
x2cf/0x320
> Dec 18 15:55:02 localhost kernel: [<ffffffff8115e999>] ? ____cache_al=
loc_node+0x99/0x160
> Dec 18 15:55:02 localhost kernel: [<ffffffff8115f77b>] ? kmem_cache_a=
lloc+0x11b/0x190
> Dec 18 15:55:02 localhost kernel: [<ffffffff8141f998>] ? sk_prot_allo=
c+0x48/0x1c0
> Dec 18 15:55:02 localhost kernel: [<ffffffff8141fc22>] ? sk_clone+0x2=
2/0x2e0
> Dec 18 15:55:02 localhost kernel: [<ffffffff8146cee6>] ? inet_csk_clo=
ne+0x16/0xd0
> Dec 18 15:55:02 localhost kernel: [<ffffffff81485dd3>] ? tcp_create_o=
penreq_child+0x23/0x450
> Dec 18 15:55:02 localhost kernel: [<ffffffff814837bd>] ? tcp_v4_syn_r=
ecv_sock+0x4d/0x2a0
> Dec 18 15:55:02 localhost kernel: [<ffffffff81485b91>] ? tcp_check_re=
q+0x201/0x420
> Dec 18 15:55:02 localhost kernel: [<ffffffff8147b646>] ? tcp_rcv_stat=
e_process+0x116/0xa30
> Dec 18 15:55:02 localhost kernel: [<ffffffff8126a859>] ? cpumask_next=
_and+0x29/0x50
> Dec 18 15:55:02 localhost kernel: [<ffffffff814831db>] ? tcp_v4_do_rc=
v+0x35b/0x430
> Dec 18 15:55:02 localhost kernel: [<ffffffffa00dea69>] ? bnx2_start_x=
mit+0x239/0x7d0 [bnx2]
> Dec 18 15:55:02 localhost kernel: [<ffffffff81484951>] ? tcp_v4_rcv+0=
x4e1/0x860
> Dec 18 15:55:02 localhost kernel: [<ffffffff814626bd>] ? ip_local_del=
iver_finish+0xdd/0x2d0
> Dec 18 15:55:02 localhost kernel: [<ffffffff81462948>] ? ip_local_del=
iver+0x98/0xa0
> Dec 18 15:55:02 localhost kernel: [<ffffffff81461e0d>] ? ip_rcv_finis=
h+0x12d/0x440
> Dec 18 15:55:02 localhost kernel: [<ffffffff81462395>] ? ip_rcv+0x275=
/0x350
> Dec 18 15:55:02 localhost kernel: [<ffffffff8104d74e>] ? update_group=
_power+0xae/0x110
> Dec 18 15:55:02 localhost kernel: [<ffffffff8142c34b>] ? __netif_rece=
ive_skb+0x49b/0x6f0
> Dec 18 15:55:02 localhost kernel: [<ffffffff8142e408>] ? netif_receiv=
e_skb+0x58/0x60
> Dec 18 15:55:02 localhost kernel: [<ffffffff8142e510>] ? napi_skb_fin=
ish+0x50/0x70
> Dec 18 15:55:02 localhost kernel: [<ffffffff81430b99>] ? napi_gro_rec=
eive+0x39/0x50
> Dec 18 15:55:02 localhost kernel: [<ffffffffa00dfd4f>] ? bnx2_poll_wo=
rk+0xd4f/0x1270 [bnx2]
> Dec 18 15:55:02 localhost kernel: [<ffffffff8105ea43>] ? rebalance_do=
mains+0xa3/0x5b0
> Dec 18 15:55:02 localhost kernel: [<ffffffffa00e02ad>] ? bnx2_poll_ms=
ix+0x3d/0xc0 [bnx2]
> Dec 18 15:55:02 localhost kernel: [<ffffffff81430cb3>] ? net_rx_actio=
n+0x103/0x2f0
> Dec 18 15:55:02 localhost kernel: [<ffffffff81072191>] ? __do_softirq=
+0xc1/0x1d0
> Dec 18 15:55:02 localhost kernel: [<ffffffff810d9640>] ? handle_IRQ_e=
vent+0x60/0x170
> Dec 18 15:55:02 localhost kernel: [<ffffffff810721ea>] ? __do_softirq=
+0x11a/0x1d0
> Dec 18 15:55:02 localhost kernel: [<ffffffff8100c24c>] ? call_softirq=
+0x1c/0x30
> Dec 18 15:55:02 localhost kernel: [<ffffffff8100de85>] ? do_softirq+0=
x65/0xa0
> Dec 18 15:55:02 localhost kernel: [<ffffffff81071f75>] ? irq_exit+0x8=
5/0x90
> Dec 18 15:55:02 localhost kernel: [<ffffffff814f5215>] ? do_IRQ+0x75/=
0xf0
> Dec 18 15:55:02 localhost kernel: [<ffffffff8100ba53>] ? ret_from_int=
r+0x0/0x11
> Dec 18 15:55:02 localhost kernel: <EOI>  [<ffffffffa02105d7>] ? nilfs=
_mark_inode_dirty+0x37/0xa0 [nilfs2]
> Dec 18 15:55:02 localhost kernel: [<ffffffffa02105d7>] ? nilfs_mark_i=
node_dirty+0x37/0xa0 [nilfs2]
> Dec 18 15:55:02 localhost kernel: [<ffffffffa02106aa>] ? nilfs_dirty_=
inode+0x6a/0xa0 [nilfs2]
> Dec 18 15:55:02 localhost kernel: [<ffffffff811a00bb>] ? __mark_inode=
_dirty+0x3b/0x160
> Dec 18 15:55:02 localhost kernel: [<ffffffff811ab185>] ? generic_writ=
e_end+0x65/0xa0
> Dec 18 15:55:02 localhost kernel: [<ffffffffa0210940>] ? nilfs_get_bl=
ock+0x0/0x1d0 [nilfs2]
> Dec 18 15:55:02 localhost kernel: [<ffffffffa020f860>] ? nilfs_write_=
end+0x70/0xb0 [nilfs2]
> Dec 18 15:55:02 localhost kernel: [<ffffffffa020f230>] ? nilfs_write_=
begin+0x80/0xb0 [nilfs2]
> Dec 18 15:55:02 localhost kernel: [<ffffffff811115c4>] ? generic_file=
_buffered_write+0x174/0x2a0
> Dec 18 15:55:02 localhost kernel: [<ffffffff810707c7>] ? current_fs_t=
ime+0x27/0x30
> Dec 18 15:55:02 localhost kernel: [<ffffffff81112eb0>] ? __generic_fi=
le_aio_write+0x250/0x480
> Dec 18 15:55:02 localhost kernel: [<ffffffff8111314f>] ? generic_file=
_aio_write+0x6f/0xe0
> Dec 18 15:55:02 localhost kernel: [<ffffffff8117651a>] ? do_sync_writ=
e+0xfa/0x140
> Dec 18 15:55:02 localhost kernel: [<ffffffff81090c30>] ? autoremove_w=
ake_function+0x0/0x40
> Dec 18 15:55:02 localhost kernel: [<ffffffff8109b849>] ? ktime_get_ts=
+0xa9/0xe0
> Dec 18 15:55:02 localhost kernel: [<ffffffff8120c546>] ? security_fil=
e_permission+0x16/0x20
> Dec 18 15:55:02 localhost kernel: [<ffffffff81176818>] ? vfs_write+0x=
b8/0x1a0
> Dec 18 15:55:02 localhost kernel: [<ffffffff81177221>] ? sys_write+0x=
51/0x90
> Dec 18 15:55:02 localhost kernel: [<ffffffff8100b0f2>] ? system_call_=
fastpath+0x16/0x1b
>=20

Is it full backtrace? Or do you have any additional info in your syslog=
?

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
