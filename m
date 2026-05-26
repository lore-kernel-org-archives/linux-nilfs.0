Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9A5359A6C
	for <linux-nilfs@vger.kernel.org>; Tue, 26 May 2026 15:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779807632; cv=pass; b=nefvJ5kDa+3t3LzSWwl54rsbUYBiKoPoUKgeMG/sMso5/vADdkMjc31/6BAPfA5xRB9B13yEDeYHNbVOhFaChjjzpOehiScuRFGXgBwoDpE0P620ssLij0HiTAbpxxM1fx2rQVn/nyQfuQegz5BNp/v/4VcixRXTrZOYqfx0BJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779807632; c=relaxed/simple;
	bh=EvbsFrM1aOZoE9rzekiebiw0GdV7XyQJiZp1BOpUdEc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gRFB+j/Pp0/277aZdPqPhmg9a+6q1lVgFDUAHXSjzu3bwWtxn5bMyXHdFoFZeOxHrXxVczWHHCLcq6588VTrAbTSKaX37+pPry3KUYtfjEqsi20NbWc8X8WzLq3pzHfwU6fNLjOJ9R7REERSbE7xXpp5SwmD7gpk90Pw1u/Nybw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=qiOyQfLL; arc=pass smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="qiOyQfLL"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-914b03e42b2so578157785a.0
        for <linux-nilfs@vger.kernel.org>; Tue, 26 May 2026 08:00:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779807630; cv=none;
        d=google.com; s=arc-20240605;
        b=jSilDUi66//IXWmxaBUpFel/mGUp5u730iuqFvAqeAfC4Oqfv9qZRKVeCJH74SiFvN
         g9pCKSMUTupIX/gVsfOrZ1KISquyk5ToXLxPjn8sNvlagsB5+gSfP5A+eV5wJi6q68TB
         hflXOlueI/f/dLWgB1vL/SRGyRsb/JT/AtuBblbBb5WFUYbE79eiynyUUXE5rXHL9K7E
         W7atx0qHf6vN2VajzERbh7anRa17z7cfheFPVzl3wR5X5eSUZSxCtGKi9vtbQx4wAlCQ
         7LBvba4ZLhBjGXdD9sZ3DiuULX8VqVokqoHJaVQFzNRNkb1yYxGt6aH2Ho4j8ENw7lXE
         KRAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=EvbsFrM1aOZoE9rzekiebiw0GdV7XyQJiZp1BOpUdEc=;
        fh=3o1fnrUcsuJ/n7O9ev9btqltO7dCo3dVbAtc9DcjbrE=;
        b=dn5oksuZXtFlCmgXpJsjK59pAWUsog9jli5nvj7lJazS7JSQhCWh3CgtEIbZAEGldV
         Uzdda1TDtS3ShccGcJt6JUzgnNzjxQFYPPxJk0gWd3Y6elyNFCj3GqwFiecZ2BRiVkPm
         rIssPXzyqyoBq5NWyNTnn+lBwR3z6ZC/s6psZkU7F+lQn6bb8JVDtVFDYONilIE9/jsr
         Tdmxhq3BQowi5C3DcURYaV0Ix/Mskz3dLDdrMqu92FozOaw4D7/MjCYqNifmN97urWyM
         IxF99Qc30uf2fvyneM4T4ugHwEoaU4TwidPFMcxhw88lrEPj+C4DaICVfNXHMvvciDkS
         ej9w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1779807630; x=1780412430; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EvbsFrM1aOZoE9rzekiebiw0GdV7XyQJiZp1BOpUdEc=;
        b=qiOyQfLLvQKJQFdrg3X39/qFxhQHanjRG5XN5rjdJEvvjA020GwKXMmdrbnlt+srAm
         UBvtGirlVxglxkarVFuxih4HyPPjLQOuRQUGmCiEzbu8g/MnqNor84FZTx8p3RvwT3jY
         jRMhAi6WnwmIQlszTYbGFpmfuSBdcQyEyt8Vs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779807630; x=1780412430;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EvbsFrM1aOZoE9rzekiebiw0GdV7XyQJiZp1BOpUdEc=;
        b=DnAddXR2S21L1nVi7EKgXyDVL1AixS8tLBz9wgROgXGo0iVB2OTWq7qkZXi/6u5TC/
         XOELTwTJ850HWOqJCbmp5heVXg57TQi835d+FSjCicP6LMGcTkVvAHOEuauoAF7N2tyR
         lIGDQKJje/2JGBnzhYJk5+VlsnQvsen5Nn4KO61of/v568ef4UDHYkwq7uAaXFMH574B
         7Z54Dk2YtECKTtaTiR8KHrEdWqE9M6EYfNSJJYyZ45v6s/Dl4RTml9kgpYuyZFaePtN9
         UI8P6sIaKI8pTkFrxiB3uEhk6E1Thx11AmUvavzf+MPTGrshjWFuxR8P2ZNp+rcRogNp
         PUww==
