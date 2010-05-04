From: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Subject: Re: [CFD] disk format fixing
Date: Tue, 4 May 2010 14:06:23 +0200
Message-ID: <20100504120623.GB1132@heethoofdje.13thmonkey.org>
References: <87aash3rrm.wl%jir@sekiba.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87aash3rrm.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Tue, May 04, 2010 at 12:54:21AM +0900, Jiro SEKIBA wrote:
> It still remains controversial argument, like directory indexing or atime
> support, xattr support and so on.  However, I'd like to make the target
> clear that when the above message can be taken away.

I'd opt for not getting into directory indexing; that can easily be
implemented at run-time as i showed to with code in the NetBSD implementation.
The speed increase is really fenominal (can be 500+ times) and doesn't need
much memory space and doesn't involve a disc layout change.

With regards,
Reinoud


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
