Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F9027E05E
	for <linux-nilfs@vger.kernel.org>; Wed, 29 Apr 2026 01:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777427439; cv=pass; b=NJvQEjtVjCW2hyAugKa6HgJSVOTgRmItvbpKbAYQEH0dG88nm8n44vVI1CFgw2o7MyPi+NFEq7HsiBeoYJoraVV+6dbrNrVtipTydB3W9vSak5CFwMG2+NY1bM2Yjvi4zQNi8Sc+Rz7T2zkQtuAKAxvQMKw9Rczyp/zqIdn4Qt8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777427439; c=relaxed/simple;
	bh=RovvnJx/rHA+rYUiXhErodRiEzMSWZH4M4wPnxwaP1M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lZiOXV6+RZW4xjpZFS4Xsv60gg7QGEpxJQYvFhQLAiwirdFSwxVqr3wXkUkpU3Cy8kGxr2xnY43b8K8yahs682+aan3RQYGgM2ETown6ixu8qaJUug7bn64mLJXiM3IoPymjKLBEHv2HqouEKdfJbYeDRqP/xiWLVE2IWX74nqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FEzclcC+; arc=pass smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FEzclcC+"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-7b6ae2ea4a1so121982307b3.2
        for <linux-nilfs@vger.kernel.org>; Tue, 28 Apr 2026 18:50:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777427437; cv=none;
        d=google.com; s=arc-20240605;
        b=Gni8J6vWsN9uC4MMcn483RCcJ7gv0rAiyOe7drdFD/O0N2QMlZGsgGPt9c2W61wfyt
         sjq7T52oXD3XR+EfUreC2KhWnGRsWVe6wfqF8rZXT/WJeWn5T4abfXDjF+3J85B0j8zB
         vON84qC6i2J7YMHDhqQXND97xBL0MTtkaBhw057wL8XRD4Y2pOmy1dTG5d7WfPwpy1sy
         Mowmuv5YAGDRjXUfD9HwjKw3v1fIUQFBEFGonceIruX9Q2UCUJLPWyejeurgpD37Ut/X
         jokv7JtY0OKJZpjC/V+3rtgn+RNViKFtrkCFhyRsEZ403SeROtAPxM0NGF0Aql/14Uif
         E1BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cz84zpK7KV8JPVJGMFZ3f68DYLqACBdBPcpiRSD2C1Q=;
        fh=JTre/rccRIg5nVbpx5WyOpnqdMR6rS/7r1GD9xVj6GA=;
        b=QGXh7XVJJlafjIUbRR7Hh9eqlBZlzgWQLgR+8kEObTwHB/2iuIWsAPplYdxe2LCte9
         1Cv2ZQjlPhHfFCQT29SG7bI4A7vytW8WCIA0mf7a70CfgqJa/Xh/+UEXF/Qlt/v3L+rw
         9WZWAFg1Ds8mmQzQCBwbMnOo8eQ1XoF94GWtYJ+ARLf6tbxtcVVbvyficj5doLp62lLw
         pFkSWH/zlTrLKtJ6NcaRmLsgoVGzmmptpUnedI6IR262qDRggz93HFIUECFY43/oy1hs
         JX15Tifb9xzsa/s1c1vd6qwAcP7wYGASXrUz/tJlvbKmNue/7STQaBDo2O4KFa2fV+Ia
         6S7A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777427437; x=1778032237; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cz84zpK7KV8JPVJGMFZ3f68DYLqACBdBPcpiRSD2C1Q=;
        b=FEzclcC+R3usGd/rgrVxGXMwc8yTeo/MZwXWDAgj2RZL6adlhv5vQjqwSsdYRJX3yT
         A1CHBKfclCzctW9iBhQf6ucAfzAmZ1Aq+wItsnLPNUwceY+AlLu3U1hi8zp0UTnyiuad
         d3X2L9q32+jsyPUxkaPO5VLaKeax4cG+gURkwaCBpQrxFpfgjmcv3MCJV8NW3grdv5bK
         61tuKXzGUNFlsm4jA3x7wXKHlUGAjg4WSJtrvxYnyZXz2Z1fbjWfcq4zJMQ+LUeRAmvi
         K0OTneo5Z4WrNBIXT2OjxeKtCnmnajpbG7WhalE9DYA+j+g/GzC0eGnjL2z/GM88/u4y
         nspQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777427437; x=1778032237;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cz84zpK7KV8JPVJGMFZ3f68DYLqACBdBPcpiRSD2C1Q=;
        b=iOSUT3P3j7Pfmam/shLEt/6HCm8GeO24Ah6weygoNjQbOTGuQOIsm9CCTTTyTHqdPU
         mx7iYM7uNNNxO/AlalvBTFEYjWiCpdBZ6bQO6X5MmoiP2wBJZZfa5WRYKSo7/a+fd7Hj
         nvnvCCIGqy2N51tWLODqAmHPHwA/2WP6MgYLG9vVU3GsxEPyc89ap+HtV2mzF8dCexXp
         grYUN4pHFHbgcF/LylgHau7Cshaknq+s4m5Km+t45Y+ubCU2PeNgFsT/i6ZmRtSAITKm
         Wqsl3JcuXkk9Rbd+Pc4NHHkeRe9NKdo16ARd57F5Ojk29VK7CJqzbDkN0CunilB0vQZn
         jTIQ==
