Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F31279780;
	Fri,  5 Sep 2025 13:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757078267; cv=none; b=fRj0Ho8jHL2Jv542Mkfr5B/Liz8WskwcBtEFRpsvLr13qyjON87rjT1qmMbRnU+SiHIfHnHbnCQ5TqUHE+gho8aToOygIdWdSbouxyio2+xlPWZuREF1UcnBe74T0zYEPJOXlrPY9uVwlaakM2CBRhmkXYlCS8NJeeAoJSk5NwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757078267; c=relaxed/simple;
	bh=x72jwWF4H/aOwVvuzhj8Ydlc8AiYOYS3TvagtWNuNsg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sGWz20d01nMQADQEW33nRbZxvC35ULTV9v1jUJ0ODGZoGLsIYnu0b9DCoYDyMsDtUAv+J9ImrGfwlsqmWZQsC+JI2KnFdjPuBE4OwJVoKs+z2g0dQ5hk6LfTi4lOm9RB8ZcD572PCLFacJeYMqO999mguodz71u8XfDwqZFnqig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K7qfCKNm; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K7qfCKNm"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-336b071e806so19414331fa.1;
        Fri, 05 Sep 2025 06:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757078264; x=1757683064; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oc8f2nWwsFgS1BPAIMfi6Jzr3Bff83194zVVHmAnwo8=;
        b=K7qfCKNmDq1rGP29axRwB1MHDahpoGHH3BFYzwVisRsbvG0GltgoU8MB4E8gjm0Gm8
         3o+g4G1rlUswEXaJDImDutbgBzmOg4PIr2VBmp57kT/+eS7ySKvAv9MGRETXxg6FjToc
         7dmRCZFOaJvtWQ4pTokZmw3W80VRV0vBnUuFp2DgY3dmMPbAUsVfUo0Z3zamhiIqju3+
         gW6sFfqZbszvAq6hjgCrRD867pn4KA4vCjG9gMcY5iehmB9EeQx5rmvTwjYH29ka8mBe
         vmEjewZDtskgnK5J9aKUU6CnBwFiUKBqEAbF9Ue2zt4Q1kQ8bu2PrfVlubVg54giY4AS
         qFoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757078264; x=1757683064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oc8f2nWwsFgS1BPAIMfi6Jzr3Bff83194zVVHmAnwo8=;
        b=lQ4fkfzn1vvnx+ytk8wqWhrv1TodhANK1Y0NCWdnjJ/Zx6DgkbLrvrWaLJeMWy5bA3
         ed7ND9UC0DkTJEqJ/iQnInTeTuelbYMMIKBEKbE89CvtjoAIDFLb+KsRtywLC6sQCPQs
         fgyacKVphf4UqA0QI8xvW/M7FiaGDcqcxMO89l/jSXEmlc+8HcPvAh4+AL/YzPEl1ni/
         6x1H892kes4aY5EnWtB5DliZOZ7M/S8s9wAMDX1OangOmbYUBmkwZYlT+afyl05SkX5s
         Jzc6AOecl1xQ/DRxuxi9GXFWryLR8uU8aQHEhp2O6oOrilDqawc3+UYYOa5/sEYViXYi
         WhTA==
X-Forwarded-Encrypted: i=1; AJvYcCV0t5nEMCUV8A5C4iDCY3awtRDhdeUaT0lW6KWD9q+h3OcZdR0Y/2F5UDtcdVbdqFWfARn8Pbj8ey+qzl8B@vger.kernel.org, AJvYcCVAfNWymGnbG/gyMPW3reyCI+HloVVVTAFEcVQ3u73ViiM7O8TYxzMKLIif0ExPK1vI1Sy4fl5ijbTRMZ0=@vger.kernel.org, AJvYcCVKXCl7wfB4dysBuHWlkFnSzlJSho7dNz67Z4uUWeIlkM1QQmLqsYqgnlVgrPK3sqPzvly7VhmsSrw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxP3rZ+2wH5M6uNoSaTS3edGq/UETZ6C1r4LmhoKyRoTDuhiQ5S
	dMFcv3lJCAObhLzjw0OvC2xSeCICDMHhm/4gsQSKWVP84D4o4qNe3x2rhu4d+L8NEX0xpN0YsNf
	Y8eF+oFN3tHP+MX2SQmX8n7hfEU1qlGU=
