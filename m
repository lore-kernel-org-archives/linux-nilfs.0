Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC6B2C08BC
	for <linux-nilfs@vger.kernel.org>; Wed,  5 Nov 2025 06:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762325091; cv=none; b=RQzvi/5HzJZzZs5Tdk9L14wcbUx21TpBwFGuaqntd6FkE5LYyS0Hd08o2Ac0pcNapCHxnhzCw+GIKO6hnm3XA3SfS1B1wMYkuCgg8d/Kxm8XwDY307fWbahYTEWXImx/nZc15cRiC5hAAaYAQoM5cdS7ucBGaqsh/3hRDShNHck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762325091; c=relaxed/simple;
	bh=lY3vPl04ZAKMtCRjX+ENRrC2aboYJ9X17xqXbfIYB8E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pwRYYXRv0GJIMaBV1PT5eNTzMyi7NKxirAk+CJ8ONJGjYnhtyV3/068ktySl3TwVShwWvCkHIPFkPVuUVb2tSAQQaoAIDrOkEyno7bRsCbymGZrBaunZoqfh2HYGOmnOOv0pAV8iiUset5fNRKPBxfjgjv+u1qGLS3APrhvrDeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lwSaT46B; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lwSaT46B"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-59431cce798so2707652e87.1
        for <linux-nilfs@vger.kernel.org>; Tue, 04 Nov 2025 22:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762325086; x=1762929886; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lY3vPl04ZAKMtCRjX+ENRrC2aboYJ9X17xqXbfIYB8E=;
        b=lwSaT46B5g/VGTD5weD71e84PazG+6S7vsKMBCo3Tppo+5nj+V6Cf2aD5wHEppsKH/
         NxaegJzaa6UD+K0KEMyRUvhnubjhK0nmj+GOCD7PcJ3dHPCaQLdYOq1ivl+ICY1HMuLk
         eSfrJ87CX90l217wO5d02JOdM2KozpFu0rCZrpOb/PbKvpP/SMG/ib3rBNWuPaBHM/YP
         ETPUvu4BF55xYFBHmkh4yEGXhekEjnF0lS3Hiv1CnSGGOcTLb+LFXBrcNXAt8Tdi0UHS
         3mX0oWbQ5rsS2Y37V3+b6Oo8cOAzFK3GiAcQqfpm6+PtmUjwRTw6MA+0RUd8Y2+kHYfT
         vCGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762325086; x=1762929886;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lY3vPl04ZAKMtCRjX+ENRrC2aboYJ9X17xqXbfIYB8E=;
        b=dzcjZtUBEP2XcoTx7VtsBAsdch5oO/6MRr9S70E6GSsWO5PpQIVVHypeb6BjfQP8H3
         AwkcF3pGnjbcaphfa8KK40HrFgaBQm7Vk2I/pSiljnsrwxI0Wt+8ABjS+b6C9l7V2u9W
         mbEbcdwIXvlqNu+X8AMhmC+Ap4tCjBnvqrBIP2NkyFuSylr0iVb7J0lmUlIImg8tHiUY
         jDFebheMDlqE/7wb0LXpckDVChTAfpsv8EAYNn7pc2+UywX7N1Fz4qAHPBJuSzFR7lpc
         Dd4zMhCaortRW7XKJR15adskzPY85D34pgtnnqxP420b6gzYpt3vU1pUVnOmIVlxZu/l
         swWw==
X-Gm-Message-State: AOJu0Yw6YvrasqxGVbKrYdKprrEDhbr0ZqV6702kcqxzCjE4iBzitJrD
	LJ2tCy7NUIh+GW0NynoRO+ls9kIT7LKIma8kUnSKtnJwUkuAU5GrR+aaoZbJrkLV/faEJvl0ftC
	Um+7Qhm4EmOXaMmFjFjpUvl/uwoDGNjaQy2Lt
