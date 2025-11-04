Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F1D2046BA
	for <linux-nilfs@vger.kernel.org>; Tue,  4 Nov 2025 20:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762287029; cv=none; b=Lnxli6cw09QzY/XlF8WFLQudB2FeP31l0qV41Sp839yq61DpviWLUwr1jrJU13bPP5KHQRGsJPQCD/SbhTd0e3pKP/fnnGsGOOZx0z+pvOvCKjehWU1kXgMj8pYgwO7PzIre68kt994q7JpqquJGm0oBsazif6YKQxFXUzXySiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762287029; c=relaxed/simple;
	bh=DcYMy6LFgbf6NYH8hRksdW9SEetG68ZHF0JqN63sl+I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=f3N/0lUR+zJsWkR9zRTt6TAyOWpFpIghLtQp4EhA+VQUO7IRwesOLfromq1GOi5GHD2fl5C0QR+u0GhlrBvWaMjfAuESMFWxtRYy7SmgGQXBQ10YmRbyC/+Tc+W+H/hVV7Z3RRw51qnZtSElaT29geg5Wyj+9tR+4ttMds+R3DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=ejd+LOTP; arc=none smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="ejd+LOTP"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-63e330a1360so6171078d50.3
        for <linux-nilfs@vger.kernel.org>; Tue, 04 Nov 2025 12:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1762287026; x=1762891826; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DcYMy6LFgbf6NYH8hRksdW9SEetG68ZHF0JqN63sl+I=;
        b=ejd+LOTPGuAQlScT7t4pj2y9nAgIQpLHxpKNHxe5ojvGBZNHAghPJNvtvU6ZZFYsQG
         obArgCEk+h2xTrninx3PLEvYYidx0stnQwvJmBY+9cJtQA3rVvBPEBfUFKiFf4uksIyb
         ghIZwA5FMzpJF9YDfX5jXVEidfpb57t7dEENcEtJobC3UDVz6XS9IW/D/4M13dNdrMNS
         fF3Pfhvx4najyjJfYuyE4Pum0Qi92UsNEH6zL0VhLmsrHCpAfKMPDF/xAtaOhEl11wNr
         gY3MFZkxff4lk7zdMe4n6mCVISiBwoIC5KQV/htDLTpvr1OFrUoDp1LBXt5mCNDFRae0
         dVUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762287026; x=1762891826;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DcYMy6LFgbf6NYH8hRksdW9SEetG68ZHF0JqN63sl+I=;
        b=JatIXmw9ezUCX2p8U3CxR/fYjmy3XsS8B8bU47Ere7/QVYJVSgqkQrTu9MtLVP8hrY
         hDHv07Zcow3g23yAS2GZinGTdmemmISgiZgbuRL/CjL8z3QJb6eJtSpwPIHWaQwvA5es
         3tpr7AR9JbZbPUrQNKNVr4UWTjz0kvIJWmictsh2fD2Hzi8BhXpX1vegpbkKsq/HmlW+
         uFURJas22lp3umCa9TSND1x6HnRM0ldPHwP/rMGU67UjfpHaIRu7JMvXYmwl1IhaU8/D
         HQVf2mtZWDAD45DgIV+5eYNx0Q6aQLT6AhPm7VFvkAksMj0kirOSUzrD2mIwEvRVCvEu
         TmAA==
X-Gm-Message-State: AOJu0YwklWJ5eVCL+tlr/KmoQ4v4nF/Ox8xOJ8IDZgqHy5C24Z2qLO/K
	NT32oZh/HGfziAm+5nmQN/SxtagyDntgSy/wt6dTXIKfivHOR7hRMbm9g2FkAu4aTtC+r/48W52
	/qH7l
X-Gm-Gg: ASbGncumhfJ+a8ceTz7B36AcuzlNGswWjNxntdEJGP3ebb85Z/6xFYg43Lwe2SEZ3li
	B/rp6LnQUVa0h/BFjiIxYb2dWiLeKdwa+nlDPiJcrx8ICuLxS1yKRrw0K1dZCU0lRSGCpTu5WPM
	4gh7VPdEjxRi009pjFzSqEluVRD06U2FRPXy8zo6bRiL+0EkjHkXLciiwScJC7Vn72FcOEJzHsY
	n7+wP+81dGVZALBp3GO72MIZgMlGLMeKkpC+dSf4o/S42GHqTyq6j3th9ynLS/nPAXKDM2fovOW
	Z0Koi30BHHRuG3z4SIB18D3nNcgU/0zEPmC8QOITYgirFxyDEpyxKd84uRdcVdDkC/BhoZaFPre
	IJml4VZ/i49ABymmTO4JSJ/CSW9aG2YyKSza08ZGK2t19cLmhWXXzqrc+Xt+i+OP/+/rNXkWMk2
	D2GQuLHNulYycM13Z7m03ncaqcsID1Q4zwoT4XP1b5PppTWByT
X-Google-Smtp-Source: AGHT+IFegyXgeHAjbymqGc/ycOsdlC+jIqwwL7Be9od4SmI0FZbytTUoq3qZXErf2rEHEDRaJTagKw==
X-Received: by 2002:a05:690e:23d3:b0:63f:2db0:9980 with SMTP id 956f58d0204a3-63fd356f4c4mr525946d50.34.1762287025753;
        Tue, 04 Nov 2025 12:10:25 -0800 (PST)
