From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Sun, 31 Mar 2013 15:14:00 +0400
Message-ID: <1D751B59-8E60-4D32-80CA-734BD25EE12C@dubeyko.com>
References: <20121128142116.GY4028@wloczykij> <1354113560.2017.11.camel@slavad-ubuntu> <20121128205943.GZ4028@wloczykij> <1354172459.2077.11.camel@slavad-ubuntu> <20130328120700.GK1672@wloczykij> <E24177B1-2EF0-4274-BD13-4642E3663D08@dubeyko.com> <20130329074249.GL1672@wloczykij> <1364544910.11128.9.camel@slavad-ubuntu> <20130329103710.GM1672@wloczykij> <1364556557.11128.28.camel@slavad-ubuntu> <20130329135722.GN1672@wloczykij>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=OcS9Nrt+9RL9H7k3X4yvj2lJJ0zQhSutYppsC3PtlTg=;
	b=dexAdCitG5A7BzPsI2iTpXY6y3IUk3f0K5JtIAfrntVY4dMX4OTSXsHHDXbi6dEfbjDszODWft+drE7lkARrb2G2GFc0ZqSUyNy9IJd/CWist+bqt3oeHLCaDB43cJ4u;
In-Reply-To: <20130329135722.GN1672@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Mar 29, 2013, at 4:57 PM, Piotr Szymaniak wrote:

> On Fri, Mar 29, 2013 at 03:29:17PM +0400, Vyacheslav Dubeyko wrote:
>> I haven't any special additional configuration options for MagicSysRq in
>> my kernel configuration. It is simply enabled.
>> 
>> As I see (https://www.kernel.org/doc/Documentation/sysrq.txt), it is
>> possible to define log level by means of setting value
>> in /proc/sys/kernel/sysrq. I have "1" (enable all functions of sysrq) in
>> this file. Maybe, have you another log level on your side?
> 
> Than this must depend on some different option as I also have "1" in
> /proc/sys/kernel/sysrq.
> 

Your sysrq-triger output is really strange. The sysrq-triger takes momentary system state snapshot. So, this output makes sense only inside issue occurrence. And I feel that this output was taken after issue ending. Or, maybe, it needs to make several trying of getting sysrq-triger output during issue reproducibility.

I think so because flusher doesn't make something NILFS2 related and, moreover, it simply sleeps:

Mar 28 12:57:05 wloczykij kernel: [3338967.379023] flush-8:0       S f6370c34     0   937      2 0x00000000
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  f57ad030 00000046 f6370c34 f6370c34 f57ad030 000040fd c104f550 f5777f40
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  00001d59 00000000 0000000e 0000001f f6370c34 00000001 00000000 00000012
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  c108085c 000040fd 000081fb f6370cac 00000000 c1481000 c700069f c1481000
Mar 28 12:57:05 wloczykij kernel: [3338967.379023] Call Trace:
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c104f550>] ? bdi_dirty_limit+0x21/0xc3
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c108085c>] ? over_bground_thresh+0x3a/0x51
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c12ad2af>] ? schedule_timeout+0xc0/0xdd
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c10226ba>] ? usleep_range+0x38/0x38
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c1081475>] ? bdi_writeback_thread+0x9b/0xd2
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c10813da>] ? wb_do_writeback+0x134/0x134
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c102ba9b>] ? kthread+0x67/0x6c
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c102ba34>] ? kthread_worker_fn+0x7f/0x7f
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c12aee36>] ? kernel_thread_helper+0x6/0xd

The nilfs_cleanerd daemons sleep also:

Mar 28 12:57:05 wloczykij kernel: [3338967.379023] nilfs_cleanerd  S ec179f24     0  1520      1 0x00000000
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  f5037cb0 00000086 c13beb68 ec179f24 f5037cb0 c113e520 f57dff20 a56028b0
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  12ef93e5 00000286 00000000 00000000 00000286 00000000 12ef93e5 00000000
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  00000000 00000078 c102e2e7 00000000 00000000 00000001 12ef93e5 00000000
Mar 28 12:57:05 wloczykij kernel: [3338967.379023] Call Trace:
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c113e520>] ? timerqueue_add+0x72/0x92
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c102e2e7>] ? hrtimer_start_range_ns+0xf/0x13
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c12ad81c>] ? schedule_hrtimeout_range_clock+0xb9/0xde
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c102df7d>] ? update_rmtp+0x5e/0x5e
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c11196fd>] ? wq_sleep+0x84/0xd4
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c1119f66>] ? sys_mq_timedreceive+0x109/0x2f6
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c12ae46d>] ? syscall_call+0x7/0xb