X-Gm-Gg: ASbGncvXp4CmzgopxtYOpEHzBraUvsm7x7dCZgKLgDxCY+0pVnsXE8I9zJgt3cE0P3L
	ZYyp0WgL3V+H7A8/fXePeD/RKIT8djHuilWhWLeUVp2gA5K9uDVAxBVvM8lbDeUnxLtjUj2z1IX
	Xb9akwYNGiueKwFjiyFWjDjTGzAqx9YrFbq2ErVwFYlhAjCfQf9GT6Rj9tWiDUIVuZJucx8ICBI
	jmwygSEESNxUewIObvv5M/HCdq5ZVTp1uhJ838AoKmTb+tGnVaoUfsq5nHY3g==
X-Google-Smtp-Source: AGHT+IHr0RrUE3c6iDbo2kxmtFqV7r/Zt/IEclwndCFwGaTjx6iuh89vpaCi6+DSKw8wZzeVnwt/lz8MWmH7yjetkrQ=
X-Received: by 2002:a05:6512:b9a:b0:592:fad3:9d02 with SMTP id
 2adb3069b0e04-5943d754a93mr476887e87.22.1762325085921; Tue, 04 Nov 2025
 22:44:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <73c75a4192c45e9c8b5054e0ac67f586a8c41589.camel@dubeyko.com>
 <CAKFNMomaK8UYcgjvx_Pp09P7OU25th2UBo+gAigZidcyTOQg3w@mail.gmail.com> <a5bf62ed31574f647fc34ad63af7fda8dc17622d.camel@dubeyko.com>
In-Reply-To: <a5bf62ed31574f647fc34ad63af7fda8dc17622d.camel@dubeyko.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 5 Nov 2025 15:44:29 +0900
X-Gm-Features: AWmQ_bkdG-o58SDDi7mTmXBMTbpmo6kXQJkjGLJ1QS-mE39PGGpfvl7ZEQhAzyE
Message-ID: <CAKFNMonZ=pgnHEOEWey_t2Ycd98nfMAAaSm9wDAXv-MEsKYc5w@mail.gmail.com>
Subject: Re: [RFC] Sending NILFS2 patches into upstream
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Viacheslav,

On Wed, Nov 5, 2025 at 5:10=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> Hi Ryusuke,
>
> On Tue, 2025-11-04 at 19:41 +0900, Ryusuke Konishi wrote:
> > On Tue, Nov 4, 2025 at 5:37=E2=80=AFAM Viacheslav Dubeyko wrote:
> > >
> > > Hi Ryusuke,
> > >
> > > Currently, you ask Andrew Morton of sending NILFS2 patches into
> > > upstream. But Andrew is busy and it makes the whole workflow
> > > complicated and unpredictable.
> > >
> > > I am sending HFS/HFS+ patches to upstream. So, I can create the
> > > dedicated NILFS2 kernel tree on kernel.org and I can send NILFS2
> > > patches upstream. I believe that it can make the whole patch
> > > management
> > > workflow more flexible and predictable. Also, additional maintainer
> > > is
> > > better than to have only one.
> > >
> > > We already had some discussion privately. So, let's continue the
> > > discussion in the email list. What do you think?
> > >
> > > Thanks,
> > > Slava.
> >
> > Hi Viacheslav,
> >
> > Yes, thanks for the suggestion.
> >
> > As I replied to you privately earlier, I'd welcome your help both
> > with
> > upstreaming and setting up the git tree on kernel.org.
> >
> > First, I'll start by adding you as a maintainer.
> > To do this, I'd like to send a patch with changes to the maintainers
> > file to Andrew.
>
> Sounds good! Probably, I can create the NILFS2 kernel tree on
> kernel.org at first. And, then this patch can be sent with adding the
> link to this kernel tree into MAINTAINERS file.

Yes, it's OK to set up a git repository first.
In that case, we will only need to make the changes to the MAINTAINERS
file once, so I'll send one patch for the next merge window.

Not only do we add an M: field and switch the T: field, but the S:
field in the MAINTAINERS file should also be updated to reflect the
current status, so I'll make these changes all at once.

