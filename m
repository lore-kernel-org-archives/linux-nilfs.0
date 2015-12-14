From: Viacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Cleaner crashes, can't read source blocks, error=-5
Date: Mon, 14 Dec 2015 11:00:11 -0800
Message-ID: <1450119611.2617.2.camel@slavad-ubuntu-14.04>
References: <CAJEMKXOZuojpXq7T4iAN5101AADe1XbbrCUt1L66PM5w6POg6w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=Yfl6cNevs3Xka7rbq1M63wReSG/bWPLira5Lsc+/u4w=;
        b=Zh+y2I0m8fvjISLxYjG0Q1jYW7Dtr/NzFN4k6C5zOWWGpqJ1O/ufGv7zSqLpXoGL65
         0zof5iwsyENFnACR+JWTZJfzzLsfOQazaN2F4BOyNuwlyd49DZusCf4HDhsLqk9BlA2S
         099cerShsJFqCUG2noQ/Fj1sVZdUyWMFUi4C0hJDCLLyLo4mW1fSJIGRezqaKwnGkwe9
         6G+4gbTuXU54VRIEG3A3811xr4AAZ2htMjmirkhTG2lFpns+i018cq6YHrttQNtkbxZl
         0MK9wrflcWGfVOBOd6HqcITVwADh4WyHhj9aTpFr5i8y9AfonBSOKpj7A0wNoKH+MKtd
         N7uw==
In-Reply-To: <CAJEMKXOZuojpXq7T4iAN5101AADe1XbbrCUt1L66PM5w6POg6w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Brian Cottingham <spiffytech-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Brian,

On Mon, 2015-12-14 at 10:11 -0500, Brian Cottingham wrote:
> My nilfs2 partition has filled up, and I can't free up space because
> nilfs_cleanerd crashes. This is what I get in syslog:
> 
> ----
> Dec 14 09:49:38 spiffyhome nilfs_cleanerd[1580]: start
> Dec 14 09:49:38 spiffyhome nilfs_cleanerd[1580]: pause (clean check)
> Dec 14 09:49:38 spiffyhome nilfs_cleanerd[1580]: resume (clean check)
> Dec 14 09:50:45 spiffyhome kernel: [  149.008559] NILFS: GC failed
> during preparation: cannot read source blocks: err=-5
> Dec 14 09:50:45 spiffyhome nilfs_cleanerd[1580]: cannot clean
> segments: Input/output error
> Dec 14 09:50:45 spiffyhome nilfs_cleanerd[1580]: shutdown

Could you please share version of Linux kernel and version nilfs utils
on your side at first? Do you use some special configuration options for
GC?

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
