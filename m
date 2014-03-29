From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: attempt to access beyond end of device
Date: Sat, 29 Mar 2014 18:49:29 +0400
Message-ID: <1396104569.2092.10.camel@slavad-CELSIUS-H720>
References: <20140324071357.GY4686@wloczykij>
	 <1395646655.2178.20.camel@slavad-CELSIUS-H720>
	 <20140324204917.GA4686@wloczykij>
	 <1395739090.2197.11.camel@slavad-CELSIUS-H720>
	 <20140327123918.GH30294@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=n+uY4JWQXSZPpL0gdacSBq0H5Nr0MJm6VXpG4hRECIY=;
	b=SPV988PRuDKkTGBTwgoWjXiQrrdann3kllk/azbJev4ac9btFV/yrISmYh94TowMG5Ne4olCnSdXCqT3ysxqb4ud0hlpKlk3dy9WruhzEbrQns+MW03pJqB7tFs7pqQy;
In-Reply-To: <20140327123918.GH30294@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 2014-03-27 at 13:39 +0100, Piotr Szymaniak wrote:

> [ 1109.889697] mmcblk0: mmc0:b368 SMI   7.51 GiB 
> [ 1109.891261]  mmcblk0: p1 p2 p3
> [ 1129.467450] NILFS warning: mounting unchecked fs
> [ 1129.956859] NILFS: recovery complete.
> [ 1129.960064] segctord starting. Construction interval = 300 seconds, CP frequency < 30 seconds
> [ 1129.979344] NILFS warning: mounting fs with errors
> [ 1283.005874] attempt to access beyond end of device
> [ 1283.005882] mmcblk0p3: rw=8192, want=145241775180196072, limit=15120384

> > ~ # nilfs-tune -l /dev/sdf3
> > > nilfs-tune 2.1.6
> > > Filesystem volume name:   (none)
> > > Filesystem UUID:          53760664-f9ed-4c8d-af42-c6ee2f16d956
> > > Filesystem magic number:  0x3434
> > > Filesystem revision #:    2.0
> > > Filesystem features:      (none)
> > > Filesystem state:         invalid or mounted,error
> > > Filesystem OS type:       Linux
> > > Block size:               4096

I suppose that you have corrupted file system. Because it is possible to
see that file system has 4 KB block size but the read request is 8 KB in
size (moreover, this request is out of device). You are using this
NILFS2 volume from 2012 year. So, the reason of the issue can be only
corrupted block on the volume.

I assume that there is significant probability of occurrence the issue
with competition of segments for dirty blocks during segment
construction. I've reproduced this issue very stably when it takes place
simultaneous checking for updates and some intensive activity with
volume (for example, compilation). So, such issue results with
corruption of file system. But you can discover such corruption far away
from place of origin.

Anyway, I'll happy to investigate your issue if you can describe a
reproducing path. I need in stable reproducing of the issue for
investigation and fix. Could you describe it?

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
