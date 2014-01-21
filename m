From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/5] nilfs-utils: cldconfig add an option to set minimal free blocks
Date: Tue, 21 Jan 2014 15:10:51 +0100
Message-ID: <2891656.vdWYFxplD3@coil>
References: <cover.1390310509.git.andreas.rohner@gmx.net> <22b5b3ac403052d3044dc8c1bebe323191376c03.1390310509.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:user-agent:in-reply-to
         :references:mime-version:content-transfer-encoding:content-type;
        bh=XuqiNCEoasBycbW0jHtF7uO4B5AKc8Ol+KSRvs2ByUg=;
        b=b3uHrws7FL6jkd678A7YNovtXNYXz54S/KRUu8KPXcD3SHUcTi0lHip7jfQHlcvuXG
         xI3bId4diztAJ6nf/FbUoXzbOlaJnTLoTmw9Unx9voFlL/NvYyt9ZpJYoMkEf1Ckg1UE
         0clmx0/0JEFeEemja0zGI2iJnscXfID69MomRjVKYF0CscayeqaMoankQhZY7hzcNCRV
         n/CNEdsKsPA5e2oOMfhRV9+GkZ+l10LLRwP/skiH7k4oxbAfeezUW68bpuCNHRMsCjrW
         5fH6VDSyBuNW00Snpzqts/GfxV/OLtyfjXolAXy4a6I3KsuQ/hUoqSinHHv4O8Eea4Yf
         lHgQ==
In-Reply-To: <22b5b3ac403052d3044dc8c1bebe323191376c03.1390310509.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Hi Andreas,


I like the idea you're introducing; should lessen trashing by GC on my=20
workstations.


On Tuesday 21 of January 2014 14:59:40 you wrote:
> With this option the user can specify the minimal number of free/dead
> blocks before a segment can be cleaned. This is a threshold for the G=
C
> to prevent needless moving of data. If there are less free blocks
> to gain from cleaning a segment than the specified number, the GC wil=
l
> abort and try again with a different segment.


Will your patches be smart enough to re-claim space if the only availab=
le free=20
blocks are under threshold?


Scenario: FS is running out of free space, and the free blocks to be re=
claimed=20
are scattered through segments in small numbers. Several segments have =
a small=20
number of free blocks, but in each segment the amount is under the thre=
shold.=20


Regards,
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