X-Forwarded-Encrypted: i=1; AFNElJ+Czi2Scdr96iJsSDoGtR7rxSgpDEAjIBpwzUt2hk5w9a2RCfSxwmmNFBHp7qyeokHa3T8orW50FBWCBg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZiy+bOkr2aOmiHxd/dUspWAuGGAO8vrthn8oOlYVvE/1R6Dy6
	7bw2ECn2d37VECyDN4q7wn+eLYijGHwXyQrwu8pLfOZhDZ3qyHhixhteNrcDjy7PtLeE+nlBEKx
	vtZCNYjk0jOsR7FEZ828KXYtOnIMzftL0VmskQu7+1w==
X-Gm-Gg: Acq92OF/OGTVK1vBauH9XGD2oVxvG8bKxH0n+zzGp793lhI7mYwFrxeZSInM0sbQ7Ag
	3Hj6PMwVbDVmg1YClrPrpdvU6uGfmY7KptizHXr37sr1WcrsXQqxh2JwOG/NiSsN8vikM/tKufb
	1ulGaPw1V3FRgZLFlcvtk5GDW+Furzg5pRfedfn37cDbijpXVry7yCFzpVREuUc7K8zESIyGKHr
	ni3uGHPSOGxBD6PI6mSl29Kw2+qEkSYtIRQN1V+Xk2jHojRFnfcbE9mGk7JTs/hZAM3u6ZJLmde
	3orGtHmLChrnDR1nauz5zUM60ysR+InyRLqk4omwcaIWYkWgZg==
X-Received: by 2002:a05:620a:2a14:b0:90c:e5b5:65f4 with SMTP id
 af79cd13be357-914b48b5d36mr2776455585a.2.1779807620596; Tue, 26 May 2026
 08:00:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org> <20260523-b4-fs-v1-12-275e36a83f0e@kernel.org>
In-Reply-To: <20260523-b4-fs-v1-12-275e36a83f0e@kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 26 May 2026 17:00:09 +0200
X-Gm-Features: AVHnY4KilITCIvGtFxS6FTciw1vCUm1AhcuYlYRxf5FBmn1jF7w4ka-Ynpxrnvc
Message-ID: <CAJfpeguR8uzC+GdyYfby1LS+HyB=p7=ri3J4aAmUFfZ2V06+1Q@mail.gmail.com>
Subject: Re: [PATCH 12/17] fuse: replace __get_free_page() with kmalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dave Kleikamp <shaggy@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 23 May 2026 at 19:56, Mike Rapoport (Microsoft) <rppt@kernel.org> wrote:
>
> fuse_do_ioctl allocates memory for struct iov array using
> __get_free_page().
>
> kmalloc() is a better API for such use and it also provides better
> scalability and more debugging possibilities.
>
> Replace use of __get_free_page() with kmalloc().
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>

Thanks,
Miklos
