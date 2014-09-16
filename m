From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix data loss with mmap()
Date: Tue, 16 Sep 2014 13:42:18 +0900 (JST)
Message-ID: <20140916.134218.1694651966300542167.konishi.ryusuke@lab.ntt.co.jp>
References: <1410810450-2637-1-git-send-email-andreas.rohner@gmx.net>
	<20140916.070130.858349725408024032.konishi.ryusuke@lab.ntt.co.jp>
	<54176705.6080107@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=WBUum5os6uHW/ToBMBZBZnnRQdELr58gctYcBiRYan0=;
        b=P29tjaOpphjCfJgWmCBCP2IjAnLWTNs5auftPvc/mybZTdxlRuCrfAGDZpWDdDy9JM
         6UtFL2o4AzMVhhDXyyfKnFzkdwK4zpXplIlpzBZsQQ2lPXcKFLkehp5uldAy2uTclWw2
         i7B8DsySUW9+KJQhbAU+P2GZwoAg1d/MloIHdyD2HnOpPd06T6JKaPkaqVk27Vi6Y+xy
         JIHdVrJV2MLwZ0/s3tcZJunmQZYCjU0rdvUq+PkzOci8aPyowpARlypLhCvCS0G+v62G
         wqg2MBOX+Hu7ScKFdFQ1Yv8ELvYbDdvkFqV8i3ggYzfMdhQklsh4tm2yRox6sJq8bJUu
         OBHA==
In-Reply-To: <54176705.6080107-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 16 Sep 2014 00:24:05 +0200, Andreas Rohner wrote:
> On 2014-09-16 00:01, Ryusuke Konishi wrote:
>> Hi Andreas,
>> On Mon, 15 Sep 2014 21:47:30 +0200, Andreas Rohner wrote:
>>> This bug leads to reproducible silent data loss, despite the use of
>>> msync(), sync() and a clean unmount of the file system. It is easily
>>> reproducible with the following script:
> <snip>
>> Thank you for reporting this issue.
> 
> I just stumbled upon the weird behaviour of mmap() while testing the
> nilfs_sync_fs() patch.
> 
>> I'd like to look into this patch, it looks to point out an important
>> regression, but it may take some time since I am quite busy this week..
> 
> Of course. I understand.

The patch looks correct.  It is my mistake that the commit 136e877
leaked consideration for the case where the page doesn't have buffer
heads.  This fix should be backported to stable kernels. (I'll add a
"Cc: stable" tag when sending this to Andrew.)

Did you confirm that the patch works as expected ?

I'd appreciate your help on testing the patch for some old kernels.
(And, please declare a "Tested-by" tag in the reply mail, if the test
is ok).

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
