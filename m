From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix segctor bug that causes file system
 corruption
Date: Fri, 03 Jan 2014 02:17:03 +0900 (JST)
Message-ID: <20140103.021703.220046134.konishi.ryusuke@lab.ntt.co.jp>
References: <1388674131-22579-1-git-send-email-andreas.rohner@gmx.net>
	<741898E4-B794-47FF-ABF6-2DCACA2AED43@dubeyko.com>
	<52C5961F.8000608@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52C5961F.8000608-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi, Andreas, and Vyacheslav

On Thu, 02 Jan 2014 17:38:55 +0100, Andreas Rohner wrote:
>> Of course, you can discover some new issue. But, currently, I can't
>> understand relation between the error message from
>> nilfs_sufile_do_cancel_free() and next messages from
>> nilfs_bmap_last_key() from your description. So, I need to think
>> over your description more deeply and I need in confirmation that
>> you reproduce the issue with presence of patch [1] in your kernel.
> 
> I am sorry if my description was not clear enough. The problem is with
> the retry loop in nilfs_segctor_collect. If the current segment buffer
> is full a new segment is allocated and the collection is retried. But
> if the allocation of a new segment happens before
> nilfs_sufile_cancel_freev, there is a possibility, that a segment is
> selected, that before was freed during nilfs_segctor_collect_blocks.
> Now the collection is retried and the segments are freed again. This
> time though the newly allocated segment is freed as well, without any
> error messages. It is still used to write active data, while it is
> marked as free in the SUFILE. At some later time it is overwritten,
> which can cause all kinds of errors.

Thank you for posting this patch.

I reviewed the patch, and yes, the patch looks correct and needed to
fix the retry logic of nilfs_segctor_collect().

I am thinking of sending this to upstream.  But, before that, please
test the patch enough in the same situation to confirm that it
actually fixes the problem and it doesn't cause other issues.

At this point, I feel this patch has no defects nor side effects, but
I cannot test it in the same situation until the next week.


Thanks,
Ryusuke Konishi

> If you follow the 10 steps I outlined in my commit message, you should
> be able to see the problem. If some of the steps are unclear, I am
> happy to provide a more thorough explanation.
> 
> best regards,
> Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
