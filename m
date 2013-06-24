From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: cleaner optimization and online defragmentation: status update
Date: Mon, 24 Jun 2013 17:42:32 +0400
Message-ID: <1372081352.2279.54.camel@slavad-ubuntu>
References: <51C0A731.9060509@student.tuwien.ac.at>
	 <1371626223.2221.25.camel@slavad-ubuntu>
	 <51C177A4.3030204@student.tuwien.ac.at>
	 <2F76977A-589B-47EB-8818-382477099600@dubeyko.com>
	 <CAFvQSYTZfiNQv4==v+m5W+SMCfrxm6WmV8gwKC_+yaW1MBfdOQ@mail.gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=3oWfOYQ3FyhBLmzfpcM237DDXWBsjTx9+Ut0G67FVKA=;
	b=hS1832T54yXQMgfUNOrkf4+oBAnnvD5UXxLL2R8FUXjMFiM2SdqEFhpAKeGCu7zcpZqRxoxSY7I8E1NOfQgjqeQdFz+8LtCAsPe33oPTc4HrZRS5nArh3uAl+jpcj2L8;
In-Reply-To: <CAFvQSYTZfiNQv4==v+m5W+SMCfrxm6WmV8gwKC_+yaW1MBfdOQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 2013-06-22 at 20:37 +0200, Clemens Eisserer wrote:

[snip]
> 
> Btrfs actually offers both, manual defragmentation as well as an
> autodefrag mount option - which is useful even for SSDs when the
> average continous segment size becomes as low as 4kb.
> While autodefrag would be great for nilfs2, a manual tool at least
> wouldn't hurt ;)
> 

Yes, manual tool can be useful also. But suggested implementation is
improper, from my viewpoint. And, first of all, we need to have internal
file system defragmenting technique. I have such vision. :)

With the best regards,
Vyacheslav Dubeyko.

> Regards
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
