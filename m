From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs error
Date: Tue, 10 Dec 2013 10:45:40 +0400
Message-ID: <1386657940.4007.24.camel@slavad-ubuntu>
References: <CAJgyHGOeRhj7D4GeyfHhBjXLE3K40DiakT2Zms2D7TPB-BiRog@mail.gmail.com>
	 <BA9C3894-7D2F-4FA1-88DE-E830102A0B5D@dubeyko.com>
	 <CAJgyHGMmxs8RUiFiZyJW2xNODuip_1yYkUTZ1_-VSPWivtHeSg@mail.gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=p/rWsjyyEmOiv81wPyH6ePKGYR1PgQeW/xXMwy6/VVU=;
	b=En81d+9tFqKCkEPm6iKCHtZo6e7GG3fzgSMWbT/c8M66LQdVhvj0NLbDUyu9qaH86ETT0Y8GsMIlJbVMj7ppxS4Wvsf2RWryfC9n/uHfSYusTigNe/VBeLMuijQfx36I;
In-Reply-To: <CAJgyHGMmxs8RUiFiZyJW2xNODuip_1yYkUTZ1_-VSPWivtHeSg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jon Watte <jwatte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 2013-12-09 at 08:33 -0800, Jon Watte wrote:
> I am using Linux robot1 3.12.3-1-ARCH #1 SMP PREEMPT Wed Dec 4
> 21:45:42 CET 2013 x86_64 GNU/Linux
> 
> Is that an "old" kernel?
> 

I can see that v3.12.2 tag contains the patch is mentioned by me.

> Also, note that an "old" kernel (from February this year) could mount
> this image, whereas this newer kernel hung. Is that consistent with
> the changes you have done?
> 

> NILFS: bad bree node (blocknr=1364234) ; level = 100; flags = 0x73; nchildren = 12336
> NILFS error (device sda1): nilfs_bmap_lookup_contig: broken bmap (inode number=3935)

Such error messages mean that you have corrupted NILFS2 volume. My patch
doesn't recover NILFS2 volume. It fixes the reason of such corruption.
And corruption of NILFS2 volume takes place without any visible
symptoms. So, you had volume corruption more earlier than you have
discovered the issue. I have such vision of the situation on your side.
Your NILFS2 volume was corrupted on kernel version that it doesn't
contain my patch. And you had discovered the issue after kernel update
only by chance. It is simply coincidence, from my point of view.

I suppose that error messages are emitted by nilfs-cleanerd. So, you can
mount volume without any troubles if nilfs-cleanerd doesn't work.

Of course, I can be not fully correct in treating of your situation. The
error message about broken bmap is very common and there are many
possible reason of it. But, anyway, this message means corruption of
volume. As a result, I need in reproducing path of the issue. I can't
investigate and fix the issue without opportunity of reproducing the
issue on my side. Can you reproduce the issue from the state of valid
volume to corrupted state stably? And could you share reproducing path
of the issue?

If I am right in understanding of your issue then I suppose that
possible solution can be: (1) create new NILFS2 volume; (2) copy valid
data from corrupted NILFS2 volume; (3) continue using new NILFS2 volume
under last version of kernel version. Unfortunately, we haven't fsck
tool for NILFS2 yet.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
