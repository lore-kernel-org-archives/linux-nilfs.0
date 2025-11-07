Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7781DF270
	for <linux-nilfs@vger.kernel.org>; Fri,  7 Nov 2025 15:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762530991; cv=none; b=YW6BwjDKB2izw/DXxrezEw9u5y5tCvDUS5CRPwFQiiBkd4MP4D3r1m4ksPlJZy18EF/V1oYWiVCoTIRLC1+orPpz5BwJmVeXXr6oFYJ8lv+rbBeHG9GgbrGVCgbMN1K6FFO/ULeb0tFGMLvIeTtzozIUQlD8SudDvEvCPyje9Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762530991; c=relaxed/simple;
	bh=6GDmy33WINZWaRCv5/AXzJOP4xCw61dQ5o4pQTUOBZw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZUoOxg83WIGjHVW6KLFl0qznKfHwR0YLOXfrOj58OXuu/FYI2jVXAXxY7tx1eyIKpKBSglpQaYLhP3v40uzDwkpCcalGjdewWuFRbCtzm8Odig4JxGYQov7D5DA+isA8Mp/U5Lmkls73xF5BWV0+GxB4J3s1Y13sRwnPLwpnCoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ksYzPcTt; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ksYzPcTt"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5945510fd7aso704286e87.0
        for <linux-nilfs@vger.kernel.org>; Fri, 07 Nov 2025 07:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762530987; x=1763135787; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VIZrXEfhjXChC80XlKROmfqUM+h6RSVhjAktbhwdlXU=;
        b=ksYzPcTtZJdcl+0CoyM1WV6xAkRbH8aXJgkuCgXA/bN01wyNF0/xCRZ1aoG8Pmvje0
         E2QeeuQzmiXU/t04uzsjs/Sg6AEP01SpcWKDbdDYW499fnIgycq3k+yThxRh60p4ki70
         h2JsKu3s/UbkO/VEahMY+jPKHK/vCJqZ6+DjaymKf3DkIIXE7AnoGSqGIQuNPRm54bGP
         3ebRQxe5v+lUBpIPJdYF9C5BIGMFXRdwSCD+vsh73GYKuU+i8DobGw/6LWnOrTgx2TOy
         qNXatBZ9TkWVJRuJBPY2N/OGwnNrzYcZgW3neDwyk+jCDDXU6t53Sr55jvjOuqCZfKIL
         yPBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762530987; x=1763135787;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VIZrXEfhjXChC80XlKROmfqUM+h6RSVhjAktbhwdlXU=;
        b=t1f3ThTk+Hfrp77MpHrurRIb/i0RjzqbTKaGLiHVsAiQMOfD7AqyNmEKzeUHcL0vfU
         kzEK/H6zIgs9EDVmHH6RS+rQXRKqQdc71lWBRNoVXunnMwUav6iXsP4WpLu+mG7c8KoY
         JmL7agErfZLLq4RJN/WpcB8+VT344bNu4AyIkhPi+JkB9389kufDZootZkqZDvTNl1Em
         AHb6cBudqTRBBpszSfSyv3VlNGDzd2JqHE/9xTtJTGcZqjpyRW3F6sfjrbVje8qBECph
         EkHsxZCNYgcSi3cNyt+BMTkXARq1iFJrcGF/aqZ8OOgBeAj1uebAIX69u1SJhQ0XpbtQ
         GWwg==
X-Gm-Message-State: AOJu0Yz6UTtvGxxJmlxf/0Hkw1f/VGTweXbCLK4O5a09qod0hiw06FJE
	RrAF5siujd+nlVAUed1BVOYKc5wFnY3BU0Pqb/TYWP3IxCnS9+OhyMpbcAldTyd+ASvzbUGOo2V
	JTThLhkqSrs9ZrmTYPnDSIqrYG3TDtJUod4+Z
X-Gm-Gg: ASbGncs8B/sTq07WFq1++zaqKs2fdL1ZNxwIhDQw5Es8h+aH2+G66yZcaOq5phISc68
	pH8Js+oSGf6vMlbCTyoxssAAAc2ATMwZ7TxWtRLJtgTYm1SdD4rQWIgflcYwqVr01T4Biez0t/2
	Z+uutqcEt9w94fZ5RyZW/JD3cOXR8wfF5nGjPuAKdhZyNnM4gsVh48/aHupEIQT54pBgLWE4Dph
	eoLlbDvXhFFi0E/Kblio0wSr89YBMwgl6hlmTo20ywhJDtpLHehcOriTgwB5BPckINazc6y
