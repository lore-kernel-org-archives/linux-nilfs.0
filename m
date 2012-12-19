From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Contributing to NILFS
Date: Wed, 19 Dec 2012 11:13:56 +0400
Message-ID: <1355901236.2528.48.camel@slavad-ubuntu>
References: <1355169902.803.19.camel@terok>
	 <1355208388.2627.16.camel@slavad-ubuntu> <1355234065.803.61.camel@terok>
	 <1355296112.2042.35.camel@slavad-ubuntu> <1355679932.761.57.camel@terok>
	 <1355725809.2502.29.camel@slavad-ubuntu> <1355739816.738.35.camel@terok>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=DZ6WzzrxChpWbt9RCEmaWv1M0XahOjeUUlJK+blioBg=;
	b=op1JnWAUEpNN8JPwwzJ7BpGDYaUMTNgyWKPPbfI/ZLzWVh64T84Zr6f7lZeSNqAF+LRHAdwaFKpHAxFE7UGxWKM69Fs0McHp1U2U5uD7fbrJmcUc0ujReAwScDN0lU+d;
In-Reply-To: <1355739816.738.35.camel@terok>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <e0502196-oe7qfRrRQffzPE21tAIdciO7C/xPubJB@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 2012-12-17 at 11:23 +0100, Andreas Rohner wrote:
> Hi,
> 
> > I misunderstand slightly about what implementation you are talking.
> > Could you point out NILFS2 source code that implement this technique? As
> > I understand, if we have implemented data reordering before flush and
> > during the cleaning then it means that we have implemented online
> > defragmenting. But, if so, why this task is in TODO list?
> 
> I guess I just assumed it. But I would connect these issues more with
> the first item on the TODO-List "Smarter and more efficient Garbage
> Collector".
> 

As you mentioned earlier, yes, garbage collection and defragmenting are
tightly related technique, from my point of view. So, GC will be more
smarter and more efficient in the case of defragmenting activity
addition in the garbage collection. Moreover, I think that more
promising technique is a some defragmenting activity during writing in a
new segment. I mean that when we add or modify some blocks of file then
it is possible to write in a new segment additional file's fragments
from old ("dirty") segments. So, we can achieve garbage collection and
defragmenting in the background of write operation. But, as you can see,
such technique can be implemented only on the kernel side. 


> > > Instead I imagined a tool like xfs_fsr for XFS. So the user can decide
> > > when to defragment the file system, by running it manually or with a
> > > cron job.
> > 
> > If you are talking about user-space tool then it means that you are
> > talking about offline defragmenter. I think that offline defragmenter is
> > not so interesting for users. The most important objections are:
> 
> I am sorry about the misunderstanding. I thought the term "online" just
> means that the file system is mounted, while the defragmentation tool is
> running. So offline defragmentation would be if you had to unmount the
> file system for defragmentation. EXT4 [1] and XFS both do "online"
> defragmentation with a user-space tool. I assumed, that the item on the
> TODO-List means something similar. Such a tool could be useful to reduce
> aging effects. It should be very conservative and probably not run every
> day, but instead once a month.
> 
> [1] http://lwn.net/Articles/317787/
> 

Yes, it is possible to implement defragmenting in the user-space
approach. But I think that the current "trend" and end-users
expectations is to integrate such technique (fsck, defragmenting, and so
on) in the internal filesystem technique. So, kernel side implementation
is more promising way, from my point of view. Moreover, kernel side
implementation can provide more infrastructure opportunities and save
significant time for implementation efforts in the case of online
defragmenting task.

And, again, I think that online defragmenting should be useful for HDD
and SSD cases. :-)

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