X-Gm-Gg: ASbGnctikJ/A/ai5jzuSfaraebPgQOCV6L/VfSh86B+ID9yuY3m0pYekgz86ALLSInz
	K/A8F1g4BZRpKfRMU4YGZQBFBrOzFH3hWwvwJYSLfFpcF4k0cU8eNBln8DHXhxXe89zyAClaGVa
	3r3RoW9tuf2lrzmP5Wyse/Qa2EYukeNsG/00bqVHNaCCqFa8jyTMjfyLHNv4WjpgWORI1rJKYAB
	S/zfJ3EiBwBs2nrtXwy0xBUhMYxIoBSn8U6DeKy40Y+ycpyaweQ
X-Google-Smtp-Source: AGHT+IEC/BApMqlsYHZkbGMlt/qZevzap7f6MVnsAtSAYRqKkCOV7uWI4ltujHwTzJedGNX4bIln/2ZFSKyvcY2vmJ4=
X-Received: by 2002:a05:651c:b13:b0:337:e8cf:f049 with SMTP id
 38308e7fff4ca-337e8cff1b1mr47189851fa.32.1757078263730; Fri, 05 Sep 2025
 06:17:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250820135043.19048-2-bp@kernel.org> <202509021646.bc78d9ef-lkp@intel.com>
 <20250904113752.GDaLl6ELJRd3LZYBQl@fat_crate.local> <20250904232952.GA875818@ax162>
In-Reply-To: <20250904232952.GA875818@ax162>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 5 Sep 2025 22:17:26 +0900
X-Gm-Features: Ac12FXysML9OmLZRBaPmH0HKfzslDEecbKrddVizojnskVBDLR0KAYFv1WjAUQg
Message-ID: <CAKFNMo=QxweJwTxf-ubYfmBVYBpNEennGLFLRxqhB+evre7zhw@mail.gmail.com>
Subject: Re: [PATCH -v1 1/2] x86/microcode: Add microcode= cmdline parsing
To: Nathan Chancellor <nathan@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, kernel test robot <oliver.sang@intel.com>, Borislav Petkov <bp@kernel.org>, 
	oe-lkp@lists.linux.dev, lkp@intel.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, X86 ML <x86@kernel.org>, 
	"Chang S. Bae" <chang.seok.bae@intel.com>, Sohil Mehta <sohil.mehta@intel.com>, 
	linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 5, 2025 at 8:29=E2=80=AFAM Nathan Chancellor  wrote:
>
> Hi Boris and the Intel folks,
>
> + Ryusuke and linux-nilfs
>
> On Thu, Sep 04, 2025 at 01:37:52PM +0200, Borislav Petkov wrote:
> > On Tue, Sep 02, 2025 at 04:45:12PM +0800, kernel test robot wrote:
...
>   $ cat /sys/fs/nilfs2/features/revision
>   [    6.975426][  T150] CFI failure at kobj_attr_show+0x59/0x80 (target:=
 nilfs_feature_revision_show+0x0/0x30; expected type: 0xed60cafc)
