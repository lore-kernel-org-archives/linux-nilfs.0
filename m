From: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Does nilfs2 do any in-place writes?
Date: Thu, 16 Jan 2014 11:03:00 +0100
Message-ID: <CAFvQSYSC7+dd93pRH-uok9N+A_s=1VKrfGEppu3qRTg3q=CuXQ@mail.gmail.com>
References: <CAFvQSYSzpX_WpUi9KpGj0pZvzhw2mfzzOqcgdj9ripXAjipmtw@mail.gmail.com>
	<1389783139.3913.23.camel@slavad-ubuntu>
	<CAFvQSYTG6HBVc9iodYyvCejwf889jiwOPsVb1Hi8cDrR9pOGeg@mail.gmail.com>
	<1389787304.3913.28.camel@slavad-ubuntu>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=DhJnVqlNqnjVAFSY4lVTJbsa8x0NB1OQdbvRmeDo8eE=;
        b=mREnLVshqSb894rgpJP8KF/c30wKSL02FmHDUf35WWZ9U64T1tUIHyh5M9zhC+ECFt
         tdNmUxW/DF6fbVuRoWW5+n5yO522HoFZKB1TVPUX/VXpUGoFOf8vWuq0rCWXFnn9F4C4
         EMVU0BxPrUDYemp7pJXp4zSoPe9aWweB5efBSMshON2Pz6yyZLhSQXlSjWb7iChJDsa+
         o0GQUofIRPbHCyw1vQXUasuoVmbGje/GqvhccvGeQuwWMMi85qhnVIIe6y339CeaaVQo
         XLcgsGde7yWfptwKLwC3EINVXzN7WQAmatisl/1kky4PiVYLrr/9hVjzREo1WIO3KFP+
         Umrw==
In-Reply-To: <1389787304.3913.28.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,

> NILFS2 has special method nilfs_sb_need_update() [1] and special
> constant NILFS_SB_FREQ [2] that it is used usually for definition
> frequency of superblocks updating. So, as far as I can judge, default
> value of such frequency under high I/O load is 10 seconds (Minimum
> interval of periodical update of superblocks (in seconds)).
>
> [1] http://lxr.free-electrons.com/source/fs/nilfs2/the_nilfs.h#L254
> [2] http://lxr.free-electrons.com/source/fs/nilfs2/the_nilfs.h#L252

Thanks for the in-depth explanation.

> We need to the periodical in-place superblock write only for updating
> a pointer to the most latest log.  And, this will be eliminable if we
> can invent the fast way to determine the latest log.

Maybe it would be enough to detect whether the stored pointer to the
last log is recent and otherwise perform a slow scan?

Thanks, Clemens
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
