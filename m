Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C121B36197D
	for <linux-nilfs@vger.kernel.org>; Sat, 25 Jul 2026 23:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785021142; cv=pass; b=K90Qoz+iPnwGox2jWVhQb+i/X5G0zNi1y4kClEaKAFF2Mi3kDI2eYHMoK3td1TdWQa+QCIlfYEe93K4aOUaeNJVoD2CxKegBvxtRg66n57dKhSRkbTuogW89gOrKnMG3ZMXjpP73ESuEizI98meoAXk6KZk5/cAqkBgZsbi9C/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785021142; c=relaxed/simple;
	bh=DAmD0jE2PK17f+xBvYiMfK6/+xI/1NO02XCtKo3Fu04=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OyPV5pacR4dHtpMAQU8o3YQodHhn7kj0fm+YNIOlpXAnk127/9d2lukbAGOr/b20uG9Xvr7gQLByFnN4nJr1gNuoXctcRH+8k87Hb3oG3atr3vQOm0/yqfp/IM82qm3kxA1BaU9p7sspixdyWpMgVcquF07duz4xj37WaLg95gY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fbtqa0Im; arc=pass smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fbtqa0Im"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5aeb8c19017so1900949e87.0
        for <linux-nilfs@vger.kernel.org>; Sat, 25 Jul 2026 16:12:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785021139; cv=none;
        d=google.com; s=arc-20260327;
        b=lhoINIVHO8BQl/YI3ycRdylECeQpzDCs/pJUprv/gfN8M+PiCRJjfjmKqY12csQB78
         v1+8sm6S2rQgXvx3+Ml4Vy96oEKBiVV3Nmwa8hvTHMb0MR/cJ0YQW1Y7VUigQk5hZVyw
         oe3G1rpTj8/Ye8PDx6EU98UbLSuW34ViDhkiKkEFjeqBpjsrTCB6SCI8Xs8I5tAsP39b
         y/V70H3qJbQ9L7buEmF3wFTYsMKrFa6V7VwDLYXWOxG9URRQqMc1CRWkpJbhV6A09eSL
         1r+D46pSn0CueICOhnHAKcl+zfWk5gOwfQAk05SftGn3spwS2KnpewbxBCvVkO/gI85E
         C3dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lk2bH0i2n8lot2p1pFmjvDciqXml1QGBbKWcb9+sKHI=;
        fh=ECoDiQl4a31jm+8ZJwrr0qIPb5HrSZ/zByADqctFbc4=;
        b=lnFgY1NFRpMCmX4N5URiTW/h2RDINovFzUgYfiK/cJbHYdRUxy3MiycD5rXyzMhiT4
         bGsTK8HwPnVxBm2T0JGBBuX0G21Yj8hDqoVk+4bgEJMS+3w1DHFNhtFHIYzTi6aH2zbM
         aNnumMiyIhqHHwLB01OeBD5YcZeSAQaPtnTXaUSg2qTFnT330/faMmOocrtHQ7UIlNBj
         GHk56Sh5Js/GCxz5RH8wViLuGvskfiI/or60FGkUsX7CDkmaIDDD7IOttn2mkkUflLg6
         zJmbvk4dL/OruGj+BkqraWk8pckiOV6FmGTa2eWrERDI7eBrptHF57I0PZnk4RYbhVA9
         RWew==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785021139; x=1785625939; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lk2bH0i2n8lot2p1pFmjvDciqXml1QGBbKWcb9+sKHI=;
        b=Fbtqa0ImwZXH2c0g9nJEgrcQ7+GrYuuu+oosptTVAYew+Qd2W8ajOhpnCZ39xuyHZj
         1U+oln2wnPJNLLUAUK9h3UEs0+90grj5nxwRxzOZyiSMcJAcWWqZWZKI71O21ZavRYa3
         edoiwFcFRvLSmqpDN7xYzlaV+aOtBlCwX27JNxWpghrZQP4Xrjlj2FsC25OGf6oXCvxW
         dlQZtVkUL11ekR/md78zRCHQ0d4IVK/40Nn252ryCuGSNctm37pUrU/CA+QzGGmCt3iK
         XnTJ8SHUBB45nmsRXk2H9woA1S4p1GxuQyQT1oAiYVhHRBrRyO9WXLIYtNg5GzyFmIYc
         pXdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785021139; x=1785625939;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lk2bH0i2n8lot2p1pFmjvDciqXml1QGBbKWcb9+sKHI=;
        b=IMhe0AKmC2nhUE+mkaJAHwR9Hf9mcXp2QtGjxq+9LO73VxtxE9hEA4KO3CKEInVv3M
         j0I/VVttSSWJVzslGL4SqLKhOuTF5RyQKbVMWdXa+IasQdWikmp5USEKEW3UagJOK13+
         otga6Rv9uRGKvD0KxmiIr/Owm5ujV/76Yid8vnVHrMPWISH320CgVUgRAbJdK/XRfygi
         xjgDjt2Qhy7a67xBUP6/UlTBdZaz/3tF1oqiE3BY5Htjot4inETs5ZeycQ6SXQNm3w4V
         +6h3Bt/b6BZ2++s7mFAspkQ3jFrekVwpJ5dayKX6vh9W8y0FOvclc2kfGaJsZYmrx60C
         wOMg==
