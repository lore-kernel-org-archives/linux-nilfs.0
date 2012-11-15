From: fwdnilfsml.to.11df-2pMamKoQTv4@public.gmane.org
Subject: Re: Strange "flush" process bahaviour
Date: Fri, 16 Nov 2012 02:58:04 +0400
Message-ID: <50A5737C.2040805@li.ru>
References: <50A159BC.9060600@li.ru> <1352787218.2042.9.camel@slavad-ubuntu>  <50A24564.7000704@li.ru> <1352814101.2443.9.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1352814101.2443.9.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Still trying to reproduce this issue.
So far, I found a workaround, that dramatically reduce flush process 
activity: Using nilfs-tune utility, set "commit interval of segment" 
parameter to default zero value.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
