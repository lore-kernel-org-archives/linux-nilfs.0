From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Fri, 16 Nov 2012 12:13:45 +0900
Message-ID: <201211160313.AA04185@capsicum.lab.ntt.co.jp>
References: <50A5737C.2040805@li.ru>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50A5737C.2040805-3TRaYzfGuuI@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fwdnilfsml.to.11df-2pMamKoQTv4@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>Still trying to reproduce this issue.
>So far, I found a workaround, that dramatically reduce flush process 
>activity: Using nilfs-tune utility, set "commit interval of segment" 
>parameter to default zero value.

Hmm, the default value of this parameter is zero.
Have you changed it with the nilfs-tune tool by some chance ?

Regards,
Ryusuke Konishi

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
