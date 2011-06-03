From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Split some metadata onto separate device?
Date: Fri, 3 Jun 2011 19:42:28 +0200
Message-ID: <201106031942.29133.dexen.devries@gmail.com>
References: <201106031229.38758.dexen.devries@gmail.com> <20110604.022621.01482278.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=e6LxvLhS7i4T3TadpGIpcyaSvl4iwd8JhlUt4sxpx2k=;
        b=ewYUNgjEs/WJzVjBjK27W/piMnimjPQY7/EIbhHg/JynRPCa1wAZ/YCJFPakdVtb/s
         bpYefB5epUxnv20HKrIJRv7DvPzHKRgd1yEr0CAdwO1F+wo4IC0VtTzNT8Nv2fZhBSzb
         UFajhYNGPS9yc0RM1Rt/TlxQKr3l++W7fdf/g=
In-Reply-To: <20110604.022621.01482278.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,


On Friday 03 June 2011 19:26:21 you wrote:
> (...) 
> NILFS2 is a log-structured filesystem and that means the filesystem
> itself is a big journal.  My understanding is using separate journal
> device has no merit of performance.
> 
> On the other hand, We may be able to speed up the filesystem by
> putting DAT (disk address translation) metadata to a separate device.
> I mean putting a full copy of the DAT metadata on the sperate device
> instead of journal of it.

*nods* sounds interesting. Of course changing on-disk format would hurt ;-)


> But, I think we have other approaches to think about before that with
> regard to performance improvement.  For example, applying "extent" to
> DAT seems much more effective.

Currently every block of file gets own entry in DAT, right?


By the way, it seems to me that the in-kernel GC does not attempt to de-
fragment files. Is that the case? If so, would probably mean extents would not 
help very much for fragmented files. Also, on magnetic media, a lot of seeking 
happens in case of fragmented files.


Regards,
-- 
dexen deVries

``One can't proceed from the informal to the formal by formal means.''
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
