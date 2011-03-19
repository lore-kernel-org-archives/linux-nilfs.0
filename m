From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Problem report: cannot run nilfs_cleanerd on full filesystem
Date: Sat, 19 Mar 2011 23:12:37 +0100
Message-ID: <201103192312.38046.dexen.devries@gmail.com>
References: <201103191738.00187.dexen.devries@gmail.com> <20110319220157.GA681@heethoofdje.13thmonkey.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=jb3pFx2zfkVsn3oOFR4Xwki6oA3cNY21zaAyTPxwpHo=;
        b=GWWPWgTfWPcx7T3K62424jpex7uj823ZOlmKKWdRbuV0oOF4urRFLRL9aiEGaH6wSb
         mYcHD1nG1/Gz92pFqXnYZ72Y69k7eZG3kUcmKEBLqm7VpXcJlWs62BuaTsjXewGIi02f
         QycUf8gsch4ImRgZ3y3NpfkTlhqwwmxwFwJVs=
In-Reply-To: <20110319220157.GA681-bVHBekiX4bNgoMqBc1r0ESegHCQxtGRMHZ5vskTnxNA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Saturday 19 of March 2011 23:01:57 you wrote:
> I presume that /mnt/x/.nilfs is a node on the mounted FS? Shouldn't that
> node be present allways and thus doesn't need to be created? or is it
> deleted first and then recreated resulting in an error since the FS is
> full? ;)
> 
> BSD traditionally save some inodes/blocks for the superuser. Maybe some
> blocks could be reserved for the nilfs_cleanerd to work with? even if only
> a few? Depending on the uid/guid of the program?

You are right about the `.nilfs'.

I botched testing; I've removed the .nilfs file by a mistake. *that* caused 
nilfs_cleanerd not to start on a full filesystem -- because it cannot create 
the `.nilfs' file in its root directory.

The problem will thus appear when both:
1) filesystem is full
2) the `.nilfs' file is not present
3) nilfs_cleanerd is re-started (for example reboot).

Not very likely to happen in practice, but not very cool either.

As for reserved blocks, that's an ugly solution IMHO. And so is delete-proofing 
the on-disk `.nilfs' file. But perhaps the `.nilfs' could be made a virtual 
file, maintained by the NILFS2 driver rathre than a plain on-disk object?

Another possibility would be to represent each mounted filesystem somewhere in 
/sys hierarchy, so an read-write filedescriptor could be obtained without use 
of a magic file on the filesystem proper.


Regards,
-- 
dexen deVries

``One can't proceed from the informal to the formal by formal means.''
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
