From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs2 per directory quota
Date: Sun, 26 Jun 2011 14:48:29 +0200
Message-ID: <201106261448.30236.dexen.devries@gmail.com>
References: <4E070070.1060502@linuxsystems.it> <201106261346.31869.dexen.devries@gmail.com> <4E071EF5.1070301@linuxsystems.it>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:resent-from:resent-to:resent-date
         :resent-message-id:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id:x-uid;
        bh=vzCDqaeTb39zBZ/BKNeagN5gnO52TpIbC47vBJiudXY=;
        b=uIC/A5XZg9X4Fo6B4j4i++Eu9l/PnlngfcpHIER8bI8E240M4B6nnsC55yP+BmVZKO
         UFkMC1HxE9jXUy7coi3F8RjAJSGjzQkRmQnlV2Bz7Oaop5TPfRPauYApDHy4qBd73eD4
         PquVmXt1J+KWzFUyIIbWiRkNguj/TGq5NUxaE=
In-Reply-To: <4E071EF5.1070301-DEeHIYRtcplPMsqi6aon0Q@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: =?iso-8859-15?q?Niccol=F2_Belli?= <darkbasic-DEeHIYRtcplPMsqi6aon0Q@public.gmane.org>

Hi again,


On Sunday 26 June 2011 13:58:45 you wrote:
> Il 26/06/2011 13:46, dexen deVries ha scritto:
> > casually looking through NILFS2 sources, I don't see quota support, but I
> > may be wrong there.
> 
> I read about per directory quotas in slashdot:
> http://linux.slashdot.org/comments.pl?sid=1287319&cid=28536529

I'm affraid the meaning of the post is ``I wish NILFS provided those:'' (the 
``but how about having some real features'' bit).


> > Why isn't XFS a viable option for you, if I may?
> 
> XFS *is* a viable option, but it was a chance to test a new fs ;)

I've been using XFS for several years, also in configuration with external 
journal for extra performance. NILFS2 comes close, if not beter, in 
performance in some cases; mostly for writting new data. For example, recently 
checked out all linux kernel sources on a 5.400 RPM laptopd hdd, and it was 
pretty darn fast. On the other hand, simply traversing the filesystem when 
metadata is not cached can be slow.

Current implementation of NILFS2 has certain on-disk inefficiences in regard 
to metadata, for example it doesn't use extents. The folks at NTT are working 
on improving stuff.




You may also want to check out
http://en.wikipedia.org/wiki/Fossil_(file_system)
http://en.wikipedia.org/wiki/Venti
which are available on any POSIX  environment via 
http://en.wikipedia.org/wiki/Plan_9_port

I don't think Fossil provides any quota support, but when coupled with Venti, 
it pretty much removes the need for it :P


Regards,
-- 
dexen deVries

> (...) I never use more than 800Mb of RAM. I am running Linux,
> a browser and a terminal.
rjbond3rd in http://news.ycombinator.com/item?id=2692529
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
