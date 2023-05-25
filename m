From: Frank Schwidom <schwidom-hi6Y0CQ0nG0@public.gmane.org>
Subject: Is it possible to restore the state of a nilfs2 partition after
 deleting files?
Date: Thu, 25 May 2023 17:18:38 +0200
Message-ID: <20230525151838.GA5174@debian64>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
 s=s31663417; t=1685029003; x=1685633803; i=schwidom-hi6Y0CQ0nG0@public.gmane.org;
 bh=l1HpxwgYBwJMik7MEg3PiDhT6iVJvQDPw/OFM6Zsphk=;
 h=X-UI-Sender-Class:Date:From:To:Subject;
 b=WC/Ek5VQJh2NjxYpiOn2m/lGnN795oTU16lG0POh2oeCpJf5WQZ04YQJIozuQ5AQxWKCeLX
 hFl5hhBKZexR6SpIZCZASiewq9ytZwfwPfSAOkgf11gNwRfh4REqEu9E5uby7gAyAGsnPrC+h
 MHrDgFVp43whi1foB0KY0FT2jyqvJZsovm26V66jwRj4+4s9WVRaLVG146qETVbO/mNWsAjcs
 Fd2+XaYtDo+BBAbLyzQGKLwJ4Y0tZXjle0zEPm3l8ahpp8jsxdesik06C4knFsA9iXp7vBU7+
 Qwzj8nld2lOYsK1f9gHzhoRXC6BdJYp5fqp/8kzYXzLA+mjciolA==
Content-Disposition: inline
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

is it anyhow possible to set the state of a nilfs2 partition to the latest
checkpoint or snapshot?

(I am using nilfs-tools 2.2.7-1 on
Linux debian64 5.10.0-0.deb10.16-amd64 #1 SMP Debian 5.10.127-2~bpo10+1 (2=
022-07-28) x86_64 GNU/Linux)

Thanks in advance,
Frank
