Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C93A3EBF36
	for <linux-nilfs@vger.kernel.org>; Sat, 24 Jan 2026 09:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769246282; cv=none; b=nsOi46BoKPgnokSORERZDQJsXzrM9vBqIb1fFkSe9IJ9idIuJdwPPdmolFZFEeVEUxHH611teuYI7F3zibGV9UYFE3GeIHdlGZcMIvQQyMm8WWRZaQrzQ5bBchxY0kAQV3GdZwejvr3/YRJK5OeZfMkWsT53dtW0nHsmoUHJZIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769246282; c=relaxed/simple;
	bh=Zkizt+02nhoZ6DlyEdZDrkg5MrvNrA0ylT+zBwkCH90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wh2tRo7NKgmSjBZdbWZ08zZZJVCm3Nabf3VrHP5XsogGOC2jLcKCPqoBa9odsgolewzAJT6A4TrBmMkfE2qcNAumdArhhSP5ilsP/fndjKCZdXGkPJB7ifGnCa+xAzNKSPl1wJnM/GH+mkLSuixPzGkPSxLJ14s6MoIjwzjm+ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=kC9bIqqc; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="kC9bIqqc"
Received: from macsyma.thunk.org ([193.36.225.166])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 60O9Hh03022147
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 24 Jan 2026 04:17:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1769246270; bh=D6cQWJaToELtffJb8NAD4wLkquQXrqmymjRfqQ1bLY8=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=kC9bIqqcVyTnQjHk0n43RrAAhQgWdoKAbMBmRtXbKcAiQYlVvrYFhbirLmUUwFlc/
	 CColWuYACUSglucMtSoys0RjoqrW2GRfmdgt+f9Yp2GJDO8VW7V8xWX/IoHmtA2gTu
	 D28NC7a4uGaz+itKqPQ8XE54wDu5spzCl51Iz6bbISU8Je1bhGyz6xnhM2Xxd02mg3
	 Dk1qbtmJSS7jY653Eem+h2cMl6UOp3jXmOXOEv0MUZ4TmnfWKILTd63uHEwwp4Osbr
	 0dHXkyIUMb1yyE0Qhcptw4j0g6AE9VRbXZA9oOTXxCdzgL4dBb4BttdX5BN18z3ge4
	 A474L/F5bU6eQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id A111955F36F0; Fri, 23 Jan 2026 23:17:42 -1000 (HST)
Date: Fri, 23 Jan 2026 23:17:42 -1000
From: "Theodore Tso" <tytso@mit.edu>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
        "konishi.ryusuke@gmail.com" <konishi.ryusuke@gmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "slava@dubeyko.com" <slava@dubeyko.com>,
        "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [LSF/MM/BPF TOPIC] Is it time of refreshing interest to NILFS2
 file system?
Message-ID: <20260124091742.GA43313@macsyma.local>
References: <8e6c3a70db8b216ab3e9aba1a485de8e6e9db23d.camel@ibm.com>
 <20260124014638.GH19954@macsyma.local>
 <43e3ce52eabd37b8af1e70fb2f0936f6bfb6127c.camel@ibm.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e3ce52eabd37b8af1e70fb2f0936f6bfb6127c.camel@ibm.com>

On Sat, Jan 24, 2026 at 03:56:24AM +0000, Viacheslav Dubeyko wrote:
> Multiple other Linux kernel file systems are in better shape because
> they have more attention. So, the main point of this topic is sharing the
> current status of NILFS2 (issues and TODOs) and to have discussion how we can
> move the NILFS2 to better shape.

I'd gently suggest to you that if you want to give a status of NILFS2,
a better place would be either writing an LWN article, or a talk or
BOF at Linux Plumbers Conference.

In terms of how to move NILFS2 to a better shape, perhaps we can start
a discussion on this e-mail thread?

  1) You need fsck.nilfs2.  I've looked at nilfs-tools, and you have
     a mkfs.nilfs2, but you don't have a utility to (a) verify that
     the file system is self-consistent, and (b) repair the file
     systgem if it isn't.  Without such a tool, I can pretty much
     guarantee that no one will take the file system seriously, and
     using it in production would be professional malpractice.

  2) You need to test nilfs2 using fstests, which means you need to
     add support for nilfs2 to fstests.  Having an fsck program is
     super useful for fstests, because if a kernel bug corrupts the
     file system, you need an fsck program to detect that fact, and
     then you need to fix said bug so that customers don't have their
     data get scrambled.

I would consider (1) and (2) table stakes.  If you don't have these,
potential customers are not going to take the file system seriously,
and no talk/presentation at any conference, whether it's LSF/MM or LPC
or OSS is going to change that.

> And this is why I would like to attract attention to NILFS2.  LFS/MM/BPF
> is really good stage for this. And also it is the way to send a signal to third
> audience (potential customers) that NILFS2 is not dead....  We need
> to rebuild the NILFS2 community, but it requires of creating some noise. 

So I'm going to disagree with you here.  Noise/attention is not what
you need.  What you need is a business case for why a company should
assign engineers to work on nilfs2.  I can't think of a single major
file system in Linux is which has all of its development done by
volunteer hobbyists.

So it's not noise that you need; you need to convince managers and
executives at various companies why they should invest in nilfs2.  And
for the most part, the people who make the final decisions on things
like Fall Plan (in the case of IBM), or OKR's (in the case of
companies like Intel, Google, and Facebook) tend not be well
represented at LSF/MM.   :-)

Cheers,

						- Ted
