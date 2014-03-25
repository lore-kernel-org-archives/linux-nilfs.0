From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: attempt to access beyond end of device
Date: Tue, 25 Mar 2014 13:18:10 +0400
Message-ID: <1395739090.2197.11.camel@slavad-CELSIUS-H720>
References: <20140324071357.GY4686@wloczykij>
	 <1395646655.2178.20.camel@slavad-CELSIUS-H720>
	 <20140324204917.GA4686@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=PzUFKBQdvyWhNBVdfuSacIipkK6HNylEDnrzeA5u9To=;
	b=cgQtEK7aB7HRD+hcmawf1XX99oHfK58MO85u/WMnEdfbrHQPk0cDlTAlIoB9YvdRokn7cNib+syyOEjnQxSOPd4zGtTLGYW9ws0Q036EdRJTiLJ5QzbIn6LfvijHQ4pu;
In-Reply-To: <20140324204917.GA4686@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 2014-03-24 at 21:49 +0100, Piotr Szymaniak wrote:

> That was some time ago, so I'm unable to answer this question. But
> nilfs-tune shows 4KB blocks:
> 
> ~ # nilfs-tune -l /dev/sdf3
> nilfs-tune 2.1.6
> Filesystem volume name:   (none)
> Filesystem UUID:          53760664-f9ed-4c8d-af42-c6ee2f16d956
> Filesystem magic number:  0x3434
> Filesystem revision #:    2.0
> Filesystem features:      (none)
> Filesystem state:         invalid or mounted,error
> Filesystem OS type:       Linux
> Block size:               4096
> Filesystem created:       Fri Aug  3 08:37:06 2012

I suspect that you used this NILFS2 volume with kernel version that it
was trouble with segments creation. So, you can have volume corruption
because of this bug that it was fixed.

(1) What Linux kernel version do use currently?
(2) How long did you use old kernel versions?
(3) What workloads did you use for this volume?
(4) Had you situations of simultaneous working of several threads with
intensive operations with volume (for example, simultaneous compilation
and checking for updates)?

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
