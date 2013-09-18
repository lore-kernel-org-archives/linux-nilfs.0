From: "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Best way to shut down NILFS2? (umount hang issue)...
Date: Wed, 18 Sep 2013 12:26:25 -0400
Message-ID: <CAJzLF9nbfM6aY8u57Lgkm4r_mpBtd96J=HaqSnF=+oLvhYpmUw@mail.gmail.com>
References: <5238DAD8.3070804@gmail.com>
	<1379485106.2365.11.camel@slavad-ubuntu>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=veLa94v/b9Z67pH8z+nPL9j4EddYiGYoNm19u4sU7JE=;
        b=QZ1cdgChq9O5oGO270MdQWGHmfDjVQ+2tL5ytFGCvTgnqWf2RxI0YC8Ac+0wV16Pc/
         vmDHZ3/Uzky/rDs6m/pUyXsz+ELDhdZikeNmtP0ntB2eMy2rfHlu4mYZGsRoSvuWj6kF
         Yzg1fgobD2nJ789kT2kiT7cqNrGbcPmsaeRuSQ4+Ne8LuEi+hAhbOwcTZ2000TMKVLnO
         r1aIpJT/DTT2BS7ni/GVfWD8kPGzvQ9SS9aPJZ2LQIRGh9fcvw9r0FNZQOMoUcl6eF8s
         LU4omItJ1AqZ+ZpmRUO0JLjCOWu8sNrUyyGIkQO/+JtLJCZir688/9/MZmYQHON+ZofQ
         3m2A==
In-Reply-To: <1379485106.2365.11.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Sep 18, 2013 at 2:18 AM, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:
> Hi Michael,
>
> On Tue, 2013-09-17 at 18:42 -0400, Michael L. Semon wrote:
>> Hi!  I have an old multi-boot x86 PC that I use for testing.
>> One of its root partitions is NILFS2, and it is booted via LILO and
>> a JFS-formatted /boot partition.  All seems fine, but the umount of /
>> can hang, especially when NILFS2 had to recover / on boot in read-only
>> mode due to a crash.  Using KDB to get stack traces, I wonder if
>> segctord is waiting for an event that will not happen.
>>
>
> As far as I can see, your NILFS2 file system was remounted in RO mode
> because of internal error. Could you confirm my understanding?

Yes, but only on reboot.  Other programs crash the PC, and NILFS2 has to
recover from that crash.  The PC spends a lot of time running xfstests and
LTP with a kernel that is set to panic.  NILFS2 itself seems OK, and its
latest xfstests run looked good, using default mkfs.nilfs2 options and
mounting with "-o pp=0".

>> [Actually, the umount of NILFS2 partitons can hang in other cases, too.
>> This is a narrow case that I can repeat fairly often.]
>>
>> Is there a guaranteed good way to shutdown nilfs_cleanerd and NILFS2
>> properly on system shutdown?  I tried to ensure that the killall5
>> program doesn't touch nilfs_cleanerd on shutdown, but that solution
>> has started to not work again.
>>
>
> So, if you have remount in RO mode after some file system operations
> then NILFS2 will have troubles with flushing and as a result with
> shutdown. Such situation takes place because of continuous trying to
> flush dirty pages without success in nilfs_write_page() and
> nilfs_mdt_write_page(). This issue was fixed in patch [1].

It is strictly like this so far:

1) NILFS2 / boots OK
2) no problems
3) shutdown is OK
4) NILFS2 / boots OK
5) computer crashes for some other reason
6) NILFS2 / boots OK, but displays a message that recovery was used
7) no problems
8) here, shutdown may hang on sync or umount (50% chance)

In other words, NILFS2 has not had an error to make it remount read-only
while the PC is running.  The problem may solve itself over time, or I
may have to boot to another partition, then mount and umount the NILFS2
partition to get it to recover and umount cleanly again.

> But I believe that now we understand the reason of the issue with
> remounting in RO mode. I posted the patch [2] two weeks ago. This patch
> is under discussion yet.
>
> Please, feel free to report about the issue again if these patches will
> not solve your problem.

I'll try your patches tonight and report back in 1-2 days.

Thanks!

Michael

> Thanks,
> Vyacheslav Dubeyko.
>
> [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8c26c4e2694a163d525976e804d81cd955bbb40c
> [2] http://www.spinics.net/lists/linux-fsdevel/msg68054.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
