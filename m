From: Seiji Kihara <kihara-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [ANNOUNCE] NILFS utils 2.0.20 released
Date: Sat, 2 Oct 2010 13:29:14 +0900
Message-ID: <AANLkTi=xjxbfDgSqHkfqKbiuR_Qbw_cC5FtwAD=NgBhQ@mail.gmail.com>
References: <20100926.183145.212708874.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:sender:received
         :in-reply-to:references:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        bh=Bz3xuJ5V7yU+MCA+yq/9/DCPl+NxkcqDsyIoTdkXabc=;
        b=goXpLabjEUdcpK7b7VHKyuvO9MS4Fd8z9YE3m6APpTMGqsSeyHN20dSywXQLUM9eIc
         vfihIR4imWwHrnVbFAmI8bSL0TfbppZHg9RIx43qCh8yi8vJ7mDviWI1Si+GnO4mg55y
         8OFLnc9ICFkkBNnkh/yy0awiC8/XQr3lhTH1o=
In-Reply-To: <20100926.183145.212708874.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

RPMs of nilfs-utils-2.0.20 for RHEL/CentOS 5 are now available at nilfs=
=2Eorg.
Enjoy!

Seiji Kihara

2010/9/26 Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>:
> Hi folks,
>
> I made a release of nilfs-utils (nilfs-utils-2.0.20) today.
> It's available at
>
> =A0http://www.nilfs.org/en/download.html
>
> This release contains "nilfs-tune" which allows modifying filesystem
> parameters including label, uuid, and so on.
>
> Recently, We had a discussion about changing the license of library t=
o
> LGPLv2 from GPLv2, but it's not included yet.
>
> See the changelog ( http://www.nilfs.org/download/ChangeLog-utils-v2 =
)
> for details.
>
> Thanks,
> Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
