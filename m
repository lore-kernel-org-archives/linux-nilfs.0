From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Broken nilfs2 filesystem
Date: Wed, 29 May 2013 23:37:57 +0900 (JST)
Message-ID: <20130529.233757.27789741.konishi.ryusuke@lab.ntt.co.jp>
References: <51A0A7A0.6010207@antoneliasson.se>
	<51A0E62D.5060600@antoneliasson.se>
	<1369809573.2253.31.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369809573.2253.31.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


I don't know whether this may be a hint of this trouble, but according
to the system log, page_buffers() of nilfs_end_page_io() seems to hit
an Oops due to an invalid page address "0x36cd":

May 22 18:53:31 riven kernel: [ 3821.605568] BUG: unable to handle kernel paging request at 00000000000036cd
May 22 18:53:31 riven kernel: [ 3821.605577] IP: [<ffffffffa027f1a2>] nilfs_end_page_io+0x12/0xc0 [nilfs2]
May 22 18:53:31 riven kernel: [ 3821.605591] PGD 19636d067 PUD 19636e067 PMD 0 
May 22 18:53:31 riven kernel: [ 3821.605597] Oops: 0000 [#1] PREEMPT SMP 
<snip>
May 22 18:53:31 riven kernel: [ 3821.605829] Code: ff ff ff 48 81 c4 88 00 00 00 5b 41 5c 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 85 ff 48 89 e5 53 48 89 fb 74 4e <48> 8b 07 f6 c4 08 0f 84 8c 00 00 00 48 8b 47 30 48 8b 00 f6 c4 
May 22 18:53:31 riven kernel: [ 3821.605873] RIP  [<ffffffffa027f1a2>] nilfs_end_page_io+0x12/0xc0 [nilfs2]
May 22 18:53:31 riven kernel: [ 3821.605881]  RSP <ffff8801960f7b30>
May 22 18:53:31 riven kernel: [ 3821.605884] CR2: 00000000000036cd

where the instruction sequence of "<48> 8b 07 f6 c4 08" is "mov
(%rdi),%rax; test $0x8, %ah", and corresponds to the part testing
PagePrivate(page) in page_buffers() macro called within
nilfs_end_page_io() routine:

      if (buffer_nilfs_node(page_buffers(page)) && !PageWriteback(page)) {

This cannot happen, but there may be something we missed.


Regards,
Ryusuke Konishi



On Wed, 29 May 2013 10:39:33 +0400, Vyacheslav Dubeyko wrote:
> Hi Anton
> 
> On Sat, 2013-05-25 at 18:26 +0200, Anton Eliasson wrote:
> 
> [snip]
>> More specifically, I have a virtual machine running Windows XP in /home, 
>> a nilfs filesystem, and a virtual machine running Windows 7 in 
>> /Supplement. /Supplement is an ext4 volume in the same LVM volume group 
>> as /home on the same slow hard drive. I can crash the host by either:
>> 
>> * Starting both machines at the same time.
>> * Starting the W7 machine first and when it is fully booted to the 
>> desktop, but still doing I/O intensive Windows stuff, starting the WXP 
>> machine.
>> 
>> If I first start the WXP machine and let it boot to the desktop, at the 
>> point where it is actually I/O idle, I can safely start the W7 machine. 
>> After that I found no trouble installing software updates and logging in 
>> and out of both machines at the same time, though the HDD made it very 
>> slow of course.
> 
> Currently, I am thinking about reproducing path. It is really important
> to have clear reproducing path. But I haven't clear picture of your
> environment yet. As I understand, you have two virtual VmWare machine
> (Win XP and Win 7). Am I correct?
> 
> Moreover, I am thinking about the fact that virtual machine on different
> volumes influence on each other in the issue environment. Currently, I
> haven't clear understanding of this.
> 
>> /etc/fstab
>> ----------
>>      tmpfs		/tmp	tmpfs	nodev,nosuid	0	0
>>      /dev/mapper/riven-arch	/         	nilfs2    	rw,noatime,discard 0 0
>>      /dev/mapper/riven-home	/home     	nilfs2    	rw,noatime,discard 0 0
>>      /dev/mapper/riven-swap  none            swap            defaults 
>>          0 0
>>      /dev/riven-proto/supplement /Supplement ext4 defaults,noatime 0 0
>> # some NFS mounts excluded
>>
> 
> As I can see, riven-arch, riven-home and riven-swap are under device
> mapper but riven-proto is not. Could you share more details about how
> your Logical Volumes environment was prepared?
> 
> Current state of fsck.nilfs2 doesn't give many useful details. But debug
> output of fsck.nilfs2 contains detailed info about first superblock,
> second superblock and segment summaries of all segments. I think that
> this output can give to me more understanding about NILFS2 volume state.
> Could you share debug output of fsck.nilfs2 for me?
> 
> You can found archive with fsck.nilf2 source code in this place:
> (http://dubeyko.com/development/FileSystems/NILFS/nilfs-utils-fsck-v.0.04-under-development.tar.gz). Please, build fsck.nilfs2 but don't install it. The fsck.nilfs2 on the initial state of development. Currently, fsck.nilfs2 doesn't make any writing operations. So, you can execute command in such way: "fsck.nilfs2 -v debug [device] 2> [output-file]". The output file has a big size, usually.
> 
> I am preparing patch for NILFS2 driver with debug output. I think that
> it makes sense to get more detail about the issue on your side because
> you can reproduce the issue stably. So, I'll send you this patch as it
> will be ready. Have you opportunity to patch your kernel and share debug
> output for the reproduced issue case?
> 
> Thanks,
> Vyacheslav Dubeyko.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
