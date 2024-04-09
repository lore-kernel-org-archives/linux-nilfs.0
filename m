Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BDF4436
	for <linux-nilfs@vger.kernel.org>; Tue,  9 Apr 2024 20:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712693893; cv=none; b=uC4XB2cr0zJF345/zY0EyAIpS6u152UqkpOIeBcOny4xLcsT5tc+aVrHJFDKZ2PNr2lENtCsJzuol6LfBRn6P1dSJLr6hKWUE74k0Tr63OEMFhONp/XnFL4+6llQlEuIvsRPRtkYpAN9feDDvgc1YBYWLi6RmJ3emwyTQYSgKWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712693893; c=relaxed/simple;
	bh=MilSHwA9eLJOIpALvChlaOZzB+7W2H6p6eSIBcTOfjE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YLAF4y0878poTOKxqs13SM3s4SFV0al2viKV7XzEX4EjovhziGWsVbN/1zUcfZBmYFcy8C6BYkJaSRFGoqWi/x/L4fiKO51ZDuXfqDy6qsaUJ8yfCPi3f7AqyHSx2jn8ml6XL2M8JcRFWdC3X44c00BySVelwgkvKYitpDUcSI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bVEvEtGV; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bVEvEtGV"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-516d3776334so6294242e87.1
        for <linux-nilfs@vger.kernel.org>; Tue, 09 Apr 2024 13:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712693890; x=1713298690; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RCGgNxKfPw/+PRmFLN5oQ+8pc4EW8ccQ6w6fTTqvlrk=;
        b=bVEvEtGV8GJlT65oeNa1ruNLw/lVx/hb7fSdjUO3E+81xx3nPtoPlTkGaRyQ1Rw8Xz
         tRukTjo8o6tgprBNJpTdF86G8bJSidx2ILqbU5QWRfcGjaJmh/QZK+jckw/NWuhX4FTi
         VHycaHVHfQE371Q2SrM+5u7OUL+iz1nKrmWPrMI4DnpdbGWe6BCwccq4T5vuXDBpMK9N
         cm2xEfsODIX5ER6Y6Q+gCE/qHeyq7mooFUglCW8XjnVRxFSNb3jZ4cSEi69L+iolUmz1
         4GbjBp7TcoLeNWXKsjh8S20VGIRDaiAI+O8a+3dpfh+uhrW8mZWz5gYgnJGc8/HkqRvY
         F7KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712693890; x=1713298690;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RCGgNxKfPw/+PRmFLN5oQ+8pc4EW8ccQ6w6fTTqvlrk=;
        b=lXULJ1wPzJG7OXiZRK+/2Q+G4toSY3c1K4nSrS4BGAiDJjbkDbUTpac6pkZEH+Bo8L
         sMOupguo+pJocX92CNVIctsLgblq9H1X3ZCLc1bnAIGq1xxK0nex2Oj1tdaNiLENg3+M
         0ZG4gHv+AM0m8X5Y3fyKB9gux0Di6OVpFRkCLqoPjx0EBa3Uxdaia6pHqEwT58lMCvE8
         pOQn1DEtIqAet+00PKuOOFJPELL1Cgwg4g8Wcy1HrxXbssZbuQ9w+Rct7NYpvC3++BVa
         Cu/WLuVByKntIkm6sIdHsfVZF20ziBnRPAMuU3q/1ZOLLXNRRer+qyrz3VjX1xgwkvzZ
         0Jsw==
X-Gm-Message-State: AOJu0YwL51HiHJY4F8M71GfGyu80QCxmm2ZQVDXLmOtRU/xMk3Z2FxEU
	KZOK2vi+nT+iCzodc2Jusr/pxg3CWdYVZkC8GXqYT1xt79GPu051YEtsvyQ93BDL5NlCwS/orJK
	Xm4EDCRy/vzDeXZgq2hqb/oEy5k7QqV6iK4k=
X-Google-Smtp-Source: AGHT+IFxlqEDrVe+O+6CS0sMDQVnVLwzEvrWoOed7K+8REcRERmtuxW7GlMI7ycAxvt81XcQHPQkPNPDFElfj9osUrI=
X-Received: by 2002:ac2:4d03:0:b0:516:ce9a:fb73 with SMTP id
 r3-20020ac24d03000000b00516ce9afb73mr343425lfi.43.1712693889279; Tue, 09 Apr
 2024 13:18:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e282e150-2bc1-4b6a-8aa1-0417371c2671@redhat.com>
 <CAKFNMo=bbdBsW2xvTMiZcrD37n8MWmDfhH7V2jKZ14=odduRXg@mail.gmail.com>
 <f99b0c44-c5b4-4e0b-892b-dd9793a80f9a@redhat.com> <CAKFNMokYkO-WsvrcZh=-FpR=LtCQnsyxET3ZjSzx-o5zXcMU9g@mail.gmail.com>
 <2fd47dc7-e130-4c67-b39a-b1c38aa1c500@redhat.com> <0d26ef52-91bd-4108-bf09-5d92fa58cd28@redhat.com>
 <1ba497be-64cb-4a4d-99a8-16707da32cc4@redhat.com> <CAKFNMo=zu38X+SYDgyP=g4aD9E1ee209C7FqvF9_cj1vxZgjuQ@mail.gmail.com>
 <10925ebc-4e91-48b5-8a99-287fbc8248fc@redhat.com>
