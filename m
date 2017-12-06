From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 00/73] XArray version 4
Date: Tue, 5 Dec 2017 18:27:13 -0800
Message-ID: <20171206022713.GN26021@bombadil.infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206014536.GA4094@dastard>
 <20171206015108.GB4094@dastard>
 <MWHPR21MB0845A83B9E89E4A9499AEC2FCB320@MWHPR21MB0845.namprd21.prod.outlook.com>
 <20171206021752.GC4094@dastard>
Mime-Version: 1.0
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+qbgtOQzBu5WMbvcTgHFIQqx+uCxbldxKnNkTy7k/so=; b=J67+vjGiVkTF7r4t9CSZkXIgQ
        wocHAepbXXaCbEBR8LMB6nit5qvWdI13u7XeWWV6HIM8JPT92wg5xMjTZqkrwxdRtyM+8XrM1z/1T
        eElSPVpngeghsVIB2EQ8qYe3AbT+6VjPFlueIeJrDt1vojAcg441BcB1ERBeDBV2DYq16d1brwj1T
        zT4YKLlCks5um1NH4ZhsTnSi0f8oK/TzfSmTcKywEoH4kKboERM1sR9sCXjw07PF3igldE/Zrdi59
        MdSXaVBuciWvP8M0WTvunibBDA/tVzY1Kx0JFykHvYlqo5yc4xGBheqVQBbdMuB4Foo35zDeeSnyQ
    
Content-Disposition: inline
In-Reply-To: <20171206021752.GC4094@dastard>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Dec 06, 2017 at 01:17:52PM +1100, Dave Chinner wrote:
> On Wed, Dec 06, 2017 at 01:53:41AM +0000, Matthew Wilcox wrote:
> > Huh, you've caught a couple of problems that 0day hasn't sent me yet.  Try turning on DAX or TRANSPARENT_HUGEPAGE.  Thanks!
> 
> Dax is turned on, CONFIG_TRANSPARENT_HUGEPAGE is not.
> 
> Looks like nothing is setting CONFIG_RADIX_TREE_MULTIORDER, which is
> what xas_set_order() is hidden under.
> 
> Ah, CONFIG_ZONE_DEVICE turns it on, not CONFIG_DAX/CONFIG_FS_DAX.
> 
> Hmmmm.  That seems wrong if it's used in fs/dax.c...

Yes, it's my mistake for not making xas_set_order available in the
!MULTIORDER case.  I'm working on a fix now.

> What a godawful mess Kconfig has turned into.

I'm not going to argue with that ...
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
