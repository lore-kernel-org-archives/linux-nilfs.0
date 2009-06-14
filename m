From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: NILFS2 get stuck after bio_alloc() fail
Date: Sun, 14 Jun 2009 21:34:19 +0900 (JST)
Message-ID: <20090614.213419.35998061.konishi.ryusuke@gmail.com>
References: <20090614015240.GW30412@blitiri.com.ar>
	<20090614.153046.25768784.konishi.ryusuke@gmail.com>
	<84144f020906140000v7b38f520rc5d9849b8ea8ad7e@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759120AbZFNMez@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:sender:date:message-id:to:cc
         :subject:from:in-reply-to:references:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        bh=TDvAjdTi3hWDI5PyOvFZ/6xR95PTpfKDr3Pngf3sOHY=;
        b=C3Daz4ZIAQSFAZ6XXE0HaeT6EIG7Yyo90wQrCYYQQ1PoHWSWTXaoCbgo6609dRAkYV
         8b4yBJxEH1tvjZUDTW6WOV8s9w8UkrNsbvDmyypR3teHgzquqs3Anxq89cdmSxEQ+lDD
         13jZMxkauoVoDQRLcEchVCXOxR/mVkkZYpFKE=
In-Reply-To: <84144f020906140000v7b38f520rc5d9849b8ea8ad7e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: penberg@cs.helsinki.fi
Cc: konishi.ryusuke@lab.ntt.co.jp, albertito@blitiri.com.ar, llucax@gmail.com, linux-kernel@vger.kernel.org, users@nilfs.org

Hi,
On Sun, 14 Jun 2009 10:00:06 +0300, Pekka Enberg <penberg@cs.helsinki.f=
i> wrote:
> On Sun, Jun 14, 2009 at 9:30 AM, Ryusuke
> Konishi<konishi.ryusuke@lab.ntt.co.jp> wrote:
>> The original GFP flag was GFP_NOIO, but replaced to GFP_NOWAIT at a
>> preliminary release in February 2008. =A0It was because a user
>> experienced system memory shortage by the bio_alloc() call.
>>
>> Even though nilfs_alloc_seg_bio() repeatedly calls bio_alloc()
>> reducing the number of bio vectors in case of failure, this fallback
>> did not work well.
>>
>> I'm in two minds whether I should change it back to GFP_NOIO.
>> Or should I switch the gfp as follows?
>=20
> As far as I can tell, the only difference with GFP_NOIO and GFP_NOWAI=
T
> here is that the former will trigger the mempool_alloc() page reclaim
> path. But I am not sure I understand why switching to GFP_NOWAIT
> helped with memory shortage. What exactly was the problem there?
>=20
>                                  Pekka

I will confirm the details later.  I cannot dig into the record due to
planned outage at office now.  The version I replaced GFP_NOIO with
GFP_NOWAIT is considerably old.  A true problem might have been in
other places somewhere.

=46or reference, the retry loop in question is as follows.  It is to
allocate bio for log writing.

        bio =3D bio_alloc(GFP_NOWAIT, nr_vecs);
        if (bio =3D=3D NULL) {
                while (!bio && (nr_vecs >>=3D 1))
                       bio =3D bio_alloc(GFP_NOWAIT, nr_vecs);
        }

where nr_vecs is less than or equal to bio_get_nr_vecs(bdev).


Thanks,
Ryusuke Konishi
