From: Paul Fertser <fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Unrecovered read error issue
Date: Sat, 19 Dec 2015 10:17:03 +0300
Message-ID: <20151219071703.GP3706@home.paul.comp>
References: <1450488372.2652.25.camel@slavad-ubuntu-14.04>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=MbXUzdnI0vxncsZINN6HTCvxffAdIlQCfGn73SN5yU4=;
        b=Ci1RxjYYSP6lhGhCbVDCVie5wmB9F8TyM58n7k8vOw2sWYHqAjI5LTx9upxEO3q5+x
         xHZAEG/w6F34oVKN9UaIp6Iw2Llv8Qo5P+0au5Ve4fDO26n9qzJiA3ssjEZKaO59+ldd
         6cYuDT7vbbusQJAtvahExsxew7Tt3MhKR8ccFq9Bm+Z+69m+rRLN6bC+QOLeg4aRt9JP
         N928i7d/2gFQbtSsyW3UAw0Ede223p9q8GZwhlpaZEoIuqWNGwLzaxKgQwuY9YcUYHKj
         FLOTmcKgSe09x1OeNCFG7PXtu1UjNcym7UnqrT/4GwJBeI0AIcIHO89Xp+gt9Yt19SM3
         A3Cg==
Content-Disposition: inline
In-Reply-To: <1450488372.2652.25.camel-dzAnj6fV1RzTdvqWZYKEhEEK6ufn8VP3@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Viacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Brian Cottingham <spiffytech-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hey Viacheslav,

On Fri, Dec 18, 2015 at 05:26:12PM -0800, Viacheslav Dubeyko wrote:
> So, what do you think about such issue? What possible and easy solution
> do you see? We haven't opportunity for long-term implementation and we
> need in some easy hack for it. What do you think?

I reported this issue several years ago (in my case GC was choking on
bad sectors of an eMMC), and no hack was considered to be necessary; I
had to resort to manually dd 4096 zero bytes to the affected block
every time I faced it.

I'm glad to see this is finally getting some attention!

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
