From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Time issues with checkpoints resolved?
Date: Wed, 30 Jan 2013 09:50:07 +0400
Message-ID: <1359525007.2085.10.camel@slavad-ubuntu>
References: <20130129221021.GL10316@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=bNnMPwx/PBbKZKUI/lV8PAkukOwRKDgMX6Firrlfh/Q=;
	b=tkkRPfEXEvxl1o0tXl0KlTZhdVi12JHuMJhhGblyV3pOFicsvYjoditWuMrH/9YqDjciIHH/lDzbk8rk8H+8LsxzS1bRdyxU3j02ZaJ6Qe2dSayVG+dfyxxzAjyeq/aG;
In-Reply-To: <20130129221021.GL10316@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Piotr,

On Tue, 2013-01-29 at 23:10 +0100, Piotr Szymaniak wrote:
> Hi,
> 
> Sorry, but I can't find an answer and noticed some checkpoints in the
> past in the middle of other checkpoints (there was a thread, I think,
> about similar issue with timezone change).
> 
> Right now I have (Raspberry Pi doesn't have RTC):
> ~ lscp
> (...)
> 7870  2013-01-27 15:12:30   cp    -           22      42174
> 7871  2013-01-27 15:34:23   cp    -           19      42174
> 7872  2013-01-27 15:42:29   cp    -           22      42174
> 7873  1970-01-01 01:05:05   cp    -           93      42176
> 7874  1970-01-01 01:10:05   cp    -           22      42174
> 7875  1970-01-01 01:36:36   cp    -           18      42174
> (...)
> 8031  1970-01-03 07:08:19   cp    -           57      42183
> 8032  1970-01-03 07:13:20   cp    -           36      42182
> 8033  2013-01-29 00:01:57   cp    -           30      42182
> 8034  2013-01-29 00:19:34   cp    -          599      42313
> 
> I just wonder if cleaner is now smart enough to clean this mess.
> 

Unfortunately, it is not. Such fix doesn't made yet. I think that it
needs to modify nilfs-clean utility. But, currently, I am deeply inside
fixing of issues with flush kernel thread and bad btree node. These
issues are slightly complex. I tried several solutions but I haven't the
proper yet. Maybe, a final solution will be a combination of several
fixes that I tried.

But fixing of issue with timezone change in my TODO list.

With the best regards,
Vyacheslav Dubeyko.

> 
> Piotr Szymaniak.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
