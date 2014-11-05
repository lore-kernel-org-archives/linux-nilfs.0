From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 1/1] nilfs2: remove unnecessary call to
 nilfs_construct_dsync_segment()
Date: Wed, 05 Nov 2014 09:07:04 +0900 (JST)
Message-ID: <20141105.090704.583801206386960498.konishi.ryusuke@lab.ntt.co.jp>
References: <1414861267-13103-1-git-send-email-andreas.rohner@gmx.net>
	<20141104.233458.804333886341114381.konishi.ryusuke@lab.ntt.co.jp>
	<5458F5BD.2030908@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=UfWym1L1If4AATw1K5xxQmZLFXsgljYp9AA78Q/e0Ow=;
        b=k0v1Mh9jyTwuUDteW6R1BKmEjCpO6TJVHCnY+Ah9YdxXCyJ4F1N9quCViO4+Q8KUXy
         XzpNTPYgAcvFYTwhvaxR5XpBsmHM9vdlomjI0NJG7dSBpPJLYDTTMJO7sMlO9oeFVVuM
         feppDxPDmMHzeCGM0V2kzsRqwXzO6PsefxQg3YM8tdH9iD0b/UKoVAKlQl34kze2toHN
         rnwlvAKJwmPQaS0jKegqELab2NsQvdxOwqFYUJTe+OzMoAJbicAaUgr950ns3WyY+a7o
         ffiC6VNR9GYA+xJ3dKhdmSwTv6pccj4GfyXZPyqs8iq7dGysrcy8l6A2z/Hq1k7x+ofE
         793Q==
In-Reply-To: <5458F5BD.2030908-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 04 Nov 2014 16:50:21 +0100, Andreas Rohner wrote:
> On 2014-11-04 15:34, Ryusuke Konishi wrote:
>> Since each call to nilfs_construct_segment() or
>> nilfs_construct_dsync_segment() implies an IO completion wait, it
>> seems that this doubles the latency of fsync().
>> 
>> Do you really need to call filemap_write_and_wait_range() in
>> nilfs_sync_file() ?
> 
> I don't think we need it, but I found the following paragraph in
> Documentation/filesystems/porting:
> 
> [mandatory]
> 	If you have your own ->fsync() you must make sure to call
> filemap_write_and_wait_range() so that all dirty pages are synced out
> properly. You must also keep in mind that ->fsync() is not called with
> i_mutex held anymore, so if you require i_mutex locking you must make
> sure to take it and release it yourself.
> 
> So I was unsure, if it is safe to remove it. But maybe I interpreted
> that wrongly, since nilfs_construct_dsync_segment() and
> nilfs_construct_segment() write out all dirty pages anyway, there is no
> need for filemap_write_and_wait_range().

I found filemap_write_and_wait_range() returns error status of
already done page I/Os via filemap_check_errors().  We need to
look into what it does.

> Also do we need i_mutex? As far as I can tell all relevant code blocks
> are wrapped in nilfs_transaction_begin/commit/abort().

Yes, we may also remove the i_mutex.  We have to confirm what i_mutex
protects for nilfs.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
