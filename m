From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: remove BKL uses
Date: Mon, 5 Jul 2010 16:53:29 +0200
Message-ID: <20100705145324.GA5240@nowhere>
References: <1278220928-28121-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <201007051650.23761.arnd@arndb.de>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:received:date:from:to:cc
         :subject:message-id:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        bh=/1kSIRTP7bOoawE5DH0le47P97TCveJe439HfPpFp10=;
        b=DhN1Hn+cLdmgjQdMY5WkyDasvdBiPMFkuMSbicf4RQarMFVrmYkAvRTZznCXxYuOT6
         gzLOZXHQEnvDquojJuF11ewsRnLWI2a5pfn8CpV+iQoTc7RYU9IpzHTMHSMc6uscGQNT
         8EoN/tjJD3hNjpq85vHuMVO161Dbll7kh/dFs=
Content-Disposition: inline
In-Reply-To: <201007051650.23761.arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Blunck <jblunck-l3A5Bk7waGM@public.gmane.org>

On Mon, Jul 05, 2010 at 04:50:23PM +0200, Arnd Bergmann wrote:
> On Sunday 04 July 2010, Ryusuke Konishi wrote:
> > Nilfs has BKL uses in its put_super and remount functions, but none of
> > them are necessary, just came from earlier push downs.  This
> > eliminates the BKL uses from nilfs.
> > 
> > Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> 
> This looks good, but there is a another patch series pushing the BKL
> into the get_sb and fill_super operations, which should be the final
> pushdown for file systems. I wonder if there is a way to find a
> shortcut on this so we don't need to add it first just to have you
> go through the effort of removing it again.


I could take his patch in the mount pushdown series.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
