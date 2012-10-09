From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Tue, 9 Oct 2012 21:32:34 +0400
Message-ID: <36CF1E3A-4334-401F-89AE-505B7A5C89EB@dubeyko.com>
References: <20121009105239.GV28032@wloczykij> <1349784514.1921.9.camel@slavad-ubuntu> <20121009135833.GX28032@wloczykij> <20121010.012440.17932600.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=9okSQLI1LnxSkqlnIZcn6ZMEldvDFgMJ1Dkc7nBldIQ=;
	b=b7eaO1R+prVsyfAEhtkTYUn1gGSuh39XZqQMnMerHniXd3ajs66f0YPnAeVbf4R+eMEdDVHHieKgHPtK084ek2DkrHvzuyemLCQYKKruIecXqcebs5s52DG7LK4c/lm1;
In-Reply-To: <20121010.012440.17932600.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Oct 9, 2012, at 8:24 PM, Ryusuke Konishi wrote:

> Hi,
> On Tue, 9 Oct 2012 15:58:33 +0200, Piotr Szymaniak wrote:
>> On Tue, Oct 09, 2012 at 04:08:34PM +0400, Vyacheslav Dubeyko wrote:
>>> First of all, I need some details about your NILFS2 partition for issue analysis.
>>> 
>>> I need in:
>>> 1. Full output of "lscp -a".
>>> 2. Full output of "lssu -a".
>>> 3. Output of dumpseg for segment #0.
>>> 
>>> Could you share these outputs?
>> 
>> Sure!
>> maszyn ~ # lscp -a /dev/sdf3
>> lscp: /dev/sdf3: cannot open NILFS
>> maszyn ~ # lssu -a /dev/sdf3
>> lssu: /dev/sdf3: cannot open NILFS
> 
> lscp and lssu don't work if the target partition is not mounted, so
> these seem to be its direct result.
> 
>> (the card is in a card reader)
>> 
>>> Maybe, you will have some troubles with getting of outputs. So, I need in your segment #0 (first 8 MB) raw output for issue analysis beginning, anyway.
>> 
>> maszyn ~ # dumpseg /dev/sdf3 0 > /tmp/dumpseg-0.out
>> 
>> Attached.
> 
> The segment zero may not include any useful information.
> Please try nilfs-tune command to know which segment should be investigated.
> 
> # nilfs-tune -l /dev/sdf3
> ...
> Last checkpoint #:	  160345
> Last block address:	    131015
> Last sequence #:	      7675
> ..
> 
> In this example, the active super block points to the segment #63:
> 
>  (value of the "Last block address" field) / 2048 = 131015 / 2048 = 63
> 
> Note that you can track the latest segment from the pointed segment.
> "next segnum" field and "sequence number" field in the dumpseg outputs
> tell you information about its successive segments.
> 
> 
> By the way, Raspberry Pi Linux seems to be the kernel for an ARM-based
> machine.  Is there possibility that this is a platform dependent
> problem?
> 

Not so long ago I received e-mail from guy that uses NILFS2 on Android smartphone (this is ARM-based platform, as I can understand). He is completely happy.

Anyway, currently, I suspect that over-clocking is a reason (maybe I am wrong).

By the way, it makes sense to try last version of fsck patch. Of course, it can check superblocks only but this fsck.nilfs2 test can be valuable anyway. Sometimes, fsck can be a valuable tool. :-) Unfortunately, it has very small checking possibility now.

With the best regards,
Vyacheslav Dubeyko.

> 
> Regards,
> Ryusuke Konishi
> 
> 
>> Piotr Szymaniak.
>> -- 
>> Od  czasu  do  czasu  bij swoja zone,  jezeli ty nie wiesz za co ona na
>> pewno bedzie wiedziec.
>>  -- Przyslowie arabskie
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
