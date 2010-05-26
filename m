From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: TRIM Support?
Date: Wed, 26 May 2010 10:51:46 +0900 (JST)
Message-ID: <20100526.105146.144288938.ryusuke@osrg.net>
References: <4BFC1412.6000908@bobich.net>
	<87ljb7bftn.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87ljb7bftn.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org
Cc: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 26 May 2010 10:40:52 +0900, Jiro SEKIBA wrote:
> hi
> 
> At Tue, 25 May 2010 19:16:50 +0100,
> Gordan Bobic wrote:
> > 
> > Hi,
> > 
> > I notice that the pitch for NILFS is that it is particularly suitable 
> > for flash based media. Does it have any sort of support for TRIM 
> > command? If not, is there at least an equivalent of dumpfs that could be 
> > used to get the list of free blocks that could be passed to hdparm to 
> > issue TRIM commands to the SSD?
> 
> You may want to specify discard mount option for the purpose.
> see Documentation/filesystems/nilfs2.txt

FYI, the trim support ("-o discard") was merged at linux-2.6.34.

Cheers,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
