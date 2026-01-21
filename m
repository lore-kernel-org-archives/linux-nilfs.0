Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906DE407580
	for <linux-nilfs@vger.kernel.org>; Wed, 21 Jan 2026 11:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768996126; cv=pass; b=O87pFY8rp6In4Ll7m7LKfFdIstaUaeXIzK03UYmoAGv/eR2B7ORbf41ltCcrr7euNX1njTGxfWRNFSuqVeuCnbpxE8bXPyDjj8LZAR4rnl4wWw6U+lunHIjahTDk1rehggH+rtRYE7Jkv5iCwQlm6DcSfmsDeEwUVctlRmFpCdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768996126; c=relaxed/simple;
	bh=RED0ZlcE4hEDXfWMXSCaN1Oarv/RJLuLbiRMuOFjC/g=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=qQGV4Ah5hsEQ+z8R2KKqkAAnCzqWkCIy1PNGVi8CjOmCV6gSfxIgxgdrapsTuI9wxDqgqkiEGTz+J7e3MAnuIVOewW4Y8X8cMPyQ+yzhIZV9va93ubx6wKxJReL7rYh4NT8evLSDBlsQnKYjCkZjRbLWjwwiDI1IpGXcpS92w+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gwA2pGXa; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gwA2pGXa"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b86f3e88d4dso1125141766b.0
        for <linux-nilfs@vger.kernel.org>; Wed, 21 Jan 2026 03:48:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768996123; cv=none;
        d=google.com; s=arc-20240605;
        b=Z/wTev+if6rsqiGO3+nKTzhyX0LWSKg2R1sLFNMLAE0nYRcZ/BD6GGg6WEG/wbu8Ah
         AreoE/6X7/MUeiD/WUw5t7oSPQz8Sa9zBCYB6sSOjxbtuL92yQgt/almDAWAb4Z7q9Fi
         div3trUGUUOy57NSxGvwazOAQecdiiSnuqy3fNYo+dg0lpZj3PwYVFFURAbtsvEpT3aa
         N3XF16q2yY9Q5+8wsbi84GUE7BCqI3Y4Nm3tPFmLrsDXxMAtFzBGOGMCQXjPWvNvz8lv
         X8FD2Jj0VgPu2d37dZZikRx081AkxvGAVkTvSfDMNxy05Qr1chqX9ZbUDjl6pyo7a1o3
         36qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:reply-to:from:mime-version
         :dkim-signature;
        bh=RED0ZlcE4hEDXfWMXSCaN1Oarv/RJLuLbiRMuOFjC/g=;
        fh=Afbqn6eya/G+dOUTlJ1LpDbmd7FU0jRH4DaWLsAvfgU=;
        b=UN2AjFjcmVS24wkyKwBnqqk1SiwaZ23BdfYYxaNJ048byVJXqvoIty1qRCnj+JeBJB
         BzBxe/C1KviiUIC+9fOiKi38wWyZX1iyoaxnen1Jg17jupPXVGHGClQASfHDA+JWg7Mq
         pqcf55H4ED+jNvTKvrQf7iFpwM+O/Yd7vVbhCzRR5f+9o0tSRdcG7nnXg+OeM+nbDzpw
         7bhpSsWksTFSJYgxU2rVDFHx4TkDWMX2UUUivS9lhhhegTY3Ubw5FQqZcpFVAq8MISSg
         t2d4bGDQXllubI9g2H8xFRKs03ybk+rdaytxiBJzDOdCMSkIbxwAdDc8f5A1Vag6YcYn
         R2JA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768996123; x=1769600923; darn=vger.kernel.org;
        h=to:subject:message-id:date:reply-to:from:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RED0ZlcE4hEDXfWMXSCaN1Oarv/RJLuLbiRMuOFjC/g=;
        b=gwA2pGXaDb9Wpo0Y3xrdm3XBYWa9eRKYlK0Ja8UaXIdgICIDMOlSDAUNXsK8VwXYlR
         yfpY/5S2CLbQ6yAFd7u5xwdivCt4SanuK5SjKnGIQFybBjeYDuHS3iJbuCdPwS+KMLAB
         IE+dAX7WMYq8cx8A8ccWdltLuD0KlENFZONqtO5Nlhtz1qg8lJ+/Q0x4sqBIvONC6+XP
         y4F34zFr8SgIPnTckcbBuQkpBfo/UYBCSfuxOKQKgjLTX+AS+vEAvM4NwdnxCIKxacRP
         9XhGVGDjBoBfYMZPPIISgnrApHbi+VlS+zGzWIYlbaseyRbabHOqsGEoLd3n30p+98Iv
         +xXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768996123; x=1769600923;
        h=to:subject:message-id:date:reply-to:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RED0ZlcE4hEDXfWMXSCaN1Oarv/RJLuLbiRMuOFjC/g=;
        b=fvZIEZKadv5AHEyIGnp0tb2SVbJroueNEr254OtWLrjN4g7XO8S3s3jfQkfBEYXtZ5
         j0g1iJ/x9iE9HcBKRKXcI7hUqn/wx1CXR2GvwfhG7rgkWw79alJgsZc5pClYGofwL5ed
         kZPxn6g8p0Px0uzuIqApbLM2vYXdExPbJePnVpEWMUpVE+bgklDib6zMDPI49xYhzrVv
         LdJf2J7km/PkqMAmzYfGQIWkL8c8aBeEh4keQP796tY0WH1AhLmDqbJXPC9pcdQDBqKt
         e9meZcRAEoiASLFB8bYHXRtv4Q8rEgAqAKeoyx6vbseMCCBcsrSQh19laVH8tRj6kbxs
         bxLg==
