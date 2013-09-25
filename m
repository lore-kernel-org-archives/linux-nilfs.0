From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Best way to shut down NILFS2? (umount hang issue)...
Date: Wed, 25 Sep 2013 12:16:44 +0400
Message-ID: <1380097004.2335.23.camel@slavad-ubuntu>
References: <5238DAD8.3070804@gmail.com>
	   <1379485106.2365.11.camel@slavad-ubuntu>
	   <CAJzLF9nbfM6aY8u57Lgkm4r_mpBtd96J=HaqSnF=+oLvhYpmUw@mail.gmail.com>
	  <1379571773.2310.5.camel@slavad-ubuntu> <523B866D.9060406@gmail.com>
	 <1379664873.2280.11.camel@slavad-ubuntu> <523E6203.2090509@gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=KLsFDWg39sZUN+TC9q6p/GZYW68DoHuLcMMmXlFouS4=;
	b=eymYJv/8omgoTEOmVdeS+LjxyYERcLurBNrG3atITNjNgadG7HJjeqOGtDaNkcTRMq4AbRCvESDW/tOyzdyUiefQ3NYKi7l28ZEZTb37YxVR8fI7ulBfd65ilUiPiZP7;
In-Reply-To: <523E6203.2090509-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Michael,

On Sat, 2013-09-21 at 23:20 -0400, Michael L. Semon wrote:

[snip]
> # ===============================================================
> 
> My test case started to succeed, and the next 20-30 reboots were successful.  
> [Again, the problem can fix itself over time.]  So I inserted this into my 
> /etc/rc.d/rc.local script:
> 
> # ======================= SCRIPT FRAGMENT =======================
> 
> echo 'Issuing `nilfs-tune -l /dev/sdb12`...'
> /sbin/nilfs-tune -l /dev/sdb12
> echo "Querying mounts using the mount command..."
> /bin/mount
> echo 'Issuing `nilfs-clean --status /dev/sdb12`'
> /sbin/nilfs-clean --status /dev/sdb12
> echo "Running fsstress..."
> /opt/ltp/testcases/bin/fsstress -p 16 -n 100 -d /tmp/test
> echo "Invoking shutdown..."
> /sbin/shutdown -r now
> 
> # ===============================================================
> 
> Note that it uses the fsstress from the latest LTP (September 2013) 
> from ltp.sourceforge.net.  The fsstress from xfstests does not cause 
> any problems.
> 

[snip]
> # echo "Issuing nilfs-clean -b for / ."
> # /sbin/nilfs-clean -b /dev/sdb12
> 
> echo "Unmounting local file systems, except for NILFS2 file systems."
> /bin/umount -v -a -t noproc,nosysfs,nonilfs2
> 
> echo "Checking mounts before umounting NILFS2 file systems:"
> /bin/mount
> 
> # Comment out the next two lines to test umount hangs instead of sync hangs.
> echo "Issuing sync"
> /bin/sync
> 
> echo "Unmounting NILFS2 file systems."
> /bin/umount -v -a -r -t nilfs2,noproc,nosysfs
> # /sbin/hdparm -F /dev/sda /dev/sdb
> 
> echo "Remounting root filesystem read-only."
> /bin/mount -t nilfs2 -n -o remount,ro /dev/sdb12 /
> 
> # This never hurts:
> # /bin/sync
> 

Unfortunately, I can't reproduce the issue, currently.

Your description of the reproducing patch is slightly complex. So, I can
make something wrong (especially, for the case of rc script modification
because I am using Ubuntu 12.04).

But I suspect that you have some additional workload before the issue
reproducing. Can you reproduce the issue for the case of freshly made
NILFS2 rootfs? Maybe fsstress is not the reason of the issue? Do you
have any NILFS2 related messages in your system log before the issue
reproducing?

So, current description of the issue's reproducing path doesn't work for
me.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
