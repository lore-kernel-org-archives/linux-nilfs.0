From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: nilfs2: Fix reference count leak in
 nilfs_sysfs_create_snapshot_group()
Date: Fri, 29 May 2020 06:51:42 +0200
Message-ID: <b4e9eb17-7c5a-15ed-5ff7-2334ff13e9d7@web.de>
References: <30cf7534-b62e-84b1-571a-945aaffac5b0@web.de>
 <CAMV6ehE3jm4ZasYqd12f=e0TNN_kfiX7yCMVHkmESKP0WbuqTw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590727910;
        bh=9s8HVWZnrNlsYF4NgOgs7U6BwK85FTelc8UkaeUj92U=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=He3pHNuw73/ydGfKjr8y1sAUq7NpqVU80PSxusgCAC5qE9qIGvAjHvmC9Kn7SAOUk
         3yriIoWdsg6CQxyfr61+EKjX1Gh8I5l8ORnk8BYOgUpDiSkOQqGR4ISzGUvpRRnEJU
         0E02a+h0o3/qhJoLo9WIfP5GX7Oj0+DE5PR+GQg8=
In-Reply-To: <CAMV6ehE3jm4ZasYqd12f=e0TNN_kfiX7yCMVHkmESKP0WbuqTw@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Qiushi Wu <wu000273@umn.edu>, linux-nilfs@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kangjie Lu <kjlu@umn.edu>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>

> I think there is only one object that can be modified in this function,

Such a view can be reasonable.


> so I didn't mention it.

I suggest to reconsider the conclusion.


>> I guess that an imperative wording is preferred also for this change de=
scription.
>
> This sentence is referenced from the code comment, so I haven't change i=
t.
> https://elixir.bootlin.com/linux/v5.7-rc7/source/lib/kobject.c#L459

I find that that there are further possibilities to consider for improveme=
nts
around the presented commit message (even after the mentioned copy
from the function description of this programming interface).


>> How do you think about to combine this update step together with
>> =E2=80=9Cnilfs2: Fix reference count leak in nilfs_sysfs_create_device_=
group=E2=80=9D
>> into a small patch series?
>
> I'd like to improve the similar issues after I reporting this bunch of b=
ugs.

Did you find questionable implementation details with the help of an evolv=
ing
source code analysis tool?

Regards,
Markus
