From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Kernel Bug: unable to handle kernel paging request
Date: Thu, 18 Jul 2013 21:30:58 +0400
Message-ID: <F4156394-8A25-4F81-81C3-9921CB00BD92@dubeyko.com>
References: <CALJXSJquK6YxGKuH97Ec2CTMyJaZrJjOfePSKtgPDm8_9YXzzw@mail.gmail.com> <CALJXSJoW9Qpp9t42u_k4cW3gO6qzSPoeCjtQDU3tDKq6TJ=K8Q@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=7uAW5a2Vx1fF0mrCe3y5r5BZ1YzrPVFePk6EegPjsFc=;
	b=SD0UVzrReTrwYBTcYWdJ7/CVDDqzVeShAGBFOf7V+qsNHgoiM+Rxlo8nzKMHaiawP29e+DFThk7WqwkZks/wLYbVazIRZDUBv3c9+x3w19cvdwXERt0dWZFKSS+RcVD8;
In-Reply-To: <CALJXSJoW9Qpp9t42u_k4cW3gO6qzSPoeCjtQDU3tDKq6TJ=K8Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi J=E9r=F4me,

On Jul 12, 2013, at 10:58 PM, J=E9r=F4me Poulin wrote:

Thank you for details. Sorry for delay with answer. I were on vacation.

> The problem happened again today after resume, it seems to be more
> frequent since last week. Here is a pastebin of the traceback +
> sysrq+W.
>=20
> http://pastebin.ca/2426059
>=20

Unfortunately, currently I haven't access to this share.

> On Fri, Jul 12, 2013 at 1:24 AM, J=E9r=F4me Poulin <jeromepoulin@gmai=
l.com> wrote:
>> In response to Vyacheslav Dubeyko, here is the problem I encounter,
>> I'm not sure how to reproduce it now, but before deleting
>> /var/cache/apt, I was able to reproduce it by issuing apt-get update=
=2E
>> Now, it triggers when Ubuntu launches the apt daemon. Afterward, the
>> whole system is frozen, not even SysRq+I would return me to the
>> console.
>>=20

So, as I see, the reproducing path is: (1) delete /var/cache/apt; (2) i=
ssue apt-get update.

Could you share additional details about the issue on your side?

I mean such details:
(1) The strace output for the case of issuing the apt-get update (in th=
e case of issue reproducing).
(2) I need more details about your NILFS2 partition. Could you share ou=
tput of "nilfs-tune -l"?

Thanks,
Vyacheslav Dubeyko.

