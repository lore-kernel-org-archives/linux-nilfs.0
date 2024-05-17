Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A741812F591
	for <linux-nilfs@vger.kernel.org>; Fri, 17 May 2024 15:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715961176; cv=none; b=MVfZMXh1807qoDnOu9zMRKEpHKa6hKNEBVB+6tyWfSWjDQlHT4HamTlPv8lhY7a5yZj6w1qTwKMK8bqJwiNxj8wZzzxXvhWMf883j0kUZEXSWqDu+igYEcYQ/AmEMMHjUGohu1oWYXPht/gH+H7/VvhtNP+2q1HCPvPhERSHyN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715961176; c=relaxed/simple;
	bh=+KKefjoffKvfiWlHtyzARSgF6pa3VRijHQBIea8/azU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=af4va/TIZyLpp5PRWdhi5QVWFy7rz3SWkwQoh7Ig9wpSrtm7Wv2BX2jl0YTZyEYud16RjU/95s/A3GXM+lbhKIcOaly5I0jqULi3wz82VnsbzMNtXAyqA+1lh4/S5TanH7DW2cPf52bxzlgWFqzoRA2sghapOTXYfBfnJhWXUKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MO0aDXb6; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MO0aDXb6"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-51f45104ef0so1003775e87.3
        for <linux-nilfs@vger.kernel.org>; Fri, 17 May 2024 08:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1715961172; x=1716565972; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5F6odILlMEMye+qyQ7yUkE31zWxXmW2HU+hKWzkF4IM=;
        b=MO0aDXb6HCenYM/AGTjirE4vWqWKA14voA4LzjrBk9TWpWsioQ7oUavLVYM0FwRki+
         gDbIrZBn3MRI4iE98hzu6UZ7lwmnczPMebYJpBtGWpDgQ0uFbA+kmz3A/SNu+CbihnKl
         hge0fkEqQnncnckVPpHy8v26nk1cxouJ7rUkg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715961172; x=1716565972;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5F6odILlMEMye+qyQ7yUkE31zWxXmW2HU+hKWzkF4IM=;
        b=LcVT+JY/kYMaJr3oJ/dyhv5LOvVw8yAXLCtvB4SMluVqsIzysenzD7UpUfllyPQTjM
         klpTW7AVrjHL1NW9dXeD/ClMgMRARtGG7gXGu9mJIInydkViCbJGkt5TYkT6hb0wBUgD
         AUeGudsptyPONfPqlcEnEfOx+t+ASw3g46yxmU1n9LDnjLmjEy8oj0d4JSXAU8qVuow3
         DzN4FFVDnhTcogoGxXgbgR5QY+DgeSEUSh+W2r4iw0nrGS2FR4XDRpDH3+hrrHGQFngI
         VlKOhPOu43r56ENYoRMPHjrVsD5bka7btaZ/7EgT0ZI6L0VFon6ikIgVXt2Vb2dQCyjY
         Yd5g==
X-Forwarded-Encrypted: i=1; AJvYcCUsdqVURwWaiZ0A5rlH2mVVgrrqNid+IXr4TPImHoczWSyGiIPGO6eRNO5jARqNujDaJOVlzJ07yuyX57Z4TH6mbdFbeO5J5Z8BPY0=
X-Gm-Message-State: AOJu0YyiVixH2SGnS7OidzusNePwfHE/nR6wSm+ehyFyrl4oTkuGGCJq
	1wf0rzsX2iBZAUDSJxOyIUhAb2Sv+skSU0oUZgHCWpUbhyGHTRuFrul0+LO8sSDEFCK0ubggkie
	Byz2YGg==
X-Google-Smtp-Source: AGHT+IFlTK8ub5c1yi/r5xQSqnqJ0QCaqvyz3m10i0uN61r75wezTqRGgpwH1EblVL2uDMyta8rbVQ==
X-Received: by 2002:a05:6512:310f:b0:51d:6660:e43 with SMTP id 2adb3069b0e04-5220ff746c8mr13635386e87.59.1715961172551;
        Fri, 17 May 2024 08:52:52 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-521f38d36d3sm3316347e87.169.2024.05.17.08.52.51
        for <linux-nilfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 May 2024 08:52:51 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-51f57713684so2887338e87.1
        for <linux-nilfs@vger.kernel.org>; Fri, 17 May 2024 08:52:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWL0wQlsx4NfI1fvwZx+hpWYZmvhmOvBeT86xm4zd3iwjpw5T3NBoi4LYnDmaOCcjAddy3rBnTqoOIItvQY9gC75JU1ehlMGQ8+5bw=
X-Received: by 2002:a05:6512:15a8:b0:51f:b781:7297 with SMTP id
 2adb3069b0e04-5220fa7180amr17902407e87.8.1715961171112; Fri, 17 May 2024
 08:52:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240507142454.3344-1-konishi.ryusuke@gmail.com>
 <CAHk-=wgogPoSdCYw9jhc2Zm=BaE19nXYwFn_F9SwD2C-DyrmCw@mail.gmail.com> <4a5cf233-a4e6-48ce-b9ba-f1014f452892@acm.org>
In-Reply-To: <4a5cf233-a4e6-48ce-b9ba-f1014f452892@acm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 17 May 2024 08:52:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh9cwmRUzqskD=qV2oCpyS8GBWWAv1sSrN8YOPR3fd70w@mail.gmail.com>
Message-ID: <CAHk-=wh9cwmRUzqskD=qV2oCpyS8GBWWAv1sSrN8YOPR3fd70w@mail.gmail.com>
Subject: Re: [PATCH -mm] nilfs2: Use __field_struct() for a bitwise field
To: Bart Van Assche <bvanassche@acm.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Steven Rostedt <rostedt@goodmis.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 16 May 2024 at 14:52, Bart Van Assche <bvanassche@acm.org> wrote:
>
> It seems like sparse verifies the types of all expressions in a
> _Generic() argument list instead of only the expression for which the
> type matches.

Yes.

>    Could this indicate a bug in sparse? On
> https://en.cppreference.com/w/c/language/generic I found the
> following (I'm not sure whether that website is a good reference):
>
> "The controlling-expression and the expressions of the selections that
> are not chosen are never evaluated."

Not really a bug, because "never evaluated" in the above context means
that they don't generate code. The expressions are still obviously
parsed for syntax and validity.

It definitely might be seen as a misfeature, though - the "degrades to
integer" warning is done before code reachability has been determined.
So it's done even for code that is never executed.

So you'd get it even if you had something like

        if (0) .. some bad bitwise expression ...

Sadly, that's fairly deeply ingrained in how sparse deals with the
bitwise types: they degrade to their regular base type as part of the
type evaluation, which happens fairly early on the syntax tree, long
before it has been converted to SSA form and reachability analysis.

It's *fixable* - instead of warning when evaluating the types of the
expression, sparse could leave in a "warning node" into the tree,
linearize it to a "warning instruction" in the SSA form, and only
actually output a warning if that instruction still exists after dead
code elimination etc.

But that kind of fix would be a pretty big change, we don't have that
kind of thing right now at all. So "fixable in theory" is probably not
"practical with the current lack of sparse development".

What would be much easier is probably to hack together a couple of
builtins for type checking: a "__builtin_signed_p()" should not be
hard.

                  Linus
