From: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Subject: Re: Broken nilfs2 filesystem
Date: Sat, 25 May 2013 13:59:28 +0200
Message-ID: <51A0A7A0.6010207@antoneliasson.se>
References: <519D2B96.9000106@antoneliasson.se> <1369291449.2673.15.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369291449.2673.15.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Vyacheslav Dubeyko skrev 2013-05-23 08:44:
> Hi Anton,
>
> On Wed, 2013-05-22 at 22:33 +0200, Anton Eliasson wrote:
>> Greetings!
>> It pains me to report that my /home filesystem broke down today. My
>> system is running Arch Linux 64-bit. The filesystem resides on a Crucial
>> M4 256 GB SSD, on top of a LVM2 volume. The drive and filesystem are
>> both around six months old. Partition table and error log excerpts are
>> at the bottom of this e-mail. Full logs are available upon request.
>>
>> I am providing this information as a bug report. I have no reason to
>> suspect the hardware but I cannot exclude it either. If you (the
>> developers) are interested in troubleshooting this for prosperity, I can
>> be your hands and run whatever tools are required. If not, I'll reformat
>> the filesystem, restore the data from backup and forget that this happened.
>>
>> In case the formatting gets mangled, this e-mail is also available at
>> What happened today, in chronological order:
>>
>> ~18:00
>> ======
>> I am troubleshooting some issues that turn out to be caused by a wrongly
>> configured system clock. The RTC (hardware clock) is set to local time
>> (UTC+2) but the OS is configured to treat the RTC as UTC. This is
>> because it was set to UTC previously, but then I reinstalled Windows
>> which promptly reset it to local time.
>>
>> This set the mtime of some files in both / and /home to dates in the
>> future. When I discovered this, I `touch`ed all affected files (`touch
>> now; sudo find / /home -xdev -newer now -exec touch {} \;`) to reset
>> their mtime and rebooted the system. I do not know if this is relevant;
>> if not, it makes reading the log files more fun.
>>
>> I then launch my command line backup program "bup", Firefox and some
>> other apps.
>>
>> ~18:50-19:00
>> ============
>> Firefox freezes. The system keeps running but I can't launch new
>> programs. It looked like all I/O broke down. However, bup kept running.
>> I left the computer alone for perhaps 30-60 min.
>>
> So, as I understand, a reproducing path is:
> (1) set mtime of some files in the future;
> (2) touch all affected files;
> (3) reboot the system;
> (4) launch backup program "bup", Firefox and some other apps.
That about sums up what I did, yes. While debugging the clock problems I 
rebooted more than once in a short time period.
> I think that it makes sense to try this reproducing path. But we had
> reports about the issue with likewise symptoms
> (nilfs_bmap_lookup_contig: broken bmap) for the case of 4 KB block size
> from other users. Unfortunately, I can't reproduce such issue for the
> case of 4 KB blocks size earlier. As I feel the clear reproducing path
> is crucial for this issue.
>
> I understand that it can be hard to reproduce the issue again. But,
> anyway, have you opportunity to try to reproduce the issue on another
> NILFS2 partition on your side?
>
> Anyway, I am going to reproduce the issue by this reproducing path on my
> side.
I have created a new nilfs filesystem about the same size as the old one 
on another drive and restored /home to it. If I find the time this 
weekend, I'll give it the same treatment.
>> ~20:00
>> ======
>> When I came back, bup hade frozen (/var/log/messages at 18:53:31).[1] I
>> restart X by pressing Alt+SysRq+K (/var/log/messages at 20:06:33) and
>> return to the login screen. The system freezes during login though,
>> probably because /home had probably been mounted read only). So I reboot
>> using Alt+SysRq+REISUB (/var/log/messages at 20:07:05). I noticed some
>> I/O errors during shutdown.
>>
>> After the reboot there are no immediate signs of disaster. I launch bup
>> again. Some time later, /home remounts as read only. I notice that bup
>> has reported I/O errors while reading some files in /home.[2] dmesg and
>> /var/log/kern.log contains errors mentioning "bad btree node" and
>> "nilfs_bmap_lookup_contig: broken bmap".[3]
>>
> Now we have patch for overcome the freezing of system after such issue:
> http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01614.html.
That is good. I shall await the next release with great anticipation.
> With the best regards,
> Vyacheslav Dubeyko.
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Best Regards,
Anton Eliasson

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