>> After setting the log in another partition, here is what I have in s=
yslog:
>>=20
>> Jul 12 01:08:43 bluetoothd[635]: Stopping discovery
>> Jul 12 01:10:43 dbus[622]: [system] Activating service
>> name=3D'org.freedesktop.PackageKit' (using servicehelper)
>> Jul 12 01:10:43 AptDaemon: INFO: Initializing daemon
>> Jul 12 01:10:43 AptDaemon.PackageKit: INFO: Initializing PackageKit =
compat layer
>> Jul 12 01:10:43 dbus[622]: [system] Successfully activated service
>> 'org.freedesktop.PackageKit'
>> [ 1677.310656] BUG: unable to handle kernel paging request at 000000=
0000004c83
>> [ 1677.310683] IP: [<ffffffffa024d0f2>] nilfs_end_page_io+0x12/0xd0 =
[nilfs2]
>> [ 1677.310708] PGD 0
>> [ 1677.310715] Oops: 0000 [#1] SMP
>> [ 1677.310726] Modules linked in: pci_stub vboxpci(OF) vboxnetadp(OF=
)
>> vboxnetflt(OF) vboxdrv(OF) nfsd(F) auth_rpcgss(F) nfs_acl(F) lockd(F=
)
>> sunrpc(F) dm_crypt(F) bbswitch(OF) zram(C) intel_powerclamp kvm_inte=
l
>> kvm parport_pc(F) ppdev(F) lp(F) uvcvideo parport(F) crc32_pclmul(F)
>> ghash_clmulni_intel(F) aesni_intel(F) snd_hda_codec_realtek
>> snd_hda_intel snd_hda_codec aes_x86_64(F) asus_wmi lrw(F)
>> sparse_keymap gf128mul(F) snd_hwdep(F) glue_helper(F) ablk_helper(F)
>> arc4(F) snd_pcm(F) cryptd(F) joydev(F) videobuf2_vmalloc
>> videobuf2_memops videobuf2_core mxm_wmi iwldvm snd_page_alloc(F) bne=
p
>> snd_seq_midi(F) videodev snd_seq_midi_event(F) snd_rawmidi(F) mac802=
11
>> snd_seq(F) snd_seq_device(F) btusb snd_timer(F) iwlwifi snd(F)
>> soundcore(F) microcode(F) psmouse(F) rfcomm bluetooth serio_raw(F)
>> cfg80211 lpc_ich mei_me wmi mei mac_hid coretemp binfmt_misc(F) nilf=
s2
>> btrfs(F) xor(F) zlib_deflate(F) raid6_pq(F) libcrc32c(F) nbd(F) i915
>> i2c_algo_bit drm_kms_helper drm alx mdio ahci(F) libahci(F) vi
>> deo(F) [last unloaded: ipmi_msghandler]
>> [ 1677.311066] CPU: 7 PID: 414 Comm: segctord Tainted: GF        C O
>> 3.10.0-2-generic #10-Ubuntu
>> [ 1677.311096] Hardware name: ASUSTeK COMPUTER INC. N56VZ/N56VZ, BIO=
S
>> N56VZ.216 12/06/2012
>> [ 1677.311124] task: ffff88021c484650 ti: ffff88021eaa2000 task.ti:
>> ffff88021eaa2000
>> [ 1677.311155] RIP: 0010:[<ffffffffa024d0f2>]  [<ffffffffa024d0f2>]
>> nilfs_end_page_io+0x12/0xd0 [nilfs2]
>> [ 1677.311199] RSP: 0000:ffff88021eaa3d00  EFLAGS: 00010202
>> [ 1677.311218] RAX: ffff880167625180 RBX: 0000000000004c83 RCX: 0000=
000000000034
>> [ 1677.311248] RDX: 000000000000000d RSI: 0000000000000000 RDI: 0000=
000000004c83
>> [ 1677.311277] RBP: ffff88021eaa3d08 R08: 7800000000000000 R09: a800=
1fa0bc000000
>> [ 1677.311305] R10: 57ffca5f4be82f00 R11: 0000000000000019 R12: ffff=
880213f46288
>> [ 1677.311328] R13: 0000000000000000 R14: ffffea0007321f80 R15: ffff=
880167625138
>> [ 1677.311353] FS:  0000000000000000(0000) GS:ffff88022efc0000(0000)
>> knlGS:0000000000000000
>> [ 1677.311383] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [ 1677.311403] CR2: 0000000000004c83 CR3: 0000000001c0e000 CR4: 0000=
0000001407e0
>> [ 1677.311428] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000=
000000000000
>> [ 1677.311455] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000=
000000000400
>> [ 1677.311478] Stack:
>> [ 1677.311487]  ffff880213f461e0 ffff88021eaa3e00 ffffffffa024e4c5
>> ffffffff81019d09
>> [ 1677.311520]  ffff88021c484650 ffff88021c484650 ffff88021c484650
>> ffff880221282270
>> [ 1677.311541]  ffff88021e691f58 ffff88021e691e00 ffff880221282260
>> 000000031c484650
>> [ 1677.311562] Call Trace:
>> [ 1677.311575]  [<ffffffffa024e4c5>]
>> nilfs_segctor_do_construct+0xf25/0x1b20 [nilfs2]
>> [ 1677.311596]  [<ffffffff81019d09>] ? sched_clock+0x9/0x10
>> [ 1677.311614]  [<ffffffffa024f3ab>]
>> nilfs_segctor_construct+0x17b/0x290 [nilfs2]
>> [ 1677.311636]  [<ffffffffa024f5e2>] nilfs_segctor_thread+0x122/0x3b=
0 [nilfs2]
>> [ 1677.311657]  [<ffffffffa024f4c0>] ?
>> nilfs_segctor_construct+0x290/0x290 [nilfs2]
>> [ 1677.311677]  [<ffffffff8107cae0>] kthread+0xc0/0xd0
>> [ 1677.311690]  [<ffffffff8107ca20>] ? kthread_create_on_node+0x120/=
0x120
>> [ 1677.311709]  [<ffffffff816dd16c>] ret_from_fork+0x7c/0xb0
>> [ 1677.311724]  [<ffffffff8107ca20>] ? kthread_create_on_node+0x120/=
0x120
>> [ 1677.311740] Code: 2d ee e0 5b 5d c3 48 89 df e8 fb 25 ee e0 eb db
>> 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 85 ff 48 89 e5 53 48
>> 89 fb 74 29 <48> 8b 07 f6 c4 08 0f 84 9c 00 00 00 48 8b 47 30 48 8b =
00
>> a9 00
>> [ 1677.311821] RIP  [<ffffffffa024d0f2>] nilfs_end_page_io+0x12/0xd0=
 [nilfs2]
>> [ 1677.311841]  RSP <ffff88021eaa3d00>
>> [ 1677.311850] CR2: 0000000000004c83
>> [ 1677.320046] ---[ end trace 0e7c8d51bd66cbe6 ]---
>> Jul 12 01:11:50 kernel: [ 1741.418989] SysRq : Emergency Sync
>> Jul 12 01:11:53 kernel: [ 1744.788020] SysRq : Terminate All Tasks
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
