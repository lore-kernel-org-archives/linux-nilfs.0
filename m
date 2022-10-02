From: Khalid Masum <khalid.masum.92-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [syzbot] KASAN: use-after-free Read in nilfs_segctor_confirm
Date: Sun, 2 Oct 2022 15:25:21 +0600
Message-ID: <3b7a3398-0826-04de-f805-c926b39e7d35@gmail.com>
Reply-To: 000000000000219dcd05e9f95ed9-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:reply-to:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=RS87/OMI0Aoi7/wAWBy+a2IoLMxK46Hso1++35Znhl4=;
        b=Xd9E8KCVc+gQe+SAizBHsD8rOuIuiI5Yl4lsFTaYIKrY+E/HLGZpHAWZTKH3d7RVv+
         /85plcy6Sy5cSCW8iY5Q0VUUUH1eZpSbwf+kLgwzvy22I0c41oZMjxph4TdL/Zdg6rab
         yWwOrlRlAsVkRDgQXU06kxdbVrKsnockFt4uQs31BM5vgnSPaxRMXwGUlVHeqvnnsdqW
         DKb4VGfN3bAvOEyi2Z/15MmdZDTVa8mhtbcXCWrmpNxqwhbcCNe2WbLyqBKwAJFhwVE0
         1PSOtInKf7SwWBVXsBh/d5QXfysYZEY2zZ+p6GSb9oKnDvnndz4MxNslV4PagqkgQUQM
         xeJA==
Content-Language: en-US
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, syzbot <syzbot+b8c672b0e22615c80fe0-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>

Hi all,

The reproducer triggers the same bug in upstream 6.0-rc7 as well.


Thanks,

 =C2=A0 -- Khalid Masum

