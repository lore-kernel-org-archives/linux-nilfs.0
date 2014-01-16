From: "Mark Trumpold" <markt-qk0wvQ0ghJwAvxtiuMwx3w@public.gmane.org>
Subject: Re:  Does nilfs2 do any in-place writes?
Date: Thu, 16 Jan 2014 19:40:24 +0000
Message-ID: <W7321454272501389901224@atl4webmail12>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> -----Original Message-----
> From: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-nilfs-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Clemens Eisserer
> Sent: Thursday, January 16, 2014 10:42 AM
> To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PossibleSpam] Re: Does nilfs2 do any in-place writes?
>
> Hi Mark,
>
> > I am wondering what the impact of in-place writes of the
> > superblock has on SSDs in terms of wear?
>
> Typically SSDs have far more advanved static wear leveling algorithms
> which keep the erease count for each erease block as well as a
> sophisticated mapping table. Otherwise e.g. journaling file systems
> would probably kill it quickly.
>
> Regards, Clemens
> --

Hi Clemens,

Thank you for the info.  That was my prior understanding; however
I thought it curious that the SSD failure sited nilfs trying to access
the superblock which had failed at the media level.

It was a fairly high end SSD with TRIM, etc (Corsair Force 240GB).
Working with the vendor to analyze further..

Thanks again,
Mark T. 



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
