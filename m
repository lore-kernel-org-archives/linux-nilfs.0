From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Does nilfs2 do any in-place writes?
Date: Wed, 15 Jan 2014 16:01:44 +0400
Message-ID: <1389787304.3913.28.camel@slavad-ubuntu>
References: <CAFvQSYSzpX_WpUi9KpGj0pZvzhw2mfzzOqcgdj9ripXAjipmtw@mail.gmail.com>
	 <1389783139.3913.23.camel@slavad-ubuntu>
	 <CAFvQSYTG6HBVc9iodYyvCejwf889jiwOPsVb1Hi8cDrR9pOGeg@mail.gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=yP+ataptiM3rLxH2TfT3YeC0QfoCjeaPAPDqP9gQbFg=;
	b=mWJmVQaQqNCvEP9ldERX2VS3IXRl7W9knttjYbwrFfJrQyYNOmdNJZ31jWpyPEXMa2l98AwsLGtko80Q/ZVGs/NIGTbjD8uqSkohyFdFebCgqQhMoJqDHASbNRhFPvQZ;
In-Reply-To: <CAFvQSYTG6HBVc9iodYyvCejwf889jiwOPsVb1Hi8cDrR9pOGeg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Clemens,

On Wed, 2014-01-15 at 12:44 +0100, Clemens Eisserer wrote:
> Hi Vyacheslav,
> 
> > The main approach of NILFS2 is COW (copy-on-write) policy. It means that
> > all data and metadata are written in log manner. Only superblocks are
> > placed in fixed positions and updated there. First superblock is located
> > in the volume begin, second one in the volume end.
> 
> Can you give me an estime how often the superblock is updated / written to?
> 

NILFS2 has special method nilfs_sb_need_update() [1] and special
constant NILFS_SB_FREQ [2] that it is used usually for definition
frequency of superblocks updating. So, as far as I can judge, default
value of such frequency under high I/O load is 10 seconds (Minimum
interval of periodical update of superblocks (in seconds)).

With the best regards,
Vyacheslav Dubeyko.

[1] http://lxr.free-electrons.com/source/fs/nilfs2/the_nilfs.h#L254
[2] http://lxr.free-electrons.com/source/fs/nilfs2/the_nilfs.h#L252


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
