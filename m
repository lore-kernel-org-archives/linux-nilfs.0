Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F4E314D06
	for <linux-nilfs@vger.kernel.org>; Sat, 19 Sep 2026 03:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789786893; cv=none; b=DE/rpayNzDTMn3B7kfZYeGgT3snGDmkVRPGv8DHmljywFoNJarQT/Wz8dbnJbVWP6ndpFc7zj35j2Bxa0WNUn29NbGHymuD16QFLqoGwelDOSi0BKpYGgdNxloo2CMZmZlv/tT2Ru7wPkD3ZL0mjQe1ITgOxr1B9fFDI/o6aFbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789786893; c=relaxed/simple;
	bh=Z3xfdok/MjLW7iYsOLwOg962uzXBF28qhYl9orh4Ijs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lr2/GkozznwSqjZ+ZghnLb20hmmJ/RfvHkwm+Ru5rjrTab/T27/QKjvFPYB+aqcS3l19FhBrmOhs9esb5hwPhffNsv0ipJWAl10x33+ywkXIodwpSiy1TkiaFUyYdx6lsznqiT7rYMsxT+S7KU3bgFw9LmwGdSQJVFB3lAVuvBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=pUfzyrIA; arc=none smtp.client-ip=74.125.224.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="pUfzyrIA"
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85d43ac6090so12398257b3.2
        for <linux-nilfs@vger.kernel.org>; Fri, 18 Sep 2026 20:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1789786891; x=1790391691; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z3xfdok/MjLW7iYsOLwOg962uzXBF28qhYl9orh4Ijs=;
        b=pUfzyrIA9GpnzJQxw5erLIqQh8rgUg+6ktNEDIzL5YK9f9uxGB5/XD9bZAAVDXswsk
         jl+mii9EtEmaq4qU++UaqbE7UQ6Hui9jLb8ekcFA8M6X/nfGqkR0wEcBzkxiVYFXwUWA
         RnyZ7mx7sP6N15LVwNv96zlk7oi0e+e39JDXHwEDff7Jlt5pCAW/lb6ZYNBwdbZG67Ox
         +y4ZH9J+hQSJyV5N1pmLZZhk6upzF3m/B86IAFJs66HOMEVlp4I01JtybkpXXzZI0Yaf
         KWmelOW2aDDSCWp/j1dqZE6jqP6gv99Ikll5dVoowGlBWpuUrfg/qBs9CcpfbK1ONjrU
         ymYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789786891; x=1790391691;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Z3xfdok/MjLW7iYsOLwOg962uzXBF28qhYl9orh4Ijs=;
        b=l89xZB3LuvG/yhT9HFSRHHCg3URuSd9POFCenqo3ViKnGZnZQDCi/egyMvxs96dMuw
         2leBg6MzvU2pqw3w1pa1b+wixRNk7GwtItsQzc/Y57HZQ8lovjMI2ASvwgbcJOaHZ2o+
         fS/nWke0ZzoBAxA0KJF4lVEg/5A5KLzWa9iJ0xSKeFENaTIVGn7MlefAVd7pu793QMis
         m+Lwa06Elv6S4EeyxWFmd3Qtg5kMnu8sEwDlq3SinxQWQItPXNiC5eMpKNej4QwzhlVz
         AwT/+oWfywL8sVFEAnbWDZ5Zc3Bgvih/hxpsoJ2SOBGk9ihakChiNtDLD09KxlVIAL6r
         0F+Q==
X-Forwarded-Encrypted: i=1; AKwUvBy7co1jXrcqafauVuBSUizaI50SZkEaD7OZV1HNliJPq8K+KjlK19/SFsIb1kuZk9gJvyO21yUGxgtXHw==@vger.kernel.org
X-Gm-Message-State: AFuF++m3+36lEx1AoMHetaPOpJs6VwwNWEs9c4JYrRJcWwL63DX1w2cT
	mD6VGEoS04qm87qIwDYK3VC12ItUUHcA34zAo/UM9LzTFjamqnm1KkKg8TnobUVzGw8=
