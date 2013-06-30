From: Paul Fertser <fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: New experience with the odd problem starting nilfs_cleanerd
	due to an eMMC misbehaviour
Date: Sun, 30 Jun 2013 11:56:26 +0400
Message-ID: <20130630075626.GJ22224@home.lan>
References: <20130110131659.GA29689@home.lan> <1357824862.2050.48.camel@slavad-ubuntu> <20130630074404.GI22224@home.lan>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=C0tbVYXjcUo+wViAntVVJR+db+XrxqKVipuLV8r9ekE=;
        b=Y8XmXqtqMA8pcXiOHt1DfM2Tt4Mg912qyYKm5QmkeMH5SKem9Btvr9217Y4fbaujFL
         FxJpXNOcHXaQadrVEc+p7qZzJ8qQwSM5QqXPV302hxVtho6RQ9JY1FOlMhYxruogpGgc
         s5du8M3MMtf5RQGWxL7KqQbvVIV7AAgSn7irFmdGawzvdQktQfWMwh9gRK4DqNJX2eKo
         4mRFtMBKGCob4LAUYfvjuEGhUImQu3+xj8Y/IaXTYdt8D/z0xIIKWOjIHpwS46djD/B5
         hqTQl06esWpfjY8oZBb6cNXHngc2R22Gmmq2zCtYlvNxNrjSH0R/kE9+Phlg5llpoYZ0
         jd7Q==
Content-Disposition: inline
In-Reply-To: <20130630074404.GI22224-0MSThuzptbI@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Jun 30, 2013 at 11:44:04AM +0400, Paul Fertser wrote:
> Attaching dumpseg output for segment 2713, strace for nilfs_cleanerd,
> etc, HTH.

But now zeroing out the eMMC sectors that lead to errors didn't help,
I get

[   81.903509] nilfs_cpfile_delete_checkpoints: invalid range of checkpoint numbers: [0, 436896)
[   81.912342] NILFS: GC failed during preparation: cannot delete checkpoints: err=-22

Jun 30 11:51:43 ac100-debian nilfs_cleanerd[1553]: start
Jun 30 11:51:43 ac100-debian nilfs_cleanerd[1553]: pause (clean check)
Jun 30 11:51:43 ac100-debian nilfs_cleanerd[1553]: resume (clean check)
Jun 30 11:51:43 ac100-debian nilfs_cleanerd[1553]: ncleansegs = 464
Jun 30 11:51:43 ac100-debian nilfs_cleanerd[1553]: 4 segments selected to be cleaned
Jun 30 11:51:43 ac100-debian nilfs_cleanerd[1553]: cannot clean segments: Invalid argument
Jun 30 11:51:43 ac100-debian nilfs_cleanerd[1553]: shutdown

I've no backups for this volume which is a rootfs on my netbook, not
that it has something very important but I'd like to keep it
functional... Any ideas how to proceed?

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
