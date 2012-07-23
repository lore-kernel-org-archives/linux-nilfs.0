From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: read error on superblock
Date: Mon, 23 Jul 2012 13:17:28 +0400
Message-ID: <1343035048.1974.6.camel@slavad-ubuntu-11>
References: <19753282.RhzHOQAfKG@coil>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:References:In-Reply-To:Cc:To:From:Subject; bh=i1lQeP4PIWtH2OPpgXMCsvOzbjnY7WLjlQ1xlHX3Auw=;
	b=h85ESkDg9mt0FoYxpK/dkRdzRbHdRhP5yyo+lNEcdFTRZ52GcnG+66ZG6xGyNReR2eFM5dmtCkBXNAI1dm9L5FVfw/Jdnv9lmbpNlmNbImSs0pTaK3Bz5wpusLHq/iKS;
In-Reply-To: <19753282.RhzHOQAfKG@coil>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Mon, 2012-07-23 at 10:45 +0200, dexen deVries wrote:
> Hi list,
> 
> 
> a harddrive got some bad sectors and now one NILFS filesystem can't be mounted;
> 
> mount: /dev/sda3: can't read superblock
> 
> I can (try to) copy this filesystem to another drive; how do I proceed form 
> that point? Does it make any sense to substitute another superblock for this 
> one? (either to use a spare superblock, if such exists, or put a new 
> superblock on the damaged sector(s)).
> 
> 
> Regards,

It exits second superblock at the end of NILFS volume. But it can be not
in fully synchronous state with primary ones (as I guess).
Theoretically, it is possible to copy secondary superblock on the place
of primary. But I am afraid that the NILFS volume can be in inconsistent
state anyway.

Do you sure that this volume doesn't contain another damaged sectors?

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
