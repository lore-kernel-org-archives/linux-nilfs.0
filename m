From: Heinz Diehl <htd+ml-iEI8Y0CNJBYdnm+yROfE0A@public.gmane.org>
Subject: Re: Where is nilfs2 fsck
Date: Mon, 8 Feb 2016 22:53:28 +0100
Message-ID: <20160208215328.GA7586@fritha.org>
References: <20160208135344.09a64c7e@ulgy_thing>
Reply-To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160208135344.09a64c7e@ulgy_thing>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 08.02.2016, David Niklas wrote: 

> Alas, my beautiful fs has become damaged and fsck does nothing, I think
> it's a nop.
> What is wrong, something in the btree, the original message was in
> syslog but it seems to have rotated, I could tell you but I'd have to
> cause my kernel to remount my home dir RO, which is not acceptable at
> this time.
> I'm not interested in the files that can't be accessed, I was trying to
> delete them when I found the error so even an experimental fsck would do.
> I do have nilfs2-utils installed but I can't find anything useful in
> there.
> Do I need to backup and reformat the partition?

There is no fsck.nilfs or similar, so yes. Nilfs2 automatically recovers most
of the time, though, so there may be underlying hardware failure. I've
been using it extensively in the last 2 years, and never seen a single
fs damage which didn't get recovered immediately.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
