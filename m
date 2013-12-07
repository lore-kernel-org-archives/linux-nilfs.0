From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs error
Date: Sat, 7 Dec 2013 13:34:19 +0300
Message-ID: <BA9C3894-7D2F-4FA1-88DE-E830102A0B5D@dubeyko.com>
References: <CAJgyHGOeRhj7D4GeyfHhBjXLE3K40DiakT2Zms2D7TPB-BiRog@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=UoWBbqw3FuNdusPaox/FZQoepwq4FKmjDq1okJPUYFg=;
	b=jXjF7p00xnMjaoCtsO2ThNtpXA4LHnGhKkFfwRhm/SPIpujjQMpKiKdkXKPzTXtiAUxKcIumwxuWhpeLp8FOzN1BATwjGphy72enGGgrgGxw/skEEvxyuCMDbD7rc2Cn;
In-Reply-To: <CAJgyHGOeRhj7D4GeyfHhBjXLE3K40DiakT2Zms2D7TPB-BiRog-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jon Watte <jwatte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Dec 7, 2013, at 5:17 AM, Jon Watte wrote:

[snip]
> However, yesterday when booting up agian, it refused to mount the root
> disk, and booting was halted, with the messages shown in the below
> photograph. Note that, because I can't boot, I can't get this output
> in a copy-and-paste-able form!
> 
> https://pbs.twimg.com/media/BaxOmptCYAABQuW.jpg:large
> 
> The two repeated messages are (typed in from the photo):
> NILFS: bad bree node (blocknr=1364234) ; level = 100; flags = 0x73;
> nchildren = 12336
> NILFS error (device sda1): nilfs_bmap_lookup_contig: broken bmap
> (inode number=3935)

What linux kernel version do you have?

I had fixed the reason of such problem by patch [1]. So, please check and
share your kernel version, firstly. I suppose that you are simply using old
kernel version.

With the best regards,
Vyacheslav Dubeyko.

[1] http://comments.gmane.org/gmane.comp.file-systems.nilfs.user/3082

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
