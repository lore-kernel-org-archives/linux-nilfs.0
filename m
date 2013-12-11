From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] nilfs2: rework error message subsystem
Date: Wed, 11 Dec 2013 10:43:06 +0400
Message-ID: <1386744186.3991.20.camel@slavad-ubuntu>
References: <1385993333.3945.3.camel@slavad-ubuntu>
		 <20131203162944.8f9ef3a08a3292a1959dd025@linux-foundation.org>
	 <1386138787.4014.17.camel@slavad-ubuntu> <52A74BD8.4030508@intellitree.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=feuXLbzEbALjV7MFa77KsQxMxYqgaOs/x0HLgbVr71Q=;
	b=PEk2G/BGqvRrlPhjS2xCF6qq3swGs0yoUQGmklpxdYW6r4yhxHyA/BbqGsUorf2KwL789L2tTRW+0ctntSjmoj0+PZ/DY/LArZGdkKI5+5VFs4SPRXkVUCWV9w0OJLyd;
In-Reply-To: <52A74BD8.4030508-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michael Conrad <mconrad-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, 2013-12-10 at 12:14 -0500, Michael Conrad wrote:

> I think this will help.  However, the idea I had in mind originally was 
> for nilfs to "give up" sooner.
> 
> I suspect that my nilfs partition became corrupt for hardware or 
> hardware-driver reasons.  So lets ignore that part for now.
> 
> With the data on the drive being corrupt, it appeared that nilfs 
> encountered an invalid directory (possibly just a long string of NUL 
> bytes?) and emitted more than a million errors about invalid structures, 
> triggering the soft-lockup watchdog and rebooting the system.  When I 
> recompiled my kernel with soft-lockup set to 5 minutes, it simply filled 
> my log files.
> 
> [10796.519283] NILFS error (device sdf1): nilfs_check_page: bad entry in 
> directory #2383620: rec_len is smaller than minimal - offset=1143304192, 
> inode=0, rec_len=0, name_len=0
> 
> I haven't read the code involved, but what I think should happen is that 
> on the very *first* error, it should return an I/O error to userland.  
> Also, the partition was set to "errors=remount-ro", so the very first 
> error should also make the filesystem read-only, correct?
> 

I think that your vision is correct. I am pondering about likewise
solution too. But, anyway, likewise fixes can be made locally only for
every concrete use-case. To change error messages correctly is easy. But
to suggest proper fix without an issue reproducing is impossible.

Anyway, I'll try to elaborate some fix. But my hands on another task
right now.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
