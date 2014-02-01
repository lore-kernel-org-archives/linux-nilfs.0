From: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1] nilfs2: add mount option that reduces super block writes
Date: Sat, 1 Feb 2014 20:05:12 +0100
Message-ID: <CAFvQSYSkd=i90zX7hYi8g5Wj=+FfymaRnKd7nm9ChYLGk=3yxw@mail.gmail.com>
References: <CAFvQSYSu5CGxs+K6bZUCtq17PrS_paX3bXBuLBRTba_XWYGgAg@mail.gmail.com>
	<cover.1391048231.git.andreas.rohner@gmx.net>
	<75ceb45c464097ab556baacf2d15d6ae4b792bb2.1391048231.git.andreas.rohner@gmx.net>
	<127C78C3-9D47-439C-9639-263BC453D98D@dubeyko.com>
	<52E9EB06.1000504@gmx.net>
	<8DBE8E18-F678-44B0-A6A6-5AFEC227AA86@dubeyko.com>
	<52EA2002.1030809@gmx.net>
	<A6830DB2-DC73-4ACC-BE73-7A6EC1AC7C18@dubeyko.com>
	<52EA38A3.8060107@gmx.net>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=g/xEAX/jGLcp8kf94bzGeWatVJ2WQJchovtgLhjrjOQ=;
        b=nks80GuVfQMpDAweQ0UCV762CPvVMwCzXU5FF5bP7ckED4rzna2KgvhOcSVPh1Xgs0
         lY4Fa/DeoS0rHqTiSxcNg1h42FUIGhI3RoVOAliuKX/If+UpenKjehFoBu8JLdnx4weB
         nvH+fbztjJEwXS/fseX4txx2oQawqOgqMB9eH4enje5sgO/XxMqxondtNGDEzcdFMhmU
         J7fD4Pir3V+LfvpEiNQJLsdaocRKeGRVUttORZcjxDOroUxLrpMcDzyBiWjGe9GxoFiE
         IVX9ruwe7i/ymA87oNsBkmPiun0Tz4cPKGFIUH0WO8TBsZpsPGrXHR0/6hZCxiOApLpx
         zmsA==
In-Reply-To: <52EA38A3.8060107-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andreas,

Because modifying NILFS_SB_FREQ requires a kernel-recompile anyway, I
gave your patch a try.
So far everything seems fine and the filesystem survived a series of power-cuts.
Although this doesn't prove the code is safe under all circumstances
of course, it seems stable enough for my use case on the raspberry pi.

I also did some tests on the raspberry with unclean shutdowns and
recovery is barely noticeable on the 8GB SD card:

unclean shutdown with recovery:
> time mount -o bad_ftl /dev/mmcblk0p3 sd_8gb
> real        0m3.552s
> user        0m0.020s
> sys        0m0.430s

mount following a proper unmount:
> time mount -o bad_ftl /dev/mmcblk0p3 sd_8gb
> real        0m1.219s
> user        0m0.020s
> sys        0m0.280s

For me the patch somehow reminds me of running ext4 with journaling
disabled - it reduces writes at the cost of longer recovery times
after an unclean shutdown. The big difference with nilfs2 is that I
don't have to worry the FS won't survive it ;)

Thanks, Clemens

PS: The only thing I don't really like is the name of the mount option ;)
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
