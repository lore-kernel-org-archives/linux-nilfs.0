From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs2 weird issue - snapshots are gone, cleanerd not running
Date: Tue, 10 Jul 2012 14:43:43 +0400
Message-ID: <1341917023.1973.14.camel@slavad-ubuntu-11>
References: <20120709073300.GP1478@wloczykij> <10181027.pPHs7IDARt@coil>
	 <20120710075131.GV1478@wloczykij>
	 <1341909282.1973.3.camel@slavad-ubuntu-11>
	 <20120710095008.GW1478@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:References:In-Reply-To:Cc:To:From:Subject; bh=MAmmocTaw3DICS0KUvQDqzok1UHvrfvoW1xw/29cEOs=;
	b=OvkSPzKdmG/KoTVRKf1FKMVwlPKP3QpWtoENj4h3GJE041r+gIMJMjyrdMZ+qn/XpMm7g4qA/VDnwg2Nm84fRk0IzDotIB3QY40Q2e9E5yaxCTl4n9U2arwevy1/moMf;
In-Reply-To: <20120710095008.GW1478@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Piotr,

Could you check that in your kernel CONFIG_POSIX_MQEUEU (General Setup
\POSIX Message Queues), CONFIG_SHMEM and CONFIG_TMPFS options are
enabled?

Thanks,
Vyacheslav Dubeyko.

On Tue, 2012-07-10 at 11:50 +0200, Piotr Szymaniak wrote:
> On Tue, Jul 10, 2012 at 12:34:42PM +0400, Vyacheslav Dubeyko wrote:
> > Hi Piotr,
> > 
> > Could you send your output of "strace -f"? I guess that it is problem
> > with semaphore opening as I can see in my reproduction. But it needs to
> > compare our cases.
> 
> I'm not a strace guru, but it looks like some issue with new udev (or
> whatever creating devices/symlinks in /dev). Right now I'm missing /dev/root
> at machine with issues with nilfs_cleanerd:
> 
> maszyn ~ (: LANG="C" ls -l /dev/root
> ls: cannot access /dev/root: No such file or directory
> 
> While on the other:
> wloczykij ~ (: LANG="C" ls -l /dev/root
> lrwxrwxrwx 1 root root 4 Jun 27 21:50 /dev/root -> sda3
> 
> strace -f log attached.
> 
> Piotr Szymaniak.
> 
> 
> 
> > On Tue, 2012-07-10 at 09:51 +0200, Piotr Szymaniak wrote:
> > > On Mon, Jul 09, 2012 at 11:33:13AM +0200, dexen deVries wrote:
> > > > On Monday 09 of July 2012 09:33:00 you wrote:
> > > > >(...)
> > > > > Where to go from this point? How to debug nilfs_cleanerd issue?
> > > > 
> > > > using strace -f  on the nilfs_cleanerd should give you a clue what causes the 
> > > > exit. it may exit if can't connect to syslogd.
> > > 
> > > Hi list,
> > > 
> > > I will try to sort information from few messages together here.
> > > 
> > > Attached strace output from my "nilfs_cleanerd" for rootfs. The script
> > > is in /etc/local.d (again, Gentoo Linux) and it looks like this (removed
> > > commented parts and empty lines):
> > > CONFILE="/etc/nilfs_cleanerd_rootfs.conf"
> > > TARGETDISK="/dev/disk/by-uuid/1aa9e6fb-cf7d-45bd-bbfb-08110a8840b7"
> > > /sbin/nilfs_cleanerd -c "${CONFILE}" "${TARGETDISK}"
> > > 
> > > And here's the mentioned nilfs_cleanerd_rootfs.conf:
> > > protection_period	3600
> > > min_clean_segments	13%
> > > max_clean_segments	25%
> > > clean_check_interval	10
> > > selection_policy	timestamp	# timestamp in ascend order
> > > nsegments_per_clean	2
> > > mc_nsegments_per_clean	4
> > > cleaning_interval	5
> > > mc_cleaning_interval	1
> > > retry_interval		60
> > > use_mmap
> > > log_priority		info
> > > 
> > > 
> > > > if `lscp' reports no checkpoints, try `lscp -a' -- should show even minor 
> > > > checkpoints (which are checkpoints created by GC, AFAIK).
> > > 
> > > That's right, lscp -a gives some more output:
> > > maszyn ~ # lscp -a | wc -l
> > > 1428
> > > 
> > > Running nilfs_cleanerd with more verbose output (log_priority debug)
> > > gives me this:
> > > Jul 10 09:45:26 [nilfs_cleanerd] start
> > > Jul 10 09:45:26 [nilfs_cleanerd] cannot open nilfs on /dev/sda2: No such
> > > file or directory
> > > Jul 10 09:45:26 [nilfs_cleanerd] cannot create cleanerd on /dev/sda2: No
> > > such file or directory
> > > Jul 10 09:45:26 [nilfs_cleanerd] shutdown
> > > 
> > > 
> > > maszyn ~ # ll /dev/sda2
> > > brw-rw---- 1 root disk 8, 2 lip 10  2012 /dev/sda2
> > > 
> > > maszyn ~ # ll /dev/disk/by-uuid/1aa9e6fb-cf7d-45bd-bbfb-08110a8840b7 
> > > lrwxrwxrwx 1 root root 10 lip 10  2012
> > > /dev/disk/by-uuid/1aa9e6fb-cf7d-45bd-bbfb-08110a8840b7 -> ../../sda2
> > > 
> > > 
> > > Piotr Szymaniak.
> > 
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
