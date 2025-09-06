Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6557217F36;
	Sat,  6 Sep 2025 03:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757130603; cv=none; b=OuMmrMPhUu4R/4yWREml+5hW+G3+gwPWv8L+RVqdwYTYgW8BGvsGLMgB+Z4JhcgLVEmdZML4yMYoCzMOibtOMHMUDEGMHcs9BaE5IYtq+osimYSixKT+JGDDagUhdtdTEoLyZMZ/n3byWqOolH0OY4v/1UzHo6sT0CgYm3p1aQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757130603; c=relaxed/simple;
	bh=DmHeofOFv2vNUo15zHzaeDgoMr+j1v8wbIXWszn8fjk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BIvgU0Vsw4fibtPi62Pq77TPd16G3FlM+ToZ+5YxcvNwEsEE9939DPVjoCwRm2VPxELIgIBSY9ommENDM02Wdtsv7SXw1HBM2cAKI2suxtNsDB/F8WJkcrfKjwXqTH26eHgxc79ZGaZDULc5v0q3HNQJm8enHwlqH03a3CFGZH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vumd4dJK; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vumd4dJK"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-336d3e4df3eso23302501fa.0;
        Fri, 05 Sep 2025 20:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757130600; x=1757735400; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Oo8HVHuI2PqmiKWjB21zsWTxJ4rnJdThwLFkwBUC6w=;
        b=Vumd4dJKsvayRYXT3RbFirUXIzTB//riU5sqd/0KBVSbVi+zLPChgZhNDMI/VeRxrd
         m0rJU97McfL0j8Nl+cGoYB03V1JJVTBP7lhDbNY4nwc0e+M0c/SKNQwKK85UGKSC2gi4
         njQyQb9Vhz6QoXLVqB6gqDVlMGtklmq8u3vkE75OIq88kRBzheUVjTG/WR5JnSVMNVeb
         zlm25DXaiAX5O4VvutyfqStTy3c1q7VOWhfyciKkagx1i8Fb9EvCAs2+cjl7DmFOsFPo
         iPF1skIAZg5XYHdVnKO53ifWUyI3AZ7PvbAEAdZyIpsIlT8giif3I1d4Hvbr8s+/Kvku
         n/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757130600; x=1757735400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Oo8HVHuI2PqmiKWjB21zsWTxJ4rnJdThwLFkwBUC6w=;
        b=ZOPogH+Dv+wBdCaRPkumx71OiqMTXCvsa5dv/zVp11KfHoNs1GonJQ0Nw9lqf1MdUg
         fJPwUw/fvmg8633O58kEPq5JJ3HnTWWWP5AcfoGdR/hy6hsJMpOAafPocA+EnJI2u9RW
         J0JxB+U/ztMWzc6oIXGApuqAkKqQPqEGqKrMkhTMn8jEka17IyZX6aJIWCHDuGwn96So
         kYKkFYdmj0kqR4mog5WECk9AvsHGiYsVeGTWRxpi4abTm7DXK6DSA3FtcugFAVs9B8e+
         QtKBBIaIZyOxs3TpabhEgLmoGg+8Uiar2FXCyw0WR83fYHqg8rNqxiH9BsyeD04j5grP
         oNbg==
X-Forwarded-Encrypted: i=1; AJvYcCVQkbqd8SDBEBcMkTgxB1+vG/cPAesewj/YCeFbMS+B5HJoDF4XWaacGdwMyyPXRvADqplH4yys0ZSRjHCB@vger.kernel.org, AJvYcCVxFEnwCnTINJXZP3Oo5LV5IXJNB7AT6sohV94u59eXm9ShRu+IKcD6mM/zxc026sW6gG3jLyt02bSBjrw=@vger.kernel.org, AJvYcCW5E8HvDSLaqyEw0SFq4jaisbg2CY8LvJXC2CIAdGDGvSdONkCKCDHW0gqFHdTMDm4IKn1BB0LW8Ovasgyr99g=@vger.kernel.org, AJvYcCX1CBpv4Sl8uY0K35/MYV6E+Gx0ipZmvwljqoz3Kg74KDP+DA+MuM5XoSRMDH16TzqcB1FP9e6k@vger.kernel.org
X-Gm-Message-State: AOJu0YyQi8EMc1OIW3no38y2q27OzwY+IohYG0BwF+VF/T98Gvi5CTxH
	i5eRgIxx1cpI0X1c7O32/jAsOIEim7ZDexBsxkSK/E3r1psNk7NVxPxrjF1wKCHs0SRmKcV/YLL
	SiOJuibPt3b01oV2tk33rUQkEbhsMsfOmD+VO
