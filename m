From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Corrupted a nilfs volume
Date: Wed, 23 Jan 2013 09:52:47 +0400
Message-ID: <1358920367.2081.7.camel@slavad-ubuntu>
References: <6045199.GMMAmmf5QP@jcanhamlaptop>
	 <1358748330.2546.6.camel@slavad-ubuntu> <2046642.TUXYeIIucd@jcanhamlaptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=lD29HV7Aou/fJPjn5XPksbo78yF6/CC9izndFIki6Hw=;
	b=toUuv7JCgKpvoDrxF6MnLBYnFLvpvgAWD5jdb+fZuCpjqcBiLvPv2qPsG5KdANyczYLtlEcU6dkgYmrYxfpmaaFhBM2vihqk2ztcJmcMeNiyKA2VdfpAyaepBZ6+b/I+;
In-Reply-To: <2046642.TUXYeIIucd@jcanhamlaptop>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juan Barry Manuel Canham <Linux-pOR+BrglI3BO41XttqYhMtHuzzzSOjJt@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Juan,

On Tue, 2013-01-22 at 00:47 +0000, Juan Barry Manuel Canham wrote:
> On Monday 21 Jan 2013 10:05:30 Vyacheslav Dubeyko wrote:
> Hi Vyacheslav,
> 
> Thanks for the quick response.
> 
> If there is nothing I can do to help, is there a way to fix it (is it just a 
> single corrupt file) or do I need to reformat?
> 

I suggest to wait now. If you can live with single corrupt file then,
please, don't hurry. This corruption takes place because of bug in
driver. But it needs to analyze what to do with such corrupted files
after the issue resolving. Maybe, it needs to prepare special patch for
solving this side effect with presence of corrupted files.

With the best regards,
Vyacheslav Dubeyko.

> Thanks, Juan
> > Hi Juan,
> > 
> > On Sun, 2013-01-20 at 22:15 +0000, Juan Barry Manuel Canham wrote:
> > > Hi and thanks for the great fs.
> > > 
> > > I managed to corrupt a volume (my /var)
> > > 
> > > to do this I was running an upgrade and when I ran out of space I ran
> > > 
> > > 	while true; do sudo nilfs-clean -v -S 10/1 -p 1  /dev/sda4; df -h 
> /var/ |
> > > 	tail -n 1 ; sleep 1 ; done> 
> > > I'm running
> > > 
> > > 	Linux JCanhamLaptop 3.3.0-rc4 #1 SMP Fri Feb 24 19:12:32 GMT 2012 
> x86_64
> > > 	x86_64 x86_64 GNU/Linux> 
> > > I know it's an RC but I never got round to upgrading, hope this doesn't
> > > invalidate my bug
> > > 
> > > I've attached what I think are the relevant dmesg and syslog but they are
> > > a bit long,
> > > 
> > > I can make the system be remounted read-only by running apt-get autoclean
> > > 
> > > Jan 20 22:08:15 localhost kernel: [129306.872119] NILFS: bad btree node
> > > (blocknr=185027): level = 0, flags = 0x0, nchildren = 768 Jan 20 22:08:15
> > > localhost kernel: [129306.872127] NILFS error (device sda4):
> > > nilfs_bmap_last_key: broken bmap (inode number=11540) Jan 20 22:08:15
> > > localhost kernel: [129306.872129]
> > > Jan 20 22:08:15 localhost kernel: [129306.872131] Remounting filesystem
> > > read-only Jan 20 22:08:15 localhost kernel: [129306.872135] NILFS warning
> > > (device sda4): nilfs_truncate_bmap: failed to truncate bmap (ino=11540,
> > > err=-5)
> > > 
> > > Remounting rw works until I run autoclean
> > > Jan 20 22:08:44 localhost kernel: [129335.576471] segctord starting.
> > > Construction interval = 5 seconds, CP frequency < 30 seconds Jan 20
> > > 22:08:44 localhost kernel: [129335.576483] NILFS warning: mounting fs
> > > with errors Jan 20 22:08:44 localhost nilfs_cleanerd[16781]: start
> > > Jan 20 22:08:44 localhost nilfs_cleanerd[16781]: pause (clean check)
> > > Jan 20 22:08:45 localhost nilfs_cleanerd[16786]: start
> > > Jan 20 22:08:45 localhost nilfs_cleanerd[16786]: pause (clean check)
> > 
> > Thank you for your report.
> > 
> > This issue is under investigation and fix. Currently, I think that the
> > reason of the reported by you issue is low value of vm.min_free_kbytes
> > and the issue with flush kernel thread. The issue with flush kernel
> > thread is near of fix. So, it needs to wait sometime. I hope that the
> > patch will be prepared soon. I need a time for testing and check the
> > fix.
> > 
> > With the best regards,
> > Vyacheslav Dubeyko.
> > 
> > > Thanks for any help and I hope I can help track down this bug
> > > 
> > > Juan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
