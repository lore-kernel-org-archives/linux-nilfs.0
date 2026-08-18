Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9733DDAFA;
	Tue, 18 Aug 2026 03:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787025498; cv=none; b=notwNEVkP5BjnjmyJyG0pYi4CePCvNaCN/7beC7IT3gASpvjHPGKyu2M4IdcV1kzopEWqYBAw9dCnoJkDp15uxgeopLAHsccJK2F5JW/zmi6tMSJ+wk/an3KGruHI/R69SRX+rzdtku1gMCxkz74NUsYrGFysAvx8zB/BRCeGxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787025498; c=relaxed/simple;
	bh=8YnDrjfPVnTMgAKYXO8dGS/BjXJFqAroPRqhR0Gn0P0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Hck4w7C0cKqeANRDq1JJUGUvFr5eDsj4lEqcsgX456aWqI3NPYIeSzsKD7sqU78IGom/8zl3VSQIxOpOSJ2es4avhc4ITva52RVbcXkr7mmEg5fCDaLMAOZGoZyr6HAjIuHZal22yQmSZNJMvPc1gTR13hpJcMZdS9JYgAVizjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VmDg4FnW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VmDg4FnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA8D1F00A3D;
	Tue, 18 Aug 2026 03:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787025496;
	bh=D48KkSSxkrjHArtNrpeRU6Hq9/GKn9yhZl9oUUn4Y9M=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=VmDg4FnWbdohvZv3twYnBVrJ2KD1qAT/d7BbEN6+6b/Rd6IbWvU3SKYQ8cJ/9CtQV
	 IuixO1ft0MFBKR254Lvj8XmAg3V1SStqQFOYXjOZwdvFl8ud0uJyHjilvy+22kLbYX
	 eOZrd/ePzMZRv7eT3diFca8bhVYg5SaZi+lhgaKUsLQQhEZNbznbAKByQVsJmFhU/d
	 RCECkG9wsmb7szQAmqmuFDGe5Le6Z5g16f2ciDc3/tfxubopok5msWOaFDwSlt5wJj
	 sNMfWsd7T3BxRVB/goztNC7FvitFEr5Eaz+0QWQ+gcT5vDklABdcDcbgsDS0g1I4Kh
	 IbyUFS8gZzdIA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D08B73926381;
	Tue, 18 Aug 2026 03:57:29 +0000 (UTC)
Subject: Re: [GIT PULL] nilfs2 changes for 7.3-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <08b17180a30dfba73925ad1232efc92eeab6e2de.camel@dubeyko.com>
References: <08b17180a30dfba73925ad1232efc92eeab6e2de.camel@dubeyko.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <08b17180a30dfba73925ad1232efc92eeab6e2de.camel@dubeyko.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vdubeyko/nilfs2.git tags/nilfs2-v7.3-tag1
X-PR-Tracked-Commit-Id: 24a098541a765ed017274f8094004404a83b0daf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 63c070cba0c6a586d33730ddbf63065cf28276b7
Message-Id: <178702544848.1862718.11009053215716225812.pr-tracker-bot@kernel.org>
Date: Tue, 18 Aug 2026 03:57:28 +0000
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: torvalds@linux-foundation.org, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, konishi.ryusuke@gmail.com, vdubeyko@coreweave.com, joshua.crofts1@gmail.com, manojkm24dev@gmail.com, david.lee@trailofbits.com, igorpetindev@gmail.com, wangjianjian3@huawei.com
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 17 Aug 2026 14:30:20 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/vdubeyko/nilfs2.git tags/nilfs2-v7.3-tag1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/63c070cba0c6a586d33730ddbf63065cf28276b7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
