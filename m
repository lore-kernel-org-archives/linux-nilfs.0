From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Unrecovered read error issue
Date: Sun, 20 Dec 2015 13:55:30 -0800
Message-ID: <1450648530.2807.20.camel@ubuntu-slavad-14.04>
References: <1450488372.2652.25.camel@slavad-ubuntu-14.04>
	 <20151219071703.GP3706@home.paul.comp>
	 <1450562290.2693.9.camel@ubuntu-slavad-14.04>
	 <CAFvQSYTHYypic+bjUOxK=F81XgA1zOvviKkAKQuJ2fD==tn02w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=fVAhLJQlWf3WDdvNB3RozNhoFtmOcR+DFWDQt8RZrws=;
        b=bXRMZFL3LSapyui2bhtqSLg8DT01aUwb0/13GdpUq2JfZe9LyNw0RsZl53ULlutcnL
         3GVo7DdesI5bU4nWpiHj/ZnY/xyfVVgOMI+uXS53JtE0FYsH1JGTqo+sN67IYObQseOr
         zn0k+kDLw0k+EwXBndwvIG8L8AVCaqcM92uB9+f/CY+7/fAOMwfbrN7tvTXB5gw8KAXW
         HDEEO0PoU4mRxu3wutzo63hlAE36AfP/nzyRy2ZTy0aHK6Qc1jleOa8ZEG6WKwK9NaZc
         eh/3clFabHZ6Dyq2U2nhpu++fbIZyctCSEaHgB2XJcc1xL0+I2pk14i3NDpNt8OigQTO
         JqYA==
In-Reply-To: <CAFvQSYTHYypic+bjUOxK=F81XgA1zOvviKkAKQuJ2fD==tn02w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Clemens,

On Sun, 2015-12-20 at 19:34 +0100, Clemens Eisserer wrote:
> Hi Vyacheslav,
> 
> 
> > But I suppose that eMMC or SSD will do re-assignment of bad logical
> > sector into valid physical page on write operation. And I am not sure
> > that bad sector will be re-assigned on write operation for HDD case.
> 
> Modern (SMART-capable) HDDs behave exactly the same - they have spare
> sectors and remap bad sectors when writing them. I "fixed" a laptop
> HDD once, which had a head-crash at the place where ext4's journal was
> located - a simple overwrite with dd fixed the drive.
> 

Yes, such remapping technology should exists for HDD too. But HDD
opportunity for remapping of bad sectors is more limited because you
cannot reserve significant amount of spare sectors. Available free space
is really important feature. Maybe it is possible to compare a size of
SSD's overprovisioning and HDD's reserved spare sectors space. But SSD's
FTL is able to use any NAND erase block for remapping. And I suppose
that HDD's reserved spare sectors space is simply special contiguous
area of sectors. So, I think that probability to exhaust HDD's reserved
spare sectors is more higher for HDD case. It means that probability to
encounter write error because of impossibility to remap bad sector is
more higher for HDD case, from my point of view.

Another bad thing with using dd for cleaning some bad sectors is
impossibility to distinguish what you try to rewrite. Because you try to
rewrite as user data as metadata. Zeroing some space in ext4 journal is
not very critical action. You will simply lose one or several
transaction in the journal. It means that the file system will be in
consistent state anyway. You could lose some user data. But if you try
to rewrite by means of dd some arbitrary sector into file system volume
then consequence of such action is hard to forecast. So, the best way is
to track and to process the occurrence of unrecoverable read error on
file system side.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
