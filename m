From: "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Best way to shut down NILFS2? (umount hang issue)...
Date: Thu, 19 Sep 2013 19:19:09 -0400
Message-ID: <523B866D.9060406@gmail.com>
References: <5238DAD8.3070804@gmail.com>  <1379485106.2365.11.camel@slavad-ubuntu>  <CAJzLF9nbfM6aY8u57Lgkm4r_mpBtd96J=HaqSnF=+oLvhYpmUw@mail.gmail.com> <1379571773.2310.5.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=UsCtUSc7e45hFFUv9q/yryD2kWBVZ8/J2E47fQdwHD4=;
        b=O0dyWmzASyEwaHYnd9D9W+RqhwnvdnQcNgBYqR54ag4NC8/prF0gauDO5YnUOuHcTP
         M+eFq1AUFnoYx0WQsaJ5ecPJs6u9j0A5WWoRtEPxgqG79jNfKHaZ4J7/9XV9gMGqu1cK
         TExK07ItG9u2MdGQYLDUAsc5wQNGyMfTBz3JMGOr3Q0nyaRaSqia2g3JPpWrR+0uA1PU
         rgexY1jXH3YJpXymIInQcAkO3jR10PPjm8O9Cstca9x/EO1Tc+yfStOwLqaXc2McMBkn
         1lqDWi6b0pz1FmoReGpL5iqGeHJoNajKQtZU+rcZWV4PKDkv0x2z2jd6HZ7CMs25sky6
         g/9A==
In-Reply-To: <1379571773.2310.5.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 09/19/2013 02:22 AM, Vyacheslav Dubeyko wrote:
> On Wed, 2013-09-18 at 12:26 -0400, Michael L. Semon wrote:
> 
> [snip]
>>>
>>> As far as I can see, your NILFS2 file system was remounted in RO mode
>>> because of internal error. Could you confirm my understanding?
>>
>> Yes, but only on reboot.  Other programs crash the PC, and NILFS2 has to
>> recover from that crash.  The PC spends a lot of time running xfstests and
>> LTP with a kernel that is set to panic.  NILFS2 itself seems OK, and its
>> latest xfstests run looked good, using default mkfs.nilfs2 options and
>> mounting with "-o pp=0".
> 
> [snip]
>>
>> It is strictly like this so far:
>>
>> 1) NILFS2 / boots OK
>> 2) no problems
>> 3) shutdown is OK
>> 4) NILFS2 / boots OK
>> 5) computer crashes for some other reason
>> 6) NILFS2 / boots OK, but displays a message that recovery was used
>> 7) no problems
>> 8) here, shutdown may hang on sync or umount (50% chance)
>>
>> In other words, NILFS2 has not had an error to make it remount read-only
>> while the PC is running.  The problem may solve itself over time, or I
>> may have to boot to another partition, then mount and umount the NILFS2
>> partition to get it to recover and umount cleanly again.
>>
> 
> So, maybe it is another issue.
> 
> [snip]
>>
>> I'll try your patches tonight and report back in 1-2 days.
>>
> 
> Ok. Please, inform me about the result anyway. If suggested patches
> don't fix the issue then I will begin investigation.
> 
> But, I begin to suspect presence of another issue after additional
> analysis of provided by you outputs. So, I am waiting results of your
> attempt.
> 
> Thanks,
> Vyacheslav Dubeyko.

The issue still happens.  One patch was already in the kernel, and
the second patch you mentioned did not make much of a difference.
The second patch is still installed, though.

The problem I mentioned above is the one that is easy to explain.
The crash doesn't even have to stress the computer:  A simple
SysRq-induced crash should be enough to get the problem started, 
though the PC might need to be crashed more than once.

I've changed / to mount as errors=panic, but there has been no 
panic yet.

# ================

Here is where the overall problem becomes hard to explain.  Consider this 
scenario:

/ is NILFS2 (rw,order=strict)
/boot is JFS
/tmp is JFS
/usr/src is JFS

Because I don't want the hung NILFS2 umount to give problems to /tmp and 
/usr/src, I adapted the end of the standard Slackware shutdown script to 
look something like this:

/bin/umount -v -a -t noproc,nosysfs,nonilfs2

# This line can be here to show a sync problem, or removed 
# to show a umount problem....
sync

/bin/umount -v -a -t nilfs2

echo "Remounting root filesystem read-only."
/bin/mount -v -n -o remount,ro /dev/sdb12 /

[I can get you the exact script next time.]

I choose to build a kernel, which fills memory, exercises a JFS
filesystem and probably writes temp files to /tmp on JFS.  `make 
install` installs the kernel to /boot on JFS.  [BTW, `make install` 
can stall when /boot is within a NILFS2 / partition, but that has 
not been tested since I started using a separate /boot partition.] 

There is a much higher chance that shutdown will hang before the
NILFS2 partitions are umounted.  A simple `mount` placed before the
`sync` shows that umount is honoring the "nonilfs2" flag, and the
NILFS2 partitions are still mounted.  So why would the sync *before*
the umount of NILFS2 partitions get hung between segctord and sync,
when mount supposedly has not umounted the NILFS2 partitions yet?
This is why I mentioned the sync issue and the umount issue at the
same time.

Could it be that `umount ... nonilfs2` causes /etc/mtab to be
modified, which is updated by NILFS2 on /, but it is not done in 
time to make sync (or the next `umount ... nilfs2`) happy?  I'm 
only speculating on this idea.

Thanks!

Michael

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