Received: from ?IPv6:2600:1700:6476:1430:1c90:8173:a930:2444? ([2600:1700:6476:1430:1c90:8173:a930:2444])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63fc95ab3bcsm1027168d50.17.2025.11.04.12.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 12:10:24 -0800 (PST)
Message-ID: <a5bf62ed31574f647fc34ad63af7fda8dc17622d.camel@dubeyko.com>
Subject: Re: [RFC] Sending NILFS2 patches into upstream
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org
Date: Tue, 04 Nov 2025 12:10:23 -0800
In-Reply-To: <CAKFNMomaK8UYcgjvx_Pp09P7OU25th2UBo+gAigZidcyTOQg3w@mail.gmail.com>
References: <73c75a4192c45e9c8b5054e0ac67f586a8c41589.camel@dubeyko.com>
	 <CAKFNMomaK8UYcgjvx_Pp09P7OU25th2UBo+gAigZidcyTOQg3w@mail.gmail.com>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Ryusuke,

On Tue, 2025-11-04 at 19:41 +0900, Ryusuke Konishi wrote:
> On Tue, Nov 4, 2025 at 5:37=E2=80=AFAM Viacheslav Dubeyko wrote:
> >=20
> > Hi Ryusuke,
> >=20
> > Currently, you ask Andrew Morton of sending NILFS2 patches into
> > upstream. But Andrew is busy and it makes the whole workflow
> > complicated and unpredictable.
> >=20
> > I am sending HFS/HFS+ patches to upstream. So, I can create the
> > dedicated NILFS2 kernel tree on kernel.org and I can send NILFS2
> > patches upstream. I believe that it can make the whole patch
> > management
> > workflow more flexible and predictable. Also, additional maintainer
> > is
> > better than to have only one.
> >=20
> > We already had some discussion privately. So, let's continue the
> > discussion in the email list. What do you think?
> >=20
> > Thanks,
> > Slava.
>=20
> Hi Viacheslav,
>=20
> Yes, thanks for the suggestion.
>=20
> As I replied to you privately earlier, I'd welcome your help both
> with
> upstreaming and setting up the git tree on kernel.org.
>=20
> First, I'll start by adding you as a maintainer.
> To do this, I'd like to send a patch with changes to the maintainers
> file to Andrew.

Sounds good! Probably, I can create the NILFS2 kernel tree on
kernel.org at first. And, then this patch can be sent with adding the
link to this kernel tree into MAINTAINERS file.

>=20
> Currently, bug fix patches and patches for the next merge window are
> being sent to Andrew, so to avoid confusion, I think it would be best
> to switch the upstreaming path after the next merge window is over.
>=20
> I'd like patches after the next merge window to be upstreamed via
> you.
> What do you think about this timing?
>=20
> As for switching the git repository in the MAINTAINERS file, how
> about
> after 6.19-rc1, again to avoid confusion?

Yes, makes sense. I am having the same in mind. Because, anyway,
preparing the whole workflow will require some time.

>=20
> Next, as for upstreaming, one option is for you to directly pick up
> patches sent to this mailing list, and I can review and test them.
> However, I think it's better to change the maintenance flow
> gradually,
> so initially I would like to pick up patches, add my Signed-of-by
> tag,
> and complement them with appropriate tags such as Fixes or Cc:
> stable.
>=20
> To do this, I think it would be best to relay patches or their series
> to the repository you set up on kernel.org via my current GitHub
> repository.
>=20
> In practice, I will push the collected patches, signed, with tags
> like
> fixes-6.19-<serial number> or for-6.20-<serial number> to my current
> GitHub repository, so please cherry pick them to receive them
> initially.

I assume that, currently, NILFS2 hasn't active development and to send
patches for the first merge window in the cycle (for-6.20-rc1, for
example) could be completely enough.

>=20
> Patches with tags starting with fixes- prefix are intended to be sent
> as bug fixes in that cycle, while patches with tags starting with
> for-<version number>- prefix are intended to be sent for the merge
> window of the next cycle.
> It would be ideal if I could automate the notification of pushes, but
> initially I will send you an email.

Makes sense. We can use this model of operations.

>=20
> Next, regarding the operation of the repository to be set up on
> kernel.org, I think you should create a main branch of the nilfs2
> project to send pull requests to Linus.
>=20
> I haven't created a main branch for the nilfs2 project so far, but I
> think it's better to have one when collaborating.
>=20
> In this regard, how do you maintain the HFS/HFS+ tree?

So, I have two branches for-next and for-linux. I am resetting it to
the last rc1 tag. And, then, I am collecting patches in the for-next
branch at first by means of b4 am <MSG ID> + git am -s <mbox file>.
When I have enough patches for a merge window, then I execute these
steps:

$ git checkout for-linus
$ git rebase for-next
$ echo -e "hfs updates for v6.18\n" > ../hfs-v6.18-changes.txt
$ git log --pretty=3Dformat:"- %s" v6.17-rc1..HEAD >> ../hfs-v6.18-
changes.txt
$ git tag -s hfs-v6.18-tag1 for-linus # (paste the contents of "hfs-
v6.18-changes.txt" here)
$ git push origin --all
$ git push origin --tags
$ git request-pull master
git://git.kernel.org/pub/scm/linux/kernel/git/vdubeyko/hfs.git hfs-
v6.18-tag1 > ../hfs-v6.18-pull-request.txt
$ git branch for-v6.18
$ git push origin --all
$ git push origin --tags

Finally, I am sending hfs-v6.18-pull-request.txt by email as pull
request.

So, I could have the same two branches for-next and for-linux for the
case of NILFS2. The for-next branch could receive patches from github,
the rest steps could be the same. I simply need to elaborate the
steps/commands to cherry pick the patches from github's repository into
the for-next branch.

Thanks,
Slava.