X-Gm-Gg: AYBFou31z4GFtwBPraxibhzwMLF54gbnQ8Z+FUo0CT1bHUgG1o+p+arZWlh6qBAAovh
	v8Ip5CAebbQiNtboM/luIkKt/bwE+YwvJXKQp5PQ2N6ZfQoHPtc5wFrYZfyfGbozXBFFMGLQi+e
	vkfPg+f6h1lEbAFdM2hegfWqLjaCfAW+Ga13tCwj0PIwXwv3W8DeWEDX8vhEW695v/N72vStjTI
	4H0nkitCPlKQOvb6fM4KxxonJff9DPtDk8UGeS/1iSmOHMc/EQ63nD5fWPXZ+in29xm3eL3+DFG
	mrM+D8BkgVS70YdUz70dSNvWXBKZ+3qQzb4Ux06faqajLLYcERZmv3+uG5hQ3tASeM3tipXh9Yp
	NJ/hibMznVWHrEnH4ZEaXONnZZJDQXemlQ83tMW2mZ1jhiF1UZID4s1ch8gTg6Hr+P0+h2BWB9C
	PWKN0C33qbKVHzVzWNXVJ/dnKou2XR+Z9HMZoc9iiX5izk3QNt73UCi4jXWO+A0OOA7owa3qnHP
	oXOmgWu/wITESBJPWKE4JReLKQMH6rDVbRWHztUeYXgT1mJlnczjH/LBa48f8UIxwImbcqePoWK
	2EeOEwbYMU5zVX1k+BJy0u005s6gLReXSXWtzBodO1J+/NX3eQJYf6DKuHNnZYF8ZnP2LJx6sAg
	=
X-Received: by 2002:a05:690c:a5d8:b0:87d:8d6f:b579 with SMTP id 00721157ae682-897353aba4dmr10924147b3.40.1789786890894;
        Fri, 18 Sep 2026 20:01:30 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:bcb1:f9f4:6193:b412? ([2600:1700:6476:1430:bcb1:f9f4:6193:b412])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a46e47e87sm5729537b3.23.2026.09.18.20.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 20:01:28 -0700 (PDT)
Message-ID: <2f638ff0568a55233899b2a7ef4dba3ed945bc51.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: validate file block counts during recovery
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Aldo Ariel Panzardo <qwe.aldo@gmail.com>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Fri, 18 Sep 2026 20:01:26 -0700
In-Reply-To: <CAKFNMo=0-rxN0BKG1v+KhrGwnh2ZL_Hn2Jbcqc9sWRV8cwxPrQ@mail.gmail.com>
References: <20260915111351.2726334-1-qwe.aldo@gmail.com>
	 <CAKFNMo=0hDANOd+DxxvKA=RNbiG-zygkWh6EUC6Vr2MYe4npLQ@mail.gmail.com>
	 <e197037b70377be78b296380bcb31b8c3e8f8d74.camel@dubeyko.com>
	 <CAKFNMo=0-rxN0BKG1v+KhrGwnh2ZL_Hn2Jbcqc9sWRV8cwxPrQ@mail.gmail.com>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2026-09-19 at 09:46 +0900, Ryusuke Konishi wrote:
> On Sat, Sep 19, 2026 at 4:33=E2=80=AFAM Viacheslav Dubeyko wrote:
> >=20
> > On Sat, 2026-09-19 at 00:44 +0900, Ryusuke Konishi wrote:
> > > Also, please replace the 'Cc: stable' tag with the following tag,
> > > as
> > > with the previous patch:
> > >=20
> > > Cc: stable+noautosel@kernel.org=C2=A0# Non-fatal bug fix; defer
> > > backport
> > > until a real issue is reported
> >=20
> > Damn! I missed this request. I already pushed the commit. Are you
> > OK
> > with that? :)
>=20
> Viacheslav,
>=20
> Since we haven't hit the merge window yet, and linux-next (the
> destination where your for-next branch is integrated) is a daily
> integration tree intended to be rebased before being pulled into
> Linus's tree, updating the commit message on your branch now should
> be
> completely fine.
>=20
> As documented in Documentation/maintainer/rebasing-and-merging.rst:
> "Some trees (linux-next being a significant example) are frequently
> rebased by their nature..."
>=20
> I think it would be better to fix the tag and overwrite-push it now
> rather than leaving it as is, though of course it will need to be
> frozen once we hit the merge window (or after the official release).
>=20

Sorry, I have too busy day.

The commit message has been updated and pushed.

Thanks,
Slava.
