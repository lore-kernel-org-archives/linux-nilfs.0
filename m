Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792550192;
	b=3PFE2VzLEIeJ4UUjZsSRmAC4727rzB3G/u/EQhT5nGUajykIA6fdc9IgkzRLk8rTh7/P
	 qeVN8v7YFHts28dGWwvKeMPgJjYTkmWOIeM739zkIeuaxV3sZfdRmH1pas0AXgARzsx2p
	 j+1BPL7B5zyRuRMcDQ0lpVxKBxT+9UL/3EmBBwaDqIykpK539xBbRkhY5zVHJTBVZhE6R
	 nI74Kj3hmWZuRY43PEfIIseIYAOx24pH3cWcj3g6RDK+fwYsubkQgtLsGEz7wK/ICJedz
	 KsbJ6RsgsGDsNe7rQhqDpEsuhgjOwlhO1ubLkwT1nOll24AozBgwGrBBj6ihTpOClMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792550192;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=RF1o8WwgvD6Hs9AE7pD2KU/fd1EOqN0edNZ8gBsE5fE=;
	b=N8dp7snuf2kXLEJ+0FHW4Zn+eldrUSdIlRJZHgBw2iXk0GVwgmub9JjuGpkLGEJcV4bp
	 muyRtbTC//6uc1PeqHE8QPg3wjATa0kciS+vMDNH/Reaa1xKy9fkXbwdS8eW4UTLdXka4
	 yCwgkCRSJP7OM3mV5n4SvxG6EY0RLC7rOHcxMFBpDqUutPEmkDavoukkO6h+IfOHRlV8L
	 elYrTvtU6CNWEvxOvclXLkjoMePiKHJdfN1QvZgMaJ3qfE2UDr+P0dGCW8nxMnMbRUYCY
	 VnjEeq2j1dN3mNMgfOm1z5GNSb4+/Ce5gabg4um33cDn/mIA1lXRlKy1rtkKjn5RYLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IonqBeyy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9A9606A31B;
	Wed, 21 Oct 2026 02:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IonqBeyy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3341F000C9;
	Wed, 21 Oct 2026 02:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792550191;
	bh=RF1o8WwgvD6Hs9AE7pD2KU/fd1EOqN0edNZ8gBsE5fE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=IonqBeyyeSxuf0p3yFJZ0w2eLHLbB83AMXXyKE5Gj6rl+8aIHPk7hlnRWuwADxFWi
	 X/q+C/jJF12SbPYI/SWp+XpKDqmxHKviwQ3HwGQrO0KviInR8x3LzL9bUZU6hlnjow
	 h/Rz0DZJ2O7+tZiEgLIHo18+e/ItXkXg3+/yKSYwUdXo/heuWF2pCsDOz6wZTsKxRZ
	 7aJDYvGwlEDVnPfd7E4Vbj0xkqaDCv2WszORfdt4LGwGLx6d7hgRJvSWVyEYoh/cjo
	 UUxq8oAVwGJ1Xy3d8einjyA1Emm57tEAexnIdM2p73jKU+jUJLTyydNlbfE06V8RL4
	 kY7EAcUAu1DHg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B47273809A18;
	Wed, 21 Oct 2026 02:36:31 +0000 (UTC)
Subject: Re: [GIT PULL] nilfs2 changes for 7.4-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <76ad2d292f0446eeaa22850bbf4a63335b5eff19.camel@dubeyko.com>
References: <76ad2d292f0446eeaa22850bbf4a63335b5eff19.camel@dubeyko.com>
X-PR-Tracked-List-Id: <linux-nilfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <76ad2d292f0446eeaa22850bbf4a63335b5eff19.camel@dubeyko.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vdubeyko/nilfs2.git tags/nilfs2-v7.4-tag1
X-PR-Tracked-Commit-Id: de7f49c12566cc5c7437a2f26c6c754b9d4d5648
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d28fb91dd82aa56359b6de4d6241b7063672a4c0
Message-Id: <179255019022.339009.14782547056377899219.pr-tracker-bot@kernel.org>
Date: Wed, 21 Oct 2026 02:36:30 +0000
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: torvalds@linux-foundation.org, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, konishi.ryusuke@gmail.com, vdubeyko@coreweave.com, qwe.aldo@gmail.com, hemanth.selam@gmail.com, southampton.jake.labelle@gmail.com, r772577952@gmail.com, joshua.crofts1@gmail.com
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Fri, 16 Oct 2026 15:27:29 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/vdubeyko/nilfs2.git tags/nilfs2-v7.4-tag1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d28fb91dd82aa56359b6de4d6241b7063672a4c0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
