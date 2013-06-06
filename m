From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Broken nilfs2 filesystem
Date: Thu, 06 Jun 2013 10:56:09 +0400
Message-ID: <1370501769.2202.36.camel@slavad-ubuntu>
References: <1369809573.2253.31.camel@slavad-ubuntu>
	 <20130529.233757.27789741.konishi.ryusuke@lab.ntt.co.jp>
	 <1369894385.2255.8.camel@slavad-ubuntu>
	 <20130530.155543.480320022.konishi.ryusuke@lab.ntt.co.jp>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=Q+Mqddu2Aq7kr81+h4NYZAVWSDXtQ60/ERJuqHo6zyc=;
	b=Q+6WK/ocqv3rwWQtTplhmMQmD+dqy/2BVhnxT1j+OZYT28c94NG+USxKzDCLfw9zsNKvvAFhE061qiGPR6lrWig/1ET9qAm/JZhh19TX00MnYh5yHzE1CoaFdjXwZo0v;
In-Reply-To: <20130530.155543.480320022.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 2013-05-30 at 15:55 +0900, Ryusuke Konishi wrote:
> On Thu, 30 May 2013 10:13:05 +0400, Vyacheslav Dubeyko wrote:
> > On Wed, 2013-05-29 at 23:37 +0900, Ryusuke Konishi wrote:
> >> I don't know whether this may be a hint of this trouble, but according
> >> to the system log, page_buffers() of nilfs_end_page_io() seems to hit
> >> an Oops due to an invalid page address "0x36cd":
> >> 
> > 
> > Yes. There are two possible way to be in nilfs_end_page_io(): (1)
> > nilfs_segctor_complete_write(); (2) nilfs_abort_logs(). Currently, I
> > suspect the nilfs_abort_logs()
> 
> That sounds a likely cause.
> 
> Can you test nilfs_abort_logs by injecting a random fault in some easy
> way ?
> 

So, what I discovered currently.

First of all, unfortunately, I can't reproduce the issue yet, currently.
I suspect that in this issue the aging state of volume, peculiarity of
workload and environment play very important role. As I remember, all
reporters of likewise symptoms (broken bnode error messages) talked
about several months of successful working of NILFS2 file system.

I tried to make LVM environment as it was described by Anton. But I
didn't catch the issue in this environment. So, I think that I haven't
properly aged NILFS2 volume state and I tried not proper workload. It
needs to think about proper workload more deeply. As I can see from
Anton's system log that it took place frequent update and git activity.
Moreover, update and git were nearly before crash:

May 22 18:48:45 riven slim[274]: [2013-05-22 18:48:43] Downloading update (37 782 of 41 158 KB)...
May 22 18:48:45 riven slim[274]: [2013-05-22 18:48:43] Downloading update (38 390 of 41 158 KB)...
May 22 18:48:45 riven slim[274]: [2013-05-22 18:48:43] Downloading update (39 066 of 41 158 KB)...
May 22 18:48:45 riven slim[274]: [2013-05-22 18:48:44] Downloading update (39 742 of 41 158 KB)...
May 22 18:48:45 riven slim[274]: [2013-05-22 18:48:44] Downloading update (40 311 of 41 158 KB)...
May 22 18:48:45 riven slim[274]: [2013-05-22 18:48:44] Downloading update (40 956 of 41 158 KB)...
May 22 18:48:45 riven slim[274]: [2013-05-22 18:48:45] Downloading update (41 158 of 41 158 KB)...
May 22 18:50:13 riven slim[274]: [2013-05-22 18:48:45] Downl18:50:13 | Git | default | Checking for remote changes...
May 22 18:50:13 riven slim[274]: 18:50:13 | Cmd | default | git rev-parse HEAD
May 22 18:50:13 riven slim[274]: 18:50:13 | Cmd | default | git ls-remote --heads --exit-code "ssh://storage@hephaestus/home/storage/default" master
May 22 18:50:13 riven slim[274]: 18:50:13 | Git | default | No remote changes, local+remote: 8eab1e96aa618010ff17c11a955f4423d823beb6
May 22 18:50:14 riven slim[274]: 18:50:14 | ListenerTcp | Pinging tcp://notifications.sparkleshare.org:443/
May 22 18:50:14 riven slim[274]: 18:50:14 | ListenerTcp | Received pong from tcp://notifications.sparkleshare.org:443/
May 22 18:53:31 riven kernel: [ 3821.605568] BUG: unable to handle kernel paging request at 00000000000036cd
May 22 18:53:31 riven kernel: [ 3821.605577] IP: [<ffffffffa027f1a2>] nilfs_end_page_io+0x12/0xc0 [nilfs2]

So, maybe, git activity is a possible workload for the issue
reproducing. It needs to check it, I suppose.

I tried to simulate errors occurrence in nilfs_segctor_do_construct()
method by means of excluding of error checking in places:

http://lxr.free-electrons.com/source/fs/nilfs2/segment.c#L1942
http://lxr.free-electrons.com/source/fs/nilfs2/segment.c#L1953
http://lxr.free-electrons.com/source/fs/nilfs2/segment.c#L1962
http://lxr.free-electrons.com/source/fs/nilfs2/segment.c#L1976
http://lxr.free-electrons.com/source/fs/nilfs2/segment.c#L1989

Initially, by chance, I simply comment error checking statement. Then, I
comment error checking statement and additionally set code error by
-EINVAL. It is strange but if I set error code then I haven't any
visible failure in working of NILFS2 driver. But I have very interesting
error in the case when I simply comment error checking statement without
setting code error:

May 31 15:05:49 slavad-ubuntu nilfs_cleanerd[2409]: run (manual)
May 31 15:05:50 slavad-ubuntu kernel: [  737.725827] [nilfs_segctor_do_construct] fs/nilfs2/segment.c:1944
May 31 15:05:50 slavad-ubuntu nilfs_cleanerd[2409]: cannot clean segments: File exists
May 31 15:05:50 slavad-ubuntu nilfs_cleanerd[2409]: shutdown
May 31 15:05:50 slavad-ubuntu kernel: [  737.744660] ------------[ cut here ]------------
May 31 15:05:50 slavad-ubuntu kernel: [  737.744674] WARNING: at fs/nilfs2/ioctl.c:449 nilfs_ioctl_clean_segments.isra.11+0x667/0x690()
May 31 15:05:50 slavad-ubuntu kernel: [  737.744676] Hardware name: OptiPlex 760                 
May 31 15:05:50 slavad-ubuntu kernel: [  737.744679] Modules linked in: snd_hda_codec_analog snd_hda_intel i915 snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event bnep rfcomm snd_seq drm_kms_helper drm bluetooth nfsv4 snd_timer snd_seq_device i2c_algo_bit snd joydev hid_generic soundcore dell_wmi video dcdbas coretemp psmouse serio_raw mei sparse_keymap ppdev snd_page_alloc lpc_ich mac_hid parport_pc microcode wmi lp parport binfmt_misc nfsd nfs_acl auth_rpcgss nfs fscache lockd sunrpc e1000e ptp pps_core usbhid hid
May 31 15:05:50 slavad-ubuntu kernel: [  737.744746] Pid: 2409, comm: nilfs_cleanerd Tainted: G          I  3.9.0-rc6+ #35
May 31 15:05:50 slavad-ubuntu kernel: [  737.744748] Call Trace:
May 31 15:05:50 slavad-ubuntu kernel: [  737.744756]  [<ffffffff8105c7df>] warn_slowpath_common+0x7f/0xc0
May 31 15:05:50 slavad-ubuntu kernel: [  737.744760]  [<ffffffff8105c83a>] warn_slowpath_null+0x1a/0x20
May 31 15:05:50 slavad-ubuntu kernel: [  737.744765]  [<ffffffff81301837>] nilfs_ioctl_clean_segments.isra.11+0x667/0x690
May 31 15:05:50 slavad-ubuntu kernel: [  737.744771]  [<ffffffff81098f0f>] ? local_clock+0x6f/0x80
May 31 15:05:50 slavad-ubuntu kernel: [  737.744776]  [<ffffffff81301e44>] nilfs_ioctl+0x3d4/0x690
May 31 15:05:50 slavad-ubuntu kernel: [  737.744781]  [<ffffffff810c370f>] ? lock_release_non_nested+0x30f/0x350
May 31 15:05:50 slavad-ubuntu kernel: [  737.744785]  [<ffffffff81098ca5>] ? sched_clock_local+0x25/0x90
May 31 15:05:50 slavad-ubuntu kernel: [  737.744790]  [<ffffffff811b7e26>] do_vfs_ioctl+0x96/0x570
May 31 15:05:50 slavad-ubuntu kernel: [  737.744795]  [<ffffffff81169e4c>] ? might_fault+0x5c/0xb0
May 31 15:05:50 slavad-ubuntu kernel: [  737.744801]  [<ffffffff81748985>] ? sysret_check+0x22/0x5d
May 31 15:05:50 slavad-ubuntu kernel: [  737.744805]  [<ffffffff811b8391>] sys_ioctl+0x91/0xb0
May 31 15:05:50 slavad-ubuntu kernel: [  737.744809]  [<ffffffff813a70be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
May 31 15:05:50 slavad-ubuntu kernel: [  737.744813]  [<ffffffff81748959>] system_call_fastpath+0x16/0x1b
May 31 15:05:50 slavad-ubuntu kernel: [  737.744816] ---[ end trace 374fc1d251cc46c6 ]---
May 31 15:05:50 slavad-ubuntu kernel: [  737.744933] NILFS: GC failed during preparation: cannot read source blocks: err=-17
May 31 15:09:44 slavad-ubuntu kernel: [  972.324583] [nilfs_segctor_do_construct] fs/nilfs2/segment.c:1944
May 31 15:09:49 slavad-ubuntu kernel: [  977.349257] [nilfs_segctor_do_construct] fs/nilfs2/segment.c:1944
May 31 15:11:57 slavad-ubuntu nilfs_cleanerd[2820]: start
May 31 15:11:57 slavad-ubuntu nilfs_cleanerd[2820]: pause (clean check)
May 31 15:12:08 slavad-ubuntu nilfs_cleanerd[2820]: run (manual)
May 31 15:12:08 slavad-ubuntu nilfs_cleanerd[2820]: cannot clean segments: File exists
May 31 15:12:08 slavad-ubuntu nilfs_cleanerd[2820]: shutdown
May 31 15:12:08 slavad-ubuntu kernel: [ 1115.562880] nilfs_ioctl_move_inode_block: conflicting data buffer: ino=4, cno=0, offset=0, blocknr=2086, vblocknr=232528
May 31 15:12:08 slavad-ubuntu kernel: [ 1115.562887] NILFS: GC failed during preparation: cannot read source blocks: err=-17

As I understand, this error looks like last Anton's reports about
complete failure of using the corrupted NILFS2 volume. So, maybe, it is
possible to make assumption that it takes place continuous and permanent
segments construction abortion in the case of the issue. But simulation
by means of commenting error checking statement without setting code
error is not proper driver's workflow, as I understand. And it confuses
me. Currently, I haven't clear understanding of it.

So, it needs to continue investigation of the issue further, from my
viewpoint.

With the best regards,
Vyacheslav Dubeyko.

> Regards,
> Ryusuke Konishi
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
