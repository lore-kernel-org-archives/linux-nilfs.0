From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Best way to shut down NILFS2? (umount hang issue)...
Date: Fri, 27 Sep 2013 10:13:15 +0400
Message-ID: <1380262395.3154.0.camel@slavad-ubuntu>
References: <5238DAD8.3070804@gmail.com>
	 <1379485106.2365.11.camel@slavad-ubuntu>
	 <CAJzLF9nbfM6aY8u57Lgkm4r_mpBtd96J=HaqSnF=+oLvhYpmUw@mail.gmail.com>
	 <1379571773.2310.5.camel@slavad-ubuntu> <523B866D.9060406@gmail.com>
	 <1379664873.2280.11.camel@slavad-ubuntu> <523E6203.2090509@gmail.com>
	 <1380097004.2335.23.camel@slavad-ubuntu> <5244A4D1.8000705@gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=3+p+vO6vWMhNg3awQloGB0Q0SwH60MmlRTLjoFme22g=;
	b=CKcRyWL7Y05lLDPqXwcjQAR09Cp7VpJeX+DNUBANOfuk1JHfkbJbfWPWevZoEl/ZiNrPiqHn2jwJdj7Rkp6vM38lvb+HV9cBUqXNMQbwezg0XuynZaSLq1slxDSnc1Hs;
In-Reply-To: <5244A4D1.8000705-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Michael,

On Thu, 2013-09-26 at 17:19 -0400, Michael L. Semon wrote:

> Update:  Now I understand why you can't reproduce the issue.  I reduced 
> the test scripts down to something like this:
> 

Ok. Thank you. I'll try to reproduce again.

> I have one kernel for which I can remove config items, and I have one 
> kernel where I have to enable kernel config items.  Other than 
> CONFIG_POSIX_MQUEUE, what items does nilfs_cleanerd need to start?  
> I have yet to get it started from a minimal kernel config.
> 

I don't try to use NILFS2 with minimal kernel config. But you can get
some details from FAQ [1]. As far as I can see, you need to enable:
CONFIG_SHMEM, CONFIG_TMPFS, CONFIG_POSIX_MQUEUE.

Thanks,
Vyacheslav Dubeyko.

[1] http://www.nilfs.org/en/faq.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