Please let me know where the repository is once you've set it up.

> >
> > Currently, bug fix patches and patches for the next merge window are
> > being sent to Andrew, so to avoid confusion, I think it would be best
> > to switch the upstreaming path after the next merge window is over.
> >
> > I'd like patches after the next merge window to be upstreamed via
> > you.
> > What do you think about this timing?
> >
> > As for switching the git repository in the MAINTAINERS file, how
> > about
> > after 6.19-rc1, again to avoid confusion?
>
> Yes, makes sense. I am having the same in mind. Because, anyway,
> preparing the whole workflow will require some time.
>
> >
> > Next, as for upstreaming, one option is for you to directly pick up
> > patches sent to this mailing list, and I can review and test them.
> > However, I think it's better to change the maintenance flow
> > gradually,
> > so initially I would like to pick up patches, add my Signed-of-by
> > tag,
> > and complement them with appropriate tags such as Fixes or Cc:
> > stable.
> >
> > To do this, I think it would be best to relay patches or their series
> > to the repository you set up on kernel.org via my current GitHub
> > repository.
> >
> > In practice, I will push the collected patches, signed, with tags
> > like
> > fixes-6.19-<serial number> or for-6.20-<serial number> to my current
> > GitHub repository, so please cherry pick them to receive them
> > initially.
>
> I assume that, currently, NILFS2 hasn't active development and to send
> patches for the first merge window in the cycle (for-6.20-rc1, for
> example) could be completely enough.
>
> >
> > Patches with tags starting with fixes- prefix are intended to be sent
> > as bug fixes in that cycle, while patches with tags starting with
> > for-<version number>- prefix are intended to be sent for the merge
> > window of the next cycle.
> > It would be ideal if I could automate the notification of pushes, but
> > initially I will send you an email.
>
> Makes sense. We can use this model of operations.
>
> >
> > Next, regarding the operation of the repository to be set up on
> > kernel.org, I think you should create a main branch of the nilfs2
> > project to send pull requests to Linus.
> >
> > I haven't created a main branch for the nilfs2 project so far, but I
> > think it's better to have one when collaborating.
> >
> > In this regard, how do you maintain the HFS/HFS+ tree?
>
> So, I have two branches for-next and for-linux. I am resetting it to
> the last rc1 tag. And, then, I am collecting patches in the for-next
> branch at first by means of b4 am <MSG ID> + git am -s <mbox file>.
> When I have enough patches for a merge window, then I execute these
> steps:
>
> $ git checkout for-linus
> $ git rebase for-next
> $ echo -e "hfs updates for v6.18\n" > ../hfs-v6.18-changes.txt
> $ git log --pretty=3Dformat:"- %s" v6.17-rc1..HEAD >> ../hfs-v6.18-
> changes.txt
> $ git tag -s hfs-v6.18-tag1 for-linus # (paste the contents of "hfs-
> v6.18-changes.txt" here)
> $ git push origin --all
> $ git push origin --tags
> $ git request-pull master
> git://git.kernel.org/pub/scm/linux/kernel/git/vdubeyko/hfs.git hfs-
> v6.18-tag1 > ../hfs-v6.18-pull-request.txt
> $ git branch for-v6.18
> $ git push origin --all
> $ git push origin --tags
>
> Finally, I am sending hfs-v6.18-pull-request.txt by email as pull
> request.
>
> So, I could have the same two branches for-next and for-linux for the
> case of NILFS2. The for-next branch could receive patches from github,
> the rest steps could be the same. I simply need to elaborate the
> steps/commands to cherry pick the patches from github's repository into
> the for-next branch.

Thanks for the detailed explanation of the steps ;)
It's almost exactly what I used to do a long time ago.

Yes, in that case, I don't think there's any need to change the
method, so please operate the nilfs2 upstreaming tree in the same way
- as before, let's exchange patches without creating a main branch for
the project.

Thanks,
Ryusuke Konishi
