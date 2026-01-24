Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F106B17A309
	for <linux-nilfs@vger.kernel.org>; Sat, 24 Jan 2026 01:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769219228; cv=none; b=Zy9UhMYOXBI7KF3D0Q8wffJvONooXmFuGqFe2+bemx/FsXQz4qjz0IpG0lTTiuakL/rRYjDAxEvM8af8D3q58tkDZ5ppk8yQL2JDn7lG8ZT41E+I3Y6P0SmoM1pgK4spkE2v3dPFAOP6UNiSXJHKLcdq/p4GfAxUvbQWj1UVFp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769219228; c=relaxed/simple;
	bh=y0NvhWFLXq+98kpflMEM8llVFKpYdLD5nvpgayTqbqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZG5Jnk8OfZUU0KPp54c42LaLzqQLC/BF7/HOTlM/zKPTAXuvS4Ewdvd1ZBiQFRrziD1OW8l26Q5XC5rwDNXG9cnBROt9Qu50QAWm8C42FA9S0KkSg3PCSg50Ww8e3xtU2My6UHTEqUToXudH7stgANmjBcXxOr2ISStqJe5yboI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=DQl0aiyh; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="DQl0aiyh"
Received: from macsyma.thunk.org ([193.36.225.251])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 60O1kd8W016618
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Jan 2026 20:46:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1769219206; bh=XdScpqUnVSUlHqO0WX62t5zWNepy398qlpb842alAPQ=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=DQl0aiyh5abU4cBp/KWW7QcsfolC/QxhQHaeWH67tOynkVZyXGAtzk2fNeaf9iRUg
	 EhFqNeLFYw49HeUrpuJ7QSn6DqnSE4v+MWDTpwi9gaiN3OvbaMvErinKUS/CkBz7rA
	 rZyl9SYumgwU5Ak//N91divI1g311QBiUCjA6xzdnzczf6xhrG8TOyhIrcZtsuRKZk
	 Vbpogyr5a0nhJuaKh0h8kWVKND2cbRVk9jEe116sHV/WcwPRunwgs25M9m+vrKf1LD
	 vA5MK4BAXk5gDfoRT9QJOL3vddqsPET++W5FnlFa+dEEa89u0la7z62meJbyPMUyHm
	 4b3+CWdTxNOFA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 1CEF355EB1F2; Fri, 23 Jan 2026 15:46:38 -1000 (HST)
Date: Fri, 23 Jan 2026 15:46:38 -1000
From: "Theodore Tso" <tytso@mit.edu>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "konishi.ryusuke@gmail.com" <konishi.ryusuke@gmail.com>,
        "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
        "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "slava@dubeyko.com" <slava@dubeyko.com>
Subject: Re: [LSF/MM/BPF TOPIC] Is it time of refreshing interest to NILFS2
 file system?
Message-ID: <20260124014638.GH19954@macsyma.local>
References: <8e6c3a70db8b216ab3e9aba1a485de8e6e9db23d.camel@ibm.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e6c3a70db8b216ab3e9aba1a485de8e6e9db23d.camel@ibm.com>

On Fri, Jan 23, 2026 at 11:15:08PM +0000, Viacheslav Dubeyko wrote:
> 
> Fresh Linux kernel guys always ask how they can contribute to Linux kernel and
> many guys are considering the file system direction. NILFS2 is viable direction
> with plenty opportunities for optimizations and new features implementation. I
> would like to deliver this talk with the goals of: (1) encouraging fresh Linux
> kernel developers of joining to contribution into NILFS2, and (2) convincing
> open-source community to revive the interest to NILFS2. I believe that NILFS2
> deserves the second life in the world of QLC NAND flash and AI/ML workloads.
> NILFS2 is part of Linux ecosystem with unique set of features and it makes sense
> to make it more efficient, secure, and reliable.

I wonder if this might be better fit for the Linux Plumbers
Conference.  The LSF/MM/BPF is workshop is a invite-only workshop
which is focused on discussions, not talks.  If the target of your
talk includes "fresh Linux kernel developers", it is unlikely that
there will be many at the LSF/MM.  They are more likely to be at
Plumbers, which will have roughly an order of magnitude ore attendees.

	  	     	  	     	      - Ted
