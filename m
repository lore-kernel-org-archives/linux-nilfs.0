From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs2 not garbage collecting
Date: Sun, 5 Aug 2012 17:44:35 +0400
Message-ID: <F50BDE9A-4863-49CC-AC87-EEDC5B854E9C@dubeyko.com>
References: <CANku=ggohcWWoxE1x=XmfWpANKyWRTWb5p_aHh8LU6+utU4OPQ@mail.gmail.com> <CANku=ghnDzkFHpPZ8eT9Y3kTM62zBKMk6TjBVraE4Kisa1TRPQ@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=JCAvxjqIWkwST0U+mwRyoLpLrQx62nEueJmDjJHRTi0=;
	b=eXXW1fcTJ0ZW7O+vGgbfYf/88fKcQCFJG0DFkVpjhwYVJV3FTFkQbAAiPex8spZ0D5IfjLVEZRYcK9ouDfoDwKz+P8CQJYIVjGkWe3zLzLPxaLOUDTUn5mVBLdTMBAoL;
In-Reply-To: <CANku=ghnDzkFHpPZ8eT9Y3kTM62zBKMk6TjBVraE4Kisa1TRPQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paolo Giangrandi <paolo-UnihLHphgvQ1GQ1Ptb7lUw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Paolo,

By the way, did you try to use the rmcp utility? This utility is dedicated by removing of checkpoints by hands.

With the best regards,
Vyacheslav Dubeyko.

On Aug 5, 2012, at 3:00 PM, Paolo Giangrandi wrote:

> Hello,
> 
> I'm using NILFS2 as the root filesystem of an ArchLinux on my EeePC
> 900A. The filesystem has been created last November.
> At the moment there's no more space left, `lscp` shows that there are
> 2648 checkpoints, but nilfs_cleanerd is in idle.
> I tried to tweak nilfs_cleanerd configuration, but couldn't achieve anything.
> 
> Is it possible to know why nilfs_cleanerd isn't collecting the
> checkpoints, or force it to collect them?
> 
> Thanks,
> Paolo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
