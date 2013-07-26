From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Kernel Bug: unable to handle kernel paging request
Date: Fri, 26 Jul 2013 14:13:17 -0400
Message-ID: <CALJXSJrY22eGkYA76wwL4moAdsjV+_PUtvVO6tt5K16hzMh8xQ@mail.gmail.com>
References: <CALJXSJquK6YxGKuH97Ec2CTMyJaZrJjOfePSKtgPDm8_9YXzzw@mail.gmail.com>
	<CALJXSJoW9Qpp9t42u_k4cW3gO6qzSPoeCjtQDU3tDKq6TJ=K8Q@mail.gmail.com>
	<F4156394-8A25-4F81-81C3-9921CB00BD92@dubeyko.com>
	<CALJXSJrj0J_-ZUCOurJXaYhx_wEJwxb2_5OOJjQSSmmP-PQDgg@mail.gmail.com>
	<1374578141.2226.5.camel@slavad-ubuntu>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=qlOtkUAFF3sk1W/Hmpg9yMwWLVRh497QPiQcz2UYlcw=;
        b=Ts/qBsurfh5Vq0j0ceMm1ipRFcTJzGl8tcaCc0/ui1qtCGm43f842F8VS6brI+4x5L
         F5Q79LUl4bxJvUjX/LYAWgCRCqVItpLkVALpgdCuCBx+TO5M7bkNqIfJH6rvaShDMUPW
         WV74VqN/+faVDq3i1Oql6eLyZhfpeVp9xW0Gp09yBPY64NHtiNzWNZRXklTWhz9WV8HT
         YToWtT/cdp9BDwBtL8yh4xaKjz/CJ6gAIaWeYSn/Hm+/E4EswekFyF3oVITGk3t7m0Su
         s0jH8TbBDQ/GrABZ5VtTPc7hgVVRmmIqLcgt/ingLq2iwNN1V6cr2LolWp2pMNBI8ZHn
         4V+Q==
In-Reply-To: <1374578141.2226.5.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Good afternoon,

I have more informations to add to the bug.

