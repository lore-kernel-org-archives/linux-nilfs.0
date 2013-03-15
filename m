From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Corrupted nilfs2 volume
Date: Fri, 15 Mar 2013 10:21:31 +0400
Message-ID: <1363328491.2078.21.camel@slavad-ubuntu>
References: <20130315024019.7DC1BD00@mail.dragonworks.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=JIrFy4C3T8jw2jD/ln3TwmWDRhD/xQYc7nE+QG6JRps=;
	b=Oszx4nm3HBKjW15GI295AD+3sJnVWRoTKTVW3HSB/j/TtgCFU29MSA2Lq+ilNA8s5m4gDaLdC3kO8YQXYBimiejQim2xnQb0aR+NTYdX3KTDwH9ZaG0J+BdJQDTxo9I1;
In-Reply-To: <20130315024019.7DC1BD00-foQFVU7ZUqen8/iIaQqUdCjHesifYMBh@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexander Bezrukov <nilfs-issues-tvrqcU/I3+LBxmVkcvZ8vQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Alexander,

On Fri, 2013-03-15 at 06:40 +0400, Alexander Bezrukov wrote:
> Hello!
> 
> First of all, thank you for the nilfs2.
> 
> I have been using this filesystem for few years on different types of storage ranging from small SSDs to huge 10+TB volumes on big arrays with no a single problem but now I am stuck with a broken volume.
> 
> The long story short. I have a laptop which runs vanilla linux-3.8.2 with nilfs on root partition (and nilfs-utils-2.1.4, if that matters; the volume has been created with 2.0.*-series of nilfs-utils with default options). Yesterday I noticed it doesn't switch its display off (probably because of some failed io) and continously displays a screensaver but I didn't touch it. Today I touched it to see that it deadly hung. I had to power cycle the laptop and since then the kernel cannot mount rootfs with:
> 
> NILFS: Invalid checkpoint (checkpoint number=5439464)
> NILFS: error loading last checkpoint (checkpoint number=5439464)
> 

Had you any snapshots on this volume?

It needs to investigate the issue more deeply. Could you try to mount this volume under another system? I hope that it gives opportunity to get more details about the issue from system log. So, could you share NILFS2 related messages for such try?

> I booted from a USB flash and inspected S.M.A.R.T attributes of the HDD. It looks absolutely healthy.
> 
> Of remarkable events, couple of months ago I have managed to make the / partition full. My distro has made a change in its initscripts (or maybe udev rules, I don't remember exactly) which led to /dev/root symlink no more created. With no /dev/root, nilfs_cleanerd didn't start, this lead to the full root partition and at the end /etc/mtab could no more be created early at boot. I rebooted with init=/bin/bash, remounted / read-write, started nilfs_cleanerd manually, waited until it cleans space and manually fixed the problem with /dev/root. After that I used my laptop for about two months, absolutely flawlessly.
> 
> To my best knowledge there is no "official" fsck tool for nilfs2 but at times nilfs2 has just been added to the mainline kernel I read somewhere about some "unofficial" version at some developer branch.
> 

I send you personally archive with actual state of fsck.nilfs2. I need in debug output of the fsck.nilfs2 for analysis of situation on the volume.

> Anyway, is there any chance to debug the problem and probably cure the volume?

I hope that we can recover your volume. But, anyway, we need to analyze the issue and try to cure the volume.

With the best regards,
Vyacheslav Dubeyko.

> I would be happy to provide any additional information.
> 
> Thanks in advance.
> Alexander
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
