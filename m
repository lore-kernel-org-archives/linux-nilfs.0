From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: NILFS2 get stuck after bio_alloc() fail
Date: Sun, 14 Jun 2009 10:00:06 +0300
Message-ID: <84144f020906140000v7b38f520rc5d9849b8ea8ad7e@mail.gmail.com>
References: <20090614013211.GA22552@homero.springfield.home>
	 <20090614015240.GW30412@blitiri.com.ar>
	 <20090614.153046.25768784.konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753894AbZFNHAU@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:sender:received:in-reply-to
         :references:date:x-google-sender-auth:message-id:subject:from:to:cc
         :content-type:content-transfer-encoding;
        bh=B+JgUDBKsMHm5y3+E1Qt5zERnGu42Cnh3DNwncOwxwY=;
        b=Abk1xWOkTmNP+wGwZjc59T5EfgzQSqnEyXkWhOfY48bSbzxyJHfhSE3rlsNxWj7xrf
         eiy6lpN1IXJifix6LHhs5xNnLWCzkTHqWmlUmkAu+aNa3ihgHmPjRj4kYkGkQHRR1A8w
         6SJ54zWVyR6jTinfhuc6k034fvsEw9drX1lu4=
In-Reply-To: <20090614.153046.25768784.konishi.ryusuke@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: albertito@blitiri.com.ar, llucax@gmail.com, linux-kernel@vger.kernel.org, users@nilfs.org

On Sun, Jun 14, 2009 at 9:30 AM, Ryusuke
Konishi<konishi.ryusuke@lab.ntt.co.jp> wrote:
> The original GFP flag was GFP_NOIO, but replaced to GFP_NOWAIT at a
> preliminary release in February 2008. =A0It was because a user
> experienced system memory shortage by the bio_alloc() call.
>
> Even though nilfs_alloc_seg_bio() repeatedly calls bio_alloc()
> reducing the number of bio vectors in case of failure, this fallback
> did not work well.
>
> I'm in two minds whether I should change it back to GFP_NOIO.
> Or should I switch the gfp as follows?

As far as I can tell, the only difference with GFP_NOIO and GFP_NOWAIT
here is that the former will trigger the mempool_alloc() page reclaim
path. But I am not sure I understand why switching to GFP_NOWAIT
helped with memory shortage. What exactly was the problem there?

                                 Pekka
