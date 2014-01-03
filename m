From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix segctor bug that causes file system
 corruption
Date: Fri, 03 Jan 2014 11:05:42 +0900 (JST)
Message-ID: <20140103.110542.55849276.konishi.ryusuke@lab.ntt.co.jp>
References: <52C5961F.8000608@gmx.net>
	<20140103.021703.220046134.konishi.ryusuke@lab.ntt.co.jp>
	<52C5EC14.2030300@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52C5EC14.2030300-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 02 Jan 2014 23:45:40 +0100, Andreas Rohner wrote:
> Hi Ryusuke and Vyacheslav,
> 
> On 2014-01-02 18:17, Ryusuke Konishi wrote:
>> I am thinking of sending this to upstream.  But, before that, please
>> test the patch enough in the same situation to confirm that it
>> actually fixes the problem and it doesn't cause other issues.
> 
> I have tested it before, but to be on the safe side, I have rerun my
> benchmark (it runs for several hours), and as far as I can tell the
> patch does fix the problem and it doesn't cause any other issues.

Thank you.

I'll send it to upstream with a few additional tags (your Tested-by
tag and a cc:stable tag) after reviewing again.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
