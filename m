From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: add tracepoints for analyzing reading and
 writing metadata files
Date: Mon, 05 Oct 2015 20:25:13 +0900 (JST)
Message-ID: <20151005.202513.149043665808498169.konishi.ryusuke@lab.ntt.co.jp>
References: <1443888162-14884-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
	<20151004.223343.974065670664209746.konishi.ryusuke@lab.ntt.co.jp>
	<CAE1WaK+TTyKZNA2xk7qZsZdJBEUSvDKHmCWnhr_gJy6yR4hnSA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=Z/AViz6N5g6sks2Pwk2AfL/XMZnaExSn5r3KDiLXNBo=;
        b=K4zTxMWqe37OWour+9EV2NVSNW7nJJTnNfRTRQ1wEE/7gSdUEnTOkB5+uiIo+ECm5V
         pGzs+GNCFPxVLm+K7woifCXBWs6IMJF74u+kRcM7cgySujTsHfRDulDQudrVDH0Go1l7
         c+y9kDsBzoOBxfAkci+KH6ZDmIGa1np+Dse7dDnw9IoZhINrLFbofR7nif34dqRYNLYt
         XQNohGASQNFUsCJPKWxt/Xdn5GiLL+Ov4RiZap0g0t6n2U4nMA8LPAQ/B85SDOLQPLfx
         PvyxHSXRSl43WS+bw0v/LTxJragZy/eeaBuk6dea+WIi764eg5Yendsq/0MLocM+DRFo
         d9Ig==
In-Reply-To: <CAE1WaK+TTyKZNA2xk7qZsZdJBEUSvDKHmCWnhr_gJy6yR4hnSA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Mitake Hitoshi <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, TK Kato <TK.Kato-Sjgp3cTcYWE@public.gmane.org>

On Mon, 5 Oct 2015 19:21:43 +0900, Mitake Hitoshi wrote:
> On Sun, Oct 4, 2015 at 10:33 PM, Ryusuke Konishi
> <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
>> On Sun,  4 Oct 2015 01:02:42 +0900, Mitake Hitoshi wrote:
>>> This patch adds tracepoints for analyzing requests of reading and
>>> writing metadata files. The tracepoints cover every in-place mdt files
>>> (cpfile, sufile, and datfile).
>>>
>>> Example of tracing mdt_insert_new_block():
>>>               cp-14635 [000] ...1 30598.199309: nilfs2_mdt_insert_new_block: inode = ffff88022a8d0178 ino = 3 block = 155
>>>               cp-14635 [000] ...1 30598.199520: nilfs2_mdt_insert_new_block: inode = ffff88022a8d0178 ino = 3 block = 5
>>>               cp-14635 [000] ...1 30598.200828: nilfs2_mdt_insert_new_block: inode = ffff88022a8d0178 ino = 3 block = 253
>>>
>>> Cc: TK Kato <TK.Kato-Sjgp3cTcYWE@public.gmane.org>
>>> Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
>>
>> Applied to the tracepoints branch.  Thanks.
> 
> Thanks, could you send the patches in the tracepoints branch to upstream?

Sure, I will.

Regards,
Ryusuke Konishi

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