On Tue, Jul 23, 2013 at 7:15 AM, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:
>> > So, as I see, the reproducing path is: (1) delete /var/cache/apt; (2) issue apt-get update.
>>
>> In fact it is the other way around;
>> (1) Issue apt-get update: Crash.
>> (2) Reboot, try again: Crash.
>> (3) Delete /var/lib/apt/lists/* and try again: Works for some time.
>>
>
> Ok. Thank you for additional details.

I was able to reproduce consistently the problem.
1. Make a snapshot of a checkpoint and mount it.
2. Read from the checkpoint (make a backup).
3. Issue apt-get update.

>
>>
>> > (1) The strace output for the case of issuing the apt-get update (in the case of issue reproducing).
>>
>> That will be hard to obtain except maybe if I alias my apt-get update
>> to strace -f -o /boot/somefile.txt apt-get update and hope the problem
>> occur again. It sometimes happen when launched from the Ubuntu Store
>> which doesn't use bash to launch the update.
>>
>
> Ok. I see. I'll try to analyze the issue on the basis of available
> information. But it will be a great to have the requested strace output.

Here are the log files.
1. strace from the backup was still reading, it did not stop.
2. apt-get-crash.log
4362  13:32:04 read(6, " Debugging symbols\nHomepage: htt"..., 32052) = 32052
4362  13:32:04 read(6, "tcp-wrappers/libwrap0-dev_7.6.q-"..., 32460) = 32460
4362  13:32:04 read(6, "bdevel\nInstalled-Size: 542\nMaint"..., 32710) = 32710
4362  13:32:04 read(6, "ian.org>\nArchitecture: i386\nSour"..., 32558) = 32558
4362  13:32:04 read(6, "l-Maintainer: XCB Developers <xc"..., 32613) = 32613
4362  13:32:04 read(6, "ed: 9m\n\nPackage: libxcb-xvmc0-db"..., 31979) = 31979
4362  13:32:04 read(6, "ibz-dev\nFilename: pool/main/x/xf"..., 32335) = 32335
4362  13:32:04 read(6, "n: Ubuntu\nSupported: 9m\nTask: my"..., 31903) = 31903
4362  13:32:04 read(6, "\nFilename: pool/main/libx/libxpm"..., 32467) = 32467
4362  13:32:04 read(6, "buntu/+filebug\nOrigin: Ubuntu\nSu"..., 31982) = 31982
4362  13:32:04 read(6, "chpad.net/ubuntu/+filebug\nOrigin"..., 31976) = 31976
4362  13:32:04 read(6, "buntu Developers <ubuntu-devel-d"..., 32681) = 32681
4362  13:32:04 read(6, "-utils\nDepends: debconf (>= 0.5)"..., 32468) = 32468
4362  13:32:04 read(6, "top, mythbuntu-backend-slave, my"..., 31678) = 31678
4362  13:32:04 read(6, "d5: 1b0992eebd45ca5ceadc775532a4"..., 32126) = 32126
4362  13:32:04 read(6, " all\nSource: munin\nVersion: 2.0."..., 32535) = 32535
4362  13:32:04 read(6, "fice-core | openoffice.org-hunsp"..., 32373) = 32373
4362  13:32:04 read(6, "ffice.org-dictionaries (1:3.3.0~"..., 32513) = 32513
4362  13:32:04 read(6, "hbuntu-backend-master\n\nPackage: "..., 31756) = 31756
4362  13:32:04 read(6, "2614b9\nSHA256: bcc70d6577dd06565"..., 32118) = 32118
4362  13:32:04 read(6, "17\nSHA256: d903f798a8c38fef2b992"..., 32339) = 32339
-- End of file --

3. syslog:
Jul 26 13:32:04 kernel: [  317.525021] BUG: unable to handle kernel
paging request at 00000000000033e5
Jul 26 13:32:04 kernel: [  317.525371] IP: [<ffffffffa02930f2>]
nilfs_end_page_io+0x12/0xd0 [nilfs2]
Jul 26 13:32:04 kernel: [  317.525715] PGD 0
Jul 26 13:32:04 kernel: [  317.526044] Oops: 0000 [#1] SMP
Jul 26 13:32:04 kernel: [  317.526372] Modules linked in: pci_stub
vboxpci(OF) vboxnetadp(OF) vboxnetflt(OF) vboxdrv(OF) nfsd(F)
auth_rpcgss(F) nfs_acl(F) lockd(F) sunrpc(F) dm_crypt(F) bbswitch(OF)
intel_powerclamp kvm uvcvideo videobuf2_v
malloc videobuf2_memops videobuf2_core crc32_pclmul(F)
ghash_clmulni_intel(F) aesni_intel(F) videodev aes_x86_64(F) lrw(F)
gf128mul(F) btusb glue_helper(F) ablk_helper(F) cryptd(F)
snd_hda_codec_realtek snd_hda_intel snd_hda_codec arc4(F) asus_wmi
snd_
hwdep(F) sparse_keymap mxm_wmi snd_pcm(F) joydev(F) snd_page_alloc(F)
iwldvm snd_seq_midi(F) snd_seq_midi_event(F) snd_rawmidi(F) snd_seq(F)
mac80211 snd_seq_device(F) snd_timer(F) iwlwifi snd(F) soundcore(F)
cfg80211 mei_me mei lpc_ich psmouse(F) wmi
microcode(F) serio_raw(F) mac_hid parport_pc(F) ppdev(F) lp(F)
parport(F) bnep rfcomm bluetooth binfmt_misc(F) coretemp nilfs2
btrfs(F) xor(F) zlib_deflate(F) raid6_pq(F) libcrc32c(F) nbd(F)
hid_generic usbhid hid usb_storage(F) i915 i2c_algo_bit drm_k
ms_helper drm alx mdio a
Jul 26 13:32:04 kernel: hci(F) libahci(F) video(F) [last unloaded:
ipmi_msghandler]
Jul 26 13:32:04 kernel: [  317.528925] CPU: 4 PID: 388 Comm: segctord
Tainted: GF        C O 3.10.0-4-generic #13-Ubuntu
Jul 26 13:32:04 kernel: [  317.529487] Hardware name: ASUSTeK COMPUTER
INC. N56VZ/N56VZ, BIOS N56VZ.216 12/06/2012
Jul 26 13:32:04 kernel: [  317.530046] task: ffff88021d159770 ti:
ffff88022067a000 task.ti: ffff88022067a000
Jul 26 13:32:04 kernel: [  317.530606] RIP: 0010:[<ffffffffa02930f2>]
[<ffffffffa02930f2>] nilfs_end_page_io+0x12/0xd0 [nilfs2]
Jul 26 13:32:04 kernel: [  317.531184] RSP: 0018:ffff88022067bd00
EFLAGS: 00010202
Jul 26 13:32:04 kernel: [  317.531756] RAX: ffff8801fd7f16c8 RBX:
00000000000033e5 RCX: 0000000000000034
Jul 26 13:32:04 kernel: [  317.532371] RDX: 000000000000000d RSI:
0000000000000000 RDI: 00000000000033e5
Jul 26 13:32:04 kernel: [  317.532952] RBP: ffff88022067bd08 R08:
7800000000000000 R09: a80022ed3c000000
Jul 26 13:32:04 kernel: [  317.533541] R10: 57ffc712ccbb4f00 R11:
0000000000000019 R12: ffff88021db8eeb8
Jul 26 13:32:04 kernel: [  317.534129] R13: 0000000000000000 R14:
ffffea0007a481c0 R15: ffff8801fd7f1680
Jul 26 13:32:04 kernel: [  317.534717] FS:  0000000000000000(0000)
GS:ffff88022ef00000(0000) knlGS:0000000000000000
Jul 26 13:32:04 kernel: [  317.535318] CS:  0010 DS: 0000 ES: 0000
CR0: 0000000080050033
Jul 26 13:32:04 kernel: [  317.535919] CR2: 00000000000033e5 CR3:
0000000001c0e000 CR4: 00000000001407e0
Jul 26 13:32:04 kernel: [  317.536528] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Jul 26 13:32:04 kernel: [  317.537176] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Jul 26 13:32:04 kernel: [  317.537791] Stack:
Jul 26 13:32:04 kernel: [  317.538406]  ffff88021db8ee10
ffff88022067be00 ffffffffa02944c5 ffffffff81019d09
Jul 26 13:32:04 kernel: [  317.539057]  ffff88021d159770
ffff88021d159770 ffff88021d159770 ffff88021f1bec70
Jul 26 13:32:04 kernel: [  317.539715]  ffff88021dcc1158
ffff88021dcc1000 ffff88021f1bec60 000000031d159770
Jul 26 13:32:04 kernel: [  317.540384] Call Trace:
Jul 26 13:32:04 kernel: [  317.541056]  [<ffffffffa02944c5>]
nilfs_segctor_do_construct+0xf25/0x1b20 [nilfs2]
Jul 26 13:32:04 kernel: [  317.541744]  [<ffffffff81019d09>] ?
sched_clock+0x9/0x10
Jul 26 13:32:04 kernel: [  317.542440]  [<ffffffffa02953ab>]
nilfs_segctor_construct+0x17b/0x290 [nilfs2]
Jul 26 13:32:04 kernel: [  317.543145]  [<ffffffffa02955e2>]
nilfs_segctor_thread+0x122/0x3b0 [nilfs2]
Jul 26 13:32:04 kernel: [  317.543840]  [<ffffffffa02954c0>] ?
nilfs_segctor_construct+0x290/0x290 [nilfs2]
Jul 26 13:32:04 kernel: [  317.544534]  [<ffffffff8107cca0>] kthread+0xc0/0xd0
Jul 26 13:32:04 kernel: [  317.545225]  [<ffffffff8107cbe0>] ?
kthread_create_on_node+0x120/0x120
Jul 26 13:32:04 kernel: [  317.545924]  [<ffffffff816f026c>]
ret_from_fork+0x7c/0xb0
Jul 26 13:32:04 kernel: [  317.546583]  [<ffffffff8107cbe0>] ?
kthread_create_on_node+0x120/0x120
Jul 26 13:32:04 kernel: [  317.547208] Code: d9 e9 e0 5b 5d c3 48 89
df e8 db d1 e9 e0 eb db 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55
48 85 ff 48 89 e5 53 48 89 fb 74 29 <48> 8b 07 f6 c4 08 0f 84 9c 00 00
00 48 8b 47 30 48 8b 00 a9 00
Jul 26 13:32:04 kernel: [  317.548013] RIP  [<ffffffffa02930f2>]
nilfs_end_page_io+0x12/0xd0 [nilfs2]
Jul 26 13:32:04 kernel: [  317.548674]  RSP <ffff88022067bd00>
Jul 26 13:32:04 kernel: [  317.549286] CR2: 00000000000033e5
Jul 26 13:32:04 kernel: [  317.549897] ---[ end trace ffe6496742ccfbe8 ]---
Jul 26 13:32:06 AptDaemon: INFO: Initializing daemon
Jul 26 13:32:07 AptDaemon.PackageKit: INFO: Initializing PackageKit compat layer
Jul 26 13:32:07 dbus[569]: [system] Successfully activated service
'org.freedesktop.PackageKit'
-- Reboot --
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
