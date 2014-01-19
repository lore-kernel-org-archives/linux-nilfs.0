From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Does nilfs2 do any in-place writes?
Date: Sun, 19 Jan 2014 14:43:45 +0900 (JST)
Message-ID: <20140119.144345.373615211.konishi.ryusuke@lab.ntt.co.jp>
References: <52DA696D.6010206@gmx.net>
	<04877EE1-F5BF-41CE-AC92-CD9C3ED0B8A4@dubeyko.com>
	<52DB098A.4010300@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52DB098A.4010300-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 19 Jan 2014 00:08:58 +0100, Andreas Rohner wrote:
> On 2014-01-19 00:08, Vyacheslav Dubeyko wrote:
>> I think that it is very desirable to share patches for the review on early
>> stages because it is possible to achieve a valuable results by means of
>> open and continuos discussion. So, you are welcome to share your
>> vision and your patches.
> 
> Good I will prepare my patches.

Before submitting patches, please test them with scripts/checkpatch.pl
in the latest nilfs-utils.git.  This would help to reduce coding style
issues, and we will be able to concentrate on design and
implementation of the patches.

If your patchset affects compatibility of existing code, it would be
helpful if you clarify them in terms of disk format compatibility,
ioctl interface compatibility, library compatibility, and
CUI-compatibility.

I expect that your work makes progress on the GC issue adding improved
algorithm (cost-benefit altogorithm, greedy algorithm, and further) to
cleanerd.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
