From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix data loss with mmap()
Date: Thu, 18 Sep 2014 12:44:16 +0200
Message-ID: <541AB780.2010708@gmx.net>
References: <20140916.225726.1211879952201061873.konishi.ryusuke@lab.ntt.co.jp>	<5419436E.4030501@gmx.net>	<20140917.213439.867924114484975245.konishi.ryusuke@lab.ntt.co.jp> <20140918.162416.1553343892940167544.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140918.162416.1553343892940167544.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-09-18 09:24, Ryusuke Konishi wrote:
> On Wed, 17 Sep 2014 21:34:39 +0900 (JST), Ryusuke Konishi wrote:
>> On Wed, 17 Sep 2014 10:16:46 +0200, Andreas Rohner wrote:
>>> On 2014-09-16 15:57, Ryusuke Konishi wrote:
>>>> On Tue, 16 Sep 2014 10:38:29 +0200, Andreas Rohner wrote:
>>>>>> I'd appreciate your help on testing the patch for some old kernels.
>>>>>> (And, please declare a "Tested-by" tag in the reply mail, if the test
>>>>>> is ok).
>>>>>
>>>>> Sure I have everything set up. Which kernels do I have to test? Was
>>>>> commit 136e877 backported? I presume at least stable and some of the
>>>>> longterm kernels on https://www.kernel.org/...
>>>>
>>>> The commit 136e877 was merged to v3.10 and backported to stable trees
>>>> of earlier kernels.  But, most of earlier stable trees are no longer
>>>> maintained.  Well maintained trees are the following longterm kernels:
>>>>
>>>> - 3.4.y  (backported commit 136e877)
>>>> - 3.10.y
>>>> - 3.14.y
>>>>
>>>> I think these three kernels are worty to be tested.
>>>
>>> I tested it on all stable kernels including 3.4.x, 3.10.x, 3.14.x. The
>>> bug is present in all of them and the patch fixes it. The patch also
>>> applies cleanly on all kernels. I sent it again yesterday, and added the
>>> Tested-by: tag.
> 
> One thing I have a question.
> 
> Is the original issue that commit 136e877 fixed still OK ?  If you
> haven't tested it, I apprecicate if you examine the test for the prior
> issue.

Yes the original issue is still fixed. I was able to reproduce it by
reverting  nilfs_set_page_dirty() to the state prior to commit 136e877.
Then I used the new version of nilfs_set_page_dirty() including my patch
and I couldn't reproduce the issue anymore. So it seems to still be fixed.

Furthermore the original issue was caused by the use of
__set_page_dirty_buffers(), which marked unmapped buffers as dirty. My
patch does not change the fix for that.

br,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
