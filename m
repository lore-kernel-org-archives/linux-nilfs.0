From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: Does nilfs2 do any in-place writes?
Date: Sun, 19 Jan 2014 15:11:02 +0100
Message-ID: <52DBDCF6.3090509@gmx.net>
References: <52DA696D.6010206@gmx.net>	<04877EE1-F5BF-41CE-AC92-CD9C3ED0B8A4@dubeyko.com>	<52DB098A.4010300@gmx.net> <20140119.144345.373615211.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140119.144345.373615211.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-01-19 06:43, Ryusuke Konishi wrote:
> On Sun, 19 Jan 2014 00:08:58 +0100, Andreas Rohner wrote:
>> On 2014-01-19 00:08, Vyacheslav Dubeyko wrote:
>>> I think that it is very desirable to share patches for the review on early
>>> stages because it is possible to achieve a valuable results by means of
>>> open and continuos discussion. So, you are welcome to share your
>>> vision and your patches.
>>
>> Good I will prepare my patches.
> 
> Before submitting patches, please test them with scripts/checkpatch.pl
> in the latest nilfs-utils.git.  This would help to reduce coding style
> issues, and we will be able to concentrate on design and
> implementation of the patches.

I used scripts/checkpatch.pl and I hope everything is correct now.

> If your patchset affects compatibility of existing code, it would be
> helpful if you clarify them in terms of disk format compatibility,
> ioctl interface compatibility, library compatibility, and
> CUI-compatibility.

Yes there are some compatibility issues with the implementation of a
counter for segment usage tracking.

> I expect that your work makes progress on the GC issue adding improved
> algorithm (cost-benefit altogorithm, greedy algorithm, and further) to
> cleanerd.

Yes that's right. Although the patch set I submitted today has nothing
to do with cost-benefit and greedy. I decided to first try and submit a
smaller contribution with no compatibility issues.

Best regards,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
