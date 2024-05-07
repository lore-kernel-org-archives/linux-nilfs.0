Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3891649D3
	for <linux-nilfs@vger.kernel.org>; Tue,  7 May 2024 16:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715097676; cv=none; b=Be83fgtVEC+LRQMoMOk4RbIi8I5Q93BxWmTcOGIARvTpkc/UiCydcnwNtJ6KZIr+8kvf33oenPiQKu3r02Ta6d5HVtXAvfciWg+1/BankDoA6mXRaX0Q2sNrWqZhrOALXLr9Lpf+rN2ZNiIT8Yl4NBd4m2KqCoi6wogtFoKZFP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715097676; c=relaxed/simple;
	bh=/+qMNlSm54t9lA3tzjqeqkW+FVGImfW2Kj0TDNg4Jb8=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=fxZX/qqclXaeiZUiSUG/fsSnKtC4T0mAqMvqy6S1af7qjKxoRbu4UiXDYPO9F7y9K9fHO1PZA05SJ2dKbGJHep8Eoqq7Y80nYTQz6lz8GMdJdlLyphQd4VyQAfIkfyVlHjgHWjcO0OWS5lcU0MNe0r7fY7Vb6Eqk0CPn9cusJ0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l5U94A51; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l5U94A51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DD4C2BBFC;
	Tue,  7 May 2024 16:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715097676;
	bh=/+qMNlSm54t9lA3tzjqeqkW+FVGImfW2Kj0TDNg4Jb8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=l5U94A518jnF6jF5mTJq6TNc+kG/5+3YoySrMemWEb5F0wVRafbYQ7ysdnqfIELcs
	 1FbZWjZIFKGF2wpySUbn9dDJeR08HSOQvYNc5z+OsH9nPki/rw1fVgXGNtZNcyTMD7
	 yQJxlza+OVrcNRgYi6zwYmjUaE54fqHfoqQfCP64=
Date: Tue, 7 May 2024 09:01:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>, Rasmus Villemoes
 <linux@rasmusvillemoes.dk>, Linus Torvalds <torvalds@linux-foundation.org>,
 linux-nilfs@vger.kernel.org
Subject: Re: [PATCH] nilfs2: Use __field_struct() for a bitwise field
Message-Id: <20240507090115.50847c51afaa2b1361f170b8@linux-foundation.org>
In-Reply-To: <ae807f93-aba8-407e-a731-4634b2da03f2@acm.org>
References: <20240506232437.21264-1-bvanassche@acm.org>
	<CAKFNMokz-zJu95hu42YVC6P5VJCJq-DStPWHuWpOkHwiq_RduQ@mail.gmail.com>
	<ae807f93-aba8-407e-a731-4634b2da03f2@acm.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 7 May 2024 05:55:27 -0700 Bart Van Assche <bvanassche@acm.org> wrote:

> On 5/6/24 21:10, Ryusuke Konishi wrote:
> > So I'm thinking of having Andrew pick this up instead of my patch
> > currently pending in the mm tree.

Please identify "my patch"?

> (+Andrew)
> 
> The patch Ryusuke is referring to is available here:
> https://lore.kernel.org/linux-nilfs/20240506232437.21264-1-bvanassche@acm.org/
> 

I'm not subscribed to linux-nilfs.  It's good to cc linux-kernel on
everything for this reason.  Resend, please?