>   [    6.976822][  T150] Oops: invalid opcode: 0000 [#1] KASAN
>   [    6.977407][  T150] CPU: 0 UID: 0 PID: 150 Comm: cat Not tainted 6.1=
7.0-rc2-00016-g894af4a1cde6 #1 NONE
>   [    6.978432][  T150] Hardware name: QEMU Standard PC (i440FX + PIIX, =
1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
>   [    6.979752][  T150] RIP: 0010:kobj_attr_show+0x59/0x80
>   [    6.980321][  T150] Code: 08 00 74 08 4c 89 e7 e8 05 6b d6 fb 4d 8b =
1c 24 4d 85 db 74 1f 4c 89 ff 4c 89 f6 48 89 da 41 ba 04 35 9f 12 45 03 53 =
f1 74 02 <0f> 0b 41 ff d3 0f 1f 00 eb 07 48 c7 c0 fb ff ff ff 5b 41 5c 41 5=
e
>   [    6.982456][  T150] RSP: 0018:ffa0000000e17b28 EFLAGS: 00010216
>   [    6.983163][  T150] RAX: 1ffffffff3753765 RBX: ff11000109eca000 RCX:=
 dffffc0000000000
>   [    6.984012][  T150] RDX: ff11000109eca000 RSI: ffffffff9ba9bb00 RDI:=
 ff11000100b4f250
>   [    6.984900][  T150] RBP: ffa0000000e17b48 R08: ff11000109ecafff R09:=
 ff11000109eca000
>   [    6.985830][  T150] R10: 000000007b3f6fc3 R11: ffffffff9541ea80 R12:=
 ffffffff9ba9bb28
>   [    6.986658][  T150] R13: 1fe2200020fdfe80 R14: ffffffff9ba9bb00 R15:=
 ff11000100b4f250
>   [    6.987542][  T150] FS:  00007f4818d2b740(0000) GS:0000000000000000(=
0000) knlGS:0000000000000000
>   [    6.988508][  T150] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
>   [    6.989241][  T150] CR2: 00007f481899a000 CR3: 0000000109f3b002 CR4:=
 0000000000371eb0
>   [    6.990120][  T150] Call Trace:
>   [    6.990498][  T150]  <TASK>
>   [    6.990867][  T150]  sysfs_kf_seq_show+0x2a6/0x390
>   [    6.991410][  T150]  ? __cfi_kobj_attr_show+0x10/0x10
>   [    6.992015][  T150]  kernfs_seq_show+0x104/0x15b
>   [    6.992542][  T150]  seq_read_iter+0x580/0xe2b
>   [    6.993076][  T150]  kernfs_fop_read_iter+0x137/0x470
>   [    6.993650][  T150]  new_sync_read+0x27e/0x365
>   [    6.994185][  T150]  vfs_read+0x1e8/0x46b
>   [    6.994650][  T150]  ksys_read+0xc2/0x170
>   [    6.995129][  T150]  __x64_sys_read+0x7f/0x90
>   [    6.995631][  T150]  ? entry_SYSCALL_64_after_hwframe+0x6b/0x73
>   [    6.996299][  T150]  x64_sys_call+0x2589/0x2cdb
>   [    6.996843][  T150]  do_syscall_64+0x89/0xfa0
>   [    6.997343][  T150]  ? irqentry_exit+0x33/0x70
>   [    6.997882][  T150]  ? exc_page_fault+0x96/0xe0
>   [    6.998400][  T150]  entry_SYSCALL_64_after_hwframe+0x6b/0x73
>   [    6.999068][  T150] RIP: 0033:0x7f4818dc11ce
>   [    6.999564][  T150] Code: 4d 89 d8 e8 64 be 00 00 4c 8b 5d f8 41 8b =
93 08 03 00 00 59 5e 48 83 f8 fc 74 11 c9 c3 0f 1f 80 00 00 00 00 48 8b 45 =
10 0f 05 <c9> c3 83 e2 39 83 fa 08 75 e7 e8 13 ff ff ff 0f 1f 00 f3 0f 1e f=
a
>   [    7.001627][  T150] RSP: 002b:00007ffc2d325600 EFLAGS: 00000202 ORIG=
_RAX: 0000000000000000
>   [    7.002558][  T150] RAX: ffffffffffffffda RBX: 0000000000040000 RCX:=
 00007f4818dc11ce
>   [    7.003443][  T150] RDX: 0000000000040000 RSI: 00007f481899b000 RDI:=
 0000000000000003
>   [    7.004363][  T150] RBP: 00007ffc2d325610 R08: 0000000000000000 R09:=
 0000000000000000
>   [    7.005260][  T150] R10: 0000000000000000 R11: 0000000000000202 R12:=
 0000000000040000
>   [    7.006143][  T150] R13: 00007f481899b000 R14: 0000000000000003 R15:=
 0000000000000000
>   [    7.007027][  T150]  </TASK>
>   [    7.007411][  T150] Modules linked in:
>   [    7.007994][  T150] ---[ end trace 0000000000000000 ]---
>   [    7.008711][  T150] RIP: 0010:kobj_attr_show+0x59/0x80
>   [    7.009430][  T150] Code: 08 00 74 08 4c 89 e7 e8 05 6b d6 fb 4d 8b =
1c 24 4d 85 db 74 1f 4c 89 ff 4c 89 f6 48 89 da 41 ba 04 35 9f 12 45 03 53 =
f1 74 02 <0f> 0b 41 ff d3 0f 1f 00 eb 07 48 c7 c0 fb ff ff ff 5b 41 5c 41 5=
e
>   [    7.011712][  T150] RSP: 0018:ffa0000000e17b28 EFLAGS: 00010216
>   [    7.012369][  T150] RAX: 1ffffffff3753765 RBX: ff11000109eca000 RCX:=
 dffffc0000000000
>   [    7.013214][  T150] RDX: ff11000109eca000 RSI: ffffffff9ba9bb00 RDI:=
 ff11000100b4f250
>   [    7.014202][  T150] RBP: ffa0000000e17b48 R08: ff11000109ecafff R09:=
 ff11000109eca000
>   [    7.015201][  T150] R10: 000000007b3f6fc3 R11: ffffffff9541ea80 R12:=
 ffffffff9ba9bb28
>   [    7.016202][  T150] R13: 1fe2200020fdfe80 R14: ffffffff9ba9bb00 R15:=
 ff11000100b4f250
>   [    7.017212][  T150] FS:  00007f4818d2b740(0000) GS:0000000000000000(=
0000) knlGS:0000000000000000
>   [    7.018332][  T150] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
>   [    7.019154][  T150] CR2: 00007f481899a000 CR3: 0000000109f3b002 CR4:=
 0000000000371eb0
>   [    7.020147][  T150] Kernel panic - not syncing: Fatal exception
>   [    7.020837][  T150] Kernel Offset: 0x12e00000 from 0xffffffff8100000=
0 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
>
> The fix should be something like the following, which resolves the issue
> for me.
>
>   nilfs_sysfs_init() ->
>     kset_create_and_add() ->
>       kset_create()
>
> has
>
>   kset->kobj.ktype =3D &kset_ktype
>
> which is
>
>   static const struct kobj_type kset_ktype =3D {
>     .sysfs_ops      =3D &kobj_sysfs_ops,
>     .release        =3D kset_release,
>     .get_ownership  =3D kset_get_ownership,
>   };
>
> Note the kobj_sysfs_ops.
>
>   const struct sysfs_ops kobj_sysfs_ops =3D {
>     .show   =3D kobj_attr_show,
>     .store  =3D kobj_attr_store,
>   };
>
> nilfs_feature_attr_group is added to the nilfs_kset->kobj via
> sysfs_create_group(), where the kernfs_ops for each file in
> nilfs_feature_attr_group becomes
>
>   sysfs_create_group() ->
>     internal_create_group() ->
>       create_files() ->
>         sysfs_add_file_mode_ns() ->
>           ops =3D &sysfs_file_kfops_rw;
>           __kernfs_create_file() ->
>             kn->attr.ops =3D ops;
>
>   static const struct kernfs_ops sysfs_file_kfops_rw =3D {
>     .seq_show =3D sysfs_kf_seq_show,
>     .write    =3D sysfs_kf_write,
>   };
>
> sysfs_kf_seq_show() calls kobj_attr_show() via
>
>   const struct sysfs_ops *ops =3D sysfs_file_ops(of->kn);
>   ...
>   count =3D ops->show(kobj, of->kn->priv, buf);
>
> kobj_attr_show() calls one of the nilfs_feature_*_show() functions via
> after casting to 'struct kobj_attribute':
>
>   kattr =3D container_of(attr, struct kobj_attribute, attr);
>   if (kattr->show)
>     ret =3D kattr->show(kobj, kattr, buf);
>
>   struct kobj_attribute {
>     struct attribute attr;
>     ssize_t (*show)(struct kobject *kobj, struct kobj_attribute *attr,
>             char *buf);
>     ssize_t (*store)(struct kobject *kobj, struct kobj_attribute *attr,
>             const char *buf, size_t count);
>   };
>
> So the types of nilfs_feature_*_show() need to match
> kobj_attribute->show() to avoid triggering CFI here.
>
> Cheers,
> Nathan

Thank you very much, Nathan, for sharing your detailed report and
proposing a fix.

I actually performed a reproduction test in an environment with
CONFIG_LTO_CLANG_THIN=3Dy and confirmed that the CFI panic reoccurs, and
that your patch fixes it.

I also followed your analysis of sysfs and concluded that it is
correct and that your changes to the two
nilfs_feature_{revision,README}_show() functions are necessary. I'll
check whether these were necessary from the beginning or whether they
became necessary later.

I'd like to send your proposed fixes upstream, but could you please
send it to me and linux-nilfs in the form of a proper patch? (I'll
need at least your SoB line).

Thank you in advance.

Ryusuke Konishi