In-Reply-To: <10925ebc-4e91-48b5-8a99-287fbc8248fc@redhat.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 10 Apr 2024 05:17:52 +0900
Message-ID: <CAKFNMonE8W=yJuf7wEcGsmd65Nz9teiE=sX0d2XZa_Sc1aou0Q@mail.gmail.com>
Subject: Re: [PATCH V2] nilfs2: convert to use the new mount API
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

In this email, I will reply regarding style issues.

On Sat, Apr 6, 2024 at 12:04=E2=80=AFAM Eric Sandeen wrote:
>
> On 4/5/24 5:33 AM, Ryusuke Konishi wrote:
> > On Fri, Apr 5, 2024 at 12:00=E2=80=AFPM Eric Sandeen wrote:
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> V2: Fix call to nilfs2_reconfigure() in nilfs_mount() to ensure
> >> fc->root is set.
> >>
> >> Clean up some extraneous comments and whitespace
> >>
> >> This one passes your current test script.
> >>
> >> Thanks,
> >> -Eric
> >
> > Yeah, this v2 patch resolved the panic issue.  It passed the test
> > script in multiple environments, as well as my manual checks for mount
> > options with and without using the constant table.  Seems to be
> > working perfectly so far.
>
> great!
>
> > I'll get started on the full review, but I'd like to provide feedback
> > on style warnings detected by the checkpatch script at this point.
>
> > ---
> > WARNING: Missing commit description - Add an appropriate one
>
> Not a lot to say; I can note 'interesting' things about the conversion
> if that'd be helpful.
>

It's OK if you include a commit log with the patch that you think is
the final version.
I also don't think a long explanation is necessary for this, but I'll
leave it to you.

> > WARNING: function definition argument 'struct super_block *' should
> > also have an identifier name
> > #146: FILE: fs/nilfs2/nilfs.h:338:
> > +extern int nilfs_store_magic(struct super_block *,
>
> As you say this is pre-existing; I can change it if you like, I was just
> following current style.
>
> > WARNING: function definition argument 'struct nilfs_super_block *'
> > should also have an identifier name
> > #146: FILE: fs/nilfs2/nilfs.h:338:
> > +extern int nilfs_store_magic(struct super_block *,
>
> same

When modifying declarations, I take the opportunity to add missing
identifier names to their arguments and delete "extern" specifiers to
eliminate checkpatch warnings, so I would appreciate it if you could
correct it as shown below.

   int nilfs_store_magic(struct super_block *sb, struct nilfs_super_block *=
sbp);

>
> > WARNING: space prohibited between function name and open parenthesis '(=
'
> > #220: FILE: fs/nilfs2/super.c:721:
> > + fsparam_enum ("errors", Opt_err, nilfs_param_err),
>
> This seems to be the pattern for every filesystem using these calls ...

Yes, I think it looks better now, please ignore these warnings.

>
> > WARNING: space prohibited between function name and open parenthesis '(=
'
> > #221: FILE: fs/nilfs2/super.c:722:
> > + fsparam_flag_no ("barrier", Opt_barrier),
> >
> > WARNING: space prohibited between function name and open parenthesis '(=
'
> > #223: FILE: fs/nilfs2/super.c:724:
> > + fsparam_string ("order", Opt_order),
> >
> > WARNING: space prohibited between function name and open parenthesis '(=
'
> > #224: FILE: fs/nilfs2/super.c:725:
> > + fsparam_flag ("norecovery", Opt_norecovery),
> >
> > WARNING: space prohibited between function name and open parenthesis '(=
'
> > #225: FILE: fs/nilfs2/super.c:726:
> > + fsparam_flag_no ("discard", Opt_discard),
> >
> > WARNING: Missing a blank line after declarations
> > #317: FILE: fs/nilfs2/super.c:770:
> > + struct super_block *sb =3D fc->root->d_sb;
> > + nilfs_err(sb,
>
> easy enough to fix.
>
> > WARNING: quoted string split across lines
> > #576: FILE: fs/nilfs2/super.c:1193:
> > + nilfs_err(s, "invalid option \"cn=3D%llu\", "
> > + "read-only option is not specified",
>
> Just let me know your preference on long strings like this (out-dent?
> go past col 80? leave it alone?)

Nowadays, when adding a new message or modifying an existing message,
I prioritize its searchability and allow past col 80 only for message
strings.
(I used to split messages to adhere to the 80 characters constraint. )

So, if you don't mind, please fix this checkpatch warning.

>
> I'll wait for more review before I send a minor update just for these.
> (or, if you prefer, feel free to tweak small things on your end.)
>
> thanks,
> -Eric
>
> > total: 0 errors, 10 warnings, 563 lines checked
> > ---
> >
> > Of these, the warning for the function declaration of
> > nilfs_store_magic() is an existing issue, so it can be left as is.
> >
> > Also, I feel like the warnings for fsparam_{enum,flag,flag_no,string}
> > can be ignored for the sake of appearance.  (I will not omit them here
> > so as not to make any preconceptions).
> >
> > Thanks,
> > Ryusuke Konishi
> >
>
