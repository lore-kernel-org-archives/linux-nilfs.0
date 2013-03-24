From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2] nilfs-utils: mkfs.nilfs2 should check presence of NILFS2 volume on device
Date: Sun, 24 Mar 2013 17:09:16 +0300
Message-ID: <2A3BDC36-1701-4FE0-B9AA-6C5A277356E8@dubeyko.com>
References: <1364126337.9937.2.camel@slavad-ubuntu-12.04> <20130324.215540.27791752.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=2MeV+Y1dfCs+m9DW4PbYej1sgzytvOJXSLAGj/Riqn0=;
	b=sTy67iWV68nNfK3ik9Ekai/9XcluGsThmL9f0Yt9wBsMvmiPpLV852XgV7gPXMnuaz5yDVxNDxQsf27pRV2k8lLZaI5OtFtT+2w224goDqe777jHn4M4xftrtQOXpZD2;
In-Reply-To: <20130324.215540.27791752.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hendrik-j5CO6tLloWodnm+yROfE0A@public.gmane.org

Hi Ryusuke,

On Mar 24, 2013, at 3:55 PM, Ryusuke Konishi wrote:

[snip]

> 
> I noticed that the prompt "Continue? [y/N]" doesn't work as expected
> for an enter key input.
> 

Yes, it needs to be fixed. I'll do it. 

> Moreover, this patch looks to break alphabetical order of options;
> "-f" option should be inserted after "-c" option.
> 

Ok. I'll fix it.

Thanks,
Vyacheslav Dubeyko.

> Regards,
> Ryusuke Konishi
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
