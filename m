From: "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Best way to shut down NILFS2? (umount hang issue)...
Date: Wed, 25 Sep 2013 20:21:45 -0400
Message-ID: <52437E19.1050602@gmail.com>
References: <5238DAD8.3070804@gmail.com>    <1379485106.2365.11.camel@slavad-ubuntu>    <CAJzLF9nbfM6aY8u57Lgkm4r_mpBtd96J=HaqSnF=+oLvhYpmUw@mail.gmail.com>   <1379571773.2310.5.camel@slavad-ubuntu> <523B866D.9060406@gmail.com>  <1379664873.2280.11.camel@slavad-ubuntu> <523E6203.2090509@gmail.com> <1380097004.2335.23.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=XhkE1klQRMt9fVwPPBfYjAWW0Gyy2sYPpzOFljgfii0=;
        b=op2WauTIymBpRuyLrduhonYh1bKuP+mrZ6/Umwh6dWTEAI9/A5wnk9Ct3OZHPVmCD2
         WWZ7b807Gh8pMY8Wpr1st/RknZWcGcWjAMQ7nFwq3x2Aad/WL6iOdF/LwFpPOCdlbTMR
         +aMR7nIzPdKSOKTKE+khiyQxLWgao0ZfRWs9xBSsDn9ATw4+AclGggt2U3Re4jGBiF7e
         i7RVOfq83+76Cv9QOnImlhzZftnVob/2OVFrsF+uoN/IZGOD4U7Khjc4xwviqmk/VtKE
         Mf27IXibUy2zD4FMbKvD8lNE6blhjxKAhxaOitH3XQX+MjJo9H6vLD0+zf4JwomkS5om
         fX7g==
In-Reply-To: <1380097004.2335.23.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 09/25/2013 04:16 AM, Vyacheslav Dubeyko wrote:
> Unfortunately, I can't reproduce the issue, currently.
> 
> Your description of the reproducing patch is slightly complex. So, I can
> make something wrong (especially, for the case of rc script modification
> because I am using Ubuntu 12.04).

Sorry about that.  I sent the real scripts so you can see the real 
settings.  Really, I'm just trying to add a little bit of stress before 
the system daemons (sshd, ntpd, syslogd, klogd) are fully set up, then 
call shutdown.  The case was 100% reproducible that way.

> But I suspect that you have some additional workload before the issue
> reproducing. Can you reproduce the issue for the case of freshly made
> NILFS2 rootfs? Maybe fsstress is not the reason of the issue? Do you
> have any NILFS2 related messages in your system log before the issue
> reproducing?

Yes, it can be done on a freshly made filesystem.  In fact, NILFS2 
seems more stable after it has filled the drive with checkpoints and 
cleaned them several times.

I'll check my logs again for additional NILFS2 error messages.  None 
have been noted, other than for the recovery messages on the next 
mount.  I could be wrong.

The usual load is syslogd, klogd, ntpd, acpid, gpm, and sshd.  However, 
this is a debug kernel with various amounts of debug in it.  Tracing, 
lockdep, netconsole, and kgdb are always in there.  A crash kernel is 
always loaded, taking 9 MB of RAM.  [If you wish, I can upload a kernel 
core, vmlinux, and System.map to my Google Drive, if you are good at 
working with crash dumps.]  Sometimes, the CONFIG_PAGEALLOC and SLUB 
debugging are added to this mix. 

Also, in case it makes a difference, SLUB is the slab allocator, and the 
Deadline I/O scheduler is almost always used.
 
> So, current description of the issue's reproducing path doesn't work for
> me.

No worries.  If I have a problem with sync or umounts, it's either 
because a) I've compiled a lot of programs before trying a sync or 
umount, or b) more than one NILFS2/nilfs_cleanerd pair is open at the 
same time.  All I'm hoping is that if such problems happen on your PC, 
they will be problems that you understand well already.

For what it's worth, my problem NILFS2 / partition just withstood two 
full runs of xfstests (for XFS) and a full run of LTP.  For now, the 
hang on shutdown is completely gone.

Good luck!

Michael

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