X-Forwarded-Encrypted: i=1; AFNElJ/5IfoeNMPTzg5Pn6EqCct1WUL6+Y6aU8pyJ1cQ9SEuMDGSrtvv1QTLXPVbc5O11CgJr0nLPu2LZPEqow==@vger.kernel.org
X-Gm-Message-State: AOJu0YzCXTyTv+T5jagkjARDE1SMefDdxq+6K+2mVG2jEqg1cYCWg5cU
	xwlclugC3gQ86N8dSIB8w4RZEhOQm5g8Q2Gn8nJjJB0Hmyy/8ZgoWe0bwJvKD+9UeNLh+hwFe43
	UesTBccgSrxbC3pK0rXnih69HNQ+ysllULo56
X-Gm-Gg: AeBDiescRzjEvaHrKPJFbTNe5Krn2yJmL1dsFrxrjEH7p/3zNwq9V2xShv7+h7/ODW6
	S3TCRvN7vO+I0dTAkdJdj88bNuPX82sP34MNHl+y1tK//q5DiHZBoNLRC2+IMoe+tlfSx4e9tLk
	rksVZJFnnFtfWBJnukOxLdkFsFcf3FAMIwG5EIuG0yjOVJAbvXt3hcm5ani8HJqCZrB7a90XqVw
	rcxlpjTIi1yKbPFWkFb/eJ+vKFvKdj+MEQbX/BCJKj3k3MkZ5+d4EasOIhULKemcToZMS9HzEPN
	bDDeUyhrVZhF0DhOIYVbV9Ohbh+UzBp7z69lSC6bYFYpPSZs392gXSyYNqMuoxClmrp1iEO4NRK
	3eeCfAE5VKj7dnmTguw==
X-Received: by 2002:a05:690c:660c:b0:7b3:9f53:9374 with SMTP id
 00721157ae682-7bd1d378604mr21926847b3.3.1777427436793; Tue, 28 Apr 2026
 18:50:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428040256.84403-1-kartikey406@gmail.com> <2ed28b6008cf898a06036d5836380cc5cc45f118.camel@redhat.com>
In-Reply-To: <2ed28b6008cf898a06036d5836380cc5cc45f118.camel@redhat.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Wed, 29 Apr 2026 07:20:25 +0530
X-Gm-Features: AVHnY4KGGPhg3lC8gqKYT_DO-f8y7Ux9ZoUiN0MwMht12ZmxaqedNKfjjHVz_Cw
Message-ID: <CADhLXY5Q8UsSQZYm-KWpJ3q753xAcxbnk9y+vGfkwA9RF8VcrQ@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: reject CLEAN_SEGMENTS ioctl with out-of-range
 segment numbers
