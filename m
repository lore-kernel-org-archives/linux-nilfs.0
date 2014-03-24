From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: attempt to access beyond end of device
Date: Mon, 24 Mar 2014 11:37:35 +0400
Message-ID: <1395646655.2178.20.camel@slavad-CELSIUS-H720>
References: <20140324071357.GY4686@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=ZwRuVfRNYsHLwjYVYPZ3o5D5vBgM4QgpsgIVkPC4XEI=;
	b=Sgkq7FP0Os8QsliKqhUmslNNN5QtrUiCoaPJdFVbY93Xy5gKHzpFjPLCkQjKO8Czpt3GDHkxFmARAgb/XTPZC5sMQf2Ms/9y4zuStcZSfGkV8S5AU97Ut1caT/jqJXHP;
In-Reply-To: <20140324071357.GY4686@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Piotr,

On Mon, 2014-03-24 at 08:13 +0100, Piotr Szymaniak wrote:
> Hello,
> 
> I'm running nilfs2 on Raspberry Pi and some time ago it got some
> problem.
> 
> Connected the SD card to my PC today and mounted the fs, the cleaner
> started and few minutes later it remounted the fs readonly. Here's the
> dmesg part:
> 
> [ 1109.889697] mmcblk0: mmc0:b368 SMI   7.51 GiB 
> [ 1109.891261]  mmcblk0: p1 p2 p3
> [ 1129.467450] NILFS warning: mounting unchecked fs
> [ 1129.956859] NILFS: recovery complete.
> [ 1129.960064] segctord starting. Construction interval = 300 seconds, CP frequency < 30 seconds
> [ 1129.979344] NILFS warning: mounting fs with errors
> [ 1283.005874] attempt to access beyond end of device
> [ 1283.005882] mmcblk0p3: rw=8192, want=145241775180196072, limit=15120384

I see that it was requested 8 KB block. How did you create file system?
Could you share the superblock content?

> 
> Should I check the card in the first place?
> 

Currently, I suspect that you have bad SD card. But, maybe, you have
something different.

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
