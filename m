From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Best way to shut down NILFS2? (umount hang issue)...
Date: Thu, 19 Sep 2013 10:22:53 +0400
Message-ID: <1379571773.2310.5.camel@slavad-ubuntu>
References: <5238DAD8.3070804@gmail.com>
	 <1379485106.2365.11.camel@slavad-ubuntu>
	 <CAJzLF9nbfM6aY8u57Lgkm4r_mpBtd96J=HaqSnF=+oLvhYpmUw@mail.gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=orXcbI7tYWUoQSJVBAwQnH1amb87DbUh10X+fpsXaPc=;
	b=rvjmcWdjLEM+IuQBNbOXDVW/N0XAtHyHY1aruD0A60bnVKOPF0bbC/EWP0mGduKuXBG2StmM2ITJvB+2N3O+AQ1YHNILVPYmCQGwgeUCOpz4GuwClnlppXYTjc4I0rcx;
In-Reply-To: <CAJzLF9nbfM6aY8u57Lgkm4r_mpBtd96J=HaqSnF=+oLvhYpmUw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, 2013-09-18 at 12:26 -0400, Michael L. Semon wrote:

[snip]
> >
> > As far as I can see, your NILFS2 file system was remounted in RO mode
> > because of internal error. Could you confirm my understanding?
> 
> Yes, but only on reboot.  Other programs crash the PC, and NILFS2 has to
> recover from that crash.  The PC spends a lot of time running xfstests and
> LTP with a kernel that is set to panic.  NILFS2 itself seems OK, and its
> latest xfstests run looked good, using default mkfs.nilfs2 options and
> mounting with "-o pp=0".

[snip]
> 
> It is strictly like this so far:
> 
> 1) NILFS2 / boots OK
> 2) no problems
> 3) shutdown is OK
> 4) NILFS2 / boots OK
> 5) computer crashes for some other reason
> 6) NILFS2 / boots OK, but displays a message that recovery was used
> 7) no problems
> 8) here, shutdown may hang on sync or umount (50% chance)
> 
> In other words, NILFS2 has not had an error to make it remount read-only
> while the PC is running.  The problem may solve itself over time, or I
> may have to boot to another partition, then mount and umount the NILFS2
> partition to get it to recover and umount cleanly again.
> 

So, maybe it is another issue.

[snip]
> 
> I'll try your patches tonight and report back in 1-2 days.
> 

Ok. Please, inform me about the result anyway. If suggested patches
don't fix the issue then I will begin investigation.

But, I begin to suspect presence of another issue after additional
analysis of provided by you outputs. So, I am waiting results of your
attempt.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
