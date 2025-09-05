Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946602D5A01;
	Fri,  5 Sep 2025 10:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757068844; cv=none; b=caB1L3lxOKPcMiv8ZMgo70OkV39ppge2c4YIfRpMYiASr47ED/2aR3GH8Xm6dEUmFT1AUYU+CY/GujkRWhe37KaVRZp7JO71r/LmK2AmLxDo1/2/E7h1nBV6LzHrVnOZerfURS+ModezfEs67M2CLJDdhILkpCS5FCDWg2HsdV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757068844; c=relaxed/simple;
	bh=YPnFae04kmEaLSKaW6TPNrtbixzGYaYsdZPPySmG0qc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=THDGmhz9CTm7LyRIjMBoLelhKqo7Q3Nntx4fEvJvCmZXQ/71YkTB93kq5i6a3fqAz/k0Wb4igqGHx/s5OTiW6WKQeKuSCNPLY/AFVs96X+KK9737zC3osIARfXUsYewqqeUC2tIZcLKWiOtV8kKI0tygsOKBubhDid/u+qUqn4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=DkRn6Ty3; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="DkRn6Ty3"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0C11140E01AC;
	Fri,  5 Sep 2025 10:40:32 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id IRcK1Xg1T4aZ; Fri,  5 Sep 2025 10:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1757068828; bh=fLEKI1Q8UMuAICh1b6LIwWEJhJeBzx8u8e46m94Lu9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DkRn6Ty3nv7zunSzT2yZ3bkmGgGk65pEkyDTNlQpkA+G8Kn5zZ9uGx5nZFHPJF9WV
	 qLTT0IsFJGm6XLiI8ZiSfSNiqkWcIO11POkur9K1h3+rhmuAnTMbuUl51vPaSCTqhS
	 zMDd1R/UUZvBEtvnacwXEjB0YxNEIhS3nuKWXCtn7ZPR34cSGMERZlljygSuHUDWOF
	 Q/RmyjDnpU8JgmoE1ox8ZsJAfYTemfzvW3ow2NiarmlB0lOcbU0VfNA+u5uR532qno
	 LKLa0wBUNTasFE1f12TUgRMUA/yJQobouUvOQ+gMjnJdYubRo1iDTZGWHnbF6VLS01
	 O9BjE8RPs9Y1PIu73R9M8QdWY/1BggaN7/p/hns4k63xnF2ZESy7frGGNJSqUJfzic
	 epVNmG4T9vnkpgx3if/0HGvU0xkiWve2dGDd0H2BHU/xt2kjwU6B3gzdgXHhIEXDc5
	 ceQTukKA7Ai/pf5GM5w+7h0w2fviN5sTtHDr7dhAOtBCs/jQp08LGuI3Ktziyq/kTK
	 swuYdxscdE+iXzkC43sCsWwQ+KTMe+LD+CKl7cT+CI8agI/4j35nfuf8RwPLRA0oMB
	 lyCEDtAh75gKuLObANNw4ZTymh0jSW9UY32TXvBULq5NtZ7bYiKklOWCoQZxun+ZYn
	 62wZorSSZ5e1F9PYy7AfluY0=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 2ACED40E01A2;
	Fri,  5 Sep 2025 10:40:16 +0000 (UTC)
Date: Fri, 5 Sep 2025 12:40:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nathan Chancellor <nathan@kernel.org>
Cc: kernel test robot <oliver.sang@intel.com>,
	Borislav Petkov <bp@kernel.org>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, X86 ML <x86@kernel.org>,
	"Chang S. Bae" <chang.seok.bae@intel.com>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	linux-nilfs@vger.kernel.org
Subject: Re: [PATCH -v1 1/2] x86/microcode: Add microcode= cmdline parsing
Message-ID: <20250905104015.GBaLq-D343jvMEZ2KA@fat_crate.local>
References: <20250820135043.19048-2-bp@kernel.org>
 <202509021646.bc78d9ef-lkp@intel.com>
 <20250904113752.GDaLl6ELJRd3LZYBQl@fat_crate.local>
 <20250904232952.GA875818@ax162>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250904232952.GA875818@ax162>

On Thu, Sep 04, 2025 at 04:29:52PM -0700, Nathan Chancellor wrote:
> Does your QEMU boot via UEFI? This configuration has
> 
>   # CONFIG_EFI is not set
> 
> so if I try to boot QEMU via OVMF, I get:
> 
>   BdsDxe: failed to load Boot0002 "UEFI Non-Block Boot Device" from VenMedia(1428F772-B64A-441E-B8C3-9EBDD7F893C7): Not Found
>   BdsDxe: No bootable option or device was found.
>   BdsDxe: Press any key to enter the Boot Manager Menu.
> 
> Turning on CONFIG_EFI and CONFIG_EFI_STUB is enough for me to boot this
> configuration.

Yeah, I'm blindly following the testing instructions because I'm being
a guinea pig for the testing folks. :-)

Looks like those instructions need massaging.

> Looks like this configuration has
> 
>   CONFIG_LTO_CLANG_FULL=y
> 
> so that's not too surprising :) turning that off or making it
> 
>   CONFIG_LTO_CLANG_THIN=y
> 
> should be much quicker.

Yeah, I hear there might be some more room for improvements in parallelizing
more of the LTO work but I dunno - just rumours :-P

> I ran 200 boots using our simple Buildroot initrd and QEMU wrapper
> script [1] and saw no issues, however...

Yeah, that's a nicely debugged issue - I think you should simply send a proper
patch.

Thanks!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
