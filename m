From: Heinz Diehl <htd+ml-iEI8Y0CNJBYdnm+yROfE0A@public.gmane.org>
Subject: Re: NILFS2: double uuid
Date: Mon, 8 Jun 2015 12:12:12 +0200
Message-ID: <20150608101212.GB16569@fritha.org>
References: <20150608064314.GA3172@fritha.org>
 <55754FDA.10406@lab.ntt.co.jp>
 <20150608094559.GB15702@fritha.org>
 <20150608100835.GA16569@fritha.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150608100835.GA16569-iEI8Y0CNJBYdnm+yROfE0A@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 08.06.2015, Heinz Diehl wrote: 

> Now, the newly formatted drive is registered in fstab to be
> automatically mounted on boot:
> 
> UUID=ff17dda9-fcae-42e7-a438-9087de58902e	/USBDRIVE	nilfs2	defaults	0	0

Sorry for the noise, but it's quite difficult to sum up all these
uuids when cop&paste doesn't work: the above uuid is wrong, but it's a
simple copy error by me. So just assume it is correct. Sorry again!

The point is that the doube uuid occurs after booting, when trying to
mount from fstab.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