X-Gm-Gg: ASbGncuBMYKuSVPXSmVvb+3NukshEtHPEwnC+sIrEyrogRXI4c1QdtQbeazkv01Hstu
	qGXBFUoOxUJTsWUUqVPSdPk1rxfC7yUQJksDp+VFujSXKM5gm9oG0gvmZpHcUt6Q51Xiohwc+23
	8IfEE/Gq6Y/K+JHOW0/QTu2UOmNxqBm9daoZw2M8xuH+tPvRzzWHaksTFu/p+Ge9nQN+kDWPBMl
	PFyXqv6mPbAg2dcicwVrfbNqmx6HL0VI+Bq5o5IMxJwUkaxhAcP
X-Google-Smtp-Source: AGHT+IGv3mg3LOleQQylXEPOl8dYwHGenSFtPk9Ea+lEqbUL34A0D2Ibt4j4fqLukOPpU1Pw4yNptTi51hIXRCY68wE=
X-Received: by 2002:a2e:be0e:0:b0:337:f57a:6844 with SMTP id
 38308e7fff4ca-33b5a3fdaa8mr2442911fa.43.1757130599548; Fri, 05 Sep 2025
 20:49:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250905-nilfs2-fix-features-cfi-violation-v1-1-b5d35136d813@kernel.org>
In-Reply-To: <20250905-nilfs2-fix-features-cfi-violation-v1-1-b5d35136d813@kernel.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sat, 6 Sep 2025 12:49:43 +0900
X-Gm-Features: Ac12FXz41hyPQuTqHh8UYKbYNa8YEVObnzXSy-4dOBDFQvzoMzz00zjhhbK6qZ8
Message-ID: <CAKFNMo=yfPPn0bc+vGv4f3yhyOQy33+ZHJJGURyY9NaHaRtToQ@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: fix CFI failure when accessing /sys/fs/nilfs2/features/*
To: Nathan Chancellor <nathan@kernel.org>
Cc: Kees Cook <kees@kernel.org>, linux-nilfs@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 6, 2025 at 4:24=E2=80=AFAM Nathan Chancellor wrote:
>
> When accessing one of the files under /sys/fs/nilfs2/features when
> CONFIG_CFI_CLANG is enabled, there is a CFI violation:
>
>   CFI failure at kobj_attr_show+0x59/0x80 (target: nilfs_feature_revision=
_show+0x0/0x30; expected type: 0xfc392c4d)
>   ...
>   Call Trace:
>    <TASK>
>    sysfs_kf_seq_show+0x2a6/0x390
>    ? __cfi_kobj_attr_show+0x10/0x10
>    kernfs_seq_show+0x104/0x15b
>    seq_read_iter+0x580/0xe2b
>   ...
>
> When the kobject of the kset for /sys/fs/nilfs2 is initialized, its
> ktype is set to kset_ktype, which has a ->sysfs_ops of kobj_sysfs_ops.
> When nilfs_feature_attr_group is added to that kobject via
> sysfs_create_group(), the kernfs_ops of each files is
> sysfs_file_kfops_rw, which will call sysfs_kf_seq_show() when
> ->seq_show() is called. sysfs_kf_seq_show() in turn calls
> kobj_attr_show() through ->sysfs_ops->show(). kobj_attr_show() casts the
> provided attribute out to a 'struct kobj_attribute' via container_of()
> and calls ->show(), resulting in the CFI violation since neither
> nilfs_feature_revision_show() nor nilfs_feature_README_show() match the
> prototype of ->show() in 'struct kobj_attribute'.
>
> Resolve the CFI violation by adjusting the second parameter in
> nilfs_feature_{revision,README}_show() from 'struct attribute' to
> 'struct kobj_attribute' to match the expected prototype.
>
> Cc: stable@vger.kernel.org
> Fixes: aebe17f68444 ("nilfs2: add /sys/fs/nilfs2/features group")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202509021646.bc78d9ef-lkp@intel.co=
m/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks again!
I'll send this upstream.

Regards,
Ryusuke Konishi
