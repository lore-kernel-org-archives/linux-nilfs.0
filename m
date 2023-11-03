Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C55C4332F
	for <linux-nilfs@archiver.kernel.org>; Fri,  3 Nov 2023 17:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbjKCR5y (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Fri, 3 Nov 2023 13:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjKCR5x (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Fri, 3 Nov 2023 13:57:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE09DD76
        for <linux-nilfs@vger.kernel.org>; Fri,  3 Nov 2023 10:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699034216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QNA+l67MoVWS7ypovgLkbj2YKf092k4D0KUV2U937nY=;
        b=gi2lf5dHXs28nYc/lWhYGvs9YZwR9q2y17aQLJZwu88NUoVKGIdb2x/sn+1nZwbfWBJuzv
        Xl/3S7GoUV+ZnxzC1VqSvO3zLZl/5chQm9yJoTSiMbW1F1ryEsvrzOMi9hc3Ub0UW0L2L/
        E9iHWKZGHwM/Dpc8mW7b52H7l6Z4nlM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-Sr8lOo72PSCR9Xv1nawBnQ-1; Fri, 03 Nov 2023 13:56:52 -0400
X-MC-Unique: Sr8lOo72PSCR9Xv1nawBnQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9c167384046so36726866b.0
        for <linux-nilfs@vger.kernel.org>; Fri, 03 Nov 2023 10:56:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699034211; x=1699639011;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QNA+l67MoVWS7ypovgLkbj2YKf092k4D0KUV2U937nY=;
        b=nHsU103g+P0SWvwhQ5P2xB8NTank4kjA3S5gWRCGkA8/9C9rNE6tLxi953Xg9D57ch
         1+igYh2a+Y7KXGYVJ9qk/lDQJJFmIYyTt01VPO/CK2RGfxlvFs9LwsNnc+Un7F60B8WI
         zqDPG4qUSSpj7R6vV3NeB7uFUWZDUXFMlYlv4T1tSNgZq9sucLvUw6+94uta09OoPepD
         owOhrjw2RS8hynd0SUDZQm0DDK6OO2iiKf1GzRlrG64bY/P0JIgXG42Xq6Qz3zKJHMn/
         jnATTIfk5DwotemNCx5scatzcPDfuwao0abAunFR2Rk7gYFCMUq8mrF/LiB1wJivbfcM
         1rkg==
X-Gm-Message-State: AOJu0YyytkPRG8fLb9WqNWtsAP9BSjEj+47eTppF+o0wNavh2kAm7LRy
        l19jcXYSXFWoVoEkG8Osi43R1xGeT7koiETZs/pBvrLGCYsHDTbeICb61YDnMlGAczOYW4uw2Fy
        yLzKe7mn0dEd8V8Fw8HwremQ=
X-Received: by 2002:a17:907:2d8c:b0:9cb:798f:91e8 with SMTP id gt12-20020a1709072d8c00b009cb798f91e8mr17329267ejc.6.1699034211254;
        Fri, 03 Nov 2023 10:56:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFj3vkbGmPpckSaE6mrMUhLK8LvUlwALiiWNoGPaTKQmCcqHXM/6/sDT4acWiauny2WdVyHAQ==
X-Received: by 2002:a17:907:2d8c:b0:9cb:798f:91e8 with SMTP id gt12-20020a1709072d8c00b009cb798f91e8mr17329255ejc.6.1699034210885;
        Fri, 03 Nov 2023 10:56:50 -0700 (PDT)
Received: from pstanner-thinkpadt14sgen1.remote.csb ([2001:9e8:32d1:5200:227b:d2ff:fe26:2a7a])
        by smtp.gmail.com with ESMTPSA id m21-20020a1709066d1500b009b9aa8fffdasm1129657ejr.131.2023.11.03.10.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Nov 2023 10:56:50 -0700 (PDT)
Message-ID: <437ec6fa34af1ccfadee2d62770e52d99ebf75c3.camel@redhat.com>
Subject: Re: [PATCH] fs/nilfs2: copy userspace-array safely
From:   Philipp Stanner <pstanner@redhat.com>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Date:   Fri, 03 Nov 2023 18:56:49 +0100
In-Reply-To: <CAKFNMok9WTV5uX3BBfr8eYiuJXvUY6TuYW=tQYvBzdCUYsxcwA@mail.gmail.com>
References: <20231102183751.47413-1-pstanner@redhat.com>
         <CAKFNMok9WTV5uX3BBfr8eYiuJXvUY6TuYW=tQYvBzdCUYsxcwA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

On Sat, 2023-11-04 at 02:44 +0900, Ryusuke Konishi wrote:
> On Fri, Nov 3, 2023 at 3:38=E2=80=AFAM Philipp Stanner wrote:
> >=20
> > ioctl.c utilizes memdup_user() to copy a userspace array. This is
> > done
> > without an overflow-check.
> >=20
> > Use the new wrapper memdup_array_user() to copy the array more
> > safely.
> >=20
> > Suggested-by: Dave Airlie <airlied@redhat.com>
> > Signed-off-by: Philipp Stanner <pstanner@redhat.com>
> > ---
> > Linus recently merged this new wrapper for Kernel v6.7
>=20
> The following overflow check is performed just before the usage of
> memdup_user():
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (nsegs > UINT_MAX / sizeof(=
__u64))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 goto out;
>=20
> This was introduced by commit 1ecd3c7ea76488 ("nilfs2: avoid
> overflowing segment numbers in nilfs_ioctl_clean_segments()") to
> avoid
> overflowing nsegs * sizeof(__u64) in the subsequent call to
> memdup_user().
>=20
> I learned about memdup_array_user() this time, and it seems to check
> for overflow when multiplying two size_t arguments (i.e. the number
> of
> elements and size of the array to be copied).
>=20
> Since size_t is 32-bit or 64-bit depending on the architecture, I
> think the overflow check that memdup_array_user() does
> is included in the above upper limit check by UINT_MAX.
>=20
> So, for security reasons, I don't think this change is necessary.=C2=A0
> (Am
> I missing something?)

No, I think you are right. My commit message was very generic =E2=80=93 it'=
s
more about unifying array-duplication.
I should rephrase it.

>=20
> In terms of cleanup, I think the clarification this patch brings is
> good, but in that case, I'm concerned about the duplication of
> overflow checks.

Alright, so would you prefer a patch that uses memdup_array_user() and,
consequently, removes the preceding check?

Regards,
P.

>=20
> Thanks,
> Ryusuke Konishi
>=20
> > ---
> > =C2=A0fs/nilfs2/ioctl.c | 8 ++++----
> > =C2=A01 file changed, 4 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> > index 40ffade49f38..6a9dceebb18d 100644
> > --- a/fs/nilfs2/ioctl.c
> > +++ b/fs/nilfs2/ioctl.c
> > @@ -877,11 +877,11 @@ static int nilfs_ioctl_clean_segments(struct
> > inode *inode, struct file *filp,
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * argv[4] points to se=
gment numbers this ioctl cleans.=C2=A0 We
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * use kmalloc() for its buf=
fer because memory used for the
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * segment numbers is enough=
 small.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * use kmalloc() for its buf=
fer because the memory used for
> > the
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * segment numbers is small =
enough.
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kbufs[4] =3D memdup_user((void __=
user *)(unsigned
> > long)argv[4].v_base,
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nsegs * sizeof(__u64));
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kbufs[4] =3D memdup_array_user((v=
oid __user *)(unsigned
> > long)argv[4].v_base,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nsegs, s=
izeof(__u64));
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (IS_ERR(kbufs[4])) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ret =3D PTR_ERR(kbufs[4]);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 goto out;
> > --
> > 2.41.0
> >=20
>=20

