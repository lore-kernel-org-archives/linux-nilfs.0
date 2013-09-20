From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Best way to shut down NILFS2? (umount hang issue)...
Date: Fri, 20 Sep 2013 12:14:33 +0400
Message-ID: <1379664873.2280.11.camel@slavad-ubuntu>
References: <5238DAD8.3070804@gmail.com>
	  <1379485106.2365.11.camel@slavad-ubuntu>
	  <CAJzLF9nbfM6aY8u57Lgkm4r_mpBtd96J=HaqSnF=+oLvhYpmUw@mail.gmail.com>
	 <1379571773.2310.5.camel@slavad-ubuntu> <523B866D.9060406@gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=08ymVuF0Ua+0LABQnxWPr4xbNCbmrTvSQ5rQZn5Z/XY=;
	b=r5hi+u8ShmDj2p67sayLIqNEL6fbAfuyPJWhB+JBVUmQanDCgXYz0VcDsURu9ldMsj1a9PJts6eAVpZc14VRsH4MTGPpkkMXqosg3+r1zlfXeLvefjGjTUbh3K+hmIll;
In-Reply-To: <523B866D.9060406-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Michael,

On Thu, 2013-09-19 at 19:19 -0400, Michael L. Semon wrote:

[snip]
> 
> The issue still happens.  One patch was already in the kernel, and
> the second patch you mentioned did not make much of a difference.
> The second patch is still installed, though.
> 

Ok. Thank you for report. I'll try to reproduce the issue, firstly.

> The problem I mentioned above is the one that is easy to explain.
> The crash doesn't even have to stress the computer:  A simple
> SysRq-induced crash should be enough to get the problem started, 
> though the PC might need to be crashed more than once.
> 
> I've changed / to mount as errors=panic, but there has been no 
> panic yet.
> 
> # ================
> 
> Here is where the overall problem becomes hard to explain.  Consider this 
> scenario:
> 
> / is NILFS2 (rw,order=strict)
> /boot is JFS
> /tmp is JFS
> /usr/src is JFS
> 
> Because I don't want the hung NILFS2 umount to give problems to /tmp and 
> /usr/src, I adapted the end of the standard Slackware shutdown script to 
> look something like this:
> 
> /bin/umount -v -a -t noproc,nosysfs,nonilfs2
> 
> # This line can be here to show a sync problem, or removed 
> # to show a umount problem....
> sync
> 
> /bin/umount -v -a -t nilfs2
> 
> echo "Remounting root filesystem read-only."
> /bin/mount -v -n -o remount,ro /dev/sdb12 /
> 
> [I can get you the exact script next time.]
> 

Ok. Please, share all additional details (or script) that it will be
helpful for the issue reproducing from your point of view.

So, I need in such details:
(1) Could you share the output of "nilfs-tune -l"?
(2) Could you share /etc/fstab content and "mount" output for the
reproduced issue case?
(3) Could you share "fdisk -l" or "parted -l" output?
(4) Could you share /etc/nilfs_cleanerd.conf content?

> I choose to build a kernel, which fills memory, exercises a JFS
> filesystem and probably writes temp files to /tmp on JFS.  `make 
> install` installs the kernel to /boot on JFS.  [BTW, `make install` 
> can stall when /boot is within a NILFS2 / partition, but that has 
> not been tested since I started using a separate /boot partition.] 
> 
> There is a much higher chance that shutdown will hang before the
> NILFS2 partitions are umounted.  A simple `mount` placed before the
> `sync` shows that umount is honoring the "nonilfs2" flag, and the
> NILFS2 partitions are still mounted.  So why would the sync *before*
> the umount of NILFS2 partitions get hung between segctord and sync,
> when mount supposedly has not umounted the NILFS2 partitions yet?
> This is why I mentioned the sync issue and the umount issue at the
> same time.
> 
> Could it be that `umount ... nonilfs2` causes /etc/mtab to be
> modified, which is updated by NILFS2 on /, but it is not done in 
> time to make sync (or the next `umount ... nilfs2`) happy?  I'm 
> only speculating on this idea.
> 

I hope that I have enough details for successful reproducing of the
issue. But if I encounter some troubles then I'll ask you about
additional details. I'll share results of my attempt, anyway.

So, I think that it needs to reproduce the issue and to investigate it
before answering on your questions. :)

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
