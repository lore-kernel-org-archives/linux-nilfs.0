From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: mkfs.nilfs2 -b 1024 -B 8192
Date: Wed, 10 Apr 2013 10:19:14 +0400
Message-ID: <1365574754.2577.5.camel@slavad-ubuntu>
References: <20130313071453.GA17072@grill.lan>
	 <424816AD-A79B-4F3D-A886-8D0CC735812B@dubeyko.com>
	 <20130409210827.GA3809@grill.lan>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=7P44j4FnuLDphwVo7pNod9jRaEVLo+W0p1BJc2vvF6U=;
	b=Qbu7uOPOP5XNjPjyGry1RluDX7J178QeDJoETIQbma+cXjdaxn6by2POxEYlza87ZJDghkIAkWnKBaptH1MtA8xPNm8M2HyYEe9xKIyi0ybNeYFZXlMyHOgNl55tGO11;
In-Reply-To: <20130409210827.GA3809-P/DK4avwC2n/PtFMR13I2A@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Anthony Doggett <Anthony2486-fDpYTK8McCxDP812hmKXO1pr/1R2p/CL@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Anthony,

On Tue, 2013-04-09 at 22:08 +0100, Anthony Doggett wrote:
> Hi Vyacheslav
> 
> I've been curious as to what within the "darcs whatsnew" was causing the
> "nilfs_direct_assign: invalid pointer: 0" / "broken bmap" issue for 1kB
> blocks and I had a quiet half hour today, so I've boiled it down to a
> simpler script and a short bit of C.  I include both below just in case
> you should find them useful.  I was surprised to see that the 'a' makes
> it to the file despite the filesystem errors.
> 

Thank you.

I am using your previous script for the issue investigation. I have a
picture of the issue but I don't find the reason of it yet. I think that
I'll use your new script during investigation.

Thanks,
Vyacheslav Dubeyko.

> Kind regards,
> Anthony

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
