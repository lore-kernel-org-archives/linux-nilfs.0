From: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Subject: Re: Broken nilfs2 filesystem
Date: Thu, 30 May 2013 10:10:25 +0200
Message-ID: <51A70971.40602@antoneliasson.se>
References: <519D2B96.9000106@antoneliasson.se>  <1369291449.2673.15.camel@slavad-ubuntu>  <51A0A7A0.6010207@antoneliasson.se> <51A0E62D.5060600@antoneliasson.se> <1369809573.2253.31.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369809573.2253.31.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Vyacheslav Dubeyko skrev 2013-05-29 08:39:
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
> Currently, I am thinking about reproducing path. It is really important
> to have clear reproducing path. But I haven't clear picture of your
> environment yet. As I understand, you have two virtual VmWare machine
> (Win XP and Win 7). Am I correct?
Correct. The Windows XP machine is stored in /home/anton/vmware/ and the 
Windows 7 machine is stored in /Supplement/anton/vmware/.
> Moreover, I am thinking about the fact that virtual machine on different
> volumes influence on each other in the issue environment. Currently, I
> haven't clear understanding of this.
>
>> /etc/fstab
>> ----------
>>       tmpfs		/tmp	tmpfs	nodev,nosuid	0	0
>>       /dev/mapper/riven-arch	/         	nilfs2    	rw,noatime,discard 0 0
>>       /dev/mapper/riven-home	/home     	nilfs2    	rw,noatime,discard 0 0
>>       /dev/mapper/riven-swap  none            swap            defaults
>>           0 0
>>       /dev/riven-proto/supplement /Supplement ext4 defaults,noatime 0 0
>> # some NFS mounts excluded
>>
> As I can see, riven-arch, riven-home and riven-swap are under device
> mapper but riven-proto is not. Could you share more details about how
> your Logical Volumes environment was prepared?
I drew some sketches to help illustrate my partitioning scheme because 
it's getting quite complicated: http://imgur.com/HC8GstJ,MlKc3DN

riven-proto is also managed by device mapper. An LVM volume can be 
specified either as /dev/mapper/<vg>-<lv> or /dev/<vg>/<lv>. Both of 
these files are symlinks to the same device. I think I've read somewhere 
that the former symlinks are created earlier in the boot process but 
other than that these two ways are basically equivalent.
> Current state of fsck.nilfs2 doesn't give many useful details. But debug
> output of fsck.nilfs2 contains detailed info about first superblock,
> second superblock and segment summaries of all segments. I think that
> this output can give to me more understanding about NILFS2 volume state.
> Could you share debug output of fsck.nilfs2 for me?
>
> You can found archive with fsck.nilf2 source code in this place:
> (http://dubeyko.com/development/FileSystems/NILFS/nilfs-utils-fsck-v.0.04-under-development.tar.gz). Please, build fsck.nilfs2 but don't install it. The fsck.nilfs2 on the initial state of development. Currently, fsck.nilfs2 doesn't make any writing operations. So, you can execute command in such way: "fsck.nilfs2 -v debug [device] 2> [output-file]". The output file has a big size, usually.
I'll see if I can do that tonight.
> I am preparing patch for NILFS2 driver with debug output. I think that
> it makes sense to get more detail about the issue on your side because
> you can reproduce the issue stably. So, I'll send you this patch as it
> will be ready. Have you opportunity to patch your kernel and share debug
> output for the reproduced issue case?
I've never patched a kernel before but I could give it a try. I probably 
won't have time for that until next weekend though, as I will be away 
from this particular computer for the next week.
> Thanks,
> Vyacheslav Dubeyko.
>
>


-- 
Best Regards,
Anton Eliasson

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
