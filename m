From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Cleancache [2]
Date: Wed, 15 Jun 2011 01:17:28 +0900
Message-ID: <BANLkTikdQLrp3EMGq=BV83BQKKkN1Emdcw@mail.gmail.com>
References: <20110608.230231.65968027.ryusuke@osrg.net>
	<201106131521.15372.dexen.devries@gmail.com>
	<20110613.234048.21322431.ryusuke@osrg.net>
	<201106132004.41118.dexen.devries@gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=CM0O+vQNPd26y+DFzzYNMVEJx2vcC62YDe5yhNty1ck=;
        b=l4Jodsm/IC0Ps4r+SkO9nz7svnAzEDPgdZHNGvHM6DoL/XKGX4cMxCtcev6MsX+Ajt
         CFI0ogbw3/PVOCIfwrDw4h437i1Yixlkp+THBmbZsjLlH1K8iGUUHpKdNZlBv0/BBr8+
         oYzIyVfLRTfMbbXIQUn0mDhxYSzF6FoX5KqCY=
In-Reply-To: <201106132004.41118.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

2011/6/14 dexen deVries wrote:
> On Monday 13 June 2011 16:40:48 you wrote:
>> Is it reproducible without zcache?
>
> I don't know how to check cleancache without zcache; cleancache itself doesn't
> do anything unless it has some backend configured, and zcache is the only
> backend I know of and can use.
>
>
> To enable zcache you need to have one `zcache' argument in kernel's command
> line.
>
>
> There's an outstanding bug in zcache's build system:
> http://code.google.com/p/compcache/issues/detail?id=91
>
> In short, core part of zcache may end up not being compiled at all ;-(
>
> To build zcache in 3.0-rc2, you need to hack it a bit with the attach'd patch.
> Basically it renames the `zcache.c' to `zcache-core.c' and updates Makefile.
>
>
> To verify zcache is enabled, look through dmesg for two lines like:
>> zcache: cleancache enabled using kernel transcendent memory and compression
> buddies
>>zcache: created ephemeral tmem pool, id=0

Thanks a lot, dexen.

The oops has not been reproduced yet, but I could see
/sys/kernel/mm/cleancache/* change.

I will try to catch the issue again this weekend.

Thanks,
Ryusuke Konishi

> --
> dexen deVries
>
> ``One can't proceed from the informal to the formal by formal means.''
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
