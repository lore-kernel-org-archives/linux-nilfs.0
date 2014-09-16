From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix data loss with mmap()
Date: Tue, 16 Sep 2014 22:57:26 +0900 (JST)
Message-ID: <20140916.225726.1211879952201061873.konishi.ryusuke@lab.ntt.co.jp>
References: <54176705.6080107@gmx.net>
	<20140916.134218.1694651966300542167.konishi.ryusuke@lab.ntt.co.jp>
	<5417F705.8020306@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=IpnR+8rQZKZCz3xgKVQnbvN5GZosdzA+J++36TGgy/c=;
        b=H5R2nrCZmZHbWDD1LeKCJ5+37vKX4yZfcU3FT06q6HyZnX+u6hKyBkAYbIwDJ1/kki
         zf2O/AgWFYi0eDiKB51d/XuPrHEwPYWSIMwNF0sh7+K/E/agi/DHx2zOqk0urzyO9wcp
         NkRzPRoZI6kw8NYdHihx2wmGZLad5pk/AeYcsdYZX3M9BuS6F23SqI5LGTlZDa+Haf+n
         pY8WGo6+45IgkT4UiUA6gH1ijTfM8snX/Q84RHivi01quSlRwOdvt3iSLK+zZynGIKgi
         TZLGRuBD6Gu3Pa4t/4pOr/B2DN7OI6660je6hVLYbfcmeyr+2jBXS2vmXlLqgkNa16Be
         +6+w==
In-Reply-To: <5417F705.8020306-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 16 Sep 2014 10:38:29 +0200, Andreas Rohner wrote:
>> I'd appreciate your help on testing the patch for some old kernels.
>> (And, please declare a "Tested-by" tag in the reply mail, if the test
>> is ok).
> 
> Sure I have everything set up. Which kernels do I have to test? Was
> commit 136e877 backported? I presume at least stable and some of the
> longterm kernels on https://www.kernel.org/...

The commit 136e877 was merged to v3.10 and backported to stable trees
of earlier kernels.  But, most of earlier stable trees are no longer
maintained.  Well maintained trees are the following longterm kernels:

- 3.4.y  (backported commit 136e877)
- 3.10.y
- 3.14.y

I think these three kernels are worty to be tested.

> By the way thanks for your continued effort and time investment in
> reviewing my patches.

Thank you too, for your hard work and patience.

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
