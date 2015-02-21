From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 1/1] nilfs2: fix potential memory overrun on inode
Date: Sat, 21 Feb 2015 11:37:03 +0900 (JST)
Message-ID: <20150221.113703.2261465491790805448.konishi.ryusuke@lab.ntt.co.jp>
References: <20150221.092208.1795135375638032743.konishi.ryusuke@lab.ntt.co.jp>
	<20150221.101328.1613471465739082397.konishi.ryusuke@lab.ntt.co.jp>
	<20150220180055.443bbce8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=exj/b9wBgNg+9reVio8Xu+J3yqN7Qj0zKEsyWk2+fYM=;
        b=dmw1kWLUlOB/xSUDSS88xpvyYFQ3i7YJxFMg1yrH03d1A25mSje7W70zKM/qZsxXmj
         5DZkmgxmttAitUYHeRpzIBo2dVLcYbiUMr5Gko6RtcNPbAZXmhj8jofBjA7n97xcF0OC
         hQeoNt15zzpYrzliCgzNQTJxYIWeJhJkZDRxmkRTf89duO+37Yawe6uvUl8i59bd8i5t
         0QiR68OoIwiwirveW/SImHQToVJEh2ueddKXLWJIah4ywItHzDsYm2fQgRwgJuBfs2lQ
         ZwZ1Ac0V/v+fOQpNEKOFMZDSnyfoT4uQab2UxfY/12WO2Ugs/brGifXpCtQDu6BICl7v
         4TAQ==
In-Reply-To: <20150220180055.443bbce8.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Henderson <rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>, Ivan Kokshaysky <ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org>, Matt Turner <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>

On Fri, 20 Feb 2015 18:00:55 -0800, Andrew Morton wrote:
> On Sat, 21 Feb 2015 10:13:28 +0900 (JST) Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> 
>> I've got a warning from 0day kernel testing backend:
>> 
>>     fs/nilfs2/btree.c: In function 'nilfs_btree_root_broken':
>> >> fs/nilfs2/btree.c:394:3: warning: format '%lu' expects argument of type 'long unsigned int', but argument 2 has type 'ino_t' [-Wformat=]
>>        pr_crit("NILFS: bad btree root (inode number=%lu): level = %d, 
>> flags = 0x%x, nchildren = %d\n",
>>        ^
>> 
>> This is output for s390 arch since ino_t doesn't mean "unsigned long"
>> in s390.
> 
> alpha uses uint for ino_t as well.
> 
> It seems a bit pointless - neither arch uses ino_t in ./arch/ code.  I
> suspect both could switch to ulong, which would make the world a
> slightly better place.

I entirely agree.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