To: Viacheslav Dubeyko <vdubeyko@redhat.com>
Cc: konishi.ryusuke@gmail.com, slava@dubeyko.com, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 29, 2026 at 12:29=E2=80=AFAM Viacheslav Dubeyko <vdubeyko@redha=
t.com> wrote:
>
> On Tue, 2026-04-28 at 09:32 +0530, Deepanshu Kartikey wrote:
> > Syzbot reported a hung task in nilfs_transaction_begin() where multiple
> > tasks performing chmod() on a nilfs2 mount blocked for over 143 seconds
> > waiting to acquire ns_segctor_sem for read:
> >
> >   INFO: task syz.0.17:5918 blocked for more than 143 seconds.
> >   Call Trace:
> >    schedule+0x164/0x360
> >    rwsem_down_read_slowpath+0x6d9/0x940
> >    down_read+0x99/0x2e0
> >    nilfs_transaction_begin+0x364/0x710 fs/nilfs2/segment.c:221
> >    nilfs_setattr+0x124/0x2c0 fs/nilfs2/inode.c:921
> >    notify_change+0xc1a/0xf40
> >    chmod_common+0x273/0x4a0
> >    do_fchmodat+0x12d/0x230
> >
> > The writer holding ns_segctor_sem was a concurrent NILFS_IOCTL_CLEAN_SE=
GMENTS
> > caller, stuck inside printk while emitting per-element warnings from
> > nilfs_sufile_updatev():
> >
> >    __nilfs_msg+0x373/0x450 fs/nilfs2/super.c:78
> >    nilfs_sufile_updatev+0x21c/0x6d0 fs/nilfs2/sufile.c:186
> >    nilfs_sufile_freev fs/nilfs2/sufile.h:93 [inline]
> >    nilfs_free_segments fs/nilfs2/segment.c:1140 [inline]
> >    nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1261 [inline]
> >    nilfs_segctor_do_construct+0x1f55/0x76c0
> >    nilfs_clean_segments+0x3bd/0xa50
> >    nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:922 [inline]
> >    nilfs_ioctl+0x261f/0x2780
> >
> > The root cause is that nilfs_ioctl_clean_segments() does not validate
> > the user-supplied segment numbers in kbufs[4] before calling
> > nilfs_clean_segments(), which acquires ns_segctor_sem for write.  The
> > range check on each segnum is performed deep inside the call chain by
> > nilfs_sufile_updatev(), which emits a nilfs_warn() per invalid entry
> > while still under the segctor lock and the sufile mi_sem.  Under load
> > (repeated invocations across multiple mounts saturating the global
> > printk path), the cumulative printk latency keeps ns_segctor_sem held
> > long enough to trip the hung_task watchdog, blocking concurrent
> > operations such as chmod() that need ns_segctor_sem for read.
> >
> > Fix by validating the contents of kbufs[4] in the ioctl entry path,
> > before any FS-wide lock is acquired.  Out-of-range segment numbers are
> > rejected with -EINVAL synchronously, with no work performed under
> > ns_segctor_sem.
> >
> > Reported-by: syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3D62f0f99d2f2bb8e3bbd7
> > Fixes: 4f6b828837b4 ("nilfs2: fix lock order reversal in nilfs_clean_se=
gments ioctl")
> > Tested-by: syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
> > Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> > ---
> >  fs/nilfs2/ioctl.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> >
> > diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> > index e0a606643e87..38822dce1839 100644
> > --- a/fs/nilfs2/ioctl.c
> > +++ b/fs/nilfs2/ioctl.c
> > @@ -846,6 +846,7 @@ static int nilfs_ioctl_clean_segments(struct inode =
*inode, struct file *filp,
> >       struct the_nilfs *nilfs;
> >       size_t len, nsegs;
> >       int n, ret;
> > +     size_t i;
>
> What about re-using the n variable? Does it make sense to introduce new o=
ne?
>
> >
> >       if (!capable(CAP_SYS_ADMIN))
> >               return -EPERM;
> > @@ -876,6 +877,21 @@ static int nilfs_ioctl_clean_segments(struct inode=
 *inode, struct file *filp,
> >       }
> >       nilfs =3D inode->i_sb->s_fs_info;
> >
> > +     /*
> > +      * Validate segment numbers against the filesystem's segment coun=
t
> > +      * before entering nilfs_clean_segments(), which acquires
> > +      * ns_segctor_sem for write.  Catching invalid segnums here avoid=
s
> > +      * holding that lock while emitting per-element diagnostics under
> > +      * the segment constructor.
> > +      */
> > +     for (i =3D 0; i < nsegs; i++) {
> > +             if (((__u64 *)kbufs[4])[i] >=3D nilfs->ns_nsegments) {
> > +                     ret =3D -EINVAL;
> > +                     kfree(kbufs[4]);
> > +                     goto out;
>
> Are you sure that you need to free buffer here and go to out? Maybe, we c=
an
> introduce another label and to jump to kfree(kbufs[4]) at the end of meth=
od?
>
> Thanks,
> Slava.
>
> > +             }
> > +     }
> > +
> >       for (n =3D 0; n < 4; n++) {
> >               ret =3D -EINVAL;
> >               if (argv[n].v_size !=3D argsz[n])
>

Thanks for the feedback. I have sent patch v2.

Thanks

Deepanshu Kartikey
