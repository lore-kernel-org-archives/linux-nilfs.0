From: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [static superblock discussion] Does nilfs2 do any in-place writes?
Date: Thu, 30 Jan 2014 11:09:51 +0100
Message-ID: <CAFvQSYQ84_BsqVC_ZM77P92jkP+1dh7NexvZWg4mFE7B3wSK0A@mail.gmail.com>
References: <1389787304.3913.28.camel@slavad-ubuntu>
	<20140116.002353.94325733.konishi.ryusuke@lab.ntt.co.jp>
	<1389866912.2565.44.camel@slavad-ubuntu>
	<20140118.090008.194171715.konishi.ryusuke@lab.ntt.co.jp>
	<1390901114.2942.11.camel@slavad-ubuntu-12.04>
	<CAFvQSYSu5CGxs+K6bZUCtq17PrS_paX3bXBuLBRTba_XWYGgAg@mail.gmail.com>
	<71B2806D-7CF2-4992-A588-EB73EADFFF9F@dubeyko.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=YVIUtuo12Ek96TsZXXhURSkWGiVj9LQRIxzh8uaoZ3E=;
        b=QJzpY4ER7Uz4+WzeNvL97Zb8MREWygOSVMPSvlDroqjbSMWHwLyahgL/D8zbL4QG0p
         tA+L+AljnbAxqsrFHWOFSGTV/AUXea8T67ZTYT2ou/62qBP8rfdWn/1M4zvl6b1FTxF4
         SPRpvgjE8yrAA94XJXBovvk9gfj4btE/rjDGpGotJ2snJirjdXxIR48Id8WtVgiM8zHG
         XLrJxKIuVyAHkBxQJaAt2DyDGSFynO8rKak16hsqW4q7uBbvAHi9YVtlhSp7Z19KaNIz
         6NSS0xP8OsJvsLy+B85XHr7FI2QCxYS7RV7cW2E8Z7d08GnHLf7+3Ahboc4Z6pC09KUE
         CUKw==
In-Reply-To: <71B2806D-7CF2-4992-A588-EB73EADFFF9F-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,

> So, as a result, when you are talking about logical block placement
> then it doesn't mean that you are talking about writes in few physical
> erase blocks. Because only mapping table of FTL knows what physical
> erase blocks are changed really.
ntly).

For powerful FTL/controllers it almost doesn't make a difference
whether you write in-place or in the "almost random" style you
propose.
Those FTLs usually have a fully associative fine-grained
physical-to-logical mapping, so they also can distribute the wear
evenly across the entire NAND.

However there are also FTLs (SD cards, managed NAND, ...) arround
which do only mapping on erase-block level, with limited associativity
- often lacking a random write unit.
So each logical block is mapped to one of n possible physical erase
blocks (for SD cards 4MB erase blocks are quite common) and for each
single write a full erase block has to be erased. And as there are
only n physcial blocks which can be mapped to this logical block, the
card pretty soon starts to develop bad sectors (even worse, these days
often cheap TLC flash is used limited to < 500 erase cycles).

The linaro guys did a survey on this some time ago:
https://wiki.linaro.org/WorkingGroups/KernelArchived/Projects/FlashCardSurvey
Very interesting is the paragraph about "Access modes", there are
still a lot of controllers which don't feature a random write unit.

> We know about clean (or unclean) umount from the superblock.
> So, you should update superblock for keeping such knowledge.
> Otherwise, you will need to perform linear scan always.
> I don't quite follow your thought. If we will not update superblock then
> how we can save any changes in superblock?

Only update the superblock at mount/unmount time, and do a linear scan
in the case of an unclean shutdown.

Thanks, Clemens
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