X-Gm-Message-State: AOJu0YzCdmL4SZD4QeZREFYxOStK+yCTGCufS3zovOKfVVwsNSiXk/QK
	h8GfJCbY3qtmNfLv5/R6fbuXDLHjE1V+JWTioYHWoXBNfSxh+k2jqdL7mtLgFiFTX5wAwyg+N7a
	Lb6P334RXKanEFuMmSvgFb5Lcd1UE7avFag==
X-Gm-Gg: AZuq6aKYjkxeGoWsr+XWUOmMHJCP6iB13pzwaP9hf/Nf5sF1IcpLM8JvsJOKmcidf9T
	HKlw8lwcjHA3BSv9f3I8BQsxKzSjB6j5sXOylCcQrOCsvIW3mA1BL1YnhwWJiHPNAHcpRpVQgX/
	yn4jRbtUR14s66Q5bnQ6VWIXcgDbq6FH9qLmNQwslkftTgjati4gVqp3IwGcjk8+l73Whk2hqsq
	WjjvfWFBHLqk1jXL2t6bciScsDObVOgYPQ/64LDJ2HPe/LoBNK1rEI9GIJge/772rw0/Q==
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a17:906:ef03:b0:b84:1fc7:944f with SMTP id
 a640c23a62f3a-b8792fc3f1emr1481875366b.45.1768996122584; Wed, 21 Jan 2026
 03:48:42 -0800 (PST)
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 21 Jan 2026 05:48:41 -0600
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 21 Jan 2026 05:48:41 -0600
From: "Linux NILFS <linuxnilfs@gmail.com>" <linuxnilfs@gmail.com>
Reply-To: Linux NILFS <linux-nilfs@vger.kernel.org>
Date: Wed, 21 Jan 2026 05:48:41 -0600
X-Gm-Features: AZwV_Qjw_36MtZdTbtkDeOYN6U16kuTzympuzSlWTrVPJ8RbSkdhAfWkkpGHSgQ
Message-ID: <CAE7Udf-Bs_p8P-wHu4sJhDEU-QSw=Dg_hZmmeULYaQWzJhstOQ@mail.gmail.com>
Subject: NILFS utils 2.2.15 was released
To: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fixed a regression in the chcp command introduced in v2.2.12, along
with documentation updates

from https://nilfs.sourceforge.io/en/download.html#2.2.15-u
