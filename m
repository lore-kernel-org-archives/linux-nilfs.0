From: fwdnilfsml.to.11df-2pMamKoQTv4@public.gmane.org
Subject: Re: Strange "flush" process bahaviour
Date: Fri, 16 Nov 2012 19:02:32 +0400
Message-ID: <50A65588.3000205@li.ru>
References: <50A5737C.2040805@li.ru> <201211160313.AA04185@capsicum.lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201211160313.AA04185-ZdTO5nnmHvkOizVVqyxoihMFgDP4sedm@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> Hmm, the default value of this parameter is zero.
> Have you changed it with the nilfs-tune tool by some chance ?
Yes, I've changed it to 60 sec for rootfs partition, and 180 sec for 
data partition. It worked flawlessly with this setup on root partition 
for last 14 months...

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
