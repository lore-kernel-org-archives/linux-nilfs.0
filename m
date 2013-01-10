From: Paul Fertser <fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: New experience with the odd problem starting nilfs_cleanerd
	due to an eMMC misbehaviour
Date: Thu, 10 Jan 2013 18:12:22 +0400
Message-ID: <20130110141222.GD29689@home.lan>
References: <20130110131659.GA29689@home.lan> <1357824862.2050.48.camel@slavad-ubuntu> <20130110134907.GB29689@home.lan> <1357826459.2050.52.camel@slavad-ubuntu>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=b5tUAVt4703jSkUaMx6ynVWpjoQdb3/LbySsoK1qqYA=;
        b=zfrEyBq8L4nfoKOlZiyh4E8iw/dkX1QJbEO4aepPhZBNqsjGDTmOUSVCM/SnyDpoBR
         zcmVFZvYxLUUdPdVoPRoNd2VzfsFMOoNGAhNBzUmwDuczMjuxArLvjy+yn07wfkXk7bN
         xZ8BhHzU7wHgsk6eB9JNKDfBWmFGwR92fW1/wHWHqZ7usL/xYCOtb7Mzzm8oMuJVVYNA
         lt1ySUyYM2w78aaV0Hg7r6Sm1fT89Im3ao8wXvZ7UpMJrhiaqQtSzetljkWfyEuNtB0n
         Dn5DhtlLiPyRrKMIrXbZqXeX2mmfwBoDKdug9sno7MjqEEv+DH/IOunN8JqVAKRQ+N9w
         i7qw==
Content-Disposition: inline
In-Reply-To: <1357826459.2050.52.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jan 10, 2013 at 06:00:59PM +0400, Vyacheslav Dubeyko wrote:
> Anyway, thank you for the report.

Big thanks to you for caring about the project!

> > I think you can reproduce something similar with loopback mounting if
> > you modify the driver to return read error for some particular sectors
> > that cleanerd wants to access when it starts cleaning.
> 
> Yes, it is a good idea. I'll try it. But I worry only that it is
> possible to investigate not the issue that was reported by you.

I think what's important is to keep in mind the following failure
scenario: a misbehaving media suddenly starts returning read errors
consistently for a number of sectors until the whole erase block is
written to.

I also found two nice options to simulate my situation:
http://stackoverflow.com/questions/1870696/simulate-a-faulty-block-device-with-read-errors

Good luck and happy hacking.
Spasibo!
-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
