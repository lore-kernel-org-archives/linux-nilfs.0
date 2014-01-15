From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Does nilfs2 do any in-place writes?
Date: Wed, 15 Jan 2014 14:52:19 +0400
Message-ID: <1389783139.3913.23.camel@slavad-ubuntu>
References: <CAFvQSYSzpX_WpUi9KpGj0pZvzhw2mfzzOqcgdj9ripXAjipmtw@mail.gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=u5BzaYcWtCjjOpxcaCm87ynyWwB/M8zyEYK6v6OZ8s0=;
	b=WgpzBIqpT1o8rr0FPhzkcNAfQlKlxe/sC0vogiLotpvvH7vqrO9GbmOxQxlCORwobHRWG9YfpHMxdb2z2I60Ce6TMvj+kGuXXP7/8bR7Z2gfo1p49pnCHyRmZssAObKi;
In-Reply-To: <CAFvQSYSzpX_WpUi9KpGj0pZvzhw2mfzzOqcgdj9ripXAjipmtw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 2014-01-15 at 11:44 +0100, Clemens Eisserer wrote:
> Hi,
> 
> Recently my raspberry pi destroyed a 32GB SD card after only 4 days,
> because that cheap SD card seemed to have issues with wear-leveling.
> The areas where the ext4 journal was stored were no longer read- or writeable.
> 
> I wonder which write-access patterns nilfs2 does exhibit.
> Are there any frequent in-place updates to statically positioned data
> structures (superblock, translation tables, ...) or is the data mostly
> written sequentially?
> 

The main approach of NILFS2 is COW (copy-on-write) policy. It means that
all data and metadata are written in log manner. Only superblocks are
placed in fixed positions and updated there. First superblock is located
in the volume begin, second one in the volume end.

With the best regards,
Vyacheslav Dubeyko.

> Thank you in advance, Clemens
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
