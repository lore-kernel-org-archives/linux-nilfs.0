From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs2 doesn't garbage collect checkpoints for me
Date: Thu, 26 May 2011 20:32:53 +0200
Message-ID: <201105262032.54257.dexen.devries@gmail.com>
References: <BANLkTim4BBKwFJUzbnsKw0_Ru2k8ZW3MYw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=53YKv0owMExjPizEX5mtfr65Ajog5Q8+SxbPw39RDbE=;
        b=GeoPXewMmWy3DuC841XGlu3KXm4/7if/b7zGIaikw33wrq8kjmhbSUGKxbCtj2UMM8
         qtxGYG+53fzceO4/BrWnaRfrqncIT1O20wM9JDCDk00/OxvmUpbP9Aax/gNS8UeWIlsO
         anref6OE/jBgta71Pm9VR9n/nARGq6k9I4hVY=
In-Reply-To: <BANLkTim4BBKwFJUzbnsKw0_Ru2k8ZW3MYw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,


On Thursday 26 of May 2011 20:11:55 you wrote:
> I'm testing nilfs2 and other fs's for use on cheap flash cards, trying
> to avoid writing same location all the time.

I'm using nilfs2 on a small server with a cheap-o 16GB SSD extracted from 
Eeepc for the same reason; works great.



> My test program makes lots of small sqlite transactions which sqlite
> syncs to disk.
> In less than 2000 transaction 1GB nilfs2 volume ran out of disk space.
> tried unmount, mount again, didn't help
> block device is nbd, works with with other fs's
> 
> lscp shows there are 7121 checkpoints and somehow old ones are not
> removed automatically.

First off, the default configuration of nilfs_cleanerd is to keep all 
checkpoints for at least one hour (3600 seconds). See file 
/etc/nilfs_cleanerd.conf, option `protection_period'. For testing you may want 
to change the protection period to just a few seconds and see if that helps. 
Either via the config file (and issue a SIGHUP so it reloads the config) or via 
the `-p SECONDS' argument (see manpage).

To see what's going on, you may want to change (temporarily) the 
`log_priority' in config file to `debug'; in /var/log/debug you should then see 
statements describing actions of the nilfs_cleanerd.


Example:

May 26 20:23:53 blitz nilfs_cleanerd[3198]: wake up
May 26 20:23:53 blitz nilfs_cleanerd[3198]: ncleansegs = 1175
May 26 20:23:53 blitz nilfs_cleanerd[3198]: 4 segments selected to be cleaned
May 26 20:23:53 blitz nilfs_cleanerd[3198]: protected checkpoints = 
[156725,157003] (protection period >= 1306430633)
May 26 20:23:53 blitz nilfs_cleanerd[3198]: segment 1844 cleaned
May 26 20:23:53 blitz nilfs_cleanerd[3198]: segment 1845 cleaned
May 26 20:23:53 blitz nilfs_cleanerd[3198]: segment 1846 cleaned
May 26 20:23:53 blitz nilfs_cleanerd[3198]: segment 1847 cleaned
May 26 20:23:53 blitz nilfs_cleanerd[3198]: wait 0.488223000


where the `ncleansegs' is the number of clean (free) segments you already 
have, and `protected checkpoints' indicates range of checkpoint numbers that 
are still under protection (due to the `protection_period' setting)


In any case, my understanding is that in typical DB, each transaction (which 
may be each command, if you don't begin/commit transaction explicitly) causes 
an fsync() which creates a new checkpoint. On a small drive that *may* cause 
creation of so many checkpoints in a short time they don't get GC'd before the 
drive fills up. Not sure yet how to work around that.



Two more possible sources of the problem:
1) GC used to break in certain scenario: the FS could become internally 
inconsistent (no data loss, but it wouldn't perform GC anymore) if two or more 
nilfs_cleanerds were processing it at the same time. It's probably fixed with 
the most recent patches. To check if that's the case, see output of `dmesg' 
command; it would indicate problems in NILFS.

2) new `nilfs_cleanerd' process may become stuck on semaphore if you kill the 
old one hard  (for example, kill -9). That used to leave aux file in /dev/shm/, 
like /dev/shm/sem.nilfs-cleaner-2067. To check if that's the case, run 
nilfs_cleanred through strace, like:

# strace -f nilfs_cleanerd /dev/YOUR_FILESYSTEM

if it hangs at one point on futex() call, that's it. A brute-force, but sure-
fire way is to kill all instances of nilfs_cleanerd and remove files matching 
/dev/shm/sem.nilfs-cleaner-*


Hope that helps somehow~


-- 
dexen deVries

``One can't proceed from the informal to the formal by formal means.''
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
