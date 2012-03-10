From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Another question on nilfs_cleanerd
Date: Sat, 10 Mar 2012 11:40:47 +0900 (JST)
Message-ID: <20120310.114047.103728078.ryusuke@osrg.net>
References: <CAHmELnVsrSUSkJeJJX8p9h2+47MGWdLLiepXBYrEbJtvTEBpEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHmELnVsrSUSkJeJJX8p9h2+47MGWdLLiepXBYrEbJtvTEBpEQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: klangga-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Sat, 10 Mar 2012 00:15:28 +0800, Kenneth Langga wrote:
> What happens when cleanerd is interrupted while it's cleaning by
> unmounting the drive, for example, and then mounted again? Does it
> resume from the previous block or does it start from the beginning?
> Thanks.

Cleanerd is safely interruptible either by unmount or a SIGINT signal.

If you mount the drive after that, GC restarts from the previous block
because the current GC algorithm selects target segments in
chronological order.

However, it will forget execution states.

If you were doing one pass cleaning kicked by nilfs-clean command, and
then unmounted and mounted again, GC doesn't resume.

If the ratio of free segments is smaller than max_clean_segments but
larger than min_clean_segments, it doesn't resume even if it was
running previously by watermark control using these threshold values.

Cheers,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