X-Google-Smtp-Source: AGHT+IHkl2CQPdOuUWsN2tx8Kkcm5IiHHNvDxKai0TlTHD+v9jeNbFa7owTDleRbnNpLUtglNO6LOoZlEUeRY6qpieI=
X-Received: by 2002:a05:6512:234d:b0:577:285f:32bd with SMTP id
 2adb3069b0e04-59456b9eaf0mr1035333e87.26.1762530987052; Fri, 07 Nov 2025
 07:56:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <73c75a4192c45e9c8b5054e0ac67f586a8c41589.camel@dubeyko.com>
 <CAKFNMomaK8UYcgjvx_Pp09P7OU25th2UBo+gAigZidcyTOQg3w@mail.gmail.com>
 <a5bf62ed31574f647fc34ad63af7fda8dc17622d.camel@dubeyko.com>
 <CAKFNMonZ=pgnHEOEWey_t2Ycd98nfMAAaSm9wDAXv-MEsKYc5w@mail.gmail.com> <0850ad95f58a73a39e190dd4e450302158e97b37.camel@dubeyko.com>
In-Reply-To: <0850ad95f58a73a39e190dd4e450302158e97b37.camel@dubeyko.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sat, 8 Nov 2025 00:56:10 +0900
X-Gm-Features: AWmQ_bl2QPqNORqdteP4iKnjEzk3Ic8glqy0JxVOdYN0ZmrTrSfPMVozCSGo8gQ
Message-ID: <CAKFNMonDXReXUppt0e9Qs4N6kHxV=kadP7CAVFueMzJz_2+Acg@mail.gmail.com>
Subject: Re: [RFC] Sending NILFS2 patches into upstream
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 7, 2025 at 4:33=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> Hi Ryusuke,
>
> On Wed, 2025-11-05 at 15:44 +0900, Ryusuke Konishi wrote:
> > Hi Viacheslav,
> >
> > On Wed, Nov 5, 2025 at 5:10=E2=80=AFAM Viacheslav Dubeyko wrote:
> > >
> > > Hi Ryusuke,
> > >
> > > On Tue, 2025-11-04 at 19:41 +0900, Ryusuke Konishi wrote:
> > > > On Tue, Nov 4, 2025 at 5:37=E2=80=AFAM Viacheslav Dubeyko wrote:
> > > > >
> > > > > Hi Ryusuke,
> > > > >
> > > > > Currently, you ask Andrew Morton of sending NILFS2 patches into
> > > > > upstream. But Andrew is busy and it makes the whole workflow
> > > > > complicated and unpredictable.
> > > > >
> > > > > I am sending HFS/HFS+ patches to upstream. So, I can create the
> > > > > dedicated NILFS2 kernel tree on kernel.org and I can send
> > > > > NILFS2
> > > > > patches upstream. I believe that it can make the whole patch
> > > > > management
> > > > > workflow more flexible and predictable. Also, additional
> > > > > maintainer
> > > > > is
> > > > > better than to have only one.
> > > > >
> > > > > We already had some discussion privately. So, let's continue
> > > > > the
> > > > > discussion in the email list. What do you think?
> > > > >
> > > > > Thanks,
> > > > > Slava.
> > > >
> > > > Hi Viacheslav,
> > > >
> > > > Yes, thanks for the suggestion.
> > > >
> > > > As I replied to you privately earlier, I'd welcome your help both
> > > > with
> > > > upstreaming and setting up the git tree on kernel.org.
> > > >
> > > > First, I'll start by adding you as a maintainer.
> > > > To do this, I'd like to send a patch with changes to the
> > > > maintainers
> > > > file to Andrew.
> > >
> > > Sounds good! Probably, I can create the NILFS2 kernel tree on
> > > kernel.org at first. And, then this patch can be sent with adding
> > > the
> > > link to this kernel tree into MAINTAINERS file.
> >
> > Yes, it's OK to set up a git repository first.
> > In that case, we will only need to make the changes to the
> > MAINTAINERS
> > file once, so I'll send one patch for the next merge window.
> >
> > Not only do we add an M: field and switch the T: field, but the S:
> > field in the MAINTAINERS file should also be updated to reflect the
> > current status, so I'll make these changes all at once.
> >
> > Please let me know where the repository is once you've set it up.
> >
> > >
>
> I've created the repository today:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/vdubeyko/nilfs2.git
>
> And I've added two branches there:
>
> git branch --all
>   for-linus
> * for-next
>   master
>   remotes/origin/HEAD -> origin/master
>   remotes/origin/for-linus
>   remotes/origin/for-next
>   remotes/origin/master
>
> Thanks,
> Slava.

Thank you for setting up the git repository.

I just sent a patch with the MAINTAINERS changes, including that
location, so if you'd like, please send an Ack to Andrew as a reply.

Thanks,
Ryusuke Konishi