Mar 28 12:57:05 wloczykij kernel: [3338967.379023] nilfs_cleanerd  S f57dff24     0 16150      1 0x00000000
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  f569a670 00000082 c13beb68 f57dff24 f569a670 c113e520 ec179f20 a77736f0
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  12ef93e7 00000286 00000000 00000000 00000286 00000000 12ef93e7 00000000
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  00000000 00000078 c102e2e7 00000000 00000000 00000001 12ef93e7 00000000
Mar 28 12:57:05 wloczykij kernel: [3338967.379023] Call Trace:
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c113e520>] ? timerqueue_add+0x72/0x92
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c102e2e7>] ? hrtimer_start_range_ns+0xf/0x13
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c12ad81c>] ? schedule_hrtimeout_range_clock+0xb9/0xde
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c102df7d>] ? update_rmtp+0x5e/0x5e
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c11196fd>] ? wq_sleep+0x84/0xd4
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c1119f66>] ? sys_mq_timedreceive+0x109/0x2f6
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c12ae46d>] ? syscall_call+0x7/0xb

The segctor thread sleeps too:

Mar 28 12:57:05 wloczykij kernel: [3338967.379023] segctord        S f63f7fac     0   497      2 0x00000000
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  f6379990 00000046 c110e2ac f63f7fac f6379990 f63760b8 e59e5978 f6379990
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  c12b32b8 c1030882 f57f3670 00000046 00000001 00000000 00000046 f6343bc0
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  ec6bfe98 f6343c48 c110fde5 00000246 00000246 f6343c54 f6343bc0 f6343c5c
Mar 28 12:57:05 wloczykij kernel: [3338967.379023] Call Trace:
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c110e2ac>] ? nilfs_dispose_list+0xdb/0xf4
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c1030882>] ? check_preempt_curr+0x20/0x5b
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c110fde5>] ? nilfs_segctor_construct+0x12e/0x193
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c1110195>] ? nilfs_segctor_thread+0x260/0x265
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c102bdfc>] ? finish_wait+0x33/0x33
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c110ff35>] ? nilfs_transaction_unlock.isra.27+0x54/0x54
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c102ba9b>] ? kthread+0x67/0x6c
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c102ba34>] ? kthread_worker_fn+0x7f/0x7f
Mar 28 12:57:05 wloczykij kernel: [3338967.379023]  [<c12aee36>] ? kernel_thread_helper+0x6/0xd

Maybe I misunderstand something but your sysrq-triger output doesn't contain info about any NILFS2 related activity. So, I can't see any details about the issue with kernel flusher thread in shared sysrq-triger output.

Thanks,
Vyacheslav Dubeyko.

> 
>>> ~ # mount
>>> rootfs on / type rootfs (rw)
>>> /dev/sda3 on / type nilfs2 (rw,noatime,nodiratime,gcpid=16150)
>>> proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
>>> tmpfs on /run type tmpfs (rw,nosuid,nodev,relatime,mode=755)
>>> udev on /dev type devtmpfs (rw,nosuid,relatime,size=10240k,nr_inodes=221714,mode=755)
>>> devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620)
>>> shm on /dev/shm type tmpfs (rw,nosuid,nodev,noexec,relatime)
>>> sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
>>> /dev/mapper/chome on /home type btrfs (rw,noatime)
>>> 
>> 
>> I see two nilfs_cleanerd deamons from "ps ax" output:
>> 
>> 1520 ?        Ss     0:25 /sbin/nilfs_cleanerd -c /etc/nilfs_cleanerd.conf /dev/disk/by-uuid/f18e80b1-f3c1-49ec-baa5-39c0edc4c0b9
>> 16150 ?        Ss     0:00 /sbin/nilfs_cleanerd -n /dev/sda3 /
>> 
>> But I can't understand what partition is serviced by nilfs_cleanerd with
>> pid #1520. Could you share more details about it?
> 
> ~ # readlink /dev/disk/by-uuid/f18e80b1-f3c1-49ec-baa5-39c0edc4c0b9
> ../../sda3
> 
> I suppose that this is caused by manually (well, by script, but it's not
> "remount") running nilfs_cleanerd on system startup on that device.
> After that there was a remount that started second cleaner. And it seems
> that this was yesterday:
> ~ # ps aux | grep nilfs
> root      1520  0.0  0.0   2572  1032 ?        Ss   Feb17   0:25
> /sbin/nilfs_cleanerd -c /etc/nilfs_cleanerd.conf
> /dev/disk/by-uuid/f18e80b1-f3c1-49ec-baa5-39c0edc4c0b9
> root     16150  0.0  0.0   2348   796 ?        Ss   Mar28   0:00
> /sbin/nilfs_cleanerd -n /dev/sda3 /
> 
> I think that running cleanerd manually is already changed to -o remount
> on my second machine with nilfs and I just forgot about this one. I had
> some issues with that because of missing /dev/root.
> 
> 
> Piotr Szymaniak.
> -- 
> Na  kazda  strzelanine   zakonczona  czyjas  smiercia  przypadaja  trzy
> strzelaniny  bez ofiar.  To po prostu  niemozliwe  do  zaakceptowania w
> Ameryce. Po prostu nie do zaakceptowania. Musimy cos z tym zrobic.
>  -- George W. Bush

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
