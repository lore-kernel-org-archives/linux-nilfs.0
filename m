From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Kernel Bug: unable to handle kernel paging request
Date: Fri, 16 Aug 2013 11:03:30 +0400
Message-ID: <1376636610.2301.28.camel@slavad-ubuntu>
References: <CALJXSJqV5nYb_t6GMS0FpWyf1aRehAgpvebwgbJzMJfctf1b2A@mail.gmail.com>
	 <1376054125.2272.84.camel@slavad-ubuntu>
	 <20130815.073806.260411879.konishi.ryusuke@lab.ntt.co.jp>
	 <20130816.134934.27810145.konishi.ryusuke@lab.ntt.co.jp>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=aQ4ZpqYe3vWKIHgGtEZOZ4VN9VZD1EY8d+v2HItSQPY=;
	b=SgnY300EH/+lrTYRwuS28UPcLyrSvVkfRgOI6MCvdyR8TlzwiLMkJaBlaRyNnV1WZq21CidhxkyFbc6a5LbpY+B4kCGTt0R/7Ev0JjsqHTH1p+LD7PHKMRwqE9StVidO;
In-Reply-To: <20130816.134934.27810145.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi Ryusuke,

On Fri, 2013-08-16 at 13:49 +0900, Ryusuke Konishi wrote:
> Hi Vyachelav,
> 
> I haven't yet succeeded to reproduce this issue even with apt-get
> update operation.
> 
> How long did it take to reproduce this issue in your environment ?
> 

I reproduce the issue stably in my environment. But sometimes I need to
repeat reproducing path several times before achieving the issue.
Usually, the issue is reproduced on the phase of "Reading package
lists...". But it is hard to predict on what concrete percent of
operation progress you will reproduce the issue.

I have such version of the kernel: Linux 3.10.0-rc5+ #45 SMP Thu Aug 8
17:20:43 MSK 2013 x86_64 x86_64 x86_64 GNU/Linux. This is Ubuntu 12.04.2
LTS (GNU/Linux 3.10.0-rc5+ x86_64) distro.

I simply start four terminal windows in parallel with root permissions:
(1) "tail -n 30 -f /var/log/syslog" output;
(2) "top" output;
(3) start kernel compilation;
(4) start apt-get update;

> According to reported logs, the crash seems to occur at the following
> BUG_ON() which is inlined in nilfs_end_page_io() function:
> 
> #define page_buffers(page)                                      \
>         ({                                                      \
>                 BUG_ON(!PagePrivate(page));                     \
>                 ((struct buffer_head *)page_private(page));     \
>         })
> 
> However, it's hard to narrow down the cause without reproducing the
> issue.  The page private flag is used to indicate that the given page
> has buffer heads.  So, this issue seems to be caused by that an
> invalid page was passed to nilfs_end_page_io() or
> try_to_free_buffers() freed the buffer head by some reason.
> 
> The latter situation can occur if the following buffer_busy() function
> unexpectedly failed for the buffer head:
> 
> static inline int buffer_busy(struct buffer_head *bh)
> {
>         return atomic_read(&bh->b_count) |
>                 (bh->b_state & ((1 << BH_Dirty) | (1 << BH_Lock)));
> }
> 
> Since BH_Dirty is dropped in nilfs_segctor_complete_write() function,
> I suspect the situation that bh->b_count mistakenly reached zero.
> 
> Anyhow, further debug seems hard without reproducing the issue.
> 

Yes, I see. I will take into account your considerations about possible
reason of the issue. Thank you.

Unfortunately, I haven't opportunity for the issue investigation during
this week. I think that I can check your suspicion during today. Anyway,
I will continue investigation of the issue on the next week.

Sorry that I don't answer on your previous e-mail. I were busy.

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
