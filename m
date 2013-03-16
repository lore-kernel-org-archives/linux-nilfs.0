From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Corrupted nilfs2 volume
Date: Sat, 16 Mar 2013 18:11:19 +0300
Message-ID: <70219EF1-8083-4DD5-BA18-84CD1914DC3E@dubeyko.com>
References: <20130315024019.7DC1BD00@mail.dragonworks.ru> <1363328491.2078.21.camel@slavad-ubuntu> <20130315232157.GC1542@black>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=7KjYEmRlyG/d63kKlZKMfBHPyz4OxYpiaOIQ7Wx9Wz4=;
	b=AkMRObxPPLG56lbRM3f6MafeyP4HP0xzgQzHbMY1QdHoIPMJmM7Tjr28PvM3N6zBsujG5NNQ2R54GwkE8/zl0ICrFltrEyzue1ADsQ7tRihrWdpghFdrSMvlTJX/9/+E;
In-Reply-To: <20130315232157.GC1542@black>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexander Bezrukov <nilfs-issues-tvrqcU/I3+LBxmVkcvZ8vQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Alexander,

On Mar 16, 2013, at 2:21 AM, Alexander Bezrukov wrote:

> 
> Hi Vyacheslav,
> 
>> Had you any snapshots on this volume?
> 
> Unfortunately no. I had had one but have recently converted
> t to an ordinary cp.
> 
>> It needs to investigate the issue more deeply. Could you
>> try to mount this volume under another system? I hope that
>> it gives opportunity to get more details about the issue
>> from system log. So, could you share NILFS2 related messages
>> for such try?
> 
> This is what I've indeed done in the first place.
> 
>>> NILFS: Invalid checkpoint (checkpoint number=5439464)
>>> NILFS: error loading last checkpoint (checkpoint number=5439464)
> 
> In fact, these lines I have copied from the system log of another
> system (with some some debian distro kernel 3.2.0). But this is
> exactly how my original kernel complains too.
> 

Ok. I think that maybe I will prepare special patch with additional debug output for deeper investigation and understanding situation on your volume. But initially I need to have the whole picture of your volume. Namely, I need in debug output of fsck.nilfs2 utility. Moreover, could you share output of "nilfs-tune -l" utility?

>>> To my best knowledge there is no "official" fsck tool for nilfs2
>>> but at times nilfs2 has just been added to the mainline kernel I
>>> read somewhere about some "unofficial" version at some developer
>>> branch.
>> 
>> I send you personally archive with actual state of fsck.nilfs2.
>> I need in debug output of the fsck.nilfs2 for analysis of situation
>> on the volume.
> 
> I am sorry, I didn't receive any archive.
> 

It is strange. Now you can download nilfs-utils archive with last actual version of fsck.nilfs2 from http://dubeyko.com/development/FileSystems/NILFS/nilfs-utils-fsck-v.0.04-under-development.tar.gz. Unfortunately, I haven't enough time for further implementation of fsck during last two months. But I am going to continue implementation. So, fsck can check only superblocks and segment summaries. But debug output of current state of fsck.nilfs2 will be very helpful for getting picture of the volume. Please, compile utilities set with fsck and run "fsck -v debug [device] 2> [output-file]". Then, please, share only with output file because it will have significant size.

Thanks,
Vyacheslav Dubeyko.

>> I hope that we can recover your volume. But, anyway, we need to analyze
>> the issue and try to cure the volume.
> 
> For me the latter is even more important.
> 
> Best regards.
> Alexander Bezrukov
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