X-Forwarded-Encrypted: i=1; AHgh+RoTVIOHAaS08s3SVy9GIsBE+1HMVA2Qnvao5rcWOkWMYjnqq61mnf3JHVs0UDxJslLiZqUy3I4PKIvuDQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwPjznwdqNfKIzzqvPoz1O7AK9xf5Xmw+mYb8BedZq8CqW8+t9s
	5603LA0E/EhCd/ppvce9ND6g5BcXIXQ63xl9smVH7L8CEryHmsi8J8jCMCttrsh0HgesS3vmWka
	alVUitXzaSd7Wa5VrYrB6j+fYiQqNuiA=
X-Gm-Gg: AR+sD1062jlUykRwTlmZaxjX7RmR1Lj0mh52aX/5xME+xUdHFH2crTxGE7wejREtqob
	zMN9pWgqmkbBjMcHxqfTnVmQa1wbxEDDj/ub1fdhKNHEVISN9WyK54jTXJRHp6rooQJNFdlavn0
	jf9Szmt46aFJwFoaAWYcAu+hqg00uT7GyYhJok0q8w0heU72mFfCK1IDpwVTNa/TuTfww5M4GsQ
	yxbgW/IfQi1tWHzg4gReqaCYmgmu1abi7CGznb10WsdzwHzOBHpS9T/NsnxFVzYAfD1QutmaQ==
X-Received: by 2002:a05:6512:159e:b0:5b0:1df9:2adf with SMTP id
 2adb3069b0e04-5b2c1b23c13mr536444e87.28.1785021138444; Sat, 25 Jul 2026
 16:12:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260725100658.1705-1-manojkm24dev@gmail.com>
In-Reply-To: <20260725100658.1705-1-manojkm24dev@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sun, 26 Jul 2026 08:12:02 +0900
X-Gm-Features: AUfX_mxFyNnlo3VPzMH4bN1g0GZY_Ni5XJHOJ1l_LeDcBVAW4ZagKbK1c2UAVdI
Message-ID: <CAKFNMo=zApDzM10dv66TgcKcvJyzWmur=88zRpfK=br_BGY02w@mail.gmail.com>
Subject: Re: [PATCH] Documentation: fix grammar in description of nilfs2
 recovery code
To: Manoj K M <manojkm24dev@gmail.com>, slava@dubeyko.com
Cc: corbet@lwn.net, skhan@linuxfoundation.org, linux-nilfs@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 25, 2026 at 7:07=E2=80=AFPM Manoj K M wrote:
>
> Include the word 'at' to make the sentence grammatically correct
> inside the description for nilfs2 recovery code. This improves
> documentation without changing the original meaning.
>
> Signed-off-by: Manoj K M <manojkm24dev@gmail.com>
> ---
>  Documentation/filesystems/nilfs2.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/filesystems/nilfs2.rst b/Documentation/filesys=
tems/nilfs2.rst
> index e3a5c8977..a0124d22a 100644
> --- a/Documentation/filesystems/nilfs2.rst
> +++ b/Documentation/filesystems/nilfs2.rst
> @@ -252,7 +252,7 @@ The following figure shows a typical organization of =
the logs::
>  To stride over segment boundaries, this sequence of files may be split
>  into multiple logs.  The sequence of logs that should be treated as
>  logically one log, is delimited with flags marked in the segment
> -summary.  The recovery code of nilfs2 looks this boundary information
> +summary.  The recovery code of nilfs2 looks at this boundary information
>  to ensure atomicity of updates.
>
>  The super root block is inserted for every checkpoints.  It includes
> --
> 2.53.0
>

Thank you for the fix!

Viacheslav, could you please pick this up directly into your tree?

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks,
Ryusuke Konishi
